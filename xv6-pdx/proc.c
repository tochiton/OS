
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "uproc.h"

struct StateLists {
  struct proc * ready[MAX + 1];
  struct proc * free;
  struct proc * sleep;
  struct proc * zombie;
  struct proc * running;
  struct proc * embryo;
};

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  struct StateLists pLists;
  uint PromoteAtTime;
} ptable;

static struct proc *initproc;

int nextpid = 1;

// assert before inserting 
// if wrapper funct then pass all arg plus state of the process

// how to allocate 

// template
// helper functions 

#ifdef CS333_P3P4
static int
removeFromStateList(struct proc** sList, struct proc * p);

static void
assertState(struct proc * p, enum procstate state);

static int
traverseList(struct proc **sList);

static int 
traverseToKill(struct proc **sList, int pid);

static struct proc *
removeFront(struct proc** sList);

static void
insertTail(struct proc** sList, struct proc * p);  //adds at the end

static void
insertAtHead(struct proc** sList, struct proc * p);

static int 
promoteOneLevelUp(struct proc** sList);

static int
updatePriority(struct proc** sList, int pid, int priority);

static int                                        //P4 helper function promote up
promoteOneLevelUpRunSleep(struct proc** sList);

#endif

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  #ifdef CS333_P3P4
    p = removeFront(&ptable.pLists.free);
    if(p != 0){
      assertState(p, UNUSED);
      goto found;
    }
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #endif
  release(&ptable.lock);
  return 0;

