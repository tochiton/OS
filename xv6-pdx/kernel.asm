
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 34 39 10 80       	mov    $0x80103934,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 18 93 10 80       	push   $0x80109318
80100042:	68 80 d6 10 80       	push   $0x8010d680
80100047:	e8 03 5c 00 00       	call   80105c4f <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 15 11 80       	mov    0x80111594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 15 11 80       	mov    %eax,0x80111594
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 15 11 80       	mov    $0x80111584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 d6 10 80       	push   $0x8010d680
801000c1:	e8 ab 5b 00 00       	call   80105c71 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 15 11 80       	mov    0x80111594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 d6 10 80       	push   $0x8010d680
8010010c:	e8 c7 5b 00 00       	call   80105cd8 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 d6 10 80       	push   $0x8010d680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 c1 50 00 00       	call   801051ed <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 15 11 80       	mov    0x80111590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 d6 10 80       	push   $0x8010d680
80100188:	e8 4b 5b 00 00       	call   80105cd8 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 1f 93 10 80       	push   $0x8010931f
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 cb 27 00 00       	call   801029b2 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 30 93 10 80       	push   $0x80109330
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 8a 27 00 00       	call   801029b2 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 37 93 10 80       	push   $0x80109337
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 d6 10 80       	push   $0x8010d680
80100255:	e8 17 5a 00 00       	call   80105c71 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 15 11 80       	mov    0x80111594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 c2 50 00 00       	call   80105380 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 d6 10 80       	push   $0x8010d680
801002c9:	e8 0a 5a 00 00       	call   80105cd8 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 c5 10 80       	push   $0x8010c5e0
801003e2:	e8 8a 58 00 00       	call   80105c71 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 3e 93 10 80       	push   $0x8010933e
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 47 93 10 80 	movl   $0x80109347,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 c5 10 80       	push   $0x8010c5e0
8010055b:	e8 78 57 00 00       	call   80105cd8 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 4e 93 10 80       	push   $0x8010934e
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 5d 93 10 80       	push   $0x8010935d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 63 57 00 00       	call   80105d2a <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 5f 93 10 80       	push   $0x8010935f
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 63 93 10 80       	push   $0x80109363
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 97 58 00 00       	call   80105f93 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 ae 57 00 00       	call   80105ed4 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 e3 71 00 00       	call   8010799e <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 d6 71 00 00       	call   8010799e <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 c9 71 00 00       	call   8010799e <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 b9 71 00 00       	call   8010799e <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c = 0; 
801007ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  int doprocdump =0; 
80100806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int printPidList =0; 
8010080d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int doPrintCount = 0; 
80100814:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int doPrintSleepList =0; 
8010081b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int doPrintZombieList = 0;
80100822:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

  acquire(&cons.lock);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100831:	e8 3b 54 00 00       	call   80105c71 <acquire>
80100836:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100839:	e9 9a 01 00 00       	jmp    801009d8 <consoleintr+0x1df>
    switch(c){
8010083e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100841:	83 f8 12             	cmp    $0x12,%eax
80100844:	74 50                	je     80100896 <consoleintr+0x9d>
80100846:	83 f8 12             	cmp    $0x12,%eax
80100849:	7f 18                	jg     80100863 <consoleintr+0x6a>
8010084b:	83 f8 08             	cmp    $0x8,%eax
8010084e:	0f 84 bd 00 00 00    	je     80100911 <consoleintr+0x118>
80100854:	83 f8 10             	cmp    $0x10,%eax
80100857:	74 31                	je     8010088a <consoleintr+0x91>
80100859:	83 f8 06             	cmp    $0x6,%eax
8010085c:	74 44                	je     801008a2 <consoleintr+0xa9>
8010085e:	e9 e3 00 00 00       	jmp    80100946 <consoleintr+0x14d>
80100863:	83 f8 15             	cmp    $0x15,%eax
80100866:	74 7b                	je     801008e3 <consoleintr+0xea>
80100868:	83 f8 15             	cmp    $0x15,%eax
8010086b:	7f 0a                	jg     80100877 <consoleintr+0x7e>
8010086d:	83 f8 13             	cmp    $0x13,%eax
80100870:	74 3c                	je     801008ae <consoleintr+0xb5>
80100872:	e9 cf 00 00 00       	jmp    80100946 <consoleintr+0x14d>
80100877:	83 f8 1a             	cmp    $0x1a,%eax
8010087a:	74 3e                	je     801008ba <consoleintr+0xc1>
8010087c:	83 f8 7f             	cmp    $0x7f,%eax
8010087f:	0f 84 8c 00 00 00    	je     80100911 <consoleintr+0x118>
80100885:	e9 bc 00 00 00       	jmp    80100946 <consoleintr+0x14d>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010088a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100891:	e9 42 01 00 00       	jmp    801009d8 <consoleintr+0x1df>
    case C('R'):  // Process listing.
      printPidList = 1;   
80100896:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;  
8010089d:	e9 36 01 00 00       	jmp    801009d8 <consoleintr+0x1df>
    case C('F'):  // Process listing.
      doPrintCount = 1;   
801008a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break; 
801008a9:	e9 2a 01 00 00       	jmp    801009d8 <consoleintr+0x1df>
    case C('S'):  // Process listing.
      doPrintSleepList = 1;   
801008ae:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
801008b5:	e9 1e 01 00 00       	jmp    801009d8 <consoleintr+0x1df>
    case C('Z'):  // Process listing.
      doPrintZombieList = 1;   
801008ba:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
801008c1:	e9 12 01 00 00       	jmp    801009d8 <consoleintr+0x1df>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008c6:	a1 28 18 11 80       	mov    0x80111828,%eax
801008cb:	83 e8 01             	sub    $0x1,%eax
801008ce:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
801008d3:	83 ec 0c             	sub    $0xc,%esp
801008d6:	68 00 01 00 00       	push   $0x100
801008db:	e8 b2 fe ff ff       	call   80100792 <consputc>
801008e0:	83 c4 10             	add    $0x10,%esp
      break;
    case C('Z'):  // Process listing.
      doPrintZombieList = 1;   
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e3:	8b 15 28 18 11 80    	mov    0x80111828,%edx
801008e9:	a1 24 18 11 80       	mov    0x80111824,%eax
801008ee:	39 c2                	cmp    %eax,%edx
801008f0:	0f 84 e2 00 00 00    	je     801009d8 <consoleintr+0x1df>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f6:	a1 28 18 11 80       	mov    0x80111828,%eax
801008fb:	83 e8 01             	sub    $0x1,%eax
801008fe:	83 e0 7f             	and    $0x7f,%eax
80100901:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
      break;
    case C('Z'):  // Process listing.
      doPrintZombieList = 1;   
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	3c 0a                	cmp    $0xa,%al
8010090a:	75 ba                	jne    801008c6 <consoleintr+0xcd>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010090c:	e9 c7 00 00 00       	jmp    801009d8 <consoleintr+0x1df>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100911:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100917:	a1 24 18 11 80       	mov    0x80111824,%eax
8010091c:	39 c2                	cmp    %eax,%edx
8010091e:	0f 84 b4 00 00 00    	je     801009d8 <consoleintr+0x1df>
        input.e--;
80100924:	a1 28 18 11 80       	mov    0x80111828,%eax
80100929:	83 e8 01             	sub    $0x1,%eax
8010092c:	a3 28 18 11 80       	mov    %eax,0x80111828
        consputc(BACKSPACE);
80100931:	83 ec 0c             	sub    $0xc,%esp
80100934:	68 00 01 00 00       	push   $0x100
80100939:	e8 54 fe ff ff       	call   80100792 <consputc>
8010093e:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100941:	e9 92 00 00 00       	jmp    801009d8 <consoleintr+0x1df>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100946:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010094a:	0f 84 87 00 00 00    	je     801009d7 <consoleintr+0x1de>
80100950:	8b 15 28 18 11 80    	mov    0x80111828,%edx
80100956:	a1 20 18 11 80       	mov    0x80111820,%eax
8010095b:	29 c2                	sub    %eax,%edx
8010095d:	89 d0                	mov    %edx,%eax
8010095f:	83 f8 7f             	cmp    $0x7f,%eax
80100962:	77 73                	ja     801009d7 <consoleintr+0x1de>
        c = (c == '\r') ? '\n' : c;
80100964:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
80100968:	74 05                	je     8010096f <consoleintr+0x176>
8010096a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010096d:	eb 05                	jmp    80100974 <consoleintr+0x17b>
8010096f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100974:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100977:	a1 28 18 11 80       	mov    0x80111828,%eax
8010097c:	8d 50 01             	lea    0x1(%eax),%edx
8010097f:	89 15 28 18 11 80    	mov    %edx,0x80111828
80100985:	83 e0 7f             	and    $0x7f,%eax
80100988:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010098b:	88 90 a0 17 11 80    	mov    %dl,-0x7feee860(%eax)
        consputc(c);
80100991:	83 ec 0c             	sub    $0xc,%esp
80100994:	ff 75 e0             	pushl  -0x20(%ebp)
80100997:	e8 f6 fd ff ff       	call   80100792 <consputc>
8010099c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010099f:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
801009a3:	74 18                	je     801009bd <consoleintr+0x1c4>
801009a5:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009a9:	74 12                	je     801009bd <consoleintr+0x1c4>
801009ab:	a1 28 18 11 80       	mov    0x80111828,%eax
801009b0:	8b 15 20 18 11 80    	mov    0x80111820,%edx
801009b6:	83 ea 80             	sub    $0xffffff80,%edx
801009b9:	39 d0                	cmp    %edx,%eax
801009bb:	75 1a                	jne    801009d7 <consoleintr+0x1de>
          input.w = input.e;
801009bd:	a1 28 18 11 80       	mov    0x80111828,%eax
801009c2:	a3 24 18 11 80       	mov    %eax,0x80111824
          wakeup(&input.r);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 18 11 80       	push   $0x80111820
801009cf:	e8 ac 49 00 00       	call   80105380 <wakeup>
801009d4:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009d7:	90                   	nop
  int doPrintCount = 0; 
  int doPrintSleepList =0; 
  int doPrintZombieList = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009d8:	8b 45 08             	mov    0x8(%ebp),%eax
801009db:	ff d0                	call   *%eax
801009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009e4:	0f 89 54 fe ff ff    	jns    8010083e <consoleintr+0x45>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009ea:	83 ec 0c             	sub    $0xc,%esp
801009ed:	68 e0 c5 10 80       	push   $0x8010c5e0
801009f2:	e8 e1 52 00 00       	call   80105cd8 <release>
801009f7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009fe:	74 05                	je     80100a05 <consoleintr+0x20c>
    procdump();  // now call procdump() wo. cons.lock held
80100a00:	e8 55 4a 00 00       	call   8010545a <procdump>
  }
  if(printPidList){
80100a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a09:	74 05                	je     80100a10 <consoleintr+0x217>
    printPidReadyList();
80100a0b:	e8 56 50 00 00       	call   80105a66 <printPidReadyList>
  }
   if(doPrintCount){
80100a10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a14:	74 05                	je     80100a1b <consoleintr+0x222>
    countFreeList();
80100a16:	e8 b7 50 00 00       	call   80105ad2 <countFreeList>
  }
  if(doPrintSleepList){
80100a1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a1f:	74 05                	je     80100a26 <consoleintr+0x22d>
    printPidSleepList();
80100a21:	e8 0f 51 00 00       	call   80105b35 <printPidSleepList>
  }
  if(doPrintZombieList){
80100a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2a:	74 05                	je     80100a31 <consoleintr+0x238>
    printZombieList();
80100a2c:	e8 70 51 00 00       	call   80105ba1 <printZombieList>
  }
}
80100a31:	90                   	nop
80100a32:	c9                   	leave  
80100a33:	c3                   	ret    

80100a34 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a3a:	83 ec 0c             	sub    $0xc,%esp
80100a3d:	ff 75 08             	pushl  0x8(%ebp)
80100a40:	e8 28 11 00 00       	call   80101b6d <iunlock>
80100a45:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a48:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4e:	83 ec 0c             	sub    $0xc,%esp
80100a51:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a56:	e8 16 52 00 00       	call   80105c71 <acquire>
80100a5b:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a5e:	e9 ac 00 00 00       	jmp    80100b0f <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a69:	8b 40 24             	mov    0x24(%eax),%eax
80100a6c:	85 c0                	test   %eax,%eax
80100a6e:	74 28                	je     80100a98 <consoleread+0x64>
        release(&cons.lock);
80100a70:	83 ec 0c             	sub    $0xc,%esp
80100a73:	68 e0 c5 10 80       	push   $0x8010c5e0
80100a78:	e8 5b 52 00 00       	call   80105cd8 <release>
80100a7d:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a80:	83 ec 0c             	sub    $0xc,%esp
80100a83:	ff 75 08             	pushl  0x8(%ebp)
80100a86:	e8 84 0f 00 00       	call   80101a0f <ilock>
80100a8b:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a93:	e9 ab 00 00 00       	jmp    80100b43 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a98:	83 ec 08             	sub    $0x8,%esp
80100a9b:	68 e0 c5 10 80       	push   $0x8010c5e0
80100aa0:	68 20 18 11 80       	push   $0x80111820
80100aa5:	e8 43 47 00 00       	call   801051ed <sleep>
80100aaa:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aad:	8b 15 20 18 11 80    	mov    0x80111820,%edx
80100ab3:	a1 24 18 11 80       	mov    0x80111824,%eax
80100ab8:	39 c2                	cmp    %eax,%edx
80100aba:	74 a7                	je     80100a63 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abc:	a1 20 18 11 80       	mov    0x80111820,%eax
80100ac1:	8d 50 01             	lea    0x1(%eax),%edx
80100ac4:	89 15 20 18 11 80    	mov    %edx,0x80111820
80100aca:	83 e0 7f             	and    $0x7f,%eax
80100acd:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80100ad4:	0f be c0             	movsbl %al,%eax
80100ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ada:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ade:	75 17                	jne    80100af7 <consoleread+0xc3>
      if(n < target){
80100ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100ae6:	73 2f                	jae    80100b17 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ae8:	a1 20 18 11 80       	mov    0x80111820,%eax
80100aed:	83 e8 01             	sub    $0x1,%eax
80100af0:	a3 20 18 11 80       	mov    %eax,0x80111820
      }
      break;
80100af5:	eb 20                	jmp    80100b17 <consoleread+0xe3>
    }
    *dst++ = c;
80100af7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afa:	8d 50 01             	lea    0x1(%eax),%edx
80100afd:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b00:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b03:	88 10                	mov    %dl,(%eax)
    --n;
80100b05:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b09:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b0d:	74 0b                	je     80100b1a <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b13:	7f 98                	jg     80100aad <consoleread+0x79>
80100b15:	eb 04                	jmp    80100b1b <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b17:	90                   	nop
80100b18:	eb 01                	jmp    80100b1b <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b1a:	90                   	nop
  }
  release(&cons.lock);
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b23:	e8 b0 51 00 00       	call   80105cd8 <release>
80100b28:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2b:	83 ec 0c             	sub    $0xc,%esp
80100b2e:	ff 75 08             	pushl  0x8(%ebp)
80100b31:	e8 d9 0e 00 00       	call   80101a0f <ilock>
80100b36:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b39:	8b 45 10             	mov    0x10(%ebp),%eax
80100b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b3f:	29 c2                	sub    %eax,%edx
80100b41:	89 d0                	mov    %edx,%eax
}
80100b43:	c9                   	leave  
80100b44:	c3                   	ret    

80100b45 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b45:	55                   	push   %ebp
80100b46:	89 e5                	mov    %esp,%ebp
80100b48:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b4b:	83 ec 0c             	sub    $0xc,%esp
80100b4e:	ff 75 08             	pushl  0x8(%ebp)
80100b51:	e8 17 10 00 00       	call   80101b6d <iunlock>
80100b56:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b59:	83 ec 0c             	sub    $0xc,%esp
80100b5c:	68 e0 c5 10 80       	push   $0x8010c5e0
80100b61:	e8 0b 51 00 00       	call   80105c71 <acquire>
80100b66:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b70:	eb 21                	jmp    80100b93 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b75:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b78:	01 d0                	add    %edx,%eax
80100b7a:	0f b6 00             	movzbl (%eax),%eax
80100b7d:	0f be c0             	movsbl %al,%eax
80100b80:	0f b6 c0             	movzbl %al,%eax
80100b83:	83 ec 0c             	sub    $0xc,%esp
80100b86:	50                   	push   %eax
80100b87:	e8 06 fc ff ff       	call   80100792 <consputc>
80100b8c:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b96:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b99:	7c d7                	jl     80100b72 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b9b:	83 ec 0c             	sub    $0xc,%esp
80100b9e:	68 e0 c5 10 80       	push   $0x8010c5e0
80100ba3:	e8 30 51 00 00       	call   80105cd8 <release>
80100ba8:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bab:	83 ec 0c             	sub    $0xc,%esp
80100bae:	ff 75 08             	pushl  0x8(%ebp)
80100bb1:	e8 59 0e 00 00       	call   80101a0f <ilock>
80100bb6:	83 c4 10             	add    $0x10,%esp

  return n;
80100bb9:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bbc:	c9                   	leave  
80100bbd:	c3                   	ret    

80100bbe <consoleinit>:

void
consoleinit(void)
{
80100bbe:	55                   	push   %ebp
80100bbf:	89 e5                	mov    %esp,%ebp
80100bc1:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bc4:	83 ec 08             	sub    $0x8,%esp
80100bc7:	68 76 93 10 80       	push   $0x80109376
80100bcc:	68 e0 c5 10 80       	push   $0x8010c5e0
80100bd1:	e8 79 50 00 00       	call   80105c4f <initlock>
80100bd6:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd9:	c7 05 ec 21 11 80 45 	movl   $0x80100b45,0x801121ec
80100be0:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be3:	c7 05 e8 21 11 80 34 	movl   $0x80100a34,0x801121e8
80100bea:	0a 10 80 
  cons.locking = 1;
80100bed:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100bf4:	00 00 00 

  picenable(IRQ_KBD);
80100bf7:	83 ec 0c             	sub    $0xc,%esp
80100bfa:	6a 01                	push   $0x1
80100bfc:	e8 cf 33 00 00       	call   80103fd0 <picenable>
80100c01:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c04:	83 ec 08             	sub    $0x8,%esp
80100c07:	6a 00                	push   $0x0
80100c09:	6a 01                	push   $0x1
80100c0b:	e8 6f 1f 00 00       	call   80102b7f <ioapicenable>
80100c10:	83 c4 10             	add    $0x10,%esp
}
80100c13:	90                   	nop
80100c14:	c9                   	leave  
80100c15:	c3                   	ret    

80100c16 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c16:	55                   	push   %ebp
80100c17:	89 e5                	mov    %esp,%ebp
80100c19:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c1f:	e8 ce 29 00 00       	call   801035f2 <begin_op>
  if((ip = namei(path)) == 0){
80100c24:	83 ec 0c             	sub    $0xc,%esp
80100c27:	ff 75 08             	pushl  0x8(%ebp)
80100c2a:	e8 9e 19 00 00       	call   801025cd <namei>
80100c2f:	83 c4 10             	add    $0x10,%esp
80100c32:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c35:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c39:	75 0f                	jne    80100c4a <exec+0x34>
    end_op();
80100c3b:	e8 3e 2a 00 00       	call   8010367e <end_op>
    return -1;
80100c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c45:	e9 ce 03 00 00       	jmp    80101018 <exec+0x402>
  }
  ilock(ip);
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff 75 d8             	pushl  -0x28(%ebp)
80100c50:	e8 ba 0d 00 00       	call   80101a0f <ilock>
80100c55:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c58:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c5f:	6a 34                	push   $0x34
80100c61:	6a 00                	push   $0x0
80100c63:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c69:	50                   	push   %eax
80100c6a:	ff 75 d8             	pushl  -0x28(%ebp)
80100c6d:	e8 0b 13 00 00       	call   80101f7d <readi>
80100c72:	83 c4 10             	add    $0x10,%esp
80100c75:	83 f8 33             	cmp    $0x33,%eax
80100c78:	0f 86 49 03 00 00    	jbe    80100fc7 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c7e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c84:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c89:	0f 85 3b 03 00 00    	jne    80100fca <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c8f:	e8 5f 7e 00 00       	call   80108af3 <setupkvm>
80100c94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c97:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c9b:	0f 84 2c 03 00 00    	je     80100fcd <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100ca1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100caf:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100cb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cb8:	e9 ab 00 00 00       	jmp    80100d68 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cc0:	6a 20                	push   $0x20
80100cc2:	50                   	push   %eax
80100cc3:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100cc9:	50                   	push   %eax
80100cca:	ff 75 d8             	pushl  -0x28(%ebp)
80100ccd:	e8 ab 12 00 00       	call   80101f7d <readi>
80100cd2:	83 c4 10             	add    $0x10,%esp
80100cd5:	83 f8 20             	cmp    $0x20,%eax
80100cd8:	0f 85 f2 02 00 00    	jne    80100fd0 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cde:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ce4:	83 f8 01             	cmp    $0x1,%eax
80100ce7:	75 71                	jne    80100d5a <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100ce9:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cef:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cf5:	39 c2                	cmp    %eax,%edx
80100cf7:	0f 82 d6 02 00 00    	jb     80100fd3 <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cfd:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d03:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d09:	01 d0                	add    %edx,%eax
80100d0b:	83 ec 04             	sub    $0x4,%esp
80100d0e:	50                   	push   %eax
80100d0f:	ff 75 e0             	pushl  -0x20(%ebp)
80100d12:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d15:	e8 80 81 00 00       	call   80108e9a <allocuvm>
80100d1a:	83 c4 10             	add    $0x10,%esp
80100d1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d20:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d24:	0f 84 ac 02 00 00    	je     80100fd6 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d2a:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d30:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d36:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d3c:	83 ec 0c             	sub    $0xc,%esp
80100d3f:	52                   	push   %edx
80100d40:	50                   	push   %eax
80100d41:	ff 75 d8             	pushl  -0x28(%ebp)
80100d44:	51                   	push   %ecx
80100d45:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d48:	e8 76 80 00 00       	call   80108dc3 <loaduvm>
80100d4d:	83 c4 20             	add    $0x20,%esp
80100d50:	85 c0                	test   %eax,%eax
80100d52:	0f 88 81 02 00 00    	js     80100fd9 <exec+0x3c3>
80100d58:	eb 01                	jmp    80100d5b <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d5a:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d5b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d62:	83 c0 20             	add    $0x20,%eax
80100d65:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d68:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d6f:	0f b7 c0             	movzwl %ax,%eax
80100d72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d75:	0f 8f 42 ff ff ff    	jg     80100cbd <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d7b:	83 ec 0c             	sub    $0xc,%esp
80100d7e:	ff 75 d8             	pushl  -0x28(%ebp)
80100d81:	e8 49 0f 00 00       	call   80101ccf <iunlockput>
80100d86:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d89:	e8 f0 28 00 00       	call   8010367e <end_op>
  ip = 0;
80100d8e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d98:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100da2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100da5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da8:	05 00 20 00 00       	add    $0x2000,%eax
80100dad:	83 ec 04             	sub    $0x4,%esp
80100db0:	50                   	push   %eax
80100db1:	ff 75 e0             	pushl  -0x20(%ebp)
80100db4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db7:	e8 de 80 00 00       	call   80108e9a <allocuvm>
80100dbc:	83 c4 10             	add    $0x10,%esp
80100dbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dc6:	0f 84 10 02 00 00    	je     80100fdc <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dcf:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dd4:	83 ec 08             	sub    $0x8,%esp
80100dd7:	50                   	push   %eax
80100dd8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ddb:	e8 e0 82 00 00       	call   801090c0 <clearpteu>
80100de0:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100de6:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100df0:	e9 96 00 00 00       	jmp    80100e8b <exec+0x275>
    if(argc >= MAXARG)
80100df5:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100df9:	0f 87 e0 01 00 00    	ja     80100fdf <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e09:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e0c:	01 d0                	add    %edx,%eax
80100e0e:	8b 00                	mov    (%eax),%eax
80100e10:	83 ec 0c             	sub    $0xc,%esp
80100e13:	50                   	push   %eax
80100e14:	e8 08 53 00 00       	call   80106121 <strlen>
80100e19:	83 c4 10             	add    $0x10,%esp
80100e1c:	89 c2                	mov    %eax,%edx
80100e1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e21:	29 d0                	sub    %edx,%eax
80100e23:	83 e8 01             	sub    $0x1,%eax
80100e26:	83 e0 fc             	and    $0xfffffffc,%eax
80100e29:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e39:	01 d0                	add    %edx,%eax
80100e3b:	8b 00                	mov    (%eax),%eax
80100e3d:	83 ec 0c             	sub    $0xc,%esp
80100e40:	50                   	push   %eax
80100e41:	e8 db 52 00 00       	call   80106121 <strlen>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	83 c0 01             	add    $0x1,%eax
80100e4c:	89 c1                	mov    %eax,%ecx
80100e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e5b:	01 d0                	add    %edx,%eax
80100e5d:	8b 00                	mov    (%eax),%eax
80100e5f:	51                   	push   %ecx
80100e60:	50                   	push   %eax
80100e61:	ff 75 dc             	pushl  -0x24(%ebp)
80100e64:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e67:	e8 0b 84 00 00       	call   80109277 <copyout>
80100e6c:	83 c4 10             	add    $0x10,%esp
80100e6f:	85 c0                	test   %eax,%eax
80100e71:	0f 88 6b 01 00 00    	js     80100fe2 <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e7a:	8d 50 03             	lea    0x3(%eax),%edx
80100e7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e80:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e87:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e8e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e98:	01 d0                	add    %edx,%eax
80100e9a:	8b 00                	mov    (%eax),%eax
80100e9c:	85 c0                	test   %eax,%eax
80100e9e:	0f 85 51 ff ff ff    	jne    80100df5 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea7:	83 c0 03             	add    $0x3,%eax
80100eaa:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100eb1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eb5:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100ebc:	ff ff ff 
  ustack[1] = argc;
80100ebf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ecb:	83 c0 01             	add    $0x1,%eax
80100ece:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed8:	29 d0                	sub    %edx,%eax
80100eda:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee3:	83 c0 04             	add    $0x4,%eax
80100ee6:	c1 e0 02             	shl    $0x2,%eax
80100ee9:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eef:	83 c0 04             	add    $0x4,%eax
80100ef2:	c1 e0 02             	shl    $0x2,%eax
80100ef5:	50                   	push   %eax
80100ef6:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100efc:	50                   	push   %eax
80100efd:	ff 75 dc             	pushl  -0x24(%ebp)
80100f00:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f03:	e8 6f 83 00 00       	call   80109277 <copyout>
80100f08:	83 c4 10             	add    $0x10,%esp
80100f0b:	85 c0                	test   %eax,%eax
80100f0d:	0f 88 d2 00 00 00    	js     80100fe5 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f13:	8b 45 08             	mov    0x8(%ebp),%eax
80100f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f1f:	eb 17                	jmp    80100f38 <exec+0x322>
    if(*s == '/')
80100f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f24:	0f b6 00             	movzbl (%eax),%eax
80100f27:	3c 2f                	cmp    $0x2f,%al
80100f29:	75 09                	jne    80100f34 <exec+0x31e>
      last = s+1;
80100f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f2e:	83 c0 01             	add    $0x1,%eax
80100f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3b:	0f b6 00             	movzbl (%eax),%eax
80100f3e:	84 c0                	test   %al,%al
80100f40:	75 df                	jne    80100f21 <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f48:	83 c0 6c             	add    $0x6c,%eax
80100f4b:	83 ec 04             	sub    $0x4,%esp
80100f4e:	6a 10                	push   $0x10
80100f50:	ff 75 f0             	pushl  -0x10(%ebp)
80100f53:	50                   	push   %eax
80100f54:	e8 7e 51 00 00       	call   801060d7 <safestrcpy>
80100f59:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f62:	8b 40 04             	mov    0x4(%eax),%eax
80100f65:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f6e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f71:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f7d:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f85:	8b 40 18             	mov    0x18(%eax),%eax
80100f88:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f8e:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f97:	8b 40 18             	mov    0x18(%eax),%eax
80100f9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f9d:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100fa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	50                   	push   %eax
80100faa:	e8 2b 7c 00 00       	call   80108bda <switchuvm>
80100faf:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb8:	e8 63 80 00 00       	call   80109020 <freevm>
80100fbd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc0:	b8 00 00 00 00       	mov    $0x0,%eax
80100fc5:	eb 51                	jmp    80101018 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fc7:	90                   	nop
80100fc8:	eb 1c                	jmp    80100fe6 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fca:	90                   	nop
80100fcb:	eb 19                	jmp    80100fe6 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fcd:	90                   	nop
80100fce:	eb 16                	jmp    80100fe6 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fd0:	90                   	nop
80100fd1:	eb 13                	jmp    80100fe6 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fd3:	90                   	nop
80100fd4:	eb 10                	jmp    80100fe6 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fd6:	90                   	nop
80100fd7:	eb 0d                	jmp    80100fe6 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fd9:	90                   	nop
80100fda:	eb 0a                	jmp    80100fe6 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fdc:	90                   	nop
80100fdd:	eb 07                	jmp    80100fe6 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fdf:	90                   	nop
80100fe0:	eb 04                	jmp    80100fe6 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fe2:	90                   	nop
80100fe3:	eb 01                	jmp    80100fe6 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fe5:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fe6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fea:	74 0e                	je     80100ffa <exec+0x3e4>
    freevm(pgdir);
80100fec:	83 ec 0c             	sub    $0xc,%esp
80100fef:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ff2:	e8 29 80 00 00       	call   80109020 <freevm>
80100ff7:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100ffa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ffe:	74 13                	je     80101013 <exec+0x3fd>
    iunlockput(ip);
80101000:	83 ec 0c             	sub    $0xc,%esp
80101003:	ff 75 d8             	pushl  -0x28(%ebp)
80101006:	e8 c4 0c 00 00       	call   80101ccf <iunlockput>
8010100b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010100e:	e8 6b 26 00 00       	call   8010367e <end_op>
  }
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    

8010101a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
8010101a:	55                   	push   %ebp
8010101b:	89 e5                	mov    %esp,%ebp
8010101d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101020:	83 ec 08             	sub    $0x8,%esp
80101023:	68 7e 93 10 80       	push   $0x8010937e
80101028:	68 40 18 11 80       	push   $0x80111840
8010102d:	e8 1d 4c 00 00       	call   80105c4f <initlock>
80101032:	83 c4 10             	add    $0x10,%esp
}
80101035:	90                   	nop
80101036:	c9                   	leave  
80101037:	c3                   	ret    

80101038 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101038:	55                   	push   %ebp
80101039:	89 e5                	mov    %esp,%ebp
8010103b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010103e:	83 ec 0c             	sub    $0xc,%esp
80101041:	68 40 18 11 80       	push   $0x80111840
80101046:	e8 26 4c 00 00       	call   80105c71 <acquire>
8010104b:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010104e:	c7 45 f4 74 18 11 80 	movl   $0x80111874,-0xc(%ebp)
80101055:	eb 2d                	jmp    80101084 <filealloc+0x4c>
    if(f->ref == 0){
80101057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105a:	8b 40 04             	mov    0x4(%eax),%eax
8010105d:	85 c0                	test   %eax,%eax
8010105f:	75 1f                	jne    80101080 <filealloc+0x48>
      f->ref = 1;
80101061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101064:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	68 40 18 11 80       	push   $0x80111840
80101073:	e8 60 4c 00 00       	call   80105cd8 <release>
80101078:	83 c4 10             	add    $0x10,%esp
      return f;
8010107b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010107e:	eb 23                	jmp    801010a3 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101080:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101084:	b8 d4 21 11 80       	mov    $0x801121d4,%eax
80101089:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010108c:	72 c9                	jb     80101057 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010108e:	83 ec 0c             	sub    $0xc,%esp
80101091:	68 40 18 11 80       	push   $0x80111840
80101096:	e8 3d 4c 00 00       	call   80105cd8 <release>
8010109b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010109e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010a3:	c9                   	leave  
801010a4:	c3                   	ret    

801010a5 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010a5:	55                   	push   %ebp
801010a6:	89 e5                	mov    %esp,%ebp
801010a8:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	68 40 18 11 80       	push   $0x80111840
801010b3:	e8 b9 4b 00 00       	call   80105c71 <acquire>
801010b8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bb:	8b 45 08             	mov    0x8(%ebp),%eax
801010be:	8b 40 04             	mov    0x4(%eax),%eax
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7f 0d                	jg     801010d2 <filedup+0x2d>
    panic("filedup");
801010c5:	83 ec 0c             	sub    $0xc,%esp
801010c8:	68 85 93 10 80       	push   $0x80109385
801010cd:	e8 94 f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	8b 40 04             	mov    0x4(%eax),%eax
801010d8:	8d 50 01             	lea    0x1(%eax),%edx
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 40 18 11 80       	push   $0x80111840
801010e9:	e8 ea 4b 00 00       	call   80105cd8 <release>
801010ee:	83 c4 10             	add    $0x10,%esp
  return f;
801010f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010f4:	c9                   	leave  
801010f5:	c3                   	ret    

801010f6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010f6:	55                   	push   %ebp
801010f7:	89 e5                	mov    %esp,%ebp
801010f9:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010fc:	83 ec 0c             	sub    $0xc,%esp
801010ff:	68 40 18 11 80       	push   $0x80111840
80101104:	e8 68 4b 00 00       	call   80105c71 <acquire>
80101109:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010110c:	8b 45 08             	mov    0x8(%ebp),%eax
8010110f:	8b 40 04             	mov    0x4(%eax),%eax
80101112:	85 c0                	test   %eax,%eax
80101114:	7f 0d                	jg     80101123 <fileclose+0x2d>
    panic("fileclose");
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	68 8d 93 10 80       	push   $0x8010938d
8010111e:	e8 43 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101123:	8b 45 08             	mov    0x8(%ebp),%eax
80101126:	8b 40 04             	mov    0x4(%eax),%eax
80101129:	8d 50 ff             	lea    -0x1(%eax),%edx
8010112c:	8b 45 08             	mov    0x8(%ebp),%eax
8010112f:	89 50 04             	mov    %edx,0x4(%eax)
80101132:	8b 45 08             	mov    0x8(%ebp),%eax
80101135:	8b 40 04             	mov    0x4(%eax),%eax
80101138:	85 c0                	test   %eax,%eax
8010113a:	7e 15                	jle    80101151 <fileclose+0x5b>
    release(&ftable.lock);
8010113c:	83 ec 0c             	sub    $0xc,%esp
8010113f:	68 40 18 11 80       	push   $0x80111840
80101144:	e8 8f 4b 00 00       	call   80105cd8 <release>
80101149:	83 c4 10             	add    $0x10,%esp
8010114c:	e9 8b 00 00 00       	jmp    801011dc <fileclose+0xe6>
    return;
  }
  ff = *f;
80101151:	8b 45 08             	mov    0x8(%ebp),%eax
80101154:	8b 10                	mov    (%eax),%edx
80101156:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101159:	8b 50 04             	mov    0x4(%eax),%edx
8010115c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010115f:	8b 50 08             	mov    0x8(%eax),%edx
80101162:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101165:	8b 50 0c             	mov    0xc(%eax),%edx
80101168:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010116b:	8b 50 10             	mov    0x10(%eax),%edx
8010116e:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101171:	8b 40 14             	mov    0x14(%eax),%eax
80101174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101177:	8b 45 08             	mov    0x8(%ebp),%eax
8010117a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101181:	8b 45 08             	mov    0x8(%ebp),%eax
80101184:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010118a:	83 ec 0c             	sub    $0xc,%esp
8010118d:	68 40 18 11 80       	push   $0x80111840
80101192:	e8 41 4b 00 00       	call   80105cd8 <release>
80101197:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010119a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010119d:	83 f8 01             	cmp    $0x1,%eax
801011a0:	75 19                	jne    801011bb <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801011a2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011a6:	0f be d0             	movsbl %al,%edx
801011a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011ac:	83 ec 08             	sub    $0x8,%esp
801011af:	52                   	push   %edx
801011b0:	50                   	push   %eax
801011b1:	e8 83 30 00 00       	call   80104239 <pipeclose>
801011b6:	83 c4 10             	add    $0x10,%esp
801011b9:	eb 21                	jmp    801011dc <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011be:	83 f8 02             	cmp    $0x2,%eax
801011c1:	75 19                	jne    801011dc <fileclose+0xe6>
    begin_op();
801011c3:	e8 2a 24 00 00       	call   801035f2 <begin_op>
    iput(ff.ip);
801011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011cb:	83 ec 0c             	sub    $0xc,%esp
801011ce:	50                   	push   %eax
801011cf:	e8 0b 0a 00 00       	call   80101bdf <iput>
801011d4:	83 c4 10             	add    $0x10,%esp
    end_op();
801011d7:	e8 a2 24 00 00       	call   8010367e <end_op>
  }
}
801011dc:	c9                   	leave  
801011dd:	c3                   	ret    

801011de <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011de:	55                   	push   %ebp
801011df:	89 e5                	mov    %esp,%ebp
801011e1:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011e4:	8b 45 08             	mov    0x8(%ebp),%eax
801011e7:	8b 00                	mov    (%eax),%eax
801011e9:	83 f8 02             	cmp    $0x2,%eax
801011ec:	75 40                	jne    8010122e <filestat+0x50>
    ilock(f->ip);
801011ee:	8b 45 08             	mov    0x8(%ebp),%eax
801011f1:	8b 40 10             	mov    0x10(%eax),%eax
801011f4:	83 ec 0c             	sub    $0xc,%esp
801011f7:	50                   	push   %eax
801011f8:	e8 12 08 00 00       	call   80101a0f <ilock>
801011fd:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101200:	8b 45 08             	mov    0x8(%ebp),%eax
80101203:	8b 40 10             	mov    0x10(%eax),%eax
80101206:	83 ec 08             	sub    $0x8,%esp
80101209:	ff 75 0c             	pushl  0xc(%ebp)
8010120c:	50                   	push   %eax
8010120d:	e8 25 0d 00 00       	call   80101f37 <stati>
80101212:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	8b 40 10             	mov    0x10(%eax),%eax
8010121b:	83 ec 0c             	sub    $0xc,%esp
8010121e:	50                   	push   %eax
8010121f:	e8 49 09 00 00       	call   80101b6d <iunlock>
80101224:	83 c4 10             	add    $0x10,%esp
    return 0;
80101227:	b8 00 00 00 00       	mov    $0x0,%eax
8010122c:	eb 05                	jmp    80101233 <filestat+0x55>
  }
  return -1;
8010122e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101233:	c9                   	leave  
80101234:	c3                   	ret    

80101235 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101235:	55                   	push   %ebp
80101236:	89 e5                	mov    %esp,%ebp
80101238:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010123b:	8b 45 08             	mov    0x8(%ebp),%eax
8010123e:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101242:	84 c0                	test   %al,%al
80101244:	75 0a                	jne    80101250 <fileread+0x1b>
    return -1;
80101246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010124b:	e9 9b 00 00 00       	jmp    801012eb <fileread+0xb6>
  if(f->type == FD_PIPE)
80101250:	8b 45 08             	mov    0x8(%ebp),%eax
80101253:	8b 00                	mov    (%eax),%eax
80101255:	83 f8 01             	cmp    $0x1,%eax
80101258:	75 1a                	jne    80101274 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010125a:	8b 45 08             	mov    0x8(%ebp),%eax
8010125d:	8b 40 0c             	mov    0xc(%eax),%eax
80101260:	83 ec 04             	sub    $0x4,%esp
80101263:	ff 75 10             	pushl  0x10(%ebp)
80101266:	ff 75 0c             	pushl  0xc(%ebp)
80101269:	50                   	push   %eax
8010126a:	e8 72 31 00 00       	call   801043e1 <piperead>
8010126f:	83 c4 10             	add    $0x10,%esp
80101272:	eb 77                	jmp    801012eb <fileread+0xb6>
  if(f->type == FD_INODE){
80101274:	8b 45 08             	mov    0x8(%ebp),%eax
80101277:	8b 00                	mov    (%eax),%eax
80101279:	83 f8 02             	cmp    $0x2,%eax
8010127c:	75 60                	jne    801012de <fileread+0xa9>
    ilock(f->ip);
8010127e:	8b 45 08             	mov    0x8(%ebp),%eax
80101281:	8b 40 10             	mov    0x10(%eax),%eax
80101284:	83 ec 0c             	sub    $0xc,%esp
80101287:	50                   	push   %eax
80101288:	e8 82 07 00 00       	call   80101a0f <ilock>
8010128d:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101290:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101293:	8b 45 08             	mov    0x8(%ebp),%eax
80101296:	8b 50 14             	mov    0x14(%eax),%edx
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 40 10             	mov    0x10(%eax),%eax
8010129f:	51                   	push   %ecx
801012a0:	52                   	push   %edx
801012a1:	ff 75 0c             	pushl  0xc(%ebp)
801012a4:	50                   	push   %eax
801012a5:	e8 d3 0c 00 00       	call   80101f7d <readi>
801012aa:	83 c4 10             	add    $0x10,%esp
801012ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012b4:	7e 11                	jle    801012c7 <fileread+0x92>
      f->off += r;
801012b6:	8b 45 08             	mov    0x8(%ebp),%eax
801012b9:	8b 50 14             	mov    0x14(%eax),%edx
801012bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012bf:	01 c2                	add    %eax,%edx
801012c1:	8b 45 08             	mov    0x8(%ebp),%eax
801012c4:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012c7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ca:	8b 40 10             	mov    0x10(%eax),%eax
801012cd:	83 ec 0c             	sub    $0xc,%esp
801012d0:	50                   	push   %eax
801012d1:	e8 97 08 00 00       	call   80101b6d <iunlock>
801012d6:	83 c4 10             	add    $0x10,%esp
    return r;
801012d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012dc:	eb 0d                	jmp    801012eb <fileread+0xb6>
  }
  panic("fileread");
801012de:	83 ec 0c             	sub    $0xc,%esp
801012e1:	68 97 93 10 80       	push   $0x80109397
801012e6:	e8 7b f2 ff ff       	call   80100566 <panic>
}
801012eb:	c9                   	leave  
801012ec:	c3                   	ret    

801012ed <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012ed:	55                   	push   %ebp
801012ee:	89 e5                	mov    %esp,%ebp
801012f0:	53                   	push   %ebx
801012f1:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012f4:	8b 45 08             	mov    0x8(%ebp),%eax
801012f7:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012fb:	84 c0                	test   %al,%al
801012fd:	75 0a                	jne    80101309 <filewrite+0x1c>
    return -1;
801012ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101304:	e9 1b 01 00 00       	jmp    80101424 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101309:	8b 45 08             	mov    0x8(%ebp),%eax
8010130c:	8b 00                	mov    (%eax),%eax
8010130e:	83 f8 01             	cmp    $0x1,%eax
80101311:	75 1d                	jne    80101330 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101313:	8b 45 08             	mov    0x8(%ebp),%eax
80101316:	8b 40 0c             	mov    0xc(%eax),%eax
80101319:	83 ec 04             	sub    $0x4,%esp
8010131c:	ff 75 10             	pushl  0x10(%ebp)
8010131f:	ff 75 0c             	pushl  0xc(%ebp)
80101322:	50                   	push   %eax
80101323:	e8 bb 2f 00 00       	call   801042e3 <pipewrite>
80101328:	83 c4 10             	add    $0x10,%esp
8010132b:	e9 f4 00 00 00       	jmp    80101424 <filewrite+0x137>
  if(f->type == FD_INODE){
80101330:	8b 45 08             	mov    0x8(%ebp),%eax
80101333:	8b 00                	mov    (%eax),%eax
80101335:	83 f8 02             	cmp    $0x2,%eax
80101338:	0f 85 d9 00 00 00    	jne    80101417 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010133e:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010134c:	e9 a3 00 00 00       	jmp    801013f4 <filewrite+0x107>
      int n1 = n - i;
80101351:	8b 45 10             	mov    0x10(%ebp),%eax
80101354:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101357:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010135d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101360:	7e 06                	jle    80101368 <filewrite+0x7b>
        n1 = max;
80101362:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101365:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101368:	e8 85 22 00 00       	call   801035f2 <begin_op>
      ilock(f->ip);
8010136d:	8b 45 08             	mov    0x8(%ebp),%eax
80101370:	8b 40 10             	mov    0x10(%eax),%eax
80101373:	83 ec 0c             	sub    $0xc,%esp
80101376:	50                   	push   %eax
80101377:	e8 93 06 00 00       	call   80101a0f <ilock>
8010137c:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010137f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101382:	8b 45 08             	mov    0x8(%ebp),%eax
80101385:	8b 50 14             	mov    0x14(%eax),%edx
80101388:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010138b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010138e:	01 c3                	add    %eax,%ebx
80101390:	8b 45 08             	mov    0x8(%ebp),%eax
80101393:	8b 40 10             	mov    0x10(%eax),%eax
80101396:	51                   	push   %ecx
80101397:	52                   	push   %edx
80101398:	53                   	push   %ebx
80101399:	50                   	push   %eax
8010139a:	e8 35 0d 00 00       	call   801020d4 <writei>
8010139f:	83 c4 10             	add    $0x10,%esp
801013a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013a9:	7e 11                	jle    801013bc <filewrite+0xcf>
        f->off += r;
801013ab:	8b 45 08             	mov    0x8(%ebp),%eax
801013ae:	8b 50 14             	mov    0x14(%eax),%edx
801013b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b4:	01 c2                	add    %eax,%edx
801013b6:	8b 45 08             	mov    0x8(%ebp),%eax
801013b9:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013bc:	8b 45 08             	mov    0x8(%ebp),%eax
801013bf:	8b 40 10             	mov    0x10(%eax),%eax
801013c2:	83 ec 0c             	sub    $0xc,%esp
801013c5:	50                   	push   %eax
801013c6:	e8 a2 07 00 00       	call   80101b6d <iunlock>
801013cb:	83 c4 10             	add    $0x10,%esp
      end_op();
801013ce:	e8 ab 22 00 00       	call   8010367e <end_op>

      if(r < 0)
801013d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013d7:	78 29                	js     80101402 <filewrite+0x115>
        break;
      if(r != n1)
801013d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013df:	74 0d                	je     801013ee <filewrite+0x101>
        panic("short filewrite");
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	68 a0 93 10 80       	push   $0x801093a0
801013e9:	e8 78 f1 ff ff       	call   80100566 <panic>
      i += r;
801013ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f1:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f7:	3b 45 10             	cmp    0x10(%ebp),%eax
801013fa:	0f 8c 51 ff ff ff    	jl     80101351 <filewrite+0x64>
80101400:	eb 01                	jmp    80101403 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101402:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101406:	3b 45 10             	cmp    0x10(%ebp),%eax
80101409:	75 05                	jne    80101410 <filewrite+0x123>
8010140b:	8b 45 10             	mov    0x10(%ebp),%eax
8010140e:	eb 14                	jmp    80101424 <filewrite+0x137>
80101410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101415:	eb 0d                	jmp    80101424 <filewrite+0x137>
  }
  panic("filewrite");
80101417:	83 ec 0c             	sub    $0xc,%esp
8010141a:	68 b0 93 10 80       	push   $0x801093b0
8010141f:	e8 42 f1 ff ff       	call   80100566 <panic>
}
80101424:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101427:	c9                   	leave  
80101428:	c3                   	ret    

80101429 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101429:	55                   	push   %ebp
8010142a:	89 e5                	mov    %esp,%ebp
8010142c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010142f:	8b 45 08             	mov    0x8(%ebp),%eax
80101432:	83 ec 08             	sub    $0x8,%esp
80101435:	6a 01                	push   $0x1
80101437:	50                   	push   %eax
80101438:	e8 79 ed ff ff       	call   801001b6 <bread>
8010143d:	83 c4 10             	add    $0x10,%esp
80101440:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101443:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101446:	83 c0 18             	add    $0x18,%eax
80101449:	83 ec 04             	sub    $0x4,%esp
8010144c:	6a 1c                	push   $0x1c
8010144e:	50                   	push   %eax
8010144f:	ff 75 0c             	pushl  0xc(%ebp)
80101452:	e8 3c 4b 00 00       	call   80105f93 <memmove>
80101457:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010145a:	83 ec 0c             	sub    $0xc,%esp
8010145d:	ff 75 f4             	pushl  -0xc(%ebp)
80101460:	e8 c9 ed ff ff       	call   8010022e <brelse>
80101465:	83 c4 10             	add    $0x10,%esp
}
80101468:	90                   	nop
80101469:	c9                   	leave  
8010146a:	c3                   	ret    

8010146b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010146b:	55                   	push   %ebp
8010146c:	89 e5                	mov    %esp,%ebp
8010146e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101471:	8b 55 0c             	mov    0xc(%ebp),%edx
80101474:	8b 45 08             	mov    0x8(%ebp),%eax
80101477:	83 ec 08             	sub    $0x8,%esp
8010147a:	52                   	push   %edx
8010147b:	50                   	push   %eax
8010147c:	e8 35 ed ff ff       	call   801001b6 <bread>
80101481:	83 c4 10             	add    $0x10,%esp
80101484:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148a:	83 c0 18             	add    $0x18,%eax
8010148d:	83 ec 04             	sub    $0x4,%esp
80101490:	68 00 02 00 00       	push   $0x200
80101495:	6a 00                	push   $0x0
80101497:	50                   	push   %eax
80101498:	e8 37 4a 00 00       	call   80105ed4 <memset>
8010149d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014a0:	83 ec 0c             	sub    $0xc,%esp
801014a3:	ff 75 f4             	pushl  -0xc(%ebp)
801014a6:	e8 7f 23 00 00       	call   8010382a <log_write>
801014ab:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014ae:	83 ec 0c             	sub    $0xc,%esp
801014b1:	ff 75 f4             	pushl  -0xc(%ebp)
801014b4:	e8 75 ed ff ff       	call   8010022e <brelse>
801014b9:	83 c4 10             	add    $0x10,%esp
}
801014bc:	90                   	nop
801014bd:	c9                   	leave  
801014be:	c3                   	ret    

801014bf <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014bf:	55                   	push   %ebp
801014c0:	89 e5                	mov    %esp,%ebp
801014c2:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014d3:	e9 13 01 00 00       	jmp    801015eb <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014db:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014e1:	85 c0                	test   %eax,%eax
801014e3:	0f 48 c2             	cmovs  %edx,%eax
801014e6:	c1 f8 0c             	sar    $0xc,%eax
801014e9:	89 c2                	mov    %eax,%edx
801014eb:	a1 58 22 11 80       	mov    0x80112258,%eax
801014f0:	01 d0                	add    %edx,%eax
801014f2:	83 ec 08             	sub    $0x8,%esp
801014f5:	50                   	push   %eax
801014f6:	ff 75 08             	pushl  0x8(%ebp)
801014f9:	e8 b8 ec ff ff       	call   801001b6 <bread>
801014fe:	83 c4 10             	add    $0x10,%esp
80101501:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101504:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010150b:	e9 a6 00 00 00       	jmp    801015b6 <balloc+0xf7>
      m = 1 << (bi % 8);
80101510:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101513:	99                   	cltd   
80101514:	c1 ea 1d             	shr    $0x1d,%edx
80101517:	01 d0                	add    %edx,%eax
80101519:	83 e0 07             	and    $0x7,%eax
8010151c:	29 d0                	sub    %edx,%eax
8010151e:	ba 01 00 00 00       	mov    $0x1,%edx
80101523:	89 c1                	mov    %eax,%ecx
80101525:	d3 e2                	shl    %cl,%edx
80101527:	89 d0                	mov    %edx,%eax
80101529:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152f:	8d 50 07             	lea    0x7(%eax),%edx
80101532:	85 c0                	test   %eax,%eax
80101534:	0f 48 c2             	cmovs  %edx,%eax
80101537:	c1 f8 03             	sar    $0x3,%eax
8010153a:	89 c2                	mov    %eax,%edx
8010153c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010153f:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101544:	0f b6 c0             	movzbl %al,%eax
80101547:	23 45 e8             	and    -0x18(%ebp),%eax
8010154a:	85 c0                	test   %eax,%eax
8010154c:	75 64                	jne    801015b2 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101551:	8d 50 07             	lea    0x7(%eax),%edx
80101554:	85 c0                	test   %eax,%eax
80101556:	0f 48 c2             	cmovs  %edx,%eax
80101559:	c1 f8 03             	sar    $0x3,%eax
8010155c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010155f:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101564:	89 d1                	mov    %edx,%ecx
80101566:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101569:	09 ca                	or     %ecx,%edx
8010156b:	89 d1                	mov    %edx,%ecx
8010156d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101570:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101574:	83 ec 0c             	sub    $0xc,%esp
80101577:	ff 75 ec             	pushl  -0x14(%ebp)
8010157a:	e8 ab 22 00 00       	call   8010382a <log_write>
8010157f:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101582:	83 ec 0c             	sub    $0xc,%esp
80101585:	ff 75 ec             	pushl  -0x14(%ebp)
80101588:	e8 a1 ec ff ff       	call   8010022e <brelse>
8010158d:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101593:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101596:	01 c2                	add    %eax,%edx
80101598:	8b 45 08             	mov    0x8(%ebp),%eax
8010159b:	83 ec 08             	sub    $0x8,%esp
8010159e:	52                   	push   %edx
8010159f:	50                   	push   %eax
801015a0:	e8 c6 fe ff ff       	call   8010146b <bzero>
801015a5:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ae:	01 d0                	add    %edx,%eax
801015b0:	eb 57                	jmp    80101609 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015b6:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015bd:	7f 17                	jg     801015d6 <balloc+0x117>
801015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c5:	01 d0                	add    %edx,%eax
801015c7:	89 c2                	mov    %eax,%edx
801015c9:	a1 40 22 11 80       	mov    0x80112240,%eax
801015ce:	39 c2                	cmp    %eax,%edx
801015d0:	0f 82 3a ff ff ff    	jb     80101510 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015d6:	83 ec 0c             	sub    $0xc,%esp
801015d9:	ff 75 ec             	pushl  -0x14(%ebp)
801015dc:	e8 4d ec ff ff       	call   8010022e <brelse>
801015e1:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015eb:	8b 15 40 22 11 80    	mov    0x80112240,%edx
801015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f4:	39 c2                	cmp    %eax,%edx
801015f6:	0f 87 dc fe ff ff    	ja     801014d8 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015fc:	83 ec 0c             	sub    $0xc,%esp
801015ff:	68 bc 93 10 80       	push   $0x801093bc
80101604:	e8 5d ef ff ff       	call   80100566 <panic>
}
80101609:	c9                   	leave  
8010160a:	c3                   	ret    

8010160b <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010160b:	55                   	push   %ebp
8010160c:	89 e5                	mov    %esp,%ebp
8010160e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101611:	83 ec 08             	sub    $0x8,%esp
80101614:	68 40 22 11 80       	push   $0x80112240
80101619:	ff 75 08             	pushl  0x8(%ebp)
8010161c:	e8 08 fe ff ff       	call   80101429 <readsb>
80101621:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101624:	8b 45 0c             	mov    0xc(%ebp),%eax
80101627:	c1 e8 0c             	shr    $0xc,%eax
8010162a:	89 c2                	mov    %eax,%edx
8010162c:	a1 58 22 11 80       	mov    0x80112258,%eax
80101631:	01 c2                	add    %eax,%edx
80101633:	8b 45 08             	mov    0x8(%ebp),%eax
80101636:	83 ec 08             	sub    $0x8,%esp
80101639:	52                   	push   %edx
8010163a:	50                   	push   %eax
8010163b:	e8 76 eb ff ff       	call   801001b6 <bread>
80101640:	83 c4 10             	add    $0x10,%esp
80101643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101646:	8b 45 0c             	mov    0xc(%ebp),%eax
80101649:	25 ff 0f 00 00       	and    $0xfff,%eax
8010164e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101651:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101654:	99                   	cltd   
80101655:	c1 ea 1d             	shr    $0x1d,%edx
80101658:	01 d0                	add    %edx,%eax
8010165a:	83 e0 07             	and    $0x7,%eax
8010165d:	29 d0                	sub    %edx,%eax
8010165f:	ba 01 00 00 00       	mov    $0x1,%edx
80101664:	89 c1                	mov    %eax,%ecx
80101666:	d3 e2                	shl    %cl,%edx
80101668:	89 d0                	mov    %edx,%eax
8010166a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101670:	8d 50 07             	lea    0x7(%eax),%edx
80101673:	85 c0                	test   %eax,%eax
80101675:	0f 48 c2             	cmovs  %edx,%eax
80101678:	c1 f8 03             	sar    $0x3,%eax
8010167b:	89 c2                	mov    %eax,%edx
8010167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101680:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101685:	0f b6 c0             	movzbl %al,%eax
80101688:	23 45 ec             	and    -0x14(%ebp),%eax
8010168b:	85 c0                	test   %eax,%eax
8010168d:	75 0d                	jne    8010169c <bfree+0x91>
    panic("freeing free block");
8010168f:	83 ec 0c             	sub    $0xc,%esp
80101692:	68 d2 93 10 80       	push   $0x801093d2
80101697:	e8 ca ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
8010169c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010169f:	8d 50 07             	lea    0x7(%eax),%edx
801016a2:	85 c0                	test   %eax,%eax
801016a4:	0f 48 c2             	cmovs  %edx,%eax
801016a7:	c1 f8 03             	sar    $0x3,%eax
801016aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016ad:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016b2:	89 d1                	mov    %edx,%ecx
801016b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016b7:	f7 d2                	not    %edx
801016b9:	21 ca                	and    %ecx,%edx
801016bb:	89 d1                	mov    %edx,%ecx
801016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c0:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016c4:	83 ec 0c             	sub    $0xc,%esp
801016c7:	ff 75 f4             	pushl  -0xc(%ebp)
801016ca:	e8 5b 21 00 00       	call   8010382a <log_write>
801016cf:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016d2:	83 ec 0c             	sub    $0xc,%esp
801016d5:	ff 75 f4             	pushl  -0xc(%ebp)
801016d8:	e8 51 eb ff ff       	call   8010022e <brelse>
801016dd:	83 c4 10             	add    $0x10,%esp
}
801016e0:	90                   	nop
801016e1:	c9                   	leave  
801016e2:	c3                   	ret    

801016e3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016e3:	55                   	push   %ebp
801016e4:	89 e5                	mov    %esp,%ebp
801016e6:	57                   	push   %edi
801016e7:	56                   	push   %esi
801016e8:	53                   	push   %ebx
801016e9:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016ec:	83 ec 08             	sub    $0x8,%esp
801016ef:	68 e5 93 10 80       	push   $0x801093e5
801016f4:	68 60 22 11 80       	push   $0x80112260
801016f9:	e8 51 45 00 00       	call   80105c4f <initlock>
801016fe:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101701:	83 ec 08             	sub    $0x8,%esp
80101704:	68 40 22 11 80       	push   $0x80112240
80101709:	ff 75 08             	pushl  0x8(%ebp)
8010170c:	e8 18 fd ff ff       	call   80101429 <readsb>
80101711:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101714:	a1 58 22 11 80       	mov    0x80112258,%eax
80101719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010171c:	8b 3d 54 22 11 80    	mov    0x80112254,%edi
80101722:	8b 35 50 22 11 80    	mov    0x80112250,%esi
80101728:	8b 1d 4c 22 11 80    	mov    0x8011224c,%ebx
8010172e:	8b 0d 48 22 11 80    	mov    0x80112248,%ecx
80101734:	8b 15 44 22 11 80    	mov    0x80112244,%edx
8010173a:	a1 40 22 11 80       	mov    0x80112240,%eax
8010173f:	ff 75 e4             	pushl  -0x1c(%ebp)
80101742:	57                   	push   %edi
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	51                   	push   %ecx
80101746:	52                   	push   %edx
80101747:	50                   	push   %eax
80101748:	68 ec 93 10 80       	push   $0x801093ec
8010174d:	e8 74 ec ff ff       	call   801003c6 <cprintf>
80101752:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101755:	90                   	nop
80101756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101759:	5b                   	pop    %ebx
8010175a:	5e                   	pop    %esi
8010175b:	5f                   	pop    %edi
8010175c:	5d                   	pop    %ebp
8010175d:	c3                   	ret    

8010175e <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010175e:	55                   	push   %ebp
8010175f:	89 e5                	mov    %esp,%ebp
80101761:	83 ec 28             	sub    $0x28,%esp
80101764:	8b 45 0c             	mov    0xc(%ebp),%eax
80101767:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010176b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101772:	e9 9e 00 00 00       	jmp    80101815 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177a:	c1 e8 03             	shr    $0x3,%eax
8010177d:	89 c2                	mov    %eax,%edx
8010177f:	a1 54 22 11 80       	mov    0x80112254,%eax
80101784:	01 d0                	add    %edx,%eax
80101786:	83 ec 08             	sub    $0x8,%esp
80101789:	50                   	push   %eax
8010178a:	ff 75 08             	pushl  0x8(%ebp)
8010178d:	e8 24 ea ff ff       	call   801001b6 <bread>
80101792:	83 c4 10             	add    $0x10,%esp
80101795:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101798:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179b:	8d 50 18             	lea    0x18(%eax),%edx
8010179e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a1:	83 e0 07             	and    $0x7,%eax
801017a4:	c1 e0 06             	shl    $0x6,%eax
801017a7:	01 d0                	add    %edx,%eax
801017a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017af:	0f b7 00             	movzwl (%eax),%eax
801017b2:	66 85 c0             	test   %ax,%ax
801017b5:	75 4c                	jne    80101803 <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017b7:	83 ec 04             	sub    $0x4,%esp
801017ba:	6a 40                	push   $0x40
801017bc:	6a 00                	push   $0x0
801017be:	ff 75 ec             	pushl  -0x14(%ebp)
801017c1:	e8 0e 47 00 00       	call   80105ed4 <memset>
801017c6:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017cc:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017d0:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017d3:	83 ec 0c             	sub    $0xc,%esp
801017d6:	ff 75 f0             	pushl  -0x10(%ebp)
801017d9:	e8 4c 20 00 00       	call   8010382a <log_write>
801017de:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017e1:	83 ec 0c             	sub    $0xc,%esp
801017e4:	ff 75 f0             	pushl  -0x10(%ebp)
801017e7:	e8 42 ea ff ff       	call   8010022e <brelse>
801017ec:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f2:	83 ec 08             	sub    $0x8,%esp
801017f5:	50                   	push   %eax
801017f6:	ff 75 08             	pushl  0x8(%ebp)
801017f9:	e8 f8 00 00 00       	call   801018f6 <iget>
801017fe:	83 c4 10             	add    $0x10,%esp
80101801:	eb 30                	jmp    80101833 <ialloc+0xd5>
    }
    brelse(bp);
80101803:	83 ec 0c             	sub    $0xc,%esp
80101806:	ff 75 f0             	pushl  -0x10(%ebp)
80101809:	e8 20 ea ff ff       	call   8010022e <brelse>
8010180e:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101811:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101815:	8b 15 48 22 11 80    	mov    0x80112248,%edx
8010181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181e:	39 c2                	cmp    %eax,%edx
80101820:	0f 87 51 ff ff ff    	ja     80101777 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101826:	83 ec 0c             	sub    $0xc,%esp
80101829:	68 3f 94 10 80       	push   $0x8010943f
8010182e:	e8 33 ed ff ff       	call   80100566 <panic>
}
80101833:	c9                   	leave  
80101834:	c3                   	ret    

80101835 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101835:	55                   	push   %ebp
80101836:	89 e5                	mov    %esp,%ebp
80101838:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010183b:	8b 45 08             	mov    0x8(%ebp),%eax
8010183e:	8b 40 04             	mov    0x4(%eax),%eax
80101841:	c1 e8 03             	shr    $0x3,%eax
80101844:	89 c2                	mov    %eax,%edx
80101846:	a1 54 22 11 80       	mov    0x80112254,%eax
8010184b:	01 c2                	add    %eax,%edx
8010184d:	8b 45 08             	mov    0x8(%ebp),%eax
80101850:	8b 00                	mov    (%eax),%eax
80101852:	83 ec 08             	sub    $0x8,%esp
80101855:	52                   	push   %edx
80101856:	50                   	push   %eax
80101857:	e8 5a e9 ff ff       	call   801001b6 <bread>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101865:	8d 50 18             	lea    0x18(%eax),%edx
80101868:	8b 45 08             	mov    0x8(%ebp),%eax
8010186b:	8b 40 04             	mov    0x4(%eax),%eax
8010186e:	83 e0 07             	and    $0x7,%eax
80101871:	c1 e0 06             	shl    $0x6,%eax
80101874:	01 d0                	add    %edx,%eax
80101876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101879:	8b 45 08             	mov    0x8(%ebp),%eax
8010187c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101883:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101886:	8b 45 08             	mov    0x8(%ebp),%eax
80101889:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101890:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101894:	8b 45 08             	mov    0x8(%ebp),%eax
80101897:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ac:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018b0:	8b 45 08             	mov    0x8(%ebp),%eax
801018b3:	8b 50 18             	mov    0x18(%eax),%edx
801018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b9:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018bc:	8b 45 08             	mov    0x8(%ebp),%eax
801018bf:	8d 50 1c             	lea    0x1c(%eax),%edx
801018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c5:	83 c0 0c             	add    $0xc,%eax
801018c8:	83 ec 04             	sub    $0x4,%esp
801018cb:	6a 34                	push   $0x34
801018cd:	52                   	push   %edx
801018ce:	50                   	push   %eax
801018cf:	e8 bf 46 00 00       	call   80105f93 <memmove>
801018d4:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	ff 75 f4             	pushl  -0xc(%ebp)
801018dd:	e8 48 1f 00 00       	call   8010382a <log_write>
801018e2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018e5:	83 ec 0c             	sub    $0xc,%esp
801018e8:	ff 75 f4             	pushl  -0xc(%ebp)
801018eb:	e8 3e e9 ff ff       	call   8010022e <brelse>
801018f0:	83 c4 10             	add    $0x10,%esp
}
801018f3:	90                   	nop
801018f4:	c9                   	leave  
801018f5:	c3                   	ret    

801018f6 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018f6:	55                   	push   %ebp
801018f7:	89 e5                	mov    %esp,%ebp
801018f9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018fc:	83 ec 0c             	sub    $0xc,%esp
801018ff:	68 60 22 11 80       	push   $0x80112260
80101904:	e8 68 43 00 00       	call   80105c71 <acquire>
80101909:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101913:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
8010191a:	eb 5d                	jmp    80101979 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191f:	8b 40 08             	mov    0x8(%eax),%eax
80101922:	85 c0                	test   %eax,%eax
80101924:	7e 39                	jle    8010195f <iget+0x69>
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101929:	8b 00                	mov    (%eax),%eax
8010192b:	3b 45 08             	cmp    0x8(%ebp),%eax
8010192e:	75 2f                	jne    8010195f <iget+0x69>
80101930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101933:	8b 40 04             	mov    0x4(%eax),%eax
80101936:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101939:	75 24                	jne    8010195f <iget+0x69>
      ip->ref++;
8010193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193e:	8b 40 08             	mov    0x8(%eax),%eax
80101941:	8d 50 01             	lea    0x1(%eax),%edx
80101944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101947:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 60 22 11 80       	push   $0x80112260
80101952:	e8 81 43 00 00       	call   80105cd8 <release>
80101957:	83 c4 10             	add    $0x10,%esp
      return ip;
8010195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195d:	eb 74                	jmp    801019d3 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010195f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101963:	75 10                	jne    80101975 <iget+0x7f>
80101965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101968:	8b 40 08             	mov    0x8(%eax),%eax
8010196b:	85 c0                	test   %eax,%eax
8010196d:	75 06                	jne    80101975 <iget+0x7f>
      empty = ip;
8010196f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101972:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101975:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101979:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101980:	72 9a                	jb     8010191c <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101982:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101986:	75 0d                	jne    80101995 <iget+0x9f>
    panic("iget: no inodes");
80101988:	83 ec 0c             	sub    $0xc,%esp
8010198b:	68 51 94 10 80       	push   $0x80109451
80101990:	e8 d1 eb ff ff       	call   80100566 <panic>

  ip = empty;
80101995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101998:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199e:	8b 55 08             	mov    0x8(%ebp),%edx
801019a1:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801019a9:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019af:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019c0:	83 ec 0c             	sub    $0xc,%esp
801019c3:	68 60 22 11 80       	push   $0x80112260
801019c8:	e8 0b 43 00 00       	call   80105cd8 <release>
801019cd:	83 c4 10             	add    $0x10,%esp

  return ip;
801019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019d3:	c9                   	leave  
801019d4:	c3                   	ret    

801019d5 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019d5:	55                   	push   %ebp
801019d6:	89 e5                	mov    %esp,%ebp
801019d8:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019db:	83 ec 0c             	sub    $0xc,%esp
801019de:	68 60 22 11 80       	push   $0x80112260
801019e3:	e8 89 42 00 00       	call   80105c71 <acquire>
801019e8:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019eb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ee:	8b 40 08             	mov    0x8(%eax),%eax
801019f1:	8d 50 01             	lea    0x1(%eax),%edx
801019f4:	8b 45 08             	mov    0x8(%ebp),%eax
801019f7:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019fa:	83 ec 0c             	sub    $0xc,%esp
801019fd:	68 60 22 11 80       	push   $0x80112260
80101a02:	e8 d1 42 00 00       	call   80105cd8 <release>
80101a07:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a0d:	c9                   	leave  
80101a0e:	c3                   	ret    

80101a0f <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a0f:	55                   	push   %ebp
80101a10:	89 e5                	mov    %esp,%ebp
80101a12:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a19:	74 0a                	je     80101a25 <ilock+0x16>
80101a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1e:	8b 40 08             	mov    0x8(%eax),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	7f 0d                	jg     80101a32 <ilock+0x23>
    panic("ilock");
80101a25:	83 ec 0c             	sub    $0xc,%esp
80101a28:	68 61 94 10 80       	push   $0x80109461
80101a2d:	e8 34 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a32:	83 ec 0c             	sub    $0xc,%esp
80101a35:	68 60 22 11 80       	push   $0x80112260
80101a3a:	e8 32 42 00 00       	call   80105c71 <acquire>
80101a3f:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a42:	eb 13                	jmp    80101a57 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a44:	83 ec 08             	sub    $0x8,%esp
80101a47:	68 60 22 11 80       	push   $0x80112260
80101a4c:	ff 75 08             	pushl  0x8(%ebp)
80101a4f:	e8 99 37 00 00       	call   801051ed <sleep>
80101a54:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5d:	83 e0 01             	and    $0x1,%eax
80101a60:	85 c0                	test   %eax,%eax
80101a62:	75 e0                	jne    80101a44 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6a:	83 c8 01             	or     $0x1,%eax
80101a6d:	89 c2                	mov    %eax,%edx
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a75:	83 ec 0c             	sub    $0xc,%esp
80101a78:	68 60 22 11 80       	push   $0x80112260
80101a7d:	e8 56 42 00 00       	call   80105cd8 <release>
80101a82:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a85:	8b 45 08             	mov    0x8(%ebp),%eax
80101a88:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8b:	83 e0 02             	and    $0x2,%eax
80101a8e:	85 c0                	test   %eax,%eax
80101a90:	0f 85 d4 00 00 00    	jne    80101b6a <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a96:	8b 45 08             	mov    0x8(%ebp),%eax
80101a99:	8b 40 04             	mov    0x4(%eax),%eax
80101a9c:	c1 e8 03             	shr    $0x3,%eax
80101a9f:	89 c2                	mov    %eax,%edx
80101aa1:	a1 54 22 11 80       	mov    0x80112254,%eax
80101aa6:	01 c2                	add    %eax,%edx
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	8b 00                	mov    (%eax),%eax
80101aad:	83 ec 08             	sub    $0x8,%esp
80101ab0:	52                   	push   %edx
80101ab1:	50                   	push   %eax
80101ab2:	e8 ff e6 ff ff       	call   801001b6 <bread>
80101ab7:	83 c4 10             	add    $0x10,%esp
80101aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac0:	8d 50 18             	lea    0x18(%eax),%edx
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	8b 40 04             	mov    0x4(%eax),%eax
80101ac9:	83 e0 07             	and    $0x7,%eax
80101acc:	c1 e0 06             	shl    $0x6,%eax
80101acf:	01 d0                	add    %edx,%eax
80101ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad7:	0f b7 10             	movzwl (%eax),%edx
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae4:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aeb:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af2:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
80101af9:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b00:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b04:	8b 45 08             	mov    0x8(%ebp),%eax
80101b07:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b0e:	8b 50 08             	mov    0x8(%eax),%edx
80101b11:	8b 45 08             	mov    0x8(%ebp),%eax
80101b14:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b1a:	8d 50 0c             	lea    0xc(%eax),%edx
80101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b20:	83 c0 1c             	add    $0x1c,%eax
80101b23:	83 ec 04             	sub    $0x4,%esp
80101b26:	6a 34                	push   $0x34
80101b28:	52                   	push   %edx
80101b29:	50                   	push   %eax
80101b2a:	e8 64 44 00 00       	call   80105f93 <memmove>
80101b2f:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b32:	83 ec 0c             	sub    $0xc,%esp
80101b35:	ff 75 f4             	pushl  -0xc(%ebp)
80101b38:	e8 f1 e6 ff ff       	call   8010022e <brelse>
80101b3d:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	8b 40 0c             	mov    0xc(%eax),%eax
80101b46:	83 c8 02             	or     $0x2,%eax
80101b49:	89 c2                	mov    %eax,%edx
80101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4e:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b51:	8b 45 08             	mov    0x8(%ebp),%eax
80101b54:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b58:	66 85 c0             	test   %ax,%ax
80101b5b:	75 0d                	jne    80101b6a <ilock+0x15b>
      panic("ilock: no type");
80101b5d:	83 ec 0c             	sub    $0xc,%esp
80101b60:	68 67 94 10 80       	push   $0x80109467
80101b65:	e8 fc e9 ff ff       	call   80100566 <panic>
  }
}
80101b6a:	90                   	nop
80101b6b:	c9                   	leave  
80101b6c:	c3                   	ret    

80101b6d <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b6d:	55                   	push   %ebp
80101b6e:	89 e5                	mov    %esp,%ebp
80101b70:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b77:	74 17                	je     80101b90 <iunlock+0x23>
80101b79:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b7f:	83 e0 01             	and    $0x1,%eax
80101b82:	85 c0                	test   %eax,%eax
80101b84:	74 0a                	je     80101b90 <iunlock+0x23>
80101b86:	8b 45 08             	mov    0x8(%ebp),%eax
80101b89:	8b 40 08             	mov    0x8(%eax),%eax
80101b8c:	85 c0                	test   %eax,%eax
80101b8e:	7f 0d                	jg     80101b9d <iunlock+0x30>
    panic("iunlock");
80101b90:	83 ec 0c             	sub    $0xc,%esp
80101b93:	68 76 94 10 80       	push   $0x80109476
80101b98:	e8 c9 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b9d:	83 ec 0c             	sub    $0xc,%esp
80101ba0:	68 60 22 11 80       	push   $0x80112260
80101ba5:	e8 c7 40 00 00       	call   80105c71 <acquire>
80101baa:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 40 0c             	mov    0xc(%eax),%eax
80101bb3:	83 e0 fe             	and    $0xfffffffe,%eax
80101bb6:	89 c2                	mov    %eax,%edx
80101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbb:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bbe:	83 ec 0c             	sub    $0xc,%esp
80101bc1:	ff 75 08             	pushl  0x8(%ebp)
80101bc4:	e8 b7 37 00 00       	call   80105380 <wakeup>
80101bc9:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bcc:	83 ec 0c             	sub    $0xc,%esp
80101bcf:	68 60 22 11 80       	push   $0x80112260
80101bd4:	e8 ff 40 00 00       	call   80105cd8 <release>
80101bd9:	83 c4 10             	add    $0x10,%esp
}
80101bdc:	90                   	nop
80101bdd:	c9                   	leave  
80101bde:	c3                   	ret    

80101bdf <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101bdf:	55                   	push   %ebp
80101be0:	89 e5                	mov    %esp,%ebp
80101be2:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101be5:	83 ec 0c             	sub    $0xc,%esp
80101be8:	68 60 22 11 80       	push   $0x80112260
80101bed:	e8 7f 40 00 00       	call   80105c71 <acquire>
80101bf2:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf8:	8b 40 08             	mov    0x8(%eax),%eax
80101bfb:	83 f8 01             	cmp    $0x1,%eax
80101bfe:	0f 85 a9 00 00 00    	jne    80101cad <iput+0xce>
80101c04:	8b 45 08             	mov    0x8(%ebp),%eax
80101c07:	8b 40 0c             	mov    0xc(%eax),%eax
80101c0a:	83 e0 02             	and    $0x2,%eax
80101c0d:	85 c0                	test   %eax,%eax
80101c0f:	0f 84 98 00 00 00    	je     80101cad <iput+0xce>
80101c15:	8b 45 08             	mov    0x8(%ebp),%eax
80101c18:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c1c:	66 85 c0             	test   %ax,%ax
80101c1f:	0f 85 88 00 00 00    	jne    80101cad <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	8b 40 0c             	mov    0xc(%eax),%eax
80101c2b:	83 e0 01             	and    $0x1,%eax
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	74 0d                	je     80101c3f <iput+0x60>
      panic("iput busy");
80101c32:	83 ec 0c             	sub    $0xc,%esp
80101c35:	68 7e 94 10 80       	push   $0x8010947e
80101c3a:	e8 27 e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101c3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c42:	8b 40 0c             	mov    0xc(%eax),%eax
80101c45:	83 c8 01             	or     $0x1,%eax
80101c48:	89 c2                	mov    %eax,%edx
80101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4d:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c50:	83 ec 0c             	sub    $0xc,%esp
80101c53:	68 60 22 11 80       	push   $0x80112260
80101c58:	e8 7b 40 00 00       	call   80105cd8 <release>
80101c5d:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c60:	83 ec 0c             	sub    $0xc,%esp
80101c63:	ff 75 08             	pushl  0x8(%ebp)
80101c66:	e8 a8 01 00 00       	call   80101e13 <itrunc>
80101c6b:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c71:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c77:	83 ec 0c             	sub    $0xc,%esp
80101c7a:	ff 75 08             	pushl  0x8(%ebp)
80101c7d:	e8 b3 fb ff ff       	call   80101835 <iupdate>
80101c82:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c85:	83 ec 0c             	sub    $0xc,%esp
80101c88:	68 60 22 11 80       	push   $0x80112260
80101c8d:	e8 df 3f 00 00       	call   80105c71 <acquire>
80101c92:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c95:	8b 45 08             	mov    0x8(%ebp),%eax
80101c98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	ff 75 08             	pushl  0x8(%ebp)
80101ca5:	e8 d6 36 00 00       	call   80105380 <wakeup>
80101caa:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101cad:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb0:	8b 40 08             	mov    0x8(%eax),%eax
80101cb3:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cbc:	83 ec 0c             	sub    $0xc,%esp
80101cbf:	68 60 22 11 80       	push   $0x80112260
80101cc4:	e8 0f 40 00 00       	call   80105cd8 <release>
80101cc9:	83 c4 10             	add    $0x10,%esp
}
80101ccc:	90                   	nop
80101ccd:	c9                   	leave  
80101cce:	c3                   	ret    

80101ccf <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101ccf:	55                   	push   %ebp
80101cd0:	89 e5                	mov    %esp,%ebp
80101cd2:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cd5:	83 ec 0c             	sub    $0xc,%esp
80101cd8:	ff 75 08             	pushl  0x8(%ebp)
80101cdb:	e8 8d fe ff ff       	call   80101b6d <iunlock>
80101ce0:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101ce3:	83 ec 0c             	sub    $0xc,%esp
80101ce6:	ff 75 08             	pushl  0x8(%ebp)
80101ce9:	e8 f1 fe ff ff       	call   80101bdf <iput>
80101cee:	83 c4 10             	add    $0x10,%esp
}
80101cf1:	90                   	nop
80101cf2:	c9                   	leave  
80101cf3:	c3                   	ret    

80101cf4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101cf4:	55                   	push   %ebp
80101cf5:	89 e5                	mov    %esp,%ebp
80101cf7:	53                   	push   %ebx
80101cf8:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cfb:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cff:	77 42                	ja     80101d43 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101d01:	8b 45 08             	mov    0x8(%ebp),%eax
80101d04:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d07:	83 c2 04             	add    $0x4,%edx
80101d0a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d15:	75 24                	jne    80101d3b <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d17:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1a:	8b 00                	mov    (%eax),%eax
80101d1c:	83 ec 0c             	sub    $0xc,%esp
80101d1f:	50                   	push   %eax
80101d20:	e8 9a f7 ff ff       	call   801014bf <balloc>
80101d25:	83 c4 10             	add    $0x10,%esp
80101d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d31:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d37:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d3e:	e9 cb 00 00 00       	jmp    80101e0e <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d43:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d47:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d4b:	0f 87 b0 00 00 00    	ja     80101e01 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d51:	8b 45 08             	mov    0x8(%ebp),%eax
80101d54:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d5e:	75 1d                	jne    80101d7d <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d60:	8b 45 08             	mov    0x8(%ebp),%eax
80101d63:	8b 00                	mov    (%eax),%eax
80101d65:	83 ec 0c             	sub    $0xc,%esp
80101d68:	50                   	push   %eax
80101d69:	e8 51 f7 ff ff       	call   801014bf <balloc>
80101d6e:	83 c4 10             	add    $0x10,%esp
80101d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d74:	8b 45 08             	mov    0x8(%ebp),%eax
80101d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d7a:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d80:	8b 00                	mov    (%eax),%eax
80101d82:	83 ec 08             	sub    $0x8,%esp
80101d85:	ff 75 f4             	pushl  -0xc(%ebp)
80101d88:	50                   	push   %eax
80101d89:	e8 28 e4 ff ff       	call   801001b6 <bread>
80101d8e:	83 c4 10             	add    $0x10,%esp
80101d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d97:	83 c0 18             	add    $0x18,%eax
80101d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101daa:	01 d0                	add    %edx,%eax
80101dac:	8b 00                	mov    (%eax),%eax
80101dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101db5:	75 37                	jne    80101dee <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101db7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dc4:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dca:	8b 00                	mov    (%eax),%eax
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	50                   	push   %eax
80101dd0:	e8 ea f6 ff ff       	call   801014bf <balloc>
80101dd5:	83 c4 10             	add    $0x10,%esp
80101dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dde:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101de0:	83 ec 0c             	sub    $0xc,%esp
80101de3:	ff 75 f0             	pushl  -0x10(%ebp)
80101de6:	e8 3f 1a 00 00       	call   8010382a <log_write>
80101deb:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101dee:	83 ec 0c             	sub    $0xc,%esp
80101df1:	ff 75 f0             	pushl  -0x10(%ebp)
80101df4:	e8 35 e4 ff ff       	call   8010022e <brelse>
80101df9:	83 c4 10             	add    $0x10,%esp
    return addr;
80101dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dff:	eb 0d                	jmp    80101e0e <bmap+0x11a>
  }

  panic("bmap: out of range");
80101e01:	83 ec 0c             	sub    $0xc,%esp
80101e04:	68 88 94 10 80       	push   $0x80109488
80101e09:	e8 58 e7 ff ff       	call   80100566 <panic>
}
80101e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e11:	c9                   	leave  
80101e12:	c3                   	ret    

80101e13 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e13:	55                   	push   %ebp
80101e14:	89 e5                	mov    %esp,%ebp
80101e16:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e20:	eb 45                	jmp    80101e67 <itrunc+0x54>
    if(ip->addrs[i]){
80101e22:	8b 45 08             	mov    0x8(%ebp),%eax
80101e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e28:	83 c2 04             	add    $0x4,%edx
80101e2b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e2f:	85 c0                	test   %eax,%eax
80101e31:	74 30                	je     80101e63 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e33:	8b 45 08             	mov    0x8(%ebp),%eax
80101e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e39:	83 c2 04             	add    $0x4,%edx
80101e3c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e40:	8b 55 08             	mov    0x8(%ebp),%edx
80101e43:	8b 12                	mov    (%edx),%edx
80101e45:	83 ec 08             	sub    $0x8,%esp
80101e48:	50                   	push   %eax
80101e49:	52                   	push   %edx
80101e4a:	e8 bc f7 ff ff       	call   8010160b <bfree>
80101e4f:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e52:	8b 45 08             	mov    0x8(%ebp),%eax
80101e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e58:	83 c2 04             	add    $0x4,%edx
80101e5b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e62:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e67:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e6b:	7e b5                	jle    80101e22 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e70:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e73:	85 c0                	test   %eax,%eax
80101e75:	0f 84 a1 00 00 00    	je     80101f1c <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7e:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e81:	8b 45 08             	mov    0x8(%ebp),%eax
80101e84:	8b 00                	mov    (%eax),%eax
80101e86:	83 ec 08             	sub    $0x8,%esp
80101e89:	52                   	push   %edx
80101e8a:	50                   	push   %eax
80101e8b:	e8 26 e3 ff ff       	call   801001b6 <bread>
80101e90:	83 c4 10             	add    $0x10,%esp
80101e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e99:	83 c0 18             	add    $0x18,%eax
80101e9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101ea6:	eb 3c                	jmp    80101ee4 <itrunc+0xd1>
      if(a[j])
80101ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eb5:	01 d0                	add    %edx,%eax
80101eb7:	8b 00                	mov    (%eax),%eax
80101eb9:	85 c0                	test   %eax,%eax
80101ebb:	74 23                	je     80101ee0 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ec0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eca:	01 d0                	add    %edx,%eax
80101ecc:	8b 00                	mov    (%eax),%eax
80101ece:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed1:	8b 12                	mov    (%edx),%edx
80101ed3:	83 ec 08             	sub    $0x8,%esp
80101ed6:	50                   	push   %eax
80101ed7:	52                   	push   %edx
80101ed8:	e8 2e f7 ff ff       	call   8010160b <bfree>
80101edd:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ee0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee7:	83 f8 7f             	cmp    $0x7f,%eax
80101eea:	76 bc                	jbe    80101ea8 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101eec:	83 ec 0c             	sub    $0xc,%esp
80101eef:	ff 75 ec             	pushl  -0x14(%ebp)
80101ef2:	e8 37 e3 ff ff       	call   8010022e <brelse>
80101ef7:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101efa:	8b 45 08             	mov    0x8(%ebp),%eax
80101efd:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f00:	8b 55 08             	mov    0x8(%ebp),%edx
80101f03:	8b 12                	mov    (%edx),%edx
80101f05:	83 ec 08             	sub    $0x8,%esp
80101f08:	50                   	push   %eax
80101f09:	52                   	push   %edx
80101f0a:	e8 fc f6 ff ff       	call   8010160b <bfree>
80101f0f:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f12:	8b 45 08             	mov    0x8(%ebp),%eax
80101f15:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f26:	83 ec 0c             	sub    $0xc,%esp
80101f29:	ff 75 08             	pushl  0x8(%ebp)
80101f2c:	e8 04 f9 ff ff       	call   80101835 <iupdate>
80101f31:	83 c4 10             	add    $0x10,%esp
}
80101f34:	90                   	nop
80101f35:	c9                   	leave  
80101f36:	c3                   	ret    

80101f37 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f37:	55                   	push   %ebp
80101f38:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3d:	8b 00                	mov    (%eax),%eax
80101f3f:	89 c2                	mov    %eax,%edx
80101f41:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f44:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f47:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4a:	8b 50 04             	mov    0x4(%eax),%edx
80101f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f50:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f53:	8b 45 08             	mov    0x8(%ebp),%eax
80101f56:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f5d:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f60:	8b 45 08             	mov    0x8(%ebp),%eax
80101f63:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f67:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f6a:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f71:	8b 50 18             	mov    0x18(%eax),%edx
80101f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f77:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f7a:	90                   	nop
80101f7b:	5d                   	pop    %ebp
80101f7c:	c3                   	ret    

80101f7d <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f7d:	55                   	push   %ebp
80101f7e:	89 e5                	mov    %esp,%ebp
80101f80:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f83:	8b 45 08             	mov    0x8(%ebp),%eax
80101f86:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f8a:	66 83 f8 03          	cmp    $0x3,%ax
80101f8e:	75 5c                	jne    80101fec <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f90:	8b 45 08             	mov    0x8(%ebp),%eax
80101f93:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f97:	66 85 c0             	test   %ax,%ax
80101f9a:	78 20                	js     80101fbc <readi+0x3f>
80101f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa3:	66 83 f8 09          	cmp    $0x9,%ax
80101fa7:	7f 13                	jg     80101fbc <readi+0x3f>
80101fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fac:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fb0:	98                   	cwtl   
80101fb1:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	75 0a                	jne    80101fc6 <readi+0x49>
      return -1;
80101fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc1:	e9 0c 01 00 00       	jmp    801020d2 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fcd:	98                   	cwtl   
80101fce:	8b 04 c5 e0 21 11 80 	mov    -0x7feede20(,%eax,8),%eax
80101fd5:	8b 55 14             	mov    0x14(%ebp),%edx
80101fd8:	83 ec 04             	sub    $0x4,%esp
80101fdb:	52                   	push   %edx
80101fdc:	ff 75 0c             	pushl  0xc(%ebp)
80101fdf:	ff 75 08             	pushl  0x8(%ebp)
80101fe2:	ff d0                	call   *%eax
80101fe4:	83 c4 10             	add    $0x10,%esp
80101fe7:	e9 e6 00 00 00       	jmp    801020d2 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101fec:	8b 45 08             	mov    0x8(%ebp),%eax
80101fef:	8b 40 18             	mov    0x18(%eax),%eax
80101ff2:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ff5:	72 0d                	jb     80102004 <readi+0x87>
80101ff7:	8b 55 10             	mov    0x10(%ebp),%edx
80101ffa:	8b 45 14             	mov    0x14(%ebp),%eax
80101ffd:	01 d0                	add    %edx,%eax
80101fff:	3b 45 10             	cmp    0x10(%ebp),%eax
80102002:	73 0a                	jae    8010200e <readi+0x91>
    return -1;
80102004:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102009:	e9 c4 00 00 00       	jmp    801020d2 <readi+0x155>
  if(off + n > ip->size)
8010200e:	8b 55 10             	mov    0x10(%ebp),%edx
80102011:	8b 45 14             	mov    0x14(%ebp),%eax
80102014:	01 c2                	add    %eax,%edx
80102016:	8b 45 08             	mov    0x8(%ebp),%eax
80102019:	8b 40 18             	mov    0x18(%eax),%eax
8010201c:	39 c2                	cmp    %eax,%edx
8010201e:	76 0c                	jbe    8010202c <readi+0xaf>
    n = ip->size - off;
80102020:	8b 45 08             	mov    0x8(%ebp),%eax
80102023:	8b 40 18             	mov    0x18(%eax),%eax
80102026:	2b 45 10             	sub    0x10(%ebp),%eax
80102029:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010202c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102033:	e9 8b 00 00 00       	jmp    801020c3 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102038:	8b 45 10             	mov    0x10(%ebp),%eax
8010203b:	c1 e8 09             	shr    $0x9,%eax
8010203e:	83 ec 08             	sub    $0x8,%esp
80102041:	50                   	push   %eax
80102042:	ff 75 08             	pushl  0x8(%ebp)
80102045:	e8 aa fc ff ff       	call   80101cf4 <bmap>
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	89 c2                	mov    %eax,%edx
8010204f:	8b 45 08             	mov    0x8(%ebp),%eax
80102052:	8b 00                	mov    (%eax),%eax
80102054:	83 ec 08             	sub    $0x8,%esp
80102057:	52                   	push   %edx
80102058:	50                   	push   %eax
80102059:	e8 58 e1 ff ff       	call   801001b6 <bread>
8010205e:	83 c4 10             	add    $0x10,%esp
80102061:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102064:	8b 45 10             	mov    0x10(%ebp),%eax
80102067:	25 ff 01 00 00       	and    $0x1ff,%eax
8010206c:	ba 00 02 00 00       	mov    $0x200,%edx
80102071:	29 c2                	sub    %eax,%edx
80102073:	8b 45 14             	mov    0x14(%ebp),%eax
80102076:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102079:	39 c2                	cmp    %eax,%edx
8010207b:	0f 46 c2             	cmovbe %edx,%eax
8010207e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102081:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102084:	8d 50 18             	lea    0x18(%eax),%edx
80102087:	8b 45 10             	mov    0x10(%ebp),%eax
8010208a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010208f:	01 d0                	add    %edx,%eax
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	ff 75 ec             	pushl  -0x14(%ebp)
80102097:	50                   	push   %eax
80102098:	ff 75 0c             	pushl  0xc(%ebp)
8010209b:	e8 f3 3e 00 00       	call   80105f93 <memmove>
801020a0:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020a3:	83 ec 0c             	sub    $0xc,%esp
801020a6:	ff 75 f0             	pushl  -0x10(%ebp)
801020a9:	e8 80 e1 ff ff       	call   8010022e <brelse>
801020ae:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b4:	01 45 f4             	add    %eax,-0xc(%ebp)
801020b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ba:	01 45 10             	add    %eax,0x10(%ebp)
801020bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c0:	01 45 0c             	add    %eax,0xc(%ebp)
801020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c6:	3b 45 14             	cmp    0x14(%ebp),%eax
801020c9:	0f 82 69 ff ff ff    	jb     80102038 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020cf:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020d2:	c9                   	leave  
801020d3:	c3                   	ret    

801020d4 <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020d4:	55                   	push   %ebp
801020d5:	89 e5                	mov    %esp,%ebp
801020d7:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020da:	8b 45 08             	mov    0x8(%ebp),%eax
801020dd:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020e1:	66 83 f8 03          	cmp    $0x3,%ax
801020e5:	75 5c                	jne    80102143 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020e7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ea:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ee:	66 85 c0             	test   %ax,%ax
801020f1:	78 20                	js     80102113 <writei+0x3f>
801020f3:	8b 45 08             	mov    0x8(%ebp),%eax
801020f6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020fa:	66 83 f8 09          	cmp    $0x9,%ax
801020fe:	7f 13                	jg     80102113 <writei+0x3f>
80102100:	8b 45 08             	mov    0x8(%ebp),%eax
80102103:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102107:	98                   	cwtl   
80102108:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
8010210f:	85 c0                	test   %eax,%eax
80102111:	75 0a                	jne    8010211d <writei+0x49>
      return -1;
80102113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102118:	e9 3d 01 00 00       	jmp    8010225a <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010211d:	8b 45 08             	mov    0x8(%ebp),%eax
80102120:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102124:	98                   	cwtl   
80102125:	8b 04 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%eax
8010212c:	8b 55 14             	mov    0x14(%ebp),%edx
8010212f:	83 ec 04             	sub    $0x4,%esp
80102132:	52                   	push   %edx
80102133:	ff 75 0c             	pushl  0xc(%ebp)
80102136:	ff 75 08             	pushl  0x8(%ebp)
80102139:	ff d0                	call   *%eax
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	e9 17 01 00 00       	jmp    8010225a <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102143:	8b 45 08             	mov    0x8(%ebp),%eax
80102146:	8b 40 18             	mov    0x18(%eax),%eax
80102149:	3b 45 10             	cmp    0x10(%ebp),%eax
8010214c:	72 0d                	jb     8010215b <writei+0x87>
8010214e:	8b 55 10             	mov    0x10(%ebp),%edx
80102151:	8b 45 14             	mov    0x14(%ebp),%eax
80102154:	01 d0                	add    %edx,%eax
80102156:	3b 45 10             	cmp    0x10(%ebp),%eax
80102159:	73 0a                	jae    80102165 <writei+0x91>
    return -1;
8010215b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102160:	e9 f5 00 00 00       	jmp    8010225a <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102165:	8b 55 10             	mov    0x10(%ebp),%edx
80102168:	8b 45 14             	mov    0x14(%ebp),%eax
8010216b:	01 d0                	add    %edx,%eax
8010216d:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102172:	76 0a                	jbe    8010217e <writei+0xaa>
    return -1;
80102174:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102179:	e9 dc 00 00 00       	jmp    8010225a <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010217e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102185:	e9 99 00 00 00       	jmp    80102223 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010218a:	8b 45 10             	mov    0x10(%ebp),%eax
8010218d:	c1 e8 09             	shr    $0x9,%eax
80102190:	83 ec 08             	sub    $0x8,%esp
80102193:	50                   	push   %eax
80102194:	ff 75 08             	pushl  0x8(%ebp)
80102197:	e8 58 fb ff ff       	call   80101cf4 <bmap>
8010219c:	83 c4 10             	add    $0x10,%esp
8010219f:	89 c2                	mov    %eax,%edx
801021a1:	8b 45 08             	mov    0x8(%ebp),%eax
801021a4:	8b 00                	mov    (%eax),%eax
801021a6:	83 ec 08             	sub    $0x8,%esp
801021a9:	52                   	push   %edx
801021aa:	50                   	push   %eax
801021ab:	e8 06 e0 ff ff       	call   801001b6 <bread>
801021b0:	83 c4 10             	add    $0x10,%esp
801021b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021b6:	8b 45 10             	mov    0x10(%ebp),%eax
801021b9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021be:	ba 00 02 00 00       	mov    $0x200,%edx
801021c3:	29 c2                	sub    %eax,%edx
801021c5:	8b 45 14             	mov    0x14(%ebp),%eax
801021c8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021cb:	39 c2                	cmp    %eax,%edx
801021cd:	0f 46 c2             	cmovbe %edx,%eax
801021d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021d6:	8d 50 18             	lea    0x18(%eax),%edx
801021d9:	8b 45 10             	mov    0x10(%ebp),%eax
801021dc:	25 ff 01 00 00       	and    $0x1ff,%eax
801021e1:	01 d0                	add    %edx,%eax
801021e3:	83 ec 04             	sub    $0x4,%esp
801021e6:	ff 75 ec             	pushl  -0x14(%ebp)
801021e9:	ff 75 0c             	pushl  0xc(%ebp)
801021ec:	50                   	push   %eax
801021ed:	e8 a1 3d 00 00       	call   80105f93 <memmove>
801021f2:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	ff 75 f0             	pushl  -0x10(%ebp)
801021fb:	e8 2a 16 00 00       	call   8010382a <log_write>
80102200:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102203:	83 ec 0c             	sub    $0xc,%esp
80102206:	ff 75 f0             	pushl  -0x10(%ebp)
80102209:	e8 20 e0 ff ff       	call   8010022e <brelse>
8010220e:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102211:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102214:	01 45 f4             	add    %eax,-0xc(%ebp)
80102217:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010221a:	01 45 10             	add    %eax,0x10(%ebp)
8010221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102220:	01 45 0c             	add    %eax,0xc(%ebp)
80102223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102226:	3b 45 14             	cmp    0x14(%ebp),%eax
80102229:	0f 82 5b ff ff ff    	jb     8010218a <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010222f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102233:	74 22                	je     80102257 <writei+0x183>
80102235:	8b 45 08             	mov    0x8(%ebp),%eax
80102238:	8b 40 18             	mov    0x18(%eax),%eax
8010223b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010223e:	73 17                	jae    80102257 <writei+0x183>
    ip->size = off;
80102240:	8b 45 08             	mov    0x8(%ebp),%eax
80102243:	8b 55 10             	mov    0x10(%ebp),%edx
80102246:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	ff 75 08             	pushl  0x8(%ebp)
8010224f:	e8 e1 f5 ff ff       	call   80101835 <iupdate>
80102254:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102257:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010225a:	c9                   	leave  
8010225b:	c3                   	ret    

8010225c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
8010225c:	55                   	push   %ebp
8010225d:	89 e5                	mov    %esp,%ebp
8010225f:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102262:	83 ec 04             	sub    $0x4,%esp
80102265:	6a 0e                	push   $0xe
80102267:	ff 75 0c             	pushl  0xc(%ebp)
8010226a:	ff 75 08             	pushl  0x8(%ebp)
8010226d:	e8 b7 3d 00 00       	call   80106029 <strncmp>
80102272:	83 c4 10             	add    $0x10,%esp
}
80102275:	c9                   	leave  
80102276:	c3                   	ret    

80102277 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102277:	55                   	push   %ebp
80102278:	89 e5                	mov    %esp,%ebp
8010227a:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010227d:	8b 45 08             	mov    0x8(%ebp),%eax
80102280:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102284:	66 83 f8 01          	cmp    $0x1,%ax
80102288:	74 0d                	je     80102297 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010228a:	83 ec 0c             	sub    $0xc,%esp
8010228d:	68 9b 94 10 80       	push   $0x8010949b
80102292:	e8 cf e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010229e:	eb 7b                	jmp    8010231b <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a0:	6a 10                	push   $0x10
801022a2:	ff 75 f4             	pushl  -0xc(%ebp)
801022a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a8:	50                   	push   %eax
801022a9:	ff 75 08             	pushl  0x8(%ebp)
801022ac:	e8 cc fc ff ff       	call   80101f7d <readi>
801022b1:	83 c4 10             	add    $0x10,%esp
801022b4:	83 f8 10             	cmp    $0x10,%eax
801022b7:	74 0d                	je     801022c6 <dirlookup+0x4f>
      panic("dirlink read");
801022b9:	83 ec 0c             	sub    $0xc,%esp
801022bc:	68 ad 94 10 80       	push   $0x801094ad
801022c1:	e8 a0 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022c6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022ca:	66 85 c0             	test   %ax,%ax
801022cd:	74 47                	je     80102316 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022cf:	83 ec 08             	sub    $0x8,%esp
801022d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022d5:	83 c0 02             	add    $0x2,%eax
801022d8:	50                   	push   %eax
801022d9:	ff 75 0c             	pushl  0xc(%ebp)
801022dc:	e8 7b ff ff ff       	call   8010225c <namecmp>
801022e1:	83 c4 10             	add    $0x10,%esp
801022e4:	85 c0                	test   %eax,%eax
801022e6:	75 2f                	jne    80102317 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022ec:	74 08                	je     801022f6 <dirlookup+0x7f>
        *poff = off;
801022ee:	8b 45 10             	mov    0x10(%ebp),%eax
801022f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022f4:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022f6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022fa:	0f b7 c0             	movzwl %ax,%eax
801022fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102300:	8b 45 08             	mov    0x8(%ebp),%eax
80102303:	8b 00                	mov    (%eax),%eax
80102305:	83 ec 08             	sub    $0x8,%esp
80102308:	ff 75 f0             	pushl  -0x10(%ebp)
8010230b:	50                   	push   %eax
8010230c:	e8 e5 f5 ff ff       	call   801018f6 <iget>
80102311:	83 c4 10             	add    $0x10,%esp
80102314:	eb 19                	jmp    8010232f <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102316:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102317:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010231b:	8b 45 08             	mov    0x8(%ebp),%eax
8010231e:	8b 40 18             	mov    0x18(%eax),%eax
80102321:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102324:	0f 87 76 ff ff ff    	ja     801022a0 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
8010232a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010232f:	c9                   	leave  
80102330:	c3                   	ret    

80102331 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102331:	55                   	push   %ebp
80102332:	89 e5                	mov    %esp,%ebp
80102334:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	6a 00                	push   $0x0
8010233c:	ff 75 0c             	pushl  0xc(%ebp)
8010233f:	ff 75 08             	pushl  0x8(%ebp)
80102342:	e8 30 ff ff ff       	call   80102277 <dirlookup>
80102347:	83 c4 10             	add    $0x10,%esp
8010234a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010234d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102351:	74 18                	je     8010236b <dirlink+0x3a>
    iput(ip);
80102353:	83 ec 0c             	sub    $0xc,%esp
80102356:	ff 75 f0             	pushl  -0x10(%ebp)
80102359:	e8 81 f8 ff ff       	call   80101bdf <iput>
8010235e:	83 c4 10             	add    $0x10,%esp
    return -1;
80102361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102366:	e9 9c 00 00 00       	jmp    80102407 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010236b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102372:	eb 39                	jmp    801023ad <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102377:	6a 10                	push   $0x10
80102379:	50                   	push   %eax
8010237a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010237d:	50                   	push   %eax
8010237e:	ff 75 08             	pushl  0x8(%ebp)
80102381:	e8 f7 fb ff ff       	call   80101f7d <readi>
80102386:	83 c4 10             	add    $0x10,%esp
80102389:	83 f8 10             	cmp    $0x10,%eax
8010238c:	74 0d                	je     8010239b <dirlink+0x6a>
      panic("dirlink read");
8010238e:	83 ec 0c             	sub    $0xc,%esp
80102391:	68 ad 94 10 80       	push   $0x801094ad
80102396:	e8 cb e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010239b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010239f:	66 85 c0             	test   %ax,%ax
801023a2:	74 18                	je     801023bc <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a7:	83 c0 10             	add    $0x10,%eax
801023aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023ad:	8b 45 08             	mov    0x8(%ebp),%eax
801023b0:	8b 50 18             	mov    0x18(%eax),%edx
801023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b6:	39 c2                	cmp    %eax,%edx
801023b8:	77 ba                	ja     80102374 <dirlink+0x43>
801023ba:	eb 01                	jmp    801023bd <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801023bc:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023bd:	83 ec 04             	sub    $0x4,%esp
801023c0:	6a 0e                	push   $0xe
801023c2:	ff 75 0c             	pushl  0xc(%ebp)
801023c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023c8:	83 c0 02             	add    $0x2,%eax
801023cb:	50                   	push   %eax
801023cc:	e8 ae 3c 00 00       	call   8010607f <strncpy>
801023d1:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023d4:	8b 45 10             	mov    0x10(%ebp),%eax
801023d7:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023de:	6a 10                	push   $0x10
801023e0:	50                   	push   %eax
801023e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023e4:	50                   	push   %eax
801023e5:	ff 75 08             	pushl  0x8(%ebp)
801023e8:	e8 e7 fc ff ff       	call   801020d4 <writei>
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	83 f8 10             	cmp    $0x10,%eax
801023f3:	74 0d                	je     80102402 <dirlink+0xd1>
    panic("dirlink");
801023f5:	83 ec 0c             	sub    $0xc,%esp
801023f8:	68 ba 94 10 80       	push   $0x801094ba
801023fd:	e8 64 e1 ff ff       	call   80100566 <panic>
  
  return 0;
80102402:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102407:	c9                   	leave  
80102408:	c3                   	ret    

80102409 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102409:	55                   	push   %ebp
8010240a:	89 e5                	mov    %esp,%ebp
8010240c:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010240f:	eb 04                	jmp    80102415 <skipelem+0xc>
    path++;
80102411:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
80102418:	0f b6 00             	movzbl (%eax),%eax
8010241b:	3c 2f                	cmp    $0x2f,%al
8010241d:	74 f2                	je     80102411 <skipelem+0x8>
    path++;
  if(*path == 0)
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
80102422:	0f b6 00             	movzbl (%eax),%eax
80102425:	84 c0                	test   %al,%al
80102427:	75 07                	jne    80102430 <skipelem+0x27>
    return 0;
80102429:	b8 00 00 00 00       	mov    $0x0,%eax
8010242e:	eb 7b                	jmp    801024ab <skipelem+0xa2>
  s = path;
80102430:	8b 45 08             	mov    0x8(%ebp),%eax
80102433:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102436:	eb 04                	jmp    8010243c <skipelem+0x33>
    path++;
80102438:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010243c:	8b 45 08             	mov    0x8(%ebp),%eax
8010243f:	0f b6 00             	movzbl (%eax),%eax
80102442:	3c 2f                	cmp    $0x2f,%al
80102444:	74 0a                	je     80102450 <skipelem+0x47>
80102446:	8b 45 08             	mov    0x8(%ebp),%eax
80102449:	0f b6 00             	movzbl (%eax),%eax
8010244c:	84 c0                	test   %al,%al
8010244e:	75 e8                	jne    80102438 <skipelem+0x2f>
    path++;
  len = path - s;
80102450:	8b 55 08             	mov    0x8(%ebp),%edx
80102453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102456:	29 c2                	sub    %eax,%edx
80102458:	89 d0                	mov    %edx,%eax
8010245a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010245d:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102461:	7e 15                	jle    80102478 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
80102463:	83 ec 04             	sub    $0x4,%esp
80102466:	6a 0e                	push   $0xe
80102468:	ff 75 f4             	pushl  -0xc(%ebp)
8010246b:	ff 75 0c             	pushl  0xc(%ebp)
8010246e:	e8 20 3b 00 00       	call   80105f93 <memmove>
80102473:	83 c4 10             	add    $0x10,%esp
80102476:	eb 26                	jmp    8010249e <skipelem+0x95>
  else {
    memmove(name, s, len);
80102478:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010247b:	83 ec 04             	sub    $0x4,%esp
8010247e:	50                   	push   %eax
8010247f:	ff 75 f4             	pushl  -0xc(%ebp)
80102482:	ff 75 0c             	pushl  0xc(%ebp)
80102485:	e8 09 3b 00 00       	call   80105f93 <memmove>
8010248a:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010248d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102490:	8b 45 0c             	mov    0xc(%ebp),%eax
80102493:	01 d0                	add    %edx,%eax
80102495:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102498:	eb 04                	jmp    8010249e <skipelem+0x95>
    path++;
8010249a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010249e:	8b 45 08             	mov    0x8(%ebp),%eax
801024a1:	0f b6 00             	movzbl (%eax),%eax
801024a4:	3c 2f                	cmp    $0x2f,%al
801024a6:	74 f2                	je     8010249a <skipelem+0x91>
    path++;
  return path;
801024a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024ab:	c9                   	leave  
801024ac:	c3                   	ret    

801024ad <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024ad:	55                   	push   %ebp
801024ae:	89 e5                	mov    %esp,%ebp
801024b0:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024b3:	8b 45 08             	mov    0x8(%ebp),%eax
801024b6:	0f b6 00             	movzbl (%eax),%eax
801024b9:	3c 2f                	cmp    $0x2f,%al
801024bb:	75 17                	jne    801024d4 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801024bd:	83 ec 08             	sub    $0x8,%esp
801024c0:	6a 01                	push   $0x1
801024c2:	6a 01                	push   $0x1
801024c4:	e8 2d f4 ff ff       	call   801018f6 <iget>
801024c9:	83 c4 10             	add    $0x10,%esp
801024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024cf:	e9 bb 00 00 00       	jmp    8010258f <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024da:	8b 40 68             	mov    0x68(%eax),%eax
801024dd:	83 ec 0c             	sub    $0xc,%esp
801024e0:	50                   	push   %eax
801024e1:	e8 ef f4 ff ff       	call   801019d5 <idup>
801024e6:	83 c4 10             	add    $0x10,%esp
801024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024ec:	e9 9e 00 00 00       	jmp    8010258f <namex+0xe2>
    ilock(ip);
801024f1:	83 ec 0c             	sub    $0xc,%esp
801024f4:	ff 75 f4             	pushl  -0xc(%ebp)
801024f7:	e8 13 f5 ff ff       	call   80101a0f <ilock>
801024fc:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102502:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102506:	66 83 f8 01          	cmp    $0x1,%ax
8010250a:	74 18                	je     80102524 <namex+0x77>
      iunlockput(ip);
8010250c:	83 ec 0c             	sub    $0xc,%esp
8010250f:	ff 75 f4             	pushl  -0xc(%ebp)
80102512:	e8 b8 f7 ff ff       	call   80101ccf <iunlockput>
80102517:	83 c4 10             	add    $0x10,%esp
      return 0;
8010251a:	b8 00 00 00 00       	mov    $0x0,%eax
8010251f:	e9 a7 00 00 00       	jmp    801025cb <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102528:	74 20                	je     8010254a <namex+0x9d>
8010252a:	8b 45 08             	mov    0x8(%ebp),%eax
8010252d:	0f b6 00             	movzbl (%eax),%eax
80102530:	84 c0                	test   %al,%al
80102532:	75 16                	jne    8010254a <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102534:	83 ec 0c             	sub    $0xc,%esp
80102537:	ff 75 f4             	pushl  -0xc(%ebp)
8010253a:	e8 2e f6 ff ff       	call   80101b6d <iunlock>
8010253f:	83 c4 10             	add    $0x10,%esp
      return ip;
80102542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102545:	e9 81 00 00 00       	jmp    801025cb <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010254a:	83 ec 04             	sub    $0x4,%esp
8010254d:	6a 00                	push   $0x0
8010254f:	ff 75 10             	pushl  0x10(%ebp)
80102552:	ff 75 f4             	pushl  -0xc(%ebp)
80102555:	e8 1d fd ff ff       	call   80102277 <dirlookup>
8010255a:	83 c4 10             	add    $0x10,%esp
8010255d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102560:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102564:	75 15                	jne    8010257b <namex+0xce>
      iunlockput(ip);
80102566:	83 ec 0c             	sub    $0xc,%esp
80102569:	ff 75 f4             	pushl  -0xc(%ebp)
8010256c:	e8 5e f7 ff ff       	call   80101ccf <iunlockput>
80102571:	83 c4 10             	add    $0x10,%esp
      return 0;
80102574:	b8 00 00 00 00       	mov    $0x0,%eax
80102579:	eb 50                	jmp    801025cb <namex+0x11e>
    }
    iunlockput(ip);
8010257b:	83 ec 0c             	sub    $0xc,%esp
8010257e:	ff 75 f4             	pushl  -0xc(%ebp)
80102581:	e8 49 f7 ff ff       	call   80101ccf <iunlockput>
80102586:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102589:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010258f:	83 ec 08             	sub    $0x8,%esp
80102592:	ff 75 10             	pushl  0x10(%ebp)
80102595:	ff 75 08             	pushl  0x8(%ebp)
80102598:	e8 6c fe ff ff       	call   80102409 <skipelem>
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	89 45 08             	mov    %eax,0x8(%ebp)
801025a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a7:	0f 85 44 ff ff ff    	jne    801024f1 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025b1:	74 15                	je     801025c8 <namex+0x11b>
    iput(ip);
801025b3:	83 ec 0c             	sub    $0xc,%esp
801025b6:	ff 75 f4             	pushl  -0xc(%ebp)
801025b9:	e8 21 f6 ff ff       	call   80101bdf <iput>
801025be:	83 c4 10             	add    $0x10,%esp
    return 0;
801025c1:	b8 00 00 00 00       	mov    $0x0,%eax
801025c6:	eb 03                	jmp    801025cb <namex+0x11e>
  }
  return ip;
801025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025cb:	c9                   	leave  
801025cc:	c3                   	ret    

801025cd <namei>:

struct inode*
namei(char *path)
{
801025cd:	55                   	push   %ebp
801025ce:	89 e5                	mov    %esp,%ebp
801025d0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025d3:	83 ec 04             	sub    $0x4,%esp
801025d6:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025d9:	50                   	push   %eax
801025da:	6a 00                	push   $0x0
801025dc:	ff 75 08             	pushl  0x8(%ebp)
801025df:	e8 c9 fe ff ff       	call   801024ad <namex>
801025e4:	83 c4 10             	add    $0x10,%esp
}
801025e7:	c9                   	leave  
801025e8:	c3                   	ret    

801025e9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025e9:	55                   	push   %ebp
801025ea:	89 e5                	mov    %esp,%ebp
801025ec:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025ef:	83 ec 04             	sub    $0x4,%esp
801025f2:	ff 75 0c             	pushl  0xc(%ebp)
801025f5:	6a 01                	push   $0x1
801025f7:	ff 75 08             	pushl  0x8(%ebp)
801025fa:	e8 ae fe ff ff       	call   801024ad <namex>
801025ff:	83 c4 10             	add    $0x10,%esp
}
80102602:	c9                   	leave  
80102603:	c3                   	ret    

80102604 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	83 ec 14             	sub    $0x14,%esp
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
8010260d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102611:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102615:	89 c2                	mov    %eax,%edx
80102617:	ec                   	in     (%dx),%al
80102618:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010261b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010261f:	c9                   	leave  
80102620:	c3                   	ret    

80102621 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102621:	55                   	push   %ebp
80102622:	89 e5                	mov    %esp,%ebp
80102624:	57                   	push   %edi
80102625:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102626:	8b 55 08             	mov    0x8(%ebp),%edx
80102629:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010262c:	8b 45 10             	mov    0x10(%ebp),%eax
8010262f:	89 cb                	mov    %ecx,%ebx
80102631:	89 df                	mov    %ebx,%edi
80102633:	89 c1                	mov    %eax,%ecx
80102635:	fc                   	cld    
80102636:	f3 6d                	rep insl (%dx),%es:(%edi)
80102638:	89 c8                	mov    %ecx,%eax
8010263a:	89 fb                	mov    %edi,%ebx
8010263c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010263f:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102642:	90                   	nop
80102643:	5b                   	pop    %ebx
80102644:	5f                   	pop    %edi
80102645:	5d                   	pop    %ebp
80102646:	c3                   	ret    

80102647 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102647:	55                   	push   %ebp
80102648:	89 e5                	mov    %esp,%ebp
8010264a:	83 ec 08             	sub    $0x8,%esp
8010264d:	8b 55 08             	mov    0x8(%ebp),%edx
80102650:	8b 45 0c             	mov    0xc(%ebp),%eax
80102653:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102657:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010265e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102662:	ee                   	out    %al,(%dx)
}
80102663:	90                   	nop
80102664:	c9                   	leave  
80102665:	c3                   	ret    

80102666 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102666:	55                   	push   %ebp
80102667:	89 e5                	mov    %esp,%ebp
80102669:	56                   	push   %esi
8010266a:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010266b:	8b 55 08             	mov    0x8(%ebp),%edx
8010266e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102671:	8b 45 10             	mov    0x10(%ebp),%eax
80102674:	89 cb                	mov    %ecx,%ebx
80102676:	89 de                	mov    %ebx,%esi
80102678:	89 c1                	mov    %eax,%ecx
8010267a:	fc                   	cld    
8010267b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
8010267d:	89 c8                	mov    %ecx,%eax
8010267f:	89 f3                	mov    %esi,%ebx
80102681:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102684:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102687:	90                   	nop
80102688:	5b                   	pop    %ebx
80102689:	5e                   	pop    %esi
8010268a:	5d                   	pop    %ebp
8010268b:	c3                   	ret    

8010268c <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010268c:	55                   	push   %ebp
8010268d:	89 e5                	mov    %esp,%ebp
8010268f:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102692:	90                   	nop
80102693:	68 f7 01 00 00       	push   $0x1f7
80102698:	e8 67 ff ff ff       	call   80102604 <inb>
8010269d:	83 c4 04             	add    $0x4,%esp
801026a0:	0f b6 c0             	movzbl %al,%eax
801026a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
801026a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026a9:	25 c0 00 00 00       	and    $0xc0,%eax
801026ae:	83 f8 40             	cmp    $0x40,%eax
801026b1:	75 e0                	jne    80102693 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026b7:	74 11                	je     801026ca <idewait+0x3e>
801026b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026bc:	83 e0 21             	and    $0x21,%eax
801026bf:	85 c0                	test   %eax,%eax
801026c1:	74 07                	je     801026ca <idewait+0x3e>
    return -1;
801026c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026c8:	eb 05                	jmp    801026cf <idewait+0x43>
  return 0;
801026ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026cf:	c9                   	leave  
801026d0:	c3                   	ret    

801026d1 <ideinit>:

void
ideinit(void)
{
801026d1:	55                   	push   %ebp
801026d2:	89 e5                	mov    %esp,%ebp
801026d4:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026d7:	83 ec 08             	sub    $0x8,%esp
801026da:	68 c2 94 10 80       	push   $0x801094c2
801026df:	68 20 c6 10 80       	push   $0x8010c620
801026e4:	e8 66 35 00 00       	call   80105c4f <initlock>
801026e9:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026ec:	83 ec 0c             	sub    $0xc,%esp
801026ef:	6a 0e                	push   $0xe
801026f1:	e8 da 18 00 00       	call   80103fd0 <picenable>
801026f6:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026f9:	a1 60 39 11 80       	mov    0x80113960,%eax
801026fe:	83 e8 01             	sub    $0x1,%eax
80102701:	83 ec 08             	sub    $0x8,%esp
80102704:	50                   	push   %eax
80102705:	6a 0e                	push   $0xe
80102707:	e8 73 04 00 00       	call   80102b7f <ioapicenable>
8010270c:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010270f:	83 ec 0c             	sub    $0xc,%esp
80102712:	6a 00                	push   $0x0
80102714:	e8 73 ff ff ff       	call   8010268c <idewait>
80102719:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010271c:	83 ec 08             	sub    $0x8,%esp
8010271f:	68 f0 00 00 00       	push   $0xf0
80102724:	68 f6 01 00 00       	push   $0x1f6
80102729:	e8 19 ff ff ff       	call   80102647 <outb>
8010272e:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102738:	eb 24                	jmp    8010275e <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010273a:	83 ec 0c             	sub    $0xc,%esp
8010273d:	68 f7 01 00 00       	push   $0x1f7
80102742:	e8 bd fe ff ff       	call   80102604 <inb>
80102747:	83 c4 10             	add    $0x10,%esp
8010274a:	84 c0                	test   %al,%al
8010274c:	74 0c                	je     8010275a <ideinit+0x89>
      havedisk1 = 1;
8010274e:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
80102755:	00 00 00 
      break;
80102758:	eb 0d                	jmp    80102767 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010275a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010275e:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102765:	7e d3                	jle    8010273a <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102767:	83 ec 08             	sub    $0x8,%esp
8010276a:	68 e0 00 00 00       	push   $0xe0
8010276f:	68 f6 01 00 00       	push   $0x1f6
80102774:	e8 ce fe ff ff       	call   80102647 <outb>
80102779:	83 c4 10             	add    $0x10,%esp
}
8010277c:	90                   	nop
8010277d:	c9                   	leave  
8010277e:	c3                   	ret    

8010277f <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010277f:	55                   	push   %ebp
80102780:	89 e5                	mov    %esp,%ebp
80102782:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102785:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102789:	75 0d                	jne    80102798 <idestart+0x19>
    panic("idestart");
8010278b:	83 ec 0c             	sub    $0xc,%esp
8010278e:	68 c6 94 10 80       	push   $0x801094c6
80102793:	e8 ce dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102798:	8b 45 08             	mov    0x8(%ebp),%eax
8010279b:	8b 40 08             	mov    0x8(%eax),%eax
8010279e:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a3:	76 0d                	jbe    801027b2 <idestart+0x33>
    panic("incorrect blockno");
801027a5:	83 ec 0c             	sub    $0xc,%esp
801027a8:	68 cf 94 10 80       	push   $0x801094cf
801027ad:	e8 b4 dd ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027b2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027b9:	8b 45 08             	mov    0x8(%ebp),%eax
801027bc:	8b 50 08             	mov    0x8(%eax),%edx
801027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027c2:	0f af c2             	imul   %edx,%eax
801027c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027c8:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027cc:	7e 0d                	jle    801027db <idestart+0x5c>
801027ce:	83 ec 0c             	sub    $0xc,%esp
801027d1:	68 c6 94 10 80       	push   $0x801094c6
801027d6:	e8 8b dd ff ff       	call   80100566 <panic>
  
  idewait(0);
801027db:	83 ec 0c             	sub    $0xc,%esp
801027de:	6a 00                	push   $0x0
801027e0:	e8 a7 fe ff ff       	call   8010268c <idewait>
801027e5:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027e8:	83 ec 08             	sub    $0x8,%esp
801027eb:	6a 00                	push   $0x0
801027ed:	68 f6 03 00 00       	push   $0x3f6
801027f2:	e8 50 fe ff ff       	call   80102647 <outb>
801027f7:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fd:	0f b6 c0             	movzbl %al,%eax
80102800:	83 ec 08             	sub    $0x8,%esp
80102803:	50                   	push   %eax
80102804:	68 f2 01 00 00       	push   $0x1f2
80102809:	e8 39 fe ff ff       	call   80102647 <outb>
8010280e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102811:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102814:	0f b6 c0             	movzbl %al,%eax
80102817:	83 ec 08             	sub    $0x8,%esp
8010281a:	50                   	push   %eax
8010281b:	68 f3 01 00 00       	push   $0x1f3
80102820:	e8 22 fe ff ff       	call   80102647 <outb>
80102825:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010282b:	c1 f8 08             	sar    $0x8,%eax
8010282e:	0f b6 c0             	movzbl %al,%eax
80102831:	83 ec 08             	sub    $0x8,%esp
80102834:	50                   	push   %eax
80102835:	68 f4 01 00 00       	push   $0x1f4
8010283a:	e8 08 fe ff ff       	call   80102647 <outb>
8010283f:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102845:	c1 f8 10             	sar    $0x10,%eax
80102848:	0f b6 c0             	movzbl %al,%eax
8010284b:	83 ec 08             	sub    $0x8,%esp
8010284e:	50                   	push   %eax
8010284f:	68 f5 01 00 00       	push   $0x1f5
80102854:	e8 ee fd ff ff       	call   80102647 <outb>
80102859:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010285c:	8b 45 08             	mov    0x8(%ebp),%eax
8010285f:	8b 40 04             	mov    0x4(%eax),%eax
80102862:	83 e0 01             	and    $0x1,%eax
80102865:	c1 e0 04             	shl    $0x4,%eax
80102868:	89 c2                	mov    %eax,%edx
8010286a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010286d:	c1 f8 18             	sar    $0x18,%eax
80102870:	83 e0 0f             	and    $0xf,%eax
80102873:	09 d0                	or     %edx,%eax
80102875:	83 c8 e0             	or     $0xffffffe0,%eax
80102878:	0f b6 c0             	movzbl %al,%eax
8010287b:	83 ec 08             	sub    $0x8,%esp
8010287e:	50                   	push   %eax
8010287f:	68 f6 01 00 00       	push   $0x1f6
80102884:	e8 be fd ff ff       	call   80102647 <outb>
80102889:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010288c:	8b 45 08             	mov    0x8(%ebp),%eax
8010288f:	8b 00                	mov    (%eax),%eax
80102891:	83 e0 04             	and    $0x4,%eax
80102894:	85 c0                	test   %eax,%eax
80102896:	74 30                	je     801028c8 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102898:	83 ec 08             	sub    $0x8,%esp
8010289b:	6a 30                	push   $0x30
8010289d:	68 f7 01 00 00       	push   $0x1f7
801028a2:	e8 a0 fd ff ff       	call   80102647 <outb>
801028a7:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028aa:	8b 45 08             	mov    0x8(%ebp),%eax
801028ad:	83 c0 18             	add    $0x18,%eax
801028b0:	83 ec 04             	sub    $0x4,%esp
801028b3:	68 80 00 00 00       	push   $0x80
801028b8:	50                   	push   %eax
801028b9:	68 f0 01 00 00       	push   $0x1f0
801028be:	e8 a3 fd ff ff       	call   80102666 <outsl>
801028c3:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028c6:	eb 12                	jmp    801028da <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028c8:	83 ec 08             	sub    $0x8,%esp
801028cb:	6a 20                	push   $0x20
801028cd:	68 f7 01 00 00       	push   $0x1f7
801028d2:	e8 70 fd ff ff       	call   80102647 <outb>
801028d7:	83 c4 10             	add    $0x10,%esp
  }
}
801028da:	90                   	nop
801028db:	c9                   	leave  
801028dc:	c3                   	ret    

801028dd <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028dd:	55                   	push   %ebp
801028de:	89 e5                	mov    %esp,%ebp
801028e0:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028e3:	83 ec 0c             	sub    $0xc,%esp
801028e6:	68 20 c6 10 80       	push   $0x8010c620
801028eb:	e8 81 33 00 00       	call   80105c71 <acquire>
801028f0:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f3:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801028f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028ff:	75 15                	jne    80102916 <ideintr+0x39>
    release(&idelock);
80102901:	83 ec 0c             	sub    $0xc,%esp
80102904:	68 20 c6 10 80       	push   $0x8010c620
80102909:	e8 ca 33 00 00       	call   80105cd8 <release>
8010290e:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102911:	e9 9a 00 00 00       	jmp    801029b0 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102919:	8b 40 14             	mov    0x14(%eax),%eax
8010291c:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102924:	8b 00                	mov    (%eax),%eax
80102926:	83 e0 04             	and    $0x4,%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	75 2d                	jne    8010295a <ideintr+0x7d>
8010292d:	83 ec 0c             	sub    $0xc,%esp
80102930:	6a 01                	push   $0x1
80102932:	e8 55 fd ff ff       	call   8010268c <idewait>
80102937:	83 c4 10             	add    $0x10,%esp
8010293a:	85 c0                	test   %eax,%eax
8010293c:	78 1c                	js     8010295a <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102941:	83 c0 18             	add    $0x18,%eax
80102944:	83 ec 04             	sub    $0x4,%esp
80102947:	68 80 00 00 00       	push   $0x80
8010294c:	50                   	push   %eax
8010294d:	68 f0 01 00 00       	push   $0x1f0
80102952:	e8 ca fc ff ff       	call   80102621 <insl>
80102957:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010295d:	8b 00                	mov    (%eax),%eax
8010295f:	83 c8 02             	or     $0x2,%eax
80102962:	89 c2                	mov    %eax,%edx
80102964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102967:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296c:	8b 00                	mov    (%eax),%eax
8010296e:	83 e0 fb             	and    $0xfffffffb,%eax
80102971:	89 c2                	mov    %eax,%edx
80102973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102976:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	ff 75 f4             	pushl  -0xc(%ebp)
8010297e:	e8 fd 29 00 00       	call   80105380 <wakeup>
80102983:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102986:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010298b:	85 c0                	test   %eax,%eax
8010298d:	74 11                	je     801029a0 <ideintr+0xc3>
    idestart(idequeue);
8010298f:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102994:	83 ec 0c             	sub    $0xc,%esp
80102997:	50                   	push   %eax
80102998:	e8 e2 fd ff ff       	call   8010277f <idestart>
8010299d:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	68 20 c6 10 80       	push   $0x8010c620
801029a8:	e8 2b 33 00 00       	call   80105cd8 <release>
801029ad:	83 c4 10             	add    $0x10,%esp
}
801029b0:	c9                   	leave  
801029b1:	c3                   	ret    

801029b2 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029b2:	55                   	push   %ebp
801029b3:	89 e5                	mov    %esp,%ebp
801029b5:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801029b8:	8b 45 08             	mov    0x8(%ebp),%eax
801029bb:	8b 00                	mov    (%eax),%eax
801029bd:	83 e0 01             	and    $0x1,%eax
801029c0:	85 c0                	test   %eax,%eax
801029c2:	75 0d                	jne    801029d1 <iderw+0x1f>
    panic("iderw: buf not busy");
801029c4:	83 ec 0c             	sub    $0xc,%esp
801029c7:	68 e1 94 10 80       	push   $0x801094e1
801029cc:	e8 95 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d1:	8b 45 08             	mov    0x8(%ebp),%eax
801029d4:	8b 00                	mov    (%eax),%eax
801029d6:	83 e0 06             	and    $0x6,%eax
801029d9:	83 f8 02             	cmp    $0x2,%eax
801029dc:	75 0d                	jne    801029eb <iderw+0x39>
    panic("iderw: nothing to do");
801029de:	83 ec 0c             	sub    $0xc,%esp
801029e1:	68 f5 94 10 80       	push   $0x801094f5
801029e6:	e8 7b db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029eb:	8b 45 08             	mov    0x8(%ebp),%eax
801029ee:	8b 40 04             	mov    0x4(%eax),%eax
801029f1:	85 c0                	test   %eax,%eax
801029f3:	74 16                	je     80102a0b <iderw+0x59>
801029f5:	a1 58 c6 10 80       	mov    0x8010c658,%eax
801029fa:	85 c0                	test   %eax,%eax
801029fc:	75 0d                	jne    80102a0b <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029fe:	83 ec 0c             	sub    $0xc,%esp
80102a01:	68 0a 95 10 80       	push   $0x8010950a
80102a06:	e8 5b db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a0b:	83 ec 0c             	sub    $0xc,%esp
80102a0e:	68 20 c6 10 80       	push   $0x8010c620
80102a13:	e8 59 32 00 00       	call   80105c71 <acquire>
80102a18:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a25:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
80102a2c:	eb 0b                	jmp    80102a39 <iderw+0x87>
80102a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a31:	8b 00                	mov    (%eax),%eax
80102a33:	83 c0 14             	add    $0x14,%eax
80102a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3c:	8b 00                	mov    (%eax),%eax
80102a3e:	85 c0                	test   %eax,%eax
80102a40:	75 ec                	jne    80102a2e <iderw+0x7c>
    ;
  *pp = b;
80102a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a45:	8b 55 08             	mov    0x8(%ebp),%edx
80102a48:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a4a:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102a4f:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a52:	75 23                	jne    80102a77 <iderw+0xc5>
    idestart(b);
80102a54:	83 ec 0c             	sub    $0xc,%esp
80102a57:	ff 75 08             	pushl  0x8(%ebp)
80102a5a:	e8 20 fd ff ff       	call   8010277f <idestart>
80102a5f:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a62:	eb 13                	jmp    80102a77 <iderw+0xc5>
    sleep(b, &idelock);
80102a64:	83 ec 08             	sub    $0x8,%esp
80102a67:	68 20 c6 10 80       	push   $0x8010c620
80102a6c:	ff 75 08             	pushl  0x8(%ebp)
80102a6f:	e8 79 27 00 00       	call   801051ed <sleep>
80102a74:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a77:	8b 45 08             	mov    0x8(%ebp),%eax
80102a7a:	8b 00                	mov    (%eax),%eax
80102a7c:	83 e0 06             	and    $0x6,%eax
80102a7f:	83 f8 02             	cmp    $0x2,%eax
80102a82:	75 e0                	jne    80102a64 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a84:	83 ec 0c             	sub    $0xc,%esp
80102a87:	68 20 c6 10 80       	push   $0x8010c620
80102a8c:	e8 47 32 00 00       	call   80105cd8 <release>
80102a91:	83 c4 10             	add    $0x10,%esp
}
80102a94:	90                   	nop
80102a95:	c9                   	leave  
80102a96:	c3                   	ret    

80102a97 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a97:	55                   	push   %ebp
80102a98:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a9a:	a1 34 32 11 80       	mov    0x80113234,%eax
80102a9f:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa2:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa4:	a1 34 32 11 80       	mov    0x80113234,%eax
80102aa9:	8b 40 10             	mov    0x10(%eax),%eax
}
80102aac:	5d                   	pop    %ebp
80102aad:	c3                   	ret    

80102aae <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102aae:	55                   	push   %ebp
80102aaf:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102ab1:	a1 34 32 11 80       	mov    0x80113234,%eax
80102ab6:	8b 55 08             	mov    0x8(%ebp),%edx
80102ab9:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102abb:	a1 34 32 11 80       	mov    0x80113234,%eax
80102ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
80102ac3:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ac6:	90                   	nop
80102ac7:	5d                   	pop    %ebp
80102ac8:	c3                   	ret    

80102ac9 <ioapicinit>:

void
ioapicinit(void)
{
80102ac9:	55                   	push   %ebp
80102aca:	89 e5                	mov    %esp,%ebp
80102acc:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102acf:	a1 64 33 11 80       	mov    0x80113364,%eax
80102ad4:	85 c0                	test   %eax,%eax
80102ad6:	0f 84 a0 00 00 00    	je     80102b7c <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102adc:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
80102ae3:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ae6:	6a 01                	push   $0x1
80102ae8:	e8 aa ff ff ff       	call   80102a97 <ioapicread>
80102aed:	83 c4 04             	add    $0x4,%esp
80102af0:	c1 e8 10             	shr    $0x10,%eax
80102af3:	25 ff 00 00 00       	and    $0xff,%eax
80102af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102afb:	6a 00                	push   $0x0
80102afd:	e8 95 ff ff ff       	call   80102a97 <ioapicread>
80102b02:	83 c4 04             	add    $0x4,%esp
80102b05:	c1 e8 18             	shr    $0x18,%eax
80102b08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b0b:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102b12:	0f b6 c0             	movzbl %al,%eax
80102b15:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b18:	74 10                	je     80102b2a <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1a:	83 ec 0c             	sub    $0xc,%esp
80102b1d:	68 28 95 10 80       	push   $0x80109528
80102b22:	e8 9f d8 ff ff       	call   801003c6 <cprintf>
80102b27:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b31:	eb 3f                	jmp    80102b72 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b36:	83 c0 20             	add    $0x20,%eax
80102b39:	0d 00 00 01 00       	or     $0x10000,%eax
80102b3e:	89 c2                	mov    %eax,%edx
80102b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b43:	83 c0 08             	add    $0x8,%eax
80102b46:	01 c0                	add    %eax,%eax
80102b48:	83 ec 08             	sub    $0x8,%esp
80102b4b:	52                   	push   %edx
80102b4c:	50                   	push   %eax
80102b4d:	e8 5c ff ff ff       	call   80102aae <ioapicwrite>
80102b52:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b58:	83 c0 08             	add    $0x8,%eax
80102b5b:	01 c0                	add    %eax,%eax
80102b5d:	83 c0 01             	add    $0x1,%eax
80102b60:	83 ec 08             	sub    $0x8,%esp
80102b63:	6a 00                	push   $0x0
80102b65:	50                   	push   %eax
80102b66:	e8 43 ff ff ff       	call   80102aae <ioapicwrite>
80102b6b:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b78:	7e b9                	jle    80102b33 <ioapicinit+0x6a>
80102b7a:	eb 01                	jmp    80102b7d <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b7c:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    

80102b7f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b7f:	55                   	push   %ebp
80102b80:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b82:	a1 64 33 11 80       	mov    0x80113364,%eax
80102b87:	85 c0                	test   %eax,%eax
80102b89:	74 39                	je     80102bc4 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8e:	83 c0 20             	add    $0x20,%eax
80102b91:	89 c2                	mov    %eax,%edx
80102b93:	8b 45 08             	mov    0x8(%ebp),%eax
80102b96:	83 c0 08             	add    $0x8,%eax
80102b99:	01 c0                	add    %eax,%eax
80102b9b:	52                   	push   %edx
80102b9c:	50                   	push   %eax
80102b9d:	e8 0c ff ff ff       	call   80102aae <ioapicwrite>
80102ba2:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ba8:	c1 e0 18             	shl    $0x18,%eax
80102bab:	89 c2                	mov    %eax,%edx
80102bad:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb0:	83 c0 08             	add    $0x8,%eax
80102bb3:	01 c0                	add    %eax,%eax
80102bb5:	83 c0 01             	add    $0x1,%eax
80102bb8:	52                   	push   %edx
80102bb9:	50                   	push   %eax
80102bba:	e8 ef fe ff ff       	call   80102aae <ioapicwrite>
80102bbf:	83 c4 08             	add    $0x8,%esp
80102bc2:	eb 01                	jmp    80102bc5 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102bc4:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102bc5:	c9                   	leave  
80102bc6:	c3                   	ret    

80102bc7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bc7:	55                   	push   %ebp
80102bc8:	89 e5                	mov    %esp,%ebp
80102bca:	8b 45 08             	mov    0x8(%ebp),%eax
80102bcd:	05 00 00 00 80       	add    $0x80000000,%eax
80102bd2:	5d                   	pop    %ebp
80102bd3:	c3                   	ret    

80102bd4 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bd4:	55                   	push   %ebp
80102bd5:	89 e5                	mov    %esp,%ebp
80102bd7:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bda:	83 ec 08             	sub    $0x8,%esp
80102bdd:	68 5a 95 10 80       	push   $0x8010955a
80102be2:	68 40 32 11 80       	push   $0x80113240
80102be7:	e8 63 30 00 00       	call   80105c4f <initlock>
80102bec:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bef:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102bf6:	00 00 00 
  freerange(vstart, vend);
80102bf9:	83 ec 08             	sub    $0x8,%esp
80102bfc:	ff 75 0c             	pushl  0xc(%ebp)
80102bff:	ff 75 08             	pushl  0x8(%ebp)
80102c02:	e8 2a 00 00 00       	call   80102c31 <freerange>
80102c07:	83 c4 10             	add    $0x10,%esp
}
80102c0a:	90                   	nop
80102c0b:	c9                   	leave  
80102c0c:	c3                   	ret    

80102c0d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c0d:	55                   	push   %ebp
80102c0e:	89 e5                	mov    %esp,%ebp
80102c10:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c13:	83 ec 08             	sub    $0x8,%esp
80102c16:	ff 75 0c             	pushl  0xc(%ebp)
80102c19:	ff 75 08             	pushl  0x8(%ebp)
80102c1c:	e8 10 00 00 00       	call   80102c31 <freerange>
80102c21:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c24:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102c2b:	00 00 00 
}
80102c2e:	90                   	nop
80102c2f:	c9                   	leave  
80102c30:	c3                   	ret    

80102c31 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c31:	55                   	push   %ebp
80102c32:	89 e5                	mov    %esp,%ebp
80102c34:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c37:	8b 45 08             	mov    0x8(%ebp),%eax
80102c3a:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c47:	eb 15                	jmp    80102c5e <freerange+0x2d>
    kfree(p);
80102c49:	83 ec 0c             	sub    $0xc,%esp
80102c4c:	ff 75 f4             	pushl  -0xc(%ebp)
80102c4f:	e8 1a 00 00 00       	call   80102c6e <kfree>
80102c54:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c57:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c61:	05 00 10 00 00       	add    $0x1000,%eax
80102c66:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c69:	76 de                	jbe    80102c49 <freerange+0x18>
    kfree(p);
}
80102c6b:	90                   	nop
80102c6c:	c9                   	leave  
80102c6d:	c3                   	ret    

80102c6e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c6e:	55                   	push   %ebp
80102c6f:	89 e5                	mov    %esp,%ebp
80102c71:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c74:	8b 45 08             	mov    0x8(%ebp),%eax
80102c77:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c7c:	85 c0                	test   %eax,%eax
80102c7e:	75 1b                	jne    80102c9b <kfree+0x2d>
80102c80:	81 7d 08 3c 67 11 80 	cmpl   $0x8011673c,0x8(%ebp)
80102c87:	72 12                	jb     80102c9b <kfree+0x2d>
80102c89:	ff 75 08             	pushl  0x8(%ebp)
80102c8c:	e8 36 ff ff ff       	call   80102bc7 <v2p>
80102c91:	83 c4 04             	add    $0x4,%esp
80102c94:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c99:	76 0d                	jbe    80102ca8 <kfree+0x3a>
    panic("kfree");
80102c9b:	83 ec 0c             	sub    $0xc,%esp
80102c9e:	68 5f 95 10 80       	push   $0x8010955f
80102ca3:	e8 be d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca8:	83 ec 04             	sub    $0x4,%esp
80102cab:	68 00 10 00 00       	push   $0x1000
80102cb0:	6a 01                	push   $0x1
80102cb2:	ff 75 08             	pushl  0x8(%ebp)
80102cb5:	e8 1a 32 00 00       	call   80105ed4 <memset>
80102cba:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cbd:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cc2:	85 c0                	test   %eax,%eax
80102cc4:	74 10                	je     80102cd6 <kfree+0x68>
    acquire(&kmem.lock);
80102cc6:	83 ec 0c             	sub    $0xc,%esp
80102cc9:	68 40 32 11 80       	push   $0x80113240
80102cce:	e8 9e 2f 00 00       	call   80105c71 <acquire>
80102cd3:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cdc:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce5:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cea:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102cef:	a1 74 32 11 80       	mov    0x80113274,%eax
80102cf4:	85 c0                	test   %eax,%eax
80102cf6:	74 10                	je     80102d08 <kfree+0x9a>
    release(&kmem.lock);
80102cf8:	83 ec 0c             	sub    $0xc,%esp
80102cfb:	68 40 32 11 80       	push   $0x80113240
80102d00:	e8 d3 2f 00 00       	call   80105cd8 <release>
80102d05:	83 c4 10             	add    $0x10,%esp
}
80102d08:	90                   	nop
80102d09:	c9                   	leave  
80102d0a:	c3                   	ret    

80102d0b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d0b:	55                   	push   %ebp
80102d0c:	89 e5                	mov    %esp,%ebp
80102d0e:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d11:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d16:	85 c0                	test   %eax,%eax
80102d18:	74 10                	je     80102d2a <kalloc+0x1f>
    acquire(&kmem.lock);
80102d1a:	83 ec 0c             	sub    $0xc,%esp
80102d1d:	68 40 32 11 80       	push   $0x80113240
80102d22:	e8 4a 2f 00 00       	call   80105c71 <acquire>
80102d27:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d2a:	a1 78 32 11 80       	mov    0x80113278,%eax
80102d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d36:	74 0a                	je     80102d42 <kalloc+0x37>
    kmem.freelist = r->next;
80102d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3b:	8b 00                	mov    (%eax),%eax
80102d3d:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102d42:	a1 74 32 11 80       	mov    0x80113274,%eax
80102d47:	85 c0                	test   %eax,%eax
80102d49:	74 10                	je     80102d5b <kalloc+0x50>
    release(&kmem.lock);
80102d4b:	83 ec 0c             	sub    $0xc,%esp
80102d4e:	68 40 32 11 80       	push   $0x80113240
80102d53:	e8 80 2f 00 00       	call   80105cd8 <release>
80102d58:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d5e:	c9                   	leave  
80102d5f:	c3                   	ret    

80102d60 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
80102d66:	8b 45 08             	mov    0x8(%ebp),%eax
80102d69:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d6d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d71:	89 c2                	mov    %eax,%edx
80102d73:	ec                   	in     (%dx),%al
80102d74:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d77:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d7b:	c9                   	leave  
80102d7c:	c3                   	ret    

80102d7d <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d7d:	55                   	push   %ebp
80102d7e:	89 e5                	mov    %esp,%ebp
80102d80:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d83:	6a 64                	push   $0x64
80102d85:	e8 d6 ff ff ff       	call   80102d60 <inb>
80102d8a:	83 c4 04             	add    $0x4,%esp
80102d8d:	0f b6 c0             	movzbl %al,%eax
80102d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d96:	83 e0 01             	and    $0x1,%eax
80102d99:	85 c0                	test   %eax,%eax
80102d9b:	75 0a                	jne    80102da7 <kbdgetc+0x2a>
    return -1;
80102d9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102da2:	e9 23 01 00 00       	jmp    80102eca <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102da7:	6a 60                	push   $0x60
80102da9:	e8 b2 ff ff ff       	call   80102d60 <inb>
80102dae:	83 c4 04             	add    $0x4,%esp
80102db1:	0f b6 c0             	movzbl %al,%eax
80102db4:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102db7:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102dbe:	75 17                	jne    80102dd7 <kbdgetc+0x5a>
    shift |= E0ESC;
80102dc0:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102dc5:	83 c8 40             	or     $0x40,%eax
80102dc8:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102dcd:	b8 00 00 00 00       	mov    $0x0,%eax
80102dd2:	e9 f3 00 00 00       	jmp    80102eca <kbdgetc+0x14d>
  } else if(data & 0x80){
80102dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dda:	25 80 00 00 00       	and    $0x80,%eax
80102ddf:	85 c0                	test   %eax,%eax
80102de1:	74 45                	je     80102e28 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102de3:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102de8:	83 e0 40             	and    $0x40,%eax
80102deb:	85 c0                	test   %eax,%eax
80102ded:	75 08                	jne    80102df7 <kbdgetc+0x7a>
80102def:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df2:	83 e0 7f             	and    $0x7f,%eax
80102df5:	eb 03                	jmp    80102dfa <kbdgetc+0x7d>
80102df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e00:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e05:	0f b6 00             	movzbl (%eax),%eax
80102e08:	83 c8 40             	or     $0x40,%eax
80102e0b:	0f b6 c0             	movzbl %al,%eax
80102e0e:	f7 d0                	not    %eax
80102e10:	89 c2                	mov    %eax,%edx
80102e12:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e17:	21 d0                	and    %edx,%eax
80102e19:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102e1e:	b8 00 00 00 00       	mov    $0x0,%eax
80102e23:	e9 a2 00 00 00       	jmp    80102eca <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e28:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e2d:	83 e0 40             	and    $0x40,%eax
80102e30:	85 c0                	test   %eax,%eax
80102e32:	74 14                	je     80102e48 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e34:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e3b:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e40:	83 e0 bf             	and    $0xffffffbf,%eax
80102e43:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e4b:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102e50:	0f b6 00             	movzbl (%eax),%eax
80102e53:	0f b6 d0             	movzbl %al,%edx
80102e56:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e5b:	09 d0                	or     %edx,%eax
80102e5d:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e65:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102e6a:	0f b6 00             	movzbl (%eax),%eax
80102e6d:	0f b6 d0             	movzbl %al,%edx
80102e70:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e75:	31 d0                	xor    %edx,%eax
80102e77:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e7c:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e81:	83 e0 03             	and    $0x3,%eax
80102e84:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e8e:	01 d0                	add    %edx,%eax
80102e90:	0f b6 00             	movzbl (%eax),%eax
80102e93:	0f b6 c0             	movzbl %al,%eax
80102e96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e99:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102e9e:	83 e0 08             	and    $0x8,%eax
80102ea1:	85 c0                	test   %eax,%eax
80102ea3:	74 22                	je     80102ec7 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102ea5:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ea9:	76 0c                	jbe    80102eb7 <kbdgetc+0x13a>
80102eab:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102eaf:	77 06                	ja     80102eb7 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102eb1:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102eb5:	eb 10                	jmp    80102ec7 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102eb7:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ebb:	76 0a                	jbe    80102ec7 <kbdgetc+0x14a>
80102ebd:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ec1:	77 04                	ja     80102ec7 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ec3:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102eca:	c9                   	leave  
80102ecb:	c3                   	ret    

80102ecc <kbdintr>:

void
kbdintr(void)
{
80102ecc:	55                   	push   %ebp
80102ecd:	89 e5                	mov    %esp,%ebp
80102ecf:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ed2:	83 ec 0c             	sub    $0xc,%esp
80102ed5:	68 7d 2d 10 80       	push   $0x80102d7d
80102eda:	e8 1a d9 ff ff       	call   801007f9 <consoleintr>
80102edf:	83 c4 10             	add    $0x10,%esp
}
80102ee2:	90                   	nop
80102ee3:	c9                   	leave  
80102ee4:	c3                   	ret    

80102ee5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ee5:	55                   	push   %ebp
80102ee6:	89 e5                	mov    %esp,%ebp
80102ee8:	83 ec 14             	sub    $0x14,%esp
80102eeb:	8b 45 08             	mov    0x8(%ebp),%eax
80102eee:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ef6:	89 c2                	mov    %eax,%edx
80102ef8:	ec                   	in     (%dx),%al
80102ef9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102efc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f00:	c9                   	leave  
80102f01:	c3                   	ret    

80102f02 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102f02:	55                   	push   %ebp
80102f03:	89 e5                	mov    %esp,%ebp
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	8b 55 08             	mov    0x8(%ebp),%edx
80102f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f0e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102f12:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f15:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f19:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f1d:	ee                   	out    %al,(%dx)
}
80102f1e:	90                   	nop
80102f1f:	c9                   	leave  
80102f20:	c3                   	ret    

80102f21 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102f21:	55                   	push   %ebp
80102f22:	89 e5                	mov    %esp,%ebp
80102f24:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f27:	9c                   	pushf  
80102f28:	58                   	pop    %eax
80102f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f2f:	c9                   	leave  
80102f30:	c3                   	ret    

80102f31 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f31:	55                   	push   %ebp
80102f32:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f34:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f39:	8b 55 08             	mov    0x8(%ebp),%edx
80102f3c:	c1 e2 02             	shl    $0x2,%edx
80102f3f:	01 c2                	add    %eax,%edx
80102f41:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f44:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f46:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f4b:	83 c0 20             	add    $0x20,%eax
80102f4e:	8b 00                	mov    (%eax),%eax
}
80102f50:	90                   	nop
80102f51:	5d                   	pop    %ebp
80102f52:	c3                   	ret    

80102f53 <lapicinit>:

void
lapicinit(void)
{
80102f53:	55                   	push   %ebp
80102f54:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f56:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f5b:	85 c0                	test   %eax,%eax
80102f5d:	0f 84 0b 01 00 00    	je     8010306e <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f63:	68 3f 01 00 00       	push   $0x13f
80102f68:	6a 3c                	push   $0x3c
80102f6a:	e8 c2 ff ff ff       	call   80102f31 <lapicw>
80102f6f:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f72:	6a 0b                	push   $0xb
80102f74:	68 f8 00 00 00       	push   $0xf8
80102f79:	e8 b3 ff ff ff       	call   80102f31 <lapicw>
80102f7e:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f81:	68 20 00 02 00       	push   $0x20020
80102f86:	68 c8 00 00 00       	push   $0xc8
80102f8b:	e8 a1 ff ff ff       	call   80102f31 <lapicw>
80102f90:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80102f93:	68 40 42 0f 00       	push   $0xf4240
80102f98:	68 e0 00 00 00       	push   $0xe0
80102f9d:	e8 8f ff ff ff       	call   80102f31 <lapicw>
80102fa2:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102fa5:	68 00 00 01 00       	push   $0x10000
80102faa:	68 d4 00 00 00       	push   $0xd4
80102faf:	e8 7d ff ff ff       	call   80102f31 <lapicw>
80102fb4:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102fb7:	68 00 00 01 00       	push   $0x10000
80102fbc:	68 d8 00 00 00       	push   $0xd8
80102fc1:	e8 6b ff ff ff       	call   80102f31 <lapicw>
80102fc6:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fc9:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102fce:	83 c0 30             	add    $0x30,%eax
80102fd1:	8b 00                	mov    (%eax),%eax
80102fd3:	c1 e8 10             	shr    $0x10,%eax
80102fd6:	0f b6 c0             	movzbl %al,%eax
80102fd9:	83 f8 03             	cmp    $0x3,%eax
80102fdc:	76 12                	jbe    80102ff0 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fde:	68 00 00 01 00       	push   $0x10000
80102fe3:	68 d0 00 00 00       	push   $0xd0
80102fe8:	e8 44 ff ff ff       	call   80102f31 <lapicw>
80102fed:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ff0:	6a 33                	push   $0x33
80102ff2:	68 dc 00 00 00       	push   $0xdc
80102ff7:	e8 35 ff ff ff       	call   80102f31 <lapicw>
80102ffc:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102fff:	6a 00                	push   $0x0
80103001:	68 a0 00 00 00       	push   $0xa0
80103006:	e8 26 ff ff ff       	call   80102f31 <lapicw>
8010300b:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010300e:	6a 00                	push   $0x0
80103010:	68 a0 00 00 00       	push   $0xa0
80103015:	e8 17 ff ff ff       	call   80102f31 <lapicw>
8010301a:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
8010301d:	6a 00                	push   $0x0
8010301f:	6a 2c                	push   $0x2c
80103021:	e8 0b ff ff ff       	call   80102f31 <lapicw>
80103026:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103029:	6a 00                	push   $0x0
8010302b:	68 c4 00 00 00       	push   $0xc4
80103030:	e8 fc fe ff ff       	call   80102f31 <lapicw>
80103035:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103038:	68 00 85 08 00       	push   $0x88500
8010303d:	68 c0 00 00 00       	push   $0xc0
80103042:	e8 ea fe ff ff       	call   80102f31 <lapicw>
80103047:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
8010304a:	90                   	nop
8010304b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80103050:	05 00 03 00 00       	add    $0x300,%eax
80103055:	8b 00                	mov    (%eax),%eax
80103057:	25 00 10 00 00       	and    $0x1000,%eax
8010305c:	85 c0                	test   %eax,%eax
8010305e:	75 eb                	jne    8010304b <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103060:	6a 00                	push   $0x0
80103062:	6a 20                	push   $0x20
80103064:	e8 c8 fe ff ff       	call   80102f31 <lapicw>
80103069:	83 c4 08             	add    $0x8,%esp
8010306c:	eb 01                	jmp    8010306f <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
8010306e:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
8010306f:	c9                   	leave  
80103070:	c3                   	ret    

80103071 <cpunum>:

int
cpunum(void)
{
80103071:	55                   	push   %ebp
80103072:	89 e5                	mov    %esp,%ebp
80103074:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103077:	e8 a5 fe ff ff       	call   80102f21 <readeflags>
8010307c:	25 00 02 00 00       	and    $0x200,%eax
80103081:	85 c0                	test   %eax,%eax
80103083:	74 26                	je     801030ab <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103085:	a1 60 c6 10 80       	mov    0x8010c660,%eax
8010308a:	8d 50 01             	lea    0x1(%eax),%edx
8010308d:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80103093:	85 c0                	test   %eax,%eax
80103095:	75 14                	jne    801030ab <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103097:	8b 45 04             	mov    0x4(%ebp),%eax
8010309a:	83 ec 08             	sub    $0x8,%esp
8010309d:	50                   	push   %eax
8010309e:	68 68 95 10 80       	push   $0x80109568
801030a3:	e8 1e d3 ff ff       	call   801003c6 <cprintf>
801030a8:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030ab:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030b0:	85 c0                	test   %eax,%eax
801030b2:	74 0f                	je     801030c3 <cpunum+0x52>
    return lapic[ID]>>24;
801030b4:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030b9:	83 c0 20             	add    $0x20,%eax
801030bc:	8b 00                	mov    (%eax),%eax
801030be:	c1 e8 18             	shr    $0x18,%eax
801030c1:	eb 05                	jmp    801030c8 <cpunum+0x57>
  return 0;
801030c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801030c8:	c9                   	leave  
801030c9:	c3                   	ret    

801030ca <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030ca:	55                   	push   %ebp
801030cb:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030cd:	a1 7c 32 11 80       	mov    0x8011327c,%eax
801030d2:	85 c0                	test   %eax,%eax
801030d4:	74 0c                	je     801030e2 <lapiceoi+0x18>
    lapicw(EOI, 0);
801030d6:	6a 00                	push   $0x0
801030d8:	6a 2c                	push   $0x2c
801030da:	e8 52 fe ff ff       	call   80102f31 <lapicw>
801030df:	83 c4 08             	add    $0x8,%esp
}
801030e2:	90                   	nop
801030e3:	c9                   	leave  
801030e4:	c3                   	ret    

801030e5 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030e5:	55                   	push   %ebp
801030e6:	89 e5                	mov    %esp,%ebp
}
801030e8:	90                   	nop
801030e9:	5d                   	pop    %ebp
801030ea:	c3                   	ret    

801030eb <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030eb:	55                   	push   %ebp
801030ec:	89 e5                	mov    %esp,%ebp
801030ee:	83 ec 14             	sub    $0x14,%esp
801030f1:	8b 45 08             	mov    0x8(%ebp),%eax
801030f4:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030f7:	6a 0f                	push   $0xf
801030f9:	6a 70                	push   $0x70
801030fb:	e8 02 fe ff ff       	call   80102f02 <outb>
80103100:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103103:	6a 0a                	push   $0xa
80103105:	6a 71                	push   $0x71
80103107:	e8 f6 fd ff ff       	call   80102f02 <outb>
8010310c:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010310f:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103116:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103119:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010311e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103121:	83 c0 02             	add    $0x2,%eax
80103124:	8b 55 0c             	mov    0xc(%ebp),%edx
80103127:	c1 ea 04             	shr    $0x4,%edx
8010312a:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010312d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103131:	c1 e0 18             	shl    $0x18,%eax
80103134:	50                   	push   %eax
80103135:	68 c4 00 00 00       	push   $0xc4
8010313a:	e8 f2 fd ff ff       	call   80102f31 <lapicw>
8010313f:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103142:	68 00 c5 00 00       	push   $0xc500
80103147:	68 c0 00 00 00       	push   $0xc0
8010314c:	e8 e0 fd ff ff       	call   80102f31 <lapicw>
80103151:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103154:	68 c8 00 00 00       	push   $0xc8
80103159:	e8 87 ff ff ff       	call   801030e5 <microdelay>
8010315e:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103161:	68 00 85 00 00       	push   $0x8500
80103166:	68 c0 00 00 00       	push   $0xc0
8010316b:	e8 c1 fd ff ff       	call   80102f31 <lapicw>
80103170:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103173:	6a 64                	push   $0x64
80103175:	e8 6b ff ff ff       	call   801030e5 <microdelay>
8010317a:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010317d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103184:	eb 3d                	jmp    801031c3 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103186:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010318a:	c1 e0 18             	shl    $0x18,%eax
8010318d:	50                   	push   %eax
8010318e:	68 c4 00 00 00       	push   $0xc4
80103193:	e8 99 fd ff ff       	call   80102f31 <lapicw>
80103198:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010319b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010319e:	c1 e8 0c             	shr    $0xc,%eax
801031a1:	80 cc 06             	or     $0x6,%ah
801031a4:	50                   	push   %eax
801031a5:	68 c0 00 00 00       	push   $0xc0
801031aa:	e8 82 fd ff ff       	call   80102f31 <lapicw>
801031af:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801031b2:	68 c8 00 00 00       	push   $0xc8
801031b7:	e8 29 ff ff ff       	call   801030e5 <microdelay>
801031bc:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031bf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031c3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031c7:	7e bd                	jle    80103186 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031c9:	90                   	nop
801031ca:	c9                   	leave  
801031cb:	c3                   	ret    

801031cc <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031cc:	55                   	push   %ebp
801031cd:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031cf:	8b 45 08             	mov    0x8(%ebp),%eax
801031d2:	0f b6 c0             	movzbl %al,%eax
801031d5:	50                   	push   %eax
801031d6:	6a 70                	push   $0x70
801031d8:	e8 25 fd ff ff       	call   80102f02 <outb>
801031dd:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031e0:	68 c8 00 00 00       	push   $0xc8
801031e5:	e8 fb fe ff ff       	call   801030e5 <microdelay>
801031ea:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031ed:	6a 71                	push   $0x71
801031ef:	e8 f1 fc ff ff       	call   80102ee5 <inb>
801031f4:	83 c4 04             	add    $0x4,%esp
801031f7:	0f b6 c0             	movzbl %al,%eax
}
801031fa:	c9                   	leave  
801031fb:	c3                   	ret    

801031fc <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031fc:	55                   	push   %ebp
801031fd:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031ff:	6a 00                	push   $0x0
80103201:	e8 c6 ff ff ff       	call   801031cc <cmos_read>
80103206:	83 c4 04             	add    $0x4,%esp
80103209:	89 c2                	mov    %eax,%edx
8010320b:	8b 45 08             	mov    0x8(%ebp),%eax
8010320e:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103210:	6a 02                	push   $0x2
80103212:	e8 b5 ff ff ff       	call   801031cc <cmos_read>
80103217:	83 c4 04             	add    $0x4,%esp
8010321a:	89 c2                	mov    %eax,%edx
8010321c:	8b 45 08             	mov    0x8(%ebp),%eax
8010321f:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103222:	6a 04                	push   $0x4
80103224:	e8 a3 ff ff ff       	call   801031cc <cmos_read>
80103229:	83 c4 04             	add    $0x4,%esp
8010322c:	89 c2                	mov    %eax,%edx
8010322e:	8b 45 08             	mov    0x8(%ebp),%eax
80103231:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103234:	6a 07                	push   $0x7
80103236:	e8 91 ff ff ff       	call   801031cc <cmos_read>
8010323b:	83 c4 04             	add    $0x4,%esp
8010323e:	89 c2                	mov    %eax,%edx
80103240:	8b 45 08             	mov    0x8(%ebp),%eax
80103243:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103246:	6a 08                	push   $0x8
80103248:	e8 7f ff ff ff       	call   801031cc <cmos_read>
8010324d:	83 c4 04             	add    $0x4,%esp
80103250:	89 c2                	mov    %eax,%edx
80103252:	8b 45 08             	mov    0x8(%ebp),%eax
80103255:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103258:	6a 09                	push   $0x9
8010325a:	e8 6d ff ff ff       	call   801031cc <cmos_read>
8010325f:	83 c4 04             	add    $0x4,%esp
80103262:	89 c2                	mov    %eax,%edx
80103264:	8b 45 08             	mov    0x8(%ebp),%eax
80103267:	89 50 14             	mov    %edx,0x14(%eax)
}
8010326a:	90                   	nop
8010326b:	c9                   	leave  
8010326c:	c3                   	ret    

8010326d <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010326d:	55                   	push   %ebp
8010326e:	89 e5                	mov    %esp,%ebp
80103270:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103273:	6a 0b                	push   $0xb
80103275:	e8 52 ff ff ff       	call   801031cc <cmos_read>
8010327a:	83 c4 04             	add    $0x4,%esp
8010327d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103283:	83 e0 04             	and    $0x4,%eax
80103286:	85 c0                	test   %eax,%eax
80103288:	0f 94 c0             	sete   %al
8010328b:	0f b6 c0             	movzbl %al,%eax
8010328e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103291:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103294:	50                   	push   %eax
80103295:	e8 62 ff ff ff       	call   801031fc <fill_rtcdate>
8010329a:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010329d:	6a 0a                	push   $0xa
8010329f:	e8 28 ff ff ff       	call   801031cc <cmos_read>
801032a4:	83 c4 04             	add    $0x4,%esp
801032a7:	25 80 00 00 00       	and    $0x80,%eax
801032ac:	85 c0                	test   %eax,%eax
801032ae:	75 27                	jne    801032d7 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801032b0:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032b3:	50                   	push   %eax
801032b4:	e8 43 ff ff ff       	call   801031fc <fill_rtcdate>
801032b9:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801032bc:	83 ec 04             	sub    $0x4,%esp
801032bf:	6a 18                	push   $0x18
801032c1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032c4:	50                   	push   %eax
801032c5:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032c8:	50                   	push   %eax
801032c9:	e8 6d 2c 00 00       	call   80105f3b <memcmp>
801032ce:	83 c4 10             	add    $0x10,%esp
801032d1:	85 c0                	test   %eax,%eax
801032d3:	74 05                	je     801032da <cmostime+0x6d>
801032d5:	eb ba                	jmp    80103291 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032d7:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032d8:	eb b7                	jmp    80103291 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032da:	90                   	nop
  }

  // convert
  if (bcd) {
801032db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032df:	0f 84 b4 00 00 00    	je     80103399 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032e8:	c1 e8 04             	shr    $0x4,%eax
801032eb:	89 c2                	mov    %eax,%edx
801032ed:	89 d0                	mov    %edx,%eax
801032ef:	c1 e0 02             	shl    $0x2,%eax
801032f2:	01 d0                	add    %edx,%eax
801032f4:	01 c0                	add    %eax,%eax
801032f6:	89 c2                	mov    %eax,%edx
801032f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032fb:	83 e0 0f             	and    $0xf,%eax
801032fe:	01 d0                	add    %edx,%eax
80103300:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103303:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103306:	c1 e8 04             	shr    $0x4,%eax
80103309:	89 c2                	mov    %eax,%edx
8010330b:	89 d0                	mov    %edx,%eax
8010330d:	c1 e0 02             	shl    $0x2,%eax
80103310:	01 d0                	add    %edx,%eax
80103312:	01 c0                	add    %eax,%eax
80103314:	89 c2                	mov    %eax,%edx
80103316:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103319:	83 e0 0f             	and    $0xf,%eax
8010331c:	01 d0                	add    %edx,%eax
8010331e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103321:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103324:	c1 e8 04             	shr    $0x4,%eax
80103327:	89 c2                	mov    %eax,%edx
80103329:	89 d0                	mov    %edx,%eax
8010332b:	c1 e0 02             	shl    $0x2,%eax
8010332e:	01 d0                	add    %edx,%eax
80103330:	01 c0                	add    %eax,%eax
80103332:	89 c2                	mov    %eax,%edx
80103334:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103337:	83 e0 0f             	and    $0xf,%eax
8010333a:	01 d0                	add    %edx,%eax
8010333c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010333f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103342:	c1 e8 04             	shr    $0x4,%eax
80103345:	89 c2                	mov    %eax,%edx
80103347:	89 d0                	mov    %edx,%eax
80103349:	c1 e0 02             	shl    $0x2,%eax
8010334c:	01 d0                	add    %edx,%eax
8010334e:	01 c0                	add    %eax,%eax
80103350:	89 c2                	mov    %eax,%edx
80103352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103355:	83 e0 0f             	and    $0xf,%eax
80103358:	01 d0                	add    %edx,%eax
8010335a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103360:	c1 e8 04             	shr    $0x4,%eax
80103363:	89 c2                	mov    %eax,%edx
80103365:	89 d0                	mov    %edx,%eax
80103367:	c1 e0 02             	shl    $0x2,%eax
8010336a:	01 d0                	add    %edx,%eax
8010336c:	01 c0                	add    %eax,%eax
8010336e:	89 c2                	mov    %eax,%edx
80103370:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103373:	83 e0 0f             	and    $0xf,%eax
80103376:	01 d0                	add    %edx,%eax
80103378:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010337b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337e:	c1 e8 04             	shr    $0x4,%eax
80103381:	89 c2                	mov    %eax,%edx
80103383:	89 d0                	mov    %edx,%eax
80103385:	c1 e0 02             	shl    $0x2,%eax
80103388:	01 d0                	add    %edx,%eax
8010338a:	01 c0                	add    %eax,%eax
8010338c:	89 c2                	mov    %eax,%edx
8010338e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103391:	83 e0 0f             	and    $0xf,%eax
80103394:	01 d0                	add    %edx,%eax
80103396:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103399:	8b 45 08             	mov    0x8(%ebp),%eax
8010339c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010339f:	89 10                	mov    %edx,(%eax)
801033a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801033a4:	89 50 04             	mov    %edx,0x4(%eax)
801033a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801033aa:	89 50 08             	mov    %edx,0x8(%eax)
801033ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033b0:	89 50 0c             	mov    %edx,0xc(%eax)
801033b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033b6:	89 50 10             	mov    %edx,0x10(%eax)
801033b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033bc:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033bf:	8b 45 08             	mov    0x8(%ebp),%eax
801033c2:	8b 40 14             	mov    0x14(%eax),%eax
801033c5:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033cb:	8b 45 08             	mov    0x8(%ebp),%eax
801033ce:	89 50 14             	mov    %edx,0x14(%eax)
}
801033d1:	90                   	nop
801033d2:	c9                   	leave  
801033d3:	c3                   	ret    

801033d4 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033da:	83 ec 08             	sub    $0x8,%esp
801033dd:	68 94 95 10 80       	push   $0x80109594
801033e2:	68 80 32 11 80       	push   $0x80113280
801033e7:	e8 63 28 00 00       	call   80105c4f <initlock>
801033ec:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033ef:	83 ec 08             	sub    $0x8,%esp
801033f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033f5:	50                   	push   %eax
801033f6:	ff 75 08             	pushl  0x8(%ebp)
801033f9:	e8 2b e0 ff ff       	call   80101429 <readsb>
801033fe:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103401:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103404:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103409:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010340c:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = dev;
80103411:	8b 45 08             	mov    0x8(%ebp),%eax
80103414:	a3 c4 32 11 80       	mov    %eax,0x801132c4
  recover_from_log();
80103419:	e8 b2 01 00 00       	call   801035d0 <recover_from_log>
}
8010341e:	90                   	nop
8010341f:	c9                   	leave  
80103420:	c3                   	ret    

80103421 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103421:	55                   	push   %ebp
80103422:	89 e5                	mov    %esp,%ebp
80103424:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010342e:	e9 95 00 00 00       	jmp    801034c8 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103433:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010343c:	01 d0                	add    %edx,%eax
8010343e:	83 c0 01             	add    $0x1,%eax
80103441:	89 c2                	mov    %eax,%edx
80103443:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103448:	83 ec 08             	sub    $0x8,%esp
8010344b:	52                   	push   %edx
8010344c:	50                   	push   %eax
8010344d:	e8 64 cd ff ff       	call   801001b6 <bread>
80103452:	83 c4 10             	add    $0x10,%esp
80103455:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010345b:	83 c0 10             	add    $0x10,%eax
8010345e:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103465:	89 c2                	mov    %eax,%edx
80103467:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010346c:	83 ec 08             	sub    $0x8,%esp
8010346f:	52                   	push   %edx
80103470:	50                   	push   %eax
80103471:	e8 40 cd ff ff       	call   801001b6 <bread>
80103476:	83 c4 10             	add    $0x10,%esp
80103479:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010347f:	8d 50 18             	lea    0x18(%eax),%edx
80103482:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103485:	83 c0 18             	add    $0x18,%eax
80103488:	83 ec 04             	sub    $0x4,%esp
8010348b:	68 00 02 00 00       	push   $0x200
80103490:	52                   	push   %edx
80103491:	50                   	push   %eax
80103492:	e8 fc 2a 00 00       	call   80105f93 <memmove>
80103497:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010349a:	83 ec 0c             	sub    $0xc,%esp
8010349d:	ff 75 ec             	pushl  -0x14(%ebp)
801034a0:	e8 4a cd ff ff       	call   801001ef <bwrite>
801034a5:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034a8:	83 ec 0c             	sub    $0xc,%esp
801034ab:	ff 75 f0             	pushl  -0x10(%ebp)
801034ae:	e8 7b cd ff ff       	call   8010022e <brelse>
801034b3:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034b6:	83 ec 0c             	sub    $0xc,%esp
801034b9:	ff 75 ec             	pushl  -0x14(%ebp)
801034bc:	e8 6d cd ff ff       	call   8010022e <brelse>
801034c1:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034c8:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801034cd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034d0:	0f 8f 5d ff ff ff    	jg     80103433 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801034d6:	90                   	nop
801034d7:	c9                   	leave  
801034d8:	c3                   	ret    

801034d9 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034d9:	55                   	push   %ebp
801034da:	89 e5                	mov    %esp,%ebp
801034dc:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034df:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801034e4:	89 c2                	mov    %eax,%edx
801034e6:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801034eb:	83 ec 08             	sub    $0x8,%esp
801034ee:	52                   	push   %edx
801034ef:	50                   	push   %eax
801034f0:	e8 c1 cc ff ff       	call   801001b6 <bread>
801034f5:	83 c4 10             	add    $0x10,%esp
801034f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034fe:	83 c0 18             	add    $0x18,%eax
80103501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103507:	8b 00                	mov    (%eax),%eax
80103509:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
8010350e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103515:	eb 1b                	jmp    80103532 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103517:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010351d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103521:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103524:	83 c2 10             	add    $0x10,%edx
80103527:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010352e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103532:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103537:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010353a:	7f db                	jg     80103517 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010353c:	83 ec 0c             	sub    $0xc,%esp
8010353f:	ff 75 f0             	pushl  -0x10(%ebp)
80103542:	e8 e7 cc ff ff       	call   8010022e <brelse>
80103547:	83 c4 10             	add    $0x10,%esp
}
8010354a:	90                   	nop
8010354b:	c9                   	leave  
8010354c:	c3                   	ret    

8010354d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010354d:	55                   	push   %ebp
8010354e:	89 e5                	mov    %esp,%ebp
80103550:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103553:	a1 b4 32 11 80       	mov    0x801132b4,%eax
80103558:	89 c2                	mov    %eax,%edx
8010355a:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010355f:	83 ec 08             	sub    $0x8,%esp
80103562:	52                   	push   %edx
80103563:	50                   	push   %eax
80103564:	e8 4d cc ff ff       	call   801001b6 <bread>
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010356f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103572:	83 c0 18             	add    $0x18,%eax
80103575:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103578:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
8010357e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103581:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010358a:	eb 1b                	jmp    801035a7 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010358c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010358f:	83 c0 10             	add    $0x10,%eax
80103592:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
80103599:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010359c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010359f:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035a7:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801035ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035af:	7f db                	jg     8010358c <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035b1:	83 ec 0c             	sub    $0xc,%esp
801035b4:	ff 75 f0             	pushl  -0x10(%ebp)
801035b7:	e8 33 cc ff ff       	call   801001ef <bwrite>
801035bc:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035bf:	83 ec 0c             	sub    $0xc,%esp
801035c2:	ff 75 f0             	pushl  -0x10(%ebp)
801035c5:	e8 64 cc ff ff       	call   8010022e <brelse>
801035ca:	83 c4 10             	add    $0x10,%esp
}
801035cd:	90                   	nop
801035ce:	c9                   	leave  
801035cf:	c3                   	ret    

801035d0 <recover_from_log>:

static void
recover_from_log(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801035d6:	e8 fe fe ff ff       	call   801034d9 <read_head>
  install_trans(); // if committed, copy from log to disk
801035db:	e8 41 fe ff ff       	call   80103421 <install_trans>
  log.lh.n = 0;
801035e0:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
801035e7:	00 00 00 
  write_head(); // clear the log
801035ea:	e8 5e ff ff ff       	call   8010354d <write_head>
}
801035ef:	90                   	nop
801035f0:	c9                   	leave  
801035f1:	c3                   	ret    

801035f2 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035f2:	55                   	push   %ebp
801035f3:	89 e5                	mov    %esp,%ebp
801035f5:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035f8:	83 ec 0c             	sub    $0xc,%esp
801035fb:	68 80 32 11 80       	push   $0x80113280
80103600:	e8 6c 26 00 00       	call   80105c71 <acquire>
80103605:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103608:	a1 c0 32 11 80       	mov    0x801132c0,%eax
8010360d:	85 c0                	test   %eax,%eax
8010360f:	74 17                	je     80103628 <begin_op+0x36>
      sleep(&log, &log.lock);
80103611:	83 ec 08             	sub    $0x8,%esp
80103614:	68 80 32 11 80       	push   $0x80113280
80103619:	68 80 32 11 80       	push   $0x80113280
8010361e:	e8 ca 1b 00 00       	call   801051ed <sleep>
80103623:	83 c4 10             	add    $0x10,%esp
80103626:	eb e0                	jmp    80103608 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103628:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
8010362e:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103633:	8d 50 01             	lea    0x1(%eax),%edx
80103636:	89 d0                	mov    %edx,%eax
80103638:	c1 e0 02             	shl    $0x2,%eax
8010363b:	01 d0                	add    %edx,%eax
8010363d:	01 c0                	add    %eax,%eax
8010363f:	01 c8                	add    %ecx,%eax
80103641:	83 f8 1e             	cmp    $0x1e,%eax
80103644:	7e 17                	jle    8010365d <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103646:	83 ec 08             	sub    $0x8,%esp
80103649:	68 80 32 11 80       	push   $0x80113280
8010364e:	68 80 32 11 80       	push   $0x80113280
80103653:	e8 95 1b 00 00       	call   801051ed <sleep>
80103658:	83 c4 10             	add    $0x10,%esp
8010365b:	eb ab                	jmp    80103608 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010365d:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103662:	83 c0 01             	add    $0x1,%eax
80103665:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
8010366a:	83 ec 0c             	sub    $0xc,%esp
8010366d:	68 80 32 11 80       	push   $0x80113280
80103672:	e8 61 26 00 00       	call   80105cd8 <release>
80103677:	83 c4 10             	add    $0x10,%esp
      break;
8010367a:	90                   	nop
    }
  }
}
8010367b:	90                   	nop
8010367c:	c9                   	leave  
8010367d:	c3                   	ret    

8010367e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010367e:	55                   	push   %ebp
8010367f:	89 e5                	mov    %esp,%ebp
80103681:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010368b:	83 ec 0c             	sub    $0xc,%esp
8010368e:	68 80 32 11 80       	push   $0x80113280
80103693:	e8 d9 25 00 00       	call   80105c71 <acquire>
80103698:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010369b:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036a0:	83 e8 01             	sub    $0x1,%eax
801036a3:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801036a8:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801036ad:	85 c0                	test   %eax,%eax
801036af:	74 0d                	je     801036be <end_op+0x40>
    panic("log.committing");
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	68 98 95 10 80       	push   $0x80109598
801036b9:	e8 a8 ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036be:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801036c3:	85 c0                	test   %eax,%eax
801036c5:	75 13                	jne    801036da <end_op+0x5c>
    do_commit = 1;
801036c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036ce:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
801036d5:	00 00 00 
801036d8:	eb 10                	jmp    801036ea <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	68 80 32 11 80       	push   $0x80113280
801036e2:	e8 99 1c 00 00       	call   80105380 <wakeup>
801036e7:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036ea:	83 ec 0c             	sub    $0xc,%esp
801036ed:	68 80 32 11 80       	push   $0x80113280
801036f2:	e8 e1 25 00 00       	call   80105cd8 <release>
801036f7:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036fe:	74 3f                	je     8010373f <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103700:	e8 f5 00 00 00       	call   801037fa <commit>
    acquire(&log.lock);
80103705:	83 ec 0c             	sub    $0xc,%esp
80103708:	68 80 32 11 80       	push   $0x80113280
8010370d:	e8 5f 25 00 00       	call   80105c71 <acquire>
80103712:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103715:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
8010371c:	00 00 00 
    wakeup(&log);
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	68 80 32 11 80       	push   $0x80113280
80103727:	e8 54 1c 00 00       	call   80105380 <wakeup>
8010372c:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	68 80 32 11 80       	push   $0x80113280
80103737:	e8 9c 25 00 00       	call   80105cd8 <release>
8010373c:	83 c4 10             	add    $0x10,%esp
  }
}
8010373f:	90                   	nop
80103740:	c9                   	leave  
80103741:	c3                   	ret    

80103742 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103742:	55                   	push   %ebp
80103743:	89 e5                	mov    %esp,%ebp
80103745:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010374f:	e9 95 00 00 00       	jmp    801037e9 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103754:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
8010375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375d:	01 d0                	add    %edx,%eax
8010375f:	83 c0 01             	add    $0x1,%eax
80103762:	89 c2                	mov    %eax,%edx
80103764:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103769:	83 ec 08             	sub    $0x8,%esp
8010376c:	52                   	push   %edx
8010376d:	50                   	push   %eax
8010376e:	e8 43 ca ff ff       	call   801001b6 <bread>
80103773:	83 c4 10             	add    $0x10,%esp
80103776:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377c:	83 c0 10             	add    $0x10,%eax
8010377f:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103786:	89 c2                	mov    %eax,%edx
80103788:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010378d:	83 ec 08             	sub    $0x8,%esp
80103790:	52                   	push   %edx
80103791:	50                   	push   %eax
80103792:	e8 1f ca ff ff       	call   801001b6 <bread>
80103797:	83 c4 10             	add    $0x10,%esp
8010379a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010379d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a0:	8d 50 18             	lea    0x18(%eax),%edx
801037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a6:	83 c0 18             	add    $0x18,%eax
801037a9:	83 ec 04             	sub    $0x4,%esp
801037ac:	68 00 02 00 00       	push   $0x200
801037b1:	52                   	push   %edx
801037b2:	50                   	push   %eax
801037b3:	e8 db 27 00 00       	call   80105f93 <memmove>
801037b8:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037bb:	83 ec 0c             	sub    $0xc,%esp
801037be:	ff 75 f0             	pushl  -0x10(%ebp)
801037c1:	e8 29 ca ff ff       	call   801001ef <bwrite>
801037c6:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037c9:	83 ec 0c             	sub    $0xc,%esp
801037cc:	ff 75 ec             	pushl  -0x14(%ebp)
801037cf:	e8 5a ca ff ff       	call   8010022e <brelse>
801037d4:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037d7:	83 ec 0c             	sub    $0xc,%esp
801037da:	ff 75 f0             	pushl  -0x10(%ebp)
801037dd:	e8 4c ca ff ff       	call   8010022e <brelse>
801037e2:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e9:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801037ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037f1:	0f 8f 5d ff ff ff    	jg     80103754 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037f7:	90                   	nop
801037f8:	c9                   	leave  
801037f9:	c3                   	ret    

801037fa <commit>:

static void
commit()
{
801037fa:	55                   	push   %ebp
801037fb:	89 e5                	mov    %esp,%ebp
801037fd:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103800:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103805:	85 c0                	test   %eax,%eax
80103807:	7e 1e                	jle    80103827 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103809:	e8 34 ff ff ff       	call   80103742 <write_log>
    write_head();    // Write header to disk -- the real commit
8010380e:	e8 3a fd ff ff       	call   8010354d <write_head>
    install_trans(); // Now install writes to home locations
80103813:	e8 09 fc ff ff       	call   80103421 <install_trans>
    log.lh.n = 0; 
80103818:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010381f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103822:	e8 26 fd ff ff       	call   8010354d <write_head>
  }
}
80103827:	90                   	nop
80103828:	c9                   	leave  
80103829:	c3                   	ret    

8010382a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010382a:	55                   	push   %ebp
8010382b:	89 e5                	mov    %esp,%ebp
8010382d:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103830:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103835:	83 f8 1d             	cmp    $0x1d,%eax
80103838:	7f 12                	jg     8010384c <log_write+0x22>
8010383a:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010383f:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103845:	83 ea 01             	sub    $0x1,%edx
80103848:	39 d0                	cmp    %edx,%eax
8010384a:	7c 0d                	jl     80103859 <log_write+0x2f>
    panic("too big a transaction");
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	68 a7 95 10 80       	push   $0x801095a7
80103854:	e8 0d cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103859:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010385e:	85 c0                	test   %eax,%eax
80103860:	7f 0d                	jg     8010386f <log_write+0x45>
    panic("log_write outside of trans");
80103862:	83 ec 0c             	sub    $0xc,%esp
80103865:	68 bd 95 10 80       	push   $0x801095bd
8010386a:	e8 f7 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010386f:	83 ec 0c             	sub    $0xc,%esp
80103872:	68 80 32 11 80       	push   $0x80113280
80103877:	e8 f5 23 00 00       	call   80105c71 <acquire>
8010387c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010387f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103886:	eb 1d                	jmp    801038a5 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010388b:	83 c0 10             	add    $0x10,%eax
8010388e:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
80103895:	89 c2                	mov    %eax,%edx
80103897:	8b 45 08             	mov    0x8(%ebp),%eax
8010389a:	8b 40 08             	mov    0x8(%eax),%eax
8010389d:	39 c2                	cmp    %eax,%edx
8010389f:	74 10                	je     801038b1 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801038a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038a5:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038ad:	7f d9                	jg     80103888 <log_write+0x5e>
801038af:	eb 01                	jmp    801038b2 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801038b1:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038b2:	8b 45 08             	mov    0x8(%ebp),%eax
801038b5:	8b 40 08             	mov    0x8(%eax),%eax
801038b8:	89 c2                	mov    %eax,%edx
801038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038bd:	83 c0 10             	add    $0x10,%eax
801038c0:	89 14 85 8c 32 11 80 	mov    %edx,-0x7feecd74(,%eax,4)
  if (i == log.lh.n)
801038c7:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038cf:	75 0d                	jne    801038de <log_write+0xb4>
    log.lh.n++;
801038d1:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801038d6:	83 c0 01             	add    $0x1,%eax
801038d9:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
801038de:	8b 45 08             	mov    0x8(%ebp),%eax
801038e1:	8b 00                	mov    (%eax),%eax
801038e3:	83 c8 04             	or     $0x4,%eax
801038e6:	89 c2                	mov    %eax,%edx
801038e8:	8b 45 08             	mov    0x8(%ebp),%eax
801038eb:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 80 32 11 80       	push   $0x80113280
801038f5:	e8 de 23 00 00       	call   80105cd8 <release>
801038fa:	83 c4 10             	add    $0x10,%esp
}
801038fd:	90                   	nop
801038fe:	c9                   	leave  
801038ff:	c3                   	ret    

80103900 <v2p>:
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	8b 45 08             	mov    0x8(%ebp),%eax
80103906:	05 00 00 00 80       	add    $0x80000000,%eax
8010390b:	5d                   	pop    %ebp
8010390c:	c3                   	ret    

8010390d <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010390d:	55                   	push   %ebp
8010390e:	89 e5                	mov    %esp,%ebp
80103910:	8b 45 08             	mov    0x8(%ebp),%eax
80103913:	05 00 00 00 80       	add    $0x80000000,%eax
80103918:	5d                   	pop    %ebp
80103919:	c3                   	ret    

8010391a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010391a:	55                   	push   %ebp
8010391b:	89 e5                	mov    %esp,%ebp
8010391d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103920:	8b 55 08             	mov    0x8(%ebp),%edx
80103923:	8b 45 0c             	mov    0xc(%ebp),%eax
80103926:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103929:	f0 87 02             	lock xchg %eax,(%edx)
8010392c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010392f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103932:	c9                   	leave  
80103933:	c3                   	ret    

80103934 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103934:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103938:	83 e4 f0             	and    $0xfffffff0,%esp
8010393b:	ff 71 fc             	pushl  -0x4(%ecx)
8010393e:	55                   	push   %ebp
8010393f:	89 e5                	mov    %esp,%ebp
80103941:	51                   	push   %ecx
80103942:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103945:	83 ec 08             	sub    $0x8,%esp
80103948:	68 00 00 40 80       	push   $0x80400000
8010394d:	68 3c 67 11 80       	push   $0x8011673c
80103952:	e8 7d f2 ff ff       	call   80102bd4 <kinit1>
80103957:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395a:	e8 46 52 00 00       	call   80108ba5 <kvmalloc>
  mpinit();        // collect info about this machine
8010395f:	e8 43 04 00 00       	call   80103da7 <mpinit>
  lapicinit();
80103964:	e8 ea f5 ff ff       	call   80102f53 <lapicinit>
  seginit();       // set up segments
80103969:	e8 e0 4b 00 00       	call   8010854e <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010396e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103974:	0f b6 00             	movzbl (%eax),%eax
80103977:	0f b6 c0             	movzbl %al,%eax
8010397a:	83 ec 08             	sub    $0x8,%esp
8010397d:	50                   	push   %eax
8010397e:	68 d8 95 10 80       	push   $0x801095d8
80103983:	e8 3e ca ff ff       	call   801003c6 <cprintf>
80103988:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010398b:	e8 6d 06 00 00       	call   80103ffd <picinit>
  ioapicinit();    // another interrupt controller
80103990:	e8 34 f1 ff ff       	call   80102ac9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103995:	e8 24 d2 ff ff       	call   80100bbe <consoleinit>
  uartinit();      // serial port
8010399a:	e8 0b 3f 00 00       	call   801078aa <uartinit>
  pinit();         // process table
8010399f:	e8 5d 0b 00 00       	call   80104501 <pinit>
  tvinit();        // trap vectors
801039a4:	e8 da 3a 00 00       	call   80107483 <tvinit>
  binit();         // buffer cache
801039a9:	e8 86 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039ae:	e8 67 d6 ff ff       	call   8010101a <fileinit>
  ideinit();       // disk
801039b3:	e8 19 ed ff ff       	call   801026d1 <ideinit>
  if(!ismp)
801039b8:	a1 64 33 11 80       	mov    0x80113364,%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	75 05                	jne    801039c6 <main+0x92>
    timerinit();   // uniprocessor timer
801039c1:	e8 0e 3a 00 00       	call   801073d4 <timerinit>
  startothers();   // start other processors
801039c6:	e8 7f 00 00 00       	call   80103a4a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039cb:	83 ec 08             	sub    $0x8,%esp
801039ce:	68 00 00 00 8e       	push   $0x8e000000
801039d3:	68 00 00 40 80       	push   $0x80400000
801039d8:	e8 30 f2 ff ff       	call   80102c0d <kinit2>
801039dd:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e0:	e8 e3 0c 00 00       	call   801046c8 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039e5:	e8 1a 00 00 00       	call   80103a04 <mpmain>

801039ea <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039ea:	55                   	push   %ebp
801039eb:	89 e5                	mov    %esp,%ebp
801039ed:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801039f0:	e8 c8 51 00 00       	call   80108bbd <switchkvm>
  seginit();
801039f5:	e8 54 4b 00 00       	call   8010854e <seginit>
  lapicinit();
801039fa:	e8 54 f5 ff ff       	call   80102f53 <lapicinit>
  mpmain();
801039ff:	e8 00 00 00 00       	call   80103a04 <mpmain>

80103a04 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a04:	55                   	push   %ebp
80103a05:	89 e5                	mov    %esp,%ebp
80103a07:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a0a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a10:	0f b6 00             	movzbl (%eax),%eax
80103a13:	0f b6 c0             	movzbl %al,%eax
80103a16:	83 ec 08             	sub    $0x8,%esp
80103a19:	50                   	push   %eax
80103a1a:	68 ef 95 10 80       	push   $0x801095ef
80103a1f:	e8 a2 c9 ff ff       	call   801003c6 <cprintf>
80103a24:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a27:	e8 b8 3b 00 00       	call   801075e4 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a2c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a32:	05 a8 00 00 00       	add    $0xa8,%eax
80103a37:	83 ec 08             	sub    $0x8,%esp
80103a3a:	6a 01                	push   $0x1
80103a3c:	50                   	push   %eax
80103a3d:	e8 d8 fe ff ff       	call   8010391a <xchg>
80103a42:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a45:	e8 e9 14 00 00       	call   80104f33 <scheduler>

80103a4a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a4a:	55                   	push   %ebp
80103a4b:	89 e5                	mov    %esp,%ebp
80103a4d:	53                   	push   %ebx
80103a4e:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a51:	68 00 70 00 00       	push   $0x7000
80103a56:	e8 b2 fe ff ff       	call   8010390d <p2v>
80103a5b:	83 c4 04             	add    $0x4,%esp
80103a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a61:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a66:	83 ec 04             	sub    $0x4,%esp
80103a69:	50                   	push   %eax
80103a6a:	68 2c c5 10 80       	push   $0x8010c52c
80103a6f:	ff 75 f0             	pushl  -0x10(%ebp)
80103a72:	e8 1c 25 00 00       	call   80105f93 <memmove>
80103a77:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a7a:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
80103a81:	e9 90 00 00 00       	jmp    80103b16 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a86:	e8 e6 f5 ff ff       	call   80103071 <cpunum>
80103a8b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a91:	05 80 33 11 80       	add    $0x80113380,%eax
80103a96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a99:	74 73                	je     80103b0e <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a9b:	e8 6b f2 ff ff       	call   80102d0b <kalloc>
80103aa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aa6:	83 e8 04             	sub    $0x4,%eax
80103aa9:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103aac:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ab2:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab7:	83 e8 08             	sub    $0x8,%eax
80103aba:	c7 00 ea 39 10 80    	movl   $0x801039ea,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac3:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103ac6:	83 ec 0c             	sub    $0xc,%esp
80103ac9:	68 00 b0 10 80       	push   $0x8010b000
80103ace:	e8 2d fe ff ff       	call   80103900 <v2p>
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103ad8:	83 ec 0c             	sub    $0xc,%esp
80103adb:	ff 75 f0             	pushl  -0x10(%ebp)
80103ade:	e8 1d fe ff ff       	call   80103900 <v2p>
80103ae3:	83 c4 10             	add    $0x10,%esp
80103ae6:	89 c2                	mov    %eax,%edx
80103ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aeb:	0f b6 00             	movzbl (%eax),%eax
80103aee:	0f b6 c0             	movzbl %al,%eax
80103af1:	83 ec 08             	sub    $0x8,%esp
80103af4:	52                   	push   %edx
80103af5:	50                   	push   %eax
80103af6:	e8 f0 f5 ff ff       	call   801030eb <lapicstartap>
80103afb:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103afe:	90                   	nop
80103aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b02:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b08:	85 c0                	test   %eax,%eax
80103b0a:	74 f3                	je     80103aff <startothers+0xb5>
80103b0c:	eb 01                	jmp    80103b0f <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103b0e:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b0f:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b16:	a1 60 39 11 80       	mov    0x80113960,%eax
80103b1b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b21:	05 80 33 11 80       	add    $0x80113380,%eax
80103b26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b29:	0f 87 57 ff ff ff    	ja     80103a86 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b2f:	90                   	nop
80103b30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b33:	c9                   	leave  
80103b34:	c3                   	ret    

80103b35 <p2v>:
80103b35:	55                   	push   %ebp
80103b36:	89 e5                	mov    %esp,%ebp
80103b38:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3b:	05 00 00 00 80       	add    $0x80000000,%eax
80103b40:	5d                   	pop    %ebp
80103b41:	c3                   	ret    

80103b42 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103b42:	55                   	push   %ebp
80103b43:	89 e5                	mov    %esp,%ebp
80103b45:	83 ec 14             	sub    $0x14,%esp
80103b48:	8b 45 08             	mov    0x8(%ebp),%eax
80103b4b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b4f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b53:	89 c2                	mov    %eax,%edx
80103b55:	ec                   	in     (%dx),%al
80103b56:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b59:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b5d:	c9                   	leave  
80103b5e:	c3                   	ret    

80103b5f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b5f:	55                   	push   %ebp
80103b60:	89 e5                	mov    %esp,%ebp
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	8b 55 08             	mov    0x8(%ebp),%edx
80103b68:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b6b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b6f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b72:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b76:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b7a:	ee                   	out    %al,(%dx)
}
80103b7b:	90                   	nop
80103b7c:	c9                   	leave  
80103b7d:	c3                   	ret    

80103b7e <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b7e:	55                   	push   %ebp
80103b7f:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b81:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103b86:	89 c2                	mov    %eax,%edx
80103b88:	b8 80 33 11 80       	mov    $0x80113380,%eax
80103b8d:	29 c2                	sub    %eax,%edx
80103b8f:	89 d0                	mov    %edx,%eax
80103b91:	c1 f8 02             	sar    $0x2,%eax
80103b94:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b9a:	5d                   	pop    %ebp
80103b9b:	c3                   	ret    

80103b9c <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b9c:	55                   	push   %ebp
80103b9d:	89 e5                	mov    %esp,%ebp
80103b9f:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103ba2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ba9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bb0:	eb 15                	jmp    80103bc7 <sum+0x2b>
    sum += addr[i];
80103bb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb8:	01 d0                	add    %edx,%eax
80103bba:	0f b6 00             	movzbl (%eax),%eax
80103bbd:	0f b6 c0             	movzbl %al,%eax
80103bc0:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bc3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bca:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bcd:	7c e3                	jl     80103bb2 <sum+0x16>
    sum += addr[i];
  return sum;
80103bcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bd2:	c9                   	leave  
80103bd3:	c3                   	ret    

80103bd4 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103bda:	ff 75 08             	pushl  0x8(%ebp)
80103bdd:	e8 53 ff ff ff       	call   80103b35 <p2v>
80103be2:	83 c4 04             	add    $0x4,%esp
80103be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103be8:	8b 55 0c             	mov    0xc(%ebp),%edx
80103beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bee:	01 d0                	add    %edx,%eax
80103bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bf9:	eb 36                	jmp    80103c31 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103bfb:	83 ec 04             	sub    $0x4,%esp
80103bfe:	6a 04                	push   $0x4
80103c00:	68 00 96 10 80       	push   $0x80109600
80103c05:	ff 75 f4             	pushl  -0xc(%ebp)
80103c08:	e8 2e 23 00 00       	call   80105f3b <memcmp>
80103c0d:	83 c4 10             	add    $0x10,%esp
80103c10:	85 c0                	test   %eax,%eax
80103c12:	75 19                	jne    80103c2d <mpsearch1+0x59>
80103c14:	83 ec 08             	sub    $0x8,%esp
80103c17:	6a 10                	push   $0x10
80103c19:	ff 75 f4             	pushl  -0xc(%ebp)
80103c1c:	e8 7b ff ff ff       	call   80103b9c <sum>
80103c21:	83 c4 10             	add    $0x10,%esp
80103c24:	84 c0                	test   %al,%al
80103c26:	75 05                	jne    80103c2d <mpsearch1+0x59>
      return (struct mp*)p;
80103c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2b:	eb 11                	jmp    80103c3e <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c2d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c34:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c37:	72 c2                	jb     80103bfb <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c3e:	c9                   	leave  
80103c3f:	c3                   	ret    

80103c40 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c46:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c50:	83 c0 0f             	add    $0xf,%eax
80103c53:	0f b6 00             	movzbl (%eax),%eax
80103c56:	0f b6 c0             	movzbl %al,%eax
80103c59:	c1 e0 08             	shl    $0x8,%eax
80103c5c:	89 c2                	mov    %eax,%edx
80103c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c61:	83 c0 0e             	add    $0xe,%eax
80103c64:	0f b6 00             	movzbl (%eax),%eax
80103c67:	0f b6 c0             	movzbl %al,%eax
80103c6a:	09 d0                	or     %edx,%eax
80103c6c:	c1 e0 04             	shl    $0x4,%eax
80103c6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c76:	74 21                	je     80103c99 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c78:	83 ec 08             	sub    $0x8,%esp
80103c7b:	68 00 04 00 00       	push   $0x400
80103c80:	ff 75 f0             	pushl  -0x10(%ebp)
80103c83:	e8 4c ff ff ff       	call   80103bd4 <mpsearch1>
80103c88:	83 c4 10             	add    $0x10,%esp
80103c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c92:	74 51                	je     80103ce5 <mpsearch+0xa5>
      return mp;
80103c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c97:	eb 61                	jmp    80103cfa <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9c:	83 c0 14             	add    $0x14,%eax
80103c9f:	0f b6 00             	movzbl (%eax),%eax
80103ca2:	0f b6 c0             	movzbl %al,%eax
80103ca5:	c1 e0 08             	shl    $0x8,%eax
80103ca8:	89 c2                	mov    %eax,%edx
80103caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cad:	83 c0 13             	add    $0x13,%eax
80103cb0:	0f b6 00             	movzbl (%eax),%eax
80103cb3:	0f b6 c0             	movzbl %al,%eax
80103cb6:	09 d0                	or     %edx,%eax
80103cb8:	c1 e0 0a             	shl    $0xa,%eax
80103cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cc1:	2d 00 04 00 00       	sub    $0x400,%eax
80103cc6:	83 ec 08             	sub    $0x8,%esp
80103cc9:	68 00 04 00 00       	push   $0x400
80103cce:	50                   	push   %eax
80103ccf:	e8 00 ff ff ff       	call   80103bd4 <mpsearch1>
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cde:	74 05                	je     80103ce5 <mpsearch+0xa5>
      return mp;
80103ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ce3:	eb 15                	jmp    80103cfa <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103ce5:	83 ec 08             	sub    $0x8,%esp
80103ce8:	68 00 00 01 00       	push   $0x10000
80103ced:	68 00 00 0f 00       	push   $0xf0000
80103cf2:	e8 dd fe ff ff       	call   80103bd4 <mpsearch1>
80103cf7:	83 c4 10             	add    $0x10,%esp
}
80103cfa:	c9                   	leave  
80103cfb:	c3                   	ret    

80103cfc <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103cfc:	55                   	push   %ebp
80103cfd:	89 e5                	mov    %esp,%ebp
80103cff:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d02:	e8 39 ff ff ff       	call   80103c40 <mpsearch>
80103d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d0e:	74 0a                	je     80103d1a <mpconfig+0x1e>
80103d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d13:	8b 40 04             	mov    0x4(%eax),%eax
80103d16:	85 c0                	test   %eax,%eax
80103d18:	75 0a                	jne    80103d24 <mpconfig+0x28>
    return 0;
80103d1a:	b8 00 00 00 00       	mov    $0x0,%eax
80103d1f:	e9 81 00 00 00       	jmp    80103da5 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d27:	8b 40 04             	mov    0x4(%eax),%eax
80103d2a:	83 ec 0c             	sub    $0xc,%esp
80103d2d:	50                   	push   %eax
80103d2e:	e8 02 fe ff ff       	call   80103b35 <p2v>
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d39:	83 ec 04             	sub    $0x4,%esp
80103d3c:	6a 04                	push   $0x4
80103d3e:	68 05 96 10 80       	push   $0x80109605
80103d43:	ff 75 f0             	pushl  -0x10(%ebp)
80103d46:	e8 f0 21 00 00       	call   80105f3b <memcmp>
80103d4b:	83 c4 10             	add    $0x10,%esp
80103d4e:	85 c0                	test   %eax,%eax
80103d50:	74 07                	je     80103d59 <mpconfig+0x5d>
    return 0;
80103d52:	b8 00 00 00 00       	mov    $0x0,%eax
80103d57:	eb 4c                	jmp    80103da5 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d5c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d60:	3c 01                	cmp    $0x1,%al
80103d62:	74 12                	je     80103d76 <mpconfig+0x7a>
80103d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d67:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d6b:	3c 04                	cmp    $0x4,%al
80103d6d:	74 07                	je     80103d76 <mpconfig+0x7a>
    return 0;
80103d6f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d74:	eb 2f                	jmp    80103da5 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d79:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d7d:	0f b7 c0             	movzwl %ax,%eax
80103d80:	83 ec 08             	sub    $0x8,%esp
80103d83:	50                   	push   %eax
80103d84:	ff 75 f0             	pushl  -0x10(%ebp)
80103d87:	e8 10 fe ff ff       	call   80103b9c <sum>
80103d8c:	83 c4 10             	add    $0x10,%esp
80103d8f:	84 c0                	test   %al,%al
80103d91:	74 07                	je     80103d9a <mpconfig+0x9e>
    return 0;
80103d93:	b8 00 00 00 00       	mov    $0x0,%eax
80103d98:	eb 0b                	jmp    80103da5 <mpconfig+0xa9>
  *pmp = mp;
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103da0:	89 10                	mov    %edx,(%eax)
  return conf;
80103da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103da5:	c9                   	leave  
80103da6:	c3                   	ret    

80103da7 <mpinit>:

void
mpinit(void)
{
80103da7:	55                   	push   %ebp
80103da8:	89 e5                	mov    %esp,%ebp
80103daa:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103dad:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103db4:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103db7:	83 ec 0c             	sub    $0xc,%esp
80103dba:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103dbd:	50                   	push   %eax
80103dbe:	e8 39 ff ff ff       	call   80103cfc <mpconfig>
80103dc3:	83 c4 10             	add    $0x10,%esp
80103dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dcd:	0f 84 96 01 00 00    	je     80103f69 <mpinit+0x1c2>
    return;
  ismp = 1;
80103dd3:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103dda:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de0:	8b 40 24             	mov    0x24(%eax),%eax
80103de3:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103deb:	83 c0 2c             	add    $0x2c,%eax
80103dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df4:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103df8:	0f b7 d0             	movzwl %ax,%edx
80103dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dfe:	01 d0                	add    %edx,%eax
80103e00:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e03:	e9 f2 00 00 00       	jmp    80103efa <mpinit+0x153>
    switch(*p){
80103e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e0b:	0f b6 00             	movzbl (%eax),%eax
80103e0e:	0f b6 c0             	movzbl %al,%eax
80103e11:	83 f8 04             	cmp    $0x4,%eax
80103e14:	0f 87 bc 00 00 00    	ja     80103ed6 <mpinit+0x12f>
80103e1a:	8b 04 85 48 96 10 80 	mov    -0x7fef69b8(,%eax,4),%eax
80103e21:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e26:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e2c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e30:	0f b6 d0             	movzbl %al,%edx
80103e33:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e38:	39 c2                	cmp    %eax,%edx
80103e3a:	74 2b                	je     80103e67 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e3f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e43:	0f b6 d0             	movzbl %al,%edx
80103e46:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e4b:	83 ec 04             	sub    $0x4,%esp
80103e4e:	52                   	push   %edx
80103e4f:	50                   	push   %eax
80103e50:	68 0a 96 10 80       	push   $0x8010960a
80103e55:	e8 6c c5 ff ff       	call   801003c6 <cprintf>
80103e5a:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e5d:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103e64:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e6a:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e6e:	0f b6 c0             	movzbl %al,%eax
80103e71:	83 e0 02             	and    $0x2,%eax
80103e74:	85 c0                	test   %eax,%eax
80103e76:	74 15                	je     80103e8d <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e78:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e7d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e83:	05 80 33 11 80       	add    $0x80113380,%eax
80103e88:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103e8d:	a1 60 39 11 80       	mov    0x80113960,%eax
80103e92:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103e98:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e9e:	05 80 33 11 80       	add    $0x80113380,%eax
80103ea3:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103ea5:	a1 60 39 11 80       	mov    0x80113960,%eax
80103eaa:	83 c0 01             	add    $0x1,%eax
80103ead:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103eb2:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103eb6:	eb 42                	jmp    80103efa <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ebb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103ebe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ec1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ec5:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103eca:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ece:	eb 2a                	jmp    80103efa <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ed0:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ed4:	eb 24                	jmp    80103efa <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed9:	0f b6 00             	movzbl (%eax),%eax
80103edc:	0f b6 c0             	movzbl %al,%eax
80103edf:	83 ec 08             	sub    $0x8,%esp
80103ee2:	50                   	push   %eax
80103ee3:	68 28 96 10 80       	push   $0x80109628
80103ee8:	e8 d9 c4 ff ff       	call   801003c6 <cprintf>
80103eed:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ef0:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103ef7:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103efd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f00:	0f 82 02 ff ff ff    	jb     80103e08 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103f06:	a1 64 33 11 80       	mov    0x80113364,%eax
80103f0b:	85 c0                	test   %eax,%eax
80103f0d:	75 1d                	jne    80103f2c <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f0f:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103f16:	00 00 00 
    lapic = 0;
80103f19:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103f20:	00 00 00 
    ioapicid = 0;
80103f23:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103f2a:	eb 3e                	jmp    80103f6a <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f2f:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f33:	84 c0                	test   %al,%al
80103f35:	74 33                	je     80103f6a <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f37:	83 ec 08             	sub    $0x8,%esp
80103f3a:	6a 70                	push   $0x70
80103f3c:	6a 22                	push   $0x22
80103f3e:	e8 1c fc ff ff       	call   80103b5f <outb>
80103f43:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	6a 23                	push   $0x23
80103f4b:	e8 f2 fb ff ff       	call   80103b42 <inb>
80103f50:	83 c4 10             	add    $0x10,%esp
80103f53:	83 c8 01             	or     $0x1,%eax
80103f56:	0f b6 c0             	movzbl %al,%eax
80103f59:	83 ec 08             	sub    $0x8,%esp
80103f5c:	50                   	push   %eax
80103f5d:	6a 23                	push   $0x23
80103f5f:	e8 fb fb ff ff       	call   80103b5f <outb>
80103f64:	83 c4 10             	add    $0x10,%esp
80103f67:	eb 01                	jmp    80103f6a <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f69:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f6a:	c9                   	leave  
80103f6b:	c3                   	ret    

80103f6c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f6c:	55                   	push   %ebp
80103f6d:	89 e5                	mov    %esp,%ebp
80103f6f:	83 ec 08             	sub    $0x8,%esp
80103f72:	8b 55 08             	mov    0x8(%ebp),%edx
80103f75:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f78:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f7c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f7f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f83:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f87:	ee                   	out    %al,(%dx)
}
80103f88:	90                   	nop
80103f89:	c9                   	leave  
80103f8a:	c3                   	ret    

80103f8b <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f8b:	55                   	push   %ebp
80103f8c:	89 e5                	mov    %esp,%ebp
80103f8e:	83 ec 04             	sub    $0x4,%esp
80103f91:	8b 45 08             	mov    0x8(%ebp),%eax
80103f94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f98:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f9c:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103fa2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fa6:	0f b6 c0             	movzbl %al,%eax
80103fa9:	50                   	push   %eax
80103faa:	6a 21                	push   $0x21
80103fac:	e8 bb ff ff ff       	call   80103f6c <outb>
80103fb1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fb4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fb8:	66 c1 e8 08          	shr    $0x8,%ax
80103fbc:	0f b6 c0             	movzbl %al,%eax
80103fbf:	50                   	push   %eax
80103fc0:	68 a1 00 00 00       	push   $0xa1
80103fc5:	e8 a2 ff ff ff       	call   80103f6c <outb>
80103fca:	83 c4 08             	add    $0x8,%esp
}
80103fcd:	90                   	nop
80103fce:	c9                   	leave  
80103fcf:	c3                   	ret    

80103fd0 <picenable>:

void
picenable(int irq)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd6:	ba 01 00 00 00       	mov    $0x1,%edx
80103fdb:	89 c1                	mov    %eax,%ecx
80103fdd:	d3 e2                	shl    %cl,%edx
80103fdf:	89 d0                	mov    %edx,%eax
80103fe1:	f7 d0                	not    %eax
80103fe3:	89 c2                	mov    %eax,%edx
80103fe5:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103fec:	21 d0                	and    %edx,%eax
80103fee:	0f b7 c0             	movzwl %ax,%eax
80103ff1:	50                   	push   %eax
80103ff2:	e8 94 ff ff ff       	call   80103f8b <picsetmask>
80103ff7:	83 c4 04             	add    $0x4,%esp
}
80103ffa:	90                   	nop
80103ffb:	c9                   	leave  
80103ffc:	c3                   	ret    

80103ffd <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ffd:	55                   	push   %ebp
80103ffe:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104000:	68 ff 00 00 00       	push   $0xff
80104005:	6a 21                	push   $0x21
80104007:	e8 60 ff ff ff       	call   80103f6c <outb>
8010400c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010400f:	68 ff 00 00 00       	push   $0xff
80104014:	68 a1 00 00 00       	push   $0xa1
80104019:	e8 4e ff ff ff       	call   80103f6c <outb>
8010401e:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104021:	6a 11                	push   $0x11
80104023:	6a 20                	push   $0x20
80104025:	e8 42 ff ff ff       	call   80103f6c <outb>
8010402a:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
8010402d:	6a 20                	push   $0x20
8010402f:	6a 21                	push   $0x21
80104031:	e8 36 ff ff ff       	call   80103f6c <outb>
80104036:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104039:	6a 04                	push   $0x4
8010403b:	6a 21                	push   $0x21
8010403d:	e8 2a ff ff ff       	call   80103f6c <outb>
80104042:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104045:	6a 03                	push   $0x3
80104047:	6a 21                	push   $0x21
80104049:	e8 1e ff ff ff       	call   80103f6c <outb>
8010404e:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104051:	6a 11                	push   $0x11
80104053:	68 a0 00 00 00       	push   $0xa0
80104058:	e8 0f ff ff ff       	call   80103f6c <outb>
8010405d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104060:	6a 28                	push   $0x28
80104062:	68 a1 00 00 00       	push   $0xa1
80104067:	e8 00 ff ff ff       	call   80103f6c <outb>
8010406c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
8010406f:	6a 02                	push   $0x2
80104071:	68 a1 00 00 00       	push   $0xa1
80104076:	e8 f1 fe ff ff       	call   80103f6c <outb>
8010407b:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010407e:	6a 03                	push   $0x3
80104080:	68 a1 00 00 00       	push   $0xa1
80104085:	e8 e2 fe ff ff       	call   80103f6c <outb>
8010408a:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010408d:	6a 68                	push   $0x68
8010408f:	6a 20                	push   $0x20
80104091:	e8 d6 fe ff ff       	call   80103f6c <outb>
80104096:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104099:	6a 0a                	push   $0xa
8010409b:	6a 20                	push   $0x20
8010409d:	e8 ca fe ff ff       	call   80103f6c <outb>
801040a2:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801040a5:	6a 68                	push   $0x68
801040a7:	68 a0 00 00 00       	push   $0xa0
801040ac:	e8 bb fe ff ff       	call   80103f6c <outb>
801040b1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040b4:	6a 0a                	push   $0xa
801040b6:	68 a0 00 00 00       	push   $0xa0
801040bb:	e8 ac fe ff ff       	call   80103f6c <outb>
801040c0:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040c3:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040ca:	66 83 f8 ff          	cmp    $0xffff,%ax
801040ce:	74 13                	je     801040e3 <picinit+0xe6>
    picsetmask(irqmask);
801040d0:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
801040d7:	0f b7 c0             	movzwl %ax,%eax
801040da:	50                   	push   %eax
801040db:	e8 ab fe ff ff       	call   80103f8b <picsetmask>
801040e0:	83 c4 04             	add    $0x4,%esp
}
801040e3:	90                   	nop
801040e4:	c9                   	leave  
801040e5:	c3                   	ret    

801040e6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040e6:	55                   	push   %ebp
801040e7:	89 e5                	mov    %esp,%ebp
801040e9:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ff:	8b 10                	mov    (%eax),%edx
80104101:	8b 45 08             	mov    0x8(%ebp),%eax
80104104:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104106:	e8 2d cf ff ff       	call   80101038 <filealloc>
8010410b:	89 c2                	mov    %eax,%edx
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	89 10                	mov    %edx,(%eax)
80104112:	8b 45 08             	mov    0x8(%ebp),%eax
80104115:	8b 00                	mov    (%eax),%eax
80104117:	85 c0                	test   %eax,%eax
80104119:	0f 84 cb 00 00 00    	je     801041ea <pipealloc+0x104>
8010411f:	e8 14 cf ff ff       	call   80101038 <filealloc>
80104124:	89 c2                	mov    %eax,%edx
80104126:	8b 45 0c             	mov    0xc(%ebp),%eax
80104129:	89 10                	mov    %edx,(%eax)
8010412b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010412e:	8b 00                	mov    (%eax),%eax
80104130:	85 c0                	test   %eax,%eax
80104132:	0f 84 b2 00 00 00    	je     801041ea <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104138:	e8 ce eb ff ff       	call   80102d0b <kalloc>
8010413d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104144:	0f 84 9f 00 00 00    	je     801041e9 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
8010414a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010414d:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104154:	00 00 00 
  p->writeopen = 1;
80104157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415a:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104161:	00 00 00 
  p->nwrite = 0;
80104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104167:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010416e:	00 00 00 
  p->nread = 0;
80104171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104174:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010417b:	00 00 00 
  initlock(&p->lock, "pipe");
8010417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104181:	83 ec 08             	sub    $0x8,%esp
80104184:	68 5c 96 10 80       	push   $0x8010965c
80104189:	50                   	push   %eax
8010418a:	e8 c0 1a 00 00       	call   80105c4f <initlock>
8010418f:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104192:	8b 45 08             	mov    0x8(%ebp),%eax
80104195:	8b 00                	mov    (%eax),%eax
80104197:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010419d:	8b 45 08             	mov    0x8(%ebp),%eax
801041a0:	8b 00                	mov    (%eax),%eax
801041a2:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041a6:	8b 45 08             	mov    0x8(%ebp),%eax
801041a9:	8b 00                	mov    (%eax),%eax
801041ab:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	8b 00                	mov    (%eax),%eax
801041b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b7:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801041bd:	8b 00                	mov    (%eax),%eax
801041bf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c8:	8b 00                	mov    (%eax),%eax
801041ca:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d1:	8b 00                	mov    (%eax),%eax
801041d3:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801041da:	8b 00                	mov    (%eax),%eax
801041dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041df:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041e2:	b8 00 00 00 00       	mov    $0x0,%eax
801041e7:	eb 4e                	jmp    80104237 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801041e9:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
801041ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041ee:	74 0e                	je     801041fe <pipealloc+0x118>
    kfree((char*)p);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	ff 75 f4             	pushl  -0xc(%ebp)
801041f6:	e8 73 ea ff ff       	call   80102c6e <kfree>
801041fb:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104201:	8b 00                	mov    (%eax),%eax
80104203:	85 c0                	test   %eax,%eax
80104205:	74 11                	je     80104218 <pipealloc+0x132>
    fileclose(*f0);
80104207:	8b 45 08             	mov    0x8(%ebp),%eax
8010420a:	8b 00                	mov    (%eax),%eax
8010420c:	83 ec 0c             	sub    $0xc,%esp
8010420f:	50                   	push   %eax
80104210:	e8 e1 ce ff ff       	call   801010f6 <fileclose>
80104215:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421b:	8b 00                	mov    (%eax),%eax
8010421d:	85 c0                	test   %eax,%eax
8010421f:	74 11                	je     80104232 <pipealloc+0x14c>
    fileclose(*f1);
80104221:	8b 45 0c             	mov    0xc(%ebp),%eax
80104224:	8b 00                	mov    (%eax),%eax
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	50                   	push   %eax
8010422a:	e8 c7 ce ff ff       	call   801010f6 <fileclose>
8010422f:	83 c4 10             	add    $0x10,%esp
  return -1;
80104232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104237:	c9                   	leave  
80104238:	c3                   	ret    

80104239 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104239:	55                   	push   %ebp
8010423a:	89 e5                	mov    %esp,%ebp
8010423c:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010423f:	8b 45 08             	mov    0x8(%ebp),%eax
80104242:	83 ec 0c             	sub    $0xc,%esp
80104245:	50                   	push   %eax
80104246:	e8 26 1a 00 00       	call   80105c71 <acquire>
8010424b:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010424e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104252:	74 23                	je     80104277 <pipeclose+0x3e>
    p->writeopen = 0;
80104254:	8b 45 08             	mov    0x8(%ebp),%eax
80104257:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010425e:	00 00 00 
    wakeup(&p->nread);
80104261:	8b 45 08             	mov    0x8(%ebp),%eax
80104264:	05 34 02 00 00       	add    $0x234,%eax
80104269:	83 ec 0c             	sub    $0xc,%esp
8010426c:	50                   	push   %eax
8010426d:	e8 0e 11 00 00       	call   80105380 <wakeup>
80104272:	83 c4 10             	add    $0x10,%esp
80104275:	eb 21                	jmp    80104298 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104277:	8b 45 08             	mov    0x8(%ebp),%eax
8010427a:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104281:	00 00 00 
    wakeup(&p->nwrite);
80104284:	8b 45 08             	mov    0x8(%ebp),%eax
80104287:	05 38 02 00 00       	add    $0x238,%eax
8010428c:	83 ec 0c             	sub    $0xc,%esp
8010428f:	50                   	push   %eax
80104290:	e8 eb 10 00 00       	call   80105380 <wakeup>
80104295:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104298:	8b 45 08             	mov    0x8(%ebp),%eax
8010429b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042a1:	85 c0                	test   %eax,%eax
801042a3:	75 2c                	jne    801042d1 <pipeclose+0x98>
801042a5:	8b 45 08             	mov    0x8(%ebp),%eax
801042a8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042ae:	85 c0                	test   %eax,%eax
801042b0:	75 1f                	jne    801042d1 <pipeclose+0x98>
    release(&p->lock);
801042b2:	8b 45 08             	mov    0x8(%ebp),%eax
801042b5:	83 ec 0c             	sub    $0xc,%esp
801042b8:	50                   	push   %eax
801042b9:	e8 1a 1a 00 00       	call   80105cd8 <release>
801042be:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	ff 75 08             	pushl  0x8(%ebp)
801042c7:	e8 a2 e9 ff ff       	call   80102c6e <kfree>
801042cc:	83 c4 10             	add    $0x10,%esp
801042cf:	eb 0f                	jmp    801042e0 <pipeclose+0xa7>
  } else
    release(&p->lock);
801042d1:	8b 45 08             	mov    0x8(%ebp),%eax
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	50                   	push   %eax
801042d8:	e8 fb 19 00 00       	call   80105cd8 <release>
801042dd:	83 c4 10             	add    $0x10,%esp
}
801042e0:	90                   	nop
801042e1:	c9                   	leave  
801042e2:	c3                   	ret    

801042e3 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801042e3:	55                   	push   %ebp
801042e4:	89 e5                	mov    %esp,%ebp
801042e6:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042e9:	8b 45 08             	mov    0x8(%ebp),%eax
801042ec:	83 ec 0c             	sub    $0xc,%esp
801042ef:	50                   	push   %eax
801042f0:	e8 7c 19 00 00       	call   80105c71 <acquire>
801042f5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042ff:	e9 ad 00 00 00       	jmp    801043b1 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104304:	8b 45 08             	mov    0x8(%ebp),%eax
80104307:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010430d:	85 c0                	test   %eax,%eax
8010430f:	74 0d                	je     8010431e <pipewrite+0x3b>
80104311:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104317:	8b 40 24             	mov    0x24(%eax),%eax
8010431a:	85 c0                	test   %eax,%eax
8010431c:	74 19                	je     80104337 <pipewrite+0x54>
        release(&p->lock);
8010431e:	8b 45 08             	mov    0x8(%ebp),%eax
80104321:	83 ec 0c             	sub    $0xc,%esp
80104324:	50                   	push   %eax
80104325:	e8 ae 19 00 00       	call   80105cd8 <release>
8010432a:	83 c4 10             	add    $0x10,%esp
        return -1;
8010432d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104332:	e9 a8 00 00 00       	jmp    801043df <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104337:	8b 45 08             	mov    0x8(%ebp),%eax
8010433a:	05 34 02 00 00       	add    $0x234,%eax
8010433f:	83 ec 0c             	sub    $0xc,%esp
80104342:	50                   	push   %eax
80104343:	e8 38 10 00 00       	call   80105380 <wakeup>
80104348:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	8b 55 08             	mov    0x8(%ebp),%edx
80104351:	81 c2 38 02 00 00    	add    $0x238,%edx
80104357:	83 ec 08             	sub    $0x8,%esp
8010435a:	50                   	push   %eax
8010435b:	52                   	push   %edx
8010435c:	e8 8c 0e 00 00       	call   801051ed <sleep>
80104361:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104364:	8b 45 08             	mov    0x8(%ebp),%eax
80104367:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010436d:	8b 45 08             	mov    0x8(%ebp),%eax
80104370:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104376:	05 00 02 00 00       	add    $0x200,%eax
8010437b:	39 c2                	cmp    %eax,%edx
8010437d:	74 85                	je     80104304 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010437f:	8b 45 08             	mov    0x8(%ebp),%eax
80104382:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104388:	8d 48 01             	lea    0x1(%eax),%ecx
8010438b:	8b 55 08             	mov    0x8(%ebp),%edx
8010438e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104394:	25 ff 01 00 00       	and    $0x1ff,%eax
80104399:	89 c1                	mov    %eax,%ecx
8010439b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010439e:	8b 45 0c             	mov    0xc(%ebp),%eax
801043a1:	01 d0                	add    %edx,%eax
801043a3:	0f b6 10             	movzbl (%eax),%edx
801043a6:	8b 45 08             	mov    0x8(%ebp),%eax
801043a9:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b4:	3b 45 10             	cmp    0x10(%ebp),%eax
801043b7:	7c ab                	jl     80104364 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043b9:	8b 45 08             	mov    0x8(%ebp),%eax
801043bc:	05 34 02 00 00       	add    $0x234,%eax
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	50                   	push   %eax
801043c5:	e8 b6 0f 00 00       	call   80105380 <wakeup>
801043ca:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043cd:	8b 45 08             	mov    0x8(%ebp),%eax
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	50                   	push   %eax
801043d4:	e8 ff 18 00 00       	call   80105cd8 <release>
801043d9:	83 c4 10             	add    $0x10,%esp
  return n;
801043dc:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043df:	c9                   	leave  
801043e0:	c3                   	ret    

801043e1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043e1:	55                   	push   %ebp
801043e2:	89 e5                	mov    %esp,%ebp
801043e4:	53                   	push   %ebx
801043e5:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043e8:	8b 45 08             	mov    0x8(%ebp),%eax
801043eb:	83 ec 0c             	sub    $0xc,%esp
801043ee:	50                   	push   %eax
801043ef:	e8 7d 18 00 00       	call   80105c71 <acquire>
801043f4:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043f7:	eb 3f                	jmp    80104438 <piperead+0x57>
    if(proc->killed){
801043f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ff:	8b 40 24             	mov    0x24(%eax),%eax
80104402:	85 c0                	test   %eax,%eax
80104404:	74 19                	je     8010441f <piperead+0x3e>
      release(&p->lock);
80104406:	8b 45 08             	mov    0x8(%ebp),%eax
80104409:	83 ec 0c             	sub    $0xc,%esp
8010440c:	50                   	push   %eax
8010440d:	e8 c6 18 00 00       	call   80105cd8 <release>
80104412:	83 c4 10             	add    $0x10,%esp
      return -1;
80104415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441a:	e9 bf 00 00 00       	jmp    801044de <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010441f:	8b 45 08             	mov    0x8(%ebp),%eax
80104422:	8b 55 08             	mov    0x8(%ebp),%edx
80104425:	81 c2 34 02 00 00    	add    $0x234,%edx
8010442b:	83 ec 08             	sub    $0x8,%esp
8010442e:	50                   	push   %eax
8010442f:	52                   	push   %edx
80104430:	e8 b8 0d 00 00       	call   801051ed <sleep>
80104435:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104438:	8b 45 08             	mov    0x8(%ebp),%eax
8010443b:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104441:	8b 45 08             	mov    0x8(%ebp),%eax
80104444:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010444a:	39 c2                	cmp    %eax,%edx
8010444c:	75 0d                	jne    8010445b <piperead+0x7a>
8010444e:	8b 45 08             	mov    0x8(%ebp),%eax
80104451:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104457:	85 c0                	test   %eax,%eax
80104459:	75 9e                	jne    801043f9 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010445b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104462:	eb 49                	jmp    801044ad <piperead+0xcc>
    if(p->nread == p->nwrite)
80104464:	8b 45 08             	mov    0x8(%ebp),%eax
80104467:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010446d:	8b 45 08             	mov    0x8(%ebp),%eax
80104470:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104476:	39 c2                	cmp    %eax,%edx
80104478:	74 3d                	je     801044b7 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010447a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104480:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104483:	8b 45 08             	mov    0x8(%ebp),%eax
80104486:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010448c:	8d 48 01             	lea    0x1(%eax),%ecx
8010448f:	8b 55 08             	mov    0x8(%ebp),%edx
80104492:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104498:	25 ff 01 00 00       	and    $0x1ff,%eax
8010449d:	89 c2                	mov    %eax,%edx
8010449f:	8b 45 08             	mov    0x8(%ebp),%eax
801044a2:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044a7:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b0:	3b 45 10             	cmp    0x10(%ebp),%eax
801044b3:	7c af                	jl     80104464 <piperead+0x83>
801044b5:	eb 01                	jmp    801044b8 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801044b7:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044b8:	8b 45 08             	mov    0x8(%ebp),%eax
801044bb:	05 38 02 00 00       	add    $0x238,%eax
801044c0:	83 ec 0c             	sub    $0xc,%esp
801044c3:	50                   	push   %eax
801044c4:	e8 b7 0e 00 00       	call   80105380 <wakeup>
801044c9:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044cc:	8b 45 08             	mov    0x8(%ebp),%eax
801044cf:	83 ec 0c             	sub    $0xc,%esp
801044d2:	50                   	push   %eax
801044d3:	e8 00 18 00 00       	call   80105cd8 <release>
801044d8:	83 c4 10             	add    $0x10,%esp
  return i;
801044db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e1:	c9                   	leave  
801044e2:	c3                   	ret    

801044e3 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801044e3:	55                   	push   %ebp
801044e4:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801044e6:	f4                   	hlt    
}
801044e7:	90                   	nop
801044e8:	5d                   	pop    %ebp
801044e9:	c3                   	ret    

801044ea <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044ea:	55                   	push   %ebp
801044eb:	89 e5                	mov    %esp,%ebp
801044ed:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044f0:	9c                   	pushf  
801044f1:	58                   	pop    %eax
801044f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044f8:	c9                   	leave  
801044f9:	c3                   	ret    

801044fa <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044fa:	55                   	push   %ebp
801044fb:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044fd:	fb                   	sti    
}
801044fe:	90                   	nop
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    

80104501 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104501:	55                   	push   %ebp
80104502:	89 e5                	mov    %esp,%ebp
80104504:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104507:	83 ec 08             	sub    $0x8,%esp
8010450a:	68 64 96 10 80       	push   $0x80109664
8010450f:	68 80 39 11 80       	push   $0x80113980
80104514:	e8 36 17 00 00       	call   80105c4f <initlock>
80104519:	83 c4 10             	add    $0x10,%esp
}
8010451c:	90                   	nop
8010451d:	c9                   	leave  
8010451e:	c3                   	ret    

8010451f <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010451f:	55                   	push   %ebp
80104520:	89 e5                	mov    %esp,%ebp
80104522:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104525:	83 ec 0c             	sub    $0xc,%esp
80104528:	68 80 39 11 80       	push   $0x80113980
8010452d:	e8 3f 17 00 00       	call   80105c71 <acquire>
80104532:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
    p = removeFront(&ptable.pLists.free);
80104535:	83 ec 0c             	sub    $0xc,%esp
80104538:	68 b8 5e 11 80       	push   $0x80115eb8
8010453d:	e8 73 14 00 00       	call   801059b5 <removeFront>
80104542:	83 c4 10             	add    $0x10,%esp
80104545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p != 0){
80104548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454c:	74 71                	je     801045bf <allocproc+0xa0>
      assertState(p, UNUSED);
8010454e:	83 ec 08             	sub    $0x8,%esp
80104551:	6a 00                	push   $0x0
80104553:	ff 75 f4             	pushl  -0xc(%ebp)
80104556:	e8 68 12 00 00       	call   801057c3 <assertState>
8010455b:	83 c4 10             	add    $0x10,%esp
      goto found;
8010455e:	90                   	nop

found:
  // remove from freeList, assert state, insert in Embryo
  #ifdef CS333_P3P4
    
      p->state = EMBRYO;
8010455f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104562:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
      insertAtHead(&ptable.pLists.embryo, p);
80104569:	83 ec 08             	sub    $0x8,%esp
8010456c:	ff 75 f4             	pushl  -0xc(%ebp)
8010456f:	68 c8 5e 11 80       	push   $0x80115ec8
80104574:	e8 d1 14 00 00       	call   80105a4a <insertAtHead>
80104579:	83 c4 10             	add    $0x10,%esp
   
  #else
   p->state = EMBRYO;              // check this
  #endif

  p->pid = nextpid++;
8010457c:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104581:	8d 50 01             	lea    0x1(%eax),%edx
80104584:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
8010458a:	89 c2                	mov    %eax,%edx
8010458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458f:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 80 39 11 80       	push   $0x80113980
8010459a:	e8 39 17 00 00       	call   80105cd8 <release>
8010459f:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045a2:	e8 64 e7 ff ff       	call   80102d0b <kalloc>
801045a7:	89 c2                	mov    %eax,%edx
801045a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ac:	89 50 08             	mov    %edx,0x8(%eax)
801045af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b2:	8b 40 08             	mov    0x8(%eax),%eax
801045b5:	85 c0                	test   %eax,%eax
801045b7:	0f 85 86 00 00 00    	jne    80104643 <allocproc+0x124>
801045bd:	eb 1a                	jmp    801045d9 <allocproc+0xba>
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #endif
  release(&ptable.lock);
801045bf:	83 ec 0c             	sub    $0xc,%esp
801045c2:	68 80 39 11 80       	push   $0x80113980
801045c7:	e8 0c 17 00 00       	call   80105cd8 <release>
801045cc:	83 c4 10             	add    $0x10,%esp
  return 0;
801045cf:	b8 00 00 00 00       	mov    $0x0,%eax
801045d4:	e9 ed 00 00 00       	jmp    801046c6 <allocproc+0x1a7>
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4                       //******* check this logic IMPORTant
    acquire(&ptable.lock);
801045d9:	83 ec 0c             	sub    $0xc,%esp
801045dc:	68 80 39 11 80       	push   $0x80113980
801045e1:	e8 8b 16 00 00       	call   80105c71 <acquire>
801045e6:	83 c4 10             	add    $0x10,%esp
    assertState(p, EMBRYO);
801045e9:	83 ec 08             	sub    $0x8,%esp
801045ec:	6a 01                	push   $0x1
801045ee:	ff 75 f4             	pushl  -0xc(%ebp)
801045f1:	e8 cd 11 00 00       	call   801057c3 <assertState>
801045f6:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, p);
801045f9:	83 ec 08             	sub    $0x8,%esp
801045fc:	ff 75 f4             	pushl  -0xc(%ebp)
801045ff:	68 c8 5e 11 80       	push   $0x80115ec8
80104604:	e8 04 12 00 00       	call   8010580d <removeFromStateList>
80104609:	83 c4 10             	add    $0x10,%esp
    p->state = UNUSED;                // should I put it in the else block
8010460c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, p);
80104616:	83 ec 08             	sub    $0x8,%esp
80104619:	ff 75 f4             	pushl  -0xc(%ebp)
8010461c:	68 b8 5e 11 80       	push   $0x80115eb8
80104621:	e8 24 14 00 00       	call   80105a4a <insertAtHead>
80104626:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104629:	83 ec 0c             	sub    $0xc,%esp
8010462c:	68 80 39 11 80       	push   $0x80113980
80104631:	e8 a2 16 00 00       	call   80105cd8 <release>
80104636:	83 c4 10             	add    $0x10,%esp
    
    #else
    p->state = UNUSED;               
    #endif

    return 0;
80104639:	b8 00 00 00 00       	mov    $0x0,%eax
8010463e:	e9 83 00 00 00       	jmp    801046c6 <allocproc+0x1a7>
  }
  sp = p->kstack + KSTACKSIZE;
80104643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104646:	8b 40 08             	mov    0x8(%eax),%eax
80104649:	05 00 10 00 00       	add    $0x1000,%eax
8010464e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104651:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104658:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010465b:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010465e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104662:	ba 31 74 10 80       	mov    $0x80107431,%edx
80104667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010466a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010466c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104673:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104676:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010467f:	83 ec 04             	sub    $0x4,%esp
80104682:	6a 14                	push   $0x14
80104684:	6a 00                	push   $0x0
80104686:	50                   	push   %eax
80104687:	e8 48 18 00 00       	call   80105ed4 <memset>
8010468c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010468f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104692:	8b 40 1c             	mov    0x1c(%eax),%eax
80104695:	ba a7 51 10 80       	mov    $0x801051a7,%edx
8010469a:	89 50 10             	mov    %edx,0x10(%eax)
  p->start_ticks = ticks;
8010469d:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a6:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total =0;
801046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ac:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801046b3:	00 00 00 
  p->cpu_ticks_in =0;
801046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b9:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801046c0:	00 00 00 
  return p;
801046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
801046c6:	c9                   	leave  
801046c7:	c3                   	ret    

801046c8 <userinit>:

// Set up first user process.
void
userinit(void)
{
801046c8:	55                   	push   %ebp
801046c9:	89 e5                	mov    %esp,%ebp
801046cb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	68 80 39 11 80       	push   $0x80113980
801046d6:	e8 96 15 00 00       	call   80105c71 <acquire>
801046db:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
801046de:	c7 05 b8 5e 11 80 00 	movl   $0x0,0x80115eb8
801046e5:	00 00 00 
  ptable.pLists.ready = 0;
801046e8:	c7 05 b4 5e 11 80 00 	movl   $0x0,0x80115eb4
801046ef:	00 00 00 
  ptable.pLists.sleep = 0;
801046f2:	c7 05 bc 5e 11 80 00 	movl   $0x0,0x80115ebc
801046f9:	00 00 00 
  ptable.pLists.embryo = 0;
801046fc:	c7 05 c8 5e 11 80 00 	movl   $0x0,0x80115ec8
80104703:	00 00 00 
  ptable.pLists.running = 0;
80104706:	c7 05 c4 5e 11 80 00 	movl   $0x0,0x80115ec4
8010470d:	00 00 00 
  ptable.pLists.zombie = 0;
80104710:	c7 05 c0 5e 11 80 00 	movl   $0x0,0x80115ec0
80104717:	00 00 00 

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471a:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104721:	eb 24                	jmp    80104747 <userinit+0x7f>
    p -> state = UNUSED;
80104723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104726:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, p);
8010472d:	83 ec 08             	sub    $0x8,%esp
80104730:	ff 75 f4             	pushl  -0xc(%ebp)
80104733:	68 b8 5e 11 80       	push   $0x80115eb8
80104738:	e8 0d 13 00 00       	call   80105a4a <insertAtHead>
8010473d:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.sleep = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.running = 0;
  ptable.pLists.zombie = 0;

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104740:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104747:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
8010474e:	72 d3                	jb     80104723 <userinit+0x5b>
    p -> state = UNUSED;
    insertAtHead(&ptable.pLists.free, p);
 }
  release(&ptable.lock);
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	68 80 39 11 80       	push   $0x80113980
80104758:	e8 7b 15 00 00       	call   80105cd8 <release>
8010475d:	83 c4 10             	add    $0x10,%esp
  #endif

  p = allocproc();
80104760:	e8 ba fd ff ff       	call   8010451f <allocproc>
80104765:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476b:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
80104770:	e8 7e 43 00 00       	call   80108af3 <setupkvm>
80104775:	89 c2                	mov    %eax,%edx
80104777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477a:	89 50 04             	mov    %edx,0x4(%eax)
8010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104780:	8b 40 04             	mov    0x4(%eax),%eax
80104783:	85 c0                	test   %eax,%eax
80104785:	75 0d                	jne    80104794 <userinit+0xcc>
    panic("userinit: out of memory?");
80104787:	83 ec 0c             	sub    $0xc,%esp
8010478a:	68 6b 96 10 80       	push   $0x8010966b
8010478f:	e8 d2 bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104794:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104799:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479c:	8b 40 04             	mov    0x4(%eax),%eax
8010479f:	83 ec 04             	sub    $0x4,%esp
801047a2:	52                   	push   %edx
801047a3:	68 00 c5 10 80       	push   $0x8010c500
801047a8:	50                   	push   %eax
801047a9:	e8 9f 45 00 00       	call   80108d4d <inituvm>
801047ae:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b4:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bd:	8b 40 18             	mov    0x18(%eax),%eax
801047c0:	83 ec 04             	sub    $0x4,%esp
801047c3:	6a 4c                	push   $0x4c
801047c5:	6a 00                	push   $0x0
801047c7:	50                   	push   %eax
801047c8:	e8 07 17 00 00       	call   80105ed4 <memset>
801047cd:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d3:	8b 40 18             	mov    0x18(%eax),%eax
801047d6:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047df:	8b 40 18             	mov    0x18(%eax),%eax
801047e2:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801047e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047eb:	8b 40 18             	mov    0x18(%eax),%eax
801047ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047f1:	8b 52 18             	mov    0x18(%edx),%edx
801047f4:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047f8:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801047fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ff:	8b 40 18             	mov    0x18(%eax),%eax
80104802:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104805:	8b 52 18             	mov    0x18(%edx),%edx
80104808:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010480c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104813:	8b 40 18             	mov    0x18(%eax),%eax
80104816:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010481d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104820:	8b 40 18             	mov    0x18(%eax),%eax
80104823:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482d:	8b 40 18             	mov    0x18(%eax),%eax
80104830:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483a:	83 c0 6c             	add    $0x6c,%eax
8010483d:	83 ec 04             	sub    $0x4,%esp
80104840:	6a 10                	push   $0x10
80104842:	68 84 96 10 80       	push   $0x80109684
80104847:	50                   	push   %eax
80104848:	e8 8a 18 00 00       	call   801060d7 <safestrcpy>
8010484d:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	68 8d 96 10 80       	push   $0x8010968d
80104858:	e8 70 dd ff ff       	call   801025cd <namei>
8010485d:	83 c4 10             	add    $0x10,%esp
80104860:	89 c2                	mov    %eax,%edx
80104862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104865:	89 50 68             	mov    %edx,0x68(%eax)
  p->parent = p;            // set up parent  -- change it later to zero
80104868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010486e:	89 50 14             	mov    %edx,0x14(%eax)
  // change the state
  // assert new state
  // insert into ready 

  #ifdef CS333_P3P4                             //*******not sure I should lock here
    acquire(&ptable.lock);
80104871:	83 ec 0c             	sub    $0xc,%esp
80104874:	68 80 39 11 80       	push   $0x80113980
80104879:	e8 f3 13 00 00       	call   80105c71 <acquire>
8010487e:	83 c4 10             	add    $0x10,%esp
    assertState(p, EMBRYO);
80104881:	83 ec 08             	sub    $0x8,%esp
80104884:	6a 01                	push   $0x1
80104886:	ff 75 f4             	pushl  -0xc(%ebp)
80104889:	e8 35 0f 00 00       	call   801057c3 <assertState>
8010488e:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, p);
80104891:	83 ec 08             	sub    $0x8,%esp
80104894:	ff 75 f4             	pushl  -0xc(%ebp)
80104897:	68 c8 5e 11 80       	push   $0x80115ec8
8010489c:	e8 6c 0f 00 00       	call   8010580d <removeFromStateList>
801048a1:	83 c4 10             	add    $0x10,%esp
    p->state = RUNNABLE;                        //************check this one
801048a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready, p);
801048ae:	83 ec 08             	sub    $0x8,%esp
801048b1:	ff 75 f4             	pushl  -0xc(%ebp)
801048b4:	68 b4 5e 11 80       	push   $0x80115eb4
801048b9:	e8 25 11 00 00       	call   801059e3 <insertTail>
801048be:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801048c1:	83 ec 0c             	sub    $0xc,%esp
801048c4:	68 80 39 11 80       	push   $0x80113980
801048c9:	e8 0a 14 00 00       	call   80105cd8 <release>
801048ce:	83 c4 10             	add    $0x10,%esp
  #else
    p->state = RUNNABLE;                        //************check this one
  #endif  
  p->uid = UID;
801048d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801048db:	00 00 00 
  p->gid = GID;
801048de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e1:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801048e8:	00 00 00 
}
801048eb:	90                   	nop
801048ec:	c9                   	leave  
801048ed:	c3                   	ret    

801048ee <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048ee:	55                   	push   %ebp
801048ef:	89 e5                	mov    %esp,%ebp
801048f1:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801048f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fa:	8b 00                	mov    (%eax),%eax
801048fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801048ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104903:	7e 31                	jle    80104936 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104905:	8b 55 08             	mov    0x8(%ebp),%edx
80104908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490b:	01 c2                	add    %eax,%edx
8010490d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104913:	8b 40 04             	mov    0x4(%eax),%eax
80104916:	83 ec 04             	sub    $0x4,%esp
80104919:	52                   	push   %edx
8010491a:	ff 75 f4             	pushl  -0xc(%ebp)
8010491d:	50                   	push   %eax
8010491e:	e8 77 45 00 00       	call   80108e9a <allocuvm>
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010492d:	75 3e                	jne    8010496d <growproc+0x7f>
      return -1;
8010492f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104934:	eb 59                	jmp    8010498f <growproc+0xa1>
  } else if(n < 0){
80104936:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010493a:	79 31                	jns    8010496d <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010493c:	8b 55 08             	mov    0x8(%ebp),%edx
8010493f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104942:	01 c2                	add    %eax,%edx
80104944:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494a:	8b 40 04             	mov    0x4(%eax),%eax
8010494d:	83 ec 04             	sub    $0x4,%esp
80104950:	52                   	push   %edx
80104951:	ff 75 f4             	pushl  -0xc(%ebp)
80104954:	50                   	push   %eax
80104955:	e8 09 46 00 00       	call   80108f63 <deallocuvm>
8010495a:	83 c4 10             	add    $0x10,%esp
8010495d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104960:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104964:	75 07                	jne    8010496d <growproc+0x7f>
      return -1;
80104966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010496b:	eb 22                	jmp    8010498f <growproc+0xa1>
  }
  proc->sz = sz;
8010496d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104973:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104976:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497e:	83 ec 0c             	sub    $0xc,%esp
80104981:	50                   	push   %eax
80104982:	e8 53 42 00 00       	call   80108bda <switchuvm>
80104987:	83 c4 10             	add    $0x10,%esp
  return 0;
8010498a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010498f:	c9                   	leave  
80104990:	c3                   	ret    

80104991 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104991:	55                   	push   %ebp
80104992:	89 e5                	mov    %esp,%ebp
80104994:	57                   	push   %edi
80104995:	56                   	push   %esi
80104996:	53                   	push   %ebx
80104997:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010499a:	e8 80 fb ff ff       	call   8010451f <allocproc>
8010499f:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049a6:	75 0a                	jne    801049b2 <fork+0x21>
    return -1;
801049a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049ad:	e9 22 02 00 00       	jmp    80104bd4 <fork+0x243>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b8:	8b 10                	mov    (%eax),%edx
801049ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c0:	8b 40 04             	mov    0x4(%eax),%eax
801049c3:	83 ec 08             	sub    $0x8,%esp
801049c6:	52                   	push   %edx
801049c7:	50                   	push   %eax
801049c8:	e8 34 47 00 00       	call   80109101 <copyuvm>
801049cd:	83 c4 10             	add    $0x10,%esp
801049d0:	89 c2                	mov    %eax,%edx
801049d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049d5:	89 50 04             	mov    %edx,0x4(%eax)
801049d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049db:	8b 40 04             	mov    0x4(%eax),%eax
801049de:	85 c0                	test   %eax,%eax
801049e0:	0f 85 86 00 00 00    	jne    80104a6c <fork+0xdb>
    kfree(np->kstack);
801049e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e9:	8b 40 08             	mov    0x8(%eax),%eax
801049ec:	83 ec 0c             	sub    $0xc,%esp
801049ef:	50                   	push   %eax
801049f0:	e8 79 e2 ff ff       	call   80102c6e <kfree>
801049f5:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801049f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049fb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

  #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104a02:	83 ec 0c             	sub    $0xc,%esp
80104a05:	68 80 39 11 80       	push   $0x80113980
80104a0a:	e8 62 12 00 00       	call   80105c71 <acquire>
80104a0f:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104a12:	83 ec 08             	sub    $0x8,%esp
80104a15:	6a 01                	push   $0x1
80104a17:	ff 75 e0             	pushl  -0x20(%ebp)
80104a1a:	e8 a4 0d 00 00       	call   801057c3 <assertState>
80104a1f:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, np);
80104a22:	83 ec 08             	sub    $0x8,%esp
80104a25:	ff 75 e0             	pushl  -0x20(%ebp)
80104a28:	68 c8 5e 11 80       	push   $0x80115ec8
80104a2d:	e8 db 0d 00 00       	call   8010580d <removeFromStateList>
80104a32:	83 c4 10             	add    $0x10,%esp

    np->state = UNUSED;                         // *** assert and add it back to free list
80104a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, np);
80104a3f:	83 ec 08             	sub    $0x8,%esp
80104a42:	ff 75 e0             	pushl  -0x20(%ebp)
80104a45:	68 b8 5e 11 80       	push   $0x80115eb8
80104a4a:	e8 fb 0f 00 00       	call   80105a4a <insertAtHead>
80104a4f:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	68 80 39 11 80       	push   $0x80113980
80104a5a:	e8 79 12 00 00       	call   80105cd8 <release>
80104a5f:	83 c4 10             	add    $0x10,%esp
  #else
    np->state = UNUSED;                         // *** assert and add it back to free list
  #endif

  return -1;
80104a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a67:	e9 68 01 00 00       	jmp    80104bd4 <fork+0x243>
  }
  np->sz = proc->sz;
80104a6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a72:	8b 10                	mov    (%eax),%edx
80104a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a77:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104a79:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a83:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a89:	8b 50 18             	mov    0x18(%eax),%edx
80104a8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a92:	8b 40 18             	mov    0x18(%eax),%eax
80104a95:	89 c3                	mov    %eax,%ebx
80104a97:	b8 13 00 00 00       	mov    $0x13,%eax
80104a9c:	89 d7                	mov    %edx,%edi
80104a9e:	89 de                	mov    %ebx,%esi
80104aa0:	89 c1                	mov    %eax,%ecx
80104aa2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->uid = proc->uid;
80104aa4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aaa:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab3:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104ab9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104abf:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ac8:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ad1:	8b 40 18             	mov    0x18(%eax),%eax
80104ad4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104adb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104ae2:	eb 43                	jmp    80104b27 <fork+0x196>
    if(proc->ofile[i])
80104ae4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104aed:	83 c2 08             	add    $0x8,%edx
80104af0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104af4:	85 c0                	test   %eax,%eax
80104af6:	74 2b                	je     80104b23 <fork+0x192>
      np->ofile[i] = filedup(proc->ofile[i]);
80104af8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b01:	83 c2 08             	add    $0x8,%edx
80104b04:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	50                   	push   %eax
80104b0c:	e8 94 c5 ff ff       	call   801010a5 <filedup>
80104b11:	83 c4 10             	add    $0x10,%esp
80104b14:	89 c1                	mov    %eax,%ecx
80104b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b1c:	83 c2 08             	add    $0x8,%edx
80104b1f:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b23:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b27:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b2b:	7e b7                	jle    80104ae4 <fork+0x153>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b33:	8b 40 68             	mov    0x68(%eax),%eax
80104b36:	83 ec 0c             	sub    $0xc,%esp
80104b39:	50                   	push   %eax
80104b3a:	e8 96 ce ff ff       	call   801019d5 <idup>
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	89 c2                	mov    %eax,%edx
80104b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b47:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b50:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b56:	83 c0 6c             	add    $0x6c,%eax
80104b59:	83 ec 04             	sub    $0x4,%esp
80104b5c:	6a 10                	push   $0x10
80104b5e:	52                   	push   %edx
80104b5f:	50                   	push   %eax
80104b60:	e8 72 15 00 00       	call   801060d7 <safestrcpy>
80104b65:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b6b:	8b 40 10             	mov    0x10(%eax),%eax
80104b6e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.

 #ifdef CS333_P3P4                          // ****** check this block
    acquire(&ptable.lock);
80104b71:	83 ec 0c             	sub    $0xc,%esp
80104b74:	68 80 39 11 80       	push   $0x80113980
80104b79:	e8 f3 10 00 00       	call   80105c71 <acquire>
80104b7e:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104b81:	83 ec 08             	sub    $0x8,%esp
80104b84:	6a 01                	push   $0x1
80104b86:	ff 75 e0             	pushl  -0x20(%ebp)
80104b89:	e8 35 0c 00 00       	call   801057c3 <assertState>
80104b8e:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, np);
80104b91:	83 ec 08             	sub    $0x8,%esp
80104b94:	ff 75 e0             	pushl  -0x20(%ebp)
80104b97:	68 c8 5e 11 80       	push   $0x80115ec8
80104b9c:	e8 6c 0c 00 00       	call   8010580d <removeFromStateList>
80104ba1:	83 c4 10             	add    $0x10,%esp
    np->state = RUNNABLE;
80104ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ba7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready, np);
80104bae:	83 ec 08             	sub    $0x8,%esp
80104bb1:	ff 75 e0             	pushl  -0x20(%ebp)
80104bb4:	68 b4 5e 11 80       	push   $0x80115eb4
80104bb9:	e8 25 0e 00 00       	call   801059e3 <insertTail>
80104bbe:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104bc1:	83 ec 0c             	sub    $0xc,%esp
80104bc4:	68 80 39 11 80       	push   $0x80113980
80104bc9:	e8 0a 11 00 00       	call   80105cd8 <release>
80104bce:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
    np->state = RUNNABLE;                   // *** repeat same logic as above  coming from Embryo to runnable
    release(&ptable.lock);
  #endif
  
  return pid;
80104bd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd7:	5b                   	pop    %ebx
80104bd8:	5e                   	pop    %esi
80104bd9:	5f                   	pop    %edi
80104bda:	5d                   	pop    %ebp
80104bdb:	c3                   	ret    

80104bdc <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104bdc:	55                   	push   %ebp
80104bdd:	89 e5                	mov    %esp,%ebp
80104bdf:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104be2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104be9:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104bee:	39 c2                	cmp    %eax,%edx
80104bf0:	75 0d                	jne    80104bff <exit+0x23>
    panic("init exiting");
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	68 8f 96 10 80       	push   $0x8010968f
80104bfa:	e8 67 b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104bff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c06:	eb 48                	jmp    80104c50 <exit+0x74>
    if(proc->ofile[fd]){
80104c08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c11:	83 c2 08             	add    $0x8,%edx
80104c14:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c18:	85 c0                	test   %eax,%eax
80104c1a:	74 30                	je     80104c4c <exit+0x70>
      fileclose(proc->ofile[fd]);
80104c1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c22:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c25:	83 c2 08             	add    $0x8,%edx
80104c28:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c2c:	83 ec 0c             	sub    $0xc,%esp
80104c2f:	50                   	push   %eax
80104c30:	e8 c1 c4 ff ff       	call   801010f6 <fileclose>
80104c35:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104c38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c41:	83 c2 08             	add    $0x8,%edx
80104c44:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c4b:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c4c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c50:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c54:	7e b2                	jle    80104c08 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c56:	e8 97 e9 ff ff       	call   801035f2 <begin_op>
  iput(proc->cwd);
80104c5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c61:	8b 40 68             	mov    0x68(%eax),%eax
80104c64:	83 ec 0c             	sub    $0xc,%esp
80104c67:	50                   	push   %eax
80104c68:	e8 72 cf ff ff       	call   80101bdf <iput>
80104c6d:	83 c4 10             	add    $0x10,%esp
  end_op();
80104c70:	e8 09 ea ff ff       	call   8010367e <end_op>
  proc->cwd = 0;
80104c75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c7b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	68 80 39 11 80       	push   $0x80113980
80104c8a:	e8 e2 0f 00 00       	call   80105c71 <acquire>
80104c8f:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104c92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c98:	8b 40 14             	mov    0x14(%eax),%eax
80104c9b:	83 ec 0c             	sub    $0xc,%esp
80104c9e:	50                   	push   %eax
80104c9f:	e8 30 06 00 00       	call   801052d4 <wakeup1>
80104ca4:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  // implemebt it later
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ca7:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104cae:	eb 3f                	jmp    80104cef <exit+0x113>
    if(p->parent == proc){
80104cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb3:	8b 50 14             	mov    0x14(%eax),%edx
80104cb6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cbc:	39 c2                	cmp    %eax,%edx
80104cbe:	75 28                	jne    80104ce8 <exit+0x10c>
      p->parent = initproc;
80104cc0:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc9:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)                 
80104ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ccf:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd2:	83 f8 05             	cmp    $0x5,%eax
80104cd5:	75 11                	jne    80104ce8 <exit+0x10c>
        wakeup1(initproc);
80104cd7:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	50                   	push   %eax
80104ce0:	e8 ef 05 00 00       	call   801052d4 <wakeup1>
80104ce5:	83 c4 10             	add    $0x10,%esp
  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  // implemebt it later
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ce8:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104cef:	81 7d f4 b4 5e 11 80 	cmpl   $0x80115eb4,-0xc(%ebp)
80104cf6:	72 b8                	jb     80104cb0 <exit+0xd4>
      if(p->state == ZOMBIE)                 
        wakeup1(initproc);
    }
  }

  if(removeFromStateList(&ptable.pLists.running, proc)){
80104cf8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cfe:	83 ec 08             	sub    $0x8,%esp
80104d01:	50                   	push   %eax
80104d02:	68 c4 5e 11 80       	push   $0x80115ec4
80104d07:	e8 01 0b 00 00       	call   8010580d <removeFromStateList>
80104d0c:	83 c4 10             	add    $0x10,%esp
80104d0f:	85 c0                	test   %eax,%eax
80104d11:	74 4a                	je     80104d5d <exit+0x181>
  assertState(proc, RUNNING);
80104d13:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d19:	83 ec 08             	sub    $0x8,%esp
80104d1c:	6a 04                	push   $0x4
80104d1e:	50                   	push   %eax
80104d1f:	e8 9f 0a 00 00       	call   801057c3 <assertState>
80104d24:	83 c4 10             	add    $0x10,%esp
  proc -> state = ZOMBIE;
80104d27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d2d:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  insertAtHead(&ptable.pLists.zombie, proc);
80104d34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d3a:	83 ec 08             	sub    $0x8,%esp
80104d3d:	50                   	push   %eax
80104d3e:	68 c0 5e 11 80       	push   $0x80115ec0
80104d43:	e8 02 0d 00 00       	call   80105a4a <insertAtHead>
80104d48:	83 c4 10             	add    $0x10,%esp
  }else{
    panic("Removing from the Exit call");
  }
  sched();
80104d4b:	e8 e8 02 00 00       	call   80105038 <sched>
  panic("zombie exit");
80104d50:	83 ec 0c             	sub    $0xc,%esp
80104d53:	68 b8 96 10 80       	push   $0x801096b8
80104d58:	e8 09 b8 ff ff       	call   80100566 <panic>
  if(removeFromStateList(&ptable.pLists.running, proc)){
  assertState(proc, RUNNING);
  proc -> state = ZOMBIE;
  insertAtHead(&ptable.pLists.zombie, proc);
  }else{
    panic("Removing from the Exit call");
80104d5d:	83 ec 0c             	sub    $0xc,%esp
80104d60:	68 9c 96 10 80       	push   $0x8010969c
80104d65:	e8 fc b7 ff ff       	call   80100566 <panic>

80104d6a <wait>:
  }
}
#else
int
wait(void)
{
80104d6a:	55                   	push   %ebp
80104d6b:	89 e5                	mov    %esp,%ebp
80104d6d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104d70:	83 ec 0c             	sub    $0xc,%esp
80104d73:	68 80 39 11 80       	push   $0x80113980
80104d78:	e8 f4 0e 00 00       	call   80105c71 <acquire>
80104d7d:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104d80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
80104d87:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80104d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      while(p){
80104d8f:	e9 db 00 00 00       	jmp    80104e6f <wait+0x105>
        if(p -> parent == proc){
80104d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d97:	8b 50 14             	mov    0x14(%eax),%edx
80104d9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da0:	39 c2                	cmp    %eax,%edx
80104da2:	0f 85 bb 00 00 00    	jne    80104e63 <wait+0xf9>
          havekids = 1;
80104da8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
          pid = p->pid;
80104daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db2:	8b 40 10             	mov    0x10(%eax),%eax
80104db5:	89 45 ec             	mov    %eax,-0x14(%ebp)
          kfree(p->kstack);
80104db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dbb:	8b 40 08             	mov    0x8(%eax),%eax
80104dbe:	83 ec 0c             	sub    $0xc,%esp
80104dc1:	50                   	push   %eax
80104dc2:	e8 a7 de ff ff       	call   80102c6e <kfree>
80104dc7:	83 c4 10             	add    $0x10,%esp
          p->kstack = 0;
80104dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dcd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          freevm(p->pgdir);
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	8b 40 04             	mov    0x4(%eax),%eax
80104dda:	83 ec 0c             	sub    $0xc,%esp
80104ddd:	50                   	push   %eax
80104dde:	e8 3d 42 00 00       	call   80109020 <freevm>
80104de3:	83 c4 10             	add    $0x10,%esp

          assertState(p, ZOMBIE);
80104de6:	83 ec 08             	sub    $0x8,%esp
80104de9:	6a 05                	push   $0x5
80104deb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dee:	e8 d0 09 00 00       	call   801057c3 <assertState>
80104df3:	83 c4 10             	add    $0x10,%esp
          removeFromStateList(&ptable.pLists.zombie, p);  
80104df6:	83 ec 08             	sub    $0x8,%esp
80104df9:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfc:	68 c0 5e 11 80       	push   $0x80115ec0
80104e01:	e8 07 0a 00 00       	call   8010580d <removeFromStateList>
80104e06:	83 c4 10             	add    $0x10,%esp
          p->state = UNUSED;
80104e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
          insertAtHead(&ptable.pLists.free, p);
80104e13:	83 ec 08             	sub    $0x8,%esp
80104e16:	ff 75 f4             	pushl  -0xc(%ebp)
80104e19:	68 b8 5e 11 80       	push   $0x80115eb8
80104e1e:	e8 27 0c 00 00       	call   80105a4a <insertAtHead>
80104e23:	83 c4 10             	add    $0x10,%esp
          p->pid = 0;
80104e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e29:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
          p->parent = 0;
80104e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e33:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
          p->name[0] = 0;
80104e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
          p->killed = 0;
80104e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e44:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
          release(&ptable.lock);
80104e4b:	83 ec 0c             	sub    $0xc,%esp
80104e4e:	68 80 39 11 80       	push   $0x80113980
80104e53:	e8 80 0e 00 00       	call   80105cd8 <release>
80104e58:	83 c4 10             	add    $0x10,%esp
          return pid; 
80104e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e5e:	e9 ce 00 00 00       	jmp    80104f31 <wait+0x1c7>
        }else{
          p = p -> next;                         // ****** not sure about this one
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
      while(p){
80104e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e73:	0f 85 1b ff ff ff    	jne    80104d94 <wait+0x2a>
        }else{
          p = p -> next;                         // ****** not sure about this one
      }     
  }

  if(traverseList(&ptable.pLists.ready)){
80104e79:	83 ec 0c             	sub    $0xc,%esp
80104e7c:	68 b4 5e 11 80       	push   $0x80115eb4
80104e81:	e8 3d 0a 00 00       	call   801058c3 <traverseList>
80104e86:	83 c4 10             	add    $0x10,%esp
80104e89:	85 c0                	test   %eax,%eax
80104e8b:	74 09                	je     80104e96 <wait+0x12c>
    havekids = 1;
80104e8d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104e94:	eb 55                	jmp    80104eeb <wait+0x181>
  }else if(traverseList(&ptable.pLists.running)){
80104e96:	83 ec 0c             	sub    $0xc,%esp
80104e99:	68 c4 5e 11 80       	push   $0x80115ec4
80104e9e:	e8 20 0a 00 00       	call   801058c3 <traverseList>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	74 09                	je     80104eb3 <wait+0x149>
    havekids = 1;
80104eaa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104eb1:	eb 38                	jmp    80104eeb <wait+0x181>
  }else if(traverseList(&ptable.pLists.sleep)){
80104eb3:	83 ec 0c             	sub    $0xc,%esp
80104eb6:	68 bc 5e 11 80       	push   $0x80115ebc
80104ebb:	e8 03 0a 00 00       	call   801058c3 <traverseList>
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	85 c0                	test   %eax,%eax
80104ec5:	74 09                	je     80104ed0 <wait+0x166>
    havekids = 1;
80104ec7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104ece:	eb 1b                	jmp    80104eeb <wait+0x181>
  }else if(traverseList(&ptable.pLists.embryo)){
80104ed0:	83 ec 0c             	sub    $0xc,%esp
80104ed3:	68 c8 5e 11 80       	push   $0x80115ec8
80104ed8:	e8 e6 09 00 00       	call   801058c3 <traverseList>
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	74 07                	je     80104eeb <wait+0x181>
    havekids =1;
80104ee4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  }  

  // traverse through all the lists except free and zombie and check p -> parent == proc
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104eeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104eef:	74 0d                	je     80104efe <wait+0x194>
80104ef1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef7:	8b 40 24             	mov    0x24(%eax),%eax
80104efa:	85 c0                	test   %eax,%eax
80104efc:	74 17                	je     80104f15 <wait+0x1ab>
      release(&ptable.lock);
80104efe:	83 ec 0c             	sub    $0xc,%esp
80104f01:	68 80 39 11 80       	push   $0x80113980
80104f06:	e8 cd 0d 00 00       	call   80105cd8 <release>
80104f0b:	83 c4 10             	add    $0x10,%esp
      return -1;
80104f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f13:	eb 1c                	jmp    80104f31 <wait+0x1c7>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104f15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f1b:	83 ec 08             	sub    $0x8,%esp
80104f1e:	68 80 39 11 80       	push   $0x80113980
80104f23:	50                   	push   %eax
80104f24:	e8 c4 02 00 00       	call   801051ed <sleep>
80104f29:	83 c4 10             	add    $0x10,%esp
  }
80104f2c:	e9 4f fe ff ff       	jmp    80104d80 <wait+0x16>
  return 0;  // placeholder
}
80104f31:	c9                   	leave  
80104f32:	c3                   	ret    

80104f33 <scheduler>:
}

#else
void
scheduler(void)
{
80104f33:	55                   	push   %ebp
80104f34:	89 e5                	mov    %esp,%ebp
80104f36:	83 ec 18             	sub    $0x18,%esp
struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104f39:	e8 bc f5 ff ff       	call   801044fa <sti>

    idle = 1;  // assume idle unless we schedule a process
80104f3e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104f45:	83 ec 0c             	sub    $0xc,%esp
80104f48:	68 80 39 11 80       	push   $0x80113980
80104f4d:	e8 1f 0d 00 00       	call   80105c71 <acquire>
80104f52:	83 c4 10             	add    $0x10,%esp
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.

      
      if(ptable.pLists.ready){
80104f55:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80104f5a:	85 c0                	test   %eax,%eax
80104f5c:	0f 84 ad 00 00 00    	je     8010500f <scheduler+0xdc>
        p = removeFront(&ptable.pLists.ready);                            //****check this logic
80104f62:	83 ec 0c             	sub    $0xc,%esp
80104f65:	68 b4 5e 11 80       	push   $0x80115eb4
80104f6a:	e8 46 0a 00 00       	call   801059b5 <removeFront>
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
        assertState(p, RUNNABLE);
80104f75:	83 ec 08             	sub    $0x8,%esp
80104f78:	6a 03                	push   $0x3
80104f7a:	ff 75 f0             	pushl  -0x10(%ebp)
80104f7d:	e8 41 08 00 00       	call   801057c3 <assertState>
80104f82:	83 c4 10             	add    $0x10,%esp

      idle = 0;  // not idle this timeslice
80104f85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      proc = p;
80104f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f8f:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	ff 75 f0             	pushl  -0x10(%ebp)
80104f9b:	e8 3a 3c 00 00       	call   80108bda <switchuvm>
80104fa0:	83 c4 10             	add    $0x10,%esp
      p->cpu_ticks_in = ticks;
80104fa3:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
80104fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fac:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      p->state = RUNNING;
80104fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb5:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      assertState(p, RUNNING);
80104fbc:	83 ec 08             	sub    $0x8,%esp
80104fbf:	6a 04                	push   $0x4
80104fc1:	ff 75 f0             	pushl  -0x10(%ebp)
80104fc4:	e8 fa 07 00 00       	call   801057c3 <assertState>
80104fc9:	83 c4 10             	add    $0x10,%esp
      insertAtHead(&ptable.pLists.running, p);
80104fcc:	83 ec 08             	sub    $0x8,%esp
80104fcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd2:	68 c4 5e 11 80       	push   $0x80115ec4
80104fd7:	e8 6e 0a 00 00       	call   80105a4a <insertAtHead>
80104fdc:	83 c4 10             	add    $0x10,%esp

      swtch(&cpu->scheduler, proc->context);
80104fdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fe5:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fe8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fef:	83 c2 04             	add    $0x4,%edx
80104ff2:	83 ec 08             	sub    $0x8,%esp
80104ff5:	50                   	push   %eax
80104ff6:	52                   	push   %edx
80104ff7:	e8 4c 11 00 00       	call   80106148 <swtch>
80104ffc:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104fff:	e8 b9 3b 00 00       	call   80108bbd <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80105004:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010500b:	00 00 00 00 

    }
  
    release(&ptable.lock);
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	68 80 39 11 80       	push   $0x80113980
80105017:	e8 bc 0c 00 00       	call   80105cd8 <release>
8010501c:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
8010501f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105023:	0f 84 10 ff ff ff    	je     80104f39 <scheduler+0x6>
      sti();
80105029:	e8 cc f4 ff ff       	call   801044fa <sti>
      hlt();
8010502e:	e8 b0 f4 ff ff       	call   801044e3 <hlt>
    }
  }
80105033:	e9 01 ff ff ff       	jmp    80104f39 <scheduler+0x6>

80105038 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80105038:	55                   	push   %ebp
80105039:	89 e5                	mov    %esp,%ebp
8010503b:	53                   	push   %ebx
8010503c:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
8010503f:	83 ec 0c             	sub    $0xc,%esp
80105042:	68 80 39 11 80       	push   $0x80113980
80105047:	e8 58 0d 00 00       	call   80105da4 <holding>
8010504c:	83 c4 10             	add    $0x10,%esp
8010504f:	85 c0                	test   %eax,%eax
80105051:	75 0d                	jne    80105060 <sched+0x28>
    panic("sched ptable.lock");
80105053:	83 ec 0c             	sub    $0xc,%esp
80105056:	68 c4 96 10 80       	push   $0x801096c4
8010505b:	e8 06 b5 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105060:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105066:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010506c:	83 f8 01             	cmp    $0x1,%eax
8010506f:	74 0d                	je     8010507e <sched+0x46>
    panic("sched locks");
80105071:	83 ec 0c             	sub    $0xc,%esp
80105074:	68 d6 96 10 80       	push   $0x801096d6
80105079:	e8 e8 b4 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
8010507e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105084:	8b 40 0c             	mov    0xc(%eax),%eax
80105087:	83 f8 04             	cmp    $0x4,%eax
8010508a:	75 0d                	jne    80105099 <sched+0x61>
    panic("sched running");
8010508c:	83 ec 0c             	sub    $0xc,%esp
8010508f:	68 e2 96 10 80       	push   $0x801096e2
80105094:	e8 cd b4 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105099:	e8 4c f4 ff ff       	call   801044ea <readeflags>
8010509e:	25 00 02 00 00       	and    $0x200,%eax
801050a3:	85 c0                	test   %eax,%eax
801050a5:	74 0d                	je     801050b4 <sched+0x7c>
    panic("sched interruptible");
801050a7:	83 ec 0c             	sub    $0xc,%esp
801050aa:	68 f0 96 10 80       	push   $0x801096f0
801050af:	e8 b2 b4 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
801050b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050ba:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801050c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;
801050c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050d0:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801050d6:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
801050dc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050e3:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801050e9:	29 d3                	sub    %edx,%ebx
801050eb:	89 da                	mov    %ebx,%edx
801050ed:	01 ca                	add    %ecx,%edx
801050ef:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
801050f5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050fb:	8b 40 04             	mov    0x4(%eax),%eax
801050fe:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105105:	83 c2 1c             	add    $0x1c,%edx
80105108:	83 ec 08             	sub    $0x8,%esp
8010510b:	50                   	push   %eax
8010510c:	52                   	push   %edx
8010510d:	e8 36 10 00 00       	call   80106148 <swtch>
80105112:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105115:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010511b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010511e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105124:	90                   	nop
80105125:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105128:	c9                   	leave  
80105129:	c3                   	ret    

8010512a <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010512a:	55                   	push   %ebp
8010512b:	89 e5                	mov    %esp,%ebp
8010512d:	83 ec 08             	sub    $0x8,%esp
  #ifdef CS333_P3P4                             // ******* check out this one
    acquire(&ptable.lock);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	68 80 39 11 80       	push   $0x80113980
80105138:	e8 34 0b 00 00       	call   80105c71 <acquire>
8010513d:	83 c4 10             	add    $0x10,%esp
    assertState(proc, RUNNING);
80105140:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105146:	83 ec 08             	sub    $0x8,%esp
80105149:	6a 04                	push   $0x4
8010514b:	50                   	push   %eax
8010514c:	e8 72 06 00 00       	call   801057c3 <assertState>
80105151:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.running, proc);
80105154:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010515a:	83 ec 08             	sub    $0x8,%esp
8010515d:	50                   	push   %eax
8010515e:	68 c4 5e 11 80       	push   $0x80115ec4
80105163:	e8 a5 06 00 00       	call   8010580d <removeFromStateList>
80105168:	83 c4 10             	add    $0x10,%esp
    proc -> state = RUNNABLE;
8010516b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105171:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready, proc);
80105178:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010517e:	83 ec 08             	sub    $0x8,%esp
80105181:	50                   	push   %eax
80105182:	68 b4 5e 11 80       	push   $0x80115eb4
80105187:	e8 57 08 00 00       	call   801059e3 <insertTail>
8010518c:	83 c4 10             	add    $0x10,%esp
    sched();
8010518f:	e8 a4 fe ff ff       	call   80105038 <sched>
    release(&ptable.lock);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	68 80 39 11 80       	push   $0x80113980
8010519c:	e8 37 0b 00 00       	call   80105cd8 <release>
801051a1:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;     // insert at tail remove from runnig and add to runnable:
    sched();
    release(&ptable.lock);
  #endif
}
801051a4:	90                   	nop
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    

801051a7 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801051a7:	55                   	push   %ebp
801051a8:	89 e5                	mov    %esp,%ebp
801051aa:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	68 80 39 11 80       	push   $0x80113980
801051b5:	e8 1e 0b 00 00       	call   80105cd8 <release>
801051ba:	83 c4 10             	add    $0x10,%esp

  if (first) {
801051bd:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801051c2:	85 c0                	test   %eax,%eax
801051c4:	74 24                	je     801051ea <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801051c6:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
801051cd:	00 00 00 
    iinit(ROOTDEV);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	6a 01                	push   $0x1
801051d5:	e8 09 c5 ff ff       	call   801016e3 <iinit>
801051da:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801051dd:	83 ec 0c             	sub    $0xc,%esp
801051e0:	6a 01                	push   $0x1
801051e2:	e8 ed e1 ff ff       	call   801033d4 <initlog>
801051e7:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801051ea:	90                   	nop
801051eb:	c9                   	leave  
801051ec:	c3                   	ret    

801051ed <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801051ed:	55                   	push   %ebp
801051ee:	89 e5                	mov    %esp,%ebp
801051f0:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801051f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051f9:	85 c0                	test   %eax,%eax
801051fb:	75 0d                	jne    8010520a <sleep+0x1d>
    panic("sleep");
801051fd:	83 ec 0c             	sub    $0xc,%esp
80105200:	68 04 97 10 80       	push   $0x80109704
80105205:	e8 5c b3 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
8010520a:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80105211:	74 24                	je     80105237 <sleep+0x4a>
    acquire(&ptable.lock);
80105213:	83 ec 0c             	sub    $0xc,%esp
80105216:	68 80 39 11 80       	push   $0x80113980
8010521b:	e8 51 0a 00 00       	call   80105c71 <acquire>
80105220:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105223:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105227:	74 0e                	je     80105237 <sleep+0x4a>
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	ff 75 0c             	pushl  0xc(%ebp)
8010522f:	e8 a4 0a 00 00       	call   80105cd8 <release>
80105234:	83 c4 10             	add    $0x10,%esp
  }

  #ifdef CS333_P3P4                         // ******check it out 
    //acquire(&ptable.lock);
    assertState(proc, RUNNING);
80105237:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010523d:	83 ec 08             	sub    $0x8,%esp
80105240:	6a 04                	push   $0x4
80105242:	50                   	push   %eax
80105243:	e8 7b 05 00 00       	call   801057c3 <assertState>
80105248:	83 c4 10             	add    $0x10,%esp
    proc -> chan = chan;
8010524b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105251:	8b 55 08             	mov    0x8(%ebp),%edx
80105254:	89 50 20             	mov    %edx,0x20(%eax)
    removeFromStateList(&ptable.pLists.running, proc);
80105257:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010525d:	83 ec 08             	sub    $0x8,%esp
80105260:	50                   	push   %eax
80105261:	68 c4 5e 11 80       	push   $0x80115ec4
80105266:	e8 a2 05 00 00       	call   8010580d <removeFromStateList>
8010526b:	83 c4 10             	add    $0x10,%esp
    proc->state = SLEEPING;
8010526e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105274:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    insertAtHead(&ptable.pLists.sleep, proc);
8010527b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105281:	83 ec 08             	sub    $0x8,%esp
80105284:	50                   	push   %eax
80105285:	68 bc 5e 11 80       	push   $0x80115ebc
8010528a:	e8 bb 07 00 00       	call   80105a4a <insertAtHead>
8010528f:	83 c4 10             	add    $0x10,%esp
  // Go to sleep.
  proc->chan = chan;      // remove it from running list and add it to the sleeping ....add flag first locally
  proc->state = SLEEPING;
  #endif

  sched();
80105292:	e8 a1 fd ff ff       	call   80105038 <sched>

  // Tidy up.
  proc->chan = 0;
80105297:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010529d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801052a4:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
801052ab:	74 24                	je     801052d1 <sleep+0xe4>
    release(&ptable.lock);
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	68 80 39 11 80       	push   $0x80113980
801052b5:	e8 1e 0a 00 00       	call   80105cd8 <release>
801052ba:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801052bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801052c1:	74 0e                	je     801052d1 <sleep+0xe4>
801052c3:	83 ec 0c             	sub    $0xc,%esp
801052c6:	ff 75 0c             	pushl  0xc(%ebp)
801052c9:	e8 a3 09 00 00       	call   80105c71 <acquire>
801052ce:	83 c4 10             	add    $0x10,%esp
  }
}
801052d1:	90                   	nop
801052d2:	c9                   	leave  
801052d3:	c3                   	ret    

801052d4 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)                   // ****** check it out --- should I hold the lock
{
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;
801052da:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
801052df:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(current){
801052e2:	e9 8c 00 00 00       	jmp    80105373 <wakeup1+0x9f>
    if(current -> chan == chan){
801052e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ea:	8b 40 20             	mov    0x20(%eax),%eax
801052ed:	3b 45 08             	cmp    0x8(%ebp),%eax
801052f0:	75 75                	jne    80105367 <wakeup1+0x93>
      temp = current -> next;
801052f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052f5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801052fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      assertState(current, SLEEPING);
801052fe:	83 ec 08             	sub    $0x8,%esp
80105301:	6a 02                	push   $0x2
80105303:	ff 75 f4             	pushl  -0xc(%ebp)
80105306:	e8 b8 04 00 00       	call   801057c3 <assertState>
8010530b:	83 c4 10             	add    $0x10,%esp
      if(removeFromStateList(&ptable.pLists.sleep, current)){
8010530e:	83 ec 08             	sub    $0x8,%esp
80105311:	ff 75 f4             	pushl  -0xc(%ebp)
80105314:	68 bc 5e 11 80       	push   $0x80115ebc
80105319:	e8 ef 04 00 00       	call   8010580d <removeFromStateList>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	85 c0                	test   %eax,%eax
80105323:	74 35                	je     8010535a <wakeup1+0x86>
      current -> state = RUNNABLE;
80105325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105328:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      assertState(current, RUNNABLE);
8010532f:	83 ec 08             	sub    $0x8,%esp
80105332:	6a 03                	push   $0x3
80105334:	ff 75 f4             	pushl  -0xc(%ebp)
80105337:	e8 87 04 00 00       	call   801057c3 <assertState>
8010533c:	83 c4 10             	add    $0x10,%esp
      insertTail(&ptable.pLists.ready, current);
8010533f:	83 ec 08             	sub    $0x8,%esp
80105342:	ff 75 f4             	pushl  -0xc(%ebp)
80105345:	68 b4 5e 11 80       	push   $0x80115eb4
8010534a:	e8 94 06 00 00       	call   801059e3 <insertTail>
8010534f:	83 c4 10             	add    $0x10,%esp
      }else{
        panic("wakeup1 not doing the job");
      }
      current = temp;    
80105352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105355:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105358:	eb 19                	jmp    80105373 <wakeup1+0x9f>
      if(removeFromStateList(&ptable.pLists.sleep, current)){
      current -> state = RUNNABLE;
      assertState(current, RUNNABLE);
      insertTail(&ptable.pLists.ready, current);
      }else{
        panic("wakeup1 not doing the job");
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	68 0a 97 10 80       	push   $0x8010970a
80105362:	e8 ff b1 ff ff       	call   80100566 <panic>
      }
      current = temp;    
    }else{
      current = current -> next;
80105367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105370:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;

  while(current){
80105373:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105377:	0f 85 6a ff ff ff    	jne    801052e7 <wakeup1+0x13>
      current = temp;    
    }else{
      current = current -> next;
    }
  }  
}
8010537d:	90                   	nop
8010537e:	c9                   	leave  
8010537f:	c3                   	ret    

80105380 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105386:	83 ec 0c             	sub    $0xc,%esp
80105389:	68 80 39 11 80       	push   $0x80113980
8010538e:	e8 de 08 00 00       	call   80105c71 <acquire>
80105393:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105396:	83 ec 0c             	sub    $0xc,%esp
80105399:	ff 75 08             	pushl  0x8(%ebp)
8010539c:	e8 33 ff ff ff       	call   801052d4 <wakeup1>
801053a1:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801053a4:	83 ec 0c             	sub    $0xc,%esp
801053a7:	68 80 39 11 80       	push   $0x80113980
801053ac:	e8 27 09 00 00       	call   80105cd8 <release>
801053b1:	83 c4 10             	add    $0x10,%esp
}
801053b4:	90                   	nop
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    

801053b7 <kill>:
  return -1;
}
#else
int
kill(int pid)                 //******* move the logic from the helper function here
{
801053b7:	55                   	push   %ebp
801053b8:	89 e5                	mov    %esp,%ebp
801053ba:	83 ec 08             	sub    $0x8,%esp
  if(traverseToKill(&ptable.pLists.sleep, pid) == 0)
801053bd:	83 ec 08             	sub    $0x8,%esp
801053c0:	ff 75 08             	pushl  0x8(%ebp)
801053c3:	68 bc 5e 11 80       	push   $0x80115ebc
801053c8:	e8 36 05 00 00       	call   80105903 <traverseToKill>
801053cd:	83 c4 10             	add    $0x10,%esp
801053d0:	85 c0                	test   %eax,%eax
801053d2:	75 07                	jne    801053db <kill+0x24>
  return 1;
801053d4:	b8 01 00 00 00       	mov    $0x1,%eax
801053d9:	eb 7d                	jmp    80105458 <kill+0xa1>
  if(traverseToKill(&ptable.pLists.ready, pid) == 0)
801053db:	83 ec 08             	sub    $0x8,%esp
801053de:	ff 75 08             	pushl  0x8(%ebp)
801053e1:	68 b4 5e 11 80       	push   $0x80115eb4
801053e6:	e8 18 05 00 00       	call   80105903 <traverseToKill>
801053eb:	83 c4 10             	add    $0x10,%esp
801053ee:	85 c0                	test   %eax,%eax
801053f0:	75 07                	jne    801053f9 <kill+0x42>
  return 1;
801053f2:	b8 01 00 00 00       	mov    $0x1,%eax
801053f7:	eb 5f                	jmp    80105458 <kill+0xa1>
  if(traverseToKill(&ptable.pLists.zombie, pid) == 0)
801053f9:	83 ec 08             	sub    $0x8,%esp
801053fc:	ff 75 08             	pushl  0x8(%ebp)
801053ff:	68 c0 5e 11 80       	push   $0x80115ec0
80105404:	e8 fa 04 00 00       	call   80105903 <traverseToKill>
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	85 c0                	test   %eax,%eax
8010540e:	75 07                	jne    80105417 <kill+0x60>
  return 1; 
80105410:	b8 01 00 00 00       	mov    $0x1,%eax
80105415:	eb 41                	jmp    80105458 <kill+0xa1>
  if(traverseToKill(&ptable.pLists.running, pid) == 0)
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	ff 75 08             	pushl  0x8(%ebp)
8010541d:	68 c4 5e 11 80       	push   $0x80115ec4
80105422:	e8 dc 04 00 00       	call   80105903 <traverseToKill>
80105427:	83 c4 10             	add    $0x10,%esp
8010542a:	85 c0                	test   %eax,%eax
8010542c:	75 07                	jne    80105435 <kill+0x7e>
  return 1;
8010542e:	b8 01 00 00 00       	mov    $0x1,%eax
80105433:	eb 23                	jmp    80105458 <kill+0xa1>
  if(traverseToKill(&ptable.pLists.embryo, pid) == 0)
80105435:	83 ec 08             	sub    $0x8,%esp
80105438:	ff 75 08             	pushl  0x8(%ebp)
8010543b:	68 c8 5e 11 80       	push   $0x80115ec8
80105440:	e8 be 04 00 00       	call   80105903 <traverseToKill>
80105445:	83 c4 10             	add    $0x10,%esp
80105448:	85 c0                	test   %eax,%eax
8010544a:	75 07                	jne    80105453 <kill+0x9c>
  return 1;
8010544c:	b8 01 00 00 00       	mov    $0x1,%eax
80105451:	eb 05                	jmp    80105458 <kill+0xa1>


  return -1;  // placeholder
80105453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105458:	c9                   	leave  
80105459:	c3                   	ret    

8010545a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010545a:	55                   	push   %ebp
8010545b:	89 e5                	mov    %esp,%ebp
8010545d:	57                   	push   %edi
8010545e:	56                   	push   %esi
8010545f:	53                   	push   %ebx
80105460:	83 ec 6c             	sub    $0x6c,%esp
  int time_difference; 
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tState\tName\tUID\tGID\tPPID\tCPU\tSIZE\tElapsed\t PCs\n");
80105463:	83 ec 0c             	sub    $0xc,%esp
80105466:	68 4c 97 10 80       	push   $0x8010974c
8010546b:	e8 56 af ff ff       	call   801003c6 <cprintf>
80105470:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105473:	c7 45 e0 b4 39 11 80 	movl   $0x801139b4,-0x20(%ebp)
8010547a:	e9 9e 01 00 00       	jmp    8010561d <procdump+0x1c3>
    if(p->state == UNUSED)
8010547f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105482:	8b 40 0c             	mov    0xc(%eax),%eax
80105485:	85 c0                	test   %eax,%eax
80105487:	0f 84 88 01 00 00    	je     80105615 <procdump+0x1bb>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state]){
8010548d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105490:	8b 40 0c             	mov    0xc(%eax),%eax
80105493:	83 f8 05             	cmp    $0x5,%eax
80105496:	77 23                	ja     801054bb <procdump+0x61>
80105498:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010549b:	8b 40 0c             	mov    0xc(%eax),%eax
8010549e:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801054a5:	85 c0                	test   %eax,%eax
801054a7:	74 12                	je     801054bb <procdump+0x61>
      state = states[p->state];
801054a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054ac:	8b 40 0c             	mov    0xc(%eax),%eax
801054af:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801054b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
801054b9:	eb 07                	jmp    801054c2 <procdump+0x68>
    }	
    else
      state = "???";
801054bb:	c7 45 dc 7f 97 10 80 	movl   $0x8010977f,-0x24(%ebp)
      time_difference = ticks - p->start_ticks;
801054c2:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
801054c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054cb:	8b 40 7c             	mov    0x7c(%eax),%eax
801054ce:	29 c2                	sub    %eax,%edx
801054d0:	89 d0                	mov    %edx,%eax
801054d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
      seconds = (time_difference)/1000;
801054d5:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801054d8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
801054dd:	89 c8                	mov    %ecx,%eax
801054df:	f7 ea                	imul   %edx
801054e1:	c1 fa 06             	sar    $0x6,%edx
801054e4:	89 c8                	mov    %ecx,%eax
801054e6:	c1 f8 1f             	sar    $0x1f,%eax
801054e9:	29 c2                	sub    %eax,%edx
801054eb:	89 d0                	mov    %edx,%eax
801054ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      time_difference -= seconds * 1000;
801054f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801054f3:	69 c0 18 fc ff ff    	imul   $0xfffffc18,%eax,%eax
801054f9:	01 45 d8             	add    %eax,-0x28(%ebp)
      milliseconds = time_difference/100;
801054fc:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801054ff:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105504:	89 c8                	mov    %ecx,%eax
80105506:	f7 ea                	imul   %edx
80105508:	c1 fa 05             	sar    $0x5,%edx
8010550b:	89 c8                	mov    %ecx,%eax
8010550d:	c1 f8 1f             	sar    $0x1f,%eax
80105510:	29 c2                	sub    %eax,%edx
80105512:	89 d0                	mov    %edx,%eax
80105514:	89 45 d0             	mov    %eax,-0x30(%ebp)
      time_difference -= milliseconds *100;
80105517:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010551a:	6b c0 9c             	imul   $0xffffff9c,%eax,%eax
8010551d:	01 45 d8             	add    %eax,-0x28(%ebp)
      temp = (time_difference)/10;
80105520:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105523:	ba 67 66 66 66       	mov    $0x66666667,%edx
80105528:	89 c8                	mov    %ecx,%eax
8010552a:	f7 ea                	imul   %edx
8010552c:	c1 fa 02             	sar    $0x2,%edx
8010552f:	89 c8                	mov    %ecx,%eax
80105531:	c1 f8 1f             	sar    $0x1f,%eax
80105534:	29 c2                	sub    %eax,%edx
80105536:	89 d0                	mov    %edx,%eax
80105538:	89 45 cc             	mov    %eax,-0x34(%ebp)
      time_difference -= temp * 10; 
8010553b:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010553e:	6b c0 f6             	imul   $0xfffffff6,%eax,%eax
80105541:	01 45 d8             	add    %eax,-0x28(%ebp)
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
80105544:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105547:	8b 38                	mov    (%eax),%edi
80105549:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010554c:	8b b0 88 00 00 00    	mov    0x88(%eax),%esi
80105552:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105555:	8b 40 14             	mov    0x14(%eax),%eax
80105558:	8b 58 10             	mov    0x10(%eax),%ebx
8010555b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010555e:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105564:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105567:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010556d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105570:	83 c0 6c             	add    $0x6c,%eax
80105573:	89 45 94             	mov    %eax,-0x6c(%ebp)
80105576:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105579:	8b 40 10             	mov    0x10(%eax),%eax
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	ff 75 d8             	pushl  -0x28(%ebp)
80105582:	ff 75 cc             	pushl  -0x34(%ebp)
80105585:	ff 75 d0             	pushl  -0x30(%ebp)
80105588:	ff 75 d4             	pushl  -0x2c(%ebp)
8010558b:	57                   	push   %edi
8010558c:	56                   	push   %esi
8010558d:	53                   	push   %ebx
8010558e:	51                   	push   %ecx
8010558f:	52                   	push   %edx
80105590:	ff 75 94             	pushl  -0x6c(%ebp)
80105593:	ff 75 dc             	pushl  -0x24(%ebp)
80105596:	50                   	push   %eax
80105597:	68 84 97 10 80       	push   $0x80109784
8010559c:	e8 25 ae ff ff       	call   801003c6 <cprintf>
801055a1:	83 c4 40             	add    $0x40,%esp
    if(p->state == SLEEPING){
801055a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055a7:	8b 40 0c             	mov    0xc(%eax),%eax
801055aa:	83 f8 02             	cmp    $0x2,%eax
801055ad:	75 54                	jne    80105603 <procdump+0x1a9>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801055af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055b2:	8b 40 1c             	mov    0x1c(%eax),%eax
801055b5:	8b 40 0c             	mov    0xc(%eax),%eax
801055b8:	83 c0 08             	add    $0x8,%eax
801055bb:	89 c2                	mov    %eax,%edx
801055bd:	83 ec 08             	sub    $0x8,%esp
801055c0:	8d 45 a4             	lea    -0x5c(%ebp),%eax
801055c3:	50                   	push   %eax
801055c4:	52                   	push   %edx
801055c5:	e8 60 07 00 00       	call   80105d2a <getcallerpcs>
801055ca:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801055cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801055d4:	eb 1c                	jmp    801055f2 <procdump+0x198>
        cprintf(" %p", pc[i]);
801055d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801055d9:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
801055dd:	83 ec 08             	sub    $0x8,%esp
801055e0:	50                   	push   %eax
801055e1:	68 a7 97 10 80       	push   $0x801097a7
801055e6:	e8 db ad ff ff       	call   801003c6 <cprintf>
801055eb:	83 c4 10             	add    $0x10,%esp
      time_difference -= temp * 10; 
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801055ee:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801055f2:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
801055f6:	7f 0b                	jg     80105603 <procdump+0x1a9>
801055f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801055fb:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
801055ff:	85 c0                	test   %eax,%eax
80105601:	75 d3                	jne    801055d6 <procdump+0x17c>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105603:	83 ec 0c             	sub    $0xc,%esp
80105606:	68 ab 97 10 80       	push   $0x801097ab
8010560b:	e8 b6 ad ff ff       	call   801003c6 <cprintf>
80105610:	83 c4 10             	add    $0x10,%esp
80105613:	eb 01                	jmp    80105616 <procdump+0x1bc>
  int temp;
   
  cprintf("PID\tState\tName\tUID\tGID\tPPID\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105615:	90                   	nop
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tState\tName\tUID\tGID\tPPID\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105616:	81 45 e0 94 00 00 00 	addl   $0x94,-0x20(%ebp)
8010561d:	81 7d e0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x20(%ebp)
80105624:	0f 82 55 fe ff ff    	jb     8010547f <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
8010562a:	90                   	nop
8010562b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010562e:	5b                   	pop    %ebx
8010562f:	5e                   	pop    %esi
80105630:	5f                   	pop    %edi
80105631:	5d                   	pop    %ebp
80105632:	c3                   	ret    

80105633 <getprocs>:

int
getprocs(uint max, struct uproc* table){
80105633:	55                   	push   %ebp
80105634:	89 e5                	mov    %esp,%ebp
80105636:	83 ec 18             	sub    $0x18,%esp
  int index = 0;      // which is my count of processes at the same time
80105639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  
    acquire(&ptable.lock);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	68 80 39 11 80       	push   $0x80113980
80105648:	e8 24 06 00 00       	call   80105c71 <acquire>
8010564d:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
80105650:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80105657:	e9 3d 01 00 00       	jmp    80105799 <getprocs+0x166>
      if(p->state == RUNNABLE || p->state == SLEEPING || p->state == RUNNING){
8010565c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010565f:	8b 40 0c             	mov    0xc(%eax),%eax
80105662:	83 f8 03             	cmp    $0x3,%eax
80105665:	74 1a                	je     80105681 <getprocs+0x4e>
80105667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566a:	8b 40 0c             	mov    0xc(%eax),%eax
8010566d:	83 f8 02             	cmp    $0x2,%eax
80105670:	74 0f                	je     80105681 <getprocs+0x4e>
80105672:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105675:	8b 40 0c             	mov    0xc(%eax),%eax
80105678:	83 f8 04             	cmp    $0x4,%eax
8010567b:	0f 85 11 01 00 00    	jne    80105792 <getprocs+0x15f>
        table[index].pid = p -> pid;
80105681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105684:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105687:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568a:	01 c2                	add    %eax,%edx
8010568c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010568f:	8b 40 10             	mov    0x10(%eax),%eax
80105692:	89 02                	mov    %eax,(%edx)
        table[index].uid = p -> uid;
80105694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105697:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010569a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569d:	01 c2                	add    %eax,%edx
8010569f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a2:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801056a8:	89 42 04             	mov    %eax,0x4(%edx)
        table[index].gid = p -> gid;
801056ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ae:	6b d0 5c             	imul   $0x5c,%eax,%edx
801056b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056b4:	01 c2                	add    %eax,%edx
801056b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801056bf:	89 42 08             	mov    %eax,0x8(%edx)
        if(p -> parent == 0)
801056c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c5:	8b 40 14             	mov    0x14(%eax),%eax
801056c8:	85 c0                	test   %eax,%eax
801056ca:	75 16                	jne    801056e2 <getprocs+0xaf>
		      table[index].ppid = p->pid;
801056cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056cf:	6b d0 5c             	imul   $0x5c,%eax,%edx
801056d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d5:	01 c2                	add    %eax,%edx
801056d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056da:	8b 40 10             	mov    0x10(%eax),%eax
801056dd:	89 42 0c             	mov    %eax,0xc(%edx)
801056e0:	eb 17                	jmp    801056f9 <getprocs+0xc6>
	      else 	
        	table[index].ppid = p -> parent -> pid;
801056e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e5:	6b d0 5c             	imul   $0x5c,%eax,%edx
801056e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801056eb:	01 c2                	add    %eax,%edx
801056ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f0:	8b 40 14             	mov    0x14(%eax),%eax
801056f3:	8b 40 10             	mov    0x10(%eax),%eax
801056f6:	89 42 0c             	mov    %eax,0xc(%edx)
        table[index].elapsed_ticks = ticks - p -> start_ticks;
801056f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fc:	6b d0 5c             	imul   $0x5c,%eax,%edx
801056ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105702:	01 c2                	add    %eax,%edx
80105704:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
8010570a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010570d:	8b 40 7c             	mov    0x7c(%eax),%eax
80105710:	29 c1                	sub    %eax,%ecx
80105712:	89 c8                	mov    %ecx,%eax
80105714:	89 42 10             	mov    %eax,0x10(%edx)
        table[index].CPU_total_ticks = p -> cpu_ticks_total;
80105717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010571a:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010571d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105720:	01 c2                	add    %eax,%edx
80105722:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105725:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010572b:	89 42 14             	mov    %eax,0x14(%edx)
        safestrcpy(table[index].state, states[p-> state], STRMAX);      
8010572e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105731:	8b 40 0c             	mov    0xc(%eax),%eax
80105734:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
8010573b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010573e:	6b ca 5c             	imul   $0x5c,%edx,%ecx
80105741:	8b 55 0c             	mov    0xc(%ebp),%edx
80105744:	01 ca                	add    %ecx,%edx
80105746:	83 c2 18             	add    $0x18,%edx
80105749:	83 ec 04             	sub    $0x4,%esp
8010574c:	6a 20                	push   $0x20
8010574e:	50                   	push   %eax
8010574f:	52                   	push   %edx
80105750:	e8 82 09 00 00       	call   801060d7 <safestrcpy>
80105755:	83 c4 10             	add    $0x10,%esp
        table[index].size = p -> sz;
80105758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575b:	6b d0 5c             	imul   $0x5c,%eax,%edx
8010575e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105761:	01 c2                	add    %eax,%edx
80105763:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105766:	8b 00                	mov    (%eax),%eax
80105768:	89 42 38             	mov    %eax,0x38(%edx)
        safestrcpy(table[index].name, p-> name, STRMAX);          
8010576b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576e:	8d 50 6c             	lea    0x6c(%eax),%edx
80105771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105774:	6b c8 5c             	imul   $0x5c,%eax,%ecx
80105777:	8b 45 0c             	mov    0xc(%ebp),%eax
8010577a:	01 c8                	add    %ecx,%eax
8010577c:	83 c0 3c             	add    $0x3c,%eax
8010577f:	83 ec 04             	sub    $0x4,%esp
80105782:	6a 20                	push   $0x20
80105784:	52                   	push   %edx
80105785:	50                   	push   %eax
80105786:	e8 4c 09 00 00       	call   801060d7 <safestrcpy>
8010578b:	83 c4 10             	add    $0x10,%esp
        index++; // after 
8010578e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc* table){
  int index = 0;      // which is my count of processes at the same time
  struct proc *p;
  
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
80105792:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
80105799:	81 7d f0 b4 5e 11 80 	cmpl   $0x80115eb4,-0x10(%ebp)
801057a0:	73 0c                	jae    801057ae <getprocs+0x17b>
801057a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a5:	3b 45 08             	cmp    0x8(%ebp),%eax
801057a8:	0f 82 ae fe ff ff    	jb     8010565c <getprocs+0x29>
        table[index].size = p -> sz;
        safestrcpy(table[index].name, p-> name, STRMAX);          
        index++; // after 
      }
    }
    release(&ptable.lock);
801057ae:	83 ec 0c             	sub    $0xc,%esp
801057b1:	68 80 39 11 80       	push   $0x80113980
801057b6:	e8 1d 05 00 00       	call   80105cd8 <release>
801057bb:	83 c4 10             	add    $0x10,%esp
    return index;    
801057be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057c1:	c9                   	leave  
801057c2:	c3                   	ret    

801057c3 <assertState>:
// Project #3 helper functions 

 #ifdef CS333_P3P4

static void
assertState(struct proc * p, enum procstate state){
801057c3:	55                   	push   %ebp
801057c4:	89 e5                	mov    %esp,%ebp
801057c6:	83 ec 08             	sub    $0x8,%esp
  if( p -> state != state){
801057c9:	8b 45 08             	mov    0x8(%ebp),%eax
801057cc:	8b 40 0c             	mov    0xc(%eax),%eax
801057cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
801057d2:	74 36                	je     8010580a <assertState+0x47>
    cprintf("Different states: current %s and expected %s\n", states[p-> state], states[state]);
801057d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801057d7:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801057de:	8b 45 08             	mov    0x8(%ebp),%eax
801057e1:	8b 40 0c             	mov    0xc(%eax),%eax
801057e4:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801057eb:	83 ec 04             	sub    $0x4,%esp
801057ee:	52                   	push   %edx
801057ef:	50                   	push   %eax
801057f0:	68 b0 97 10 80       	push   $0x801097b0
801057f5:	e8 cc ab ff ff       	call   801003c6 <cprintf>
801057fa:	83 c4 10             	add    $0x10,%esp
    panic("Panic different states");
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	68 de 97 10 80       	push   $0x801097de
80105805:	e8 5c ad ff ff       	call   80100566 <panic>
  }
}
8010580a:	90                   	nop
8010580b:	c9                   	leave  
8010580c:	c3                   	ret    

8010580d <removeFromStateList>:

static int
removeFromStateList(struct proc** sList, struct proc * p){
8010580d:	55                   	push   %ebp
8010580e:	89 e5                	mov    %esp,%ebp
80105810:	83 ec 18             	sub    $0x18,%esp
  struct proc * current; 
  struct proc * previous;
  current = *sList;
80105813:	8b 45 08             	mov    0x8(%ebp),%eax
80105816:	8b 00                	mov    (%eax),%eax
80105818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(current == 0)
8010581b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010581f:	75 0d                	jne    8010582e <removeFromStateList+0x21>
    panic("Nothing in sList");
80105821:	83 ec 0c             	sub    $0xc,%esp
80105824:	68 f5 97 10 80       	push   $0x801097f5
80105829:	e8 38 ad ff ff       	call   80100566 <panic>

  if(current == p){
8010582e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105831:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105834:	75 22                	jne    80105858 <removeFromStateList+0x4b>
    *sList = p -> next;
80105836:	8b 45 0c             	mov    0xc(%ebp),%eax
80105839:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010583f:	8b 45 08             	mov    0x8(%ebp),%eax
80105842:	89 10                	mov    %edx,(%eax)
    p -> next = 0;
80105844:	8b 45 0c             	mov    0xc(%ebp),%eax
80105847:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010584e:	00 00 00 
    return 1;
80105851:	b8 01 00 00 00       	mov    $0x1,%eax
80105856:	eb 69                	jmp    801058c1 <removeFromStateList+0xb4>
  }

  previous = *sList;
80105858:	8b 45 08             	mov    0x8(%ebp),%eax
8010585b:	8b 00                	mov    (%eax),%eax
8010585d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  current = current -> next;
80105860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105863:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105869:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  while(current){
8010586c:	eb 40                	jmp    801058ae <removeFromStateList+0xa1>
    if(current == p){
8010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105871:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105874:	75 26                	jne    8010589c <removeFromStateList+0x8f>
      previous -> next = current -> next;
80105876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105879:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010587f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105882:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      current -> next = 0;
80105888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588b:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105892:	00 00 00 
      return 1 ;
80105895:	b8 01 00 00 00       	mov    $0x1,%eax
8010589a:	eb 25                	jmp    801058c1 <removeFromStateList+0xb4>
    }
    previous = current;
8010589c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010589f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    current = current -> next;
801058a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  previous = *sList;
  current = current -> next;
 
  while(current){
801058ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058b2:	75 ba                	jne    8010586e <removeFromStateList+0x61>
      return 1 ;
    }
    previous = current;
    current = current -> next;
  }
  panic("I'm not in the list -- removeFromStateList call");
801058b4:	83 ec 0c             	sub    $0xc,%esp
801058b7:	68 08 98 10 80       	push   $0x80109808
801058bc:	e8 a5 ac ff ff       	call   80100566 <panic>
  return 0;
}
801058c1:	c9                   	leave  
801058c2:	c3                   	ret    

801058c3 <traverseList>:


static int
traverseList(struct proc **sList){
801058c3:	55                   	push   %ebp
801058c4:	89 e5                	mov    %esp,%ebp
801058c6:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;
    current = *sList;
801058c9:	8b 45 08             	mov    0x8(%ebp),%eax
801058cc:	8b 00                	mov    (%eax),%eax
801058ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    //int count = 0;
    while(current){
801058d1:	eb 23                	jmp    801058f6 <traverseList+0x33>
      if(current -> parent == proc){
801058d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d6:	8b 50 14             	mov    0x14(%eax),%edx
801058d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058df:	39 c2                	cmp    %eax,%edx
801058e1:	75 07                	jne    801058ea <traverseList+0x27>
        return 1;
801058e3:	b8 01 00 00 00       	mov    $0x1,%eax
801058e8:	eb 17                	jmp    80105901 <traverseList+0x3e>
      }
      current = current -> next;
801058ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ed:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
static int
traverseList(struct proc **sList){
    struct proc * current;
    current = *sList;
    //int count = 0;
    while(current){
801058f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801058fa:	75 d7                	jne    801058d3 <traverseList+0x10>
      if(current -> parent == proc){
        return 1;
      }
      current = current -> next;
    }
    return 0;
801058fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105901:	c9                   	leave  
80105902:	c3                   	ret    

80105903 <traverseToKill>:

static int 
traverseToKill(struct proc **sList, int pid){
80105903:	55                   	push   %ebp
80105904:	89 e5                	mov    %esp,%ebp
80105906:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
80105909:	8b 45 08             	mov    0x8(%ebp),%eax
8010590c:	8b 00                	mov    (%eax),%eax
8010590e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);     // *****move the lock before the function call outside
80105911:	83 ec 0c             	sub    $0xc,%esp
80105914:	68 80 39 11 80       	push   $0x80113980
80105919:	e8 53 03 00 00       	call   80105c71 <acquire>
8010591e:	83 c4 10             	add    $0x10,%esp

  while(current){
80105921:	eb 75                	jmp    80105998 <traverseToKill+0x95>
    if(current -> pid == pid){
80105923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105926:	8b 50 10             	mov    0x10(%eax),%edx
80105929:	8b 45 0c             	mov    0xc(%ebp),%eax
8010592c:	39 c2                	cmp    %eax,%edx
8010592e:	75 5c                	jne    8010598c <traverseToKill+0x89>
      current -> killed = 1;
80105930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105933:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(current -> state == SLEEPING){ // assert state sleeping
8010593a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593d:	8b 40 0c             	mov    0xc(%eax),%eax
80105940:	83 f8 02             	cmp    $0x2,%eax
80105943:	75 30                	jne    80105975 <traverseToKill+0x72>
        removeFromStateList(&ptable.pLists.sleep, current);
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	ff 75 f4             	pushl  -0xc(%ebp)
8010594b:	68 bc 5e 11 80       	push   $0x80115ebc
80105950:	e8 b8 fe ff ff       	call   8010580d <removeFromStateList>
80105955:	83 c4 10             	add    $0x10,%esp
        current -> state = RUNNABLE;
80105958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        insertTail(&ptable.pLists.ready, current);
80105962:	83 ec 08             	sub    $0x8,%esp
80105965:	ff 75 f4             	pushl  -0xc(%ebp)
80105968:	68 b4 5e 11 80       	push   $0x80115eb4
8010596d:	e8 71 00 00 00       	call   801059e3 <insertTail>
80105972:	83 c4 10             	add    $0x10,%esp
      }
      release(&ptable.lock);
80105975:	83 ec 0c             	sub    $0xc,%esp
80105978:	68 80 39 11 80       	push   $0x80113980
8010597d:	e8 56 03 00 00       	call   80105cd8 <release>
80105982:	83 c4 10             	add    $0x10,%esp
      return 1;
80105985:	b8 01 00 00 00       	mov    $0x1,%eax
8010598a:	eb 27                	jmp    801059b3 <traverseToKill+0xb0>
    }else{
      current = current -> next;
8010598c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc * current;
  current = *sList;

  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
80105998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010599c:	75 85                	jne    80105923 <traverseToKill+0x20>
      return 1;
    }else{
      current = current -> next;
    }
  }
  release(&ptable.lock);
8010599e:	83 ec 0c             	sub    $0xc,%esp
801059a1:	68 80 39 11 80       	push   $0x80113980
801059a6:	e8 2d 03 00 00       	call   80105cd8 <release>
801059ab:	83 c4 10             	add    $0x10,%esp
  return -1;
801059ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b3:	c9                   	leave  
801059b4:	c3                   	ret    

801059b5 <removeFront>:

static struct proc *
removeFront(struct proc** sList){
801059b5:	55                   	push   %ebp
801059b6:	89 e5                	mov    %esp,%ebp
801059b8:	83 ec 10             	sub    $0x10,%esp
  struct proc * temp;
  temp = *sList;
801059bb:	8b 45 08             	mov    0x8(%ebp),%eax
801059be:	8b 00                	mov    (%eax),%eax
801059c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(temp == 0)
801059c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801059c7:	75 05                	jne    801059ce <removeFront+0x19>
    return temp;
801059c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059cc:	eb 13                	jmp    801059e1 <removeFront+0x2c>

  *sList = (* sList) -> next;
801059ce:	8b 45 08             	mov    0x8(%ebp),%eax
801059d1:	8b 00                	mov    (%eax),%eax
801059d3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801059d9:	8b 45 08             	mov    0x8(%ebp),%eax
801059dc:	89 10                	mov    %edx,(%eax)

  return temp;
801059de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059e1:	c9                   	leave  
801059e2:	c3                   	ret    

801059e3 <insertTail>:

static void
insertTail(struct proc** sList, struct proc * p){
801059e3:	55                   	push   %ebp
801059e4:	89 e5                	mov    %esp,%ebp
801059e6:	83 ec 10             	sub    $0x10,%esp
  if(*sList == 0){
801059e9:	8b 45 08             	mov    0x8(%ebp),%eax
801059ec:	8b 00                	mov    (%eax),%eax
801059ee:	85 c0                	test   %eax,%eax
801059f0:	75 19                	jne    80105a0b <insertTail+0x28>
    *sList = p;
801059f2:	8b 45 08             	mov    0x8(%ebp),%eax
801059f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801059f8:	89 10                	mov    %edx,(%eax)
    (*sList) -> next = 0;
801059fa:	8b 45 08             	mov    0x8(%ebp),%eax
801059fd:	8b 00                	mov    (%eax),%eax
801059ff:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105a06:	00 00 00 
    return;
80105a09:	eb 3d                	jmp    80105a48 <insertTail+0x65>
  }

  struct proc * current;
  current = *sList;
80105a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0e:	8b 00                	mov    (%eax),%eax
80105a10:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(current -> next != 0){
80105a13:	eb 0c                	jmp    80105a21 <insertTail+0x3e>
    current = current -> next;
80105a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a18:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  }

  struct proc * current;
  current = *sList;

  while(current -> next != 0){
80105a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a24:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a2a:	85 c0                	test   %eax,%eax
80105a2c:	75 e7                	jne    80105a15 <insertTail+0x32>
    current = current -> next;
  }
  current -> next = p;
80105a2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a31:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a34:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  p -> next = 0;
80105a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a3d:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105a44:	00 00 00 
  return;
80105a47:	90                   	nop
}
80105a48:	c9                   	leave  
80105a49:	c3                   	ret    

80105a4a <insertAtHead>:

static void
insertAtHead(struct proc** sList, struct proc * p){
80105a4a:	55                   	push   %ebp
80105a4b:	89 e5                	mov    %esp,%ebp
  p->next = *sList;
80105a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a50:	8b 10                	mov    (%eax),%edx
80105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a55:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
80105a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a61:	89 10                	mov    %edx,(%eax)
}
80105a63:	90                   	nop
80105a64:	5d                   	pop    %ebp
80105a65:	c3                   	ret    

80105a66 <printPidReadyList>:

#endif

void
printPidReadyList(void){
80105a66:	55                   	push   %ebp
80105a67:	89 e5                	mov    %esp,%ebp
80105a69:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	68 80 39 11 80       	push   $0x80113980
80105a74:	e8 f8 01 00 00       	call   80105c71 <acquire>
80105a79:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.ready;
80105a7c:	a1 b4 5e 11 80       	mov    0x80115eb4,%eax
80105a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Ready List processes: \n");
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	68 38 98 10 80       	push   $0x80109838
80105a8c:	e8 35 a9 ff ff       	call   801003c6 <cprintf>
80105a91:	83 c4 10             	add    $0x10,%esp
    while(current){
80105a94:	eb 23                	jmp    80105ab9 <printPidReadyList+0x53>
      cprintf("%d ->", current -> pid);
80105a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a99:	8b 40 10             	mov    0x10(%eax),%eax
80105a9c:	83 ec 08             	sub    $0x8,%esp
80105a9f:	50                   	push   %eax
80105aa0:	68 50 98 10 80       	push   $0x80109850
80105aa5:	e8 1c a9 ff ff       	call   801003c6 <cprintf>
80105aaa:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80105aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.ready;
    //int count = 0;
    cprintf("Ready List processes: \n");
    while(current){
80105ab9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105abd:	75 d7                	jne    80105a96 <printPidReadyList+0x30>
      cprintf("%d ->", current -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
80105abf:	83 ec 0c             	sub    $0xc,%esp
80105ac2:	68 80 39 11 80       	push   $0x80113980
80105ac7:	e8 0c 02 00 00       	call   80105cd8 <release>
80105acc:	83 c4 10             	add    $0x10,%esp
}
80105acf:	90                   	nop
80105ad0:	c9                   	leave  
80105ad1:	c3                   	ret    

80105ad2 <countFreeList>:

void
countFreeList(void){
80105ad2:	55                   	push   %ebp
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	68 80 39 11 80       	push   $0x80113980
80105ae0:	e8 8c 01 00 00       	call   80105c71 <acquire>
80105ae5:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.free;
80105ae8:	a1 b8 5e 11 80       	mov    0x80115eb8,%eax
80105aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int count = 0;
80105af0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(current){
80105af7:	eb 10                	jmp    80105b09 <countFreeList+0x37>
      count++;
80105af9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      current = current -> next;
80105afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b00:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
countFreeList(void){
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.free;
    int count = 0;
    while(current){
80105b09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b0d:	75 ea                	jne    80105af9 <countFreeList+0x27>
      count++;
      current = current -> next;
    }
    cprintf("Free List size: %d\n", count);
80105b0f:	83 ec 08             	sub    $0x8,%esp
80105b12:	ff 75 f0             	pushl  -0x10(%ebp)
80105b15:	68 56 98 10 80       	push   $0x80109856
80105b1a:	e8 a7 a8 ff ff       	call   801003c6 <cprintf>
80105b1f:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105b22:	83 ec 0c             	sub    $0xc,%esp
80105b25:	68 80 39 11 80       	push   $0x80113980
80105b2a:	e8 a9 01 00 00       	call   80105cd8 <release>
80105b2f:	83 c4 10             	add    $0x10,%esp
}
80105b32:	90                   	nop
80105b33:	c9                   	leave  
80105b34:	c3                   	ret    

80105b35 <printPidSleepList>:

void
printPidSleepList(void){
80105b35:	55                   	push   %ebp
80105b36:	89 e5                	mov    %esp,%ebp
80105b38:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105b3b:	83 ec 0c             	sub    $0xc,%esp
80105b3e:	68 80 39 11 80       	push   $0x80113980
80105b43:	e8 29 01 00 00       	call   80105c71 <acquire>
80105b48:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.sleep;
80105b4b:	a1 bc 5e 11 80       	mov    0x80115ebc,%eax
80105b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Sleep List processes: \n");
80105b53:	83 ec 0c             	sub    $0xc,%esp
80105b56:	68 6a 98 10 80       	push   $0x8010986a
80105b5b:	e8 66 a8 ff ff       	call   801003c6 <cprintf>
80105b60:	83 c4 10             	add    $0x10,%esp
    while(current){
80105b63:	eb 23                	jmp    80105b88 <printPidSleepList+0x53>
      cprintf("%d ->", current -> pid);
80105b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b68:	8b 40 10             	mov    0x10(%eax),%eax
80105b6b:	83 ec 08             	sub    $0x8,%esp
80105b6e:	50                   	push   %eax
80105b6f:	68 50 98 10 80       	push   $0x80109850
80105b74:	e8 4d a8 ff ff       	call   801003c6 <cprintf>
80105b79:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80105b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.sleep;
    //int count = 0;
    cprintf("Sleep List processes: \n");
    while(current){
80105b88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b8c:	75 d7                	jne    80105b65 <printPidSleepList+0x30>
      cprintf("%d ->", current -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
80105b8e:	83 ec 0c             	sub    $0xc,%esp
80105b91:	68 80 39 11 80       	push   $0x80113980
80105b96:	e8 3d 01 00 00       	call   80105cd8 <release>
80105b9b:	83 c4 10             	add    $0x10,%esp
}
80105b9e:	90                   	nop
80105b9f:	c9                   	leave  
80105ba0:	c3                   	ret    

80105ba1 <printZombieList>:

void
printZombieList(void){
80105ba1:	55                   	push   %ebp
80105ba2:	89 e5                	mov    %esp,%ebp
80105ba4:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105ba7:	83 ec 0c             	sub    $0xc,%esp
80105baa:	68 80 39 11 80       	push   $0x80113980
80105baf:	e8 bd 00 00 00       	call   80105c71 <acquire>
80105bb4:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.zombie;
80105bb7:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80105bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Zombie List processes: \n");
80105bbf:	83 ec 0c             	sub    $0xc,%esp
80105bc2:	68 82 98 10 80       	push   $0x80109882
80105bc7:	e8 fa a7 ff ff       	call   801003c6 <cprintf>
80105bcc:	83 c4 10             	add    $0x10,%esp
    while(current){
80105bcf:	eb 2d                	jmp    80105bfe <printZombieList+0x5d>
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
80105bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd4:	8b 40 14             	mov    0x14(%eax),%eax
80105bd7:	8b 50 10             	mov    0x10(%eax),%edx
80105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bdd:	8b 40 10             	mov    0x10(%eax),%eax
80105be0:	83 ec 04             	sub    $0x4,%esp
80105be3:	52                   	push   %edx
80105be4:	50                   	push   %eax
80105be5:	68 9b 98 10 80       	push   $0x8010989b
80105bea:	e8 d7 a7 ff ff       	call   801003c6 <cprintf>
80105bef:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80105bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.zombie;
    //int count = 0;
    cprintf("Zombie List processes: \n");
    while(current){
80105bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c02:	75 cd                	jne    80105bd1 <printZombieList+0x30>
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
80105c04:	83 ec 0c             	sub    $0xc,%esp
80105c07:	68 80 39 11 80       	push   $0x80113980
80105c0c:	e8 c7 00 00 00       	call   80105cd8 <release>
80105c11:	83 c4 10             	add    $0x10,%esp
}
80105c14:	90                   	nop
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    

80105c17 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105c17:	55                   	push   %ebp
80105c18:	89 e5                	mov    %esp,%ebp
80105c1a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105c1d:	9c                   	pushf  
80105c1e:	58                   	pop    %eax
80105c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    

80105c27 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80105c27:	55                   	push   %ebp
80105c28:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105c2a:	fa                   	cli    
}
80105c2b:	90                   	nop
80105c2c:	5d                   	pop    %ebp
80105c2d:	c3                   	ret    

80105c2e <sti>:

static inline void
sti(void)
{
80105c2e:	55                   	push   %ebp
80105c2f:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105c31:	fb                   	sti    
}
80105c32:	90                   	nop
80105c33:	5d                   	pop    %ebp
80105c34:	c3                   	ret    

80105c35 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80105c35:	55                   	push   %ebp
80105c36:	89 e5                	mov    %esp,%ebp
80105c38:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105c3b:	8b 55 08             	mov    0x8(%ebp),%edx
80105c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c41:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105c44:	f0 87 02             	lock xchg %eax,(%edx)
80105c47:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80105c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105c4d:	c9                   	leave  
80105c4e:	c3                   	ret    

80105c4f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105c4f:	55                   	push   %ebp
80105c50:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105c52:	8b 45 08             	mov    0x8(%ebp),%eax
80105c55:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c58:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105c64:	8b 45 08             	mov    0x8(%ebp),%eax
80105c67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105c6e:	90                   	nop
80105c6f:	5d                   	pop    %ebp
80105c70:	c3                   	ret    

80105c71 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105c71:	55                   	push   %ebp
80105c72:	89 e5                	mov    %esp,%ebp
80105c74:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105c77:	e8 52 01 00 00       	call   80105dce <pushcli>
  if(holding(lk))
80105c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80105c7f:	83 ec 0c             	sub    $0xc,%esp
80105c82:	50                   	push   %eax
80105c83:	e8 1c 01 00 00       	call   80105da4 <holding>
80105c88:	83 c4 10             	add    $0x10,%esp
80105c8b:	85 c0                	test   %eax,%eax
80105c8d:	74 0d                	je     80105c9c <acquire+0x2b>
    panic("acquire");
80105c8f:	83 ec 0c             	sub    $0xc,%esp
80105c92:	68 a6 98 10 80       	push   $0x801098a6
80105c97:	e8 ca a8 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105c9c:	90                   	nop
80105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	6a 01                	push   $0x1
80105ca5:	50                   	push   %eax
80105ca6:	e8 8a ff ff ff       	call   80105c35 <xchg>
80105cab:	83 c4 10             	add    $0x10,%esp
80105cae:	85 c0                	test   %eax,%eax
80105cb0:	75 eb                	jne    80105c9d <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105cb2:	8b 45 08             	mov    0x8(%ebp),%eax
80105cb5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105cbc:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc2:	83 c0 0c             	add    $0xc,%eax
80105cc5:	83 ec 08             	sub    $0x8,%esp
80105cc8:	50                   	push   %eax
80105cc9:	8d 45 08             	lea    0x8(%ebp),%eax
80105ccc:	50                   	push   %eax
80105ccd:	e8 58 00 00 00       	call   80105d2a <getcallerpcs>
80105cd2:	83 c4 10             	add    $0x10,%esp
}
80105cd5:	90                   	nop
80105cd6:	c9                   	leave  
80105cd7:	c3                   	ret    

80105cd8 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105cd8:	55                   	push   %ebp
80105cd9:	89 e5                	mov    %esp,%ebp
80105cdb:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105cde:	83 ec 0c             	sub    $0xc,%esp
80105ce1:	ff 75 08             	pushl  0x8(%ebp)
80105ce4:	e8 bb 00 00 00       	call   80105da4 <holding>
80105ce9:	83 c4 10             	add    $0x10,%esp
80105cec:	85 c0                	test   %eax,%eax
80105cee:	75 0d                	jne    80105cfd <release+0x25>
    panic("release");
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	68 ae 98 10 80       	push   $0x801098ae
80105cf8:	e8 69 a8 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105d00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105d07:	8b 45 08             	mov    0x8(%ebp),%eax
80105d0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105d11:	8b 45 08             	mov    0x8(%ebp),%eax
80105d14:	83 ec 08             	sub    $0x8,%esp
80105d17:	6a 00                	push   $0x0
80105d19:	50                   	push   %eax
80105d1a:	e8 16 ff ff ff       	call   80105c35 <xchg>
80105d1f:	83 c4 10             	add    $0x10,%esp

  popcli();
80105d22:	e8 ec 00 00 00       	call   80105e13 <popcli>
}
80105d27:	90                   	nop
80105d28:	c9                   	leave  
80105d29:	c3                   	ret    

80105d2a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105d2a:	55                   	push   %ebp
80105d2b:	89 e5                	mov    %esp,%ebp
80105d2d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105d30:	8b 45 08             	mov    0x8(%ebp),%eax
80105d33:	83 e8 08             	sub    $0x8,%eax
80105d36:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105d39:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105d40:	eb 38                	jmp    80105d7a <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105d42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105d46:	74 53                	je     80105d9b <getcallerpcs+0x71>
80105d48:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105d4f:	76 4a                	jbe    80105d9b <getcallerpcs+0x71>
80105d51:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105d55:	74 44                	je     80105d9b <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105d5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105d61:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d64:	01 c2                	add    %eax,%edx
80105d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d69:	8b 40 04             	mov    0x4(%eax),%eax
80105d6c:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d71:	8b 00                	mov    (%eax),%eax
80105d73:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105d76:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105d7a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105d7e:	7e c2                	jle    80105d42 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105d80:	eb 19                	jmp    80105d9b <getcallerpcs+0x71>
    pcs[i] = 0;
80105d82:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105d85:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d8f:	01 d0                	add    %edx,%eax
80105d91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105d97:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105d9b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105d9f:	7e e1                	jle    80105d82 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80105da1:	90                   	nop
80105da2:	c9                   	leave  
80105da3:	c3                   	ret    

80105da4 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105da7:	8b 45 08             	mov    0x8(%ebp),%eax
80105daa:	8b 00                	mov    (%eax),%eax
80105dac:	85 c0                	test   %eax,%eax
80105dae:	74 17                	je     80105dc7 <holding+0x23>
80105db0:	8b 45 08             	mov    0x8(%ebp),%eax
80105db3:	8b 50 08             	mov    0x8(%eax),%edx
80105db6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105dbc:	39 c2                	cmp    %eax,%edx
80105dbe:	75 07                	jne    80105dc7 <holding+0x23>
80105dc0:	b8 01 00 00 00       	mov    $0x1,%eax
80105dc5:	eb 05                	jmp    80105dcc <holding+0x28>
80105dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dcc:	5d                   	pop    %ebp
80105dcd:	c3                   	ret    

80105dce <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105dce:	55                   	push   %ebp
80105dcf:	89 e5                	mov    %esp,%ebp
80105dd1:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105dd4:	e8 3e fe ff ff       	call   80105c17 <readeflags>
80105dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105ddc:	e8 46 fe ff ff       	call   80105c27 <cli>
  if(cpu->ncli++ == 0)
80105de1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105de8:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105dee:	8d 48 01             	lea    0x1(%eax),%ecx
80105df1:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105df7:	85 c0                	test   %eax,%eax
80105df9:	75 15                	jne    80105e10 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105dfb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105e04:	81 e2 00 02 00 00    	and    $0x200,%edx
80105e0a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105e10:	90                   	nop
80105e11:	c9                   	leave  
80105e12:	c3                   	ret    

80105e13 <popcli>:

void
popcli(void)
{
80105e13:	55                   	push   %ebp
80105e14:	89 e5                	mov    %esp,%ebp
80105e16:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105e19:	e8 f9 fd ff ff       	call   80105c17 <readeflags>
80105e1e:	25 00 02 00 00       	and    $0x200,%eax
80105e23:	85 c0                	test   %eax,%eax
80105e25:	74 0d                	je     80105e34 <popcli+0x21>
    panic("popcli - interruptible");
80105e27:	83 ec 0c             	sub    $0xc,%esp
80105e2a:	68 b6 98 10 80       	push   $0x801098b6
80105e2f:	e8 32 a7 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105e34:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105e3a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105e40:	83 ea 01             	sub    $0x1,%edx
80105e43:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105e49:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105e4f:	85 c0                	test   %eax,%eax
80105e51:	79 0d                	jns    80105e60 <popcli+0x4d>
    panic("popcli");
80105e53:	83 ec 0c             	sub    $0xc,%esp
80105e56:	68 cd 98 10 80       	push   $0x801098cd
80105e5b:	e8 06 a7 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105e60:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105e66:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105e6c:	85 c0                	test   %eax,%eax
80105e6e:	75 15                	jne    80105e85 <popcli+0x72>
80105e70:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105e76:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105e7c:	85 c0                	test   %eax,%eax
80105e7e:	74 05                	je     80105e85 <popcli+0x72>
    sti();
80105e80:	e8 a9 fd ff ff       	call   80105c2e <sti>
}
80105e85:	90                   	nop
80105e86:	c9                   	leave  
80105e87:	c3                   	ret    

80105e88 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105e88:	55                   	push   %ebp
80105e89:	89 e5                	mov    %esp,%ebp
80105e8b:	57                   	push   %edi
80105e8c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105e90:	8b 55 10             	mov    0x10(%ebp),%edx
80105e93:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e96:	89 cb                	mov    %ecx,%ebx
80105e98:	89 df                	mov    %ebx,%edi
80105e9a:	89 d1                	mov    %edx,%ecx
80105e9c:	fc                   	cld    
80105e9d:	f3 aa                	rep stos %al,%es:(%edi)
80105e9f:	89 ca                	mov    %ecx,%edx
80105ea1:	89 fb                	mov    %edi,%ebx
80105ea3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105ea6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105ea9:	90                   	nop
80105eaa:	5b                   	pop    %ebx
80105eab:	5f                   	pop    %edi
80105eac:	5d                   	pop    %ebp
80105ead:	c3                   	ret    

80105eae <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105eae:	55                   	push   %ebp
80105eaf:	89 e5                	mov    %esp,%ebp
80105eb1:	57                   	push   %edi
80105eb2:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105eb3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105eb6:	8b 55 10             	mov    0x10(%ebp),%edx
80105eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ebc:	89 cb                	mov    %ecx,%ebx
80105ebe:	89 df                	mov    %ebx,%edi
80105ec0:	89 d1                	mov    %edx,%ecx
80105ec2:	fc                   	cld    
80105ec3:	f3 ab                	rep stos %eax,%es:(%edi)
80105ec5:	89 ca                	mov    %ecx,%edx
80105ec7:	89 fb                	mov    %edi,%ebx
80105ec9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105ecc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105ecf:	90                   	nop
80105ed0:	5b                   	pop    %ebx
80105ed1:	5f                   	pop    %edi
80105ed2:	5d                   	pop    %ebp
80105ed3:	c3                   	ret    

80105ed4 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105ed4:	55                   	push   %ebp
80105ed5:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105ed7:	8b 45 08             	mov    0x8(%ebp),%eax
80105eda:	83 e0 03             	and    $0x3,%eax
80105edd:	85 c0                	test   %eax,%eax
80105edf:	75 43                	jne    80105f24 <memset+0x50>
80105ee1:	8b 45 10             	mov    0x10(%ebp),%eax
80105ee4:	83 e0 03             	and    $0x3,%eax
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	75 39                	jne    80105f24 <memset+0x50>
    c &= 0xFF;
80105eeb:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105ef2:	8b 45 10             	mov    0x10(%ebp),%eax
80105ef5:	c1 e8 02             	shr    $0x2,%eax
80105ef8:	89 c1                	mov    %eax,%ecx
80105efa:	8b 45 0c             	mov    0xc(%ebp),%eax
80105efd:	c1 e0 18             	shl    $0x18,%eax
80105f00:	89 c2                	mov    %eax,%edx
80105f02:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f05:	c1 e0 10             	shl    $0x10,%eax
80105f08:	09 c2                	or     %eax,%edx
80105f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f0d:	c1 e0 08             	shl    $0x8,%eax
80105f10:	09 d0                	or     %edx,%eax
80105f12:	0b 45 0c             	or     0xc(%ebp),%eax
80105f15:	51                   	push   %ecx
80105f16:	50                   	push   %eax
80105f17:	ff 75 08             	pushl  0x8(%ebp)
80105f1a:	e8 8f ff ff ff       	call   80105eae <stosl>
80105f1f:	83 c4 0c             	add    $0xc,%esp
80105f22:	eb 12                	jmp    80105f36 <memset+0x62>
  } else
    stosb(dst, c, n);
80105f24:	8b 45 10             	mov    0x10(%ebp),%eax
80105f27:	50                   	push   %eax
80105f28:	ff 75 0c             	pushl  0xc(%ebp)
80105f2b:	ff 75 08             	pushl  0x8(%ebp)
80105f2e:	e8 55 ff ff ff       	call   80105e88 <stosb>
80105f33:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105f36:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105f39:	c9                   	leave  
80105f3a:	c3                   	ret    

80105f3b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105f3b:	55                   	push   %ebp
80105f3c:	89 e5                	mov    %esp,%ebp
80105f3e:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105f41:	8b 45 08             	mov    0x8(%ebp),%eax
80105f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105f47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105f4d:	eb 30                	jmp    80105f7f <memcmp+0x44>
    if(*s1 != *s2)
80105f4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f52:	0f b6 10             	movzbl (%eax),%edx
80105f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f58:	0f b6 00             	movzbl (%eax),%eax
80105f5b:	38 c2                	cmp    %al,%dl
80105f5d:	74 18                	je     80105f77 <memcmp+0x3c>
      return *s1 - *s2;
80105f5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105f62:	0f b6 00             	movzbl (%eax),%eax
80105f65:	0f b6 d0             	movzbl %al,%edx
80105f68:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f6b:	0f b6 00             	movzbl (%eax),%eax
80105f6e:	0f b6 c0             	movzbl %al,%eax
80105f71:	29 c2                	sub    %eax,%edx
80105f73:	89 d0                	mov    %edx,%eax
80105f75:	eb 1a                	jmp    80105f91 <memcmp+0x56>
    s1++, s2++;
80105f77:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105f7b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105f7f:	8b 45 10             	mov    0x10(%ebp),%eax
80105f82:	8d 50 ff             	lea    -0x1(%eax),%edx
80105f85:	89 55 10             	mov    %edx,0x10(%ebp)
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	75 c3                	jne    80105f4f <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f91:	c9                   	leave  
80105f92:	c3                   	ret    

80105f93 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105f93:	55                   	push   %ebp
80105f94:	89 e5                	mov    %esp,%ebp
80105f96:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105f99:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fa8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105fab:	73 54                	jae    80106001 <memmove+0x6e>
80105fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105fb0:	8b 45 10             	mov    0x10(%ebp),%eax
80105fb3:	01 d0                	add    %edx,%eax
80105fb5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105fb8:	76 47                	jbe    80106001 <memmove+0x6e>
    s += n;
80105fba:	8b 45 10             	mov    0x10(%ebp),%eax
80105fbd:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80105fc3:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105fc6:	eb 13                	jmp    80105fdb <memmove+0x48>
      *--d = *--s;
80105fc8:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105fcc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fd3:	0f b6 10             	movzbl (%eax),%edx
80105fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105fd9:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105fdb:	8b 45 10             	mov    0x10(%ebp),%eax
80105fde:	8d 50 ff             	lea    -0x1(%eax),%edx
80105fe1:	89 55 10             	mov    %edx,0x10(%ebp)
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	75 e0                	jne    80105fc8 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105fe8:	eb 24                	jmp    8010600e <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105fea:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105fed:	8d 50 01             	lea    0x1(%eax),%edx
80105ff0:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105ff3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ff6:	8d 4a 01             	lea    0x1(%edx),%ecx
80105ff9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105ffc:	0f b6 12             	movzbl (%edx),%edx
80105fff:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106001:	8b 45 10             	mov    0x10(%ebp),%eax
80106004:	8d 50 ff             	lea    -0x1(%eax),%edx
80106007:	89 55 10             	mov    %edx,0x10(%ebp)
8010600a:	85 c0                	test   %eax,%eax
8010600c:	75 dc                	jne    80105fea <memmove+0x57>
      *d++ = *s++;

  return dst;
8010600e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106011:	c9                   	leave  
80106012:	c3                   	ret    

80106013 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106013:	55                   	push   %ebp
80106014:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106016:	ff 75 10             	pushl  0x10(%ebp)
80106019:	ff 75 0c             	pushl  0xc(%ebp)
8010601c:	ff 75 08             	pushl  0x8(%ebp)
8010601f:	e8 6f ff ff ff       	call   80105f93 <memmove>
80106024:	83 c4 0c             	add    $0xc,%esp
}
80106027:	c9                   	leave  
80106028:	c3                   	ret    

80106029 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106029:	55                   	push   %ebp
8010602a:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010602c:	eb 0c                	jmp    8010603a <strncmp+0x11>
    n--, p++, q++;
8010602e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106032:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106036:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010603a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010603e:	74 1a                	je     8010605a <strncmp+0x31>
80106040:	8b 45 08             	mov    0x8(%ebp),%eax
80106043:	0f b6 00             	movzbl (%eax),%eax
80106046:	84 c0                	test   %al,%al
80106048:	74 10                	je     8010605a <strncmp+0x31>
8010604a:	8b 45 08             	mov    0x8(%ebp),%eax
8010604d:	0f b6 10             	movzbl (%eax),%edx
80106050:	8b 45 0c             	mov    0xc(%ebp),%eax
80106053:	0f b6 00             	movzbl (%eax),%eax
80106056:	38 c2                	cmp    %al,%dl
80106058:	74 d4                	je     8010602e <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010605a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010605e:	75 07                	jne    80106067 <strncmp+0x3e>
    return 0;
80106060:	b8 00 00 00 00       	mov    $0x0,%eax
80106065:	eb 16                	jmp    8010607d <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106067:	8b 45 08             	mov    0x8(%ebp),%eax
8010606a:	0f b6 00             	movzbl (%eax),%eax
8010606d:	0f b6 d0             	movzbl %al,%edx
80106070:	8b 45 0c             	mov    0xc(%ebp),%eax
80106073:	0f b6 00             	movzbl (%eax),%eax
80106076:	0f b6 c0             	movzbl %al,%eax
80106079:	29 c2                	sub    %eax,%edx
8010607b:	89 d0                	mov    %edx,%eax
}
8010607d:	5d                   	pop    %ebp
8010607e:	c3                   	ret    

8010607f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010607f:	55                   	push   %ebp
80106080:	89 e5                	mov    %esp,%ebp
80106082:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106085:	8b 45 08             	mov    0x8(%ebp),%eax
80106088:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010608b:	90                   	nop
8010608c:	8b 45 10             	mov    0x10(%ebp),%eax
8010608f:	8d 50 ff             	lea    -0x1(%eax),%edx
80106092:	89 55 10             	mov    %edx,0x10(%ebp)
80106095:	85 c0                	test   %eax,%eax
80106097:	7e 2c                	jle    801060c5 <strncpy+0x46>
80106099:	8b 45 08             	mov    0x8(%ebp),%eax
8010609c:	8d 50 01             	lea    0x1(%eax),%edx
8010609f:	89 55 08             	mov    %edx,0x8(%ebp)
801060a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801060a5:	8d 4a 01             	lea    0x1(%edx),%ecx
801060a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801060ab:	0f b6 12             	movzbl (%edx),%edx
801060ae:	88 10                	mov    %dl,(%eax)
801060b0:	0f b6 00             	movzbl (%eax),%eax
801060b3:	84 c0                	test   %al,%al
801060b5:	75 d5                	jne    8010608c <strncpy+0xd>
    ;
  while(n-- > 0)
801060b7:	eb 0c                	jmp    801060c5 <strncpy+0x46>
    *s++ = 0;
801060b9:	8b 45 08             	mov    0x8(%ebp),%eax
801060bc:	8d 50 01             	lea    0x1(%eax),%edx
801060bf:	89 55 08             	mov    %edx,0x8(%ebp)
801060c2:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801060c5:	8b 45 10             	mov    0x10(%ebp),%eax
801060c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801060cb:	89 55 10             	mov    %edx,0x10(%ebp)
801060ce:	85 c0                	test   %eax,%eax
801060d0:	7f e7                	jg     801060b9 <strncpy+0x3a>
    *s++ = 0;
  return os;
801060d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801060d5:	c9                   	leave  
801060d6:	c3                   	ret    

801060d7 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801060d7:	55                   	push   %ebp
801060d8:	89 e5                	mov    %esp,%ebp
801060da:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801060dd:	8b 45 08             	mov    0x8(%ebp),%eax
801060e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801060e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801060e7:	7f 05                	jg     801060ee <safestrcpy+0x17>
    return os;
801060e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801060ec:	eb 31                	jmp    8010611f <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801060ee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801060f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801060f6:	7e 1e                	jle    80106116 <safestrcpy+0x3f>
801060f8:	8b 45 08             	mov    0x8(%ebp),%eax
801060fb:	8d 50 01             	lea    0x1(%eax),%edx
801060fe:	89 55 08             	mov    %edx,0x8(%ebp)
80106101:	8b 55 0c             	mov    0xc(%ebp),%edx
80106104:	8d 4a 01             	lea    0x1(%edx),%ecx
80106107:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010610a:	0f b6 12             	movzbl (%edx),%edx
8010610d:	88 10                	mov    %dl,(%eax)
8010610f:	0f b6 00             	movzbl (%eax),%eax
80106112:	84 c0                	test   %al,%al
80106114:	75 d8                	jne    801060ee <safestrcpy+0x17>
    ;
  *s = 0;
80106116:	8b 45 08             	mov    0x8(%ebp),%eax
80106119:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010611c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010611f:	c9                   	leave  
80106120:	c3                   	ret    

80106121 <strlen>:

int
strlen(const char *s)
{
80106121:	55                   	push   %ebp
80106122:	89 e5                	mov    %esp,%ebp
80106124:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106127:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010612e:	eb 04                	jmp    80106134 <strlen+0x13>
80106130:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106134:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106137:	8b 45 08             	mov    0x8(%ebp),%eax
8010613a:	01 d0                	add    %edx,%eax
8010613c:	0f b6 00             	movzbl (%eax),%eax
8010613f:	84 c0                	test   %al,%al
80106141:	75 ed                	jne    80106130 <strlen+0xf>
    ;
  return n;
80106143:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106146:	c9                   	leave  
80106147:	c3                   	ret    

80106148 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106148:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010614c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106150:	55                   	push   %ebp
  pushl %ebx
80106151:	53                   	push   %ebx
  pushl %esi
80106152:	56                   	push   %esi
  pushl %edi
80106153:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106154:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106156:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106158:	5f                   	pop    %edi
  popl %esi
80106159:	5e                   	pop    %esi
  popl %ebx
8010615a:	5b                   	pop    %ebx
  popl %ebp
8010615b:	5d                   	pop    %ebp
  ret
8010615c:	c3                   	ret    

8010615d <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010615d:	55                   	push   %ebp
8010615e:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106160:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106166:	8b 00                	mov    (%eax),%eax
80106168:	3b 45 08             	cmp    0x8(%ebp),%eax
8010616b:	76 12                	jbe    8010617f <fetchint+0x22>
8010616d:	8b 45 08             	mov    0x8(%ebp),%eax
80106170:	8d 50 04             	lea    0x4(%eax),%edx
80106173:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106179:	8b 00                	mov    (%eax),%eax
8010617b:	39 c2                	cmp    %eax,%edx
8010617d:	76 07                	jbe    80106186 <fetchint+0x29>
    return -1;
8010617f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106184:	eb 0f                	jmp    80106195 <fetchint+0x38>
  *ip = *(int*)(addr);
80106186:	8b 45 08             	mov    0x8(%ebp),%eax
80106189:	8b 10                	mov    (%eax),%edx
8010618b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010618e:	89 10                	mov    %edx,(%eax)
  return 0;
80106190:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106195:	5d                   	pop    %ebp
80106196:	c3                   	ret    

80106197 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106197:	55                   	push   %ebp
80106198:	89 e5                	mov    %esp,%ebp
8010619a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010619d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061a3:	8b 00                	mov    (%eax),%eax
801061a5:	3b 45 08             	cmp    0x8(%ebp),%eax
801061a8:	77 07                	ja     801061b1 <fetchstr+0x1a>
    return -1;
801061aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061af:	eb 46                	jmp    801061f7 <fetchstr+0x60>
  *pp = (char*)addr;
801061b1:	8b 55 08             	mov    0x8(%ebp),%edx
801061b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801061b7:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801061b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061bf:	8b 00                	mov    (%eax),%eax
801061c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801061c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801061c7:	8b 00                	mov    (%eax),%eax
801061c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
801061cc:	eb 1c                	jmp    801061ea <fetchstr+0x53>
    if(*s == 0)
801061ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061d1:	0f b6 00             	movzbl (%eax),%eax
801061d4:	84 c0                	test   %al,%al
801061d6:	75 0e                	jne    801061e6 <fetchstr+0x4f>
      return s - *pp;
801061d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801061db:	8b 45 0c             	mov    0xc(%ebp),%eax
801061de:	8b 00                	mov    (%eax),%eax
801061e0:	29 c2                	sub    %eax,%edx
801061e2:	89 d0                	mov    %edx,%eax
801061e4:	eb 11                	jmp    801061f7 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801061e6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801061ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801061ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801061f0:	72 dc                	jb     801061ce <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801061f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061f7:	c9                   	leave  
801061f8:	c3                   	ret    

801061f9 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801061f9:	55                   	push   %ebp
801061fa:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801061fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106202:	8b 40 18             	mov    0x18(%eax),%eax
80106205:	8b 40 44             	mov    0x44(%eax),%eax
80106208:	8b 55 08             	mov    0x8(%ebp),%edx
8010620b:	c1 e2 02             	shl    $0x2,%edx
8010620e:	01 d0                	add    %edx,%eax
80106210:	83 c0 04             	add    $0x4,%eax
80106213:	ff 75 0c             	pushl  0xc(%ebp)
80106216:	50                   	push   %eax
80106217:	e8 41 ff ff ff       	call   8010615d <fetchint>
8010621c:	83 c4 08             	add    $0x8,%esp
}
8010621f:	c9                   	leave  
80106220:	c3                   	ret    

80106221 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106221:	55                   	push   %ebp
80106222:	89 e5                	mov    %esp,%ebp
80106224:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106227:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010622a:	50                   	push   %eax
8010622b:	ff 75 08             	pushl  0x8(%ebp)
8010622e:	e8 c6 ff ff ff       	call   801061f9 <argint>
80106233:	83 c4 08             	add    $0x8,%esp
80106236:	85 c0                	test   %eax,%eax
80106238:	79 07                	jns    80106241 <argptr+0x20>
    return -1;
8010623a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623f:	eb 3b                	jmp    8010627c <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106241:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106247:	8b 00                	mov    (%eax),%eax
80106249:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010624c:	39 d0                	cmp    %edx,%eax
8010624e:	76 16                	jbe    80106266 <argptr+0x45>
80106250:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106253:	89 c2                	mov    %eax,%edx
80106255:	8b 45 10             	mov    0x10(%ebp),%eax
80106258:	01 c2                	add    %eax,%edx
8010625a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106260:	8b 00                	mov    (%eax),%eax
80106262:	39 c2                	cmp    %eax,%edx
80106264:	76 07                	jbe    8010626d <argptr+0x4c>
    return -1;
80106266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626b:	eb 0f                	jmp    8010627c <argptr+0x5b>
  *pp = (char*)i;
8010626d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106270:	89 c2                	mov    %eax,%edx
80106272:	8b 45 0c             	mov    0xc(%ebp),%eax
80106275:	89 10                	mov    %edx,(%eax)
  return 0;
80106277:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010627c:	c9                   	leave  
8010627d:	c3                   	ret    

8010627e <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010627e:	55                   	push   %ebp
8010627f:	89 e5                	mov    %esp,%ebp
80106281:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106284:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106287:	50                   	push   %eax
80106288:	ff 75 08             	pushl  0x8(%ebp)
8010628b:	e8 69 ff ff ff       	call   801061f9 <argint>
80106290:	83 c4 08             	add    $0x8,%esp
80106293:	85 c0                	test   %eax,%eax
80106295:	79 07                	jns    8010629e <argstr+0x20>
    return -1;
80106297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629c:	eb 0f                	jmp    801062ad <argstr+0x2f>
  return fetchstr(addr, pp);
8010629e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062a1:	ff 75 0c             	pushl  0xc(%ebp)
801062a4:	50                   	push   %eax
801062a5:	e8 ed fe ff ff       	call   80106197 <fetchstr>
801062aa:	83 c4 08             	add    $0x8,%esp
}
801062ad:	c9                   	leave  
801062ae:	c3                   	ret    

801062af <syscall>:
"getprocs",
};
#endif 
void
syscall(void)
{
801062af:	55                   	push   %ebp
801062b0:	89 e5                	mov    %esp,%ebp
801062b2:	53                   	push   %ebx
801062b3:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801062b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062bc:	8b 40 18             	mov    0x18(%eax),%eax
801062bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801062c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801062c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062c9:	7e 30                	jle    801062fb <syscall+0x4c>
801062cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ce:	83 f8 1d             	cmp    $0x1d,%eax
801062d1:	77 28                	ja     801062fb <syscall+0x4c>
801062d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d6:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801062dd:	85 c0                	test   %eax,%eax
801062df:	74 1a                	je     801062fb <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801062e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062e7:	8b 58 18             	mov    0x18(%eax),%ebx
801062ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ed:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
801062f4:	ff d0                	call   *%eax
801062f6:	89 43 1c             	mov    %eax,0x1c(%ebx)
801062f9:	eb 34                	jmp    8010632f <syscall+0x80>
    #ifdef PRINT_SYSCALLS
      cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif 
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801062fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106301:	8d 50 6c             	lea    0x6c(%eax),%edx
80106304:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    proc->tf->eax = syscalls[num]();
    #ifdef PRINT_SYSCALLS
      cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif 
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010630a:	8b 40 10             	mov    0x10(%eax),%eax
8010630d:	ff 75 f4             	pushl  -0xc(%ebp)
80106310:	52                   	push   %edx
80106311:	50                   	push   %eax
80106312:	68 d4 98 10 80       	push   $0x801098d4
80106317:	e8 aa a0 ff ff       	call   801003c6 <cprintf>
8010631c:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010631f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106325:	8b 40 18             	mov    0x18(%eax),%eax
80106328:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010632f:	90                   	nop
80106330:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106333:	c9                   	leave  
80106334:	c3                   	ret    

80106335 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106335:	55                   	push   %ebp
80106336:	89 e5                	mov    %esp,%ebp
80106338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010633b:	83 ec 08             	sub    $0x8,%esp
8010633e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106341:	50                   	push   %eax
80106342:	ff 75 08             	pushl  0x8(%ebp)
80106345:	e8 af fe ff ff       	call   801061f9 <argint>
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	85 c0                	test   %eax,%eax
8010634f:	79 07                	jns    80106358 <argfd+0x23>
    return -1;
80106351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106356:	eb 50                	jmp    801063a8 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635b:	85 c0                	test   %eax,%eax
8010635d:	78 21                	js     80106380 <argfd+0x4b>
8010635f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106362:	83 f8 0f             	cmp    $0xf,%eax
80106365:	7f 19                	jg     80106380 <argfd+0x4b>
80106367:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010636d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106370:	83 c2 08             	add    $0x8,%edx
80106373:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106377:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010637a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010637e:	75 07                	jne    80106387 <argfd+0x52>
    return -1;
80106380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106385:	eb 21                	jmp    801063a8 <argfd+0x73>
  if(pfd)
80106387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010638b:	74 08                	je     80106395 <argfd+0x60>
    *pfd = fd;
8010638d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106390:	8b 45 0c             	mov    0xc(%ebp),%eax
80106393:	89 10                	mov    %edx,(%eax)
  if(pf)
80106395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106399:	74 08                	je     801063a3 <argfd+0x6e>
    *pf = f;
8010639b:	8b 45 10             	mov    0x10(%ebp),%eax
8010639e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063a1:	89 10                	mov    %edx,(%eax)
  return 0;
801063a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063a8:	c9                   	leave  
801063a9:	c3                   	ret    

801063aa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801063aa:	55                   	push   %ebp
801063ab:	89 e5                	mov    %esp,%ebp
801063ad:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801063b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801063b7:	eb 30                	jmp    801063e9 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801063b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
801063c2:	83 c2 08             	add    $0x8,%edx
801063c5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801063c9:	85 c0                	test   %eax,%eax
801063cb:	75 18                	jne    801063e5 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801063cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801063d6:	8d 4a 08             	lea    0x8(%edx),%ecx
801063d9:	8b 55 08             	mov    0x8(%ebp),%edx
801063dc:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801063e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063e3:	eb 0f                	jmp    801063f4 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801063e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801063e9:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801063ed:	7e ca                	jle    801063b9 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801063ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063f4:	c9                   	leave  
801063f5:	c3                   	ret    

801063f6 <sys_dup>:

int
sys_dup(void)
{
801063f6:	55                   	push   %ebp
801063f7:	89 e5                	mov    %esp,%ebp
801063f9:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801063fc:	83 ec 04             	sub    $0x4,%esp
801063ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106402:	50                   	push   %eax
80106403:	6a 00                	push   $0x0
80106405:	6a 00                	push   $0x0
80106407:	e8 29 ff ff ff       	call   80106335 <argfd>
8010640c:	83 c4 10             	add    $0x10,%esp
8010640f:	85 c0                	test   %eax,%eax
80106411:	79 07                	jns    8010641a <sys_dup+0x24>
    return -1;
80106413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106418:	eb 31                	jmp    8010644b <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010641a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010641d:	83 ec 0c             	sub    $0xc,%esp
80106420:	50                   	push   %eax
80106421:	e8 84 ff ff ff       	call   801063aa <fdalloc>
80106426:	83 c4 10             	add    $0x10,%esp
80106429:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010642c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106430:	79 07                	jns    80106439 <sys_dup+0x43>
    return -1;
80106432:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106437:	eb 12                	jmp    8010644b <sys_dup+0x55>
  filedup(f);
80106439:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643c:	83 ec 0c             	sub    $0xc,%esp
8010643f:	50                   	push   %eax
80106440:	e8 60 ac ff ff       	call   801010a5 <filedup>
80106445:	83 c4 10             	add    $0x10,%esp
  return fd;
80106448:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010644b:	c9                   	leave  
8010644c:	c3                   	ret    

8010644d <sys_read>:

int
sys_read(void)
{
8010644d:	55                   	push   %ebp
8010644e:	89 e5                	mov    %esp,%ebp
80106450:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106453:	83 ec 04             	sub    $0x4,%esp
80106456:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106459:	50                   	push   %eax
8010645a:	6a 00                	push   $0x0
8010645c:	6a 00                	push   $0x0
8010645e:	e8 d2 fe ff ff       	call   80106335 <argfd>
80106463:	83 c4 10             	add    $0x10,%esp
80106466:	85 c0                	test   %eax,%eax
80106468:	78 2e                	js     80106498 <sys_read+0x4b>
8010646a:	83 ec 08             	sub    $0x8,%esp
8010646d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106470:	50                   	push   %eax
80106471:	6a 02                	push   $0x2
80106473:	e8 81 fd ff ff       	call   801061f9 <argint>
80106478:	83 c4 10             	add    $0x10,%esp
8010647b:	85 c0                	test   %eax,%eax
8010647d:	78 19                	js     80106498 <sys_read+0x4b>
8010647f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106482:	83 ec 04             	sub    $0x4,%esp
80106485:	50                   	push   %eax
80106486:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106489:	50                   	push   %eax
8010648a:	6a 01                	push   $0x1
8010648c:	e8 90 fd ff ff       	call   80106221 <argptr>
80106491:	83 c4 10             	add    $0x10,%esp
80106494:	85 c0                	test   %eax,%eax
80106496:	79 07                	jns    8010649f <sys_read+0x52>
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649d:	eb 17                	jmp    801064b6 <sys_read+0x69>
  return fileread(f, p, n);
8010649f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801064a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801064a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064a8:	83 ec 04             	sub    $0x4,%esp
801064ab:	51                   	push   %ecx
801064ac:	52                   	push   %edx
801064ad:	50                   	push   %eax
801064ae:	e8 82 ad ff ff       	call   80101235 <fileread>
801064b3:	83 c4 10             	add    $0x10,%esp
}
801064b6:	c9                   	leave  
801064b7:	c3                   	ret    

801064b8 <sys_write>:

int
sys_write(void)
{
801064b8:	55                   	push   %ebp
801064b9:	89 e5                	mov    %esp,%ebp
801064bb:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801064be:	83 ec 04             	sub    $0x4,%esp
801064c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064c4:	50                   	push   %eax
801064c5:	6a 00                	push   $0x0
801064c7:	6a 00                	push   $0x0
801064c9:	e8 67 fe ff ff       	call   80106335 <argfd>
801064ce:	83 c4 10             	add    $0x10,%esp
801064d1:	85 c0                	test   %eax,%eax
801064d3:	78 2e                	js     80106503 <sys_write+0x4b>
801064d5:	83 ec 08             	sub    $0x8,%esp
801064d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064db:	50                   	push   %eax
801064dc:	6a 02                	push   $0x2
801064de:	e8 16 fd ff ff       	call   801061f9 <argint>
801064e3:	83 c4 10             	add    $0x10,%esp
801064e6:	85 c0                	test   %eax,%eax
801064e8:	78 19                	js     80106503 <sys_write+0x4b>
801064ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ed:	83 ec 04             	sub    $0x4,%esp
801064f0:	50                   	push   %eax
801064f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064f4:	50                   	push   %eax
801064f5:	6a 01                	push   $0x1
801064f7:	e8 25 fd ff ff       	call   80106221 <argptr>
801064fc:	83 c4 10             	add    $0x10,%esp
801064ff:	85 c0                	test   %eax,%eax
80106501:	79 07                	jns    8010650a <sys_write+0x52>
    return -1;
80106503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106508:	eb 17                	jmp    80106521 <sys_write+0x69>
  return filewrite(f, p, n);
8010650a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010650d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106513:	83 ec 04             	sub    $0x4,%esp
80106516:	51                   	push   %ecx
80106517:	52                   	push   %edx
80106518:	50                   	push   %eax
80106519:	e8 cf ad ff ff       	call   801012ed <filewrite>
8010651e:	83 c4 10             	add    $0x10,%esp
}
80106521:	c9                   	leave  
80106522:	c3                   	ret    

80106523 <sys_close>:

int
sys_close(void)
{
80106523:	55                   	push   %ebp
80106524:	89 e5                	mov    %esp,%ebp
80106526:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106529:	83 ec 04             	sub    $0x4,%esp
8010652c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010652f:	50                   	push   %eax
80106530:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106533:	50                   	push   %eax
80106534:	6a 00                	push   $0x0
80106536:	e8 fa fd ff ff       	call   80106335 <argfd>
8010653b:	83 c4 10             	add    $0x10,%esp
8010653e:	85 c0                	test   %eax,%eax
80106540:	79 07                	jns    80106549 <sys_close+0x26>
    return -1;
80106542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106547:	eb 28                	jmp    80106571 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106549:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010654f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106552:	83 c2 08             	add    $0x8,%edx
80106555:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010655c:	00 
  fileclose(f);
8010655d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	50                   	push   %eax
80106564:	e8 8d ab ff ff       	call   801010f6 <fileclose>
80106569:	83 c4 10             	add    $0x10,%esp
  return 0;
8010656c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106571:	c9                   	leave  
80106572:	c3                   	ret    

80106573 <sys_fstat>:

int
sys_fstat(void)
{
80106573:	55                   	push   %ebp
80106574:	89 e5                	mov    %esp,%ebp
80106576:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106579:	83 ec 04             	sub    $0x4,%esp
8010657c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010657f:	50                   	push   %eax
80106580:	6a 00                	push   $0x0
80106582:	6a 00                	push   $0x0
80106584:	e8 ac fd ff ff       	call   80106335 <argfd>
80106589:	83 c4 10             	add    $0x10,%esp
8010658c:	85 c0                	test   %eax,%eax
8010658e:	78 17                	js     801065a7 <sys_fstat+0x34>
80106590:	83 ec 04             	sub    $0x4,%esp
80106593:	6a 14                	push   $0x14
80106595:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106598:	50                   	push   %eax
80106599:	6a 01                	push   $0x1
8010659b:	e8 81 fc ff ff       	call   80106221 <argptr>
801065a0:	83 c4 10             	add    $0x10,%esp
801065a3:	85 c0                	test   %eax,%eax
801065a5:	79 07                	jns    801065ae <sys_fstat+0x3b>
    return -1;
801065a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ac:	eb 13                	jmp    801065c1 <sys_fstat+0x4e>
  return filestat(f, st);
801065ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
801065b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b4:	83 ec 08             	sub    $0x8,%esp
801065b7:	52                   	push   %edx
801065b8:	50                   	push   %eax
801065b9:	e8 20 ac ff ff       	call   801011de <filestat>
801065be:	83 c4 10             	add    $0x10,%esp
}
801065c1:	c9                   	leave  
801065c2:	c3                   	ret    

801065c3 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801065c3:	55                   	push   %ebp
801065c4:	89 e5                	mov    %esp,%ebp
801065c6:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801065c9:	83 ec 08             	sub    $0x8,%esp
801065cc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801065cf:	50                   	push   %eax
801065d0:	6a 00                	push   $0x0
801065d2:	e8 a7 fc ff ff       	call   8010627e <argstr>
801065d7:	83 c4 10             	add    $0x10,%esp
801065da:	85 c0                	test   %eax,%eax
801065dc:	78 15                	js     801065f3 <sys_link+0x30>
801065de:	83 ec 08             	sub    $0x8,%esp
801065e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801065e4:	50                   	push   %eax
801065e5:	6a 01                	push   $0x1
801065e7:	e8 92 fc ff ff       	call   8010627e <argstr>
801065ec:	83 c4 10             	add    $0x10,%esp
801065ef:	85 c0                	test   %eax,%eax
801065f1:	79 0a                	jns    801065fd <sys_link+0x3a>
    return -1;
801065f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f8:	e9 68 01 00 00       	jmp    80106765 <sys_link+0x1a2>

  begin_op();
801065fd:	e8 f0 cf ff ff       	call   801035f2 <begin_op>
  if((ip = namei(old)) == 0){
80106602:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106605:	83 ec 0c             	sub    $0xc,%esp
80106608:	50                   	push   %eax
80106609:	e8 bf bf ff ff       	call   801025cd <namei>
8010660e:	83 c4 10             	add    $0x10,%esp
80106611:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106618:	75 0f                	jne    80106629 <sys_link+0x66>
    end_op();
8010661a:	e8 5f d0 ff ff       	call   8010367e <end_op>
    return -1;
8010661f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106624:	e9 3c 01 00 00       	jmp    80106765 <sys_link+0x1a2>
  }

  ilock(ip);
80106629:	83 ec 0c             	sub    $0xc,%esp
8010662c:	ff 75 f4             	pushl  -0xc(%ebp)
8010662f:	e8 db b3 ff ff       	call   80101a0f <ilock>
80106634:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010663e:	66 83 f8 01          	cmp    $0x1,%ax
80106642:	75 1d                	jne    80106661 <sys_link+0x9e>
    iunlockput(ip);
80106644:	83 ec 0c             	sub    $0xc,%esp
80106647:	ff 75 f4             	pushl  -0xc(%ebp)
8010664a:	e8 80 b6 ff ff       	call   80101ccf <iunlockput>
8010664f:	83 c4 10             	add    $0x10,%esp
    end_op();
80106652:	e8 27 d0 ff ff       	call   8010367e <end_op>
    return -1;
80106657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010665c:	e9 04 01 00 00       	jmp    80106765 <sys_link+0x1a2>
  }

  ip->nlink++;
80106661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106664:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106668:	83 c0 01             	add    $0x1,%eax
8010666b:	89 c2                	mov    %eax,%edx
8010666d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106670:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106674:	83 ec 0c             	sub    $0xc,%esp
80106677:	ff 75 f4             	pushl  -0xc(%ebp)
8010667a:	e8 b6 b1 ff ff       	call   80101835 <iupdate>
8010667f:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106682:	83 ec 0c             	sub    $0xc,%esp
80106685:	ff 75 f4             	pushl  -0xc(%ebp)
80106688:	e8 e0 b4 ff ff       	call   80101b6d <iunlock>
8010668d:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106690:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106693:	83 ec 08             	sub    $0x8,%esp
80106696:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106699:	52                   	push   %edx
8010669a:	50                   	push   %eax
8010669b:	e8 49 bf ff ff       	call   801025e9 <nameiparent>
801066a0:	83 c4 10             	add    $0x10,%esp
801066a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066aa:	74 71                	je     8010671d <sys_link+0x15a>
    goto bad;
  ilock(dp);
801066ac:	83 ec 0c             	sub    $0xc,%esp
801066af:	ff 75 f0             	pushl  -0x10(%ebp)
801066b2:	e8 58 b3 ff ff       	call   80101a0f <ilock>
801066b7:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801066ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066bd:	8b 10                	mov    (%eax),%edx
801066bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c2:	8b 00                	mov    (%eax),%eax
801066c4:	39 c2                	cmp    %eax,%edx
801066c6:	75 1d                	jne    801066e5 <sys_link+0x122>
801066c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cb:	8b 40 04             	mov    0x4(%eax),%eax
801066ce:	83 ec 04             	sub    $0x4,%esp
801066d1:	50                   	push   %eax
801066d2:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801066d5:	50                   	push   %eax
801066d6:	ff 75 f0             	pushl  -0x10(%ebp)
801066d9:	e8 53 bc ff ff       	call   80102331 <dirlink>
801066de:	83 c4 10             	add    $0x10,%esp
801066e1:	85 c0                	test   %eax,%eax
801066e3:	79 10                	jns    801066f5 <sys_link+0x132>
    iunlockput(dp);
801066e5:	83 ec 0c             	sub    $0xc,%esp
801066e8:	ff 75 f0             	pushl  -0x10(%ebp)
801066eb:	e8 df b5 ff ff       	call   80101ccf <iunlockput>
801066f0:	83 c4 10             	add    $0x10,%esp
    goto bad;
801066f3:	eb 29                	jmp    8010671e <sys_link+0x15b>
  }
  iunlockput(dp);
801066f5:	83 ec 0c             	sub    $0xc,%esp
801066f8:	ff 75 f0             	pushl  -0x10(%ebp)
801066fb:	e8 cf b5 ff ff       	call   80101ccf <iunlockput>
80106700:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106703:	83 ec 0c             	sub    $0xc,%esp
80106706:	ff 75 f4             	pushl  -0xc(%ebp)
80106709:	e8 d1 b4 ff ff       	call   80101bdf <iput>
8010670e:	83 c4 10             	add    $0x10,%esp

  end_op();
80106711:	e8 68 cf ff ff       	call   8010367e <end_op>

  return 0;
80106716:	b8 00 00 00 00       	mov    $0x0,%eax
8010671b:	eb 48                	jmp    80106765 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010671d:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
8010671e:	83 ec 0c             	sub    $0xc,%esp
80106721:	ff 75 f4             	pushl  -0xc(%ebp)
80106724:	e8 e6 b2 ff ff       	call   80101a0f <ilock>
80106729:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010672c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106733:	83 e8 01             	sub    $0x1,%eax
80106736:	89 c2                	mov    %eax,%edx
80106738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010673f:	83 ec 0c             	sub    $0xc,%esp
80106742:	ff 75 f4             	pushl  -0xc(%ebp)
80106745:	e8 eb b0 ff ff       	call   80101835 <iupdate>
8010674a:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010674d:	83 ec 0c             	sub    $0xc,%esp
80106750:	ff 75 f4             	pushl  -0xc(%ebp)
80106753:	e8 77 b5 ff ff       	call   80101ccf <iunlockput>
80106758:	83 c4 10             	add    $0x10,%esp
  end_op();
8010675b:	e8 1e cf ff ff       	call   8010367e <end_op>
  return -1;
80106760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106765:	c9                   	leave  
80106766:	c3                   	ret    

80106767 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106767:	55                   	push   %ebp
80106768:	89 e5                	mov    %esp,%ebp
8010676a:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010676d:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106774:	eb 40                	jmp    801067b6 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106779:	6a 10                	push   $0x10
8010677b:	50                   	push   %eax
8010677c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010677f:	50                   	push   %eax
80106780:	ff 75 08             	pushl  0x8(%ebp)
80106783:	e8 f5 b7 ff ff       	call   80101f7d <readi>
80106788:	83 c4 10             	add    $0x10,%esp
8010678b:	83 f8 10             	cmp    $0x10,%eax
8010678e:	74 0d                	je     8010679d <isdirempty+0x36>
      panic("isdirempty: readi");
80106790:	83 ec 0c             	sub    $0xc,%esp
80106793:	68 f0 98 10 80       	push   $0x801098f0
80106798:	e8 c9 9d ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010679d:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801067a1:	66 85 c0             	test   %ax,%ax
801067a4:	74 07                	je     801067ad <isdirempty+0x46>
      return 0;
801067a6:	b8 00 00 00 00       	mov    $0x0,%eax
801067ab:	eb 1b                	jmp    801067c8 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801067ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b0:	83 c0 10             	add    $0x10,%eax
801067b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067b6:	8b 45 08             	mov    0x8(%ebp),%eax
801067b9:	8b 50 18             	mov    0x18(%eax),%edx
801067bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067bf:	39 c2                	cmp    %eax,%edx
801067c1:	77 b3                	ja     80106776 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801067c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801067c8:	c9                   	leave  
801067c9:	c3                   	ret    

801067ca <sys_unlink>:

int
sys_unlink(void)
{
801067ca:	55                   	push   %ebp
801067cb:	89 e5                	mov    %esp,%ebp
801067cd:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801067d0:	83 ec 08             	sub    $0x8,%esp
801067d3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801067d6:	50                   	push   %eax
801067d7:	6a 00                	push   $0x0
801067d9:	e8 a0 fa ff ff       	call   8010627e <argstr>
801067de:	83 c4 10             	add    $0x10,%esp
801067e1:	85 c0                	test   %eax,%eax
801067e3:	79 0a                	jns    801067ef <sys_unlink+0x25>
    return -1;
801067e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067ea:	e9 bc 01 00 00       	jmp    801069ab <sys_unlink+0x1e1>

  begin_op();
801067ef:	e8 fe cd ff ff       	call   801035f2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801067f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
801067f7:	83 ec 08             	sub    $0x8,%esp
801067fa:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801067fd:	52                   	push   %edx
801067fe:	50                   	push   %eax
801067ff:	e8 e5 bd ff ff       	call   801025e9 <nameiparent>
80106804:	83 c4 10             	add    $0x10,%esp
80106807:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010680a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010680e:	75 0f                	jne    8010681f <sys_unlink+0x55>
    end_op();
80106810:	e8 69 ce ff ff       	call   8010367e <end_op>
    return -1;
80106815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010681a:	e9 8c 01 00 00       	jmp    801069ab <sys_unlink+0x1e1>
  }

  ilock(dp);
8010681f:	83 ec 0c             	sub    $0xc,%esp
80106822:	ff 75 f4             	pushl  -0xc(%ebp)
80106825:	e8 e5 b1 ff ff       	call   80101a0f <ilock>
8010682a:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010682d:	83 ec 08             	sub    $0x8,%esp
80106830:	68 02 99 10 80       	push   $0x80109902
80106835:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106838:	50                   	push   %eax
80106839:	e8 1e ba ff ff       	call   8010225c <namecmp>
8010683e:	83 c4 10             	add    $0x10,%esp
80106841:	85 c0                	test   %eax,%eax
80106843:	0f 84 4a 01 00 00    	je     80106993 <sys_unlink+0x1c9>
80106849:	83 ec 08             	sub    $0x8,%esp
8010684c:	68 04 99 10 80       	push   $0x80109904
80106851:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106854:	50                   	push   %eax
80106855:	e8 02 ba ff ff       	call   8010225c <namecmp>
8010685a:	83 c4 10             	add    $0x10,%esp
8010685d:	85 c0                	test   %eax,%eax
8010685f:	0f 84 2e 01 00 00    	je     80106993 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106865:	83 ec 04             	sub    $0x4,%esp
80106868:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010686b:	50                   	push   %eax
8010686c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010686f:	50                   	push   %eax
80106870:	ff 75 f4             	pushl  -0xc(%ebp)
80106873:	e8 ff b9 ff ff       	call   80102277 <dirlookup>
80106878:	83 c4 10             	add    $0x10,%esp
8010687b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010687e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106882:	0f 84 0a 01 00 00    	je     80106992 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106888:	83 ec 0c             	sub    $0xc,%esp
8010688b:	ff 75 f0             	pushl  -0x10(%ebp)
8010688e:	e8 7c b1 ff ff       	call   80101a0f <ilock>
80106893:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106896:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106899:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010689d:	66 85 c0             	test   %ax,%ax
801068a0:	7f 0d                	jg     801068af <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801068a2:	83 ec 0c             	sub    $0xc,%esp
801068a5:	68 07 99 10 80       	push   $0x80109907
801068aa:	e8 b7 9c ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801068af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068b2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801068b6:	66 83 f8 01          	cmp    $0x1,%ax
801068ba:	75 25                	jne    801068e1 <sys_unlink+0x117>
801068bc:	83 ec 0c             	sub    $0xc,%esp
801068bf:	ff 75 f0             	pushl  -0x10(%ebp)
801068c2:	e8 a0 fe ff ff       	call   80106767 <isdirempty>
801068c7:	83 c4 10             	add    $0x10,%esp
801068ca:	85 c0                	test   %eax,%eax
801068cc:	75 13                	jne    801068e1 <sys_unlink+0x117>
    iunlockput(ip);
801068ce:	83 ec 0c             	sub    $0xc,%esp
801068d1:	ff 75 f0             	pushl  -0x10(%ebp)
801068d4:	e8 f6 b3 ff ff       	call   80101ccf <iunlockput>
801068d9:	83 c4 10             	add    $0x10,%esp
    goto bad;
801068dc:	e9 b2 00 00 00       	jmp    80106993 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801068e1:	83 ec 04             	sub    $0x4,%esp
801068e4:	6a 10                	push   $0x10
801068e6:	6a 00                	push   $0x0
801068e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801068eb:	50                   	push   %eax
801068ec:	e8 e3 f5 ff ff       	call   80105ed4 <memset>
801068f1:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801068f4:	8b 45 c8             	mov    -0x38(%ebp),%eax
801068f7:	6a 10                	push   $0x10
801068f9:	50                   	push   %eax
801068fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
801068fd:	50                   	push   %eax
801068fe:	ff 75 f4             	pushl  -0xc(%ebp)
80106901:	e8 ce b7 ff ff       	call   801020d4 <writei>
80106906:	83 c4 10             	add    $0x10,%esp
80106909:	83 f8 10             	cmp    $0x10,%eax
8010690c:	74 0d                	je     8010691b <sys_unlink+0x151>
    panic("unlink: writei");
8010690e:	83 ec 0c             	sub    $0xc,%esp
80106911:	68 19 99 10 80       	push   $0x80109919
80106916:	e8 4b 9c ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
8010691b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010691e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106922:	66 83 f8 01          	cmp    $0x1,%ax
80106926:	75 21                	jne    80106949 <sys_unlink+0x17f>
    dp->nlink--;
80106928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010692b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010692f:	83 e8 01             	sub    $0x1,%eax
80106932:	89 c2                	mov    %eax,%edx
80106934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106937:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010693b:	83 ec 0c             	sub    $0xc,%esp
8010693e:	ff 75 f4             	pushl  -0xc(%ebp)
80106941:	e8 ef ae ff ff       	call   80101835 <iupdate>
80106946:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106949:	83 ec 0c             	sub    $0xc,%esp
8010694c:	ff 75 f4             	pushl  -0xc(%ebp)
8010694f:	e8 7b b3 ff ff       	call   80101ccf <iunlockput>
80106954:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010695a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010695e:	83 e8 01             	sub    $0x1,%eax
80106961:	89 c2                	mov    %eax,%edx
80106963:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106966:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010696a:	83 ec 0c             	sub    $0xc,%esp
8010696d:	ff 75 f0             	pushl  -0x10(%ebp)
80106970:	e8 c0 ae ff ff       	call   80101835 <iupdate>
80106975:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106978:	83 ec 0c             	sub    $0xc,%esp
8010697b:	ff 75 f0             	pushl  -0x10(%ebp)
8010697e:	e8 4c b3 ff ff       	call   80101ccf <iunlockput>
80106983:	83 c4 10             	add    $0x10,%esp

  end_op();
80106986:	e8 f3 cc ff ff       	call   8010367e <end_op>

  return 0;
8010698b:	b8 00 00 00 00       	mov    $0x0,%eax
80106990:	eb 19                	jmp    801069ab <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106992:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106993:	83 ec 0c             	sub    $0xc,%esp
80106996:	ff 75 f4             	pushl  -0xc(%ebp)
80106999:	e8 31 b3 ff ff       	call   80101ccf <iunlockput>
8010699e:	83 c4 10             	add    $0x10,%esp
  end_op();
801069a1:	e8 d8 cc ff ff       	call   8010367e <end_op>
  return -1;
801069a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069ab:	c9                   	leave  
801069ac:	c3                   	ret    

801069ad <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801069ad:	55                   	push   %ebp
801069ae:	89 e5                	mov    %esp,%ebp
801069b0:	83 ec 38             	sub    $0x38,%esp
801069b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069b6:	8b 55 10             	mov    0x10(%ebp),%edx
801069b9:	8b 45 14             	mov    0x14(%ebp),%eax
801069bc:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801069c0:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801069c4:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801069c8:	83 ec 08             	sub    $0x8,%esp
801069cb:	8d 45 de             	lea    -0x22(%ebp),%eax
801069ce:	50                   	push   %eax
801069cf:	ff 75 08             	pushl  0x8(%ebp)
801069d2:	e8 12 bc ff ff       	call   801025e9 <nameiparent>
801069d7:	83 c4 10             	add    $0x10,%esp
801069da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069e1:	75 0a                	jne    801069ed <create+0x40>
    return 0;
801069e3:	b8 00 00 00 00       	mov    $0x0,%eax
801069e8:	e9 90 01 00 00       	jmp    80106b7d <create+0x1d0>
  ilock(dp);
801069ed:	83 ec 0c             	sub    $0xc,%esp
801069f0:	ff 75 f4             	pushl  -0xc(%ebp)
801069f3:	e8 17 b0 ff ff       	call   80101a0f <ilock>
801069f8:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801069fb:	83 ec 04             	sub    $0x4,%esp
801069fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a01:	50                   	push   %eax
80106a02:	8d 45 de             	lea    -0x22(%ebp),%eax
80106a05:	50                   	push   %eax
80106a06:	ff 75 f4             	pushl  -0xc(%ebp)
80106a09:	e8 69 b8 ff ff       	call   80102277 <dirlookup>
80106a0e:	83 c4 10             	add    $0x10,%esp
80106a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a18:	74 50                	je     80106a6a <create+0xbd>
    iunlockput(dp);
80106a1a:	83 ec 0c             	sub    $0xc,%esp
80106a1d:	ff 75 f4             	pushl  -0xc(%ebp)
80106a20:	e8 aa b2 ff ff       	call   80101ccf <iunlockput>
80106a25:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106a28:	83 ec 0c             	sub    $0xc,%esp
80106a2b:	ff 75 f0             	pushl  -0x10(%ebp)
80106a2e:	e8 dc af ff ff       	call   80101a0f <ilock>
80106a33:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106a36:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106a3b:	75 15                	jne    80106a52 <create+0xa5>
80106a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a40:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106a44:	66 83 f8 02          	cmp    $0x2,%ax
80106a48:	75 08                	jne    80106a52 <create+0xa5>
      return ip;
80106a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a4d:	e9 2b 01 00 00       	jmp    80106b7d <create+0x1d0>
    iunlockput(ip);
80106a52:	83 ec 0c             	sub    $0xc,%esp
80106a55:	ff 75 f0             	pushl  -0x10(%ebp)
80106a58:	e8 72 b2 ff ff       	call   80101ccf <iunlockput>
80106a5d:	83 c4 10             	add    $0x10,%esp
    return 0;
80106a60:	b8 00 00 00 00       	mov    $0x0,%eax
80106a65:	e9 13 01 00 00       	jmp    80106b7d <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106a6a:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a71:	8b 00                	mov    (%eax),%eax
80106a73:	83 ec 08             	sub    $0x8,%esp
80106a76:	52                   	push   %edx
80106a77:	50                   	push   %eax
80106a78:	e8 e1 ac ff ff       	call   8010175e <ialloc>
80106a7d:	83 c4 10             	add    $0x10,%esp
80106a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106a83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106a87:	75 0d                	jne    80106a96 <create+0xe9>
    panic("create: ialloc");
80106a89:	83 ec 0c             	sub    $0xc,%esp
80106a8c:	68 28 99 10 80       	push   $0x80109928
80106a91:	e8 d0 9a ff ff       	call   80100566 <panic>

  ilock(ip);
80106a96:	83 ec 0c             	sub    $0xc,%esp
80106a99:	ff 75 f0             	pushl  -0x10(%ebp)
80106a9c:	e8 6e af ff ff       	call   80101a0f <ilock>
80106aa1:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106aa7:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106aab:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ab2:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106ab6:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106abd:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106ac3:	83 ec 0c             	sub    $0xc,%esp
80106ac6:	ff 75 f0             	pushl  -0x10(%ebp)
80106ac9:	e8 67 ad ff ff       	call   80101835 <iupdate>
80106ace:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106ad1:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106ad6:	75 6a                	jne    80106b42 <create+0x195>
    dp->nlink++;  // for ".."
80106ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106adb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106adf:	83 c0 01             	add    $0x1,%eax
80106ae2:	89 c2                	mov    %eax,%edx
80106ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ae7:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106aeb:	83 ec 0c             	sub    $0xc,%esp
80106aee:	ff 75 f4             	pushl  -0xc(%ebp)
80106af1:	e8 3f ad ff ff       	call   80101835 <iupdate>
80106af6:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106afc:	8b 40 04             	mov    0x4(%eax),%eax
80106aff:	83 ec 04             	sub    $0x4,%esp
80106b02:	50                   	push   %eax
80106b03:	68 02 99 10 80       	push   $0x80109902
80106b08:	ff 75 f0             	pushl  -0x10(%ebp)
80106b0b:	e8 21 b8 ff ff       	call   80102331 <dirlink>
80106b10:	83 c4 10             	add    $0x10,%esp
80106b13:	85 c0                	test   %eax,%eax
80106b15:	78 1e                	js     80106b35 <create+0x188>
80106b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b1a:	8b 40 04             	mov    0x4(%eax),%eax
80106b1d:	83 ec 04             	sub    $0x4,%esp
80106b20:	50                   	push   %eax
80106b21:	68 04 99 10 80       	push   $0x80109904
80106b26:	ff 75 f0             	pushl  -0x10(%ebp)
80106b29:	e8 03 b8 ff ff       	call   80102331 <dirlink>
80106b2e:	83 c4 10             	add    $0x10,%esp
80106b31:	85 c0                	test   %eax,%eax
80106b33:	79 0d                	jns    80106b42 <create+0x195>
      panic("create dots");
80106b35:	83 ec 0c             	sub    $0xc,%esp
80106b38:	68 37 99 10 80       	push   $0x80109937
80106b3d:	e8 24 9a ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b45:	8b 40 04             	mov    0x4(%eax),%eax
80106b48:	83 ec 04             	sub    $0x4,%esp
80106b4b:	50                   	push   %eax
80106b4c:	8d 45 de             	lea    -0x22(%ebp),%eax
80106b4f:	50                   	push   %eax
80106b50:	ff 75 f4             	pushl  -0xc(%ebp)
80106b53:	e8 d9 b7 ff ff       	call   80102331 <dirlink>
80106b58:	83 c4 10             	add    $0x10,%esp
80106b5b:	85 c0                	test   %eax,%eax
80106b5d:	79 0d                	jns    80106b6c <create+0x1bf>
    panic("create: dirlink");
80106b5f:	83 ec 0c             	sub    $0xc,%esp
80106b62:	68 43 99 10 80       	push   $0x80109943
80106b67:	e8 fa 99 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106b6c:	83 ec 0c             	sub    $0xc,%esp
80106b6f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b72:	e8 58 b1 ff ff       	call   80101ccf <iunlockput>
80106b77:	83 c4 10             	add    $0x10,%esp

  return ip;
80106b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106b7d:	c9                   	leave  
80106b7e:	c3                   	ret    

80106b7f <sys_open>:

int
sys_open(void)
{
80106b7f:	55                   	push   %ebp
80106b80:	89 e5                	mov    %esp,%ebp
80106b82:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106b85:	83 ec 08             	sub    $0x8,%esp
80106b88:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b8b:	50                   	push   %eax
80106b8c:	6a 00                	push   $0x0
80106b8e:	e8 eb f6 ff ff       	call   8010627e <argstr>
80106b93:	83 c4 10             	add    $0x10,%esp
80106b96:	85 c0                	test   %eax,%eax
80106b98:	78 15                	js     80106baf <sys_open+0x30>
80106b9a:	83 ec 08             	sub    $0x8,%esp
80106b9d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ba0:	50                   	push   %eax
80106ba1:	6a 01                	push   $0x1
80106ba3:	e8 51 f6 ff ff       	call   801061f9 <argint>
80106ba8:	83 c4 10             	add    $0x10,%esp
80106bab:	85 c0                	test   %eax,%eax
80106bad:	79 0a                	jns    80106bb9 <sys_open+0x3a>
    return -1;
80106baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb4:	e9 61 01 00 00       	jmp    80106d1a <sys_open+0x19b>

  begin_op();
80106bb9:	e8 34 ca ff ff       	call   801035f2 <begin_op>

  if(omode & O_CREATE){
80106bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc1:	25 00 02 00 00       	and    $0x200,%eax
80106bc6:	85 c0                	test   %eax,%eax
80106bc8:	74 2a                	je     80106bf4 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106bca:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bcd:	6a 00                	push   $0x0
80106bcf:	6a 00                	push   $0x0
80106bd1:	6a 02                	push   $0x2
80106bd3:	50                   	push   %eax
80106bd4:	e8 d4 fd ff ff       	call   801069ad <create>
80106bd9:	83 c4 10             	add    $0x10,%esp
80106bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106be3:	75 75                	jne    80106c5a <sys_open+0xdb>
      end_op();
80106be5:	e8 94 ca ff ff       	call   8010367e <end_op>
      return -1;
80106bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bef:	e9 26 01 00 00       	jmp    80106d1a <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106bf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bf7:	83 ec 0c             	sub    $0xc,%esp
80106bfa:	50                   	push   %eax
80106bfb:	e8 cd b9 ff ff       	call   801025cd <namei>
80106c00:	83 c4 10             	add    $0x10,%esp
80106c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c0a:	75 0f                	jne    80106c1b <sys_open+0x9c>
      end_op();
80106c0c:	e8 6d ca ff ff       	call   8010367e <end_op>
      return -1;
80106c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c16:	e9 ff 00 00 00       	jmp    80106d1a <sys_open+0x19b>
    }
    ilock(ip);
80106c1b:	83 ec 0c             	sub    $0xc,%esp
80106c1e:	ff 75 f4             	pushl  -0xc(%ebp)
80106c21:	e8 e9 ad ff ff       	call   80101a0f <ilock>
80106c26:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c2c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106c30:	66 83 f8 01          	cmp    $0x1,%ax
80106c34:	75 24                	jne    80106c5a <sys_open+0xdb>
80106c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	74 1d                	je     80106c5a <sys_open+0xdb>
      iunlockput(ip);
80106c3d:	83 ec 0c             	sub    $0xc,%esp
80106c40:	ff 75 f4             	pushl  -0xc(%ebp)
80106c43:	e8 87 b0 ff ff       	call   80101ccf <iunlockput>
80106c48:	83 c4 10             	add    $0x10,%esp
      end_op();
80106c4b:	e8 2e ca ff ff       	call   8010367e <end_op>
      return -1;
80106c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c55:	e9 c0 00 00 00       	jmp    80106d1a <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106c5a:	e8 d9 a3 ff ff       	call   80101038 <filealloc>
80106c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106c62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c66:	74 17                	je     80106c7f <sys_open+0x100>
80106c68:	83 ec 0c             	sub    $0xc,%esp
80106c6b:	ff 75 f0             	pushl  -0x10(%ebp)
80106c6e:	e8 37 f7 ff ff       	call   801063aa <fdalloc>
80106c73:	83 c4 10             	add    $0x10,%esp
80106c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106c79:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106c7d:	79 2e                	jns    80106cad <sys_open+0x12e>
    if(f)
80106c7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106c83:	74 0e                	je     80106c93 <sys_open+0x114>
      fileclose(f);
80106c85:	83 ec 0c             	sub    $0xc,%esp
80106c88:	ff 75 f0             	pushl  -0x10(%ebp)
80106c8b:	e8 66 a4 ff ff       	call   801010f6 <fileclose>
80106c90:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106c93:	83 ec 0c             	sub    $0xc,%esp
80106c96:	ff 75 f4             	pushl  -0xc(%ebp)
80106c99:	e8 31 b0 ff ff       	call   80101ccf <iunlockput>
80106c9e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106ca1:	e8 d8 c9 ff ff       	call   8010367e <end_op>
    return -1;
80106ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cab:	eb 6d                	jmp    80106d1a <sys_open+0x19b>
  }
  iunlock(ip);
80106cad:	83 ec 0c             	sub    $0xc,%esp
80106cb0:	ff 75 f4             	pushl  -0xc(%ebp)
80106cb3:	e8 b5 ae ff ff       	call   80101b6d <iunlock>
80106cb8:	83 c4 10             	add    $0x10,%esp
  end_op();
80106cbb:	e8 be c9 ff ff       	call   8010367e <end_op>

  f->type = FD_INODE;
80106cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cc3:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ccf:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cd5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106cdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cdf:	83 e0 01             	and    $0x1,%eax
80106ce2:	85 c0                	test   %eax,%eax
80106ce4:	0f 94 c0             	sete   %al
80106ce7:	89 c2                	mov    %eax,%edx
80106ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cec:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cf2:	83 e0 01             	and    $0x1,%eax
80106cf5:	85 c0                	test   %eax,%eax
80106cf7:	75 0a                	jne    80106d03 <sys_open+0x184>
80106cf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cfc:	83 e0 02             	and    $0x2,%eax
80106cff:	85 c0                	test   %eax,%eax
80106d01:	74 07                	je     80106d0a <sys_open+0x18b>
80106d03:	b8 01 00 00 00       	mov    $0x1,%eax
80106d08:	eb 05                	jmp    80106d0f <sys_open+0x190>
80106d0a:	b8 00 00 00 00       	mov    $0x0,%eax
80106d0f:	89 c2                	mov    %eax,%edx
80106d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d14:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106d1a:	c9                   	leave  
80106d1b:	c3                   	ret    

80106d1c <sys_mkdir>:

int
sys_mkdir(void)
{
80106d1c:	55                   	push   %ebp
80106d1d:	89 e5                	mov    %esp,%ebp
80106d1f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106d22:	e8 cb c8 ff ff       	call   801035f2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106d27:	83 ec 08             	sub    $0x8,%esp
80106d2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d2d:	50                   	push   %eax
80106d2e:	6a 00                	push   $0x0
80106d30:	e8 49 f5 ff ff       	call   8010627e <argstr>
80106d35:	83 c4 10             	add    $0x10,%esp
80106d38:	85 c0                	test   %eax,%eax
80106d3a:	78 1b                	js     80106d57 <sys_mkdir+0x3b>
80106d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d3f:	6a 00                	push   $0x0
80106d41:	6a 00                	push   $0x0
80106d43:	6a 01                	push   $0x1
80106d45:	50                   	push   %eax
80106d46:	e8 62 fc ff ff       	call   801069ad <create>
80106d4b:	83 c4 10             	add    $0x10,%esp
80106d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106d55:	75 0c                	jne    80106d63 <sys_mkdir+0x47>
    end_op();
80106d57:	e8 22 c9 ff ff       	call   8010367e <end_op>
    return -1;
80106d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d61:	eb 18                	jmp    80106d7b <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106d63:	83 ec 0c             	sub    $0xc,%esp
80106d66:	ff 75 f4             	pushl  -0xc(%ebp)
80106d69:	e8 61 af ff ff       	call   80101ccf <iunlockput>
80106d6e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106d71:	e8 08 c9 ff ff       	call   8010367e <end_op>
  return 0;
80106d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d7b:	c9                   	leave  
80106d7c:	c3                   	ret    

80106d7d <sys_mknod>:

int
sys_mknod(void)
{
80106d7d:	55                   	push   %ebp
80106d7e:	89 e5                	mov    %esp,%ebp
80106d80:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106d83:	e8 6a c8 ff ff       	call   801035f2 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106d88:	83 ec 08             	sub    $0x8,%esp
80106d8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106d8e:	50                   	push   %eax
80106d8f:	6a 00                	push   $0x0
80106d91:	e8 e8 f4 ff ff       	call   8010627e <argstr>
80106d96:	83 c4 10             	add    $0x10,%esp
80106d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106da0:	78 4f                	js     80106df1 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106da2:	83 ec 08             	sub    $0x8,%esp
80106da5:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106da8:	50                   	push   %eax
80106da9:	6a 01                	push   $0x1
80106dab:	e8 49 f4 ff ff       	call   801061f9 <argint>
80106db0:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80106db3:	85 c0                	test   %eax,%eax
80106db5:	78 3a                	js     80106df1 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106db7:	83 ec 08             	sub    $0x8,%esp
80106dba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106dbd:	50                   	push   %eax
80106dbe:	6a 02                	push   $0x2
80106dc0:	e8 34 f4 ff ff       	call   801061f9 <argint>
80106dc5:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106dc8:	85 c0                	test   %eax,%eax
80106dca:	78 25                	js     80106df1 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106dcc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dcf:	0f bf c8             	movswl %ax,%ecx
80106dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106dd5:	0f bf d0             	movswl %ax,%edx
80106dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106ddb:	51                   	push   %ecx
80106ddc:	52                   	push   %edx
80106ddd:	6a 03                	push   $0x3
80106ddf:	50                   	push   %eax
80106de0:	e8 c8 fb ff ff       	call   801069ad <create>
80106de5:	83 c4 10             	add    $0x10,%esp
80106de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106deb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106def:	75 0c                	jne    80106dfd <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106df1:	e8 88 c8 ff ff       	call   8010367e <end_op>
    return -1;
80106df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dfb:	eb 18                	jmp    80106e15 <sys_mknod+0x98>
  }
  iunlockput(ip);
80106dfd:	83 ec 0c             	sub    $0xc,%esp
80106e00:	ff 75 f0             	pushl  -0x10(%ebp)
80106e03:	e8 c7 ae ff ff       	call   80101ccf <iunlockput>
80106e08:	83 c4 10             	add    $0x10,%esp
  end_op();
80106e0b:	e8 6e c8 ff ff       	call   8010367e <end_op>
  return 0;
80106e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e15:	c9                   	leave  
80106e16:	c3                   	ret    

80106e17 <sys_chdir>:

int
sys_chdir(void)
{
80106e17:	55                   	push   %ebp
80106e18:	89 e5                	mov    %esp,%ebp
80106e1a:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106e1d:	e8 d0 c7 ff ff       	call   801035f2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106e22:	83 ec 08             	sub    $0x8,%esp
80106e25:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e28:	50                   	push   %eax
80106e29:	6a 00                	push   $0x0
80106e2b:	e8 4e f4 ff ff       	call   8010627e <argstr>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	85 c0                	test   %eax,%eax
80106e35:	78 18                	js     80106e4f <sys_chdir+0x38>
80106e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e3a:	83 ec 0c             	sub    $0xc,%esp
80106e3d:	50                   	push   %eax
80106e3e:	e8 8a b7 ff ff       	call   801025cd <namei>
80106e43:	83 c4 10             	add    $0x10,%esp
80106e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e4d:	75 0c                	jne    80106e5b <sys_chdir+0x44>
    end_op();
80106e4f:	e8 2a c8 ff ff       	call   8010367e <end_op>
    return -1;
80106e54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e59:	eb 6e                	jmp    80106ec9 <sys_chdir+0xb2>
  }
  ilock(ip);
80106e5b:	83 ec 0c             	sub    $0xc,%esp
80106e5e:	ff 75 f4             	pushl  -0xc(%ebp)
80106e61:	e8 a9 ab ff ff       	call   80101a0f <ilock>
80106e66:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106e70:	66 83 f8 01          	cmp    $0x1,%ax
80106e74:	74 1a                	je     80106e90 <sys_chdir+0x79>
    iunlockput(ip);
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	ff 75 f4             	pushl  -0xc(%ebp)
80106e7c:	e8 4e ae ff ff       	call   80101ccf <iunlockput>
80106e81:	83 c4 10             	add    $0x10,%esp
    end_op();
80106e84:	e8 f5 c7 ff ff       	call   8010367e <end_op>
    return -1;
80106e89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e8e:	eb 39                	jmp    80106ec9 <sys_chdir+0xb2>
  }
  iunlock(ip);
80106e90:	83 ec 0c             	sub    $0xc,%esp
80106e93:	ff 75 f4             	pushl  -0xc(%ebp)
80106e96:	e8 d2 ac ff ff       	call   80101b6d <iunlock>
80106e9b:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80106e9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea4:	8b 40 68             	mov    0x68(%eax),%eax
80106ea7:	83 ec 0c             	sub    $0xc,%esp
80106eaa:	50                   	push   %eax
80106eab:	e8 2f ad ff ff       	call   80101bdf <iput>
80106eb0:	83 c4 10             	add    $0x10,%esp
  end_op();
80106eb3:	e8 c6 c7 ff ff       	call   8010367e <end_op>
  proc->cwd = ip;
80106eb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ec1:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ec9:	c9                   	leave  
80106eca:	c3                   	ret    

80106ecb <sys_exec>:

int
sys_exec(void)
{
80106ecb:	55                   	push   %ebp
80106ecc:	89 e5                	mov    %esp,%ebp
80106ece:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106ed4:	83 ec 08             	sub    $0x8,%esp
80106ed7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106eda:	50                   	push   %eax
80106edb:	6a 00                	push   $0x0
80106edd:	e8 9c f3 ff ff       	call   8010627e <argstr>
80106ee2:	83 c4 10             	add    $0x10,%esp
80106ee5:	85 c0                	test   %eax,%eax
80106ee7:	78 18                	js     80106f01 <sys_exec+0x36>
80106ee9:	83 ec 08             	sub    $0x8,%esp
80106eec:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106ef2:	50                   	push   %eax
80106ef3:	6a 01                	push   $0x1
80106ef5:	e8 ff f2 ff ff       	call   801061f9 <argint>
80106efa:	83 c4 10             	add    $0x10,%esp
80106efd:	85 c0                	test   %eax,%eax
80106eff:	79 0a                	jns    80106f0b <sys_exec+0x40>
    return -1;
80106f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f06:	e9 c6 00 00 00       	jmp    80106fd1 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106f0b:	83 ec 04             	sub    $0x4,%esp
80106f0e:	68 80 00 00 00       	push   $0x80
80106f13:	6a 00                	push   $0x0
80106f15:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106f1b:	50                   	push   %eax
80106f1c:	e8 b3 ef ff ff       	call   80105ed4 <memset>
80106f21:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106f24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f2e:	83 f8 1f             	cmp    $0x1f,%eax
80106f31:	76 0a                	jbe    80106f3d <sys_exec+0x72>
      return -1;
80106f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f38:	e9 94 00 00 00       	jmp    80106fd1 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f40:	c1 e0 02             	shl    $0x2,%eax
80106f43:	89 c2                	mov    %eax,%edx
80106f45:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106f4b:	01 c2                	add    %eax,%edx
80106f4d:	83 ec 08             	sub    $0x8,%esp
80106f50:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106f56:	50                   	push   %eax
80106f57:	52                   	push   %edx
80106f58:	e8 00 f2 ff ff       	call   8010615d <fetchint>
80106f5d:	83 c4 10             	add    $0x10,%esp
80106f60:	85 c0                	test   %eax,%eax
80106f62:	79 07                	jns    80106f6b <sys_exec+0xa0>
      return -1;
80106f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f69:	eb 66                	jmp    80106fd1 <sys_exec+0x106>
    if(uarg == 0){
80106f6b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106f71:	85 c0                	test   %eax,%eax
80106f73:	75 27                	jne    80106f9c <sys_exec+0xd1>
      argv[i] = 0;
80106f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f78:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106f7f:	00 00 00 00 
      break;
80106f83:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f87:	83 ec 08             	sub    $0x8,%esp
80106f8a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106f90:	52                   	push   %edx
80106f91:	50                   	push   %eax
80106f92:	e8 7f 9c ff ff       	call   80100c16 <exec>
80106f97:	83 c4 10             	add    $0x10,%esp
80106f9a:	eb 35                	jmp    80106fd1 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106f9c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106fa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106fa5:	c1 e2 02             	shl    $0x2,%edx
80106fa8:	01 c2                	add    %eax,%edx
80106faa:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106fb0:	83 ec 08             	sub    $0x8,%esp
80106fb3:	52                   	push   %edx
80106fb4:	50                   	push   %eax
80106fb5:	e8 dd f1 ff ff       	call   80106197 <fetchstr>
80106fba:	83 c4 10             	add    $0x10,%esp
80106fbd:	85 c0                	test   %eax,%eax
80106fbf:	79 07                	jns    80106fc8 <sys_exec+0xfd>
      return -1;
80106fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fc6:	eb 09                	jmp    80106fd1 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106fc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106fcc:	e9 5a ff ff ff       	jmp    80106f2b <sys_exec+0x60>
  return exec(path, argv);
}
80106fd1:	c9                   	leave  
80106fd2:	c3                   	ret    

80106fd3 <sys_pipe>:

int
sys_pipe(void)
{
80106fd3:	55                   	push   %ebp
80106fd4:	89 e5                	mov    %esp,%ebp
80106fd6:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106fd9:	83 ec 04             	sub    $0x4,%esp
80106fdc:	6a 08                	push   $0x8
80106fde:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106fe1:	50                   	push   %eax
80106fe2:	6a 00                	push   $0x0
80106fe4:	e8 38 f2 ff ff       	call   80106221 <argptr>
80106fe9:	83 c4 10             	add    $0x10,%esp
80106fec:	85 c0                	test   %eax,%eax
80106fee:	79 0a                	jns    80106ffa <sys_pipe+0x27>
    return -1;
80106ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff5:	e9 af 00 00 00       	jmp    801070a9 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106ffa:	83 ec 08             	sub    $0x8,%esp
80106ffd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107000:	50                   	push   %eax
80107001:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107004:	50                   	push   %eax
80107005:	e8 dc d0 ff ff       	call   801040e6 <pipealloc>
8010700a:	83 c4 10             	add    $0x10,%esp
8010700d:	85 c0                	test   %eax,%eax
8010700f:	79 0a                	jns    8010701b <sys_pipe+0x48>
    return -1;
80107011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107016:	e9 8e 00 00 00       	jmp    801070a9 <sys_pipe+0xd6>
  fd0 = -1;
8010701b:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107022:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107025:	83 ec 0c             	sub    $0xc,%esp
80107028:	50                   	push   %eax
80107029:	e8 7c f3 ff ff       	call   801063aa <fdalloc>
8010702e:	83 c4 10             	add    $0x10,%esp
80107031:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107034:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107038:	78 18                	js     80107052 <sys_pipe+0x7f>
8010703a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010703d:	83 ec 0c             	sub    $0xc,%esp
80107040:	50                   	push   %eax
80107041:	e8 64 f3 ff ff       	call   801063aa <fdalloc>
80107046:	83 c4 10             	add    $0x10,%esp
80107049:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010704c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107050:	79 3f                	jns    80107091 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107052:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107056:	78 14                	js     8010706c <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107058:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010705e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107061:	83 c2 08             	add    $0x8,%edx
80107064:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010706b:	00 
    fileclose(rf);
8010706c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010706f:	83 ec 0c             	sub    $0xc,%esp
80107072:	50                   	push   %eax
80107073:	e8 7e a0 ff ff       	call   801010f6 <fileclose>
80107078:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010707b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010707e:	83 ec 0c             	sub    $0xc,%esp
80107081:	50                   	push   %eax
80107082:	e8 6f a0 ff ff       	call   801010f6 <fileclose>
80107087:	83 c4 10             	add    $0x10,%esp
    return -1;
8010708a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010708f:	eb 18                	jmp    801070a9 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107091:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107094:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107097:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107099:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010709c:	8d 50 04             	lea    0x4(%eax),%edx
8010709f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070a2:	89 02                	mov    %eax,(%edx)
  return 0;
801070a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070a9:	c9                   	leave  
801070aa:	c3                   	ret    

801070ab <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801070ab:	55                   	push   %ebp
801070ac:	89 e5                	mov    %esp,%ebp
801070ae:	83 ec 08             	sub    $0x8,%esp
801070b1:	8b 55 08             	mov    0x8(%ebp),%edx
801070b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801070b7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801070bb:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801070bf:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801070c3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801070c7:	66 ef                	out    %ax,(%dx)
}
801070c9:	90                   	nop
801070ca:	c9                   	leave  
801070cb:	c3                   	ret    

801070cc <sys_fork>:
#include "mmu.h"
#include "proc.h"
#include "uproc.h"
int
sys_fork(void)
{
801070cc:	55                   	push   %ebp
801070cd:	89 e5                	mov    %esp,%ebp
801070cf:	83 ec 08             	sub    $0x8,%esp
  return fork();
801070d2:	e8 ba d8 ff ff       	call   80104991 <fork>
}
801070d7:	c9                   	leave  
801070d8:	c3                   	ret    

801070d9 <sys_exit>:

int
sys_exit(void)
{
801070d9:	55                   	push   %ebp
801070da:	89 e5                	mov    %esp,%ebp
801070dc:	83 ec 08             	sub    $0x8,%esp
  exit();
801070df:	e8 f8 da ff ff       	call   80104bdc <exit>
  return 0;  // not reached
801070e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070e9:	c9                   	leave  
801070ea:	c3                   	ret    

801070eb <sys_wait>:

int
sys_wait(void)
{
801070eb:	55                   	push   %ebp
801070ec:	89 e5                	mov    %esp,%ebp
801070ee:	83 ec 08             	sub    $0x8,%esp
  return wait();
801070f1:	e8 74 dc ff ff       	call   80104d6a <wait>
}
801070f6:	c9                   	leave  
801070f7:	c3                   	ret    

801070f8 <sys_kill>:

int
sys_kill(void)
{
801070f8:	55                   	push   %ebp
801070f9:	89 e5                	mov    %esp,%ebp
801070fb:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801070fe:	83 ec 08             	sub    $0x8,%esp
80107101:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107104:	50                   	push   %eax
80107105:	6a 00                	push   $0x0
80107107:	e8 ed f0 ff ff       	call   801061f9 <argint>
8010710c:	83 c4 10             	add    $0x10,%esp
8010710f:	85 c0                	test   %eax,%eax
80107111:	79 07                	jns    8010711a <sys_kill+0x22>
    return -1;
80107113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107118:	eb 0f                	jmp    80107129 <sys_kill+0x31>
  return kill(pid);
8010711a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010711d:	83 ec 0c             	sub    $0xc,%esp
80107120:	50                   	push   %eax
80107121:	e8 91 e2 ff ff       	call   801053b7 <kill>
80107126:	83 c4 10             	add    $0x10,%esp
}
80107129:	c9                   	leave  
8010712a:	c3                   	ret    

8010712b <sys_getpid>:

int
sys_getpid(void)
{
8010712b:	55                   	push   %ebp
8010712c:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010712e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107134:	8b 40 10             	mov    0x10(%eax),%eax
}
80107137:	5d                   	pop    %ebp
80107138:	c3                   	ret    

80107139 <sys_sbrk>:

int
sys_sbrk(void)
{
80107139:	55                   	push   %ebp
8010713a:	89 e5                	mov    %esp,%ebp
8010713c:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)// remove this stub once you implement the date() system call.
8010713f:	83 ec 08             	sub    $0x8,%esp
80107142:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107145:	50                   	push   %eax
80107146:	6a 00                	push   $0x0
80107148:	e8 ac f0 ff ff       	call   801061f9 <argint>
8010714d:	83 c4 10             	add    $0x10,%esp
80107150:	85 c0                	test   %eax,%eax
80107152:	79 07                	jns    8010715b <sys_sbrk+0x22>
   return -1;
80107154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107159:	eb 28                	jmp    80107183 <sys_sbrk+0x4a>
  addr = proc->sz;
8010715b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107161:	8b 00                	mov    (%eax),%eax
80107163:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107166:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107169:	83 ec 0c             	sub    $0xc,%esp
8010716c:	50                   	push   %eax
8010716d:	e8 7c d7 ff ff       	call   801048ee <growproc>
80107172:	83 c4 10             	add    $0x10,%esp
80107175:	85 c0                	test   %eax,%eax
80107177:	79 07                	jns    80107180 <sys_sbrk+0x47>
    return -1;
80107179:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010717e:	eb 03                	jmp    80107183 <sys_sbrk+0x4a>
  return addr;
80107180:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107183:	c9                   	leave  
80107184:	c3                   	ret    

80107185 <sys_sleep>:

int
sys_sleep(void)
{
80107185:	55                   	push   %ebp
80107186:	89 e5                	mov    %esp,%ebp
80107188:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010718b:	83 ec 08             	sub    $0x8,%esp
8010718e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107191:	50                   	push   %eax
80107192:	6a 00                	push   $0x0
80107194:	e8 60 f0 ff ff       	call   801061f9 <argint>
80107199:	83 c4 10             	add    $0x10,%esp
8010719c:	85 c0                	test   %eax,%eax
8010719e:	79 07                	jns    801071a7 <sys_sleep+0x22>
    return -1;
801071a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071a5:	eb 44                	jmp    801071eb <sys_sleep+0x66>
  ticks0 = ticks;
801071a7:	a1 e0 66 11 80       	mov    0x801166e0,%eax
801071ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801071af:	eb 26                	jmp    801071d7 <sys_sleep+0x52>
    if(proc->killed){
801071b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071b7:	8b 40 24             	mov    0x24(%eax),%eax
801071ba:	85 c0                	test   %eax,%eax
801071bc:	74 07                	je     801071c5 <sys_sleep+0x40>
      return -1;
801071be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071c3:	eb 26                	jmp    801071eb <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
801071c5:	83 ec 08             	sub    $0x8,%esp
801071c8:	6a 00                	push   $0x0
801071ca:	68 e0 66 11 80       	push   $0x801166e0
801071cf:	e8 19 e0 ff ff       	call   801051ed <sleep>
801071d4:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801071d7:	a1 e0 66 11 80       	mov    0x801166e0,%eax
801071dc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801071df:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071e2:	39 d0                	cmp    %edx,%eax
801071e4:	72 cb                	jb     801071b1 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
801071e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801071eb:	c9                   	leave  
801071ec:	c3                   	ret    

801071ed <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801071ed:	55                   	push   %ebp
801071ee:	89 e5                	mov    %esp,%ebp
801071f0:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
801071f3:	a1 e0 66 11 80       	mov    0x801166e0,%eax
801071f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
801071fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801071fe:	c9                   	leave  
801071ff:	c3                   	ret    

80107200 <sys_halt>:

//Turn of the computer
int 
sys_halt(void){
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	68 53 99 10 80       	push   $0x80109953
8010720e:	e8 b3 91 ff ff       	call   801003c6 <cprintf>
80107213:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107216:	83 ec 08             	sub    $0x8,%esp
80107219:	68 00 20 00 00       	push   $0x2000
8010721e:	68 04 06 00 00       	push   $0x604
80107223:	e8 83 fe ff ff       	call   801070ab <outw>
80107228:	83 c4 10             	add    $0x10,%esp
  return 0;
8010722b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107230:	c9                   	leave  
80107231:	c3                   	ret    

80107232 <sys_date>:

// return the date
int 
sys_date(void){
80107232:	55                   	push   %ebp
80107233:	89 e5                	mov    %esp,%ebp
80107235:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;
  if(argptr(0,(void*)&d, sizeof(struct rtcdate)) < 0)
80107238:	83 ec 04             	sub    $0x4,%esp
8010723b:	6a 18                	push   $0x18
8010723d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107240:	50                   	push   %eax
80107241:	6a 00                	push   $0x0
80107243:	e8 d9 ef ff ff       	call   80106221 <argptr>
80107248:	83 c4 10             	add    $0x10,%esp
8010724b:	85 c0                	test   %eax,%eax
8010724d:	79 07                	jns    80107256 <sys_date+0x24>
    return -1;
8010724f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107254:	eb 14                	jmp    8010726a <sys_date+0x38>
  
  cmostime(d); //d updated
80107256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107259:	83 ec 0c             	sub    $0xc,%esp
8010725c:	50                   	push   %eax
8010725d:	e8 0b c0 ff ff       	call   8010326d <cmostime>
80107262:	83 c4 10             	add    $0x10,%esp
  
  return 0;
80107265:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010726a:	c9                   	leave  
8010726b:	c3                   	ret    

8010726c <sys_getuid>:

uint 
sys_getuid(void){
8010726c:	55                   	push   %ebp
8010726d:	89 e5                	mov    %esp,%ebp
  return proc->uid;
8010726f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107275:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}       
8010727b:	5d                   	pop    %ebp
8010727c:	c3                   	ret    

8010727d <sys_getgid>:

uint 
sys_getgid(void){
8010727d:	55                   	push   %ebp
8010727e:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80107280:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107286:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010728c:	5d                   	pop    %ebp
8010728d:	c3                   	ret    

8010728e <sys_getppid>:

uint
sys_getppid(void){
8010728e:	55                   	push   %ebp
8010728f:	89 e5                	mov    %esp,%ebp
80107291:	83 ec 10             	sub    $0x10,%esp
  if(proc->parent)
80107294:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010729a:	8b 40 14             	mov    0x14(%eax),%eax
8010729d:	85 c0                	test   %eax,%eax
8010729f:	74 0b                	je     801072ac <sys_getppid+0x1e>
  return proc->pid;
801072a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072a7:	8b 40 10             	mov    0x10(%eax),%eax
801072aa:	eb 12                	jmp    801072be <sys_getppid+0x30>
  int parent_id = proc->parent->pid;
801072ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072b2:	8b 40 14             	mov    0x14(%eax),%eax
801072b5:	8b 40 10             	mov    0x10(%eax),%eax
801072b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return parent_id;
801072bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801072be:	c9                   	leave  
801072bf:	c3                   	ret    

801072c0 <sys_setuid>:

int 
sys_setuid(void){     
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	83 ec 18             	sub    $0x18,%esp
int uid;
if(argint(0, &uid) < 0)
801072c6:	83 ec 08             	sub    $0x8,%esp
801072c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801072cc:	50                   	push   %eax
801072cd:	6a 00                	push   $0x0
801072cf:	e8 25 ef ff ff       	call   801061f9 <argint>
801072d4:	83 c4 10             	add    $0x10,%esp
801072d7:	85 c0                	test   %eax,%eax
801072d9:	79 07                	jns    801072e2 <sys_setuid+0x22>
    return -1;
801072db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072e0:	eb 2c                	jmp    8010730e <sys_setuid+0x4e>

  if(uid <0 || uid > 32767){
801072e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e5:	85 c0                	test   %eax,%eax
801072e7:	78 0a                	js     801072f3 <sys_setuid+0x33>
801072e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072ec:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801072f1:	7e 07                	jle    801072fa <sys_setuid+0x3a>
    return -1;
801072f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072f8:	eb 14                	jmp    8010730e <sys_setuid+0x4e>
  }
  proc->uid = uid;
801072fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107300:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107303:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)

  return 0;
80107309:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010730e:	c9                   	leave  
8010730f:	c3                   	ret    

80107310 <sys_setgid>:

int 
sys_setgid(void){
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	83 ec 18             	sub    $0x18,%esp
int gid;
 if(argint(0, &gid) < 0)
80107316:	83 ec 08             	sub    $0x8,%esp
80107319:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010731c:	50                   	push   %eax
8010731d:	6a 00                	push   $0x0
8010731f:	e8 d5 ee ff ff       	call   801061f9 <argint>
80107324:	83 c4 10             	add    $0x10,%esp
80107327:	85 c0                	test   %eax,%eax
80107329:	79 07                	jns    80107332 <sys_setgid+0x22>
    return -1;
8010732b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107330:	eb 2c                	jmp    8010735e <sys_setgid+0x4e>


  if(gid <0 || gid > 32767){
80107332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107335:	85 c0                	test   %eax,%eax
80107337:	78 0a                	js     80107343 <sys_setgid+0x33>
80107339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733c:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107341:	7e 07                	jle    8010734a <sys_setgid+0x3a>
    return -1;
80107343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107348:	eb 14                	jmp    8010735e <sys_setgid+0x4e>
  }

  proc->gid = gid;
8010734a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107350:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107353:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  return 0;
80107359:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010735e:	c9                   	leave  
8010735f:	c3                   	ret    

80107360 <sys_getprocs>:

int 
sys_getprocs(void){
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	83 ec 18             	sub    $0x18,%esp
  struct uproc *d;
  int n;
  
  if(argint(0, &n) < 0)
80107366:	83 ec 08             	sub    $0x8,%esp
80107369:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010736c:	50                   	push   %eax
8010736d:	6a 00                	push   $0x0
8010736f:	e8 85 ee ff ff       	call   801061f9 <argint>
80107374:	83 c4 10             	add    $0x10,%esp
80107377:	85 c0                	test   %eax,%eax
80107379:	79 07                	jns    80107382 <sys_getprocs+0x22>
    return -1;
8010737b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107380:	eb 31                	jmp    801073b3 <sys_getprocs+0x53>

  if(argptr(1,(void*)&d, sizeof(struct uproc)) < 0)
80107382:	83 ec 04             	sub    $0x4,%esp
80107385:	6a 5c                	push   $0x5c
80107387:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010738a:	50                   	push   %eax
8010738b:	6a 01                	push   $0x1
8010738d:	e8 8f ee ff ff       	call   80106221 <argptr>
80107392:	83 c4 10             	add    $0x10,%esp
80107395:	85 c0                	test   %eax,%eax
80107397:	79 07                	jns    801073a0 <sys_getprocs+0x40>
    return -1;
80107399:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010739e:	eb 13                	jmp    801073b3 <sys_getprocs+0x53>
  return getprocs(n, d);
801073a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801073a6:	83 ec 08             	sub    $0x8,%esp
801073a9:	50                   	push   %eax
801073aa:	52                   	push   %edx
801073ab:	e8 83 e2 ff ff       	call   80105633 <getprocs>
801073b0:	83 c4 10             	add    $0x10,%esp
}
801073b3:	c9                   	leave  
801073b4:	c3                   	ret    

801073b5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801073b5:	55                   	push   %ebp
801073b6:	89 e5                	mov    %esp,%ebp
801073b8:	83 ec 08             	sub    $0x8,%esp
801073bb:	8b 55 08             	mov    0x8(%ebp),%edx
801073be:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801073c5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801073c8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801073cc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801073d0:	ee                   	out    %al,(%dx)
}
801073d1:	90                   	nop
801073d2:	c9                   	leave  
801073d3:	c3                   	ret    

801073d4 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801073da:	6a 34                	push   $0x34
801073dc:	6a 43                	push   $0x43
801073de:	e8 d2 ff ff ff       	call   801073b5 <outb>
801073e3:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
801073e6:	68 a9 00 00 00       	push   $0xa9
801073eb:	6a 40                	push   $0x40
801073ed:	e8 c3 ff ff ff       	call   801073b5 <outb>
801073f2:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
801073f5:	6a 04                	push   $0x4
801073f7:	6a 40                	push   $0x40
801073f9:	e8 b7 ff ff ff       	call   801073b5 <outb>
801073fe:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107401:	83 ec 0c             	sub    $0xc,%esp
80107404:	6a 00                	push   $0x0
80107406:	e8 c5 cb ff ff       	call   80103fd0 <picenable>
8010740b:	83 c4 10             	add    $0x10,%esp
}
8010740e:	90                   	nop
8010740f:	c9                   	leave  
80107410:	c3                   	ret    

80107411 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107411:	1e                   	push   %ds
  pushl %es
80107412:	06                   	push   %es
  pushl %fs
80107413:	0f a0                	push   %fs
  pushl %gs
80107415:	0f a8                	push   %gs
  pushal
80107417:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107418:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010741c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010741e:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107420:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107424:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107426:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107428:	54                   	push   %esp
  call trap
80107429:	e8 ce 01 00 00       	call   801075fc <trap>
  addl $4, %esp
8010742e:	83 c4 04             	add    $0x4,%esp

80107431 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107431:	61                   	popa   
  popl %gs
80107432:	0f a9                	pop    %gs
  popl %fs
80107434:	0f a1                	pop    %fs
  popl %es
80107436:	07                   	pop    %es
  popl %ds
80107437:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107438:	83 c4 08             	add    $0x8,%esp
  iret
8010743b:	cf                   	iret   

8010743c <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
8010743c:	55                   	push   %ebp
8010743d:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
8010743f:	8b 45 08             	mov    0x8(%ebp),%eax
80107442:	f0 ff 00             	lock incl (%eax)
}
80107445:	90                   	nop
80107446:	5d                   	pop    %ebp
80107447:	c3                   	ret    

80107448 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107448:	55                   	push   %ebp
80107449:	89 e5                	mov    %esp,%ebp
8010744b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010744e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107451:	83 e8 01             	sub    $0x1,%eax
80107454:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107458:	8b 45 08             	mov    0x8(%ebp),%eax
8010745b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010745f:	8b 45 08             	mov    0x8(%ebp),%eax
80107462:	c1 e8 10             	shr    $0x10,%eax
80107465:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107469:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010746c:	0f 01 18             	lidtl  (%eax)
}
8010746f:	90                   	nop
80107470:	c9                   	leave  
80107471:	c3                   	ret    

80107472 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107472:	55                   	push   %ebp
80107473:	89 e5                	mov    %esp,%ebp
80107475:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107478:	0f 20 d0             	mov    %cr2,%eax
8010747b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010747e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107481:	c9                   	leave  
80107482:	c3                   	ret    

80107483 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107483:	55                   	push   %ebp
80107484:	89 e5                	mov    %esp,%ebp
80107486:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107489:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107490:	e9 c3 00 00 00       	jmp    80107558 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107495:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107498:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
8010749f:	89 c2                	mov    %eax,%edx
801074a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074a4:	66 89 14 c5 e0 5e 11 	mov    %dx,-0x7feea120(,%eax,8)
801074ab:	80 
801074ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074af:	66 c7 04 c5 e2 5e 11 	movw   $0x8,-0x7feea11e(,%eax,8)
801074b6:	80 08 00 
801074b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074bc:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
801074c3:	80 
801074c4:	83 e2 e0             	and    $0xffffffe0,%edx
801074c7:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
801074ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074d1:	0f b6 14 c5 e4 5e 11 	movzbl -0x7feea11c(,%eax,8),%edx
801074d8:	80 
801074d9:	83 e2 1f             	and    $0x1f,%edx
801074dc:	88 14 c5 e4 5e 11 80 	mov    %dl,-0x7feea11c(,%eax,8)
801074e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074e6:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
801074ed:	80 
801074ee:	83 e2 f0             	and    $0xfffffff0,%edx
801074f1:	83 ca 0e             	or     $0xe,%edx
801074f4:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
801074fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801074fe:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
80107505:	80 
80107506:	83 e2 ef             	and    $0xffffffef,%edx
80107509:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107510:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107513:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
8010751a:	80 
8010751b:	83 e2 9f             	and    $0xffffff9f,%edx
8010751e:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
80107525:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107528:	0f b6 14 c5 e5 5e 11 	movzbl -0x7feea11b(,%eax,8),%edx
8010752f:	80 
80107530:	83 ca 80             	or     $0xffffff80,%edx
80107533:	88 14 c5 e5 5e 11 80 	mov    %dl,-0x7feea11b(,%eax,8)
8010753a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010753d:	8b 04 85 b8 c0 10 80 	mov    -0x7fef3f48(,%eax,4),%eax
80107544:	c1 e8 10             	shr    $0x10,%eax
80107547:	89 c2                	mov    %eax,%edx
80107549:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010754c:	66 89 14 c5 e6 5e 11 	mov    %dx,-0x7feea11a(,%eax,8)
80107553:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107554:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107558:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
8010755f:	0f 8e 30 ff ff ff    	jle    80107495 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107565:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
8010756a:	66 a3 e0 60 11 80    	mov    %ax,0x801160e0
80107570:	66 c7 05 e2 60 11 80 	movw   $0x8,0x801160e2
80107577:	08 00 
80107579:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
80107580:	83 e0 e0             	and    $0xffffffe0,%eax
80107583:	a2 e4 60 11 80       	mov    %al,0x801160e4
80107588:	0f b6 05 e4 60 11 80 	movzbl 0x801160e4,%eax
8010758f:	83 e0 1f             	and    $0x1f,%eax
80107592:	a2 e4 60 11 80       	mov    %al,0x801160e4
80107597:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
8010759e:	83 c8 0f             	or     $0xf,%eax
801075a1:	a2 e5 60 11 80       	mov    %al,0x801160e5
801075a6:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
801075ad:	83 e0 ef             	and    $0xffffffef,%eax
801075b0:	a2 e5 60 11 80       	mov    %al,0x801160e5
801075b5:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
801075bc:	83 c8 60             	or     $0x60,%eax
801075bf:	a2 e5 60 11 80       	mov    %al,0x801160e5
801075c4:	0f b6 05 e5 60 11 80 	movzbl 0x801160e5,%eax
801075cb:	83 c8 80             	or     $0xffffff80,%eax
801075ce:	a2 e5 60 11 80       	mov    %al,0x801160e5
801075d3:	a1 b8 c1 10 80       	mov    0x8010c1b8,%eax
801075d8:	c1 e8 10             	shr    $0x10,%eax
801075db:	66 a3 e6 60 11 80    	mov    %ax,0x801160e6
  
}
801075e1:	90                   	nop
801075e2:	c9                   	leave  
801075e3:	c3                   	ret    

801075e4 <idtinit>:

void
idtinit(void)
{
801075e4:	55                   	push   %ebp
801075e5:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801075e7:	68 00 08 00 00       	push   $0x800
801075ec:	68 e0 5e 11 80       	push   $0x80115ee0
801075f1:	e8 52 fe ff ff       	call   80107448 <lidt>
801075f6:	83 c4 08             	add    $0x8,%esp
}
801075f9:	90                   	nop
801075fa:	c9                   	leave  
801075fb:	c3                   	ret    

801075fc <trap>:

void
trap(struct trapframe *tf)
{
801075fc:	55                   	push   %ebp
801075fd:	89 e5                	mov    %esp,%ebp
801075ff:	57                   	push   %edi
80107600:	56                   	push   %esi
80107601:	53                   	push   %ebx
80107602:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107605:	8b 45 08             	mov    0x8(%ebp),%eax
80107608:	8b 40 30             	mov    0x30(%eax),%eax
8010760b:	83 f8 40             	cmp    $0x40,%eax
8010760e:	75 3e                	jne    8010764e <trap+0x52>
    if(proc->killed)
80107610:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107616:	8b 40 24             	mov    0x24(%eax),%eax
80107619:	85 c0                	test   %eax,%eax
8010761b:	74 05                	je     80107622 <trap+0x26>
      exit();
8010761d:	e8 ba d5 ff ff       	call   80104bdc <exit>
    proc->tf = tf;
80107622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107628:	8b 55 08             	mov    0x8(%ebp),%edx
8010762b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010762e:	e8 7c ec ff ff       	call   801062af <syscall>
    if(proc->killed)
80107633:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107639:	8b 40 24             	mov    0x24(%eax),%eax
8010763c:	85 c0                	test   %eax,%eax
8010763e:	0f 84 21 02 00 00    	je     80107865 <trap+0x269>
      exit();
80107644:	e8 93 d5 ff ff       	call   80104bdc <exit>
    return;
80107649:	e9 17 02 00 00       	jmp    80107865 <trap+0x269>
  }

  switch(tf->trapno){
8010764e:	8b 45 08             	mov    0x8(%ebp),%eax
80107651:	8b 40 30             	mov    0x30(%eax),%eax
80107654:	83 e8 20             	sub    $0x20,%eax
80107657:	83 f8 1f             	cmp    $0x1f,%eax
8010765a:	0f 87 a3 00 00 00    	ja     80107703 <trap+0x107>
80107660:	8b 04 85 08 9a 10 80 	mov    -0x7fef65f8(,%eax,4),%eax
80107667:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107669:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010766f:	0f b6 00             	movzbl (%eax),%eax
80107672:	84 c0                	test   %al,%al
80107674:	75 20                	jne    80107696 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107676:	83 ec 0c             	sub    $0xc,%esp
80107679:	68 e0 66 11 80       	push   $0x801166e0
8010767e:	e8 b9 fd ff ff       	call   8010743c <atom_inc>
80107683:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107686:	83 ec 0c             	sub    $0xc,%esp
80107689:	68 e0 66 11 80       	push   $0x801166e0
8010768e:	e8 ed dc ff ff       	call   80105380 <wakeup>
80107693:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107696:	e8 2f ba ff ff       	call   801030ca <lapiceoi>
    break;
8010769b:	e9 1c 01 00 00       	jmp    801077bc <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801076a0:	e8 38 b2 ff ff       	call   801028dd <ideintr>
    lapiceoi();
801076a5:	e8 20 ba ff ff       	call   801030ca <lapiceoi>
    break;
801076aa:	e9 0d 01 00 00       	jmp    801077bc <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801076af:	e8 18 b8 ff ff       	call   80102ecc <kbdintr>
    lapiceoi();
801076b4:	e8 11 ba ff ff       	call   801030ca <lapiceoi>
    break;
801076b9:	e9 fe 00 00 00       	jmp    801077bc <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801076be:	e8 83 03 00 00       	call   80107a46 <uartintr>
    lapiceoi();
801076c3:	e8 02 ba ff ff       	call   801030ca <lapiceoi>
    break;
801076c8:	e9 ef 00 00 00       	jmp    801077bc <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801076cd:	8b 45 08             	mov    0x8(%ebp),%eax
801076d0:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801076d3:	8b 45 08             	mov    0x8(%ebp),%eax
801076d6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801076da:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801076dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801076e3:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801076e6:	0f b6 c0             	movzbl %al,%eax
801076e9:	51                   	push   %ecx
801076ea:	52                   	push   %edx
801076eb:	50                   	push   %eax
801076ec:	68 68 99 10 80       	push   $0x80109968
801076f1:	e8 d0 8c ff ff       	call   801003c6 <cprintf>
801076f6:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801076f9:	e8 cc b9 ff ff       	call   801030ca <lapiceoi>
    break;
801076fe:	e9 b9 00 00 00       	jmp    801077bc <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107703:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107709:	85 c0                	test   %eax,%eax
8010770b:	74 11                	je     8010771e <trap+0x122>
8010770d:	8b 45 08             	mov    0x8(%ebp),%eax
80107710:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107714:	0f b7 c0             	movzwl %ax,%eax
80107717:	83 e0 03             	and    $0x3,%eax
8010771a:	85 c0                	test   %eax,%eax
8010771c:	75 40                	jne    8010775e <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010771e:	e8 4f fd ff ff       	call   80107472 <rcr2>
80107723:	89 c3                	mov    %eax,%ebx
80107725:	8b 45 08             	mov    0x8(%ebp),%eax
80107728:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010772b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107731:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107734:	0f b6 d0             	movzbl %al,%edx
80107737:	8b 45 08             	mov    0x8(%ebp),%eax
8010773a:	8b 40 30             	mov    0x30(%eax),%eax
8010773d:	83 ec 0c             	sub    $0xc,%esp
80107740:	53                   	push   %ebx
80107741:	51                   	push   %ecx
80107742:	52                   	push   %edx
80107743:	50                   	push   %eax
80107744:	68 8c 99 10 80       	push   $0x8010998c
80107749:	e8 78 8c ff ff       	call   801003c6 <cprintf>
8010774e:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107751:	83 ec 0c             	sub    $0xc,%esp
80107754:	68 be 99 10 80       	push   $0x801099be
80107759:	e8 08 8e ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010775e:	e8 0f fd ff ff       	call   80107472 <rcr2>
80107763:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107766:	8b 45 08             	mov    0x8(%ebp),%eax
80107769:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010776c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107772:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107775:	0f b6 d8             	movzbl %al,%ebx
80107778:	8b 45 08             	mov    0x8(%ebp),%eax
8010777b:	8b 48 34             	mov    0x34(%eax),%ecx
8010777e:	8b 45 08             	mov    0x8(%ebp),%eax
80107781:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107784:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010778a:	8d 78 6c             	lea    0x6c(%eax),%edi
8010778d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107793:	8b 40 10             	mov    0x10(%eax),%eax
80107796:	ff 75 e4             	pushl  -0x1c(%ebp)
80107799:	56                   	push   %esi
8010779a:	53                   	push   %ebx
8010779b:	51                   	push   %ecx
8010779c:	52                   	push   %edx
8010779d:	57                   	push   %edi
8010779e:	50                   	push   %eax
8010779f:	68 c4 99 10 80       	push   $0x801099c4
801077a4:	e8 1d 8c ff ff       	call   801003c6 <cprintf>
801077a9:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801077ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077b2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801077b9:	eb 01                	jmp    801077bc <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801077bb:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801077bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077c2:	85 c0                	test   %eax,%eax
801077c4:	74 24                	je     801077ea <trap+0x1ee>
801077c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077cc:	8b 40 24             	mov    0x24(%eax),%eax
801077cf:	85 c0                	test   %eax,%eax
801077d1:	74 17                	je     801077ea <trap+0x1ee>
801077d3:	8b 45 08             	mov    0x8(%ebp),%eax
801077d6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801077da:	0f b7 c0             	movzwl %ax,%eax
801077dd:	83 e0 03             	and    $0x3,%eax
801077e0:	83 f8 03             	cmp    $0x3,%eax
801077e3:	75 05                	jne    801077ea <trap+0x1ee>
    exit();
801077e5:	e8 f2 d3 ff ff       	call   80104bdc <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
801077ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077f0:	85 c0                	test   %eax,%eax
801077f2:	74 41                	je     80107835 <trap+0x239>
801077f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077fa:	8b 40 0c             	mov    0xc(%eax),%eax
801077fd:	83 f8 04             	cmp    $0x4,%eax
80107800:	75 33                	jne    80107835 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107802:	8b 45 08             	mov    0x8(%ebp),%eax
80107805:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107808:	83 f8 20             	cmp    $0x20,%eax
8010780b:	75 28                	jne    80107835 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010780d:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
80107813:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107818:	89 c8                	mov    %ecx,%eax
8010781a:	f7 e2                	mul    %edx
8010781c:	c1 ea 03             	shr    $0x3,%edx
8010781f:	89 d0                	mov    %edx,%eax
80107821:	c1 e0 02             	shl    $0x2,%eax
80107824:	01 d0                	add    %edx,%eax
80107826:	01 c0                	add    %eax,%eax
80107828:	29 c1                	sub    %eax,%ecx
8010782a:	89 ca                	mov    %ecx,%edx
8010782c:	85 d2                	test   %edx,%edx
8010782e:	75 05                	jne    80107835 <trap+0x239>
    yield();
80107830:	e8 f5 d8 ff ff       	call   8010512a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107835:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010783b:	85 c0                	test   %eax,%eax
8010783d:	74 27                	je     80107866 <trap+0x26a>
8010783f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107845:	8b 40 24             	mov    0x24(%eax),%eax
80107848:	85 c0                	test   %eax,%eax
8010784a:	74 1a                	je     80107866 <trap+0x26a>
8010784c:	8b 45 08             	mov    0x8(%ebp),%eax
8010784f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107853:	0f b7 c0             	movzwl %ax,%eax
80107856:	83 e0 03             	and    $0x3,%eax
80107859:	83 f8 03             	cmp    $0x3,%eax
8010785c:	75 08                	jne    80107866 <trap+0x26a>
    exit();
8010785e:	e8 79 d3 ff ff       	call   80104bdc <exit>
80107863:	eb 01                	jmp    80107866 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107865:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107866:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107869:	5b                   	pop    %ebx
8010786a:	5e                   	pop    %esi
8010786b:	5f                   	pop    %edi
8010786c:	5d                   	pop    %ebp
8010786d:	c3                   	ret    

8010786e <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010786e:	55                   	push   %ebp
8010786f:	89 e5                	mov    %esp,%ebp
80107871:	83 ec 14             	sub    $0x14,%esp
80107874:	8b 45 08             	mov    0x8(%ebp),%eax
80107877:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010787b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010787f:	89 c2                	mov    %eax,%edx
80107881:	ec                   	in     (%dx),%al
80107882:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107885:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107889:	c9                   	leave  
8010788a:	c3                   	ret    

8010788b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010788b:	55                   	push   %ebp
8010788c:	89 e5                	mov    %esp,%ebp
8010788e:	83 ec 08             	sub    $0x8,%esp
80107891:	8b 55 08             	mov    0x8(%ebp),%edx
80107894:	8b 45 0c             	mov    0xc(%ebp),%eax
80107897:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010789b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010789e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801078a2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801078a6:	ee                   	out    %al,(%dx)
}
801078a7:	90                   	nop
801078a8:	c9                   	leave  
801078a9:	c3                   	ret    

801078aa <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801078aa:	55                   	push   %ebp
801078ab:	89 e5                	mov    %esp,%ebp
801078ad:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801078b0:	6a 00                	push   $0x0
801078b2:	68 fa 03 00 00       	push   $0x3fa
801078b7:	e8 cf ff ff ff       	call   8010788b <outb>
801078bc:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801078bf:	68 80 00 00 00       	push   $0x80
801078c4:	68 fb 03 00 00       	push   $0x3fb
801078c9:	e8 bd ff ff ff       	call   8010788b <outb>
801078ce:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801078d1:	6a 0c                	push   $0xc
801078d3:	68 f8 03 00 00       	push   $0x3f8
801078d8:	e8 ae ff ff ff       	call   8010788b <outb>
801078dd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801078e0:	6a 00                	push   $0x0
801078e2:	68 f9 03 00 00       	push   $0x3f9
801078e7:	e8 9f ff ff ff       	call   8010788b <outb>
801078ec:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801078ef:	6a 03                	push   $0x3
801078f1:	68 fb 03 00 00       	push   $0x3fb
801078f6:	e8 90 ff ff ff       	call   8010788b <outb>
801078fb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801078fe:	6a 00                	push   $0x0
80107900:	68 fc 03 00 00       	push   $0x3fc
80107905:	e8 81 ff ff ff       	call   8010788b <outb>
8010790a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010790d:	6a 01                	push   $0x1
8010790f:	68 f9 03 00 00       	push   $0x3f9
80107914:	e8 72 ff ff ff       	call   8010788b <outb>
80107919:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010791c:	68 fd 03 00 00       	push   $0x3fd
80107921:	e8 48 ff ff ff       	call   8010786e <inb>
80107926:	83 c4 04             	add    $0x4,%esp
80107929:	3c ff                	cmp    $0xff,%al
8010792b:	74 6e                	je     8010799b <uartinit+0xf1>
    return;
  uart = 1;
8010792d:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
80107934:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107937:	68 fa 03 00 00       	push   $0x3fa
8010793c:	e8 2d ff ff ff       	call   8010786e <inb>
80107941:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107944:	68 f8 03 00 00       	push   $0x3f8
80107949:	e8 20 ff ff ff       	call   8010786e <inb>
8010794e:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107951:	83 ec 0c             	sub    $0xc,%esp
80107954:	6a 04                	push   $0x4
80107956:	e8 75 c6 ff ff       	call   80103fd0 <picenable>
8010795b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010795e:	83 ec 08             	sub    $0x8,%esp
80107961:	6a 00                	push   $0x0
80107963:	6a 04                	push   $0x4
80107965:	e8 15 b2 ff ff       	call   80102b7f <ioapicenable>
8010796a:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010796d:	c7 45 f4 88 9a 10 80 	movl   $0x80109a88,-0xc(%ebp)
80107974:	eb 19                	jmp    8010798f <uartinit+0xe5>
    uartputc(*p);
80107976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107979:	0f b6 00             	movzbl (%eax),%eax
8010797c:	0f be c0             	movsbl %al,%eax
8010797f:	83 ec 0c             	sub    $0xc,%esp
80107982:	50                   	push   %eax
80107983:	e8 16 00 00 00       	call   8010799e <uartputc>
80107988:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010798b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010798f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107992:	0f b6 00             	movzbl (%eax),%eax
80107995:	84 c0                	test   %al,%al
80107997:	75 dd                	jne    80107976 <uartinit+0xcc>
80107999:	eb 01                	jmp    8010799c <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010799b:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010799c:	c9                   	leave  
8010799d:	c3                   	ret    

8010799e <uartputc>:

void
uartputc(int c)
{
8010799e:	55                   	push   %ebp
8010799f:	89 e5                	mov    %esp,%ebp
801079a1:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801079a4:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801079a9:	85 c0                	test   %eax,%eax
801079ab:	74 53                	je     80107a00 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801079ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801079b4:	eb 11                	jmp    801079c7 <uartputc+0x29>
    microdelay(10);
801079b6:	83 ec 0c             	sub    $0xc,%esp
801079b9:	6a 0a                	push   $0xa
801079bb:	e8 25 b7 ff ff       	call   801030e5 <microdelay>
801079c0:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801079c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801079c7:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801079cb:	7f 1a                	jg     801079e7 <uartputc+0x49>
801079cd:	83 ec 0c             	sub    $0xc,%esp
801079d0:	68 fd 03 00 00       	push   $0x3fd
801079d5:	e8 94 fe ff ff       	call   8010786e <inb>
801079da:	83 c4 10             	add    $0x10,%esp
801079dd:	0f b6 c0             	movzbl %al,%eax
801079e0:	83 e0 20             	and    $0x20,%eax
801079e3:	85 c0                	test   %eax,%eax
801079e5:	74 cf                	je     801079b6 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801079e7:	8b 45 08             	mov    0x8(%ebp),%eax
801079ea:	0f b6 c0             	movzbl %al,%eax
801079ed:	83 ec 08             	sub    $0x8,%esp
801079f0:	50                   	push   %eax
801079f1:	68 f8 03 00 00       	push   $0x3f8
801079f6:	e8 90 fe ff ff       	call   8010788b <outb>
801079fb:	83 c4 10             	add    $0x10,%esp
801079fe:	eb 01                	jmp    80107a01 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107a00:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107a01:	c9                   	leave  
80107a02:	c3                   	ret    

80107a03 <uartgetc>:

static int
uartgetc(void)
{
80107a03:	55                   	push   %ebp
80107a04:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107a06:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107a0b:	85 c0                	test   %eax,%eax
80107a0d:	75 07                	jne    80107a16 <uartgetc+0x13>
    return -1;
80107a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a14:	eb 2e                	jmp    80107a44 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107a16:	68 fd 03 00 00       	push   $0x3fd
80107a1b:	e8 4e fe ff ff       	call   8010786e <inb>
80107a20:	83 c4 04             	add    $0x4,%esp
80107a23:	0f b6 c0             	movzbl %al,%eax
80107a26:	83 e0 01             	and    $0x1,%eax
80107a29:	85 c0                	test   %eax,%eax
80107a2b:	75 07                	jne    80107a34 <uartgetc+0x31>
    return -1;
80107a2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a32:	eb 10                	jmp    80107a44 <uartgetc+0x41>
  return inb(COM1+0);
80107a34:	68 f8 03 00 00       	push   $0x3f8
80107a39:	e8 30 fe ff ff       	call   8010786e <inb>
80107a3e:	83 c4 04             	add    $0x4,%esp
80107a41:	0f b6 c0             	movzbl %al,%eax
}
80107a44:	c9                   	leave  
80107a45:	c3                   	ret    

80107a46 <uartintr>:

void
uartintr(void)
{
80107a46:	55                   	push   %ebp
80107a47:	89 e5                	mov    %esp,%ebp
80107a49:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107a4c:	83 ec 0c             	sub    $0xc,%esp
80107a4f:	68 03 7a 10 80       	push   $0x80107a03
80107a54:	e8 a0 8d ff ff       	call   801007f9 <consoleintr>
80107a59:	83 c4 10             	add    $0x10,%esp
}
80107a5c:	90                   	nop
80107a5d:	c9                   	leave  
80107a5e:	c3                   	ret    

80107a5f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $0
80107a61:	6a 00                	push   $0x0
  jmp alltraps
80107a63:	e9 a9 f9 ff ff       	jmp    80107411 <alltraps>

80107a68 <vector1>:
.globl vector1
vector1:
  pushl $0
80107a68:	6a 00                	push   $0x0
  pushl $1
80107a6a:	6a 01                	push   $0x1
  jmp alltraps
80107a6c:	e9 a0 f9 ff ff       	jmp    80107411 <alltraps>

80107a71 <vector2>:
.globl vector2
vector2:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $2
80107a73:	6a 02                	push   $0x2
  jmp alltraps
80107a75:	e9 97 f9 ff ff       	jmp    80107411 <alltraps>

80107a7a <vector3>:
.globl vector3
vector3:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $3
80107a7c:	6a 03                	push   $0x3
  jmp alltraps
80107a7e:	e9 8e f9 ff ff       	jmp    80107411 <alltraps>

80107a83 <vector4>:
.globl vector4
vector4:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $4
80107a85:	6a 04                	push   $0x4
  jmp alltraps
80107a87:	e9 85 f9 ff ff       	jmp    80107411 <alltraps>

80107a8c <vector5>:
.globl vector5
vector5:
  pushl $0
80107a8c:	6a 00                	push   $0x0
  pushl $5
80107a8e:	6a 05                	push   $0x5
  jmp alltraps
80107a90:	e9 7c f9 ff ff       	jmp    80107411 <alltraps>

80107a95 <vector6>:
.globl vector6
vector6:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $6
80107a97:	6a 06                	push   $0x6
  jmp alltraps
80107a99:	e9 73 f9 ff ff       	jmp    80107411 <alltraps>

80107a9e <vector7>:
.globl vector7
vector7:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $7
80107aa0:	6a 07                	push   $0x7
  jmp alltraps
80107aa2:	e9 6a f9 ff ff       	jmp    80107411 <alltraps>

80107aa7 <vector8>:
.globl vector8
vector8:
  pushl $8
80107aa7:	6a 08                	push   $0x8
  jmp alltraps
80107aa9:	e9 63 f9 ff ff       	jmp    80107411 <alltraps>

80107aae <vector9>:
.globl vector9
vector9:
  pushl $0
80107aae:	6a 00                	push   $0x0
  pushl $9
80107ab0:	6a 09                	push   $0x9
  jmp alltraps
80107ab2:	e9 5a f9 ff ff       	jmp    80107411 <alltraps>

80107ab7 <vector10>:
.globl vector10
vector10:
  pushl $10
80107ab7:	6a 0a                	push   $0xa
  jmp alltraps
80107ab9:	e9 53 f9 ff ff       	jmp    80107411 <alltraps>

80107abe <vector11>:
.globl vector11
vector11:
  pushl $11
80107abe:	6a 0b                	push   $0xb
  jmp alltraps
80107ac0:	e9 4c f9 ff ff       	jmp    80107411 <alltraps>

80107ac5 <vector12>:
.globl vector12
vector12:
  pushl $12
80107ac5:	6a 0c                	push   $0xc
  jmp alltraps
80107ac7:	e9 45 f9 ff ff       	jmp    80107411 <alltraps>

80107acc <vector13>:
.globl vector13
vector13:
  pushl $13
80107acc:	6a 0d                	push   $0xd
  jmp alltraps
80107ace:	e9 3e f9 ff ff       	jmp    80107411 <alltraps>

80107ad3 <vector14>:
.globl vector14
vector14:
  pushl $14
80107ad3:	6a 0e                	push   $0xe
  jmp alltraps
80107ad5:	e9 37 f9 ff ff       	jmp    80107411 <alltraps>

80107ada <vector15>:
.globl vector15
vector15:
  pushl $0
80107ada:	6a 00                	push   $0x0
  pushl $15
80107adc:	6a 0f                	push   $0xf
  jmp alltraps
80107ade:	e9 2e f9 ff ff       	jmp    80107411 <alltraps>

80107ae3 <vector16>:
.globl vector16
vector16:
  pushl $0
80107ae3:	6a 00                	push   $0x0
  pushl $16
80107ae5:	6a 10                	push   $0x10
  jmp alltraps
80107ae7:	e9 25 f9 ff ff       	jmp    80107411 <alltraps>

80107aec <vector17>:
.globl vector17
vector17:
  pushl $17
80107aec:	6a 11                	push   $0x11
  jmp alltraps
80107aee:	e9 1e f9 ff ff       	jmp    80107411 <alltraps>

80107af3 <vector18>:
.globl vector18
vector18:
  pushl $0
80107af3:	6a 00                	push   $0x0
  pushl $18
80107af5:	6a 12                	push   $0x12
  jmp alltraps
80107af7:	e9 15 f9 ff ff       	jmp    80107411 <alltraps>

80107afc <vector19>:
.globl vector19
vector19:
  pushl $0
80107afc:	6a 00                	push   $0x0
  pushl $19
80107afe:	6a 13                	push   $0x13
  jmp alltraps
80107b00:	e9 0c f9 ff ff       	jmp    80107411 <alltraps>

80107b05 <vector20>:
.globl vector20
vector20:
  pushl $0
80107b05:	6a 00                	push   $0x0
  pushl $20
80107b07:	6a 14                	push   $0x14
  jmp alltraps
80107b09:	e9 03 f9 ff ff       	jmp    80107411 <alltraps>

80107b0e <vector21>:
.globl vector21
vector21:
  pushl $0
80107b0e:	6a 00                	push   $0x0
  pushl $21
80107b10:	6a 15                	push   $0x15
  jmp alltraps
80107b12:	e9 fa f8 ff ff       	jmp    80107411 <alltraps>

80107b17 <vector22>:
.globl vector22
vector22:
  pushl $0
80107b17:	6a 00                	push   $0x0
  pushl $22
80107b19:	6a 16                	push   $0x16
  jmp alltraps
80107b1b:	e9 f1 f8 ff ff       	jmp    80107411 <alltraps>

80107b20 <vector23>:
.globl vector23
vector23:
  pushl $0
80107b20:	6a 00                	push   $0x0
  pushl $23
80107b22:	6a 17                	push   $0x17
  jmp alltraps
80107b24:	e9 e8 f8 ff ff       	jmp    80107411 <alltraps>

80107b29 <vector24>:
.globl vector24
vector24:
  pushl $0
80107b29:	6a 00                	push   $0x0
  pushl $24
80107b2b:	6a 18                	push   $0x18
  jmp alltraps
80107b2d:	e9 df f8 ff ff       	jmp    80107411 <alltraps>

80107b32 <vector25>:
.globl vector25
vector25:
  pushl $0
80107b32:	6a 00                	push   $0x0
  pushl $25
80107b34:	6a 19                	push   $0x19
  jmp alltraps
80107b36:	e9 d6 f8 ff ff       	jmp    80107411 <alltraps>

80107b3b <vector26>:
.globl vector26
vector26:
  pushl $0
80107b3b:	6a 00                	push   $0x0
  pushl $26
80107b3d:	6a 1a                	push   $0x1a
  jmp alltraps
80107b3f:	e9 cd f8 ff ff       	jmp    80107411 <alltraps>

80107b44 <vector27>:
.globl vector27
vector27:
  pushl $0
80107b44:	6a 00                	push   $0x0
  pushl $27
80107b46:	6a 1b                	push   $0x1b
  jmp alltraps
80107b48:	e9 c4 f8 ff ff       	jmp    80107411 <alltraps>

80107b4d <vector28>:
.globl vector28
vector28:
  pushl $0
80107b4d:	6a 00                	push   $0x0
  pushl $28
80107b4f:	6a 1c                	push   $0x1c
  jmp alltraps
80107b51:	e9 bb f8 ff ff       	jmp    80107411 <alltraps>

80107b56 <vector29>:
.globl vector29
vector29:
  pushl $0
80107b56:	6a 00                	push   $0x0
  pushl $29
80107b58:	6a 1d                	push   $0x1d
  jmp alltraps
80107b5a:	e9 b2 f8 ff ff       	jmp    80107411 <alltraps>

80107b5f <vector30>:
.globl vector30
vector30:
  pushl $0
80107b5f:	6a 00                	push   $0x0
  pushl $30
80107b61:	6a 1e                	push   $0x1e
  jmp alltraps
80107b63:	e9 a9 f8 ff ff       	jmp    80107411 <alltraps>

80107b68 <vector31>:
.globl vector31
vector31:
  pushl $0
80107b68:	6a 00                	push   $0x0
  pushl $31
80107b6a:	6a 1f                	push   $0x1f
  jmp alltraps
80107b6c:	e9 a0 f8 ff ff       	jmp    80107411 <alltraps>

80107b71 <vector32>:
.globl vector32
vector32:
  pushl $0
80107b71:	6a 00                	push   $0x0
  pushl $32
80107b73:	6a 20                	push   $0x20
  jmp alltraps
80107b75:	e9 97 f8 ff ff       	jmp    80107411 <alltraps>

80107b7a <vector33>:
.globl vector33
vector33:
  pushl $0
80107b7a:	6a 00                	push   $0x0
  pushl $33
80107b7c:	6a 21                	push   $0x21
  jmp alltraps
80107b7e:	e9 8e f8 ff ff       	jmp    80107411 <alltraps>

80107b83 <vector34>:
.globl vector34
vector34:
  pushl $0
80107b83:	6a 00                	push   $0x0
  pushl $34
80107b85:	6a 22                	push   $0x22
  jmp alltraps
80107b87:	e9 85 f8 ff ff       	jmp    80107411 <alltraps>

80107b8c <vector35>:
.globl vector35
vector35:
  pushl $0
80107b8c:	6a 00                	push   $0x0
  pushl $35
80107b8e:	6a 23                	push   $0x23
  jmp alltraps
80107b90:	e9 7c f8 ff ff       	jmp    80107411 <alltraps>

80107b95 <vector36>:
.globl vector36
vector36:
  pushl $0
80107b95:	6a 00                	push   $0x0
  pushl $36
80107b97:	6a 24                	push   $0x24
  jmp alltraps
80107b99:	e9 73 f8 ff ff       	jmp    80107411 <alltraps>

80107b9e <vector37>:
.globl vector37
vector37:
  pushl $0
80107b9e:	6a 00                	push   $0x0
  pushl $37
80107ba0:	6a 25                	push   $0x25
  jmp alltraps
80107ba2:	e9 6a f8 ff ff       	jmp    80107411 <alltraps>

80107ba7 <vector38>:
.globl vector38
vector38:
  pushl $0
80107ba7:	6a 00                	push   $0x0
  pushl $38
80107ba9:	6a 26                	push   $0x26
  jmp alltraps
80107bab:	e9 61 f8 ff ff       	jmp    80107411 <alltraps>

80107bb0 <vector39>:
.globl vector39
vector39:
  pushl $0
80107bb0:	6a 00                	push   $0x0
  pushl $39
80107bb2:	6a 27                	push   $0x27
  jmp alltraps
80107bb4:	e9 58 f8 ff ff       	jmp    80107411 <alltraps>

80107bb9 <vector40>:
.globl vector40
vector40:
  pushl $0
80107bb9:	6a 00                	push   $0x0
  pushl $40
80107bbb:	6a 28                	push   $0x28
  jmp alltraps
80107bbd:	e9 4f f8 ff ff       	jmp    80107411 <alltraps>

80107bc2 <vector41>:
.globl vector41
vector41:
  pushl $0
80107bc2:	6a 00                	push   $0x0
  pushl $41
80107bc4:	6a 29                	push   $0x29
  jmp alltraps
80107bc6:	e9 46 f8 ff ff       	jmp    80107411 <alltraps>

80107bcb <vector42>:
.globl vector42
vector42:
  pushl $0
80107bcb:	6a 00                	push   $0x0
  pushl $42
80107bcd:	6a 2a                	push   $0x2a
  jmp alltraps
80107bcf:	e9 3d f8 ff ff       	jmp    80107411 <alltraps>

80107bd4 <vector43>:
.globl vector43
vector43:
  pushl $0
80107bd4:	6a 00                	push   $0x0
  pushl $43
80107bd6:	6a 2b                	push   $0x2b
  jmp alltraps
80107bd8:	e9 34 f8 ff ff       	jmp    80107411 <alltraps>

80107bdd <vector44>:
.globl vector44
vector44:
  pushl $0
80107bdd:	6a 00                	push   $0x0
  pushl $44
80107bdf:	6a 2c                	push   $0x2c
  jmp alltraps
80107be1:	e9 2b f8 ff ff       	jmp    80107411 <alltraps>

80107be6 <vector45>:
.globl vector45
vector45:
  pushl $0
80107be6:	6a 00                	push   $0x0
  pushl $45
80107be8:	6a 2d                	push   $0x2d
  jmp alltraps
80107bea:	e9 22 f8 ff ff       	jmp    80107411 <alltraps>

80107bef <vector46>:
.globl vector46
vector46:
  pushl $0
80107bef:	6a 00                	push   $0x0
  pushl $46
80107bf1:	6a 2e                	push   $0x2e
  jmp alltraps
80107bf3:	e9 19 f8 ff ff       	jmp    80107411 <alltraps>

80107bf8 <vector47>:
.globl vector47
vector47:
  pushl $0
80107bf8:	6a 00                	push   $0x0
  pushl $47
80107bfa:	6a 2f                	push   $0x2f
  jmp alltraps
80107bfc:	e9 10 f8 ff ff       	jmp    80107411 <alltraps>

80107c01 <vector48>:
.globl vector48
vector48:
  pushl $0
80107c01:	6a 00                	push   $0x0
  pushl $48
80107c03:	6a 30                	push   $0x30
  jmp alltraps
80107c05:	e9 07 f8 ff ff       	jmp    80107411 <alltraps>

80107c0a <vector49>:
.globl vector49
vector49:
  pushl $0
80107c0a:	6a 00                	push   $0x0
  pushl $49
80107c0c:	6a 31                	push   $0x31
  jmp alltraps
80107c0e:	e9 fe f7 ff ff       	jmp    80107411 <alltraps>

80107c13 <vector50>:
.globl vector50
vector50:
  pushl $0
80107c13:	6a 00                	push   $0x0
  pushl $50
80107c15:	6a 32                	push   $0x32
  jmp alltraps
80107c17:	e9 f5 f7 ff ff       	jmp    80107411 <alltraps>

80107c1c <vector51>:
.globl vector51
vector51:
  pushl $0
80107c1c:	6a 00                	push   $0x0
  pushl $51
80107c1e:	6a 33                	push   $0x33
  jmp alltraps
80107c20:	e9 ec f7 ff ff       	jmp    80107411 <alltraps>

80107c25 <vector52>:
.globl vector52
vector52:
  pushl $0
80107c25:	6a 00                	push   $0x0
  pushl $52
80107c27:	6a 34                	push   $0x34
  jmp alltraps
80107c29:	e9 e3 f7 ff ff       	jmp    80107411 <alltraps>

80107c2e <vector53>:
.globl vector53
vector53:
  pushl $0
80107c2e:	6a 00                	push   $0x0
  pushl $53
80107c30:	6a 35                	push   $0x35
  jmp alltraps
80107c32:	e9 da f7 ff ff       	jmp    80107411 <alltraps>

80107c37 <vector54>:
.globl vector54
vector54:
  pushl $0
80107c37:	6a 00                	push   $0x0
  pushl $54
80107c39:	6a 36                	push   $0x36
  jmp alltraps
80107c3b:	e9 d1 f7 ff ff       	jmp    80107411 <alltraps>

80107c40 <vector55>:
.globl vector55
vector55:
  pushl $0
80107c40:	6a 00                	push   $0x0
  pushl $55
80107c42:	6a 37                	push   $0x37
  jmp alltraps
80107c44:	e9 c8 f7 ff ff       	jmp    80107411 <alltraps>

80107c49 <vector56>:
.globl vector56
vector56:
  pushl $0
80107c49:	6a 00                	push   $0x0
  pushl $56
80107c4b:	6a 38                	push   $0x38
  jmp alltraps
80107c4d:	e9 bf f7 ff ff       	jmp    80107411 <alltraps>

80107c52 <vector57>:
.globl vector57
vector57:
  pushl $0
80107c52:	6a 00                	push   $0x0
  pushl $57
80107c54:	6a 39                	push   $0x39
  jmp alltraps
80107c56:	e9 b6 f7 ff ff       	jmp    80107411 <alltraps>

80107c5b <vector58>:
.globl vector58
vector58:
  pushl $0
80107c5b:	6a 00                	push   $0x0
  pushl $58
80107c5d:	6a 3a                	push   $0x3a
  jmp alltraps
80107c5f:	e9 ad f7 ff ff       	jmp    80107411 <alltraps>

80107c64 <vector59>:
.globl vector59
vector59:
  pushl $0
80107c64:	6a 00                	push   $0x0
  pushl $59
80107c66:	6a 3b                	push   $0x3b
  jmp alltraps
80107c68:	e9 a4 f7 ff ff       	jmp    80107411 <alltraps>

80107c6d <vector60>:
.globl vector60
vector60:
  pushl $0
80107c6d:	6a 00                	push   $0x0
  pushl $60
80107c6f:	6a 3c                	push   $0x3c
  jmp alltraps
80107c71:	e9 9b f7 ff ff       	jmp    80107411 <alltraps>

80107c76 <vector61>:
.globl vector61
vector61:
  pushl $0
80107c76:	6a 00                	push   $0x0
  pushl $61
80107c78:	6a 3d                	push   $0x3d
  jmp alltraps
80107c7a:	e9 92 f7 ff ff       	jmp    80107411 <alltraps>

80107c7f <vector62>:
.globl vector62
vector62:
  pushl $0
80107c7f:	6a 00                	push   $0x0
  pushl $62
80107c81:	6a 3e                	push   $0x3e
  jmp alltraps
80107c83:	e9 89 f7 ff ff       	jmp    80107411 <alltraps>

80107c88 <vector63>:
.globl vector63
vector63:
  pushl $0
80107c88:	6a 00                	push   $0x0
  pushl $63
80107c8a:	6a 3f                	push   $0x3f
  jmp alltraps
80107c8c:	e9 80 f7 ff ff       	jmp    80107411 <alltraps>

80107c91 <vector64>:
.globl vector64
vector64:
  pushl $0
80107c91:	6a 00                	push   $0x0
  pushl $64
80107c93:	6a 40                	push   $0x40
  jmp alltraps
80107c95:	e9 77 f7 ff ff       	jmp    80107411 <alltraps>

80107c9a <vector65>:
.globl vector65
vector65:
  pushl $0
80107c9a:	6a 00                	push   $0x0
  pushl $65
80107c9c:	6a 41                	push   $0x41
  jmp alltraps
80107c9e:	e9 6e f7 ff ff       	jmp    80107411 <alltraps>

80107ca3 <vector66>:
.globl vector66
vector66:
  pushl $0
80107ca3:	6a 00                	push   $0x0
  pushl $66
80107ca5:	6a 42                	push   $0x42
  jmp alltraps
80107ca7:	e9 65 f7 ff ff       	jmp    80107411 <alltraps>

80107cac <vector67>:
.globl vector67
vector67:
  pushl $0
80107cac:	6a 00                	push   $0x0
  pushl $67
80107cae:	6a 43                	push   $0x43
  jmp alltraps
80107cb0:	e9 5c f7 ff ff       	jmp    80107411 <alltraps>

80107cb5 <vector68>:
.globl vector68
vector68:
  pushl $0
80107cb5:	6a 00                	push   $0x0
  pushl $68
80107cb7:	6a 44                	push   $0x44
  jmp alltraps
80107cb9:	e9 53 f7 ff ff       	jmp    80107411 <alltraps>

80107cbe <vector69>:
.globl vector69
vector69:
  pushl $0
80107cbe:	6a 00                	push   $0x0
  pushl $69
80107cc0:	6a 45                	push   $0x45
  jmp alltraps
80107cc2:	e9 4a f7 ff ff       	jmp    80107411 <alltraps>

80107cc7 <vector70>:
.globl vector70
vector70:
  pushl $0
80107cc7:	6a 00                	push   $0x0
  pushl $70
80107cc9:	6a 46                	push   $0x46
  jmp alltraps
80107ccb:	e9 41 f7 ff ff       	jmp    80107411 <alltraps>

80107cd0 <vector71>:
.globl vector71
vector71:
  pushl $0
80107cd0:	6a 00                	push   $0x0
  pushl $71
80107cd2:	6a 47                	push   $0x47
  jmp alltraps
80107cd4:	e9 38 f7 ff ff       	jmp    80107411 <alltraps>

80107cd9 <vector72>:
.globl vector72
vector72:
  pushl $0
80107cd9:	6a 00                	push   $0x0
  pushl $72
80107cdb:	6a 48                	push   $0x48
  jmp alltraps
80107cdd:	e9 2f f7 ff ff       	jmp    80107411 <alltraps>

80107ce2 <vector73>:
.globl vector73
vector73:
  pushl $0
80107ce2:	6a 00                	push   $0x0
  pushl $73
80107ce4:	6a 49                	push   $0x49
  jmp alltraps
80107ce6:	e9 26 f7 ff ff       	jmp    80107411 <alltraps>

80107ceb <vector74>:
.globl vector74
vector74:
  pushl $0
80107ceb:	6a 00                	push   $0x0
  pushl $74
80107ced:	6a 4a                	push   $0x4a
  jmp alltraps
80107cef:	e9 1d f7 ff ff       	jmp    80107411 <alltraps>

80107cf4 <vector75>:
.globl vector75
vector75:
  pushl $0
80107cf4:	6a 00                	push   $0x0
  pushl $75
80107cf6:	6a 4b                	push   $0x4b
  jmp alltraps
80107cf8:	e9 14 f7 ff ff       	jmp    80107411 <alltraps>

80107cfd <vector76>:
.globl vector76
vector76:
  pushl $0
80107cfd:	6a 00                	push   $0x0
  pushl $76
80107cff:	6a 4c                	push   $0x4c
  jmp alltraps
80107d01:	e9 0b f7 ff ff       	jmp    80107411 <alltraps>

80107d06 <vector77>:
.globl vector77
vector77:
  pushl $0
80107d06:	6a 00                	push   $0x0
  pushl $77
80107d08:	6a 4d                	push   $0x4d
  jmp alltraps
80107d0a:	e9 02 f7 ff ff       	jmp    80107411 <alltraps>

80107d0f <vector78>:
.globl vector78
vector78:
  pushl $0
80107d0f:	6a 00                	push   $0x0
  pushl $78
80107d11:	6a 4e                	push   $0x4e
  jmp alltraps
80107d13:	e9 f9 f6 ff ff       	jmp    80107411 <alltraps>

80107d18 <vector79>:
.globl vector79
vector79:
  pushl $0
80107d18:	6a 00                	push   $0x0
  pushl $79
80107d1a:	6a 4f                	push   $0x4f
  jmp alltraps
80107d1c:	e9 f0 f6 ff ff       	jmp    80107411 <alltraps>

80107d21 <vector80>:
.globl vector80
vector80:
  pushl $0
80107d21:	6a 00                	push   $0x0
  pushl $80
80107d23:	6a 50                	push   $0x50
  jmp alltraps
80107d25:	e9 e7 f6 ff ff       	jmp    80107411 <alltraps>

80107d2a <vector81>:
.globl vector81
vector81:
  pushl $0
80107d2a:	6a 00                	push   $0x0
  pushl $81
80107d2c:	6a 51                	push   $0x51
  jmp alltraps
80107d2e:	e9 de f6 ff ff       	jmp    80107411 <alltraps>

80107d33 <vector82>:
.globl vector82
vector82:
  pushl $0
80107d33:	6a 00                	push   $0x0
  pushl $82
80107d35:	6a 52                	push   $0x52
  jmp alltraps
80107d37:	e9 d5 f6 ff ff       	jmp    80107411 <alltraps>

80107d3c <vector83>:
.globl vector83
vector83:
  pushl $0
80107d3c:	6a 00                	push   $0x0
  pushl $83
80107d3e:	6a 53                	push   $0x53
  jmp alltraps
80107d40:	e9 cc f6 ff ff       	jmp    80107411 <alltraps>

80107d45 <vector84>:
.globl vector84
vector84:
  pushl $0
80107d45:	6a 00                	push   $0x0
  pushl $84
80107d47:	6a 54                	push   $0x54
  jmp alltraps
80107d49:	e9 c3 f6 ff ff       	jmp    80107411 <alltraps>

80107d4e <vector85>:
.globl vector85
vector85:
  pushl $0
80107d4e:	6a 00                	push   $0x0
  pushl $85
80107d50:	6a 55                	push   $0x55
  jmp alltraps
80107d52:	e9 ba f6 ff ff       	jmp    80107411 <alltraps>

80107d57 <vector86>:
.globl vector86
vector86:
  pushl $0
80107d57:	6a 00                	push   $0x0
  pushl $86
80107d59:	6a 56                	push   $0x56
  jmp alltraps
80107d5b:	e9 b1 f6 ff ff       	jmp    80107411 <alltraps>

80107d60 <vector87>:
.globl vector87
vector87:
  pushl $0
80107d60:	6a 00                	push   $0x0
  pushl $87
80107d62:	6a 57                	push   $0x57
  jmp alltraps
80107d64:	e9 a8 f6 ff ff       	jmp    80107411 <alltraps>

80107d69 <vector88>:
.globl vector88
vector88:
  pushl $0
80107d69:	6a 00                	push   $0x0
  pushl $88
80107d6b:	6a 58                	push   $0x58
  jmp alltraps
80107d6d:	e9 9f f6 ff ff       	jmp    80107411 <alltraps>

80107d72 <vector89>:
.globl vector89
vector89:
  pushl $0
80107d72:	6a 00                	push   $0x0
  pushl $89
80107d74:	6a 59                	push   $0x59
  jmp alltraps
80107d76:	e9 96 f6 ff ff       	jmp    80107411 <alltraps>

80107d7b <vector90>:
.globl vector90
vector90:
  pushl $0
80107d7b:	6a 00                	push   $0x0
  pushl $90
80107d7d:	6a 5a                	push   $0x5a
  jmp alltraps
80107d7f:	e9 8d f6 ff ff       	jmp    80107411 <alltraps>

80107d84 <vector91>:
.globl vector91
vector91:
  pushl $0
80107d84:	6a 00                	push   $0x0
  pushl $91
80107d86:	6a 5b                	push   $0x5b
  jmp alltraps
80107d88:	e9 84 f6 ff ff       	jmp    80107411 <alltraps>

80107d8d <vector92>:
.globl vector92
vector92:
  pushl $0
80107d8d:	6a 00                	push   $0x0
  pushl $92
80107d8f:	6a 5c                	push   $0x5c
  jmp alltraps
80107d91:	e9 7b f6 ff ff       	jmp    80107411 <alltraps>

80107d96 <vector93>:
.globl vector93
vector93:
  pushl $0
80107d96:	6a 00                	push   $0x0
  pushl $93
80107d98:	6a 5d                	push   $0x5d
  jmp alltraps
80107d9a:	e9 72 f6 ff ff       	jmp    80107411 <alltraps>

80107d9f <vector94>:
.globl vector94
vector94:
  pushl $0
80107d9f:	6a 00                	push   $0x0
  pushl $94
80107da1:	6a 5e                	push   $0x5e
  jmp alltraps
80107da3:	e9 69 f6 ff ff       	jmp    80107411 <alltraps>

80107da8 <vector95>:
.globl vector95
vector95:
  pushl $0
80107da8:	6a 00                	push   $0x0
  pushl $95
80107daa:	6a 5f                	push   $0x5f
  jmp alltraps
80107dac:	e9 60 f6 ff ff       	jmp    80107411 <alltraps>

80107db1 <vector96>:
.globl vector96
vector96:
  pushl $0
80107db1:	6a 00                	push   $0x0
  pushl $96
80107db3:	6a 60                	push   $0x60
  jmp alltraps
80107db5:	e9 57 f6 ff ff       	jmp    80107411 <alltraps>

80107dba <vector97>:
.globl vector97
vector97:
  pushl $0
80107dba:	6a 00                	push   $0x0
  pushl $97
80107dbc:	6a 61                	push   $0x61
  jmp alltraps
80107dbe:	e9 4e f6 ff ff       	jmp    80107411 <alltraps>

80107dc3 <vector98>:
.globl vector98
vector98:
  pushl $0
80107dc3:	6a 00                	push   $0x0
  pushl $98
80107dc5:	6a 62                	push   $0x62
  jmp alltraps
80107dc7:	e9 45 f6 ff ff       	jmp    80107411 <alltraps>

80107dcc <vector99>:
.globl vector99
vector99:
  pushl $0
80107dcc:	6a 00                	push   $0x0
  pushl $99
80107dce:	6a 63                	push   $0x63
  jmp alltraps
80107dd0:	e9 3c f6 ff ff       	jmp    80107411 <alltraps>

80107dd5 <vector100>:
.globl vector100
vector100:
  pushl $0
80107dd5:	6a 00                	push   $0x0
  pushl $100
80107dd7:	6a 64                	push   $0x64
  jmp alltraps
80107dd9:	e9 33 f6 ff ff       	jmp    80107411 <alltraps>

80107dde <vector101>:
.globl vector101
vector101:
  pushl $0
80107dde:	6a 00                	push   $0x0
  pushl $101
80107de0:	6a 65                	push   $0x65
  jmp alltraps
80107de2:	e9 2a f6 ff ff       	jmp    80107411 <alltraps>

80107de7 <vector102>:
.globl vector102
vector102:
  pushl $0
80107de7:	6a 00                	push   $0x0
  pushl $102
80107de9:	6a 66                	push   $0x66
  jmp alltraps
80107deb:	e9 21 f6 ff ff       	jmp    80107411 <alltraps>

80107df0 <vector103>:
.globl vector103
vector103:
  pushl $0
80107df0:	6a 00                	push   $0x0
  pushl $103
80107df2:	6a 67                	push   $0x67
  jmp alltraps
80107df4:	e9 18 f6 ff ff       	jmp    80107411 <alltraps>

80107df9 <vector104>:
.globl vector104
vector104:
  pushl $0
80107df9:	6a 00                	push   $0x0
  pushl $104
80107dfb:	6a 68                	push   $0x68
  jmp alltraps
80107dfd:	e9 0f f6 ff ff       	jmp    80107411 <alltraps>

80107e02 <vector105>:
.globl vector105
vector105:
  pushl $0
80107e02:	6a 00                	push   $0x0
  pushl $105
80107e04:	6a 69                	push   $0x69
  jmp alltraps
80107e06:	e9 06 f6 ff ff       	jmp    80107411 <alltraps>

80107e0b <vector106>:
.globl vector106
vector106:
  pushl $0
80107e0b:	6a 00                	push   $0x0
  pushl $106
80107e0d:	6a 6a                	push   $0x6a
  jmp alltraps
80107e0f:	e9 fd f5 ff ff       	jmp    80107411 <alltraps>

80107e14 <vector107>:
.globl vector107
vector107:
  pushl $0
80107e14:	6a 00                	push   $0x0
  pushl $107
80107e16:	6a 6b                	push   $0x6b
  jmp alltraps
80107e18:	e9 f4 f5 ff ff       	jmp    80107411 <alltraps>

80107e1d <vector108>:
.globl vector108
vector108:
  pushl $0
80107e1d:	6a 00                	push   $0x0
  pushl $108
80107e1f:	6a 6c                	push   $0x6c
  jmp alltraps
80107e21:	e9 eb f5 ff ff       	jmp    80107411 <alltraps>

80107e26 <vector109>:
.globl vector109
vector109:
  pushl $0
80107e26:	6a 00                	push   $0x0
  pushl $109
80107e28:	6a 6d                	push   $0x6d
  jmp alltraps
80107e2a:	e9 e2 f5 ff ff       	jmp    80107411 <alltraps>

80107e2f <vector110>:
.globl vector110
vector110:
  pushl $0
80107e2f:	6a 00                	push   $0x0
  pushl $110
80107e31:	6a 6e                	push   $0x6e
  jmp alltraps
80107e33:	e9 d9 f5 ff ff       	jmp    80107411 <alltraps>

80107e38 <vector111>:
.globl vector111
vector111:
  pushl $0
80107e38:	6a 00                	push   $0x0
  pushl $111
80107e3a:	6a 6f                	push   $0x6f
  jmp alltraps
80107e3c:	e9 d0 f5 ff ff       	jmp    80107411 <alltraps>

80107e41 <vector112>:
.globl vector112
vector112:
  pushl $0
80107e41:	6a 00                	push   $0x0
  pushl $112
80107e43:	6a 70                	push   $0x70
  jmp alltraps
80107e45:	e9 c7 f5 ff ff       	jmp    80107411 <alltraps>

80107e4a <vector113>:
.globl vector113
vector113:
  pushl $0
80107e4a:	6a 00                	push   $0x0
  pushl $113
80107e4c:	6a 71                	push   $0x71
  jmp alltraps
80107e4e:	e9 be f5 ff ff       	jmp    80107411 <alltraps>

80107e53 <vector114>:
.globl vector114
vector114:
  pushl $0
80107e53:	6a 00                	push   $0x0
  pushl $114
80107e55:	6a 72                	push   $0x72
  jmp alltraps
80107e57:	e9 b5 f5 ff ff       	jmp    80107411 <alltraps>

80107e5c <vector115>:
.globl vector115
vector115:
  pushl $0
80107e5c:	6a 00                	push   $0x0
  pushl $115
80107e5e:	6a 73                	push   $0x73
  jmp alltraps
80107e60:	e9 ac f5 ff ff       	jmp    80107411 <alltraps>

80107e65 <vector116>:
.globl vector116
vector116:
  pushl $0
80107e65:	6a 00                	push   $0x0
  pushl $116
80107e67:	6a 74                	push   $0x74
  jmp alltraps
80107e69:	e9 a3 f5 ff ff       	jmp    80107411 <alltraps>

80107e6e <vector117>:
.globl vector117
vector117:
  pushl $0
80107e6e:	6a 00                	push   $0x0
  pushl $117
80107e70:	6a 75                	push   $0x75
  jmp alltraps
80107e72:	e9 9a f5 ff ff       	jmp    80107411 <alltraps>

80107e77 <vector118>:
.globl vector118
vector118:
  pushl $0
80107e77:	6a 00                	push   $0x0
  pushl $118
80107e79:	6a 76                	push   $0x76
  jmp alltraps
80107e7b:	e9 91 f5 ff ff       	jmp    80107411 <alltraps>

80107e80 <vector119>:
.globl vector119
vector119:
  pushl $0
80107e80:	6a 00                	push   $0x0
  pushl $119
80107e82:	6a 77                	push   $0x77
  jmp alltraps
80107e84:	e9 88 f5 ff ff       	jmp    80107411 <alltraps>

80107e89 <vector120>:
.globl vector120
vector120:
  pushl $0
80107e89:	6a 00                	push   $0x0
  pushl $120
80107e8b:	6a 78                	push   $0x78
  jmp alltraps
80107e8d:	e9 7f f5 ff ff       	jmp    80107411 <alltraps>

80107e92 <vector121>:
.globl vector121
vector121:
  pushl $0
80107e92:	6a 00                	push   $0x0
  pushl $121
80107e94:	6a 79                	push   $0x79
  jmp alltraps
80107e96:	e9 76 f5 ff ff       	jmp    80107411 <alltraps>

80107e9b <vector122>:
.globl vector122
vector122:
  pushl $0
80107e9b:	6a 00                	push   $0x0
  pushl $122
80107e9d:	6a 7a                	push   $0x7a
  jmp alltraps
80107e9f:	e9 6d f5 ff ff       	jmp    80107411 <alltraps>

80107ea4 <vector123>:
.globl vector123
vector123:
  pushl $0
80107ea4:	6a 00                	push   $0x0
  pushl $123
80107ea6:	6a 7b                	push   $0x7b
  jmp alltraps
80107ea8:	e9 64 f5 ff ff       	jmp    80107411 <alltraps>

80107ead <vector124>:
.globl vector124
vector124:
  pushl $0
80107ead:	6a 00                	push   $0x0
  pushl $124
80107eaf:	6a 7c                	push   $0x7c
  jmp alltraps
80107eb1:	e9 5b f5 ff ff       	jmp    80107411 <alltraps>

80107eb6 <vector125>:
.globl vector125
vector125:
  pushl $0
80107eb6:	6a 00                	push   $0x0
  pushl $125
80107eb8:	6a 7d                	push   $0x7d
  jmp alltraps
80107eba:	e9 52 f5 ff ff       	jmp    80107411 <alltraps>

80107ebf <vector126>:
.globl vector126
vector126:
  pushl $0
80107ebf:	6a 00                	push   $0x0
  pushl $126
80107ec1:	6a 7e                	push   $0x7e
  jmp alltraps
80107ec3:	e9 49 f5 ff ff       	jmp    80107411 <alltraps>

80107ec8 <vector127>:
.globl vector127
vector127:
  pushl $0
80107ec8:	6a 00                	push   $0x0
  pushl $127
80107eca:	6a 7f                	push   $0x7f
  jmp alltraps
80107ecc:	e9 40 f5 ff ff       	jmp    80107411 <alltraps>

80107ed1 <vector128>:
.globl vector128
vector128:
  pushl $0
80107ed1:	6a 00                	push   $0x0
  pushl $128
80107ed3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107ed8:	e9 34 f5 ff ff       	jmp    80107411 <alltraps>

80107edd <vector129>:
.globl vector129
vector129:
  pushl $0
80107edd:	6a 00                	push   $0x0
  pushl $129
80107edf:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107ee4:	e9 28 f5 ff ff       	jmp    80107411 <alltraps>

80107ee9 <vector130>:
.globl vector130
vector130:
  pushl $0
80107ee9:	6a 00                	push   $0x0
  pushl $130
80107eeb:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107ef0:	e9 1c f5 ff ff       	jmp    80107411 <alltraps>

80107ef5 <vector131>:
.globl vector131
vector131:
  pushl $0
80107ef5:	6a 00                	push   $0x0
  pushl $131
80107ef7:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107efc:	e9 10 f5 ff ff       	jmp    80107411 <alltraps>

80107f01 <vector132>:
.globl vector132
vector132:
  pushl $0
80107f01:	6a 00                	push   $0x0
  pushl $132
80107f03:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107f08:	e9 04 f5 ff ff       	jmp    80107411 <alltraps>

80107f0d <vector133>:
.globl vector133
vector133:
  pushl $0
80107f0d:	6a 00                	push   $0x0
  pushl $133
80107f0f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107f14:	e9 f8 f4 ff ff       	jmp    80107411 <alltraps>

80107f19 <vector134>:
.globl vector134
vector134:
  pushl $0
80107f19:	6a 00                	push   $0x0
  pushl $134
80107f1b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107f20:	e9 ec f4 ff ff       	jmp    80107411 <alltraps>

80107f25 <vector135>:
.globl vector135
vector135:
  pushl $0
80107f25:	6a 00                	push   $0x0
  pushl $135
80107f27:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107f2c:	e9 e0 f4 ff ff       	jmp    80107411 <alltraps>

80107f31 <vector136>:
.globl vector136
vector136:
  pushl $0
80107f31:	6a 00                	push   $0x0
  pushl $136
80107f33:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107f38:	e9 d4 f4 ff ff       	jmp    80107411 <alltraps>

80107f3d <vector137>:
.globl vector137
vector137:
  pushl $0
80107f3d:	6a 00                	push   $0x0
  pushl $137
80107f3f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107f44:	e9 c8 f4 ff ff       	jmp    80107411 <alltraps>

80107f49 <vector138>:
.globl vector138
vector138:
  pushl $0
80107f49:	6a 00                	push   $0x0
  pushl $138
80107f4b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107f50:	e9 bc f4 ff ff       	jmp    80107411 <alltraps>

80107f55 <vector139>:
.globl vector139
vector139:
  pushl $0
80107f55:	6a 00                	push   $0x0
  pushl $139
80107f57:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107f5c:	e9 b0 f4 ff ff       	jmp    80107411 <alltraps>

80107f61 <vector140>:
.globl vector140
vector140:
  pushl $0
80107f61:	6a 00                	push   $0x0
  pushl $140
80107f63:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107f68:	e9 a4 f4 ff ff       	jmp    80107411 <alltraps>

80107f6d <vector141>:
.globl vector141
vector141:
  pushl $0
80107f6d:	6a 00                	push   $0x0
  pushl $141
80107f6f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107f74:	e9 98 f4 ff ff       	jmp    80107411 <alltraps>

80107f79 <vector142>:
.globl vector142
vector142:
  pushl $0
80107f79:	6a 00                	push   $0x0
  pushl $142
80107f7b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107f80:	e9 8c f4 ff ff       	jmp    80107411 <alltraps>

80107f85 <vector143>:
.globl vector143
vector143:
  pushl $0
80107f85:	6a 00                	push   $0x0
  pushl $143
80107f87:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107f8c:	e9 80 f4 ff ff       	jmp    80107411 <alltraps>

80107f91 <vector144>:
.globl vector144
vector144:
  pushl $0
80107f91:	6a 00                	push   $0x0
  pushl $144
80107f93:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107f98:	e9 74 f4 ff ff       	jmp    80107411 <alltraps>

80107f9d <vector145>:
.globl vector145
vector145:
  pushl $0
80107f9d:	6a 00                	push   $0x0
  pushl $145
80107f9f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107fa4:	e9 68 f4 ff ff       	jmp    80107411 <alltraps>

80107fa9 <vector146>:
.globl vector146
vector146:
  pushl $0
80107fa9:	6a 00                	push   $0x0
  pushl $146
80107fab:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107fb0:	e9 5c f4 ff ff       	jmp    80107411 <alltraps>

80107fb5 <vector147>:
.globl vector147
vector147:
  pushl $0
80107fb5:	6a 00                	push   $0x0
  pushl $147
80107fb7:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107fbc:	e9 50 f4 ff ff       	jmp    80107411 <alltraps>

80107fc1 <vector148>:
.globl vector148
vector148:
  pushl $0
80107fc1:	6a 00                	push   $0x0
  pushl $148
80107fc3:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107fc8:	e9 44 f4 ff ff       	jmp    80107411 <alltraps>

80107fcd <vector149>:
.globl vector149
vector149:
  pushl $0
80107fcd:	6a 00                	push   $0x0
  pushl $149
80107fcf:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107fd4:	e9 38 f4 ff ff       	jmp    80107411 <alltraps>

80107fd9 <vector150>:
.globl vector150
vector150:
  pushl $0
80107fd9:	6a 00                	push   $0x0
  pushl $150
80107fdb:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107fe0:	e9 2c f4 ff ff       	jmp    80107411 <alltraps>

80107fe5 <vector151>:
.globl vector151
vector151:
  pushl $0
80107fe5:	6a 00                	push   $0x0
  pushl $151
80107fe7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107fec:	e9 20 f4 ff ff       	jmp    80107411 <alltraps>

80107ff1 <vector152>:
.globl vector152
vector152:
  pushl $0
80107ff1:	6a 00                	push   $0x0
  pushl $152
80107ff3:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107ff8:	e9 14 f4 ff ff       	jmp    80107411 <alltraps>

80107ffd <vector153>:
.globl vector153
vector153:
  pushl $0
80107ffd:	6a 00                	push   $0x0
  pushl $153
80107fff:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108004:	e9 08 f4 ff ff       	jmp    80107411 <alltraps>

80108009 <vector154>:
.globl vector154
vector154:
  pushl $0
80108009:	6a 00                	push   $0x0
  pushl $154
8010800b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108010:	e9 fc f3 ff ff       	jmp    80107411 <alltraps>

80108015 <vector155>:
.globl vector155
vector155:
  pushl $0
80108015:	6a 00                	push   $0x0
  pushl $155
80108017:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010801c:	e9 f0 f3 ff ff       	jmp    80107411 <alltraps>

80108021 <vector156>:
.globl vector156
vector156:
  pushl $0
80108021:	6a 00                	push   $0x0
  pushl $156
80108023:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108028:	e9 e4 f3 ff ff       	jmp    80107411 <alltraps>

8010802d <vector157>:
.globl vector157
vector157:
  pushl $0
8010802d:	6a 00                	push   $0x0
  pushl $157
8010802f:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108034:	e9 d8 f3 ff ff       	jmp    80107411 <alltraps>

80108039 <vector158>:
.globl vector158
vector158:
  pushl $0
80108039:	6a 00                	push   $0x0
  pushl $158
8010803b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108040:	e9 cc f3 ff ff       	jmp    80107411 <alltraps>

80108045 <vector159>:
.globl vector159
vector159:
  pushl $0
80108045:	6a 00                	push   $0x0
  pushl $159
80108047:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010804c:	e9 c0 f3 ff ff       	jmp    80107411 <alltraps>

80108051 <vector160>:
.globl vector160
vector160:
  pushl $0
80108051:	6a 00                	push   $0x0
  pushl $160
80108053:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108058:	e9 b4 f3 ff ff       	jmp    80107411 <alltraps>

8010805d <vector161>:
.globl vector161
vector161:
  pushl $0
8010805d:	6a 00                	push   $0x0
  pushl $161
8010805f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108064:	e9 a8 f3 ff ff       	jmp    80107411 <alltraps>

80108069 <vector162>:
.globl vector162
vector162:
  pushl $0
80108069:	6a 00                	push   $0x0
  pushl $162
8010806b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108070:	e9 9c f3 ff ff       	jmp    80107411 <alltraps>

80108075 <vector163>:
.globl vector163
vector163:
  pushl $0
80108075:	6a 00                	push   $0x0
  pushl $163
80108077:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010807c:	e9 90 f3 ff ff       	jmp    80107411 <alltraps>

80108081 <vector164>:
.globl vector164
vector164:
  pushl $0
80108081:	6a 00                	push   $0x0
  pushl $164
80108083:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108088:	e9 84 f3 ff ff       	jmp    80107411 <alltraps>

8010808d <vector165>:
.globl vector165
vector165:
  pushl $0
8010808d:	6a 00                	push   $0x0
  pushl $165
8010808f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108094:	e9 78 f3 ff ff       	jmp    80107411 <alltraps>

80108099 <vector166>:
.globl vector166
vector166:
  pushl $0
80108099:	6a 00                	push   $0x0
  pushl $166
8010809b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801080a0:	e9 6c f3 ff ff       	jmp    80107411 <alltraps>

801080a5 <vector167>:
.globl vector167
vector167:
  pushl $0
801080a5:	6a 00                	push   $0x0
  pushl $167
801080a7:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801080ac:	e9 60 f3 ff ff       	jmp    80107411 <alltraps>

801080b1 <vector168>:
.globl vector168
vector168:
  pushl $0
801080b1:	6a 00                	push   $0x0
  pushl $168
801080b3:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801080b8:	e9 54 f3 ff ff       	jmp    80107411 <alltraps>

801080bd <vector169>:
.globl vector169
vector169:
  pushl $0
801080bd:	6a 00                	push   $0x0
  pushl $169
801080bf:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801080c4:	e9 48 f3 ff ff       	jmp    80107411 <alltraps>

801080c9 <vector170>:
.globl vector170
vector170:
  pushl $0
801080c9:	6a 00                	push   $0x0
  pushl $170
801080cb:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801080d0:	e9 3c f3 ff ff       	jmp    80107411 <alltraps>

801080d5 <vector171>:
.globl vector171
vector171:
  pushl $0
801080d5:	6a 00                	push   $0x0
  pushl $171
801080d7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801080dc:	e9 30 f3 ff ff       	jmp    80107411 <alltraps>

801080e1 <vector172>:
.globl vector172
vector172:
  pushl $0
801080e1:	6a 00                	push   $0x0
  pushl $172
801080e3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801080e8:	e9 24 f3 ff ff       	jmp    80107411 <alltraps>

801080ed <vector173>:
.globl vector173
vector173:
  pushl $0
801080ed:	6a 00                	push   $0x0
  pushl $173
801080ef:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801080f4:	e9 18 f3 ff ff       	jmp    80107411 <alltraps>

801080f9 <vector174>:
.globl vector174
vector174:
  pushl $0
801080f9:	6a 00                	push   $0x0
  pushl $174
801080fb:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108100:	e9 0c f3 ff ff       	jmp    80107411 <alltraps>

80108105 <vector175>:
.globl vector175
vector175:
  pushl $0
80108105:	6a 00                	push   $0x0
  pushl $175
80108107:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010810c:	e9 00 f3 ff ff       	jmp    80107411 <alltraps>

80108111 <vector176>:
.globl vector176
vector176:
  pushl $0
80108111:	6a 00                	push   $0x0
  pushl $176
80108113:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108118:	e9 f4 f2 ff ff       	jmp    80107411 <alltraps>

8010811d <vector177>:
.globl vector177
vector177:
  pushl $0
8010811d:	6a 00                	push   $0x0
  pushl $177
8010811f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108124:	e9 e8 f2 ff ff       	jmp    80107411 <alltraps>

80108129 <vector178>:
.globl vector178
vector178:
  pushl $0
80108129:	6a 00                	push   $0x0
  pushl $178
8010812b:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108130:	e9 dc f2 ff ff       	jmp    80107411 <alltraps>

80108135 <vector179>:
.globl vector179
vector179:
  pushl $0
80108135:	6a 00                	push   $0x0
  pushl $179
80108137:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010813c:	e9 d0 f2 ff ff       	jmp    80107411 <alltraps>

80108141 <vector180>:
.globl vector180
vector180:
  pushl $0
80108141:	6a 00                	push   $0x0
  pushl $180
80108143:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108148:	e9 c4 f2 ff ff       	jmp    80107411 <alltraps>

8010814d <vector181>:
.globl vector181
vector181:
  pushl $0
8010814d:	6a 00                	push   $0x0
  pushl $181
8010814f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108154:	e9 b8 f2 ff ff       	jmp    80107411 <alltraps>

80108159 <vector182>:
.globl vector182
vector182:
  pushl $0
80108159:	6a 00                	push   $0x0
  pushl $182
8010815b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108160:	e9 ac f2 ff ff       	jmp    80107411 <alltraps>

80108165 <vector183>:
.globl vector183
vector183:
  pushl $0
80108165:	6a 00                	push   $0x0
  pushl $183
80108167:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010816c:	e9 a0 f2 ff ff       	jmp    80107411 <alltraps>

80108171 <vector184>:
.globl vector184
vector184:
  pushl $0
80108171:	6a 00                	push   $0x0
  pushl $184
80108173:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108178:	e9 94 f2 ff ff       	jmp    80107411 <alltraps>

8010817d <vector185>:
.globl vector185
vector185:
  pushl $0
8010817d:	6a 00                	push   $0x0
  pushl $185
8010817f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108184:	e9 88 f2 ff ff       	jmp    80107411 <alltraps>

80108189 <vector186>:
.globl vector186
vector186:
  pushl $0
80108189:	6a 00                	push   $0x0
  pushl $186
8010818b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108190:	e9 7c f2 ff ff       	jmp    80107411 <alltraps>

80108195 <vector187>:
.globl vector187
vector187:
  pushl $0
80108195:	6a 00                	push   $0x0
  pushl $187
80108197:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010819c:	e9 70 f2 ff ff       	jmp    80107411 <alltraps>

801081a1 <vector188>:
.globl vector188
vector188:
  pushl $0
801081a1:	6a 00                	push   $0x0
  pushl $188
801081a3:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801081a8:	e9 64 f2 ff ff       	jmp    80107411 <alltraps>

801081ad <vector189>:
.globl vector189
vector189:
  pushl $0
801081ad:	6a 00                	push   $0x0
  pushl $189
801081af:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801081b4:	e9 58 f2 ff ff       	jmp    80107411 <alltraps>

801081b9 <vector190>:
.globl vector190
vector190:
  pushl $0
801081b9:	6a 00                	push   $0x0
  pushl $190
801081bb:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801081c0:	e9 4c f2 ff ff       	jmp    80107411 <alltraps>

801081c5 <vector191>:
.globl vector191
vector191:
  pushl $0
801081c5:	6a 00                	push   $0x0
  pushl $191
801081c7:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801081cc:	e9 40 f2 ff ff       	jmp    80107411 <alltraps>

801081d1 <vector192>:
.globl vector192
vector192:
  pushl $0
801081d1:	6a 00                	push   $0x0
  pushl $192
801081d3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801081d8:	e9 34 f2 ff ff       	jmp    80107411 <alltraps>

801081dd <vector193>:
.globl vector193
vector193:
  pushl $0
801081dd:	6a 00                	push   $0x0
  pushl $193
801081df:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801081e4:	e9 28 f2 ff ff       	jmp    80107411 <alltraps>

801081e9 <vector194>:
.globl vector194
vector194:
  pushl $0
801081e9:	6a 00                	push   $0x0
  pushl $194
801081eb:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801081f0:	e9 1c f2 ff ff       	jmp    80107411 <alltraps>

801081f5 <vector195>:
.globl vector195
vector195:
  pushl $0
801081f5:	6a 00                	push   $0x0
  pushl $195
801081f7:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801081fc:	e9 10 f2 ff ff       	jmp    80107411 <alltraps>

80108201 <vector196>:
.globl vector196
vector196:
  pushl $0
80108201:	6a 00                	push   $0x0
  pushl $196
80108203:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108208:	e9 04 f2 ff ff       	jmp    80107411 <alltraps>

8010820d <vector197>:
.globl vector197
vector197:
  pushl $0
8010820d:	6a 00                	push   $0x0
  pushl $197
8010820f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108214:	e9 f8 f1 ff ff       	jmp    80107411 <alltraps>

80108219 <vector198>:
.globl vector198
vector198:
  pushl $0
80108219:	6a 00                	push   $0x0
  pushl $198
8010821b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108220:	e9 ec f1 ff ff       	jmp    80107411 <alltraps>

80108225 <vector199>:
.globl vector199
vector199:
  pushl $0
80108225:	6a 00                	push   $0x0
  pushl $199
80108227:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010822c:	e9 e0 f1 ff ff       	jmp    80107411 <alltraps>

80108231 <vector200>:
.globl vector200
vector200:
  pushl $0
80108231:	6a 00                	push   $0x0
  pushl $200
80108233:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108238:	e9 d4 f1 ff ff       	jmp    80107411 <alltraps>

8010823d <vector201>:
.globl vector201
vector201:
  pushl $0
8010823d:	6a 00                	push   $0x0
  pushl $201
8010823f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108244:	e9 c8 f1 ff ff       	jmp    80107411 <alltraps>

80108249 <vector202>:
.globl vector202
vector202:
  pushl $0
80108249:	6a 00                	push   $0x0
  pushl $202
8010824b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108250:	e9 bc f1 ff ff       	jmp    80107411 <alltraps>

80108255 <vector203>:
.globl vector203
vector203:
  pushl $0
80108255:	6a 00                	push   $0x0
  pushl $203
80108257:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010825c:	e9 b0 f1 ff ff       	jmp    80107411 <alltraps>

80108261 <vector204>:
.globl vector204
vector204:
  pushl $0
80108261:	6a 00                	push   $0x0
  pushl $204
80108263:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108268:	e9 a4 f1 ff ff       	jmp    80107411 <alltraps>

8010826d <vector205>:
.globl vector205
vector205:
  pushl $0
8010826d:	6a 00                	push   $0x0
  pushl $205
8010826f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108274:	e9 98 f1 ff ff       	jmp    80107411 <alltraps>

80108279 <vector206>:
.globl vector206
vector206:
  pushl $0
80108279:	6a 00                	push   $0x0
  pushl $206
8010827b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108280:	e9 8c f1 ff ff       	jmp    80107411 <alltraps>

80108285 <vector207>:
.globl vector207
vector207:
  pushl $0
80108285:	6a 00                	push   $0x0
  pushl $207
80108287:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010828c:	e9 80 f1 ff ff       	jmp    80107411 <alltraps>

80108291 <vector208>:
.globl vector208
vector208:
  pushl $0
80108291:	6a 00                	push   $0x0
  pushl $208
80108293:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108298:	e9 74 f1 ff ff       	jmp    80107411 <alltraps>

8010829d <vector209>:
.globl vector209
vector209:
  pushl $0
8010829d:	6a 00                	push   $0x0
  pushl $209
8010829f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801082a4:	e9 68 f1 ff ff       	jmp    80107411 <alltraps>

801082a9 <vector210>:
.globl vector210
vector210:
  pushl $0
801082a9:	6a 00                	push   $0x0
  pushl $210
801082ab:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801082b0:	e9 5c f1 ff ff       	jmp    80107411 <alltraps>

801082b5 <vector211>:
.globl vector211
vector211:
  pushl $0
801082b5:	6a 00                	push   $0x0
  pushl $211
801082b7:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801082bc:	e9 50 f1 ff ff       	jmp    80107411 <alltraps>

801082c1 <vector212>:
.globl vector212
vector212:
  pushl $0
801082c1:	6a 00                	push   $0x0
  pushl $212
801082c3:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801082c8:	e9 44 f1 ff ff       	jmp    80107411 <alltraps>

801082cd <vector213>:
.globl vector213
vector213:
  pushl $0
801082cd:	6a 00                	push   $0x0
  pushl $213
801082cf:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801082d4:	e9 38 f1 ff ff       	jmp    80107411 <alltraps>

801082d9 <vector214>:
.globl vector214
vector214:
  pushl $0
801082d9:	6a 00                	push   $0x0
  pushl $214
801082db:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801082e0:	e9 2c f1 ff ff       	jmp    80107411 <alltraps>

801082e5 <vector215>:
.globl vector215
vector215:
  pushl $0
801082e5:	6a 00                	push   $0x0
  pushl $215
801082e7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801082ec:	e9 20 f1 ff ff       	jmp    80107411 <alltraps>

801082f1 <vector216>:
.globl vector216
vector216:
  pushl $0
801082f1:	6a 00                	push   $0x0
  pushl $216
801082f3:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801082f8:	e9 14 f1 ff ff       	jmp    80107411 <alltraps>

801082fd <vector217>:
.globl vector217
vector217:
  pushl $0
801082fd:	6a 00                	push   $0x0
  pushl $217
801082ff:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108304:	e9 08 f1 ff ff       	jmp    80107411 <alltraps>

80108309 <vector218>:
.globl vector218
vector218:
  pushl $0
80108309:	6a 00                	push   $0x0
  pushl $218
8010830b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108310:	e9 fc f0 ff ff       	jmp    80107411 <alltraps>

80108315 <vector219>:
.globl vector219
vector219:
  pushl $0
80108315:	6a 00                	push   $0x0
  pushl $219
80108317:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010831c:	e9 f0 f0 ff ff       	jmp    80107411 <alltraps>

80108321 <vector220>:
.globl vector220
vector220:
  pushl $0
80108321:	6a 00                	push   $0x0
  pushl $220
80108323:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108328:	e9 e4 f0 ff ff       	jmp    80107411 <alltraps>

8010832d <vector221>:
.globl vector221
vector221:
  pushl $0
8010832d:	6a 00                	push   $0x0
  pushl $221
8010832f:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108334:	e9 d8 f0 ff ff       	jmp    80107411 <alltraps>

80108339 <vector222>:
.globl vector222
vector222:
  pushl $0
80108339:	6a 00                	push   $0x0
  pushl $222
8010833b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108340:	e9 cc f0 ff ff       	jmp    80107411 <alltraps>

80108345 <vector223>:
.globl vector223
vector223:
  pushl $0
80108345:	6a 00                	push   $0x0
  pushl $223
80108347:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010834c:	e9 c0 f0 ff ff       	jmp    80107411 <alltraps>

80108351 <vector224>:
.globl vector224
vector224:
  pushl $0
80108351:	6a 00                	push   $0x0
  pushl $224
80108353:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108358:	e9 b4 f0 ff ff       	jmp    80107411 <alltraps>

8010835d <vector225>:
.globl vector225
vector225:
  pushl $0
8010835d:	6a 00                	push   $0x0
  pushl $225
8010835f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108364:	e9 a8 f0 ff ff       	jmp    80107411 <alltraps>

80108369 <vector226>:
.globl vector226
vector226:
  pushl $0
80108369:	6a 00                	push   $0x0
  pushl $226
8010836b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108370:	e9 9c f0 ff ff       	jmp    80107411 <alltraps>

80108375 <vector227>:
.globl vector227
vector227:
  pushl $0
80108375:	6a 00                	push   $0x0
  pushl $227
80108377:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
8010837c:	e9 90 f0 ff ff       	jmp    80107411 <alltraps>

80108381 <vector228>:
.globl vector228
vector228:
  pushl $0
80108381:	6a 00                	push   $0x0
  pushl $228
80108383:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108388:	e9 84 f0 ff ff       	jmp    80107411 <alltraps>

8010838d <vector229>:
.globl vector229
vector229:
  pushl $0
8010838d:	6a 00                	push   $0x0
  pushl $229
8010838f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108394:	e9 78 f0 ff ff       	jmp    80107411 <alltraps>

80108399 <vector230>:
.globl vector230
vector230:
  pushl $0
80108399:	6a 00                	push   $0x0
  pushl $230
8010839b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801083a0:	e9 6c f0 ff ff       	jmp    80107411 <alltraps>

801083a5 <vector231>:
.globl vector231
vector231:
  pushl $0
801083a5:	6a 00                	push   $0x0
  pushl $231
801083a7:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801083ac:	e9 60 f0 ff ff       	jmp    80107411 <alltraps>

801083b1 <vector232>:
.globl vector232
vector232:
  pushl $0
801083b1:	6a 00                	push   $0x0
  pushl $232
801083b3:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801083b8:	e9 54 f0 ff ff       	jmp    80107411 <alltraps>

801083bd <vector233>:
.globl vector233
vector233:
  pushl $0
801083bd:	6a 00                	push   $0x0
  pushl $233
801083bf:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801083c4:	e9 48 f0 ff ff       	jmp    80107411 <alltraps>

801083c9 <vector234>:
.globl vector234
vector234:
  pushl $0
801083c9:	6a 00                	push   $0x0
  pushl $234
801083cb:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801083d0:	e9 3c f0 ff ff       	jmp    80107411 <alltraps>

801083d5 <vector235>:
.globl vector235
vector235:
  pushl $0
801083d5:	6a 00                	push   $0x0
  pushl $235
801083d7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801083dc:	e9 30 f0 ff ff       	jmp    80107411 <alltraps>

801083e1 <vector236>:
.globl vector236
vector236:
  pushl $0
801083e1:	6a 00                	push   $0x0
  pushl $236
801083e3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801083e8:	e9 24 f0 ff ff       	jmp    80107411 <alltraps>

801083ed <vector237>:
.globl vector237
vector237:
  pushl $0
801083ed:	6a 00                	push   $0x0
  pushl $237
801083ef:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801083f4:	e9 18 f0 ff ff       	jmp    80107411 <alltraps>

801083f9 <vector238>:
.globl vector238
vector238:
  pushl $0
801083f9:	6a 00                	push   $0x0
  pushl $238
801083fb:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108400:	e9 0c f0 ff ff       	jmp    80107411 <alltraps>

80108405 <vector239>:
.globl vector239
vector239:
  pushl $0
80108405:	6a 00                	push   $0x0
  pushl $239
80108407:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010840c:	e9 00 f0 ff ff       	jmp    80107411 <alltraps>

80108411 <vector240>:
.globl vector240
vector240:
  pushl $0
80108411:	6a 00                	push   $0x0
  pushl $240
80108413:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108418:	e9 f4 ef ff ff       	jmp    80107411 <alltraps>

8010841d <vector241>:
.globl vector241
vector241:
  pushl $0
8010841d:	6a 00                	push   $0x0
  pushl $241
8010841f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108424:	e9 e8 ef ff ff       	jmp    80107411 <alltraps>

80108429 <vector242>:
.globl vector242
vector242:
  pushl $0
80108429:	6a 00                	push   $0x0
  pushl $242
8010842b:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108430:	e9 dc ef ff ff       	jmp    80107411 <alltraps>

80108435 <vector243>:
.globl vector243
vector243:
  pushl $0
80108435:	6a 00                	push   $0x0
  pushl $243
80108437:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010843c:	e9 d0 ef ff ff       	jmp    80107411 <alltraps>

80108441 <vector244>:
.globl vector244
vector244:
  pushl $0
80108441:	6a 00                	push   $0x0
  pushl $244
80108443:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108448:	e9 c4 ef ff ff       	jmp    80107411 <alltraps>

8010844d <vector245>:
.globl vector245
vector245:
  pushl $0
8010844d:	6a 00                	push   $0x0
  pushl $245
8010844f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108454:	e9 b8 ef ff ff       	jmp    80107411 <alltraps>

80108459 <vector246>:
.globl vector246
vector246:
  pushl $0
80108459:	6a 00                	push   $0x0
  pushl $246
8010845b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108460:	e9 ac ef ff ff       	jmp    80107411 <alltraps>

80108465 <vector247>:
.globl vector247
vector247:
  pushl $0
80108465:	6a 00                	push   $0x0
  pushl $247
80108467:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010846c:	e9 a0 ef ff ff       	jmp    80107411 <alltraps>

80108471 <vector248>:
.globl vector248
vector248:
  pushl $0
80108471:	6a 00                	push   $0x0
  pushl $248
80108473:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108478:	e9 94 ef ff ff       	jmp    80107411 <alltraps>

8010847d <vector249>:
.globl vector249
vector249:
  pushl $0
8010847d:	6a 00                	push   $0x0
  pushl $249
8010847f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108484:	e9 88 ef ff ff       	jmp    80107411 <alltraps>

80108489 <vector250>:
.globl vector250
vector250:
  pushl $0
80108489:	6a 00                	push   $0x0
  pushl $250
8010848b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108490:	e9 7c ef ff ff       	jmp    80107411 <alltraps>

80108495 <vector251>:
.globl vector251
vector251:
  pushl $0
80108495:	6a 00                	push   $0x0
  pushl $251
80108497:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010849c:	e9 70 ef ff ff       	jmp    80107411 <alltraps>

801084a1 <vector252>:
.globl vector252
vector252:
  pushl $0
801084a1:	6a 00                	push   $0x0
  pushl $252
801084a3:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801084a8:	e9 64 ef ff ff       	jmp    80107411 <alltraps>

801084ad <vector253>:
.globl vector253
vector253:
  pushl $0
801084ad:	6a 00                	push   $0x0
  pushl $253
801084af:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801084b4:	e9 58 ef ff ff       	jmp    80107411 <alltraps>

801084b9 <vector254>:
.globl vector254
vector254:
  pushl $0
801084b9:	6a 00                	push   $0x0
  pushl $254
801084bb:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801084c0:	e9 4c ef ff ff       	jmp    80107411 <alltraps>

801084c5 <vector255>:
.globl vector255
vector255:
  pushl $0
801084c5:	6a 00                	push   $0x0
  pushl $255
801084c7:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801084cc:	e9 40 ef ff ff       	jmp    80107411 <alltraps>

801084d1 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801084d1:	55                   	push   %ebp
801084d2:	89 e5                	mov    %esp,%ebp
801084d4:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801084d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801084da:	83 e8 01             	sub    $0x1,%eax
801084dd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801084e1:	8b 45 08             	mov    0x8(%ebp),%eax
801084e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801084e8:	8b 45 08             	mov    0x8(%ebp),%eax
801084eb:	c1 e8 10             	shr    $0x10,%eax
801084ee:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801084f2:	8d 45 fa             	lea    -0x6(%ebp),%eax
801084f5:	0f 01 10             	lgdtl  (%eax)
}
801084f8:	90                   	nop
801084f9:	c9                   	leave  
801084fa:	c3                   	ret    

801084fb <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801084fb:	55                   	push   %ebp
801084fc:	89 e5                	mov    %esp,%ebp
801084fe:	83 ec 04             	sub    $0x4,%esp
80108501:	8b 45 08             	mov    0x8(%ebp),%eax
80108504:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108508:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010850c:	0f 00 d8             	ltr    %ax
}
8010850f:	90                   	nop
80108510:	c9                   	leave  
80108511:	c3                   	ret    

80108512 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108512:	55                   	push   %ebp
80108513:	89 e5                	mov    %esp,%ebp
80108515:	83 ec 04             	sub    $0x4,%esp
80108518:	8b 45 08             	mov    0x8(%ebp),%eax
8010851b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010851f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108523:	8e e8                	mov    %eax,%gs
}
80108525:	90                   	nop
80108526:	c9                   	leave  
80108527:	c3                   	ret    

80108528 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108528:	55                   	push   %ebp
80108529:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010852b:	8b 45 08             	mov    0x8(%ebp),%eax
8010852e:	0f 22 d8             	mov    %eax,%cr3
}
80108531:	90                   	nop
80108532:	5d                   	pop    %ebp
80108533:	c3                   	ret    

80108534 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108534:	55                   	push   %ebp
80108535:	89 e5                	mov    %esp,%ebp
80108537:	8b 45 08             	mov    0x8(%ebp),%eax
8010853a:	05 00 00 00 80       	add    $0x80000000,%eax
8010853f:	5d                   	pop    %ebp
80108540:	c3                   	ret    

80108541 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108541:	55                   	push   %ebp
80108542:	89 e5                	mov    %esp,%ebp
80108544:	8b 45 08             	mov    0x8(%ebp),%eax
80108547:	05 00 00 00 80       	add    $0x80000000,%eax
8010854c:	5d                   	pop    %ebp
8010854d:	c3                   	ret    

8010854e <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010854e:	55                   	push   %ebp
8010854f:	89 e5                	mov    %esp,%ebp
80108551:	53                   	push   %ebx
80108552:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108555:	e8 17 ab ff ff       	call   80103071 <cpunum>
8010855a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108560:	05 80 33 11 80       	add    $0x80113380,%eax
80108565:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010856b:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108574:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010857a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010857d:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108584:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108588:	83 e2 f0             	and    $0xfffffff0,%edx
8010858b:	83 ca 0a             	or     $0xa,%edx
8010858e:	88 50 7d             	mov    %dl,0x7d(%eax)
80108591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108594:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108598:	83 ca 10             	or     $0x10,%edx
8010859b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010859e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801085a5:	83 e2 9f             	and    $0xffffff9f,%edx
801085a8:	88 50 7d             	mov    %dl,0x7d(%eax)
801085ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ae:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801085b2:	83 ca 80             	or     $0xffffff80,%edx
801085b5:	88 50 7d             	mov    %dl,0x7d(%eax)
801085b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085bb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801085bf:	83 ca 0f             	or     $0xf,%edx
801085c2:	88 50 7e             	mov    %dl,0x7e(%eax)
801085c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801085cc:	83 e2 ef             	and    $0xffffffef,%edx
801085cf:	88 50 7e             	mov    %dl,0x7e(%eax)
801085d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801085d9:	83 e2 df             	and    $0xffffffdf,%edx
801085dc:	88 50 7e             	mov    %dl,0x7e(%eax)
801085df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801085e6:	83 ca 40             	or     $0x40,%edx
801085e9:	88 50 7e             	mov    %dl,0x7e(%eax)
801085ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ef:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801085f3:	83 ca 80             	or     $0xffffff80,%edx
801085f6:	88 50 7e             	mov    %dl,0x7e(%eax)
801085f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085fc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108603:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010860a:	ff ff 
8010860c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010860f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108616:	00 00 
80108618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010861b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108625:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010862c:	83 e2 f0             	and    $0xfffffff0,%edx
8010862f:	83 ca 02             	or     $0x2,%edx
80108632:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010863b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108642:	83 ca 10             	or     $0x10,%edx
80108645:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010864b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010864e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108655:	83 e2 9f             	and    $0xffffff9f,%edx
80108658:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010865e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108661:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108668:	83 ca 80             	or     $0xffffff80,%edx
8010866b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108674:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010867b:	83 ca 0f             	or     $0xf,%edx
8010867e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108684:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108687:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010868e:	83 e2 ef             	and    $0xffffffef,%edx
80108691:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010869a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801086a1:	83 e2 df             	and    $0xffffffdf,%edx
801086a4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801086aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ad:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801086b4:	83 ca 40             	or     $0x40,%edx
801086b7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801086bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801086c7:	83 ca 80             	or     $0xffffff80,%edx
801086ca:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801086d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086d3:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801086da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086dd:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801086e4:	ff ff 
801086e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e9:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801086f0:	00 00 
801086f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f5:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801086fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086ff:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108706:	83 e2 f0             	and    $0xfffffff0,%edx
80108709:	83 ca 0a             	or     $0xa,%edx
8010870c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108715:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010871c:	83 ca 10             	or     $0x10,%edx
8010871f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108728:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010872f:	83 ca 60             	or     $0x60,%edx
80108732:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010873b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108742:	83 ca 80             	or     $0xffffff80,%edx
80108745:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010874b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108755:	83 ca 0f             	or     $0xf,%edx
80108758:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010875e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108761:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108768:	83 e2 ef             	and    $0xffffffef,%edx
8010876b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108774:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010877b:	83 e2 df             	and    $0xffffffdf,%edx
8010877e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108787:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010878e:	83 ca 40             	or     $0x40,%edx
80108791:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010879a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801087a1:	83 ca 80             	or     $0xffffff80,%edx
801087a4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801087aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ad:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801087b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b7:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801087be:	ff ff 
801087c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087c3:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801087ca:	00 00 
801087cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087cf:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801087d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801087e0:	83 e2 f0             	and    $0xfffffff0,%edx
801087e3:	83 ca 02             	or     $0x2,%edx
801087e6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801087ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ef:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801087f6:	83 ca 10             	or     $0x10,%edx
801087f9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801087ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108802:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108809:	83 ca 60             	or     $0x60,%edx
8010880c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108815:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010881c:	83 ca 80             	or     $0xffffff80,%edx
8010881f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108828:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010882f:	83 ca 0f             	or     $0xf,%edx
80108832:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010883b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108842:	83 e2 ef             	and    $0xffffffef,%edx
80108845:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010884b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108855:	83 e2 df             	and    $0xffffffdf,%edx
80108858:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010885e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108861:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108868:	83 ca 40             	or     $0x40,%edx
8010886b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108874:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010887b:	83 ca 80             	or     $0xffffff80,%edx
8010887e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108887:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010888e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108891:	05 b4 00 00 00       	add    $0xb4,%eax
80108896:	89 c3                	mov    %eax,%ebx
80108898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010889b:	05 b4 00 00 00       	add    $0xb4,%eax
801088a0:	c1 e8 10             	shr    $0x10,%eax
801088a3:	89 c2                	mov    %eax,%edx
801088a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a8:	05 b4 00 00 00       	add    $0xb4,%eax
801088ad:	c1 e8 18             	shr    $0x18,%eax
801088b0:	89 c1                	mov    %eax,%ecx
801088b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088b5:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801088bc:	00 00 
801088be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c1:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801088c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088cb:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801088d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801088db:	83 e2 f0             	and    $0xfffffff0,%edx
801088de:	83 ca 02             	or     $0x2,%edx
801088e1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801088e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ea:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801088f1:	83 ca 10             	or     $0x10,%edx
801088f4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801088fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088fd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108904:	83 e2 9f             	and    $0xffffff9f,%edx
80108907:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010890d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108910:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108917:	83 ca 80             	or     $0xffffff80,%edx
8010891a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108920:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108923:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010892a:	83 e2 f0             	and    $0xfffffff0,%edx
8010892d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108936:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010893d:	83 e2 ef             	and    $0xffffffef,%edx
80108940:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108949:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108950:	83 e2 df             	and    $0xffffffdf,%edx
80108953:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010895c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108963:	83 ca 40             	or     $0x40,%edx
80108966:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010896c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108976:	83 ca 80             	or     $0xffffff80,%edx
80108979:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010897f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108982:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010898b:	83 c0 70             	add    $0x70,%eax
8010898e:	83 ec 08             	sub    $0x8,%esp
80108991:	6a 38                	push   $0x38
80108993:	50                   	push   %eax
80108994:	e8 38 fb ff ff       	call   801084d1 <lgdt>
80108999:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010899c:	83 ec 0c             	sub    $0xc,%esp
8010899f:	6a 18                	push   $0x18
801089a1:	e8 6c fb ff ff       	call   80108512 <loadgs>
801089a6:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801089a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ac:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801089b2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801089b9:	00 00 00 00 
}
801089bd:	90                   	nop
801089be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801089c1:	c9                   	leave  
801089c2:	c3                   	ret    

801089c3 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801089c3:	55                   	push   %ebp
801089c4:	89 e5                	mov    %esp,%ebp
801089c6:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801089c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801089cc:	c1 e8 16             	shr    $0x16,%eax
801089cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801089d6:	8b 45 08             	mov    0x8(%ebp),%eax
801089d9:	01 d0                	add    %edx,%eax
801089db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801089de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089e1:	8b 00                	mov    (%eax),%eax
801089e3:	83 e0 01             	and    $0x1,%eax
801089e6:	85 c0                	test   %eax,%eax
801089e8:	74 18                	je     80108a02 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801089ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ed:	8b 00                	mov    (%eax),%eax
801089ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089f4:	50                   	push   %eax
801089f5:	e8 47 fb ff ff       	call   80108541 <p2v>
801089fa:	83 c4 04             	add    $0x4,%esp
801089fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108a00:	eb 48                	jmp    80108a4a <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108a02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108a06:	74 0e                	je     80108a16 <walkpgdir+0x53>
80108a08:	e8 fe a2 ff ff       	call   80102d0b <kalloc>
80108a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108a10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108a14:	75 07                	jne    80108a1d <walkpgdir+0x5a>
      return 0;
80108a16:	b8 00 00 00 00       	mov    $0x0,%eax
80108a1b:	eb 44                	jmp    80108a61 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108a1d:	83 ec 04             	sub    $0x4,%esp
80108a20:	68 00 10 00 00       	push   $0x1000
80108a25:	6a 00                	push   $0x0
80108a27:	ff 75 f4             	pushl  -0xc(%ebp)
80108a2a:	e8 a5 d4 ff ff       	call   80105ed4 <memset>
80108a2f:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108a32:	83 ec 0c             	sub    $0xc,%esp
80108a35:	ff 75 f4             	pushl  -0xc(%ebp)
80108a38:	e8 f7 fa ff ff       	call   80108534 <v2p>
80108a3d:	83 c4 10             	add    $0x10,%esp
80108a40:	83 c8 07             	or     $0x7,%eax
80108a43:	89 c2                	mov    %eax,%edx
80108a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a48:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a4d:	c1 e8 0c             	shr    $0xc,%eax
80108a50:	25 ff 03 00 00       	and    $0x3ff,%eax
80108a55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a5f:	01 d0                	add    %edx,%eax
}
80108a61:	c9                   	leave  
80108a62:	c3                   	ret    

80108a63 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108a63:	55                   	push   %ebp
80108a64:	89 e5                	mov    %esp,%ebp
80108a66:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108a69:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108a74:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a77:	8b 45 10             	mov    0x10(%ebp),%eax
80108a7a:	01 d0                	add    %edx,%eax
80108a7c:	83 e8 01             	sub    $0x1,%eax
80108a7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108a87:	83 ec 04             	sub    $0x4,%esp
80108a8a:	6a 01                	push   $0x1
80108a8c:	ff 75 f4             	pushl  -0xc(%ebp)
80108a8f:	ff 75 08             	pushl  0x8(%ebp)
80108a92:	e8 2c ff ff ff       	call   801089c3 <walkpgdir>
80108a97:	83 c4 10             	add    $0x10,%esp
80108a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108a9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108aa1:	75 07                	jne    80108aaa <mappages+0x47>
      return -1;
80108aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108aa8:	eb 47                	jmp    80108af1 <mappages+0x8e>
    if(*pte & PTE_P)
80108aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aad:	8b 00                	mov    (%eax),%eax
80108aaf:	83 e0 01             	and    $0x1,%eax
80108ab2:	85 c0                	test   %eax,%eax
80108ab4:	74 0d                	je     80108ac3 <mappages+0x60>
      panic("remap");
80108ab6:	83 ec 0c             	sub    $0xc,%esp
80108ab9:	68 90 9a 10 80       	push   $0x80109a90
80108abe:	e8 a3 7a ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108ac3:	8b 45 18             	mov    0x18(%ebp),%eax
80108ac6:	0b 45 14             	or     0x14(%ebp),%eax
80108ac9:	83 c8 01             	or     $0x1,%eax
80108acc:	89 c2                	mov    %eax,%edx
80108ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ad1:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108ad9:	74 10                	je     80108aeb <mappages+0x88>
      break;
    a += PGSIZE;
80108adb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108ae2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108ae9:	eb 9c                	jmp    80108a87 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108aeb:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108af1:	c9                   	leave  
80108af2:	c3                   	ret    

80108af3 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108af3:	55                   	push   %ebp
80108af4:	89 e5                	mov    %esp,%ebp
80108af6:	53                   	push   %ebx
80108af7:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108afa:	e8 0c a2 ff ff       	call   80102d0b <kalloc>
80108aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b06:	75 0a                	jne    80108b12 <setupkvm+0x1f>
    return 0;
80108b08:	b8 00 00 00 00       	mov    $0x0,%eax
80108b0d:	e9 8e 00 00 00       	jmp    80108ba0 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108b12:	83 ec 04             	sub    $0x4,%esp
80108b15:	68 00 10 00 00       	push   $0x1000
80108b1a:	6a 00                	push   $0x0
80108b1c:	ff 75 f0             	pushl  -0x10(%ebp)
80108b1f:	e8 b0 d3 ff ff       	call   80105ed4 <memset>
80108b24:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108b27:	83 ec 0c             	sub    $0xc,%esp
80108b2a:	68 00 00 00 0e       	push   $0xe000000
80108b2f:	e8 0d fa ff ff       	call   80108541 <p2v>
80108b34:	83 c4 10             	add    $0x10,%esp
80108b37:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108b3c:	76 0d                	jbe    80108b4b <setupkvm+0x58>
    panic("PHYSTOP too high");
80108b3e:	83 ec 0c             	sub    $0xc,%esp
80108b41:	68 96 9a 10 80       	push   $0x80109a96
80108b46:	e8 1b 7a ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108b4b:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108b52:	eb 40                	jmp    80108b94 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b57:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5d:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b63:	8b 58 08             	mov    0x8(%eax),%ebx
80108b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b69:	8b 40 04             	mov    0x4(%eax),%eax
80108b6c:	29 c3                	sub    %eax,%ebx
80108b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b71:	8b 00                	mov    (%eax),%eax
80108b73:	83 ec 0c             	sub    $0xc,%esp
80108b76:	51                   	push   %ecx
80108b77:	52                   	push   %edx
80108b78:	53                   	push   %ebx
80108b79:	50                   	push   %eax
80108b7a:	ff 75 f0             	pushl  -0x10(%ebp)
80108b7d:	e8 e1 fe ff ff       	call   80108a63 <mappages>
80108b82:	83 c4 20             	add    $0x20,%esp
80108b85:	85 c0                	test   %eax,%eax
80108b87:	79 07                	jns    80108b90 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108b89:	b8 00 00 00 00       	mov    $0x0,%eax
80108b8e:	eb 10                	jmp    80108ba0 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108b90:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108b94:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108b9b:	72 b7                	jb     80108b54 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80108b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108ba3:	c9                   	leave  
80108ba4:	c3                   	ret    

80108ba5 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108ba5:	55                   	push   %ebp
80108ba6:	89 e5                	mov    %esp,%ebp
80108ba8:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108bab:	e8 43 ff ff ff       	call   80108af3 <setupkvm>
80108bb0:	a3 38 67 11 80       	mov    %eax,0x80116738
  switchkvm();
80108bb5:	e8 03 00 00 00       	call   80108bbd <switchkvm>
}
80108bba:	90                   	nop
80108bbb:	c9                   	leave  
80108bbc:	c3                   	ret    

80108bbd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108bbd:	55                   	push   %ebp
80108bbe:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80108bc0:	a1 38 67 11 80       	mov    0x80116738,%eax
80108bc5:	50                   	push   %eax
80108bc6:	e8 69 f9 ff ff       	call   80108534 <v2p>
80108bcb:	83 c4 04             	add    $0x4,%esp
80108bce:	50                   	push   %eax
80108bcf:	e8 54 f9 ff ff       	call   80108528 <lcr3>
80108bd4:	83 c4 04             	add    $0x4,%esp
}
80108bd7:	90                   	nop
80108bd8:	c9                   	leave  
80108bd9:	c3                   	ret    

80108bda <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108bda:	55                   	push   %ebp
80108bdb:	89 e5                	mov    %esp,%ebp
80108bdd:	56                   	push   %esi
80108bde:	53                   	push   %ebx
  pushcli();
80108bdf:	e8 ea d1 ff ff       	call   80105dce <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108be4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108bea:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108bf1:	83 c2 08             	add    $0x8,%edx
80108bf4:	89 d6                	mov    %edx,%esi
80108bf6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108bfd:	83 c2 08             	add    $0x8,%edx
80108c00:	c1 ea 10             	shr    $0x10,%edx
80108c03:	89 d3                	mov    %edx,%ebx
80108c05:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108c0c:	83 c2 08             	add    $0x8,%edx
80108c0f:	c1 ea 18             	shr    $0x18,%edx
80108c12:	89 d1                	mov    %edx,%ecx
80108c14:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108c1b:	67 00 
80108c1d:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108c24:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108c2a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108c31:	83 e2 f0             	and    $0xfffffff0,%edx
80108c34:	83 ca 09             	or     $0x9,%edx
80108c37:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108c3d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108c44:	83 ca 10             	or     $0x10,%edx
80108c47:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108c4d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108c54:	83 e2 9f             	and    $0xffffff9f,%edx
80108c57:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108c5d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108c64:	83 ca 80             	or     $0xffffff80,%edx
80108c67:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108c6d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108c74:	83 e2 f0             	and    $0xfffffff0,%edx
80108c77:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108c7d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108c84:	83 e2 ef             	and    $0xffffffef,%edx
80108c87:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108c8d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108c94:	83 e2 df             	and    $0xffffffdf,%edx
80108c97:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108c9d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108ca4:	83 ca 40             	or     $0x40,%edx
80108ca7:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108cad:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108cb4:	83 e2 7f             	and    $0x7f,%edx
80108cb7:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108cbd:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108cc3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108cc9:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108cd0:	83 e2 ef             	and    $0xffffffef,%edx
80108cd3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108cd9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108cdf:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108ce5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108ceb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108cf2:	8b 52 08             	mov    0x8(%edx),%edx
80108cf5:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108cfb:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108cfe:	83 ec 0c             	sub    $0xc,%esp
80108d01:	6a 30                	push   $0x30
80108d03:	e8 f3 f7 ff ff       	call   801084fb <ltr>
80108d08:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80108d0e:	8b 40 04             	mov    0x4(%eax),%eax
80108d11:	85 c0                	test   %eax,%eax
80108d13:	75 0d                	jne    80108d22 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108d15:	83 ec 0c             	sub    $0xc,%esp
80108d18:	68 a7 9a 10 80       	push   $0x80109aa7
80108d1d:	e8 44 78 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108d22:	8b 45 08             	mov    0x8(%ebp),%eax
80108d25:	8b 40 04             	mov    0x4(%eax),%eax
80108d28:	83 ec 0c             	sub    $0xc,%esp
80108d2b:	50                   	push   %eax
80108d2c:	e8 03 f8 ff ff       	call   80108534 <v2p>
80108d31:	83 c4 10             	add    $0x10,%esp
80108d34:	83 ec 0c             	sub    $0xc,%esp
80108d37:	50                   	push   %eax
80108d38:	e8 eb f7 ff ff       	call   80108528 <lcr3>
80108d3d:	83 c4 10             	add    $0x10,%esp
  popcli();
80108d40:	e8 ce d0 ff ff       	call   80105e13 <popcli>
}
80108d45:	90                   	nop
80108d46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108d49:	5b                   	pop    %ebx
80108d4a:	5e                   	pop    %esi
80108d4b:	5d                   	pop    %ebp
80108d4c:	c3                   	ret    

80108d4d <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108d4d:	55                   	push   %ebp
80108d4e:	89 e5                	mov    %esp,%ebp
80108d50:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108d53:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108d5a:	76 0d                	jbe    80108d69 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108d5c:	83 ec 0c             	sub    $0xc,%esp
80108d5f:	68 bb 9a 10 80       	push   $0x80109abb
80108d64:	e8 fd 77 ff ff       	call   80100566 <panic>
  mem = kalloc();
80108d69:	e8 9d 9f ff ff       	call   80102d0b <kalloc>
80108d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108d71:	83 ec 04             	sub    $0x4,%esp
80108d74:	68 00 10 00 00       	push   $0x1000
80108d79:	6a 00                	push   $0x0
80108d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80108d7e:	e8 51 d1 ff ff       	call   80105ed4 <memset>
80108d83:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108d86:	83 ec 0c             	sub    $0xc,%esp
80108d89:	ff 75 f4             	pushl  -0xc(%ebp)
80108d8c:	e8 a3 f7 ff ff       	call   80108534 <v2p>
80108d91:	83 c4 10             	add    $0x10,%esp
80108d94:	83 ec 0c             	sub    $0xc,%esp
80108d97:	6a 06                	push   $0x6
80108d99:	50                   	push   %eax
80108d9a:	68 00 10 00 00       	push   $0x1000
80108d9f:	6a 00                	push   $0x0
80108da1:	ff 75 08             	pushl  0x8(%ebp)
80108da4:	e8 ba fc ff ff       	call   80108a63 <mappages>
80108da9:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80108dac:	83 ec 04             	sub    $0x4,%esp
80108daf:	ff 75 10             	pushl  0x10(%ebp)
80108db2:	ff 75 0c             	pushl  0xc(%ebp)
80108db5:	ff 75 f4             	pushl  -0xc(%ebp)
80108db8:	e8 d6 d1 ff ff       	call   80105f93 <memmove>
80108dbd:	83 c4 10             	add    $0x10,%esp
}
80108dc0:	90                   	nop
80108dc1:	c9                   	leave  
80108dc2:	c3                   	ret    

80108dc3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108dc3:	55                   	push   %ebp
80108dc4:	89 e5                	mov    %esp,%ebp
80108dc6:	53                   	push   %ebx
80108dc7:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108dca:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dcd:	25 ff 0f 00 00       	and    $0xfff,%eax
80108dd2:	85 c0                	test   %eax,%eax
80108dd4:	74 0d                	je     80108de3 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80108dd6:	83 ec 0c             	sub    $0xc,%esp
80108dd9:	68 d8 9a 10 80       	push   $0x80109ad8
80108dde:	e8 83 77 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108de3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108dea:	e9 95 00 00 00       	jmp    80108e84 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108def:	8b 55 0c             	mov    0xc(%ebp),%edx
80108df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df5:	01 d0                	add    %edx,%eax
80108df7:	83 ec 04             	sub    $0x4,%esp
80108dfa:	6a 00                	push   $0x0
80108dfc:	50                   	push   %eax
80108dfd:	ff 75 08             	pushl  0x8(%ebp)
80108e00:	e8 be fb ff ff       	call   801089c3 <walkpgdir>
80108e05:	83 c4 10             	add    $0x10,%esp
80108e08:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108e0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108e0f:	75 0d                	jne    80108e1e <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108e11:	83 ec 0c             	sub    $0xc,%esp
80108e14:	68 fb 9a 10 80       	push   $0x80109afb
80108e19:	e8 48 77 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e21:	8b 00                	mov    (%eax),%eax
80108e23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e28:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108e2b:	8b 45 18             	mov    0x18(%ebp),%eax
80108e2e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108e31:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108e36:	77 0b                	ja     80108e43 <loaduvm+0x80>
      n = sz - i;
80108e38:	8b 45 18             	mov    0x18(%ebp),%eax
80108e3b:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108e41:	eb 07                	jmp    80108e4a <loaduvm+0x87>
    else
      n = PGSIZE;
80108e43:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108e4a:	8b 55 14             	mov    0x14(%ebp),%edx
80108e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e50:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108e53:	83 ec 0c             	sub    $0xc,%esp
80108e56:	ff 75 e8             	pushl  -0x18(%ebp)
80108e59:	e8 e3 f6 ff ff       	call   80108541 <p2v>
80108e5e:	83 c4 10             	add    $0x10,%esp
80108e61:	ff 75 f0             	pushl  -0x10(%ebp)
80108e64:	53                   	push   %ebx
80108e65:	50                   	push   %eax
80108e66:	ff 75 10             	pushl  0x10(%ebp)
80108e69:	e8 0f 91 ff ff       	call   80101f7d <readi>
80108e6e:	83 c4 10             	add    $0x10,%esp
80108e71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108e74:	74 07                	je     80108e7d <loaduvm+0xba>
      return -1;
80108e76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e7b:	eb 18                	jmp    80108e95 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108e7d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e87:	3b 45 18             	cmp    0x18(%ebp),%eax
80108e8a:	0f 82 5f ff ff ff    	jb     80108def <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108e98:	c9                   	leave  
80108e99:	c3                   	ret    

80108e9a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108e9a:	55                   	push   %ebp
80108e9b:	89 e5                	mov    %esp,%ebp
80108e9d:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108ea0:	8b 45 10             	mov    0x10(%ebp),%eax
80108ea3:	85 c0                	test   %eax,%eax
80108ea5:	79 0a                	jns    80108eb1 <allocuvm+0x17>
    return 0;
80108ea7:	b8 00 00 00 00       	mov    $0x0,%eax
80108eac:	e9 b0 00 00 00       	jmp    80108f61 <allocuvm+0xc7>
  if(newsz < oldsz)
80108eb1:	8b 45 10             	mov    0x10(%ebp),%eax
80108eb4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108eb7:	73 08                	jae    80108ec1 <allocuvm+0x27>
    return oldsz;
80108eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ebc:	e9 a0 00 00 00       	jmp    80108f61 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ec4:	05 ff 0f 00 00       	add    $0xfff,%eax
80108ec9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108ed1:	eb 7f                	jmp    80108f52 <allocuvm+0xb8>
    mem = kalloc();
80108ed3:	e8 33 9e ff ff       	call   80102d0b <kalloc>
80108ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108edb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108edf:	75 2b                	jne    80108f0c <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108ee1:	83 ec 0c             	sub    $0xc,%esp
80108ee4:	68 19 9b 10 80       	push   $0x80109b19
80108ee9:	e8 d8 74 ff ff       	call   801003c6 <cprintf>
80108eee:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108ef1:	83 ec 04             	sub    $0x4,%esp
80108ef4:	ff 75 0c             	pushl  0xc(%ebp)
80108ef7:	ff 75 10             	pushl  0x10(%ebp)
80108efa:	ff 75 08             	pushl  0x8(%ebp)
80108efd:	e8 61 00 00 00       	call   80108f63 <deallocuvm>
80108f02:	83 c4 10             	add    $0x10,%esp
      return 0;
80108f05:	b8 00 00 00 00       	mov    $0x0,%eax
80108f0a:	eb 55                	jmp    80108f61 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108f0c:	83 ec 04             	sub    $0x4,%esp
80108f0f:	68 00 10 00 00       	push   $0x1000
80108f14:	6a 00                	push   $0x0
80108f16:	ff 75 f0             	pushl  -0x10(%ebp)
80108f19:	e8 b6 cf ff ff       	call   80105ed4 <memset>
80108f1e:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108f21:	83 ec 0c             	sub    $0xc,%esp
80108f24:	ff 75 f0             	pushl  -0x10(%ebp)
80108f27:	e8 08 f6 ff ff       	call   80108534 <v2p>
80108f2c:	83 c4 10             	add    $0x10,%esp
80108f2f:	89 c2                	mov    %eax,%edx
80108f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f34:	83 ec 0c             	sub    $0xc,%esp
80108f37:	6a 06                	push   $0x6
80108f39:	52                   	push   %edx
80108f3a:	68 00 10 00 00       	push   $0x1000
80108f3f:	50                   	push   %eax
80108f40:	ff 75 08             	pushl  0x8(%ebp)
80108f43:	e8 1b fb ff ff       	call   80108a63 <mappages>
80108f48:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108f4b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f55:	3b 45 10             	cmp    0x10(%ebp),%eax
80108f58:	0f 82 75 ff ff ff    	jb     80108ed3 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108f5e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108f61:	c9                   	leave  
80108f62:	c3                   	ret    

80108f63 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108f63:	55                   	push   %ebp
80108f64:	89 e5                	mov    %esp,%ebp
80108f66:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108f69:	8b 45 10             	mov    0x10(%ebp),%eax
80108f6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108f6f:	72 08                	jb     80108f79 <deallocuvm+0x16>
    return oldsz;
80108f71:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f74:	e9 a5 00 00 00       	jmp    8010901e <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108f79:	8b 45 10             	mov    0x10(%ebp),%eax
80108f7c:	05 ff 0f 00 00       	add    $0xfff,%eax
80108f81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108f89:	e9 81 00 00 00       	jmp    8010900f <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f91:	83 ec 04             	sub    $0x4,%esp
80108f94:	6a 00                	push   $0x0
80108f96:	50                   	push   %eax
80108f97:	ff 75 08             	pushl  0x8(%ebp)
80108f9a:	e8 24 fa ff ff       	call   801089c3 <walkpgdir>
80108f9f:	83 c4 10             	add    $0x10,%esp
80108fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108fa5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108fa9:	75 09                	jne    80108fb4 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108fab:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108fb2:	eb 54                	jmp    80109008 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fb7:	8b 00                	mov    (%eax),%eax
80108fb9:	83 e0 01             	and    $0x1,%eax
80108fbc:	85 c0                	test   %eax,%eax
80108fbe:	74 48                	je     80109008 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fc3:	8b 00                	mov    (%eax),%eax
80108fc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fca:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108fcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108fd1:	75 0d                	jne    80108fe0 <deallocuvm+0x7d>
        panic("kfree");
80108fd3:	83 ec 0c             	sub    $0xc,%esp
80108fd6:	68 31 9b 10 80       	push   $0x80109b31
80108fdb:	e8 86 75 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108fe0:	83 ec 0c             	sub    $0xc,%esp
80108fe3:	ff 75 ec             	pushl  -0x14(%ebp)
80108fe6:	e8 56 f5 ff ff       	call   80108541 <p2v>
80108feb:	83 c4 10             	add    $0x10,%esp
80108fee:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108ff1:	83 ec 0c             	sub    $0xc,%esp
80108ff4:	ff 75 e8             	pushl  -0x18(%ebp)
80108ff7:	e8 72 9c ff ff       	call   80102c6e <kfree>
80108ffc:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109008:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010900f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109012:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109015:	0f 82 73 ff ff ff    	jb     80108f8e <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010901b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010901e:	c9                   	leave  
8010901f:	c3                   	ret    

80109020 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109020:	55                   	push   %ebp
80109021:	89 e5                	mov    %esp,%ebp
80109023:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109026:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010902a:	75 0d                	jne    80109039 <freevm+0x19>
    panic("freevm: no pgdir");
8010902c:	83 ec 0c             	sub    $0xc,%esp
8010902f:	68 37 9b 10 80       	push   $0x80109b37
80109034:	e8 2d 75 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109039:	83 ec 04             	sub    $0x4,%esp
8010903c:	6a 00                	push   $0x0
8010903e:	68 00 00 00 80       	push   $0x80000000
80109043:	ff 75 08             	pushl  0x8(%ebp)
80109046:	e8 18 ff ff ff       	call   80108f63 <deallocuvm>
8010904b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010904e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109055:	eb 4f                	jmp    801090a6 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010905a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109061:	8b 45 08             	mov    0x8(%ebp),%eax
80109064:	01 d0                	add    %edx,%eax
80109066:	8b 00                	mov    (%eax),%eax
80109068:	83 e0 01             	and    $0x1,%eax
8010906b:	85 c0                	test   %eax,%eax
8010906d:	74 33                	je     801090a2 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010906f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109072:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109079:	8b 45 08             	mov    0x8(%ebp),%eax
8010907c:	01 d0                	add    %edx,%eax
8010907e:	8b 00                	mov    (%eax),%eax
80109080:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109085:	83 ec 0c             	sub    $0xc,%esp
80109088:	50                   	push   %eax
80109089:	e8 b3 f4 ff ff       	call   80108541 <p2v>
8010908e:	83 c4 10             	add    $0x10,%esp
80109091:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109094:	83 ec 0c             	sub    $0xc,%esp
80109097:	ff 75 f0             	pushl  -0x10(%ebp)
8010909a:	e8 cf 9b ff ff       	call   80102c6e <kfree>
8010909f:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801090a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801090a6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801090ad:	76 a8                	jbe    80109057 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801090af:	83 ec 0c             	sub    $0xc,%esp
801090b2:	ff 75 08             	pushl  0x8(%ebp)
801090b5:	e8 b4 9b ff ff       	call   80102c6e <kfree>
801090ba:	83 c4 10             	add    $0x10,%esp
}
801090bd:	90                   	nop
801090be:	c9                   	leave  
801090bf:	c3                   	ret    

801090c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801090c0:	55                   	push   %ebp
801090c1:	89 e5                	mov    %esp,%ebp
801090c3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801090c6:	83 ec 04             	sub    $0x4,%esp
801090c9:	6a 00                	push   $0x0
801090cb:	ff 75 0c             	pushl  0xc(%ebp)
801090ce:	ff 75 08             	pushl  0x8(%ebp)
801090d1:	e8 ed f8 ff ff       	call   801089c3 <walkpgdir>
801090d6:	83 c4 10             	add    $0x10,%esp
801090d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801090dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801090e0:	75 0d                	jne    801090ef <clearpteu+0x2f>
    panic("clearpteu");
801090e2:	83 ec 0c             	sub    $0xc,%esp
801090e5:	68 48 9b 10 80       	push   $0x80109b48
801090ea:	e8 77 74 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801090ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f2:	8b 00                	mov    (%eax),%eax
801090f4:	83 e0 fb             	and    $0xfffffffb,%eax
801090f7:	89 c2                	mov    %eax,%edx
801090f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090fc:	89 10                	mov    %edx,(%eax)
}
801090fe:	90                   	nop
801090ff:	c9                   	leave  
80109100:	c3                   	ret    

80109101 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109101:	55                   	push   %ebp
80109102:	89 e5                	mov    %esp,%ebp
80109104:	53                   	push   %ebx
80109105:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109108:	e8 e6 f9 ff ff       	call   80108af3 <setupkvm>
8010910d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109110:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109114:	75 0a                	jne    80109120 <copyuvm+0x1f>
    return 0;
80109116:	b8 00 00 00 00       	mov    $0x0,%eax
8010911b:	e9 f8 00 00 00       	jmp    80109218 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109127:	e9 c4 00 00 00       	jmp    801091f0 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010912c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010912f:	83 ec 04             	sub    $0x4,%esp
80109132:	6a 00                	push   $0x0
80109134:	50                   	push   %eax
80109135:	ff 75 08             	pushl  0x8(%ebp)
80109138:	e8 86 f8 ff ff       	call   801089c3 <walkpgdir>
8010913d:	83 c4 10             	add    $0x10,%esp
80109140:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109143:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109147:	75 0d                	jne    80109156 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109149:	83 ec 0c             	sub    $0xc,%esp
8010914c:	68 52 9b 10 80       	push   $0x80109b52
80109151:	e8 10 74 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109156:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109159:	8b 00                	mov    (%eax),%eax
8010915b:	83 e0 01             	and    $0x1,%eax
8010915e:	85 c0                	test   %eax,%eax
80109160:	75 0d                	jne    8010916f <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109162:	83 ec 0c             	sub    $0xc,%esp
80109165:	68 6c 9b 10 80       	push   $0x80109b6c
8010916a:	e8 f7 73 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010916f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109172:	8b 00                	mov    (%eax),%eax
80109174:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109179:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010917c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010917f:	8b 00                	mov    (%eax),%eax
80109181:	25 ff 0f 00 00       	and    $0xfff,%eax
80109186:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109189:	e8 7d 9b ff ff       	call   80102d0b <kalloc>
8010918e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109191:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109195:	74 6a                	je     80109201 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109197:	83 ec 0c             	sub    $0xc,%esp
8010919a:	ff 75 e8             	pushl  -0x18(%ebp)
8010919d:	e8 9f f3 ff ff       	call   80108541 <p2v>
801091a2:	83 c4 10             	add    $0x10,%esp
801091a5:	83 ec 04             	sub    $0x4,%esp
801091a8:	68 00 10 00 00       	push   $0x1000
801091ad:	50                   	push   %eax
801091ae:	ff 75 e0             	pushl  -0x20(%ebp)
801091b1:	e8 dd cd ff ff       	call   80105f93 <memmove>
801091b6:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801091b9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801091bc:	83 ec 0c             	sub    $0xc,%esp
801091bf:	ff 75 e0             	pushl  -0x20(%ebp)
801091c2:	e8 6d f3 ff ff       	call   80108534 <v2p>
801091c7:	83 c4 10             	add    $0x10,%esp
801091ca:	89 c2                	mov    %eax,%edx
801091cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cf:	83 ec 0c             	sub    $0xc,%esp
801091d2:	53                   	push   %ebx
801091d3:	52                   	push   %edx
801091d4:	68 00 10 00 00       	push   $0x1000
801091d9:	50                   	push   %eax
801091da:	ff 75 f0             	pushl  -0x10(%ebp)
801091dd:	e8 81 f8 ff ff       	call   80108a63 <mappages>
801091e2:	83 c4 20             	add    $0x20,%esp
801091e5:	85 c0                	test   %eax,%eax
801091e7:	78 1b                	js     80109204 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801091e9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801091f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801091f6:	0f 82 30 ff ff ff    	jb     8010912c <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801091fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801091ff:	eb 17                	jmp    80109218 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109201:	90                   	nop
80109202:	eb 01                	jmp    80109205 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109204:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109205:	83 ec 0c             	sub    $0xc,%esp
80109208:	ff 75 f0             	pushl  -0x10(%ebp)
8010920b:	e8 10 fe ff ff       	call   80109020 <freevm>
80109210:	83 c4 10             	add    $0x10,%esp
  return 0;
80109213:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010921b:	c9                   	leave  
8010921c:	c3                   	ret    

8010921d <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010921d:	55                   	push   %ebp
8010921e:	89 e5                	mov    %esp,%ebp
80109220:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109223:	83 ec 04             	sub    $0x4,%esp
80109226:	6a 00                	push   $0x0
80109228:	ff 75 0c             	pushl  0xc(%ebp)
8010922b:	ff 75 08             	pushl  0x8(%ebp)
8010922e:	e8 90 f7 ff ff       	call   801089c3 <walkpgdir>
80109233:	83 c4 10             	add    $0x10,%esp
80109236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109239:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010923c:	8b 00                	mov    (%eax),%eax
8010923e:	83 e0 01             	and    $0x1,%eax
80109241:	85 c0                	test   %eax,%eax
80109243:	75 07                	jne    8010924c <uva2ka+0x2f>
    return 0;
80109245:	b8 00 00 00 00       	mov    $0x0,%eax
8010924a:	eb 29                	jmp    80109275 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010924c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924f:	8b 00                	mov    (%eax),%eax
80109251:	83 e0 04             	and    $0x4,%eax
80109254:	85 c0                	test   %eax,%eax
80109256:	75 07                	jne    8010925f <uva2ka+0x42>
    return 0;
80109258:	b8 00 00 00 00       	mov    $0x0,%eax
8010925d:	eb 16                	jmp    80109275 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010925f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109262:	8b 00                	mov    (%eax),%eax
80109264:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109269:	83 ec 0c             	sub    $0xc,%esp
8010926c:	50                   	push   %eax
8010926d:	e8 cf f2 ff ff       	call   80108541 <p2v>
80109272:	83 c4 10             	add    $0x10,%esp
}
80109275:	c9                   	leave  
80109276:	c3                   	ret    

80109277 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109277:	55                   	push   %ebp
80109278:	89 e5                	mov    %esp,%ebp
8010927a:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010927d:	8b 45 10             	mov    0x10(%ebp),%eax
80109280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109283:	eb 7f                	jmp    80109304 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109285:	8b 45 0c             	mov    0xc(%ebp),%eax
80109288:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010928d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109290:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109293:	83 ec 08             	sub    $0x8,%esp
80109296:	50                   	push   %eax
80109297:	ff 75 08             	pushl  0x8(%ebp)
8010929a:	e8 7e ff ff ff       	call   8010921d <uva2ka>
8010929f:	83 c4 10             	add    $0x10,%esp
801092a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801092a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801092a9:	75 07                	jne    801092b2 <copyout+0x3b>
      return -1;
801092ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801092b0:	eb 61                	jmp    80109313 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801092b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092b5:	2b 45 0c             	sub    0xc(%ebp),%eax
801092b8:	05 00 10 00 00       	add    $0x1000,%eax
801092bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801092c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092c3:	3b 45 14             	cmp    0x14(%ebp),%eax
801092c6:	76 06                	jbe    801092ce <copyout+0x57>
      n = len;
801092c8:	8b 45 14             	mov    0x14(%ebp),%eax
801092cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801092ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801092d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
801092d4:	89 c2                	mov    %eax,%edx
801092d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801092d9:	01 d0                	add    %edx,%eax
801092db:	83 ec 04             	sub    $0x4,%esp
801092de:	ff 75 f0             	pushl  -0x10(%ebp)
801092e1:	ff 75 f4             	pushl  -0xc(%ebp)
801092e4:	50                   	push   %eax
801092e5:	e8 a9 cc ff ff       	call   80105f93 <memmove>
801092ea:	83 c4 10             	add    $0x10,%esp
    len -= n;
801092ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092f0:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801092f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801092f6:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801092f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092fc:	05 00 10 00 00       	add    $0x1000,%eax
80109301:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109304:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109308:	0f 85 77 ff ff ff    	jne    80109285 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010930e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109313:	c9                   	leave  
80109314:	c3                   	ret    