found:
  // remove from freeList, assert state, insert in Embryo
  #ifdef CS333_P3P4
    
      p->state = EMBRYO;
      insertAtHead(&ptable.pLists.embryo, p);
   
  #else
   p->state = EMBRYO;              // check this
  #endif

  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4                       //******* check this logic IMPORTant
    acquire(&ptable.lock);
    assertState(p, EMBRYO);
    removeFromStateList(&ptable.pLists.embryo, p);
    p->state = UNUSED;                // should I put it in the else block
    insertAtHead(&ptable.pLists.free, p);
    release(&ptable.lock);
    
    #else
    p->state = UNUSED;               
    #endif

    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->start_ticks = ticks;
  p->cpu_ticks_total =0;
  p->cpu_ticks_in =0;

  p->priority = 0;
  p->budget = BUDGET;

  return p;

}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  ptable.pLists.free = 0;
  for(int i =0; i <= MAX; i++){                  //P4 initialize array list
    ptable.pLists.ready[i] = 0;
  }
  ptable.pLists.sleep = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.running = 0;
  ptable.pLists.zombie = 0;

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;   //P4 initilize ticksToPromote

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    p -> state = UNUSED;
    insertAtHead(&ptable.pLists.free, p);
 }
  release(&ptable.lock);
  #endif

  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  p->parent = p;            // set up parent  -- change it later to zero
  // put flag
  // acquire the lock
  // assert embryo
  // remove 
  // change the state
  // assert new state
  // insert into ready 

  #ifdef CS333_P3P4                             
    acquire(&ptable.lock);
    assertState(p, EMBRYO);
    removeFromStateList(&ptable.pLists.embryo, p);
    p->state = RUNNABLE;                        //P4 insert the first process at ready[0]
    insertTail(&ptable.pLists.ready[0], p);
    release(&ptable.lock);
  #else
    p->state = RUNNABLE;                        
  #endif  
  p->uid = UID;
  p->gid = GID;                                 
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;

  #ifdef CS333_P3P4
    acquire(&ptable.lock);
    assertState(np, EMBRYO);
    removeFromStateList(&ptable.pLists.embryo, np);

    np->state = UNUSED;                         // *** assert and add it back to free list
    insertAtHead(&ptable.pLists.free, np);
    release(&ptable.lock);
  #else
    np->state = UNUSED;                         // *** assert and add it back to free list
  #endif

  return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  np->uid = proc->uid;
  np->gid = proc->gid;                          

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.

 #ifdef CS333_P3P4                          // ****** check this block
    acquire(&ptable.lock);
    assertState(np, EMBRYO);
    removeFromStateList(&ptable.pLists.embryo, np);
    np->state = RUNNABLE;
    insertTail(&ptable.pLists.ready[np -> priority], np);                 //P4 inserting at the priority index
    release(&ptable.lock);
  #else
    acquire(&ptable.lock);
    np->state = RUNNABLE;                   // *** repeat same logic as above  coming from Embryo to runnable
    release(&ptable.lock);
  #endif
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)                 
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;                       
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)                 
        wakeup1(initproc);
    }
  }

  if(removeFromStateList(&ptable.pLists.running, proc)){
  assertState(proc, RUNNING);
  proc -> state = ZOMBIE;
  insertAtHead(&ptable.pLists.zombie, proc);
  }else{
    panic("Removing from the Exit call");
  }
  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
      while(p){
        if(p -> parent == proc){
          havekids = 1;
          pid = p->pid;
          kfree(p->kstack);
          p->kstack = 0;
          freevm(p->pgdir);

          assertState(p, ZOMBIE);
          removeFromStateList(&ptable.pLists.zombie, p);  
          p->state = UNUSED;
          insertAtHead(&ptable.pLists.free, p);
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          p->killed = 0;
          release(&ptable.lock);
          return pid; 
        }else{
          p = p -> next;                         // ****** not sure about this one
      }     
  }

  for(int i =0; i <= MAX; i++){                    //P4 make the call traversing the array list of ready
    if(traverseList(&ptable.pLists.ready[i])){
      havekids = 1;
      break;                                         
    }
  }
  if(traverseList(&ptable.pLists.running)){
    havekids = 1;
  }else if(traverseList(&ptable.pLists.sleep)){
    havekids = 1;
  }else if(traverseList(&ptable.pLists.embryo)){
    havekids =1;
  }  

  // traverse through all the lists except free and zombie and check p -> parent == proc
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
  return 0;  // placeholder
}
#endif

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    //notes grab from the ready list
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->cpu_ticks_in = ticks;
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
//    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
//      if(p->state != RUNNABLE)
//        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.

      if(ticks >= ptable.PromoteAtTime){                          //P4 preparing for promotion
        ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
        for(int i =1; i <= MAX; i++){                  
          promoteOneLevelUp(&ptable.pLists.ready[i]);
        }
        promoteOneLevelUpRunSleep(&ptable.pLists.sleep);
        promoteOneLevelUpRunSleep(&ptable.pLists.running);
      }
      // call with sleep and running list
      for(int i = 0; i <= MAX; i++){
      if(ptable.pLists.ready[i]){
        p = removeFront(&ptable.pLists.ready[i]);                            //P4 *** pending -- removes from the highest priority
        assertState(p, RUNNABLE);

      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->cpu_ticks_in = ticks;

      p->state = RUNNING;
      assertState(p, RUNNING);
      insertAtHead(&ptable.pLists.running, p);

      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
      break;
    }
  }
  
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;                                       //P4 check budget and reset it
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;        // updaates the cpu ticks total
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  #ifdef CS333_P3P4                             // ******* check out this one
    acquire(&ptable.lock);
    assertState(proc, RUNNING);
    removeFromStateList(&ptable.pLists.running, proc);
    proc -> state = RUNNABLE;
    //P4 do logic budget -- either reset it or update
    proc -> budget -= (ticks - proc -> cpu_ticks_in);
    if(proc -> budget <= 0){
      proc -> budget = BUDGET;
      if(proc -> priority < MAX){
        proc -> priority = proc -> priority + 1;
      }
    }
    insertTail(&ptable.pLists.ready[proc -> priority], proc);
    sched();
    release(&ptable.lock);
  #else
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;     // insert at tail remove from runnig and add to runnable:
    sched();
    release(&ptable.lock);
  #endif
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  #ifdef CS333_P3P4                         // ******check it out 
    //acquire(&ptable.lock);
    assertState(proc, RUNNING);
    proc -> chan = chan;
    removeFromStateList(&ptable.pLists.running, proc);
    proc->state = SLEEPING;
    proc -> budget -= (ticks - proc -> cpu_ticks_in);             //P4 demoting 
    if(proc -> budget <= 0){
      proc -> budget = BUDGET;
      if(proc -> priority < MAX){
        proc -> priority = proc -> priority + 1;
      }
    }
    insertAtHead(&ptable.pLists.sleep, proc);
    //release(&ptable.lock);
  #else
  // Go to sleep.
  proc->chan = chan;      // remove it from running list and add it to the sleeping ....add flag first locally
  proc->state = SLEEPING;
  #endif

  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)                   // ****** check it out --- should I hold the lock
{
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;

  while(current){
    if(current -> chan == chan){
      temp = current -> next;
      assertState(current, SLEEPING);
      if(removeFromStateList(&ptable.pLists.sleep, current)){
      current -> state = RUNNABLE;
      assertState(current, RUNNABLE);
      insertTail(&ptable.pLists.ready[current -> priority], current);            //P4 insert proper list
      }else{
        panic("wakeup1 not doing the job");
      }
      current = temp;    
    }else{
      current = current -> next;
    }
  }  
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}


// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)                 //******* move the logic from the helper function here
{
  if(traverseToKill(&ptable.pLists.sleep, pid) == 0)
  return 1;
  if(traverseToKill(&ptable.pLists.zombie, pid) == 0)
  return 1; 
  if(traverseToKill(&ptable.pLists.running, pid) == 0)
  return 1;
  if(traverseToKill(&ptable.pLists.embryo, pid) == 0)
  return 1;
  for(int i =0; i <= MAX; i++){                            //P4 iterate through the array
    if(traverseToKill(&ptable.pLists.ready[i],pid) ==0)
      return 1;
  }

  return -1;  // placeholder
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run",
  [ZOMBIE]    "zombie"
};

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  int time_difference; 
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state]){
      state = states[p->state];
    }	
    else
      state = "???";
      time_difference = ticks - p->start_ticks;
      seconds = (time_difference)/1000;
      time_difference -= seconds * 1000;
      milliseconds = time_difference/100;
      time_difference -= milliseconds *100;
      temp = (time_difference)/10;
      time_difference -= temp * 10; 
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->priority,p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
getprocs(uint max, struct uproc* table){
  int index = 0;      // which is my count of processes at the same time
  struct proc *p;
  
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
      if(p->state == RUNNABLE || p->state == SLEEPING || p->state == RUNNING){
        table[index].pid = p -> pid;
        table[index].uid = p -> uid;
        table[index].gid = p -> gid;
        if(p -> parent == 0)
		      table[index].ppid = p->pid;
	      else 	
        	table[index].ppid = p -> parent -> pid;
        table[index].priority = p -> priority;                  //P4
        table[index].elapsed_ticks = ticks - p -> start_ticks;
        table[index].CPU_total_ticks = p -> cpu_ticks_total;
        safestrcpy(table[index].state, states[p-> state], STRMAX);      
        table[index].size = p -> sz;
        safestrcpy(table[index].name, p-> name, STRMAX);          
        index++; // after 
      }
    }
    release(&ptable.lock);
    return index;    
}

// Project #3 helper functions 

#ifdef CS333_P3P4
static void
assertState(struct proc * p, enum procstate state){
  if( p -> state != state){
    cprintf("Different states: current %s and expected %s\n", states[p-> state], states[state]);
    panic("Panic different states");
  }
}

static int
removeFromStateList(struct proc** sList, struct proc * p){
  struct proc * current; 
  struct proc * previous;
  current = *sList;
  if(current == 0)
    panic("Nothing in sList");

  if(current == p){
    *sList = p -> next;
    p -> next = 0;
    return 1;
  }

  previous = *sList;
  current = current -> next;
 
  while(current){
    if(current == p){
      previous -> next = current -> next;
      current -> next = 0;
      return 1 ;
    }
    previous = current;
    current = current -> next;
  }
  panic("I'm not in the list -- removeFromStateList call");
  return 0;
}


static int
traverseList(struct proc **sList){
    struct proc * current;
    current = *sList;
    //int count = 0;
    while(current){
      if(current -> parent == proc){
        return 1;
      }
      current = current -> next;
    }
    return 0;
}

static int 
traverseToKill(struct proc **sList, int pid){
  struct proc * current;
  current = *sList;

  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
    if(current -> pid == pid){
      current -> killed = 1;
      if(current -> state == SLEEPING){ // assert state sleeping
        removeFromStateList(&ptable.pLists.sleep, current);
        current -> state = RUNNABLE;
        current -> priority = 0;                  //P4 put it to the first priority queue -- it gets out of the system sooner 
        insertTail(&ptable.pLists.ready[current -> priority], current);                  //P4 put it at the same priority level
      }
      release(&ptable.lock);
      return 1;
    }else{
      current = current -> next;
    }
  }
  release(&ptable.lock);
  return -1;
}

static struct proc *
removeFront(struct proc** sList){
  struct proc * temp;
  temp = *sList;
  if(temp == 0)
    return temp;

  *sList = (* sList) -> next;

  return temp;
}

static int                                        //P4 helper function promote up
promoteOneLevelUp(struct proc** sList){
  struct proc * current;
  current = *sList;
  if(current == 0){
    return 0;
  }
  if(current -> priority == 0){
    return 1;
  }
  while(*sList){
    current = removeFront(sList);
    if(current){
      current -> priority = current -> priority - 1;
      insertTail(&ptable.pLists.ready[current -> priority], current);
    }
  }
  return 1;
}

static int                                        //P4 helper function promote up
promoteOneLevelUpRunSleep(struct proc** sList){
  struct proc * current;
  current = *sList;
  if(current == 0){
    return 0;
  }
  while(current){
    if(current -> priority > 0){
      current -> priority = current -> priority - 1;
    }
    current = current -> next;
  }
  return 1;
}

static void
insertTail(struct proc** sList, struct proc * p){
  if(*sList == 0){
    *sList = p;
    (*sList) -> next = 0;
    return;
  }

  struct proc * current;
  current = *sList;

  while(current -> next != 0){
    current = current -> next;
  }
  current -> next = p;
  p -> next = 0;
  return;
}

static void
insertAtHead(struct proc** sList, struct proc * p){
  p->next = *sList;
  *sList = p;
}

#endif

void
printPidReadyList(void){
   struct proc * current;
   acquire(&ptable.lock);
   cprintf("Ready List processes: \n");
   for(int i = 0; i <= MAX; i++){
    current = ptable.pLists.ready[i];
    while(current){
      cprintf("%d: (%d, %d) ->", i, current -> pid, current -> budget);
      current = current -> next;
    }
    cprintf("\n");
  }

    release(&ptable.lock);
}

void
countFreeList(void){
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.free;
    int count = 0;
    while(current){
      count++;
      current = current -> next;
    }
    cprintf("Free List size: %d\n", count);
    release(&ptable.lock);
}

void
printPidSleepList(void){
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.sleep;
    //int count = 0;
    cprintf("Sleep List processes: \n");
    while(current){
      cprintf("%d ->", current -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
}

void
printZombieList(void){
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.zombie;
    //int count = 0;
    cprintf("Zombie List processes: \n");
    while(current){
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
}

#ifdef CS333_P3P4

int
setpriority(int pid, int priority){
  if(priority < 0 || priority > MAX){
    return -1;
  }
  if(updatePriority(&ptable.pLists.sleep, pid, priority) == 1)
    return 0;
  if(updatePriority(&ptable.pLists.running, pid, priority) == 1)
    return 0;
  for(int i = 0; i <=MAX; i++){
    if(updatePriority(&ptable.pLists.ready[i], pid, priority)== 1)
      return 0;
  }

  return -1;
}

static int
updatePriority(struct proc** sList, int pid, int priority){
  struct proc * current;
  current = *sList;


  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
    if(current -> pid == pid){
      if(current -> priority != priority && current -> state == RUNNABLE){
        removeFromStateList(&ptable.pLists.ready[current -> priority], current);
        current -> priority = priority;
        insertTail(&ptable.pLists.ready[current -> priority], current);                           //P4 put it at the same priority level
      }
      current -> priority = priority;
      current -> budget = BUDGET;
      release(&ptable.lock);
      return 1; 
    }
    current = current -> next;
  }
  release(&ptable.lock);
  return -1;  
}

#endif





