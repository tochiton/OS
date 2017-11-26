
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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 90 e6 10 80       	mov    $0x8010e690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e9 3b 10 80       	mov    $0x80103be9,%eax
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
8010003d:	68 70 9d 10 80       	push   $0x80109d70
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 c7 64 00 00       	call   80106513 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 25 11 80 a4 	movl   $0x801125a4,0x801125b0
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 25 11 80 a4 	movl   $0x801125a4,0x801125b4
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 e6 10 80 	movl   $0x8010e6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 25 11 80       	mov    %eax,0x801125b4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 25 11 80       	mov    $0x801125a4,%eax
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
801000bc:	68 a0 e6 10 80       	push   $0x8010e6a0
801000c1:	e8 6f 64 00 00       	call   80106535 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 25 11 80       	mov    0x801125b4,%eax
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
80100107:	68 a0 e6 10 80       	push   $0x8010e6a0
8010010c:	e8 8b 64 00 00       	call   8010659c <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 37 55 00 00       	call   80105663 <sleep>
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
8010013a:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 25 11 80       	mov    0x801125b0,%eax
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
80100183:	68 a0 e6 10 80       	push   $0x8010e6a0
80100188:	e8 0f 64 00 00       	call   8010659c <release>
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
8010019e:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 77 9d 10 80       	push   $0x80109d77
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
801001e2:	e8 80 2a 00 00       	call   80102c67 <iderw>
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
80100204:	68 88 9d 10 80       	push   $0x80109d88
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
80100223:	e8 3f 2a 00 00       	call   80102c67 <iderw>
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
80100243:	68 8f 9d 10 80       	push   $0x80109d8f
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 db 62 00 00       	call   80106535 <acquire>
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
8010027b:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 25 11 80       	mov    %eax,0x801125b4

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
801002b9:	e8 d6 55 00 00       	call   80105894 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 ce 62 00 00       	call   8010659c <release>
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
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
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
801003cc:	a1 34 d6 10 80       	mov    0x8010d634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 d6 10 80       	push   $0x8010d600
801003e2:	e8 4e 61 00 00       	call   80106535 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 96 9d 10 80       	push   $0x80109d96
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
801004cd:	c7 45 ec 9f 9d 10 80 	movl   $0x80109d9f,-0x14(%ebp)
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
80100556:	68 00 d6 10 80       	push   $0x8010d600
8010055b:	e8 3c 60 00 00       	call   8010659c <release>
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
80100571:	c7 05 34 d6 10 80 00 	movl   $0x0,0x8010d634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 a6 9d 10 80       	push   $0x80109da6
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
801005aa:	68 b5 9d 10 80       	push   $0x80109db5
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 27 60 00 00       	call   801065ee <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 b7 9d 10 80       	push   $0x80109db7
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
801005f5:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
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
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
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
801006ca:	68 bb 9d 10 80       	push   $0x80109dbb
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 5b 61 00 00       	call   80106857 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 72 60 00 00       	call   80106798 <memset>
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
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
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
80100798:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
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
801007b6:	e8 3c 7c 00 00       	call   801083f7 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 2f 7c 00 00       	call   801083f7 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 22 7c 00 00       	call   801083f7 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 12 7c 00 00       	call   801083f7 <uartputc>
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
8010082c:	68 00 d6 10 80       	push   $0x8010d600
80100831:	e8 ff 5c 00 00       	call   80106535 <acquire>
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
801008c6:	a1 48 28 11 80       	mov    0x80112848,%eax
801008cb:	83 e8 01             	sub    $0x1,%eax
801008ce:	a3 48 28 11 80       	mov    %eax,0x80112848
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
801008e3:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008e9:	a1 44 28 11 80       	mov    0x80112844,%eax
801008ee:	39 c2                	cmp    %eax,%edx
801008f0:	0f 84 e2 00 00 00    	je     801009d8 <consoleintr+0x1df>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f6:	a1 48 28 11 80       	mov    0x80112848,%eax
801008fb:	83 e8 01             	sub    $0x1,%eax
801008fe:	83 e0 7f             	and    $0x7f,%eax
80100901:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
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
80100911:	8b 15 48 28 11 80    	mov    0x80112848,%edx
80100917:	a1 44 28 11 80       	mov    0x80112844,%eax
8010091c:	39 c2                	cmp    %eax,%edx
8010091e:	0f 84 b4 00 00 00    	je     801009d8 <consoleintr+0x1df>
        input.e--;
80100924:	a1 48 28 11 80       	mov    0x80112848,%eax
80100929:	83 e8 01             	sub    $0x1,%eax
8010092c:	a3 48 28 11 80       	mov    %eax,0x80112848
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
80100950:	8b 15 48 28 11 80    	mov    0x80112848,%edx
80100956:	a1 40 28 11 80       	mov    0x80112840,%eax
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
80100977:	a1 48 28 11 80       	mov    0x80112848,%eax
8010097c:	8d 50 01             	lea    0x1(%eax),%edx
8010097f:	89 15 48 28 11 80    	mov    %edx,0x80112848
80100985:	83 e0 7f             	and    $0x7f,%eax
80100988:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010098b:	88 90 c0 27 11 80    	mov    %dl,-0x7feed840(%eax)
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
801009ab:	a1 48 28 11 80       	mov    0x80112848,%eax
801009b0:	8b 15 40 28 11 80    	mov    0x80112840,%edx
801009b6:	83 ea 80             	sub    $0xffffff80,%edx
801009b9:	39 d0                	cmp    %edx,%eax
801009bb:	75 1a                	jne    801009d7 <consoleintr+0x1de>
          input.w = input.e;
801009bd:	a1 48 28 11 80       	mov    0x80112848,%eax
801009c2:	a3 44 28 11 80       	mov    %eax,0x80112844
          wakeup(&input.r);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 40 28 11 80       	push   $0x80112840
801009cf:	e8 c0 4e 00 00       	call   80105894 <wakeup>
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
801009ed:	68 00 d6 10 80       	push   $0x8010d600
801009f2:	e8 a5 5b 00 00       	call   8010659c <release>
801009f7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009fe:	74 05                	je     80100a05 <consoleintr+0x20c>
    procdump();  // now call procdump() wo. cons.lock held
80100a00:	e8 91 4f 00 00       	call   80105996 <procdump>
  }
  if(printPidList){
80100a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a09:	74 05                	je     80100a10 <consoleintr+0x217>
    printPidReadyList();
80100a0b:	e8 1f 57 00 00       	call   8010612f <printPidReadyList>
  }
   if(doPrintCount){
80100a10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a14:	74 05                	je     80100a1b <consoleintr+0x222>
    countFreeList();
80100a16:	e8 ca 57 00 00       	call   801061e5 <countFreeList>
  }
  if(doPrintSleepList){
80100a1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a1f:	74 05                	je     80100a26 <consoleintr+0x22d>
    printPidSleepList();
80100a21:	e8 22 58 00 00       	call   80106248 <printPidSleepList>
  }
  if(doPrintZombieList){
80100a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2a:	74 05                	je     80100a31 <consoleintr+0x238>
    printZombieList();
80100a2c:	e8 83 58 00 00       	call   801062b4 <printZombieList>
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
80100a40:	e8 3c 12 00 00       	call   80101c81 <iunlock>
80100a45:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a48:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a4e:	83 ec 0c             	sub    $0xc,%esp
80100a51:	68 00 d6 10 80       	push   $0x8010d600
80100a56:	e8 da 5a 00 00       	call   80106535 <acquire>
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
80100a73:	68 00 d6 10 80       	push   $0x8010d600
80100a78:	e8 1f 5b 00 00       	call   8010659c <release>
80100a7d:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a80:	83 ec 0c             	sub    $0xc,%esp
80100a83:	ff 75 08             	pushl  0x8(%ebp)
80100a86:	e8 70 10 00 00       	call   80101afb <ilock>
80100a8b:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a93:	e9 ab 00 00 00       	jmp    80100b43 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a98:	83 ec 08             	sub    $0x8,%esp
80100a9b:	68 00 d6 10 80       	push   $0x8010d600
80100aa0:	68 40 28 11 80       	push   $0x80112840
80100aa5:	e8 b9 4b 00 00       	call   80105663 <sleep>
80100aaa:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aad:	8b 15 40 28 11 80    	mov    0x80112840,%edx
80100ab3:	a1 44 28 11 80       	mov    0x80112844,%eax
80100ab8:	39 c2                	cmp    %eax,%edx
80100aba:	74 a7                	je     80100a63 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abc:	a1 40 28 11 80       	mov    0x80112840,%eax
80100ac1:	8d 50 01             	lea    0x1(%eax),%edx
80100ac4:	89 15 40 28 11 80    	mov    %edx,0x80112840
80100aca:	83 e0 7f             	and    $0x7f,%eax
80100acd:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
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
80100ae8:	a1 40 28 11 80       	mov    0x80112840,%eax
80100aed:	83 e8 01             	sub    $0x1,%eax
80100af0:	a3 40 28 11 80       	mov    %eax,0x80112840
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
80100b1e:	68 00 d6 10 80       	push   $0x8010d600
80100b23:	e8 74 5a 00 00       	call   8010659c <release>
80100b28:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b2b:	83 ec 0c             	sub    $0xc,%esp
80100b2e:	ff 75 08             	pushl  0x8(%ebp)
80100b31:	e8 c5 0f 00 00       	call   80101afb <ilock>
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
80100b51:	e8 2b 11 00 00       	call   80101c81 <iunlock>
80100b56:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b59:	83 ec 0c             	sub    $0xc,%esp
80100b5c:	68 00 d6 10 80       	push   $0x8010d600
80100b61:	e8 cf 59 00 00       	call   80106535 <acquire>
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
80100b9e:	68 00 d6 10 80       	push   $0x8010d600
80100ba3:	e8 f4 59 00 00       	call   8010659c <release>
80100ba8:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bab:	83 ec 0c             	sub    $0xc,%esp
80100bae:	ff 75 08             	pushl  0x8(%ebp)
80100bb1:	e8 45 0f 00 00       	call   80101afb <ilock>
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
80100bc7:	68 ce 9d 10 80       	push   $0x80109dce
80100bcc:	68 00 d6 10 80       	push   $0x8010d600
80100bd1:	e8 3d 59 00 00       	call   80106513 <initlock>
80100bd6:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd9:	c7 05 0c 32 11 80 45 	movl   $0x80100b45,0x8011320c
80100be0:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be3:	c7 05 08 32 11 80 34 	movl   $0x80100a34,0x80113208
80100bea:	0a 10 80 
  cons.locking = 1;
80100bed:	c7 05 34 d6 10 80 01 	movl   $0x1,0x8010d634
80100bf4:	00 00 00 

  picenable(IRQ_KBD);
80100bf7:	83 ec 0c             	sub    $0xc,%esp
80100bfa:	6a 01                	push   $0x1
80100bfc:	e8 84 36 00 00       	call   80104285 <picenable>
80100c01:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c04:	83 ec 08             	sub    $0x8,%esp
80100c07:	6a 00                	push   $0x0
80100c09:	6a 01                	push   $0x1
80100c0b:	e8 24 22 00 00       	call   80102e34 <ioapicenable>
80100c10:	83 c4 10             	add    $0x10,%esp
}
80100c13:	90                   	nop
80100c14:	c9                   	leave  
80100c15:	c3                   	ret    

80100c16 <exec>:
#include "elf.h"
#include "stat.h"

int
exec(char *path, char **argv)
{
80100c16:	55                   	push   %ebp
80100c17:	89 e5                	mov    %esp,%ebp
80100c19:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c1f:	e8 83 2c 00 00       	call   801038a7 <begin_op>
  if((ip = namei(path)) == 0){
80100c24:	83 ec 0c             	sub    $0xc,%esp
80100c27:	ff 75 08             	pushl  0x8(%ebp)
80100c2a:	e8 da 1a 00 00       	call   80102709 <namei>
80100c2f:	83 c4 10             	add    $0x10,%esp
80100c32:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c35:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c39:	75 0f                	jne    80100c4a <exec+0x34>
    end_op();
80100c3b:	e8 f3 2c 00 00       	call   80103933 <end_op>
    return -1;
80100c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c45:	e9 76 04 00 00       	jmp    801010c0 <exec+0x4aa>
  }
  ilock(ip);
80100c4a:	83 ec 0c             	sub    $0xc,%esp
80100c4d:	ff 75 d8             	pushl  -0x28(%ebp)
80100c50:	e8 a6 0e 00 00       	call   80101afb <ilock>
80100c55:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c58:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

 #ifdef CS333_P5
    struct stat myInode;
    stati(ip, &myInode);
80100c5f:	83 ec 08             	sub    $0x8,%esp
80100c62:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
80100c68:	50                   	push   %eax
80100c69:	ff 75 d8             	pushl  -0x28(%ebp)
80100c6c:	e8 da 13 00 00       	call   8010204b <stati>
80100c71:	83 c4 10             	add    $0x10,%esp
    if(proc -> uid == myInode.uid){
80100c74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c7a:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80100c80:	0f b7 85 e4 fe ff ff 	movzwl -0x11c(%ebp),%eax
80100c87:	0f b7 c0             	movzwl %ax,%eax
80100c8a:	39 c2                	cmp    %eax,%edx
80100c8c:	75 13                	jne    80100ca1 <exec+0x8b>
      if(myInode.mode.flags.u_x == 0) 
80100c8e:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
80100c95:	83 e0 40             	and    $0x40,%eax
80100c98:	84 c0                	test   %al,%al
80100c9a:	75 44                	jne    80100ce0 <exec+0xca>
        goto bad;
80100c9c:	e9 ed 03 00 00       	jmp    8010108e <exec+0x478>
    }
    else if(proc -> gid == myInode.gid){
80100ca1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ca7:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80100cad:	0f b7 85 e6 fe ff ff 	movzwl -0x11a(%ebp),%eax
80100cb4:	0f b7 c0             	movzwl %ax,%eax
80100cb7:	39 c2                	cmp    %eax,%edx
80100cb9:	75 13                	jne    80100cce <exec+0xb8>
      if(myInode.mode.flags.g_x == 0)
80100cbb:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
80100cc2:	83 e0 08             	and    $0x8,%eax
80100cc5:	84 c0                	test   %al,%al
80100cc7:	75 17                	jne    80100ce0 <exec+0xca>
        goto bad;
80100cc9:	e9 c0 03 00 00       	jmp    8010108e <exec+0x478>
    }
    else if(myInode.mode.flags.o_x == 0){
80100cce:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
80100cd5:	83 e0 01             	and    $0x1,%eax
80100cd8:	84 c0                	test   %al,%al
80100cda:	0f 84 8c 03 00 00    	je     8010106c <exec+0x456>
      goto bad;
    }
 #endif 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ce0:	6a 34                	push   $0x34
80100ce2:	6a 00                	push   $0x0
80100ce4:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100cea:	50                   	push   %eax
80100ceb:	ff 75 d8             	pushl  -0x28(%ebp)
80100cee:	e8 c6 13 00 00       	call   801020b9 <readi>
80100cf3:	83 c4 10             	add    $0x10,%esp
80100cf6:	83 f8 33             	cmp    $0x33,%eax
80100cf9:	0f 86 70 03 00 00    	jbe    8010106f <exec+0x459>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100cff:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100d05:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d0a:	0f 85 62 03 00 00    	jne    80101072 <exec+0x45c>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100d10:	e8 37 88 00 00       	call   8010954c <setupkvm>
80100d15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d18:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d1c:	0f 84 53 03 00 00    	je     80101075 <exec+0x45f>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d29:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d30:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d39:	e9 ab 00 00 00       	jmp    80100de9 <exec+0x1d3>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d41:	6a 20                	push   $0x20
80100d43:	50                   	push   %eax
80100d44:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100d4a:	50                   	push   %eax
80100d4b:	ff 75 d8             	pushl  -0x28(%ebp)
80100d4e:	e8 66 13 00 00       	call   801020b9 <readi>
80100d53:	83 c4 10             	add    $0x10,%esp
80100d56:	83 f8 20             	cmp    $0x20,%eax
80100d59:	0f 85 19 03 00 00    	jne    80101078 <exec+0x462>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d5f:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d65:	83 f8 01             	cmp    $0x1,%eax
80100d68:	75 71                	jne    80100ddb <exec+0x1c5>
      continue;
    if(ph.memsz < ph.filesz)
80100d6a:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100d70:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d76:	39 c2                	cmp    %eax,%edx
80100d78:	0f 82 fd 02 00 00    	jb     8010107b <exec+0x465>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d7e:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d84:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d8a:	01 d0                	add    %edx,%eax
80100d8c:	83 ec 04             	sub    $0x4,%esp
80100d8f:	50                   	push   %eax
80100d90:	ff 75 e0             	pushl  -0x20(%ebp)
80100d93:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d96:	e8 58 8b 00 00       	call   801098f3 <allocuvm>
80100d9b:	83 c4 10             	add    $0x10,%esp
80100d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100da1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100da5:	0f 84 d3 02 00 00    	je     8010107e <exec+0x468>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100dab:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100db1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100db7:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100dbd:	83 ec 0c             	sub    $0xc,%esp
80100dc0:	52                   	push   %edx
80100dc1:	50                   	push   %eax
80100dc2:	ff 75 d8             	pushl  -0x28(%ebp)
80100dc5:	51                   	push   %ecx
80100dc6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc9:	e8 4e 8a 00 00       	call   8010981c <loaduvm>
80100dce:	83 c4 20             	add    $0x20,%esp
80100dd1:	85 c0                	test   %eax,%eax
80100dd3:	0f 88 a8 02 00 00    	js     80101081 <exec+0x46b>
80100dd9:	eb 01                	jmp    80100ddc <exec+0x1c6>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100ddb:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ddc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de3:	83 c0 20             	add    $0x20,%eax
80100de6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100de9:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100df0:	0f b7 c0             	movzwl %ax,%eax
80100df3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100df6:	0f 8f 42 ff ff ff    	jg     80100d3e <exec+0x128>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100dfc:	83 ec 0c             	sub    $0xc,%esp
80100dff:	ff 75 d8             	pushl  -0x28(%ebp)
80100e02:	e8 dc 0f 00 00       	call   80101de3 <iunlockput>
80100e07:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e0a:	e8 24 2b 00 00       	call   80103933 <end_op>
  ip = 0;
80100e0f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e19:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e29:	05 00 20 00 00       	add    $0x2000,%eax
80100e2e:	83 ec 04             	sub    $0x4,%esp
80100e31:	50                   	push   %eax
80100e32:	ff 75 e0             	pushl  -0x20(%ebp)
80100e35:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e38:	e8 b6 8a 00 00       	call   801098f3 <allocuvm>
80100e3d:	83 c4 10             	add    $0x10,%esp
80100e40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e47:	0f 84 37 02 00 00    	je     80101084 <exec+0x46e>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e50:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e55:	83 ec 08             	sub    $0x8,%esp
80100e58:	50                   	push   %eax
80100e59:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5c:	e8 b8 8c 00 00       	call   80109b19 <clearpteu>
80100e61:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e67:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e6a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e71:	e9 96 00 00 00       	jmp    80100f0c <exec+0x2f6>
    if(argc >= MAXARG)
80100e76:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e7a:	0f 87 07 02 00 00    	ja     80101087 <exec+0x471>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e83:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e8d:	01 d0                	add    %edx,%eax
80100e8f:	8b 00                	mov    (%eax),%eax
80100e91:	83 ec 0c             	sub    $0xc,%esp
80100e94:	50                   	push   %eax
80100e95:	e8 4b 5b 00 00       	call   801069e5 <strlen>
80100e9a:	83 c4 10             	add    $0x10,%esp
80100e9d:	89 c2                	mov    %eax,%edx
80100e9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea2:	29 d0                	sub    %edx,%eax
80100ea4:	83 e8 01             	sub    $0x1,%eax
80100ea7:	83 e0 fc             	and    $0xfffffffc,%eax
80100eaa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ead:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eba:	01 d0                	add    %edx,%eax
80100ebc:	8b 00                	mov    (%eax),%eax
80100ebe:	83 ec 0c             	sub    $0xc,%esp
80100ec1:	50                   	push   %eax
80100ec2:	e8 1e 5b 00 00       	call   801069e5 <strlen>
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	83 c0 01             	add    $0x1,%eax
80100ecd:	89 c1                	mov    %eax,%ecx
80100ecf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100edc:	01 d0                	add    %edx,%eax
80100ede:	8b 00                	mov    (%eax),%eax
80100ee0:	51                   	push   %ecx
80100ee1:	50                   	push   %eax
80100ee2:	ff 75 dc             	pushl  -0x24(%ebp)
80100ee5:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ee8:	e8 e3 8d 00 00       	call   80109cd0 <copyout>
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 c0                	test   %eax,%eax
80100ef2:	0f 88 92 01 00 00    	js     8010108a <exec+0x474>
      goto bad;
    ustack[3+argc] = sp;
80100ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100efb:	8d 50 03             	lea    0x3(%eax),%edx
80100efe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f01:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f08:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f16:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f19:	01 d0                	add    %edx,%eax
80100f1b:	8b 00                	mov    (%eax),%eax
80100f1d:	85 c0                	test   %eax,%eax
80100f1f:	0f 85 51 ff ff ff    	jne    80100e76 <exec+0x260>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f28:	83 c0 03             	add    $0x3,%eax
80100f2b:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100f32:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f36:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100f3d:	ff ff ff 
  ustack[1] = argc;
80100f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f43:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4c:	83 c0 01             	add    $0x1,%eax
80100f4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f56:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f59:	29 d0                	sub    %edx,%eax
80100f5b:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f64:	83 c0 04             	add    $0x4,%eax
80100f67:	c1 e0 02             	shl    $0x2,%eax
80100f6a:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f70:	83 c0 04             	add    $0x4,%eax
80100f73:	c1 e0 02             	shl    $0x2,%eax
80100f76:	50                   	push   %eax
80100f77:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100f7d:	50                   	push   %eax
80100f7e:	ff 75 dc             	pushl  -0x24(%ebp)
80100f81:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f84:	e8 47 8d 00 00       	call   80109cd0 <copyout>
80100f89:	83 c4 10             	add    $0x10,%esp
80100f8c:	85 c0                	test   %eax,%eax
80100f8e:	0f 88 f9 00 00 00    	js     8010108d <exec+0x477>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f94:	8b 45 08             	mov    0x8(%ebp),%eax
80100f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100fa0:	eb 17                	jmp    80100fb9 <exec+0x3a3>
    if(*s == '/')
80100fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa5:	0f b6 00             	movzbl (%eax),%eax
80100fa8:	3c 2f                	cmp    $0x2f,%al
80100faa:	75 09                	jne    80100fb5 <exec+0x39f>
      last = s+1;
80100fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100faf:	83 c0 01             	add    $0x1,%eax
80100fb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fb5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbc:	0f b6 00             	movzbl (%eax),%eax
80100fbf:	84 c0                	test   %al,%al
80100fc1:	75 df                	jne    80100fa2 <exec+0x38c>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100fc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fc9:	83 c0 6c             	add    $0x6c,%eax
80100fcc:	83 ec 04             	sub    $0x4,%esp
80100fcf:	6a 10                	push   $0x10
80100fd1:	ff 75 f0             	pushl  -0x10(%ebp)
80100fd4:	50                   	push   %eax
80100fd5:	e8 c1 59 00 00       	call   8010699b <safestrcpy>
80100fda:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100fdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fe3:	8b 40 04             	mov    0x4(%eax),%eax
80100fe6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100fe9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ff2:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ff5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ffb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ffe:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101000:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101006:	8b 40 18             	mov    0x18(%eax),%eax
80101009:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
8010100f:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80101012:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101018:	8b 40 18             	mov    0x18(%eax),%eax
8010101b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010101e:	89 50 44             	mov    %edx,0x44(%eax)

  if(myInode.mode.flags.setuid){
80101021:	0f b6 85 e9 fe ff ff 	movzbl -0x117(%ebp),%eax
80101028:	83 e0 02             	and    $0x2,%eax
8010102b:	84 c0                	test   %al,%al
8010102d:	74 16                	je     80101045 <exec+0x42f>
    proc -> uid = myInode.uid;
8010102f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101035:	0f b7 95 e4 fe ff ff 	movzwl -0x11c(%ebp),%edx
8010103c:	0f b7 d2             	movzwl %dx,%edx
8010103f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }

  switchuvm(proc);
80101045:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	50                   	push   %eax
8010104f:	e8 df 85 00 00       	call   80109633 <switchuvm>
80101054:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80101057:	83 ec 0c             	sub    $0xc,%esp
8010105a:	ff 75 d0             	pushl  -0x30(%ebp)
8010105d:	e8 17 8a 00 00       	call   80109a79 <freevm>
80101062:	83 c4 10             	add    $0x10,%esp
  return 0;
80101065:	b8 00 00 00 00       	mov    $0x0,%eax
8010106a:	eb 54                	jmp    801010c0 <exec+0x4aa>
    else if(proc -> gid == myInode.gid){
      if(myInode.mode.flags.g_x == 0)
        goto bad;
    }
    else if(myInode.mode.flags.o_x == 0){
      goto bad;
8010106c:	90                   	nop
8010106d:	eb 1f                	jmp    8010108e <exec+0x478>
    }
 #endif 

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
8010106f:	90                   	nop
80101070:	eb 1c                	jmp    8010108e <exec+0x478>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101072:	90                   	nop
80101073:	eb 19                	jmp    8010108e <exec+0x478>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80101075:	90                   	nop
80101076:	eb 16                	jmp    8010108e <exec+0x478>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80101078:	90                   	nop
80101079:	eb 13                	jmp    8010108e <exec+0x478>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
8010107b:	90                   	nop
8010107c:	eb 10                	jmp    8010108e <exec+0x478>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
8010107e:	90                   	nop
8010107f:	eb 0d                	jmp    8010108e <exec+0x478>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101081:	90                   	nop
80101082:	eb 0a                	jmp    8010108e <exec+0x478>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80101084:	90                   	nop
80101085:	eb 07                	jmp    8010108e <exec+0x478>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80101087:	90                   	nop
80101088:	eb 04                	jmp    8010108e <exec+0x478>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
8010108a:	90                   	nop
8010108b:	eb 01                	jmp    8010108e <exec+0x478>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
8010108d:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
8010108e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101092:	74 0e                	je     801010a2 <exec+0x48c>
    freevm(pgdir);
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	ff 75 d4             	pushl  -0x2c(%ebp)
8010109a:	e8 da 89 00 00       	call   80109a79 <freevm>
8010109f:	83 c4 10             	add    $0x10,%esp
  if(ip){
801010a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010a6:	74 13                	je     801010bb <exec+0x4a5>
    iunlockput(ip);
801010a8:	83 ec 0c             	sub    $0xc,%esp
801010ab:	ff 75 d8             	pushl  -0x28(%ebp)
801010ae:	e8 30 0d 00 00       	call   80101de3 <iunlockput>
801010b3:	83 c4 10             	add    $0x10,%esp
    end_op();
801010b6:	e8 78 28 00 00       	call   80103933 <end_op>
  }
  return -1;
801010bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c0:	c9                   	leave  
801010c1:	c3                   	ret    

801010c2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010c2:	55                   	push   %ebp
801010c3:	89 e5                	mov    %esp,%ebp
801010c5:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010c8:	83 ec 08             	sub    $0x8,%esp
801010cb:	68 d6 9d 10 80       	push   $0x80109dd6
801010d0:	68 60 28 11 80       	push   $0x80112860
801010d5:	e8 39 54 00 00       	call   80106513 <initlock>
801010da:	83 c4 10             	add    $0x10,%esp
}
801010dd:	90                   	nop
801010de:	c9                   	leave  
801010df:	c3                   	ret    

801010e0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010e6:	83 ec 0c             	sub    $0xc,%esp
801010e9:	68 60 28 11 80       	push   $0x80112860
801010ee:	e8 42 54 00 00       	call   80106535 <acquire>
801010f3:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010f6:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
801010fd:	eb 2d                	jmp    8010112c <filealloc+0x4c>
    if(f->ref == 0){
801010ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101102:	8b 40 04             	mov    0x4(%eax),%eax
80101105:	85 c0                	test   %eax,%eax
80101107:	75 1f                	jne    80101128 <filealloc+0x48>
      f->ref = 1;
80101109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010110c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	68 60 28 11 80       	push   $0x80112860
8010111b:	e8 7c 54 00 00       	call   8010659c <release>
80101120:	83 c4 10             	add    $0x10,%esp
      return f;
80101123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101126:	eb 23                	jmp    8010114b <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101128:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010112c:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
80101131:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101134:	72 c9                	jb     801010ff <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101136:	83 ec 0c             	sub    $0xc,%esp
80101139:	68 60 28 11 80       	push   $0x80112860
8010113e:	e8 59 54 00 00       	call   8010659c <release>
80101143:	83 c4 10             	add    $0x10,%esp
  return 0;
80101146:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010114b:	c9                   	leave  
8010114c:	c3                   	ret    

8010114d <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010114d:	55                   	push   %ebp
8010114e:	89 e5                	mov    %esp,%ebp
80101150:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	68 60 28 11 80       	push   $0x80112860
8010115b:	e8 d5 53 00 00       	call   80106535 <acquire>
80101160:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101163:	8b 45 08             	mov    0x8(%ebp),%eax
80101166:	8b 40 04             	mov    0x4(%eax),%eax
80101169:	85 c0                	test   %eax,%eax
8010116b:	7f 0d                	jg     8010117a <filedup+0x2d>
    panic("filedup");
8010116d:	83 ec 0c             	sub    $0xc,%esp
80101170:	68 dd 9d 10 80       	push   $0x80109ddd
80101175:	e8 ec f3 ff ff       	call   80100566 <panic>
  f->ref++;
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 40 04             	mov    0x4(%eax),%eax
80101180:	8d 50 01             	lea    0x1(%eax),%edx
80101183:	8b 45 08             	mov    0x8(%ebp),%eax
80101186:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101189:	83 ec 0c             	sub    $0xc,%esp
8010118c:	68 60 28 11 80       	push   $0x80112860
80101191:	e8 06 54 00 00       	call   8010659c <release>
80101196:	83 c4 10             	add    $0x10,%esp
  return f;
80101199:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010119c:	c9                   	leave  
8010119d:	c3                   	ret    

8010119e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010119e:	55                   	push   %ebp
8010119f:	89 e5                	mov    %esp,%ebp
801011a1:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011a4:	83 ec 0c             	sub    $0xc,%esp
801011a7:	68 60 28 11 80       	push   $0x80112860
801011ac:	e8 84 53 00 00       	call   80106535 <acquire>
801011b1:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011b4:	8b 45 08             	mov    0x8(%ebp),%eax
801011b7:	8b 40 04             	mov    0x4(%eax),%eax
801011ba:	85 c0                	test   %eax,%eax
801011bc:	7f 0d                	jg     801011cb <fileclose+0x2d>
    panic("fileclose");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 e5 9d 10 80       	push   $0x80109de5
801011c6:	e8 9b f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 40 04             	mov    0x4(%eax),%eax
801011d1:	8d 50 ff             	lea    -0x1(%eax),%edx
801011d4:	8b 45 08             	mov    0x8(%ebp),%eax
801011d7:	89 50 04             	mov    %edx,0x4(%eax)
801011da:	8b 45 08             	mov    0x8(%ebp),%eax
801011dd:	8b 40 04             	mov    0x4(%eax),%eax
801011e0:	85 c0                	test   %eax,%eax
801011e2:	7e 15                	jle    801011f9 <fileclose+0x5b>
    release(&ftable.lock);
801011e4:	83 ec 0c             	sub    $0xc,%esp
801011e7:	68 60 28 11 80       	push   $0x80112860
801011ec:	e8 ab 53 00 00       	call   8010659c <release>
801011f1:	83 c4 10             	add    $0x10,%esp
801011f4:	e9 8b 00 00 00       	jmp    80101284 <fileclose+0xe6>
    return;
  }
  ff = *f;
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 10                	mov    (%eax),%edx
801011fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101201:	8b 50 04             	mov    0x4(%eax),%edx
80101204:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101207:	8b 50 08             	mov    0x8(%eax),%edx
8010120a:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010120d:	8b 50 0c             	mov    0xc(%eax),%edx
80101210:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101213:	8b 50 10             	mov    0x10(%eax),%edx
80101216:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101219:	8b 40 14             	mov    0x14(%eax),%eax
8010121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
80101222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101229:	8b 45 08             	mov    0x8(%ebp),%eax
8010122c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101232:	83 ec 0c             	sub    $0xc,%esp
80101235:	68 60 28 11 80       	push   $0x80112860
8010123a:	e8 5d 53 00 00       	call   8010659c <release>
8010123f:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101242:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101245:	83 f8 01             	cmp    $0x1,%eax
80101248:	75 19                	jne    80101263 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010124a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010124e:	0f be d0             	movsbl %al,%edx
80101251:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	52                   	push   %edx
80101258:	50                   	push   %eax
80101259:	e8 90 32 00 00       	call   801044ee <pipeclose>
8010125e:	83 c4 10             	add    $0x10,%esp
80101261:	eb 21                	jmp    80101284 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101263:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101266:	83 f8 02             	cmp    $0x2,%eax
80101269:	75 19                	jne    80101284 <fileclose+0xe6>
    begin_op();
8010126b:	e8 37 26 00 00       	call   801038a7 <begin_op>
    iput(ff.ip);
80101270:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101273:	83 ec 0c             	sub    $0xc,%esp
80101276:	50                   	push   %eax
80101277:	e8 77 0a 00 00       	call   80101cf3 <iput>
8010127c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010127f:	e8 af 26 00 00       	call   80103933 <end_op>
  }
}
80101284:	c9                   	leave  
80101285:	c3                   	ret    

80101286 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101286:	55                   	push   %ebp
80101287:	89 e5                	mov    %esp,%ebp
80101289:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 00                	mov    (%eax),%eax
80101291:	83 f8 02             	cmp    $0x2,%eax
80101294:	75 40                	jne    801012d6 <filestat+0x50>
    ilock(f->ip);
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 40 10             	mov    0x10(%eax),%eax
8010129c:	83 ec 0c             	sub    $0xc,%esp
8010129f:	50                   	push   %eax
801012a0:	e8 56 08 00 00       	call   80101afb <ilock>
801012a5:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801012a8:	8b 45 08             	mov    0x8(%ebp),%eax
801012ab:	8b 40 10             	mov    0x10(%eax),%eax
801012ae:	83 ec 08             	sub    $0x8,%esp
801012b1:	ff 75 0c             	pushl  0xc(%ebp)
801012b4:	50                   	push   %eax
801012b5:	e8 91 0d 00 00       	call   8010204b <stati>
801012ba:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012bd:	8b 45 08             	mov    0x8(%ebp),%eax
801012c0:	8b 40 10             	mov    0x10(%eax),%eax
801012c3:	83 ec 0c             	sub    $0xc,%esp
801012c6:	50                   	push   %eax
801012c7:	e8 b5 09 00 00       	call   80101c81 <iunlock>
801012cc:	83 c4 10             	add    $0x10,%esp
    return 0;
801012cf:	b8 00 00 00 00       	mov    $0x0,%eax
801012d4:	eb 05                	jmp    801012db <filestat+0x55>
  }
  return -1;
801012d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012db:	c9                   	leave  
801012dc:	c3                   	ret    

801012dd <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012dd:	55                   	push   %ebp
801012de:	89 e5                	mov    %esp,%ebp
801012e0:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012e3:	8b 45 08             	mov    0x8(%ebp),%eax
801012e6:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012ea:	84 c0                	test   %al,%al
801012ec:	75 0a                	jne    801012f8 <fileread+0x1b>
    return -1;
801012ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f3:	e9 9b 00 00 00       	jmp    80101393 <fileread+0xb6>
  if(f->type == FD_PIPE)
801012f8:	8b 45 08             	mov    0x8(%ebp),%eax
801012fb:	8b 00                	mov    (%eax),%eax
801012fd:	83 f8 01             	cmp    $0x1,%eax
80101300:	75 1a                	jne    8010131c <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101302:	8b 45 08             	mov    0x8(%ebp),%eax
80101305:	8b 40 0c             	mov    0xc(%eax),%eax
80101308:	83 ec 04             	sub    $0x4,%esp
8010130b:	ff 75 10             	pushl  0x10(%ebp)
8010130e:	ff 75 0c             	pushl  0xc(%ebp)
80101311:	50                   	push   %eax
80101312:	e8 7f 33 00 00       	call   80104696 <piperead>
80101317:	83 c4 10             	add    $0x10,%esp
8010131a:	eb 77                	jmp    80101393 <fileread+0xb6>
  if(f->type == FD_INODE){
8010131c:	8b 45 08             	mov    0x8(%ebp),%eax
8010131f:	8b 00                	mov    (%eax),%eax
80101321:	83 f8 02             	cmp    $0x2,%eax
80101324:	75 60                	jne    80101386 <fileread+0xa9>
    ilock(f->ip);
80101326:	8b 45 08             	mov    0x8(%ebp),%eax
80101329:	8b 40 10             	mov    0x10(%eax),%eax
8010132c:	83 ec 0c             	sub    $0xc,%esp
8010132f:	50                   	push   %eax
80101330:	e8 c6 07 00 00       	call   80101afb <ilock>
80101335:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101338:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010133b:	8b 45 08             	mov    0x8(%ebp),%eax
8010133e:	8b 50 14             	mov    0x14(%eax),%edx
80101341:	8b 45 08             	mov    0x8(%ebp),%eax
80101344:	8b 40 10             	mov    0x10(%eax),%eax
80101347:	51                   	push   %ecx
80101348:	52                   	push   %edx
80101349:	ff 75 0c             	pushl  0xc(%ebp)
8010134c:	50                   	push   %eax
8010134d:	e8 67 0d 00 00       	call   801020b9 <readi>
80101352:	83 c4 10             	add    $0x10,%esp
80101355:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010135c:	7e 11                	jle    8010136f <fileread+0x92>
      f->off += r;
8010135e:	8b 45 08             	mov    0x8(%ebp),%eax
80101361:	8b 50 14             	mov    0x14(%eax),%edx
80101364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101367:	01 c2                	add    %eax,%edx
80101369:	8b 45 08             	mov    0x8(%ebp),%eax
8010136c:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010136f:	8b 45 08             	mov    0x8(%ebp),%eax
80101372:	8b 40 10             	mov    0x10(%eax),%eax
80101375:	83 ec 0c             	sub    $0xc,%esp
80101378:	50                   	push   %eax
80101379:	e8 03 09 00 00       	call   80101c81 <iunlock>
8010137e:	83 c4 10             	add    $0x10,%esp
    return r;
80101381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101384:	eb 0d                	jmp    80101393 <fileread+0xb6>
  }
  panic("fileread");
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	68 ef 9d 10 80       	push   $0x80109def
8010138e:	e8 d3 f1 ff ff       	call   80100566 <panic>
}
80101393:	c9                   	leave  
80101394:	c3                   	ret    

80101395 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101395:	55                   	push   %ebp
80101396:	89 e5                	mov    %esp,%ebp
80101398:	53                   	push   %ebx
80101399:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010139c:	8b 45 08             	mov    0x8(%ebp),%eax
8010139f:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013a3:	84 c0                	test   %al,%al
801013a5:	75 0a                	jne    801013b1 <filewrite+0x1c>
    return -1;
801013a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013ac:	e9 1b 01 00 00       	jmp    801014cc <filewrite+0x137>
  if(f->type == FD_PIPE)
801013b1:	8b 45 08             	mov    0x8(%ebp),%eax
801013b4:	8b 00                	mov    (%eax),%eax
801013b6:	83 f8 01             	cmp    $0x1,%eax
801013b9:	75 1d                	jne    801013d8 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801013bb:	8b 45 08             	mov    0x8(%ebp),%eax
801013be:	8b 40 0c             	mov    0xc(%eax),%eax
801013c1:	83 ec 04             	sub    $0x4,%esp
801013c4:	ff 75 10             	pushl  0x10(%ebp)
801013c7:	ff 75 0c             	pushl  0xc(%ebp)
801013ca:	50                   	push   %eax
801013cb:	e8 c8 31 00 00       	call   80104598 <pipewrite>
801013d0:	83 c4 10             	add    $0x10,%esp
801013d3:	e9 f4 00 00 00       	jmp    801014cc <filewrite+0x137>
  if(f->type == FD_INODE){
801013d8:	8b 45 08             	mov    0x8(%ebp),%eax
801013db:	8b 00                	mov    (%eax),%eax
801013dd:	83 f8 02             	cmp    $0x2,%eax
801013e0:	0f 85 d9 00 00 00    	jne    801014bf <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013e6:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013f4:	e9 a3 00 00 00       	jmp    8010149c <filewrite+0x107>
      int n1 = n - i;
801013f9:	8b 45 10             	mov    0x10(%ebp),%eax
801013fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801013ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101402:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101405:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101408:	7e 06                	jle    80101410 <filewrite+0x7b>
        n1 = max;
8010140a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010140d:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101410:	e8 92 24 00 00       	call   801038a7 <begin_op>
      ilock(f->ip);
80101415:	8b 45 08             	mov    0x8(%ebp),%eax
80101418:	8b 40 10             	mov    0x10(%eax),%eax
8010141b:	83 ec 0c             	sub    $0xc,%esp
8010141e:	50                   	push   %eax
8010141f:	e8 d7 06 00 00       	call   80101afb <ilock>
80101424:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101427:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010142a:	8b 45 08             	mov    0x8(%ebp),%eax
8010142d:	8b 50 14             	mov    0x14(%eax),%edx
80101430:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101433:	8b 45 0c             	mov    0xc(%ebp),%eax
80101436:	01 c3                	add    %eax,%ebx
80101438:	8b 45 08             	mov    0x8(%ebp),%eax
8010143b:	8b 40 10             	mov    0x10(%eax),%eax
8010143e:	51                   	push   %ecx
8010143f:	52                   	push   %edx
80101440:	53                   	push   %ebx
80101441:	50                   	push   %eax
80101442:	e8 c9 0d 00 00       	call   80102210 <writei>
80101447:	83 c4 10             	add    $0x10,%esp
8010144a:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010144d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101451:	7e 11                	jle    80101464 <filewrite+0xcf>
        f->off += r;
80101453:	8b 45 08             	mov    0x8(%ebp),%eax
80101456:	8b 50 14             	mov    0x14(%eax),%edx
80101459:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010145c:	01 c2                	add    %eax,%edx
8010145e:	8b 45 08             	mov    0x8(%ebp),%eax
80101461:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101464:	8b 45 08             	mov    0x8(%ebp),%eax
80101467:	8b 40 10             	mov    0x10(%eax),%eax
8010146a:	83 ec 0c             	sub    $0xc,%esp
8010146d:	50                   	push   %eax
8010146e:	e8 0e 08 00 00       	call   80101c81 <iunlock>
80101473:	83 c4 10             	add    $0x10,%esp
      end_op();
80101476:	e8 b8 24 00 00       	call   80103933 <end_op>

      if(r < 0)
8010147b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010147f:	78 29                	js     801014aa <filewrite+0x115>
        break;
      if(r != n1)
80101481:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101484:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101487:	74 0d                	je     80101496 <filewrite+0x101>
        panic("short filewrite");
80101489:	83 ec 0c             	sub    $0xc,%esp
8010148c:	68 f8 9d 10 80       	push   $0x80109df8
80101491:	e8 d0 f0 ff ff       	call   80100566 <panic>
      i += r;
80101496:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101499:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010149c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010149f:	3b 45 10             	cmp    0x10(%ebp),%eax
801014a2:	0f 8c 51 ff ff ff    	jl     801013f9 <filewrite+0x64>
801014a8:	eb 01                	jmp    801014ab <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801014aa:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801014b1:	75 05                	jne    801014b8 <filewrite+0x123>
801014b3:	8b 45 10             	mov    0x10(%ebp),%eax
801014b6:	eb 14                	jmp    801014cc <filewrite+0x137>
801014b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014bd:	eb 0d                	jmp    801014cc <filewrite+0x137>
  }
  panic("filewrite");
801014bf:	83 ec 0c             	sub    $0xc,%esp
801014c2:	68 08 9e 10 80       	push   $0x80109e08
801014c7:	e8 9a f0 ff ff       	call   80100566 <panic>
}
801014cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014cf:	c9                   	leave  
801014d0:	c3                   	ret    

801014d1 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014d1:	55                   	push   %ebp
801014d2:	89 e5                	mov    %esp,%ebp
801014d4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801014d7:	8b 45 08             	mov    0x8(%ebp),%eax
801014da:	83 ec 08             	sub    $0x8,%esp
801014dd:	6a 01                	push   $0x1
801014df:	50                   	push   %eax
801014e0:	e8 d1 ec ff ff       	call   801001b6 <bread>
801014e5:	83 c4 10             	add    $0x10,%esp
801014e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014ee:	83 c0 18             	add    $0x18,%eax
801014f1:	83 ec 04             	sub    $0x4,%esp
801014f4:	6a 1c                	push   $0x1c
801014f6:	50                   	push   %eax
801014f7:	ff 75 0c             	pushl  0xc(%ebp)
801014fa:	e8 58 53 00 00       	call   80106857 <memmove>
801014ff:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101502:	83 ec 0c             	sub    $0xc,%esp
80101505:	ff 75 f4             	pushl  -0xc(%ebp)
80101508:	e8 21 ed ff ff       	call   8010022e <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
}
80101510:	90                   	nop
80101511:	c9                   	leave  
80101512:	c3                   	ret    

80101513 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101513:	55                   	push   %ebp
80101514:	89 e5                	mov    %esp,%ebp
80101516:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101519:	8b 55 0c             	mov    0xc(%ebp),%edx
8010151c:	8b 45 08             	mov    0x8(%ebp),%eax
8010151f:	83 ec 08             	sub    $0x8,%esp
80101522:	52                   	push   %edx
80101523:	50                   	push   %eax
80101524:	e8 8d ec ff ff       	call   801001b6 <bread>
80101529:	83 c4 10             	add    $0x10,%esp
8010152c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010152f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101532:	83 c0 18             	add    $0x18,%eax
80101535:	83 ec 04             	sub    $0x4,%esp
80101538:	68 00 02 00 00       	push   $0x200
8010153d:	6a 00                	push   $0x0
8010153f:	50                   	push   %eax
80101540:	e8 53 52 00 00       	call   80106798 <memset>
80101545:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101548:	83 ec 0c             	sub    $0xc,%esp
8010154b:	ff 75 f4             	pushl  -0xc(%ebp)
8010154e:	e8 8c 25 00 00       	call   80103adf <log_write>
80101553:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	ff 75 f4             	pushl  -0xc(%ebp)
8010155c:	e8 cd ec ff ff       	call   8010022e <brelse>
80101561:	83 c4 10             	add    $0x10,%esp
}
80101564:	90                   	nop
80101565:	c9                   	leave  
80101566:	c3                   	ret    

80101567 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101567:	55                   	push   %ebp
80101568:	89 e5                	mov    %esp,%ebp
8010156a:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010156d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101574:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010157b:	e9 13 01 00 00       	jmp    80101693 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101583:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101589:	85 c0                	test   %eax,%eax
8010158b:	0f 48 c2             	cmovs  %edx,%eax
8010158e:	c1 f8 0c             	sar    $0xc,%eax
80101591:	89 c2                	mov    %eax,%edx
80101593:	a1 78 32 11 80       	mov    0x80113278,%eax
80101598:	01 d0                	add    %edx,%eax
8010159a:	83 ec 08             	sub    $0x8,%esp
8010159d:	50                   	push   %eax
8010159e:	ff 75 08             	pushl  0x8(%ebp)
801015a1:	e8 10 ec ff ff       	call   801001b6 <bread>
801015a6:	83 c4 10             	add    $0x10,%esp
801015a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015b3:	e9 a6 00 00 00       	jmp    8010165e <balloc+0xf7>
      m = 1 << (bi % 8);
801015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015bb:	99                   	cltd   
801015bc:	c1 ea 1d             	shr    $0x1d,%edx
801015bf:	01 d0                	add    %edx,%eax
801015c1:	83 e0 07             	and    $0x7,%eax
801015c4:	29 d0                	sub    %edx,%eax
801015c6:	ba 01 00 00 00       	mov    $0x1,%edx
801015cb:	89 c1                	mov    %eax,%ecx
801015cd:	d3 e2                	shl    %cl,%edx
801015cf:	89 d0                	mov    %edx,%eax
801015d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d7:	8d 50 07             	lea    0x7(%eax),%edx
801015da:	85 c0                	test   %eax,%eax
801015dc:	0f 48 c2             	cmovs  %edx,%eax
801015df:	c1 f8 03             	sar    $0x3,%eax
801015e2:	89 c2                	mov    %eax,%edx
801015e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015e7:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015ec:	0f b6 c0             	movzbl %al,%eax
801015ef:	23 45 e8             	and    -0x18(%ebp),%eax
801015f2:	85 c0                	test   %eax,%eax
801015f4:	75 64                	jne    8010165a <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f9:	8d 50 07             	lea    0x7(%eax),%edx
801015fc:	85 c0                	test   %eax,%eax
801015fe:	0f 48 c2             	cmovs  %edx,%eax
80101601:	c1 f8 03             	sar    $0x3,%eax
80101604:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101607:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160c:	89 d1                	mov    %edx,%ecx
8010160e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101611:	09 ca                	or     %ecx,%edx
80101613:	89 d1                	mov    %edx,%ecx
80101615:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101618:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010161c:	83 ec 0c             	sub    $0xc,%esp
8010161f:	ff 75 ec             	pushl  -0x14(%ebp)
80101622:	e8 b8 24 00 00       	call   80103adf <log_write>
80101627:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010162a:	83 ec 0c             	sub    $0xc,%esp
8010162d:	ff 75 ec             	pushl  -0x14(%ebp)
80101630:	e8 f9 eb ff ff       	call   8010022e <brelse>
80101635:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101638:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010163b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163e:	01 c2                	add    %eax,%edx
80101640:	8b 45 08             	mov    0x8(%ebp),%eax
80101643:	83 ec 08             	sub    $0x8,%esp
80101646:	52                   	push   %edx
80101647:	50                   	push   %eax
80101648:	e8 c6 fe ff ff       	call   80101513 <bzero>
8010164d:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101650:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101653:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101656:	01 d0                	add    %edx,%eax
80101658:	eb 57                	jmp    801016b1 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010165a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010165e:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101665:	7f 17                	jg     8010167e <balloc+0x117>
80101667:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010166a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010166d:	01 d0                	add    %edx,%eax
8010166f:	89 c2                	mov    %eax,%edx
80101671:	a1 60 32 11 80       	mov    0x80113260,%eax
80101676:	39 c2                	cmp    %eax,%edx
80101678:	0f 82 3a ff ff ff    	jb     801015b8 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	ff 75 ec             	pushl  -0x14(%ebp)
80101684:	e8 a5 eb ff ff       	call   8010022e <brelse>
80101689:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010168c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101693:	8b 15 60 32 11 80    	mov    0x80113260,%edx
80101699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169c:	39 c2                	cmp    %eax,%edx
8010169e:	0f 87 dc fe ff ff    	ja     80101580 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016a4:	83 ec 0c             	sub    $0xc,%esp
801016a7:	68 14 9e 10 80       	push   $0x80109e14
801016ac:	e8 b5 ee ff ff       	call   80100566 <panic>
}
801016b1:	c9                   	leave  
801016b2:	c3                   	ret    

801016b3 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016b3:	55                   	push   %ebp
801016b4:	89 e5                	mov    %esp,%ebp
801016b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016b9:	83 ec 08             	sub    $0x8,%esp
801016bc:	68 60 32 11 80       	push   $0x80113260
801016c1:	ff 75 08             	pushl  0x8(%ebp)
801016c4:	e8 08 fe ff ff       	call   801014d1 <readsb>
801016c9:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801016cf:	c1 e8 0c             	shr    $0xc,%eax
801016d2:	89 c2                	mov    %eax,%edx
801016d4:	a1 78 32 11 80       	mov    0x80113278,%eax
801016d9:	01 c2                	add    %eax,%edx
801016db:	8b 45 08             	mov    0x8(%ebp),%eax
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	52                   	push   %edx
801016e2:	50                   	push   %eax
801016e3:	e8 ce ea ff ff       	call   801001b6 <bread>
801016e8:	83 c4 10             	add    $0x10,%esp
801016eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801016f1:	25 ff 0f 00 00       	and    $0xfff,%eax
801016f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016fc:	99                   	cltd   
801016fd:	c1 ea 1d             	shr    $0x1d,%edx
80101700:	01 d0                	add    %edx,%eax
80101702:	83 e0 07             	and    $0x7,%eax
80101705:	29 d0                	sub    %edx,%eax
80101707:	ba 01 00 00 00       	mov    $0x1,%edx
8010170c:	89 c1                	mov    %eax,%ecx
8010170e:	d3 e2                	shl    %cl,%edx
80101710:	89 d0                	mov    %edx,%eax
80101712:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101715:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101718:	8d 50 07             	lea    0x7(%eax),%edx
8010171b:	85 c0                	test   %eax,%eax
8010171d:	0f 48 c2             	cmovs  %edx,%eax
80101720:	c1 f8 03             	sar    $0x3,%eax
80101723:	89 c2                	mov    %eax,%edx
80101725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101728:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010172d:	0f b6 c0             	movzbl %al,%eax
80101730:	23 45 ec             	and    -0x14(%ebp),%eax
80101733:	85 c0                	test   %eax,%eax
80101735:	75 0d                	jne    80101744 <bfree+0x91>
    panic("freeing free block");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 2a 9e 10 80       	push   $0x80109e2a
8010173f:	e8 22 ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101744:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101747:	8d 50 07             	lea    0x7(%eax),%edx
8010174a:	85 c0                	test   %eax,%eax
8010174c:	0f 48 c2             	cmovs  %edx,%eax
8010174f:	c1 f8 03             	sar    $0x3,%eax
80101752:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101755:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010175a:	89 d1                	mov    %edx,%ecx
8010175c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010175f:	f7 d2                	not    %edx
80101761:	21 ca                	and    %ecx,%edx
80101763:	89 d1                	mov    %edx,%ecx
80101765:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101768:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010176c:	83 ec 0c             	sub    $0xc,%esp
8010176f:	ff 75 f4             	pushl  -0xc(%ebp)
80101772:	e8 68 23 00 00       	call   80103adf <log_write>
80101777:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	ff 75 f4             	pushl  -0xc(%ebp)
80101780:	e8 a9 ea ff ff       	call   8010022e <brelse>
80101785:	83 c4 10             	add    $0x10,%esp
}
80101788:	90                   	nop
80101789:	c9                   	leave  
8010178a:	c3                   	ret    

8010178b <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010178b:	55                   	push   %ebp
8010178c:	89 e5                	mov    %esp,%ebp
8010178e:	57                   	push   %edi
8010178f:	56                   	push   %esi
80101790:	53                   	push   %ebx
80101791:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101794:	83 ec 08             	sub    $0x8,%esp
80101797:	68 3d 9e 10 80       	push   $0x80109e3d
8010179c:	68 80 32 11 80       	push   $0x80113280
801017a1:	e8 6d 4d 00 00       	call   80106513 <initlock>
801017a6:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801017a9:	83 ec 08             	sub    $0x8,%esp
801017ac:	68 60 32 11 80       	push   $0x80113260
801017b1:	ff 75 08             	pushl  0x8(%ebp)
801017b4:	e8 18 fd ff ff       	call   801014d1 <readsb>
801017b9:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801017bc:	a1 78 32 11 80       	mov    0x80113278,%eax
801017c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017c4:	8b 3d 74 32 11 80    	mov    0x80113274,%edi
801017ca:	8b 35 70 32 11 80    	mov    0x80113270,%esi
801017d0:	8b 1d 6c 32 11 80    	mov    0x8011326c,%ebx
801017d6:	8b 0d 68 32 11 80    	mov    0x80113268,%ecx
801017dc:	8b 15 64 32 11 80    	mov    0x80113264,%edx
801017e2:	a1 60 32 11 80       	mov    0x80113260,%eax
801017e7:	ff 75 e4             	pushl  -0x1c(%ebp)
801017ea:	57                   	push   %edi
801017eb:	56                   	push   %esi
801017ec:	53                   	push   %ebx
801017ed:	51                   	push   %ecx
801017ee:	52                   	push   %edx
801017ef:	50                   	push   %eax
801017f0:	68 44 9e 10 80       	push   $0x80109e44
801017f5:	e8 cc eb ff ff       	call   801003c6 <cprintf>
801017fa:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801017fd:	90                   	nop
801017fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101801:	5b                   	pop    %ebx
80101802:	5e                   	pop    %esi
80101803:	5f                   	pop    %edi
80101804:	5d                   	pop    %ebp
80101805:	c3                   	ret    

80101806 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101806:	55                   	push   %ebp
80101807:	89 e5                	mov    %esp,%ebp
80101809:	83 ec 28             	sub    $0x28,%esp
8010180c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010180f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101813:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010181a:	e9 ba 00 00 00       	jmp    801018d9 <ialloc+0xd3>
    bp = bread(dev, IBLOCK(inum, sb));
8010181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101822:	c1 e8 03             	shr    $0x3,%eax
80101825:	89 c2                	mov    %eax,%edx
80101827:	a1 74 32 11 80       	mov    0x80113274,%eax
8010182c:	01 d0                	add    %edx,%eax
8010182e:	83 ec 08             	sub    $0x8,%esp
80101831:	50                   	push   %eax
80101832:	ff 75 08             	pushl  0x8(%ebp)
80101835:	e8 7c e9 ff ff       	call   801001b6 <bread>
8010183a:	83 c4 10             	add    $0x10,%esp
8010183d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101840:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101843:	8d 50 18             	lea    0x18(%eax),%edx
80101846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101849:	83 e0 07             	and    $0x7,%eax
8010184c:	c1 e0 06             	shl    $0x6,%eax
8010184f:	01 d0                	add    %edx,%eax
80101851:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101854:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101857:	0f b7 00             	movzwl (%eax),%eax
8010185a:	66 85 c0             	test   %ax,%ax
8010185d:	75 68                	jne    801018c7 <ialloc+0xc1>
      memset(dip, 0, sizeof(*dip));
8010185f:	83 ec 04             	sub    $0x4,%esp
80101862:	6a 40                	push   $0x40
80101864:	6a 00                	push   $0x0
80101866:	ff 75 ec             	pushl  -0x14(%ebp)
80101869:	e8 2a 4f 00 00       	call   80106798 <memset>
8010186e:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101871:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101874:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101878:	66 89 10             	mov    %dx,(%eax)

      dip->uid = UID;
8010187b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010187e:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
      dip->gid = GID;
80101884:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101887:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
      dip->mode.asInt = MODE;
8010188d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101890:	c7 40 0c ed 01 00 00 	movl   $0x1ed,0xc(%eax)

      log_write(bp);   // mark it allocated on the disk
80101897:	83 ec 0c             	sub    $0xc,%esp
8010189a:	ff 75 f0             	pushl  -0x10(%ebp)
8010189d:	e8 3d 22 00 00       	call   80103adf <log_write>
801018a2:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801018a5:	83 ec 0c             	sub    $0xc,%esp
801018a8:	ff 75 f0             	pushl  -0x10(%ebp)
801018ab:	e8 7e e9 ff ff       	call   8010022e <brelse>
801018b0:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b6:	83 ec 08             	sub    $0x8,%esp
801018b9:	50                   	push   %eax
801018ba:	ff 75 08             	pushl  0x8(%ebp)
801018bd:	e8 20 01 00 00       	call   801019e2 <iget>
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	eb 30                	jmp    801018f7 <ialloc+0xf1>
    }
    brelse(bp);
801018c7:	83 ec 0c             	sub    $0xc,%esp
801018ca:	ff 75 f0             	pushl  -0x10(%ebp)
801018cd:	e8 5c e9 ff ff       	call   8010022e <brelse>
801018d2:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801018d9:	8b 15 68 32 11 80    	mov    0x80113268,%edx
801018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e2:	39 c2                	cmp    %eax,%edx
801018e4:	0f 87 35 ff ff ff    	ja     8010181f <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801018ea:	83 ec 0c             	sub    $0xc,%esp
801018ed:	68 97 9e 10 80       	push   $0x80109e97
801018f2:	e8 6f ec ff ff       	call   80100566 <panic>
}
801018f7:	c9                   	leave  
801018f8:	c3                   	ret    

801018f9 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801018f9:	55                   	push   %ebp
801018fa:	89 e5                	mov    %esp,%ebp
801018fc:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101902:	8b 40 04             	mov    0x4(%eax),%eax
80101905:	c1 e8 03             	shr    $0x3,%eax
80101908:	89 c2                	mov    %eax,%edx
8010190a:	a1 74 32 11 80       	mov    0x80113274,%eax
8010190f:	01 c2                	add    %eax,%edx
80101911:	8b 45 08             	mov    0x8(%ebp),%eax
80101914:	8b 00                	mov    (%eax),%eax
80101916:	83 ec 08             	sub    $0x8,%esp
80101919:	52                   	push   %edx
8010191a:	50                   	push   %eax
8010191b:	e8 96 e8 ff ff       	call   801001b6 <bread>
80101920:	83 c4 10             	add    $0x10,%esp
80101923:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101929:	8d 50 18             	lea    0x18(%eax),%edx
8010192c:	8b 45 08             	mov    0x8(%ebp),%eax
8010192f:	8b 40 04             	mov    0x4(%eax),%eax
80101932:	83 e0 07             	and    $0x7,%eax
80101935:	c1 e0 06             	shl    $0x6,%eax
80101938:	01 d0                	add    %edx,%eax
8010193a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010193d:	8b 45 08             	mov    0x8(%ebp),%eax
80101940:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101944:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101947:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010194a:	8b 45 08             	mov    0x8(%ebp),%eax
8010194d:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101951:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101954:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101958:	8b 45 08             	mov    0x8(%ebp),%eax
8010195b:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010195f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101962:	66 89 50 04          	mov    %dx,0x4(%eax)

  //add flag
  dip->uid = ip->uid;
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	0f b7 50 1c          	movzwl 0x1c(%eax),%edx
8010196d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101970:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
80101974:	8b 45 08             	mov    0x8(%ebp),%eax
80101977:	0f b7 50 1e          	movzwl 0x1e(%eax),%edx
8010197b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197e:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101982:	8b 45 08             	mov    0x8(%ebp),%eax
80101985:	8b 50 20             	mov    0x20(%eax),%edx
80101988:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198b:	89 50 0c             	mov    %edx,0xc(%eax)

  dip->nlink = ip->nlink;
8010198e:	8b 45 08             	mov    0x8(%ebp),%eax
80101991:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101998:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010199c:	8b 45 08             	mov    0x8(%ebp),%eax
8010199f:	8b 50 18             	mov    0x18(%eax),%edx
801019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a5:	89 50 10             	mov    %edx,0x10(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019a8:	8b 45 08             	mov    0x8(%ebp),%eax
801019ab:	8d 50 24             	lea    0x24(%eax),%edx
801019ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b1:	83 c0 14             	add    $0x14,%eax
801019b4:	83 ec 04             	sub    $0x4,%esp
801019b7:	6a 2c                	push   $0x2c
801019b9:	52                   	push   %edx
801019ba:	50                   	push   %eax
801019bb:	e8 97 4e 00 00       	call   80106857 <memmove>
801019c0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019c3:	83 ec 0c             	sub    $0xc,%esp
801019c6:	ff 75 f4             	pushl  -0xc(%ebp)
801019c9:	e8 11 21 00 00       	call   80103adf <log_write>
801019ce:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019d1:	83 ec 0c             	sub    $0xc,%esp
801019d4:	ff 75 f4             	pushl  -0xc(%ebp)
801019d7:	e8 52 e8 ff ff       	call   8010022e <brelse>
801019dc:	83 c4 10             	add    $0x10,%esp
}
801019df:	90                   	nop
801019e0:	c9                   	leave  
801019e1:	c3                   	ret    

801019e2 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019e2:	55                   	push   %ebp
801019e3:	89 e5                	mov    %esp,%ebp
801019e5:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019e8:	83 ec 0c             	sub    $0xc,%esp
801019eb:	68 80 32 11 80       	push   $0x80113280
801019f0:	e8 40 4b 00 00       	call   80106535 <acquire>
801019f5:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801019f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019ff:	c7 45 f4 b4 32 11 80 	movl   $0x801132b4,-0xc(%ebp)
80101a06:	eb 5d                	jmp    80101a65 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0b:	8b 40 08             	mov    0x8(%eax),%eax
80101a0e:	85 c0                	test   %eax,%eax
80101a10:	7e 39                	jle    80101a4b <iget+0x69>
80101a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a15:	8b 00                	mov    (%eax),%eax
80101a17:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a1a:	75 2f                	jne    80101a4b <iget+0x69>
80101a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a1f:	8b 40 04             	mov    0x4(%eax),%eax
80101a22:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a25:	75 24                	jne    80101a4b <iget+0x69>
      ip->ref++;
80101a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a2a:	8b 40 08             	mov    0x8(%eax),%eax
80101a2d:	8d 50 01             	lea    0x1(%eax),%edx
80101a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a33:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	68 80 32 11 80       	push   $0x80113280
80101a3e:	e8 59 4b 00 00       	call   8010659c <release>
80101a43:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a49:	eb 74                	jmp    80101abf <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a4f:	75 10                	jne    80101a61 <iget+0x7f>
80101a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a54:	8b 40 08             	mov    0x8(%eax),%eax
80101a57:	85 c0                	test   %eax,%eax
80101a59:	75 06                	jne    80101a61 <iget+0x7f>
      empty = ip;
80101a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a61:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101a65:	81 7d f4 54 42 11 80 	cmpl   $0x80114254,-0xc(%ebp)
80101a6c:	72 9a                	jb     80101a08 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a72:	75 0d                	jne    80101a81 <iget+0x9f>
    panic("iget: no inodes");
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	68 a9 9e 10 80       	push   $0x80109ea9
80101a7c:	e8 e5 ea ff ff       	call   80100566 <panic>

  ip = empty;
80101a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a8a:	8b 55 08             	mov    0x8(%ebp),%edx
80101a8d:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a92:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a95:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a9b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101aac:	83 ec 0c             	sub    $0xc,%esp
80101aaf:	68 80 32 11 80       	push   $0x80113280
80101ab4:	e8 e3 4a 00 00       	call   8010659c <release>
80101ab9:	83 c4 10             	add    $0x10,%esp

  return ip;
80101abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101abf:	c9                   	leave  
80101ac0:	c3                   	ret    

80101ac1 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101ac1:	55                   	push   %ebp
80101ac2:	89 e5                	mov    %esp,%ebp
80101ac4:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101ac7:	83 ec 0c             	sub    $0xc,%esp
80101aca:	68 80 32 11 80       	push   $0x80113280
80101acf:	e8 61 4a 00 00       	call   80106535 <acquire>
80101ad4:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	8b 40 08             	mov    0x8(%eax),%eax
80101add:	8d 50 01             	lea    0x1(%eax),%edx
80101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae3:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	68 80 32 11 80       	push   $0x80113280
80101aee:	e8 a9 4a 00 00       	call   8010659c <release>
80101af3:	83 c4 10             	add    $0x10,%esp
  return ip;
80101af6:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101af9:	c9                   	leave  
80101afa:	c3                   	ret    

80101afb <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101afb:	55                   	push   %ebp
80101afc:	89 e5                	mov    %esp,%ebp
80101afe:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b05:	74 0a                	je     80101b11 <ilock+0x16>
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	8b 40 08             	mov    0x8(%eax),%eax
80101b0d:	85 c0                	test   %eax,%eax
80101b0f:	7f 0d                	jg     80101b1e <ilock+0x23>
    panic("ilock");
80101b11:	83 ec 0c             	sub    $0xc,%esp
80101b14:	68 b9 9e 10 80       	push   $0x80109eb9
80101b19:	e8 48 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b1e:	83 ec 0c             	sub    $0xc,%esp
80101b21:	68 80 32 11 80       	push   $0x80113280
80101b26:	e8 0a 4a 00 00       	call   80106535 <acquire>
80101b2b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b2e:	eb 13                	jmp    80101b43 <ilock+0x48>
    sleep(ip, &icache.lock);
80101b30:	83 ec 08             	sub    $0x8,%esp
80101b33:	68 80 32 11 80       	push   $0x80113280
80101b38:	ff 75 08             	pushl  0x8(%ebp)
80101b3b:	e8 23 3b 00 00       	call   80105663 <sleep>
80101b40:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101b43:	8b 45 08             	mov    0x8(%ebp),%eax
80101b46:	8b 40 0c             	mov    0xc(%eax),%eax
80101b49:	83 e0 01             	and    $0x1,%eax
80101b4c:	85 c0                	test   %eax,%eax
80101b4e:	75 e0                	jne    80101b30 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101b50:	8b 45 08             	mov    0x8(%ebp),%eax
80101b53:	8b 40 0c             	mov    0xc(%eax),%eax
80101b56:	83 c8 01             	or     $0x1,%eax
80101b59:	89 c2                	mov    %eax,%edx
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101b61:	83 ec 0c             	sub    $0xc,%esp
80101b64:	68 80 32 11 80       	push   $0x80113280
80101b69:	e8 2e 4a 00 00       	call   8010659c <release>
80101b6e:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101b71:	8b 45 08             	mov    0x8(%ebp),%eax
80101b74:	8b 40 0c             	mov    0xc(%eax),%eax
80101b77:	83 e0 02             	and    $0x2,%eax
80101b7a:	85 c0                	test   %eax,%eax
80101b7c:	0f 85 fc 00 00 00    	jne    80101c7e <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b82:	8b 45 08             	mov    0x8(%ebp),%eax
80101b85:	8b 40 04             	mov    0x4(%eax),%eax
80101b88:	c1 e8 03             	shr    $0x3,%eax
80101b8b:	89 c2                	mov    %eax,%edx
80101b8d:	a1 74 32 11 80       	mov    0x80113274,%eax
80101b92:	01 c2                	add    %eax,%edx
80101b94:	8b 45 08             	mov    0x8(%ebp),%eax
80101b97:	8b 00                	mov    (%eax),%eax
80101b99:	83 ec 08             	sub    $0x8,%esp
80101b9c:	52                   	push   %edx
80101b9d:	50                   	push   %eax
80101b9e:	e8 13 e6 ff ff       	call   801001b6 <bread>
80101ba3:	83 c4 10             	add    $0x10,%esp
80101ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bac:	8d 50 18             	lea    0x18(%eax),%edx
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	8b 40 04             	mov    0x4(%eax),%eax
80101bb5:	83 e0 07             	and    $0x7,%eax
80101bb8:	c1 e0 06             	shl    $0x6,%eax
80101bbb:	01 d0                	add    %edx,%eax
80101bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc3:	0f b7 10             	movzwl (%eax),%edx
80101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc9:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd0:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101bd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd7:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bde:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bec:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf3:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfa:	8b 50 10             	mov    0x10(%eax),%edx
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	89 50 18             	mov    %edx,0x18(%eax)

    ip->uid = dip->uid;
80101c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c06:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0d:	66 89 50 1c          	mov    %dx,0x1c(%eax)
    ip->gid = dip->gid;
80101c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c14:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101c18:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1b:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    ip->mode.asInt = dip->mode.asInt;
80101c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c22:	8b 50 0c             	mov    0xc(%eax),%edx
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	89 50 20             	mov    %edx,0x20(%eax)

    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c2e:	8d 50 14             	lea    0x14(%eax),%edx
80101c31:	8b 45 08             	mov    0x8(%ebp),%eax
80101c34:	83 c0 24             	add    $0x24,%eax
80101c37:	83 ec 04             	sub    $0x4,%esp
80101c3a:	6a 2c                	push   $0x2c
80101c3c:	52                   	push   %edx
80101c3d:	50                   	push   %eax
80101c3e:	e8 14 4c 00 00       	call   80106857 <memmove>
80101c43:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c46:	83 ec 0c             	sub    $0xc,%esp
80101c49:	ff 75 f4             	pushl  -0xc(%ebp)
80101c4c:	e8 dd e5 ff ff       	call   8010022e <brelse>
80101c51:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101c54:	8b 45 08             	mov    0x8(%ebp),%eax
80101c57:	8b 40 0c             	mov    0xc(%eax),%eax
80101c5a:	83 c8 02             	or     $0x2,%eax
80101c5d:	89 c2                	mov    %eax,%edx
80101c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c62:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101c65:	8b 45 08             	mov    0x8(%ebp),%eax
80101c68:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101c6c:	66 85 c0             	test   %ax,%ax
80101c6f:	75 0d                	jne    80101c7e <ilock+0x183>
      panic("ilock: no type");
80101c71:	83 ec 0c             	sub    $0xc,%esp
80101c74:	68 bf 9e 10 80       	push   $0x80109ebf
80101c79:	e8 e8 e8 ff ff       	call   80100566 <panic>
  }
}
80101c7e:	90                   	nop
80101c7f:	c9                   	leave  
80101c80:	c3                   	ret    

80101c81 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c81:	55                   	push   %ebp
80101c82:	89 e5                	mov    %esp,%ebp
80101c84:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101c87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c8b:	74 17                	je     80101ca4 <iunlock+0x23>
80101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c90:	8b 40 0c             	mov    0xc(%eax),%eax
80101c93:	83 e0 01             	and    $0x1,%eax
80101c96:	85 c0                	test   %eax,%eax
80101c98:	74 0a                	je     80101ca4 <iunlock+0x23>
80101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9d:	8b 40 08             	mov    0x8(%eax),%eax
80101ca0:	85 c0                	test   %eax,%eax
80101ca2:	7f 0d                	jg     80101cb1 <iunlock+0x30>
    panic("iunlock");
80101ca4:	83 ec 0c             	sub    $0xc,%esp
80101ca7:	68 ce 9e 10 80       	push   $0x80109ece
80101cac:	e8 b5 e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101cb1:	83 ec 0c             	sub    $0xc,%esp
80101cb4:	68 80 32 11 80       	push   $0x80113280
80101cb9:	e8 77 48 00 00       	call   80106535 <acquire>
80101cbe:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc4:	8b 40 0c             	mov    0xc(%eax),%eax
80101cc7:	83 e0 fe             	and    $0xfffffffe,%eax
80101cca:	89 c2                	mov    %eax,%edx
80101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccf:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101cd2:	83 ec 0c             	sub    $0xc,%esp
80101cd5:	ff 75 08             	pushl  0x8(%ebp)
80101cd8:	e8 b7 3b 00 00       	call   80105894 <wakeup>
80101cdd:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ce0:	83 ec 0c             	sub    $0xc,%esp
80101ce3:	68 80 32 11 80       	push   $0x80113280
80101ce8:	e8 af 48 00 00       	call   8010659c <release>
80101ced:	83 c4 10             	add    $0x10,%esp
}
80101cf0:	90                   	nop
80101cf1:	c9                   	leave  
80101cf2:	c3                   	ret    

80101cf3 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101cf3:	55                   	push   %ebp
80101cf4:	89 e5                	mov    %esp,%ebp
80101cf6:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101cf9:	83 ec 0c             	sub    $0xc,%esp
80101cfc:	68 80 32 11 80       	push   $0x80113280
80101d01:	e8 2f 48 00 00       	call   80106535 <acquire>
80101d06:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 40 08             	mov    0x8(%eax),%eax
80101d0f:	83 f8 01             	cmp    $0x1,%eax
80101d12:	0f 85 a9 00 00 00    	jne    80101dc1 <iput+0xce>
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 40 0c             	mov    0xc(%eax),%eax
80101d1e:	83 e0 02             	and    $0x2,%eax
80101d21:	85 c0                	test   %eax,%eax
80101d23:	0f 84 98 00 00 00    	je     80101dc1 <iput+0xce>
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101d30:	66 85 c0             	test   %ax,%ax
80101d33:	0f 85 88 00 00 00    	jne    80101dc1 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101d39:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3c:	8b 40 0c             	mov    0xc(%eax),%eax
80101d3f:	83 e0 01             	and    $0x1,%eax
80101d42:	85 c0                	test   %eax,%eax
80101d44:	74 0d                	je     80101d53 <iput+0x60>
      panic("iput busy");
80101d46:	83 ec 0c             	sub    $0xc,%esp
80101d49:	68 d6 9e 10 80       	push   $0x80109ed6
80101d4e:	e8 13 e8 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101d53:	8b 45 08             	mov    0x8(%ebp),%eax
80101d56:	8b 40 0c             	mov    0xc(%eax),%eax
80101d59:	83 c8 01             	or     $0x1,%eax
80101d5c:	89 c2                	mov    %eax,%edx
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 80 32 11 80       	push   $0x80113280
80101d6c:	e8 2b 48 00 00       	call   8010659c <release>
80101d71:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101d74:	83 ec 0c             	sub    $0xc,%esp
80101d77:	ff 75 08             	pushl  0x8(%ebp)
80101d7a:	e8 a8 01 00 00       	call   80101f27 <itrunc>
80101d7f:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101d82:	8b 45 08             	mov    0x8(%ebp),%eax
80101d85:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101d8b:	83 ec 0c             	sub    $0xc,%esp
80101d8e:	ff 75 08             	pushl  0x8(%ebp)
80101d91:	e8 63 fb ff ff       	call   801018f9 <iupdate>
80101d96:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101d99:	83 ec 0c             	sub    $0xc,%esp
80101d9c:	68 80 32 11 80       	push   $0x80113280
80101da1:	e8 8f 47 00 00       	call   80106535 <acquire>
80101da6:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101da9:	8b 45 08             	mov    0x8(%ebp),%eax
80101dac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101db3:	83 ec 0c             	sub    $0xc,%esp
80101db6:	ff 75 08             	pushl  0x8(%ebp)
80101db9:	e8 d6 3a 00 00       	call   80105894 <wakeup>
80101dbe:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc4:	8b 40 08             	mov    0x8(%eax),%eax
80101dc7:	8d 50 ff             	lea    -0x1(%eax),%edx
80101dca:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcd:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	68 80 32 11 80       	push   $0x80113280
80101dd8:	e8 bf 47 00 00       	call   8010659c <release>
80101ddd:	83 c4 10             	add    $0x10,%esp
}
80101de0:	90                   	nop
80101de1:	c9                   	leave  
80101de2:	c3                   	ret    

80101de3 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101de3:	55                   	push   %ebp
80101de4:	89 e5                	mov    %esp,%ebp
80101de6:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101de9:	83 ec 0c             	sub    $0xc,%esp
80101dec:	ff 75 08             	pushl  0x8(%ebp)
80101def:	e8 8d fe ff ff       	call   80101c81 <iunlock>
80101df4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101df7:	83 ec 0c             	sub    $0xc,%esp
80101dfa:	ff 75 08             	pushl  0x8(%ebp)
80101dfd:	e8 f1 fe ff ff       	call   80101cf3 <iput>
80101e02:	83 c4 10             	add    $0x10,%esp
}
80101e05:	90                   	nop
80101e06:	c9                   	leave  
80101e07:	c3                   	ret    

80101e08 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101e08:	55                   	push   %ebp
80101e09:	89 e5                	mov    %esp,%ebp
80101e0b:	53                   	push   %ebx
80101e0c:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101e0f:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101e13:	77 42                	ja     80101e57 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101e15:	8b 45 08             	mov    0x8(%ebp),%eax
80101e18:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e1b:	83 c2 08             	add    $0x8,%edx
80101e1e:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e29:	75 24                	jne    80101e4f <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2e:	8b 00                	mov    (%eax),%eax
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	50                   	push   %eax
80101e34:	e8 2e f7 ff ff       	call   80101567 <balloc>
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e45:	8d 4a 08             	lea    0x8(%edx),%ecx
80101e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e4b:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e52:	e9 cb 00 00 00       	jmp    80101f22 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101e57:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101e5b:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101e5f:	0f 87 b0 00 00 00    	ja     80101f15 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101e65:	8b 45 08             	mov    0x8(%ebp),%eax
80101e68:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e72:	75 1d                	jne    80101e91 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	8b 00                	mov    (%eax),%eax
80101e79:	83 ec 0c             	sub    $0xc,%esp
80101e7c:	50                   	push   %eax
80101e7d:	e8 e5 f6 ff ff       	call   80101567 <balloc>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e88:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e8e:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101e91:	8b 45 08             	mov    0x8(%ebp),%eax
80101e94:	8b 00                	mov    (%eax),%eax
80101e96:	83 ec 08             	sub    $0x8,%esp
80101e99:	ff 75 f4             	pushl  -0xc(%ebp)
80101e9c:	50                   	push   %eax
80101e9d:	e8 14 e3 ff ff       	call   801001b6 <bread>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eab:	83 c0 18             	add    $0x18,%eax
80101eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ebe:	01 d0                	add    %edx,%eax
80101ec0:	8b 00                	mov    (%eax),%eax
80101ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ec5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ec9:	75 37                	jne    80101f02 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ece:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ed8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101edb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ede:	8b 00                	mov    (%eax),%eax
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	50                   	push   %eax
80101ee4:	e8 7e f6 ff ff       	call   80101567 <balloc>
80101ee9:	83 c4 10             	add    $0x10,%esp
80101eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef2:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ef4:	83 ec 0c             	sub    $0xc,%esp
80101ef7:	ff 75 f0             	pushl  -0x10(%ebp)
80101efa:	e8 e0 1b 00 00       	call   80103adf <log_write>
80101eff:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	ff 75 f0             	pushl  -0x10(%ebp)
80101f08:	e8 21 e3 ff ff       	call   8010022e <brelse>
80101f0d:	83 c4 10             	add    $0x10,%esp
    return addr;
80101f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f13:	eb 0d                	jmp    80101f22 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101f15:	83 ec 0c             	sub    $0xc,%esp
80101f18:	68 e0 9e 10 80       	push   $0x80109ee0
80101f1d:	e8 44 e6 ff ff       	call   80100566 <panic>
}
80101f22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f25:	c9                   	leave  
80101f26:	c3                   	ret    

80101f27 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f27:	55                   	push   %ebp
80101f28:	89 e5                	mov    %esp,%ebp
80101f2a:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f34:	eb 45                	jmp    80101f7b <itrunc+0x54>
    if(ip->addrs[i]){
80101f36:	8b 45 08             	mov    0x8(%ebp),%eax
80101f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f3c:	83 c2 08             	add    $0x8,%edx
80101f3f:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f43:	85 c0                	test   %eax,%eax
80101f45:	74 30                	je     80101f77 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101f47:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f4d:	83 c2 08             	add    $0x8,%edx
80101f50:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f54:	8b 55 08             	mov    0x8(%ebp),%edx
80101f57:	8b 12                	mov    (%edx),%edx
80101f59:	83 ec 08             	sub    $0x8,%esp
80101f5c:	50                   	push   %eax
80101f5d:	52                   	push   %edx
80101f5e:	e8 50 f7 ff ff       	call   801016b3 <bfree>
80101f63:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101f66:	8b 45 08             	mov    0x8(%ebp),%eax
80101f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f6c:	83 c2 08             	add    $0x8,%edx
80101f6f:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101f76:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101f7b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101f7f:	7e b5                	jle    80101f36 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f87:	85 c0                	test   %eax,%eax
80101f89:	0f 84 a1 00 00 00    	je     80102030 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f92:	8b 50 4c             	mov    0x4c(%eax),%edx
80101f95:	8b 45 08             	mov    0x8(%ebp),%eax
80101f98:	8b 00                	mov    (%eax),%eax
80101f9a:	83 ec 08             	sub    $0x8,%esp
80101f9d:	52                   	push   %edx
80101f9e:	50                   	push   %eax
80101f9f:	e8 12 e2 ff ff       	call   801001b6 <bread>
80101fa4:	83 c4 10             	add    $0x10,%esp
80101fa7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fad:	83 c0 18             	add    $0x18,%eax
80101fb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101fba:	eb 3c                	jmp    80101ff8 <itrunc+0xd1>
      if(a[j])
80101fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fc9:	01 d0                	add    %edx,%eax
80101fcb:	8b 00                	mov    (%eax),%eax
80101fcd:	85 c0                	test   %eax,%eax
80101fcf:	74 23                	je     80101ff4 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fd4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fde:	01 d0                	add    %edx,%eax
80101fe0:	8b 00                	mov    (%eax),%eax
80101fe2:	8b 55 08             	mov    0x8(%ebp),%edx
80101fe5:	8b 12                	mov    (%edx),%edx
80101fe7:	83 ec 08             	sub    $0x8,%esp
80101fea:	50                   	push   %eax
80101feb:	52                   	push   %edx
80101fec:	e8 c2 f6 ff ff       	call   801016b3 <bfree>
80101ff1:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ff4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ffb:	83 f8 7f             	cmp    $0x7f,%eax
80101ffe:	76 bc                	jbe    80101fbc <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80102000:	83 ec 0c             	sub    $0xc,%esp
80102003:	ff 75 ec             	pushl  -0x14(%ebp)
80102006:	e8 23 e2 ff ff       	call   8010022e <brelse>
8010200b:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010200e:	8b 45 08             	mov    0x8(%ebp),%eax
80102011:	8b 40 4c             	mov    0x4c(%eax),%eax
80102014:	8b 55 08             	mov    0x8(%ebp),%edx
80102017:	8b 12                	mov    (%edx),%edx
80102019:	83 ec 08             	sub    $0x8,%esp
8010201c:	50                   	push   %eax
8010201d:	52                   	push   %edx
8010201e:	e8 90 f6 ff ff       	call   801016b3 <bfree>
80102023:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80102026:	8b 45 08             	mov    0x8(%ebp),%eax
80102029:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80102030:	8b 45 08             	mov    0x8(%ebp),%eax
80102033:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
8010203a:	83 ec 0c             	sub    $0xc,%esp
8010203d:	ff 75 08             	pushl  0x8(%ebp)
80102040:	e8 b4 f8 ff ff       	call   801018f9 <iupdate>
80102045:	83 c4 10             	add    $0x10,%esp
}
80102048:	90                   	nop
80102049:	c9                   	leave  
8010204a:	c3                   	ret    

8010204b <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
8010204b:	55                   	push   %ebp
8010204c:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
8010204e:	8b 45 08             	mov    0x8(%ebp),%eax
80102051:	8b 00                	mov    (%eax),%eax
80102053:	89 c2                	mov    %eax,%edx
80102055:	8b 45 0c             	mov    0xc(%ebp),%eax
80102058:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	8b 50 04             	mov    0x4(%eax),%edx
80102061:	8b 45 0c             	mov    0xc(%ebp),%eax
80102064:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80102067:	8b 45 08             	mov    0x8(%ebp),%eax
8010206a:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010206e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102071:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010207b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010207e:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102082:	8b 45 08             	mov    0x8(%ebp),%eax
80102085:	8b 50 18             	mov    0x18(%eax),%edx
80102088:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208b:	89 50 10             	mov    %edx,0x10(%eax)

  st->uid = ip->uid;
8010208e:	8b 45 08             	mov    0x8(%ebp),%eax
80102091:	0f b7 50 1c          	movzwl 0x1c(%eax),%edx
80102095:	8b 45 0c             	mov    0xc(%ebp),%eax
80102098:	66 89 50 14          	mov    %dx,0x14(%eax)
  st->gid = ip->gid;
8010209c:	8b 45 08             	mov    0x8(%ebp),%eax
8010209f:	0f b7 50 1e          	movzwl 0x1e(%eax),%edx
801020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a6:	66 89 50 16          	mov    %dx,0x16(%eax)
  st->mode.asInt = ip->mode.asInt;
801020aa:	8b 45 08             	mov    0x8(%ebp),%eax
801020ad:	8b 50 20             	mov    0x20(%eax),%edx
801020b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b3:	89 50 18             	mov    %edx,0x18(%eax)
  
}
801020b6:	90                   	nop
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    

801020b9 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020b9:	55                   	push   %ebp
801020ba:	89 e5                	mov    %esp,%ebp
801020bc:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020bf:	8b 45 08             	mov    0x8(%ebp),%eax
801020c2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020c6:	66 83 f8 03          	cmp    $0x3,%ax
801020ca:	75 5c                	jne    80102128 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020d3:	66 85 c0             	test   %ax,%ax
801020d6:	78 20                	js     801020f8 <readi+0x3f>
801020d8:	8b 45 08             	mov    0x8(%ebp),%eax
801020db:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020df:	66 83 f8 09          	cmp    $0x9,%ax
801020e3:	7f 13                	jg     801020f8 <readi+0x3f>
801020e5:	8b 45 08             	mov    0x8(%ebp),%eax
801020e8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ec:	98                   	cwtl   
801020ed:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
801020f4:	85 c0                	test   %eax,%eax
801020f6:	75 0a                	jne    80102102 <readi+0x49>
      return -1;
801020f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020fd:	e9 0c 01 00 00       	jmp    8010220e <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80102102:	8b 45 08             	mov    0x8(%ebp),%eax
80102105:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102109:	98                   	cwtl   
8010210a:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
80102111:	8b 55 14             	mov    0x14(%ebp),%edx
80102114:	83 ec 04             	sub    $0x4,%esp
80102117:	52                   	push   %edx
80102118:	ff 75 0c             	pushl  0xc(%ebp)
8010211b:	ff 75 08             	pushl  0x8(%ebp)
8010211e:	ff d0                	call   *%eax
80102120:	83 c4 10             	add    $0x10,%esp
80102123:	e9 e6 00 00 00       	jmp    8010220e <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80102128:	8b 45 08             	mov    0x8(%ebp),%eax
8010212b:	8b 40 18             	mov    0x18(%eax),%eax
8010212e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102131:	72 0d                	jb     80102140 <readi+0x87>
80102133:	8b 55 10             	mov    0x10(%ebp),%edx
80102136:	8b 45 14             	mov    0x14(%ebp),%eax
80102139:	01 d0                	add    %edx,%eax
8010213b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010213e:	73 0a                	jae    8010214a <readi+0x91>
    return -1;
80102140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102145:	e9 c4 00 00 00       	jmp    8010220e <readi+0x155>
  if(off + n > ip->size)
8010214a:	8b 55 10             	mov    0x10(%ebp),%edx
8010214d:	8b 45 14             	mov    0x14(%ebp),%eax
80102150:	01 c2                	add    %eax,%edx
80102152:	8b 45 08             	mov    0x8(%ebp),%eax
80102155:	8b 40 18             	mov    0x18(%eax),%eax
80102158:	39 c2                	cmp    %eax,%edx
8010215a:	76 0c                	jbe    80102168 <readi+0xaf>
    n = ip->size - off;
8010215c:	8b 45 08             	mov    0x8(%ebp),%eax
8010215f:	8b 40 18             	mov    0x18(%eax),%eax
80102162:	2b 45 10             	sub    0x10(%ebp),%eax
80102165:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010216f:	e9 8b 00 00 00       	jmp    801021ff <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102174:	8b 45 10             	mov    0x10(%ebp),%eax
80102177:	c1 e8 09             	shr    $0x9,%eax
8010217a:	83 ec 08             	sub    $0x8,%esp
8010217d:	50                   	push   %eax
8010217e:	ff 75 08             	pushl  0x8(%ebp)
80102181:	e8 82 fc ff ff       	call   80101e08 <bmap>
80102186:	83 c4 10             	add    $0x10,%esp
80102189:	89 c2                	mov    %eax,%edx
8010218b:	8b 45 08             	mov    0x8(%ebp),%eax
8010218e:	8b 00                	mov    (%eax),%eax
80102190:	83 ec 08             	sub    $0x8,%esp
80102193:	52                   	push   %edx
80102194:	50                   	push   %eax
80102195:	e8 1c e0 ff ff       	call   801001b6 <bread>
8010219a:	83 c4 10             	add    $0x10,%esp
8010219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021a0:	8b 45 10             	mov    0x10(%ebp),%eax
801021a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801021a8:	ba 00 02 00 00       	mov    $0x200,%edx
801021ad:	29 c2                	sub    %eax,%edx
801021af:	8b 45 14             	mov    0x14(%ebp),%eax
801021b2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021b5:	39 c2                	cmp    %eax,%edx
801021b7:	0f 46 c2             	cmovbe %edx,%eax
801021ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801021bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021c0:	8d 50 18             	lea    0x18(%eax),%edx
801021c3:	8b 45 10             	mov    0x10(%ebp),%eax
801021c6:	25 ff 01 00 00       	and    $0x1ff,%eax
801021cb:	01 d0                	add    %edx,%eax
801021cd:	83 ec 04             	sub    $0x4,%esp
801021d0:	ff 75 ec             	pushl  -0x14(%ebp)
801021d3:	50                   	push   %eax
801021d4:	ff 75 0c             	pushl  0xc(%ebp)
801021d7:	e8 7b 46 00 00       	call   80106857 <memmove>
801021dc:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021df:	83 ec 0c             	sub    $0xc,%esp
801021e2:	ff 75 f0             	pushl  -0x10(%ebp)
801021e5:	e8 44 e0 ff ff       	call   8010022e <brelse>
801021ea:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f0:	01 45 f4             	add    %eax,-0xc(%ebp)
801021f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f6:	01 45 10             	add    %eax,0x10(%ebp)
801021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021fc:	01 45 0c             	add    %eax,0xc(%ebp)
801021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102202:	3b 45 14             	cmp    0x14(%ebp),%eax
80102205:	0f 82 69 ff ff ff    	jb     80102174 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010220b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010220e:	c9                   	leave  
8010220f:	c3                   	ret    

80102210 <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102216:	8b 45 08             	mov    0x8(%ebp),%eax
80102219:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010221d:	66 83 f8 03          	cmp    $0x3,%ax
80102221:	75 5c                	jne    8010227f <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102223:	8b 45 08             	mov    0x8(%ebp),%eax
80102226:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010222a:	66 85 c0             	test   %ax,%ax
8010222d:	78 20                	js     8010224f <writei+0x3f>
8010222f:	8b 45 08             	mov    0x8(%ebp),%eax
80102232:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102236:	66 83 f8 09          	cmp    $0x9,%ax
8010223a:	7f 13                	jg     8010224f <writei+0x3f>
8010223c:	8b 45 08             	mov    0x8(%ebp),%eax
8010223f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102243:	98                   	cwtl   
80102244:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
8010224b:	85 c0                	test   %eax,%eax
8010224d:	75 0a                	jne    80102259 <writei+0x49>
      return -1;
8010224f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102254:	e9 3d 01 00 00       	jmp    80102396 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102259:	8b 45 08             	mov    0x8(%ebp),%eax
8010225c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102260:	98                   	cwtl   
80102261:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
80102268:	8b 55 14             	mov    0x14(%ebp),%edx
8010226b:	83 ec 04             	sub    $0x4,%esp
8010226e:	52                   	push   %edx
8010226f:	ff 75 0c             	pushl  0xc(%ebp)
80102272:	ff 75 08             	pushl  0x8(%ebp)
80102275:	ff d0                	call   *%eax
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	e9 17 01 00 00       	jmp    80102396 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010227f:	8b 45 08             	mov    0x8(%ebp),%eax
80102282:	8b 40 18             	mov    0x18(%eax),%eax
80102285:	3b 45 10             	cmp    0x10(%ebp),%eax
80102288:	72 0d                	jb     80102297 <writei+0x87>
8010228a:	8b 55 10             	mov    0x10(%ebp),%edx
8010228d:	8b 45 14             	mov    0x14(%ebp),%eax
80102290:	01 d0                	add    %edx,%eax
80102292:	3b 45 10             	cmp    0x10(%ebp),%eax
80102295:	73 0a                	jae    801022a1 <writei+0x91>
    return -1;
80102297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010229c:	e9 f5 00 00 00       	jmp    80102396 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801022a1:	8b 55 10             	mov    0x10(%ebp),%edx
801022a4:	8b 45 14             	mov    0x14(%ebp),%eax
801022a7:	01 d0                	add    %edx,%eax
801022a9:	3d 00 14 01 00       	cmp    $0x11400,%eax
801022ae:	76 0a                	jbe    801022ba <writei+0xaa>
    return -1;
801022b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b5:	e9 dc 00 00 00       	jmp    80102396 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022c1:	e9 99 00 00 00       	jmp    8010235f <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022c6:	8b 45 10             	mov    0x10(%ebp),%eax
801022c9:	c1 e8 09             	shr    $0x9,%eax
801022cc:	83 ec 08             	sub    $0x8,%esp
801022cf:	50                   	push   %eax
801022d0:	ff 75 08             	pushl  0x8(%ebp)
801022d3:	e8 30 fb ff ff       	call   80101e08 <bmap>
801022d8:	83 c4 10             	add    $0x10,%esp
801022db:	89 c2                	mov    %eax,%edx
801022dd:	8b 45 08             	mov    0x8(%ebp),%eax
801022e0:	8b 00                	mov    (%eax),%eax
801022e2:	83 ec 08             	sub    $0x8,%esp
801022e5:	52                   	push   %edx
801022e6:	50                   	push   %eax
801022e7:	e8 ca de ff ff       	call   801001b6 <bread>
801022ec:	83 c4 10             	add    $0x10,%esp
801022ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022f2:	8b 45 10             	mov    0x10(%ebp),%eax
801022f5:	25 ff 01 00 00       	and    $0x1ff,%eax
801022fa:	ba 00 02 00 00       	mov    $0x200,%edx
801022ff:	29 c2                	sub    %eax,%edx
80102301:	8b 45 14             	mov    0x14(%ebp),%eax
80102304:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102307:	39 c2                	cmp    %eax,%edx
80102309:	0f 46 c2             	cmovbe %edx,%eax
8010230c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102312:	8d 50 18             	lea    0x18(%eax),%edx
80102315:	8b 45 10             	mov    0x10(%ebp),%eax
80102318:	25 ff 01 00 00       	and    $0x1ff,%eax
8010231d:	01 d0                	add    %edx,%eax
8010231f:	83 ec 04             	sub    $0x4,%esp
80102322:	ff 75 ec             	pushl  -0x14(%ebp)
80102325:	ff 75 0c             	pushl  0xc(%ebp)
80102328:	50                   	push   %eax
80102329:	e8 29 45 00 00       	call   80106857 <memmove>
8010232e:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102331:	83 ec 0c             	sub    $0xc,%esp
80102334:	ff 75 f0             	pushl  -0x10(%ebp)
80102337:	e8 a3 17 00 00       	call   80103adf <log_write>
8010233c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010233f:	83 ec 0c             	sub    $0xc,%esp
80102342:	ff 75 f0             	pushl  -0x10(%ebp)
80102345:	e8 e4 de ff ff       	call   8010022e <brelse>
8010234a:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010234d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102350:	01 45 f4             	add    %eax,-0xc(%ebp)
80102353:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102356:	01 45 10             	add    %eax,0x10(%ebp)
80102359:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010235c:	01 45 0c             	add    %eax,0xc(%ebp)
8010235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102362:	3b 45 14             	cmp    0x14(%ebp),%eax
80102365:	0f 82 5b ff ff ff    	jb     801022c6 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010236b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010236f:	74 22                	je     80102393 <writei+0x183>
80102371:	8b 45 08             	mov    0x8(%ebp),%eax
80102374:	8b 40 18             	mov    0x18(%eax),%eax
80102377:	3b 45 10             	cmp    0x10(%ebp),%eax
8010237a:	73 17                	jae    80102393 <writei+0x183>
    ip->size = off;
8010237c:	8b 45 08             	mov    0x8(%ebp),%eax
8010237f:	8b 55 10             	mov    0x10(%ebp),%edx
80102382:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	ff 75 08             	pushl  0x8(%ebp)
8010238b:	e8 69 f5 ff ff       	call   801018f9 <iupdate>
80102390:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102393:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102396:	c9                   	leave  
80102397:	c3                   	ret    

80102398 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80102398:	55                   	push   %ebp
80102399:	89 e5                	mov    %esp,%ebp
8010239b:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010239e:	83 ec 04             	sub    $0x4,%esp
801023a1:	6a 0e                	push   $0xe
801023a3:	ff 75 0c             	pushl  0xc(%ebp)
801023a6:	ff 75 08             	pushl  0x8(%ebp)
801023a9:	e8 3f 45 00 00       	call   801068ed <strncmp>
801023ae:	83 c4 10             	add    $0x10,%esp
}
801023b1:	c9                   	leave  
801023b2:	c3                   	ret    

801023b3 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801023b3:	55                   	push   %ebp
801023b4:	89 e5                	mov    %esp,%ebp
801023b6:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
801023bc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023c0:	66 83 f8 01          	cmp    $0x1,%ax
801023c4:	74 0d                	je     801023d3 <dirlookup+0x20>
    panic("dirlookup not DIR");
801023c6:	83 ec 0c             	sub    $0xc,%esp
801023c9:	68 f3 9e 10 80       	push   $0x80109ef3
801023ce:	e8 93 e1 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801023d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023da:	eb 7b                	jmp    80102457 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023dc:	6a 10                	push   $0x10
801023de:	ff 75 f4             	pushl  -0xc(%ebp)
801023e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023e4:	50                   	push   %eax
801023e5:	ff 75 08             	pushl  0x8(%ebp)
801023e8:	e8 cc fc ff ff       	call   801020b9 <readi>
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	83 f8 10             	cmp    $0x10,%eax
801023f3:	74 0d                	je     80102402 <dirlookup+0x4f>
      panic("dirlink read");
801023f5:	83 ec 0c             	sub    $0xc,%esp
801023f8:	68 05 9f 10 80       	push   $0x80109f05
801023fd:	e8 64 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102402:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102406:	66 85 c0             	test   %ax,%ax
80102409:	74 47                	je     80102452 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010240b:	83 ec 08             	sub    $0x8,%esp
8010240e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102411:	83 c0 02             	add    $0x2,%eax
80102414:	50                   	push   %eax
80102415:	ff 75 0c             	pushl  0xc(%ebp)
80102418:	e8 7b ff ff ff       	call   80102398 <namecmp>
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 c0                	test   %eax,%eax
80102422:	75 2f                	jne    80102453 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102424:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102428:	74 08                	je     80102432 <dirlookup+0x7f>
        *poff = off;
8010242a:	8b 45 10             	mov    0x10(%ebp),%eax
8010242d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102430:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102432:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102436:	0f b7 c0             	movzwl %ax,%eax
80102439:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010243c:	8b 45 08             	mov    0x8(%ebp),%eax
8010243f:	8b 00                	mov    (%eax),%eax
80102441:	83 ec 08             	sub    $0x8,%esp
80102444:	ff 75 f0             	pushl  -0x10(%ebp)
80102447:	50                   	push   %eax
80102448:	e8 95 f5 ff ff       	call   801019e2 <iget>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	eb 19                	jmp    8010246b <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102452:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102453:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
8010245a:	8b 40 18             	mov    0x18(%eax),%eax
8010245d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102460:	0f 87 76 ff ff ff    	ja     801023dc <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102466:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010246b:	c9                   	leave  
8010246c:	c3                   	ret    

8010246d <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010246d:	55                   	push   %ebp
8010246e:	89 e5                	mov    %esp,%ebp
80102470:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102473:	83 ec 04             	sub    $0x4,%esp
80102476:	6a 00                	push   $0x0
80102478:	ff 75 0c             	pushl  0xc(%ebp)
8010247b:	ff 75 08             	pushl  0x8(%ebp)
8010247e:	e8 30 ff ff ff       	call   801023b3 <dirlookup>
80102483:	83 c4 10             	add    $0x10,%esp
80102486:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010248d:	74 18                	je     801024a7 <dirlink+0x3a>
    iput(ip);
8010248f:	83 ec 0c             	sub    $0xc,%esp
80102492:	ff 75 f0             	pushl  -0x10(%ebp)
80102495:	e8 59 f8 ff ff       	call   80101cf3 <iput>
8010249a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010249d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024a2:	e9 9c 00 00 00       	jmp    80102543 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801024ae:	eb 39                	jmp    801024e9 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024b3:	6a 10                	push   $0x10
801024b5:	50                   	push   %eax
801024b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024b9:	50                   	push   %eax
801024ba:	ff 75 08             	pushl  0x8(%ebp)
801024bd:	e8 f7 fb ff ff       	call   801020b9 <readi>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	83 f8 10             	cmp    $0x10,%eax
801024c8:	74 0d                	je     801024d7 <dirlink+0x6a>
      panic("dirlink read");
801024ca:	83 ec 0c             	sub    $0xc,%esp
801024cd:	68 05 9f 10 80       	push   $0x80109f05
801024d2:	e8 8f e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801024d7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801024db:	66 85 c0             	test   %ax,%ax
801024de:	74 18                	je     801024f8 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024e3:	83 c0 10             	add    $0x10,%eax
801024e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
801024ec:	8b 50 18             	mov    0x18(%eax),%edx
801024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f2:	39 c2                	cmp    %eax,%edx
801024f4:	77 ba                	ja     801024b0 <dirlink+0x43>
801024f6:	eb 01                	jmp    801024f9 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801024f8:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801024f9:	83 ec 04             	sub    $0x4,%esp
801024fc:	6a 0e                	push   $0xe
801024fe:	ff 75 0c             	pushl  0xc(%ebp)
80102501:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102504:	83 c0 02             	add    $0x2,%eax
80102507:	50                   	push   %eax
80102508:	e8 36 44 00 00       	call   80106943 <strncpy>
8010250d:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102510:	8b 45 10             	mov    0x10(%ebp),%eax
80102513:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251a:	6a 10                	push   $0x10
8010251c:	50                   	push   %eax
8010251d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102520:	50                   	push   %eax
80102521:	ff 75 08             	pushl  0x8(%ebp)
80102524:	e8 e7 fc ff ff       	call   80102210 <writei>
80102529:	83 c4 10             	add    $0x10,%esp
8010252c:	83 f8 10             	cmp    $0x10,%eax
8010252f:	74 0d                	je     8010253e <dirlink+0xd1>
    panic("dirlink");
80102531:	83 ec 0c             	sub    $0xc,%esp
80102534:	68 12 9f 10 80       	push   $0x80109f12
80102539:	e8 28 e0 ff ff       	call   80100566 <panic>
  
  return 0;
8010253e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102543:	c9                   	leave  
80102544:	c3                   	ret    

80102545 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102545:	55                   	push   %ebp
80102546:	89 e5                	mov    %esp,%ebp
80102548:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010254b:	eb 04                	jmp    80102551 <skipelem+0xc>
    path++;
8010254d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102551:	8b 45 08             	mov    0x8(%ebp),%eax
80102554:	0f b6 00             	movzbl (%eax),%eax
80102557:	3c 2f                	cmp    $0x2f,%al
80102559:	74 f2                	je     8010254d <skipelem+0x8>
    path++;
  if(*path == 0)
8010255b:	8b 45 08             	mov    0x8(%ebp),%eax
8010255e:	0f b6 00             	movzbl (%eax),%eax
80102561:	84 c0                	test   %al,%al
80102563:	75 07                	jne    8010256c <skipelem+0x27>
    return 0;
80102565:	b8 00 00 00 00       	mov    $0x0,%eax
8010256a:	eb 7b                	jmp    801025e7 <skipelem+0xa2>
  s = path;
8010256c:	8b 45 08             	mov    0x8(%ebp),%eax
8010256f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102572:	eb 04                	jmp    80102578 <skipelem+0x33>
    path++;
80102574:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102578:	8b 45 08             	mov    0x8(%ebp),%eax
8010257b:	0f b6 00             	movzbl (%eax),%eax
8010257e:	3c 2f                	cmp    $0x2f,%al
80102580:	74 0a                	je     8010258c <skipelem+0x47>
80102582:	8b 45 08             	mov    0x8(%ebp),%eax
80102585:	0f b6 00             	movzbl (%eax),%eax
80102588:	84 c0                	test   %al,%al
8010258a:	75 e8                	jne    80102574 <skipelem+0x2f>
    path++;
  len = path - s;
8010258c:	8b 55 08             	mov    0x8(%ebp),%edx
8010258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102592:	29 c2                	sub    %eax,%edx
80102594:	89 d0                	mov    %edx,%eax
80102596:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102599:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010259d:	7e 15                	jle    801025b4 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010259f:	83 ec 04             	sub    $0x4,%esp
801025a2:	6a 0e                	push   $0xe
801025a4:	ff 75 f4             	pushl  -0xc(%ebp)
801025a7:	ff 75 0c             	pushl  0xc(%ebp)
801025aa:	e8 a8 42 00 00       	call   80106857 <memmove>
801025af:	83 c4 10             	add    $0x10,%esp
801025b2:	eb 26                	jmp    801025da <skipelem+0x95>
  else {
    memmove(name, s, len);
801025b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025b7:	83 ec 04             	sub    $0x4,%esp
801025ba:	50                   	push   %eax
801025bb:	ff 75 f4             	pushl  -0xc(%ebp)
801025be:	ff 75 0c             	pushl  0xc(%ebp)
801025c1:	e8 91 42 00 00       	call   80106857 <memmove>
801025c6:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801025c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801025cf:	01 d0                	add    %edx,%eax
801025d1:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025d4:	eb 04                	jmp    801025da <skipelem+0x95>
    path++;
801025d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025da:	8b 45 08             	mov    0x8(%ebp),%eax
801025dd:	0f b6 00             	movzbl (%eax),%eax
801025e0:	3c 2f                	cmp    $0x2f,%al
801025e2:	74 f2                	je     801025d6 <skipelem+0x91>
    path++;
  return path;
801025e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025e7:	c9                   	leave  
801025e8:	c3                   	ret    

801025e9 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025e9:	55                   	push   %ebp
801025ea:	89 e5                	mov    %esp,%ebp
801025ec:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025ef:	8b 45 08             	mov    0x8(%ebp),%eax
801025f2:	0f b6 00             	movzbl (%eax),%eax
801025f5:	3c 2f                	cmp    $0x2f,%al
801025f7:	75 17                	jne    80102610 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801025f9:	83 ec 08             	sub    $0x8,%esp
801025fc:	6a 01                	push   $0x1
801025fe:	6a 01                	push   $0x1
80102600:	e8 dd f3 ff ff       	call   801019e2 <iget>
80102605:	83 c4 10             	add    $0x10,%esp
80102608:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010260b:	e9 bb 00 00 00       	jmp    801026cb <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102610:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102616:	8b 40 68             	mov    0x68(%eax),%eax
80102619:	83 ec 0c             	sub    $0xc,%esp
8010261c:	50                   	push   %eax
8010261d:	e8 9f f4 ff ff       	call   80101ac1 <idup>
80102622:	83 c4 10             	add    $0x10,%esp
80102625:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102628:	e9 9e 00 00 00       	jmp    801026cb <namex+0xe2>
    ilock(ip);
8010262d:	83 ec 0c             	sub    $0xc,%esp
80102630:	ff 75 f4             	pushl  -0xc(%ebp)
80102633:	e8 c3 f4 ff ff       	call   80101afb <ilock>
80102638:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010263e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102642:	66 83 f8 01          	cmp    $0x1,%ax
80102646:	74 18                	je     80102660 <namex+0x77>
      iunlockput(ip);
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	ff 75 f4             	pushl  -0xc(%ebp)
8010264e:	e8 90 f7 ff ff       	call   80101de3 <iunlockput>
80102653:	83 c4 10             	add    $0x10,%esp
      return 0;
80102656:	b8 00 00 00 00       	mov    $0x0,%eax
8010265b:	e9 a7 00 00 00       	jmp    80102707 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102660:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102664:	74 20                	je     80102686 <namex+0x9d>
80102666:	8b 45 08             	mov    0x8(%ebp),%eax
80102669:	0f b6 00             	movzbl (%eax),%eax
8010266c:	84 c0                	test   %al,%al
8010266e:	75 16                	jne    80102686 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	ff 75 f4             	pushl  -0xc(%ebp)
80102676:	e8 06 f6 ff ff       	call   80101c81 <iunlock>
8010267b:	83 c4 10             	add    $0x10,%esp
      return ip;
8010267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102681:	e9 81 00 00 00       	jmp    80102707 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102686:	83 ec 04             	sub    $0x4,%esp
80102689:	6a 00                	push   $0x0
8010268b:	ff 75 10             	pushl  0x10(%ebp)
8010268e:	ff 75 f4             	pushl  -0xc(%ebp)
80102691:	e8 1d fd ff ff       	call   801023b3 <dirlookup>
80102696:	83 c4 10             	add    $0x10,%esp
80102699:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010269c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026a0:	75 15                	jne    801026b7 <namex+0xce>
      iunlockput(ip);
801026a2:	83 ec 0c             	sub    $0xc,%esp
801026a5:	ff 75 f4             	pushl  -0xc(%ebp)
801026a8:	e8 36 f7 ff ff       	call   80101de3 <iunlockput>
801026ad:	83 c4 10             	add    $0x10,%esp
      return 0;
801026b0:	b8 00 00 00 00       	mov    $0x0,%eax
801026b5:	eb 50                	jmp    80102707 <namex+0x11e>
    }
    iunlockput(ip);
801026b7:	83 ec 0c             	sub    $0xc,%esp
801026ba:	ff 75 f4             	pushl  -0xc(%ebp)
801026bd:	e8 21 f7 ff ff       	call   80101de3 <iunlockput>
801026c2:	83 c4 10             	add    $0x10,%esp
    ip = next;
801026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801026cb:	83 ec 08             	sub    $0x8,%esp
801026ce:	ff 75 10             	pushl  0x10(%ebp)
801026d1:	ff 75 08             	pushl  0x8(%ebp)
801026d4:	e8 6c fe ff ff       	call   80102545 <skipelem>
801026d9:	83 c4 10             	add    $0x10,%esp
801026dc:	89 45 08             	mov    %eax,0x8(%ebp)
801026df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026e3:	0f 85 44 ff ff ff    	jne    8010262d <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026ed:	74 15                	je     80102704 <namex+0x11b>
    iput(ip);
801026ef:	83 ec 0c             	sub    $0xc,%esp
801026f2:	ff 75 f4             	pushl  -0xc(%ebp)
801026f5:	e8 f9 f5 ff ff       	call   80101cf3 <iput>
801026fa:	83 c4 10             	add    $0x10,%esp
    return 0;
801026fd:	b8 00 00 00 00       	mov    $0x0,%eax
80102702:	eb 03                	jmp    80102707 <namex+0x11e>
  }
  return ip;
80102704:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102707:	c9                   	leave  
80102708:	c3                   	ret    

80102709 <namei>:

struct inode*
namei(char *path)
{
80102709:	55                   	push   %ebp
8010270a:	89 e5                	mov    %esp,%ebp
8010270c:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010270f:	83 ec 04             	sub    $0x4,%esp
80102712:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102715:	50                   	push   %eax
80102716:	6a 00                	push   $0x0
80102718:	ff 75 08             	pushl  0x8(%ebp)
8010271b:	e8 c9 fe ff ff       	call   801025e9 <namex>
80102720:	83 c4 10             	add    $0x10,%esp
}
80102723:	c9                   	leave  
80102724:	c3                   	ret    

80102725 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102725:	55                   	push   %ebp
80102726:	89 e5                	mov    %esp,%ebp
80102728:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010272b:	83 ec 04             	sub    $0x4,%esp
8010272e:	ff 75 0c             	pushl  0xc(%ebp)
80102731:	6a 01                	push   $0x1
80102733:	ff 75 08             	pushl  0x8(%ebp)
80102736:	e8 ae fe ff ff       	call   801025e9 <namex>
8010273b:	83 c4 10             	add    $0x10,%esp
}
8010273e:	c9                   	leave  
8010273f:	c3                   	ret    

80102740 <chmod>:

#ifdef CS333_P5
int 
chmod(char *pathname, int mode){
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 18             	sub    $0x18,%esp
  //cprintf("hello");
  //cprintf("%d", mode);
  begin_op();
80102746:	e8 5c 11 00 00       	call   801038a7 <begin_op>
  struct inode* ip = namei(pathname);
8010274b:	83 ec 0c             	sub    $0xc,%esp
8010274e:	ff 75 08             	pushl  0x8(%ebp)
80102751:	e8 b3 ff ff ff       	call   80102709 <namei>
80102756:	83 c4 10             	add    $0x10,%esp
80102759:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(ip != 0){
8010275c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102760:	74 3f                	je     801027a1 <chmod+0x61>
    ilock(ip);
80102762:	83 ec 0c             	sub    $0xc,%esp
80102765:	ff 75 f4             	pushl  -0xc(%ebp)
80102768:	e8 8e f3 ff ff       	call   80101afb <ilock>
8010276d:	83 c4 10             	add    $0x10,%esp
    ip -> mode.asInt = mode;
80102770:	8b 55 0c             	mov    0xc(%ebp),%edx
80102773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102776:	89 50 20             	mov    %edx,0x20(%eax)
    //cprintf("%d", ip->mode.asInt);
    iupdate(ip);
80102779:	83 ec 0c             	sub    $0xc,%esp
8010277c:	ff 75 f4             	pushl  -0xc(%ebp)
8010277f:	e8 75 f1 ff ff       	call   801018f9 <iupdate>
80102784:	83 c4 10             	add    $0x10,%esp
    iunlock(ip);
80102787:	83 ec 0c             	sub    $0xc,%esp
8010278a:	ff 75 f4             	pushl  -0xc(%ebp)
8010278d:	e8 ef f4 ff ff       	call   80101c81 <iunlock>
80102792:	83 c4 10             	add    $0x10,%esp
    end_op();
80102795:	e8 99 11 00 00       	call   80103933 <end_op>
    return 0;
8010279a:	b8 00 00 00 00       	mov    $0x0,%eax
8010279f:	eb 0a                	jmp    801027ab <chmod+0x6b>
  }else{
    end_op();
801027a1:	e8 8d 11 00 00       	call   80103933 <end_op>
    return -1;
801027a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801027ab:	c9                   	leave  
801027ac:	c3                   	ret    

801027ad <chown>:

int chown(char *pathname, int owner){
801027ad:	55                   	push   %ebp
801027ae:	89 e5                	mov    %esp,%ebp
801027b0:	83 ec 18             	sub    $0x18,%esp
  if(owner < 0 || owner > 32767){
801027b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801027b7:	78 09                	js     801027c2 <chown+0x15>
801027b9:	81 7d 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%ebp)
801027c0:	7e 07                	jle    801027c9 <chown+0x1c>
    return -1;
801027c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027c7:	eb 68                	jmp    80102831 <chown+0x84>
  }
  begin_op();
801027c9:	e8 d9 10 00 00       	call   801038a7 <begin_op>
  struct inode* ip = namei(pathname);
801027ce:	83 ec 0c             	sub    $0xc,%esp
801027d1:	ff 75 08             	pushl  0x8(%ebp)
801027d4:	e8 30 ff ff ff       	call   80102709 <namei>
801027d9:	83 c4 10             	add    $0x10,%esp
801027dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip != 0){
801027df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027e3:	74 42                	je     80102827 <chown+0x7a>
    ilock(ip);
801027e5:	83 ec 0c             	sub    $0xc,%esp
801027e8:	ff 75 f4             	pushl  -0xc(%ebp)
801027eb:	e8 0b f3 ff ff       	call   80101afb <ilock>
801027f0:	83 c4 10             	add    $0x10,%esp
    ip -> uid = owner;
801027f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801027f6:	89 c2                	mov    %eax,%edx
801027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fb:	66 89 50 1c          	mov    %dx,0x1c(%eax)
    iupdate(ip);
801027ff:	83 ec 0c             	sub    $0xc,%esp
80102802:	ff 75 f4             	pushl  -0xc(%ebp)
80102805:	e8 ef f0 ff ff       	call   801018f9 <iupdate>
8010280a:	83 c4 10             	add    $0x10,%esp
    iunlock(ip);
8010280d:	83 ec 0c             	sub    $0xc,%esp
80102810:	ff 75 f4             	pushl  -0xc(%ebp)
80102813:	e8 69 f4 ff ff       	call   80101c81 <iunlock>
80102818:	83 c4 10             	add    $0x10,%esp
    end_op();
8010281b:	e8 13 11 00 00       	call   80103933 <end_op>
    return 0;
80102820:	b8 00 00 00 00       	mov    $0x0,%eax
80102825:	eb 0a                	jmp    80102831 <chown+0x84>
  }else{
    end_op();
80102827:	e8 07 11 00 00       	call   80103933 <end_op>
    return -1;
8010282c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
80102831:	c9                   	leave  
80102832:	c3                   	ret    

80102833 <chgrp>:

int chgrp(char *pathname, int group){
80102833:	55                   	push   %ebp
80102834:	89 e5                	mov    %esp,%ebp
80102836:	83 ec 18             	sub    $0x18,%esp
  if(group < 0 || group > 32767){
80102839:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010283d:	78 09                	js     80102848 <chgrp+0x15>
8010283f:	81 7d 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%ebp)
80102846:	7e 07                	jle    8010284f <chgrp+0x1c>
    return -1;
80102848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010284d:	eb 68                	jmp    801028b7 <chgrp+0x84>
  }
  begin_op();
8010284f:	e8 53 10 00 00       	call   801038a7 <begin_op>
  struct inode* ip = namei(pathname);
80102854:	83 ec 0c             	sub    $0xc,%esp
80102857:	ff 75 08             	pushl  0x8(%ebp)
8010285a:	e8 aa fe ff ff       	call   80102709 <namei>
8010285f:	83 c4 10             	add    $0x10,%esp
80102862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip != 0){
80102865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102869:	74 42                	je     801028ad <chgrp+0x7a>
    ilock(ip);
8010286b:	83 ec 0c             	sub    $0xc,%esp
8010286e:	ff 75 f4             	pushl  -0xc(%ebp)
80102871:	e8 85 f2 ff ff       	call   80101afb <ilock>
80102876:	83 c4 10             	add    $0x10,%esp
    ip -> gid = group;
80102879:	8b 45 0c             	mov    0xc(%ebp),%eax
8010287c:	89 c2                	mov    %eax,%edx
8010287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102881:	66 89 50 1e          	mov    %dx,0x1e(%eax)
    iupdate(ip);
80102885:	83 ec 0c             	sub    $0xc,%esp
80102888:	ff 75 f4             	pushl  -0xc(%ebp)
8010288b:	e8 69 f0 ff ff       	call   801018f9 <iupdate>
80102890:	83 c4 10             	add    $0x10,%esp
    iunlock(ip);
80102893:	83 ec 0c             	sub    $0xc,%esp
80102896:	ff 75 f4             	pushl  -0xc(%ebp)
80102899:	e8 e3 f3 ff ff       	call   80101c81 <iunlock>
8010289e:	83 c4 10             	add    $0x10,%esp
    end_op();
801028a1:	e8 8d 10 00 00       	call   80103933 <end_op>
    return 0;
801028a6:	b8 00 00 00 00       	mov    $0x0,%eax
801028ab:	eb 0a                	jmp    801028b7 <chgrp+0x84>
  }else{
    end_op();
801028ad:	e8 81 10 00 00       	call   80103933 <end_op>
    return -1;
801028b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
}
801028b7:	c9                   	leave  
801028b8:	c3                   	ret    

801028b9 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801028b9:	55                   	push   %ebp
801028ba:	89 e5                	mov    %esp,%ebp
801028bc:	83 ec 14             	sub    $0x14,%esp
801028bf:	8b 45 08             	mov    0x8(%ebp),%eax
801028c2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801028ca:	89 c2                	mov    %eax,%edx
801028cc:	ec                   	in     (%dx),%al
801028cd:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801028d0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801028d4:	c9                   	leave  
801028d5:	c3                   	ret    

801028d6 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801028d6:	55                   	push   %ebp
801028d7:	89 e5                	mov    %esp,%ebp
801028d9:	57                   	push   %edi
801028da:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801028db:	8b 55 08             	mov    0x8(%ebp),%edx
801028de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028e1:	8b 45 10             	mov    0x10(%ebp),%eax
801028e4:	89 cb                	mov    %ecx,%ebx
801028e6:	89 df                	mov    %ebx,%edi
801028e8:	89 c1                	mov    %eax,%ecx
801028ea:	fc                   	cld    
801028eb:	f3 6d                	rep insl (%dx),%es:(%edi)
801028ed:	89 c8                	mov    %ecx,%eax
801028ef:	89 fb                	mov    %edi,%ebx
801028f1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028f4:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801028f7:	90                   	nop
801028f8:	5b                   	pop    %ebx
801028f9:	5f                   	pop    %edi
801028fa:	5d                   	pop    %ebp
801028fb:	c3                   	ret    

801028fc <outb>:

static inline void
outb(ushort port, uchar data)
{
801028fc:	55                   	push   %ebp
801028fd:	89 e5                	mov    %esp,%ebp
801028ff:	83 ec 08             	sub    $0x8,%esp
80102902:	8b 55 08             	mov    0x8(%ebp),%edx
80102905:	8b 45 0c             	mov    0xc(%ebp),%eax
80102908:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010290c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102913:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102917:	ee                   	out    %al,(%dx)
}
80102918:	90                   	nop
80102919:	c9                   	leave  
8010291a:	c3                   	ret    

8010291b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010291b:	55                   	push   %ebp
8010291c:	89 e5                	mov    %esp,%ebp
8010291e:	56                   	push   %esi
8010291f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102920:	8b 55 08             	mov    0x8(%ebp),%edx
80102923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102926:	8b 45 10             	mov    0x10(%ebp),%eax
80102929:	89 cb                	mov    %ecx,%ebx
8010292b:	89 de                	mov    %ebx,%esi
8010292d:	89 c1                	mov    %eax,%ecx
8010292f:	fc                   	cld    
80102930:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102932:	89 c8                	mov    %ecx,%eax
80102934:	89 f3                	mov    %esi,%ebx
80102936:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102939:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010293c:	90                   	nop
8010293d:	5b                   	pop    %ebx
8010293e:	5e                   	pop    %esi
8010293f:	5d                   	pop    %ebp
80102940:	c3                   	ret    

80102941 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102941:	55                   	push   %ebp
80102942:	89 e5                	mov    %esp,%ebp
80102944:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102947:	90                   	nop
80102948:	68 f7 01 00 00       	push   $0x1f7
8010294d:	e8 67 ff ff ff       	call   801028b9 <inb>
80102952:	83 c4 04             	add    $0x4,%esp
80102955:	0f b6 c0             	movzbl %al,%eax
80102958:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010295b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010295e:	25 c0 00 00 00       	and    $0xc0,%eax
80102963:	83 f8 40             	cmp    $0x40,%eax
80102966:	75 e0                	jne    80102948 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102968:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010296c:	74 11                	je     8010297f <idewait+0x3e>
8010296e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102971:	83 e0 21             	and    $0x21,%eax
80102974:	85 c0                	test   %eax,%eax
80102976:	74 07                	je     8010297f <idewait+0x3e>
    return -1;
80102978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010297d:	eb 05                	jmp    80102984 <idewait+0x43>
  return 0;
8010297f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102984:	c9                   	leave  
80102985:	c3                   	ret    

80102986 <ideinit>:

void
ideinit(void)
{
80102986:	55                   	push   %ebp
80102987:	89 e5                	mov    %esp,%ebp
80102989:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
8010298c:	83 ec 08             	sub    $0x8,%esp
8010298f:	68 1a 9f 10 80       	push   $0x80109f1a
80102994:	68 40 d6 10 80       	push   $0x8010d640
80102999:	e8 75 3b 00 00       	call   80106513 <initlock>
8010299e:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801029a1:	83 ec 0c             	sub    $0xc,%esp
801029a4:	6a 0e                	push   $0xe
801029a6:	e8 da 18 00 00       	call   80104285 <picenable>
801029ab:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801029ae:	a1 80 49 11 80       	mov    0x80114980,%eax
801029b3:	83 e8 01             	sub    $0x1,%eax
801029b6:	83 ec 08             	sub    $0x8,%esp
801029b9:	50                   	push   %eax
801029ba:	6a 0e                	push   $0xe
801029bc:	e8 73 04 00 00       	call   80102e34 <ioapicenable>
801029c1:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801029c4:	83 ec 0c             	sub    $0xc,%esp
801029c7:	6a 00                	push   $0x0
801029c9:	e8 73 ff ff ff       	call   80102941 <idewait>
801029ce:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801029d1:	83 ec 08             	sub    $0x8,%esp
801029d4:	68 f0 00 00 00       	push   $0xf0
801029d9:	68 f6 01 00 00       	push   $0x1f6
801029de:	e8 19 ff ff ff       	call   801028fc <outb>
801029e3:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801029e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029ed:	eb 24                	jmp    80102a13 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801029ef:	83 ec 0c             	sub    $0xc,%esp
801029f2:	68 f7 01 00 00       	push   $0x1f7
801029f7:	e8 bd fe ff ff       	call   801028b9 <inb>
801029fc:	83 c4 10             	add    $0x10,%esp
801029ff:	84 c0                	test   %al,%al
80102a01:	74 0c                	je     80102a0f <ideinit+0x89>
      havedisk1 = 1;
80102a03:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
80102a0a:	00 00 00 
      break;
80102a0d:	eb 0d                	jmp    80102a1c <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102a0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a13:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102a1a:	7e d3                	jle    801029ef <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102a1c:	83 ec 08             	sub    $0x8,%esp
80102a1f:	68 e0 00 00 00       	push   $0xe0
80102a24:	68 f6 01 00 00       	push   $0x1f6
80102a29:	e8 ce fe ff ff       	call   801028fc <outb>
80102a2e:	83 c4 10             	add    $0x10,%esp
}
80102a31:	90                   	nop
80102a32:	c9                   	leave  
80102a33:	c3                   	ret    

80102a34 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
80102a37:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102a3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102a3e:	75 0d                	jne    80102a4d <idestart+0x19>
    panic("idestart");
80102a40:	83 ec 0c             	sub    $0xc,%esp
80102a43:	68 1e 9f 10 80       	push   $0x80109f1e
80102a48:	e8 19 db ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102a50:	8b 40 08             	mov    0x8(%eax),%eax
80102a53:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102a58:	76 0d                	jbe    80102a67 <idestart+0x33>
    panic("incorrect blockno");
80102a5a:	83 ec 0c             	sub    $0xc,%esp
80102a5d:	68 27 9f 10 80       	push   $0x80109f27
80102a62:	e8 ff da ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102a67:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	8b 50 08             	mov    0x8(%eax),%edx
80102a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a77:	0f af c2             	imul   %edx,%eax
80102a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102a7d:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102a81:	7e 0d                	jle    80102a90 <idestart+0x5c>
80102a83:	83 ec 0c             	sub    $0xc,%esp
80102a86:	68 1e 9f 10 80       	push   $0x80109f1e
80102a8b:	e8 d6 da ff ff       	call   80100566 <panic>
  
  idewait(0);
80102a90:	83 ec 0c             	sub    $0xc,%esp
80102a93:	6a 00                	push   $0x0
80102a95:	e8 a7 fe ff ff       	call   80102941 <idewait>
80102a9a:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102a9d:	83 ec 08             	sub    $0x8,%esp
80102aa0:	6a 00                	push   $0x0
80102aa2:	68 f6 03 00 00       	push   $0x3f6
80102aa7:	e8 50 fe ff ff       	call   801028fc <outb>
80102aac:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab2:	0f b6 c0             	movzbl %al,%eax
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	50                   	push   %eax
80102ab9:	68 f2 01 00 00       	push   $0x1f2
80102abe:	e8 39 fe ff ff       	call   801028fc <outb>
80102ac3:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ac9:	0f b6 c0             	movzbl %al,%eax
80102acc:	83 ec 08             	sub    $0x8,%esp
80102acf:	50                   	push   %eax
80102ad0:	68 f3 01 00 00       	push   $0x1f3
80102ad5:	e8 22 fe ff ff       	call   801028fc <outb>
80102ada:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102add:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ae0:	c1 f8 08             	sar    $0x8,%eax
80102ae3:	0f b6 c0             	movzbl %al,%eax
80102ae6:	83 ec 08             	sub    $0x8,%esp
80102ae9:	50                   	push   %eax
80102aea:	68 f4 01 00 00       	push   $0x1f4
80102aef:	e8 08 fe ff ff       	call   801028fc <outb>
80102af4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102afa:	c1 f8 10             	sar    $0x10,%eax
80102afd:	0f b6 c0             	movzbl %al,%eax
80102b00:	83 ec 08             	sub    $0x8,%esp
80102b03:	50                   	push   %eax
80102b04:	68 f5 01 00 00       	push   $0x1f5
80102b09:	e8 ee fd ff ff       	call   801028fc <outb>
80102b0e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102b11:	8b 45 08             	mov    0x8(%ebp),%eax
80102b14:	8b 40 04             	mov    0x4(%eax),%eax
80102b17:	83 e0 01             	and    $0x1,%eax
80102b1a:	c1 e0 04             	shl    $0x4,%eax
80102b1d:	89 c2                	mov    %eax,%edx
80102b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b22:	c1 f8 18             	sar    $0x18,%eax
80102b25:	83 e0 0f             	and    $0xf,%eax
80102b28:	09 d0                	or     %edx,%eax
80102b2a:	83 c8 e0             	or     $0xffffffe0,%eax
80102b2d:	0f b6 c0             	movzbl %al,%eax
80102b30:	83 ec 08             	sub    $0x8,%esp
80102b33:	50                   	push   %eax
80102b34:	68 f6 01 00 00       	push   $0x1f6
80102b39:	e8 be fd ff ff       	call   801028fc <outb>
80102b3e:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102b41:	8b 45 08             	mov    0x8(%ebp),%eax
80102b44:	8b 00                	mov    (%eax),%eax
80102b46:	83 e0 04             	and    $0x4,%eax
80102b49:	85 c0                	test   %eax,%eax
80102b4b:	74 30                	je     80102b7d <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102b4d:	83 ec 08             	sub    $0x8,%esp
80102b50:	6a 30                	push   $0x30
80102b52:	68 f7 01 00 00       	push   $0x1f7
80102b57:	e8 a0 fd ff ff       	call   801028fc <outb>
80102b5c:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b62:	83 c0 18             	add    $0x18,%eax
80102b65:	83 ec 04             	sub    $0x4,%esp
80102b68:	68 80 00 00 00       	push   $0x80
80102b6d:	50                   	push   %eax
80102b6e:	68 f0 01 00 00       	push   $0x1f0
80102b73:	e8 a3 fd ff ff       	call   8010291b <outsl>
80102b78:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102b7b:	eb 12                	jmp    80102b8f <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102b7d:	83 ec 08             	sub    $0x8,%esp
80102b80:	6a 20                	push   $0x20
80102b82:	68 f7 01 00 00       	push   $0x1f7
80102b87:	e8 70 fd ff ff       	call   801028fc <outb>
80102b8c:	83 c4 10             	add    $0x10,%esp
  }
}
80102b8f:	90                   	nop
80102b90:	c9                   	leave  
80102b91:	c3                   	ret    

80102b92 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b92:	55                   	push   %ebp
80102b93:	89 e5                	mov    %esp,%ebp
80102b95:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b98:	83 ec 0c             	sub    $0xc,%esp
80102b9b:	68 40 d6 10 80       	push   $0x8010d640
80102ba0:	e8 90 39 00 00       	call   80106535 <acquire>
80102ba5:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102ba8:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bb4:	75 15                	jne    80102bcb <ideintr+0x39>
    release(&idelock);
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	68 40 d6 10 80       	push   $0x8010d640
80102bbe:	e8 d9 39 00 00       	call   8010659c <release>
80102bc3:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102bc6:	e9 9a 00 00 00       	jmp    80102c65 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bce:	8b 40 14             	mov    0x14(%eax),%eax
80102bd1:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd9:	8b 00                	mov    (%eax),%eax
80102bdb:	83 e0 04             	and    $0x4,%eax
80102bde:	85 c0                	test   %eax,%eax
80102be0:	75 2d                	jne    80102c0f <ideintr+0x7d>
80102be2:	83 ec 0c             	sub    $0xc,%esp
80102be5:	6a 01                	push   $0x1
80102be7:	e8 55 fd ff ff       	call   80102941 <idewait>
80102bec:	83 c4 10             	add    $0x10,%esp
80102bef:	85 c0                	test   %eax,%eax
80102bf1:	78 1c                	js     80102c0f <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf6:	83 c0 18             	add    $0x18,%eax
80102bf9:	83 ec 04             	sub    $0x4,%esp
80102bfc:	68 80 00 00 00       	push   $0x80
80102c01:	50                   	push   %eax
80102c02:	68 f0 01 00 00       	push   $0x1f0
80102c07:	e8 ca fc ff ff       	call   801028d6 <insl>
80102c0c:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c12:	8b 00                	mov    (%eax),%eax
80102c14:	83 c8 02             	or     $0x2,%eax
80102c17:	89 c2                	mov    %eax,%edx
80102c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c1c:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c21:	8b 00                	mov    (%eax),%eax
80102c23:	83 e0 fb             	and    $0xfffffffb,%eax
80102c26:	89 c2                	mov    %eax,%edx
80102c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102c2d:	83 ec 0c             	sub    $0xc,%esp
80102c30:	ff 75 f4             	pushl  -0xc(%ebp)
80102c33:	e8 5c 2c 00 00       	call   80105894 <wakeup>
80102c38:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102c3b:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c40:	85 c0                	test   %eax,%eax
80102c42:	74 11                	je     80102c55 <ideintr+0xc3>
    idestart(idequeue);
80102c44:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c49:	83 ec 0c             	sub    $0xc,%esp
80102c4c:	50                   	push   %eax
80102c4d:	e8 e2 fd ff ff       	call   80102a34 <idestart>
80102c52:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102c55:	83 ec 0c             	sub    $0xc,%esp
80102c58:	68 40 d6 10 80       	push   $0x8010d640
80102c5d:	e8 3a 39 00 00       	call   8010659c <release>
80102c62:	83 c4 10             	add    $0x10,%esp
}
80102c65:	c9                   	leave  
80102c66:	c3                   	ret    

80102c67 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102c67:	55                   	push   %ebp
80102c68:	89 e5                	mov    %esp,%ebp
80102c6a:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c70:	8b 00                	mov    (%eax),%eax
80102c72:	83 e0 01             	and    $0x1,%eax
80102c75:	85 c0                	test   %eax,%eax
80102c77:	75 0d                	jne    80102c86 <iderw+0x1f>
    panic("iderw: buf not busy");
80102c79:	83 ec 0c             	sub    $0xc,%esp
80102c7c:	68 39 9f 10 80       	push   $0x80109f39
80102c81:	e8 e0 d8 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c86:	8b 45 08             	mov    0x8(%ebp),%eax
80102c89:	8b 00                	mov    (%eax),%eax
80102c8b:	83 e0 06             	and    $0x6,%eax
80102c8e:	83 f8 02             	cmp    $0x2,%eax
80102c91:	75 0d                	jne    80102ca0 <iderw+0x39>
    panic("iderw: nothing to do");
80102c93:	83 ec 0c             	sub    $0xc,%esp
80102c96:	68 4d 9f 10 80       	push   $0x80109f4d
80102c9b:	e8 c6 d8 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ca3:	8b 40 04             	mov    0x4(%eax),%eax
80102ca6:	85 c0                	test   %eax,%eax
80102ca8:	74 16                	je     80102cc0 <iderw+0x59>
80102caa:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102caf:	85 c0                	test   %eax,%eax
80102cb1:	75 0d                	jne    80102cc0 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102cb3:	83 ec 0c             	sub    $0xc,%esp
80102cb6:	68 62 9f 10 80       	push   $0x80109f62
80102cbb:	e8 a6 d8 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102cc0:	83 ec 0c             	sub    $0xc,%esp
80102cc3:	68 40 d6 10 80       	push   $0x8010d640
80102cc8:	e8 68 38 00 00       	call   80106535 <acquire>
80102ccd:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102cda:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102ce1:	eb 0b                	jmp    80102cee <iderw+0x87>
80102ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce6:	8b 00                	mov    (%eax),%eax
80102ce8:	83 c0 14             	add    $0x14,%eax
80102ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf1:	8b 00                	mov    (%eax),%eax
80102cf3:	85 c0                	test   %eax,%eax
80102cf5:	75 ec                	jne    80102ce3 <iderw+0x7c>
    ;
  *pp = b;
80102cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cfa:	8b 55 08             	mov    0x8(%ebp),%edx
80102cfd:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102cff:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102d04:	3b 45 08             	cmp    0x8(%ebp),%eax
80102d07:	75 23                	jne    80102d2c <iderw+0xc5>
    idestart(b);
80102d09:	83 ec 0c             	sub    $0xc,%esp
80102d0c:	ff 75 08             	pushl  0x8(%ebp)
80102d0f:	e8 20 fd ff ff       	call   80102a34 <idestart>
80102d14:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d17:	eb 13                	jmp    80102d2c <iderw+0xc5>
    sleep(b, &idelock);
80102d19:	83 ec 08             	sub    $0x8,%esp
80102d1c:	68 40 d6 10 80       	push   $0x8010d640
80102d21:	ff 75 08             	pushl  0x8(%ebp)
80102d24:	e8 3a 29 00 00       	call   80105663 <sleep>
80102d29:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d2f:	8b 00                	mov    (%eax),%eax
80102d31:	83 e0 06             	and    $0x6,%eax
80102d34:	83 f8 02             	cmp    $0x2,%eax
80102d37:	75 e0                	jne    80102d19 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102d39:	83 ec 0c             	sub    $0xc,%esp
80102d3c:	68 40 d6 10 80       	push   $0x8010d640
80102d41:	e8 56 38 00 00       	call   8010659c <release>
80102d46:	83 c4 10             	add    $0x10,%esp
}
80102d49:	90                   	nop
80102d4a:	c9                   	leave  
80102d4b:	c3                   	ret    

80102d4c <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102d4c:	55                   	push   %ebp
80102d4d:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d4f:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d54:	8b 55 08             	mov    0x8(%ebp),%edx
80102d57:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102d59:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d5e:	8b 40 10             	mov    0x10(%eax),%eax
}
80102d61:	5d                   	pop    %ebp
80102d62:	c3                   	ret    

80102d63 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102d63:	55                   	push   %ebp
80102d64:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d66:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d6b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d6e:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102d70:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d75:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d78:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d7b:	90                   	nop
80102d7c:	5d                   	pop    %ebp
80102d7d:	c3                   	ret    

80102d7e <ioapicinit>:

void
ioapicinit(void)
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102d84:	a1 84 43 11 80       	mov    0x80114384,%eax
80102d89:	85 c0                	test   %eax,%eax
80102d8b:	0f 84 a0 00 00 00    	je     80102e31 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d91:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102d98:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d9b:	6a 01                	push   $0x1
80102d9d:	e8 aa ff ff ff       	call   80102d4c <ioapicread>
80102da2:	83 c4 04             	add    $0x4,%esp
80102da5:	c1 e8 10             	shr    $0x10,%eax
80102da8:	25 ff 00 00 00       	and    $0xff,%eax
80102dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102db0:	6a 00                	push   $0x0
80102db2:	e8 95 ff ff ff       	call   80102d4c <ioapicread>
80102db7:	83 c4 04             	add    $0x4,%esp
80102dba:	c1 e8 18             	shr    $0x18,%eax
80102dbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102dc0:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102dc7:	0f b6 c0             	movzbl %al,%eax
80102dca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102dcd:	74 10                	je     80102ddf <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102dcf:	83 ec 0c             	sub    $0xc,%esp
80102dd2:	68 80 9f 10 80       	push   $0x80109f80
80102dd7:	e8 ea d5 ff ff       	call   801003c6 <cprintf>
80102ddc:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ddf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102de6:	eb 3f                	jmp    80102e27 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102deb:	83 c0 20             	add    $0x20,%eax
80102dee:	0d 00 00 01 00       	or     $0x10000,%eax
80102df3:	89 c2                	mov    %eax,%edx
80102df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df8:	83 c0 08             	add    $0x8,%eax
80102dfb:	01 c0                	add    %eax,%eax
80102dfd:	83 ec 08             	sub    $0x8,%esp
80102e00:	52                   	push   %edx
80102e01:	50                   	push   %eax
80102e02:	e8 5c ff ff ff       	call   80102d63 <ioapicwrite>
80102e07:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e0d:	83 c0 08             	add    $0x8,%eax
80102e10:	01 c0                	add    %eax,%eax
80102e12:	83 c0 01             	add    $0x1,%eax
80102e15:	83 ec 08             	sub    $0x8,%esp
80102e18:	6a 00                	push   $0x0
80102e1a:	50                   	push   %eax
80102e1b:	e8 43 ff ff ff       	call   80102d63 <ioapicwrite>
80102e20:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e23:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e2a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102e2d:	7e b9                	jle    80102de8 <ioapicinit+0x6a>
80102e2f:	eb 01                	jmp    80102e32 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102e31:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102e32:	c9                   	leave  
80102e33:	c3                   	ret    

80102e34 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102e34:	55                   	push   %ebp
80102e35:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102e37:	a1 84 43 11 80       	mov    0x80114384,%eax
80102e3c:	85 c0                	test   %eax,%eax
80102e3e:	74 39                	je     80102e79 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102e40:	8b 45 08             	mov    0x8(%ebp),%eax
80102e43:	83 c0 20             	add    $0x20,%eax
80102e46:	89 c2                	mov    %eax,%edx
80102e48:	8b 45 08             	mov    0x8(%ebp),%eax
80102e4b:	83 c0 08             	add    $0x8,%eax
80102e4e:	01 c0                	add    %eax,%eax
80102e50:	52                   	push   %edx
80102e51:	50                   	push   %eax
80102e52:	e8 0c ff ff ff       	call   80102d63 <ioapicwrite>
80102e57:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e5d:	c1 e0 18             	shl    $0x18,%eax
80102e60:	89 c2                	mov    %eax,%edx
80102e62:	8b 45 08             	mov    0x8(%ebp),%eax
80102e65:	83 c0 08             	add    $0x8,%eax
80102e68:	01 c0                	add    %eax,%eax
80102e6a:	83 c0 01             	add    $0x1,%eax
80102e6d:	52                   	push   %edx
80102e6e:	50                   	push   %eax
80102e6f:	e8 ef fe ff ff       	call   80102d63 <ioapicwrite>
80102e74:	83 c4 08             	add    $0x8,%esp
80102e77:	eb 01                	jmp    80102e7a <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102e79:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102e7a:	c9                   	leave  
80102e7b:	c3                   	ret    

80102e7c <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102e7c:	55                   	push   %ebp
80102e7d:	89 e5                	mov    %esp,%ebp
80102e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80102e82:	05 00 00 00 80       	add    $0x80000000,%eax
80102e87:	5d                   	pop    %ebp
80102e88:	c3                   	ret    

80102e89 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102e89:	55                   	push   %ebp
80102e8a:	89 e5                	mov    %esp,%ebp
80102e8c:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102e8f:	83 ec 08             	sub    $0x8,%esp
80102e92:	68 b2 9f 10 80       	push   $0x80109fb2
80102e97:	68 60 42 11 80       	push   $0x80114260
80102e9c:	e8 72 36 00 00       	call   80106513 <initlock>
80102ea1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ea4:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
80102eab:	00 00 00 
  freerange(vstart, vend);
80102eae:	83 ec 08             	sub    $0x8,%esp
80102eb1:	ff 75 0c             	pushl  0xc(%ebp)
80102eb4:	ff 75 08             	pushl  0x8(%ebp)
80102eb7:	e8 2a 00 00 00       	call   80102ee6 <freerange>
80102ebc:	83 c4 10             	add    $0x10,%esp
}
80102ebf:	90                   	nop
80102ec0:	c9                   	leave  
80102ec1:	c3                   	ret    

80102ec2 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ec2:	55                   	push   %ebp
80102ec3:	89 e5                	mov    %esp,%ebp
80102ec5:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102ec8:	83 ec 08             	sub    $0x8,%esp
80102ecb:	ff 75 0c             	pushl  0xc(%ebp)
80102ece:	ff 75 08             	pushl  0x8(%ebp)
80102ed1:	e8 10 00 00 00       	call   80102ee6 <freerange>
80102ed6:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ed9:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
80102ee0:	00 00 00 
}
80102ee3:	90                   	nop
80102ee4:	c9                   	leave  
80102ee5:	c3                   	ret    

80102ee6 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ee6:	55                   	push   %ebp
80102ee7:	89 e5                	mov    %esp,%ebp
80102ee9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102eec:	8b 45 08             	mov    0x8(%ebp),%eax
80102eef:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ef4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102efc:	eb 15                	jmp    80102f13 <freerange+0x2d>
    kfree(p);
80102efe:	83 ec 0c             	sub    $0xc,%esp
80102f01:	ff 75 f4             	pushl  -0xc(%ebp)
80102f04:	e8 1a 00 00 00       	call   80102f23 <kfree>
80102f09:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102f0c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f16:	05 00 10 00 00       	add    $0x1000,%eax
80102f1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102f1e:	76 de                	jbe    80102efe <freerange+0x18>
    kfree(p);
}
80102f20:	90                   	nop
80102f21:	c9                   	leave  
80102f22:	c3                   	ret    

80102f23 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f23:	55                   	push   %ebp
80102f24:	89 e5                	mov    %esp,%ebp
80102f26:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102f29:	8b 45 08             	mov    0x8(%ebp),%eax
80102f2c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102f31:	85 c0                	test   %eax,%eax
80102f33:	75 1b                	jne    80102f50 <kfree+0x2d>
80102f35:	81 7d 08 7c 79 11 80 	cmpl   $0x8011797c,0x8(%ebp)
80102f3c:	72 12                	jb     80102f50 <kfree+0x2d>
80102f3e:	ff 75 08             	pushl  0x8(%ebp)
80102f41:	e8 36 ff ff ff       	call   80102e7c <v2p>
80102f46:	83 c4 04             	add    $0x4,%esp
80102f49:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f4e:	76 0d                	jbe    80102f5d <kfree+0x3a>
    panic("kfree");
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 b7 9f 10 80       	push   $0x80109fb7
80102f58:	e8 09 d6 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f5d:	83 ec 04             	sub    $0x4,%esp
80102f60:	68 00 10 00 00       	push   $0x1000
80102f65:	6a 01                	push   $0x1
80102f67:	ff 75 08             	pushl  0x8(%ebp)
80102f6a:	e8 29 38 00 00       	call   80106798 <memset>
80102f6f:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102f72:	a1 94 42 11 80       	mov    0x80114294,%eax
80102f77:	85 c0                	test   %eax,%eax
80102f79:	74 10                	je     80102f8b <kfree+0x68>
    acquire(&kmem.lock);
80102f7b:	83 ec 0c             	sub    $0xc,%esp
80102f7e:	68 60 42 11 80       	push   $0x80114260
80102f83:	e8 ad 35 00 00       	call   80106535 <acquire>
80102f88:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80102f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102f91:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80102f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f9a:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f9f:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102fa4:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fa9:	85 c0                	test   %eax,%eax
80102fab:	74 10                	je     80102fbd <kfree+0x9a>
    release(&kmem.lock);
80102fad:	83 ec 0c             	sub    $0xc,%esp
80102fb0:	68 60 42 11 80       	push   $0x80114260
80102fb5:	e8 e2 35 00 00       	call   8010659c <release>
80102fba:	83 c4 10             	add    $0x10,%esp
}
80102fbd:	90                   	nop
80102fbe:	c9                   	leave  
80102fbf:	c3                   	ret    

80102fc0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102fc6:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fcb:	85 c0                	test   %eax,%eax
80102fcd:	74 10                	je     80102fdf <kalloc+0x1f>
    acquire(&kmem.lock);
80102fcf:	83 ec 0c             	sub    $0xc,%esp
80102fd2:	68 60 42 11 80       	push   $0x80114260
80102fd7:	e8 59 35 00 00       	call   80106535 <acquire>
80102fdc:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102fdf:	a1 98 42 11 80       	mov    0x80114298,%eax
80102fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102feb:	74 0a                	je     80102ff7 <kalloc+0x37>
    kmem.freelist = r->next;
80102fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ff0:	8b 00                	mov    (%eax),%eax
80102ff2:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102ff7:	a1 94 42 11 80       	mov    0x80114294,%eax
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	74 10                	je     80103010 <kalloc+0x50>
    release(&kmem.lock);
80103000:	83 ec 0c             	sub    $0xc,%esp
80103003:	68 60 42 11 80       	push   $0x80114260
80103008:	e8 8f 35 00 00       	call   8010659c <release>
8010300d:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80103010:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103013:	c9                   	leave  
80103014:	c3                   	ret    

80103015 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103015:	55                   	push   %ebp
80103016:	89 e5                	mov    %esp,%ebp
80103018:	83 ec 14             	sub    $0x14,%esp
8010301b:	8b 45 08             	mov    0x8(%ebp),%eax
8010301e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103022:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103026:	89 c2                	mov    %eax,%edx
80103028:	ec                   	in     (%dx),%al
80103029:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010302c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103030:	c9                   	leave  
80103031:	c3                   	ret    

80103032 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103032:	55                   	push   %ebp
80103033:	89 e5                	mov    %esp,%ebp
80103035:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80103038:	6a 64                	push   $0x64
8010303a:	e8 d6 ff ff ff       	call   80103015 <inb>
8010303f:	83 c4 04             	add    $0x4,%esp
80103042:	0f b6 c0             	movzbl %al,%eax
80103045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80103048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010304b:	83 e0 01             	and    $0x1,%eax
8010304e:	85 c0                	test   %eax,%eax
80103050:	75 0a                	jne    8010305c <kbdgetc+0x2a>
    return -1;
80103052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103057:	e9 23 01 00 00       	jmp    8010317f <kbdgetc+0x14d>
  data = inb(KBDATAP);
8010305c:	6a 60                	push   $0x60
8010305e:	e8 b2 ff ff ff       	call   80103015 <inb>
80103063:	83 c4 04             	add    $0x4,%esp
80103066:	0f b6 c0             	movzbl %al,%eax
80103069:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
8010306c:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80103073:	75 17                	jne    8010308c <kbdgetc+0x5a>
    shift |= E0ESC;
80103075:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010307a:	83 c8 40             	or     $0x40,%eax
8010307d:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103082:	b8 00 00 00 00       	mov    $0x0,%eax
80103087:	e9 f3 00 00 00       	jmp    8010317f <kbdgetc+0x14d>
  } else if(data & 0x80){
8010308c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010308f:	25 80 00 00 00       	and    $0x80,%eax
80103094:	85 c0                	test   %eax,%eax
80103096:	74 45                	je     801030dd <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103098:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010309d:	83 e0 40             	and    $0x40,%eax
801030a0:	85 c0                	test   %eax,%eax
801030a2:	75 08                	jne    801030ac <kbdgetc+0x7a>
801030a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030a7:	83 e0 7f             	and    $0x7f,%eax
801030aa:	eb 03                	jmp    801030af <kbdgetc+0x7d>
801030ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
801030b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030b5:	05 20 b0 10 80       	add    $0x8010b020,%eax
801030ba:	0f b6 00             	movzbl (%eax),%eax
801030bd:	83 c8 40             	or     $0x40,%eax
801030c0:	0f b6 c0             	movzbl %al,%eax
801030c3:	f7 d0                	not    %eax
801030c5:	89 c2                	mov    %eax,%edx
801030c7:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030cc:	21 d0                	and    %edx,%eax
801030ce:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
801030d3:	b8 00 00 00 00       	mov    $0x0,%eax
801030d8:	e9 a2 00 00 00       	jmp    8010317f <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801030dd:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030e2:	83 e0 40             	and    $0x40,%eax
801030e5:	85 c0                	test   %eax,%eax
801030e7:	74 14                	je     801030fd <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801030e9:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801030f0:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030f5:	83 e0 bf             	and    $0xffffffbf,%eax
801030f8:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
801030fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103100:	05 20 b0 10 80       	add    $0x8010b020,%eax
80103105:	0f b6 00             	movzbl (%eax),%eax
80103108:	0f b6 d0             	movzbl %al,%edx
8010310b:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103110:	09 d0                	or     %edx,%eax
80103112:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
80103117:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010311a:	05 20 b1 10 80       	add    $0x8010b120,%eax
8010311f:	0f b6 00             	movzbl (%eax),%eax
80103122:	0f b6 d0             	movzbl %al,%edx
80103125:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010312a:	31 d0                	xor    %edx,%eax
8010312c:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
80103131:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103136:	83 e0 03             	and    $0x3,%eax
80103139:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80103140:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103143:	01 d0                	add    %edx,%eax
80103145:	0f b6 00             	movzbl (%eax),%eax
80103148:	0f b6 c0             	movzbl %al,%eax
8010314b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
8010314e:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103153:	83 e0 08             	and    $0x8,%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 22                	je     8010317c <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
8010315a:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
8010315e:	76 0c                	jbe    8010316c <kbdgetc+0x13a>
80103160:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80103164:	77 06                	ja     8010316c <kbdgetc+0x13a>
      c += 'A' - 'a';
80103166:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
8010316a:	eb 10                	jmp    8010317c <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
8010316c:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80103170:	76 0a                	jbe    8010317c <kbdgetc+0x14a>
80103172:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80103176:	77 04                	ja     8010317c <kbdgetc+0x14a>
      c += 'a' - 'A';
80103178:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
8010317c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010317f:	c9                   	leave  
80103180:	c3                   	ret    

80103181 <kbdintr>:

void
kbdintr(void)
{
80103181:	55                   	push   %ebp
80103182:	89 e5                	mov    %esp,%ebp
80103184:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103187:	83 ec 0c             	sub    $0xc,%esp
8010318a:	68 32 30 10 80       	push   $0x80103032
8010318f:	e8 65 d6 ff ff       	call   801007f9 <consoleintr>
80103194:	83 c4 10             	add    $0x10,%esp
}
80103197:	90                   	nop
80103198:	c9                   	leave  
80103199:	c3                   	ret    

8010319a <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010319a:	55                   	push   %ebp
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	83 ec 14             	sub    $0x14,%esp
801031a0:	8b 45 08             	mov    0x8(%ebp),%eax
801031a3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801031ab:	89 c2                	mov    %eax,%edx
801031ad:	ec                   	in     (%dx),%al
801031ae:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801031b1:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801031b5:	c9                   	leave  
801031b6:	c3                   	ret    

801031b7 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801031b7:	55                   	push   %ebp
801031b8:	89 e5                	mov    %esp,%ebp
801031ba:	83 ec 08             	sub    $0x8,%esp
801031bd:	8b 55 08             	mov    0x8(%ebp),%edx
801031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801031c3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801031c7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ca:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801031ce:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801031d2:	ee                   	out    %al,(%dx)
}
801031d3:	90                   	nop
801031d4:	c9                   	leave  
801031d5:	c3                   	ret    

801031d6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801031d6:	55                   	push   %ebp
801031d7:	89 e5                	mov    %esp,%ebp
801031d9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031dc:	9c                   	pushf  
801031dd:	58                   	pop    %eax
801031de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801031e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801031e4:	c9                   	leave  
801031e5:	c3                   	ret    

801031e6 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801031e6:	55                   	push   %ebp
801031e7:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801031e9:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031ee:	8b 55 08             	mov    0x8(%ebp),%edx
801031f1:	c1 e2 02             	shl    $0x2,%edx
801031f4:	01 c2                	add    %eax,%edx
801031f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801031f9:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801031fb:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103200:	83 c0 20             	add    $0x20,%eax
80103203:	8b 00                	mov    (%eax),%eax
}
80103205:	90                   	nop
80103206:	5d                   	pop    %ebp
80103207:	c3                   	ret    

80103208 <lapicinit>:

void
lapicinit(void)
{
80103208:	55                   	push   %ebp
80103209:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
8010320b:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103210:	85 c0                	test   %eax,%eax
80103212:	0f 84 0b 01 00 00    	je     80103323 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103218:	68 3f 01 00 00       	push   $0x13f
8010321d:	6a 3c                	push   $0x3c
8010321f:	e8 c2 ff ff ff       	call   801031e6 <lapicw>
80103224:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103227:	6a 0b                	push   $0xb
80103229:	68 f8 00 00 00       	push   $0xf8
8010322e:	e8 b3 ff ff ff       	call   801031e6 <lapicw>
80103233:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103236:	68 20 00 02 00       	push   $0x20020
8010323b:	68 c8 00 00 00       	push   $0xc8
80103240:	e8 a1 ff ff ff       	call   801031e6 <lapicw>
80103245:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80103248:	68 40 42 0f 00       	push   $0xf4240
8010324d:	68 e0 00 00 00       	push   $0xe0
80103252:	e8 8f ff ff ff       	call   801031e6 <lapicw>
80103257:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
8010325a:	68 00 00 01 00       	push   $0x10000
8010325f:	68 d4 00 00 00       	push   $0xd4
80103264:	e8 7d ff ff ff       	call   801031e6 <lapicw>
80103269:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
8010326c:	68 00 00 01 00       	push   $0x10000
80103271:	68 d8 00 00 00       	push   $0xd8
80103276:	e8 6b ff ff ff       	call   801031e6 <lapicw>
8010327b:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010327e:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103283:	83 c0 30             	add    $0x30,%eax
80103286:	8b 00                	mov    (%eax),%eax
80103288:	c1 e8 10             	shr    $0x10,%eax
8010328b:	0f b6 c0             	movzbl %al,%eax
8010328e:	83 f8 03             	cmp    $0x3,%eax
80103291:	76 12                	jbe    801032a5 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103293:	68 00 00 01 00       	push   $0x10000
80103298:	68 d0 00 00 00       	push   $0xd0
8010329d:	e8 44 ff ff ff       	call   801031e6 <lapicw>
801032a2:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801032a5:	6a 33                	push   $0x33
801032a7:	68 dc 00 00 00       	push   $0xdc
801032ac:	e8 35 ff ff ff       	call   801031e6 <lapicw>
801032b1:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801032b4:	6a 00                	push   $0x0
801032b6:	68 a0 00 00 00       	push   $0xa0
801032bb:	e8 26 ff ff ff       	call   801031e6 <lapicw>
801032c0:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801032c3:	6a 00                	push   $0x0
801032c5:	68 a0 00 00 00       	push   $0xa0
801032ca:	e8 17 ff ff ff       	call   801031e6 <lapicw>
801032cf:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801032d2:	6a 00                	push   $0x0
801032d4:	6a 2c                	push   $0x2c
801032d6:	e8 0b ff ff ff       	call   801031e6 <lapicw>
801032db:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801032de:	6a 00                	push   $0x0
801032e0:	68 c4 00 00 00       	push   $0xc4
801032e5:	e8 fc fe ff ff       	call   801031e6 <lapicw>
801032ea:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801032ed:	68 00 85 08 00       	push   $0x88500
801032f2:	68 c0 00 00 00       	push   $0xc0
801032f7:	e8 ea fe ff ff       	call   801031e6 <lapicw>
801032fc:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801032ff:	90                   	nop
80103300:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103305:	05 00 03 00 00       	add    $0x300,%eax
8010330a:	8b 00                	mov    (%eax),%eax
8010330c:	25 00 10 00 00       	and    $0x1000,%eax
80103311:	85 c0                	test   %eax,%eax
80103313:	75 eb                	jne    80103300 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103315:	6a 00                	push   $0x0
80103317:	6a 20                	push   $0x20
80103319:	e8 c8 fe ff ff       	call   801031e6 <lapicw>
8010331e:	83 c4 08             	add    $0x8,%esp
80103321:	eb 01                	jmp    80103324 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103323:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103324:	c9                   	leave  
80103325:	c3                   	ret    

80103326 <cpunum>:

int
cpunum(void)
{
80103326:	55                   	push   %ebp
80103327:	89 e5                	mov    %esp,%ebp
80103329:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010332c:	e8 a5 fe ff ff       	call   801031d6 <readeflags>
80103331:	25 00 02 00 00       	and    $0x200,%eax
80103336:	85 c0                	test   %eax,%eax
80103338:	74 26                	je     80103360 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010333a:	a1 80 d6 10 80       	mov    0x8010d680,%eax
8010333f:	8d 50 01             	lea    0x1(%eax),%edx
80103342:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
80103348:	85 c0                	test   %eax,%eax
8010334a:	75 14                	jne    80103360 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
8010334c:	8b 45 04             	mov    0x4(%ebp),%eax
8010334f:	83 ec 08             	sub    $0x8,%esp
80103352:	50                   	push   %eax
80103353:	68 c0 9f 10 80       	push   $0x80109fc0
80103358:	e8 69 d0 ff ff       	call   801003c6 <cprintf>
8010335d:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103360:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103365:	85 c0                	test   %eax,%eax
80103367:	74 0f                	je     80103378 <cpunum+0x52>
    return lapic[ID]>>24;
80103369:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010336e:	83 c0 20             	add    $0x20,%eax
80103371:	8b 00                	mov    (%eax),%eax
80103373:	c1 e8 18             	shr    $0x18,%eax
80103376:	eb 05                	jmp    8010337d <cpunum+0x57>
  return 0;
80103378:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010337d:	c9                   	leave  
8010337e:	c3                   	ret    

8010337f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010337f:	55                   	push   %ebp
80103380:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103382:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103387:	85 c0                	test   %eax,%eax
80103389:	74 0c                	je     80103397 <lapiceoi+0x18>
    lapicw(EOI, 0);
8010338b:	6a 00                	push   $0x0
8010338d:	6a 2c                	push   $0x2c
8010338f:	e8 52 fe ff ff       	call   801031e6 <lapicw>
80103394:	83 c4 08             	add    $0x8,%esp
}
80103397:	90                   	nop
80103398:	c9                   	leave  
80103399:	c3                   	ret    

8010339a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010339a:	55                   	push   %ebp
8010339b:	89 e5                	mov    %esp,%ebp
}
8010339d:	90                   	nop
8010339e:	5d                   	pop    %ebp
8010339f:	c3                   	ret    

801033a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	83 ec 14             	sub    $0x14,%esp
801033a6:	8b 45 08             	mov    0x8(%ebp),%eax
801033a9:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801033ac:	6a 0f                	push   $0xf
801033ae:	6a 70                	push   $0x70
801033b0:	e8 02 fe ff ff       	call   801031b7 <outb>
801033b5:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801033b8:	6a 0a                	push   $0xa
801033ba:	6a 71                	push   $0x71
801033bc:	e8 f6 fd ff ff       	call   801031b7 <outb>
801033c1:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801033c4:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801033cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033ce:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801033d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033d6:	83 c0 02             	add    $0x2,%eax
801033d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801033dc:	c1 ea 04             	shr    $0x4,%edx
801033df:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033e2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033e6:	c1 e0 18             	shl    $0x18,%eax
801033e9:	50                   	push   %eax
801033ea:	68 c4 00 00 00       	push   $0xc4
801033ef:	e8 f2 fd ff ff       	call   801031e6 <lapicw>
801033f4:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801033f7:	68 00 c5 00 00       	push   $0xc500
801033fc:	68 c0 00 00 00       	push   $0xc0
80103401:	e8 e0 fd ff ff       	call   801031e6 <lapicw>
80103406:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103409:	68 c8 00 00 00       	push   $0xc8
8010340e:	e8 87 ff ff ff       	call   8010339a <microdelay>
80103413:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103416:	68 00 85 00 00       	push   $0x8500
8010341b:	68 c0 00 00 00       	push   $0xc0
80103420:	e8 c1 fd ff ff       	call   801031e6 <lapicw>
80103425:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103428:	6a 64                	push   $0x64
8010342a:	e8 6b ff ff ff       	call   8010339a <microdelay>
8010342f:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103432:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103439:	eb 3d                	jmp    80103478 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010343b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010343f:	c1 e0 18             	shl    $0x18,%eax
80103442:	50                   	push   %eax
80103443:	68 c4 00 00 00       	push   $0xc4
80103448:	e8 99 fd ff ff       	call   801031e6 <lapicw>
8010344d:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103450:	8b 45 0c             	mov    0xc(%ebp),%eax
80103453:	c1 e8 0c             	shr    $0xc,%eax
80103456:	80 cc 06             	or     $0x6,%ah
80103459:	50                   	push   %eax
8010345a:	68 c0 00 00 00       	push   $0xc0
8010345f:	e8 82 fd ff ff       	call   801031e6 <lapicw>
80103464:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103467:	68 c8 00 00 00       	push   $0xc8
8010346c:	e8 29 ff ff ff       	call   8010339a <microdelay>
80103471:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103474:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103478:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010347c:	7e bd                	jle    8010343b <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010347e:	90                   	nop
8010347f:	c9                   	leave  
80103480:	c3                   	ret    

80103481 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103481:	55                   	push   %ebp
80103482:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103484:	8b 45 08             	mov    0x8(%ebp),%eax
80103487:	0f b6 c0             	movzbl %al,%eax
8010348a:	50                   	push   %eax
8010348b:	6a 70                	push   $0x70
8010348d:	e8 25 fd ff ff       	call   801031b7 <outb>
80103492:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103495:	68 c8 00 00 00       	push   $0xc8
8010349a:	e8 fb fe ff ff       	call   8010339a <microdelay>
8010349f:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801034a2:	6a 71                	push   $0x71
801034a4:	e8 f1 fc ff ff       	call   8010319a <inb>
801034a9:	83 c4 04             	add    $0x4,%esp
801034ac:	0f b6 c0             	movzbl %al,%eax
}
801034af:	c9                   	leave  
801034b0:	c3                   	ret    

801034b1 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801034b1:	55                   	push   %ebp
801034b2:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801034b4:	6a 00                	push   $0x0
801034b6:	e8 c6 ff ff ff       	call   80103481 <cmos_read>
801034bb:	83 c4 04             	add    $0x4,%esp
801034be:	89 c2                	mov    %eax,%edx
801034c0:	8b 45 08             	mov    0x8(%ebp),%eax
801034c3:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801034c5:	6a 02                	push   $0x2
801034c7:	e8 b5 ff ff ff       	call   80103481 <cmos_read>
801034cc:	83 c4 04             	add    $0x4,%esp
801034cf:	89 c2                	mov    %eax,%edx
801034d1:	8b 45 08             	mov    0x8(%ebp),%eax
801034d4:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801034d7:	6a 04                	push   $0x4
801034d9:	e8 a3 ff ff ff       	call   80103481 <cmos_read>
801034de:	83 c4 04             	add    $0x4,%esp
801034e1:	89 c2                	mov    %eax,%edx
801034e3:	8b 45 08             	mov    0x8(%ebp),%eax
801034e6:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801034e9:	6a 07                	push   $0x7
801034eb:	e8 91 ff ff ff       	call   80103481 <cmos_read>
801034f0:	83 c4 04             	add    $0x4,%esp
801034f3:	89 c2                	mov    %eax,%edx
801034f5:	8b 45 08             	mov    0x8(%ebp),%eax
801034f8:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801034fb:	6a 08                	push   $0x8
801034fd:	e8 7f ff ff ff       	call   80103481 <cmos_read>
80103502:	83 c4 04             	add    $0x4,%esp
80103505:	89 c2                	mov    %eax,%edx
80103507:	8b 45 08             	mov    0x8(%ebp),%eax
8010350a:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
8010350d:	6a 09                	push   $0x9
8010350f:	e8 6d ff ff ff       	call   80103481 <cmos_read>
80103514:	83 c4 04             	add    $0x4,%esp
80103517:	89 c2                	mov    %eax,%edx
80103519:	8b 45 08             	mov    0x8(%ebp),%eax
8010351c:	89 50 14             	mov    %edx,0x14(%eax)
}
8010351f:	90                   	nop
80103520:	c9                   	leave  
80103521:	c3                   	ret    

80103522 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103522:	55                   	push   %ebp
80103523:	89 e5                	mov    %esp,%ebp
80103525:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103528:	6a 0b                	push   $0xb
8010352a:	e8 52 ff ff ff       	call   80103481 <cmos_read>
8010352f:	83 c4 04             	add    $0x4,%esp
80103532:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103535:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103538:	83 e0 04             	and    $0x4,%eax
8010353b:	85 c0                	test   %eax,%eax
8010353d:	0f 94 c0             	sete   %al
80103540:	0f b6 c0             	movzbl %al,%eax
80103543:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103546:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103549:	50                   	push   %eax
8010354a:	e8 62 ff ff ff       	call   801034b1 <fill_rtcdate>
8010354f:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103552:	6a 0a                	push   $0xa
80103554:	e8 28 ff ff ff       	call   80103481 <cmos_read>
80103559:	83 c4 04             	add    $0x4,%esp
8010355c:	25 80 00 00 00       	and    $0x80,%eax
80103561:	85 c0                	test   %eax,%eax
80103563:	75 27                	jne    8010358c <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103565:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103568:	50                   	push   %eax
80103569:	e8 43 ff ff ff       	call   801034b1 <fill_rtcdate>
8010356e:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103571:	83 ec 04             	sub    $0x4,%esp
80103574:	6a 18                	push   $0x18
80103576:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103579:	50                   	push   %eax
8010357a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010357d:	50                   	push   %eax
8010357e:	e8 7c 32 00 00       	call   801067ff <memcmp>
80103583:	83 c4 10             	add    $0x10,%esp
80103586:	85 c0                	test   %eax,%eax
80103588:	74 05                	je     8010358f <cmostime+0x6d>
8010358a:	eb ba                	jmp    80103546 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
8010358c:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
8010358d:	eb b7                	jmp    80103546 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010358f:	90                   	nop
  }

  // convert
  if (bcd) {
80103590:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103594:	0f 84 b4 00 00 00    	je     8010364e <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010359a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010359d:	c1 e8 04             	shr    $0x4,%eax
801035a0:	89 c2                	mov    %eax,%edx
801035a2:	89 d0                	mov    %edx,%eax
801035a4:	c1 e0 02             	shl    $0x2,%eax
801035a7:	01 d0                	add    %edx,%eax
801035a9:	01 c0                	add    %eax,%eax
801035ab:	89 c2                	mov    %eax,%edx
801035ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
801035b0:	83 e0 0f             	and    $0xf,%eax
801035b3:	01 d0                	add    %edx,%eax
801035b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801035b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035bb:	c1 e8 04             	shr    $0x4,%eax
801035be:	89 c2                	mov    %eax,%edx
801035c0:	89 d0                	mov    %edx,%eax
801035c2:	c1 e0 02             	shl    $0x2,%eax
801035c5:	01 d0                	add    %edx,%eax
801035c7:	01 c0                	add    %eax,%eax
801035c9:	89 c2                	mov    %eax,%edx
801035cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035ce:	83 e0 0f             	and    $0xf,%eax
801035d1:	01 d0                	add    %edx,%eax
801035d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801035d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035d9:	c1 e8 04             	shr    $0x4,%eax
801035dc:	89 c2                	mov    %eax,%edx
801035de:	89 d0                	mov    %edx,%eax
801035e0:	c1 e0 02             	shl    $0x2,%eax
801035e3:	01 d0                	add    %edx,%eax
801035e5:	01 c0                	add    %eax,%eax
801035e7:	89 c2                	mov    %eax,%edx
801035e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035ec:	83 e0 0f             	and    $0xf,%eax
801035ef:	01 d0                	add    %edx,%eax
801035f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801035f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035f7:	c1 e8 04             	shr    $0x4,%eax
801035fa:	89 c2                	mov    %eax,%edx
801035fc:	89 d0                	mov    %edx,%eax
801035fe:	c1 e0 02             	shl    $0x2,%eax
80103601:	01 d0                	add    %edx,%eax
80103603:	01 c0                	add    %eax,%eax
80103605:	89 c2                	mov    %eax,%edx
80103607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010360a:	83 e0 0f             	and    $0xf,%eax
8010360d:	01 d0                	add    %edx,%eax
8010360f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103612:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103615:	c1 e8 04             	shr    $0x4,%eax
80103618:	89 c2                	mov    %eax,%edx
8010361a:	89 d0                	mov    %edx,%eax
8010361c:	c1 e0 02             	shl    $0x2,%eax
8010361f:	01 d0                	add    %edx,%eax
80103621:	01 c0                	add    %eax,%eax
80103623:	89 c2                	mov    %eax,%edx
80103625:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103628:	83 e0 0f             	and    $0xf,%eax
8010362b:	01 d0                	add    %edx,%eax
8010362d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103630:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103633:	c1 e8 04             	shr    $0x4,%eax
80103636:	89 c2                	mov    %eax,%edx
80103638:	89 d0                	mov    %edx,%eax
8010363a:	c1 e0 02             	shl    $0x2,%eax
8010363d:	01 d0                	add    %edx,%eax
8010363f:	01 c0                	add    %eax,%eax
80103641:	89 c2                	mov    %eax,%edx
80103643:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103646:	83 e0 0f             	and    $0xf,%eax
80103649:	01 d0                	add    %edx,%eax
8010364b:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010364e:	8b 45 08             	mov    0x8(%ebp),%eax
80103651:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103654:	89 10                	mov    %edx,(%eax)
80103656:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103659:	89 50 04             	mov    %edx,0x4(%eax)
8010365c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010365f:	89 50 08             	mov    %edx,0x8(%eax)
80103662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103665:	89 50 0c             	mov    %edx,0xc(%eax)
80103668:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010366b:	89 50 10             	mov    %edx,0x10(%eax)
8010366e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103671:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103674:	8b 45 08             	mov    0x8(%ebp),%eax
80103677:	8b 40 14             	mov    0x14(%eax),%eax
8010367a:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103680:	8b 45 08             	mov    0x8(%ebp),%eax
80103683:	89 50 14             	mov    %edx,0x14(%eax)
}
80103686:	90                   	nop
80103687:	c9                   	leave  
80103688:	c3                   	ret    

80103689 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103689:	55                   	push   %ebp
8010368a:	89 e5                	mov    %esp,%ebp
8010368c:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010368f:	83 ec 08             	sub    $0x8,%esp
80103692:	68 ec 9f 10 80       	push   $0x80109fec
80103697:	68 a0 42 11 80       	push   $0x801142a0
8010369c:	e8 72 2e 00 00       	call   80106513 <initlock>
801036a1:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801036a4:	83 ec 08             	sub    $0x8,%esp
801036a7:	8d 45 dc             	lea    -0x24(%ebp),%eax
801036aa:	50                   	push   %eax
801036ab:	ff 75 08             	pushl  0x8(%ebp)
801036ae:	e8 1e de ff ff       	call   801014d1 <readsb>
801036b3:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801036b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036b9:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
801036be:	8b 45 e8             	mov    -0x18(%ebp),%eax
801036c1:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
801036c6:	8b 45 08             	mov    0x8(%ebp),%eax
801036c9:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
801036ce:	e8 b2 01 00 00       	call   80103885 <recover_from_log>
}
801036d3:	90                   	nop
801036d4:	c9                   	leave  
801036d5:	c3                   	ret    

801036d6 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801036d6:	55                   	push   %ebp
801036d7:	89 e5                	mov    %esp,%ebp
801036d9:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036e3:	e9 95 00 00 00       	jmp    8010377d <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801036e8:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f1:	01 d0                	add    %edx,%eax
801036f3:	83 c0 01             	add    $0x1,%eax
801036f6:	89 c2                	mov    %eax,%edx
801036f8:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801036fd:	83 ec 08             	sub    $0x8,%esp
80103700:	52                   	push   %edx
80103701:	50                   	push   %eax
80103702:	e8 af ca ff ff       	call   801001b6 <bread>
80103707:	83 c4 10             	add    $0x10,%esp
8010370a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010370d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103710:	83 c0 10             	add    $0x10,%eax
80103713:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
8010371a:	89 c2                	mov    %eax,%edx
8010371c:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103721:	83 ec 08             	sub    $0x8,%esp
80103724:	52                   	push   %edx
80103725:	50                   	push   %eax
80103726:	e8 8b ca ff ff       	call   801001b6 <bread>
8010372b:	83 c4 10             	add    $0x10,%esp
8010372e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103731:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103734:	8d 50 18             	lea    0x18(%eax),%edx
80103737:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010373a:	83 c0 18             	add    $0x18,%eax
8010373d:	83 ec 04             	sub    $0x4,%esp
80103740:	68 00 02 00 00       	push   $0x200
80103745:	52                   	push   %edx
80103746:	50                   	push   %eax
80103747:	e8 0b 31 00 00       	call   80106857 <memmove>
8010374c:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010374f:	83 ec 0c             	sub    $0xc,%esp
80103752:	ff 75 ec             	pushl  -0x14(%ebp)
80103755:	e8 95 ca ff ff       	call   801001ef <bwrite>
8010375a:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010375d:	83 ec 0c             	sub    $0xc,%esp
80103760:	ff 75 f0             	pushl  -0x10(%ebp)
80103763:	e8 c6 ca ff ff       	call   8010022e <brelse>
80103768:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
8010376b:	83 ec 0c             	sub    $0xc,%esp
8010376e:	ff 75 ec             	pushl  -0x14(%ebp)
80103771:	e8 b8 ca ff ff       	call   8010022e <brelse>
80103776:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103779:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010377d:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103782:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103785:	0f 8f 5d ff ff ff    	jg     801036e8 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010378b:	90                   	nop
8010378c:	c9                   	leave  
8010378d:	c3                   	ret    

8010378e <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010378e:	55                   	push   %ebp
8010378f:	89 e5                	mov    %esp,%ebp
80103791:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103794:	a1 d4 42 11 80       	mov    0x801142d4,%eax
80103799:	89 c2                	mov    %eax,%edx
8010379b:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801037a0:	83 ec 08             	sub    $0x8,%esp
801037a3:	52                   	push   %edx
801037a4:	50                   	push   %eax
801037a5:	e8 0c ca ff ff       	call   801001b6 <bread>
801037aa:	83 c4 10             	add    $0x10,%esp
801037ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801037b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037b3:	83 c0 18             	add    $0x18,%eax
801037b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801037b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037bc:	8b 00                	mov    (%eax),%eax
801037be:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
801037c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037ca:	eb 1b                	jmp    801037e7 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801037cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037d2:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801037d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037d9:	83 c2 10             	add    $0x10,%edx
801037dc:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801037e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e7:	a1 e8 42 11 80       	mov    0x801142e8,%eax
801037ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037ef:	7f db                	jg     801037cc <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801037f1:	83 ec 0c             	sub    $0xc,%esp
801037f4:	ff 75 f0             	pushl  -0x10(%ebp)
801037f7:	e8 32 ca ff ff       	call   8010022e <brelse>
801037fc:	83 c4 10             	add    $0x10,%esp
}
801037ff:	90                   	nop
80103800:	c9                   	leave  
80103801:	c3                   	ret    

80103802 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103802:	55                   	push   %ebp
80103803:	89 e5                	mov    %esp,%ebp
80103805:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103808:	a1 d4 42 11 80       	mov    0x801142d4,%eax
8010380d:	89 c2                	mov    %eax,%edx
8010380f:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103814:	83 ec 08             	sub    $0x8,%esp
80103817:	52                   	push   %edx
80103818:	50                   	push   %eax
80103819:	e8 98 c9 ff ff       	call   801001b6 <bread>
8010381e:	83 c4 10             	add    $0x10,%esp
80103821:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103827:	83 c0 18             	add    $0x18,%eax
8010382a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010382d:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
80103833:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103836:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010383f:	eb 1b                	jmp    8010385c <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103844:	83 c0 10             	add    $0x10,%eax
80103847:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
8010384e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103851:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103854:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103858:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010385c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103861:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103864:	7f db                	jg     80103841 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103866:	83 ec 0c             	sub    $0xc,%esp
80103869:	ff 75 f0             	pushl  -0x10(%ebp)
8010386c:	e8 7e c9 ff ff       	call   801001ef <bwrite>
80103871:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103874:	83 ec 0c             	sub    $0xc,%esp
80103877:	ff 75 f0             	pushl  -0x10(%ebp)
8010387a:	e8 af c9 ff ff       	call   8010022e <brelse>
8010387f:	83 c4 10             	add    $0x10,%esp
}
80103882:	90                   	nop
80103883:	c9                   	leave  
80103884:	c3                   	ret    

80103885 <recover_from_log>:

static void
recover_from_log(void)
{
80103885:	55                   	push   %ebp
80103886:	89 e5                	mov    %esp,%ebp
80103888:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010388b:	e8 fe fe ff ff       	call   8010378e <read_head>
  install_trans(); // if committed, copy from log to disk
80103890:	e8 41 fe ff ff       	call   801036d6 <install_trans>
  log.lh.n = 0;
80103895:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
8010389c:	00 00 00 
  write_head(); // clear the log
8010389f:	e8 5e ff ff ff       	call   80103802 <write_head>
}
801038a4:	90                   	nop
801038a5:	c9                   	leave  
801038a6:	c3                   	ret    

801038a7 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801038a7:	55                   	push   %ebp
801038a8:	89 e5                	mov    %esp,%ebp
801038aa:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801038ad:	83 ec 0c             	sub    $0xc,%esp
801038b0:	68 a0 42 11 80       	push   $0x801142a0
801038b5:	e8 7b 2c 00 00       	call   80106535 <acquire>
801038ba:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801038bd:	a1 e0 42 11 80       	mov    0x801142e0,%eax
801038c2:	85 c0                	test   %eax,%eax
801038c4:	74 17                	je     801038dd <begin_op+0x36>
      sleep(&log, &log.lock);
801038c6:	83 ec 08             	sub    $0x8,%esp
801038c9:	68 a0 42 11 80       	push   $0x801142a0
801038ce:	68 a0 42 11 80       	push   $0x801142a0
801038d3:	e8 8b 1d 00 00       	call   80105663 <sleep>
801038d8:	83 c4 10             	add    $0x10,%esp
801038db:	eb e0                	jmp    801038bd <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801038dd:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
801038e3:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801038e8:	8d 50 01             	lea    0x1(%eax),%edx
801038eb:	89 d0                	mov    %edx,%eax
801038ed:	c1 e0 02             	shl    $0x2,%eax
801038f0:	01 d0                	add    %edx,%eax
801038f2:	01 c0                	add    %eax,%eax
801038f4:	01 c8                	add    %ecx,%eax
801038f6:	83 f8 1e             	cmp    $0x1e,%eax
801038f9:	7e 17                	jle    80103912 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801038fb:	83 ec 08             	sub    $0x8,%esp
801038fe:	68 a0 42 11 80       	push   $0x801142a0
80103903:	68 a0 42 11 80       	push   $0x801142a0
80103908:	e8 56 1d 00 00       	call   80105663 <sleep>
8010390d:	83 c4 10             	add    $0x10,%esp
80103910:	eb ab                	jmp    801038bd <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103912:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103917:	83 c0 01             	add    $0x1,%eax
8010391a:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
8010391f:	83 ec 0c             	sub    $0xc,%esp
80103922:	68 a0 42 11 80       	push   $0x801142a0
80103927:	e8 70 2c 00 00       	call   8010659c <release>
8010392c:	83 c4 10             	add    $0x10,%esp
      break;
8010392f:	90                   	nop
    }
  }
}
80103930:	90                   	nop
80103931:	c9                   	leave  
80103932:	c3                   	ret    

80103933 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103933:	55                   	push   %ebp
80103934:	89 e5                	mov    %esp,%ebp
80103936:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
80103943:	68 a0 42 11 80       	push   $0x801142a0
80103948:	e8 e8 2b 00 00       	call   80106535 <acquire>
8010394d:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103950:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103955:	83 e8 01             	sub    $0x1,%eax
80103958:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
8010395d:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103962:	85 c0                	test   %eax,%eax
80103964:	74 0d                	je     80103973 <end_op+0x40>
    panic("log.committing");
80103966:	83 ec 0c             	sub    $0xc,%esp
80103969:	68 f0 9f 10 80       	push   $0x80109ff0
8010396e:	e8 f3 cb ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103973:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103978:	85 c0                	test   %eax,%eax
8010397a:	75 13                	jne    8010398f <end_op+0x5c>
    do_commit = 1;
8010397c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103983:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
8010398a:	00 00 00 
8010398d:	eb 10                	jmp    8010399f <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010398f:	83 ec 0c             	sub    $0xc,%esp
80103992:	68 a0 42 11 80       	push   $0x801142a0
80103997:	e8 f8 1e 00 00       	call   80105894 <wakeup>
8010399c:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010399f:	83 ec 0c             	sub    $0xc,%esp
801039a2:	68 a0 42 11 80       	push   $0x801142a0
801039a7:	e8 f0 2b 00 00       	call   8010659c <release>
801039ac:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801039af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801039b3:	74 3f                	je     801039f4 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801039b5:	e8 f5 00 00 00       	call   80103aaf <commit>
    acquire(&log.lock);
801039ba:	83 ec 0c             	sub    $0xc,%esp
801039bd:	68 a0 42 11 80       	push   $0x801142a0
801039c2:	e8 6e 2b 00 00       	call   80106535 <acquire>
801039c7:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801039ca:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
801039d1:	00 00 00 
    wakeup(&log);
801039d4:	83 ec 0c             	sub    $0xc,%esp
801039d7:	68 a0 42 11 80       	push   $0x801142a0
801039dc:	e8 b3 1e 00 00       	call   80105894 <wakeup>
801039e1:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801039e4:	83 ec 0c             	sub    $0xc,%esp
801039e7:	68 a0 42 11 80       	push   $0x801142a0
801039ec:	e8 ab 2b 00 00       	call   8010659c <release>
801039f1:	83 c4 10             	add    $0x10,%esp
  }
}
801039f4:	90                   	nop
801039f5:	c9                   	leave  
801039f6:	c3                   	ret    

801039f7 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801039f7:	55                   	push   %ebp
801039f8:	89 e5                	mov    %esp,%ebp
801039fa:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a04:	e9 95 00 00 00       	jmp    80103a9e <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103a09:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
80103a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a12:	01 d0                	add    %edx,%eax
80103a14:	83 c0 01             	add    $0x1,%eax
80103a17:	89 c2                	mov    %eax,%edx
80103a19:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a1e:	83 ec 08             	sub    $0x8,%esp
80103a21:	52                   	push   %edx
80103a22:	50                   	push   %eax
80103a23:	e8 8e c7 ff ff       	call   801001b6 <bread>
80103a28:	83 c4 10             	add    $0x10,%esp
80103a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a31:	83 c0 10             	add    $0x10,%eax
80103a34:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103a3b:	89 c2                	mov    %eax,%edx
80103a3d:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a42:	83 ec 08             	sub    $0x8,%esp
80103a45:	52                   	push   %edx
80103a46:	50                   	push   %eax
80103a47:	e8 6a c7 ff ff       	call   801001b6 <bread>
80103a4c:	83 c4 10             	add    $0x10,%esp
80103a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a55:	8d 50 18             	lea    0x18(%eax),%edx
80103a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5b:	83 c0 18             	add    $0x18,%eax
80103a5e:	83 ec 04             	sub    $0x4,%esp
80103a61:	68 00 02 00 00       	push   $0x200
80103a66:	52                   	push   %edx
80103a67:	50                   	push   %eax
80103a68:	e8 ea 2d 00 00       	call   80106857 <memmove>
80103a6d:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	ff 75 f0             	pushl  -0x10(%ebp)
80103a76:	e8 74 c7 ff ff       	call   801001ef <bwrite>
80103a7b:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103a7e:	83 ec 0c             	sub    $0xc,%esp
80103a81:	ff 75 ec             	pushl  -0x14(%ebp)
80103a84:	e8 a5 c7 ff ff       	call   8010022e <brelse>
80103a89:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a8c:	83 ec 0c             	sub    $0xc,%esp
80103a8f:	ff 75 f0             	pushl  -0x10(%ebp)
80103a92:	e8 97 c7 ff ff       	call   8010022e <brelse>
80103a97:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a9a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a9e:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103aa3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103aa6:	0f 8f 5d ff ff ff    	jg     80103a09 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103aac:	90                   	nop
80103aad:	c9                   	leave  
80103aae:	c3                   	ret    

80103aaf <commit>:

static void
commit()
{
80103aaf:	55                   	push   %ebp
80103ab0:	89 e5                	mov    %esp,%ebp
80103ab2:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103ab5:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103aba:	85 c0                	test   %eax,%eax
80103abc:	7e 1e                	jle    80103adc <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103abe:	e8 34 ff ff ff       	call   801039f7 <write_log>
    write_head();    // Write header to disk -- the real commit
80103ac3:	e8 3a fd ff ff       	call   80103802 <write_head>
    install_trans(); // Now install writes to home locations
80103ac8:	e8 09 fc ff ff       	call   801036d6 <install_trans>
    log.lh.n = 0; 
80103acd:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103ad4:	00 00 00 
    write_head();    // Erase the transaction from the log
80103ad7:	e8 26 fd ff ff       	call   80103802 <write_head>
  }
}
80103adc:	90                   	nop
80103add:	c9                   	leave  
80103ade:	c3                   	ret    

80103adf <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103adf:	55                   	push   %ebp
80103ae0:	89 e5                	mov    %esp,%ebp
80103ae2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103ae5:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103aea:	83 f8 1d             	cmp    $0x1d,%eax
80103aed:	7f 12                	jg     80103b01 <log_write+0x22>
80103aef:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103af4:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
80103afa:	83 ea 01             	sub    $0x1,%edx
80103afd:	39 d0                	cmp    %edx,%eax
80103aff:	7c 0d                	jl     80103b0e <log_write+0x2f>
    panic("too big a transaction");
80103b01:	83 ec 0c             	sub    $0xc,%esp
80103b04:	68 ff 9f 10 80       	push   $0x80109fff
80103b09:	e8 58 ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103b0e:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103b13:	85 c0                	test   %eax,%eax
80103b15:	7f 0d                	jg     80103b24 <log_write+0x45>
    panic("log_write outside of trans");
80103b17:	83 ec 0c             	sub    $0xc,%esp
80103b1a:	68 15 a0 10 80       	push   $0x8010a015
80103b1f:	e8 42 ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103b24:	83 ec 0c             	sub    $0xc,%esp
80103b27:	68 a0 42 11 80       	push   $0x801142a0
80103b2c:	e8 04 2a 00 00       	call   80106535 <acquire>
80103b31:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103b34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b3b:	eb 1d                	jmp    80103b5a <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b40:	83 c0 10             	add    $0x10,%eax
80103b43:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103b4a:	89 c2                	mov    %eax,%edx
80103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b4f:	8b 40 08             	mov    0x8(%eax),%eax
80103b52:	39 c2                	cmp    %eax,%edx
80103b54:	74 10                	je     80103b66 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b5a:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b5f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b62:	7f d9                	jg     80103b3d <log_write+0x5e>
80103b64:	eb 01                	jmp    80103b67 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103b66:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103b67:	8b 45 08             	mov    0x8(%ebp),%eax
80103b6a:	8b 40 08             	mov    0x8(%eax),%eax
80103b6d:	89 c2                	mov    %eax,%edx
80103b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b72:	83 c0 10             	add    $0x10,%eax
80103b75:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103b7c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b81:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b84:	75 0d                	jne    80103b93 <log_write+0xb4>
    log.lh.n++;
80103b86:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b8b:	83 c0 01             	add    $0x1,%eax
80103b8e:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103b93:	8b 45 08             	mov    0x8(%ebp),%eax
80103b96:	8b 00                	mov    (%eax),%eax
80103b98:	83 c8 04             	or     $0x4,%eax
80103b9b:	89 c2                	mov    %eax,%edx
80103b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103ba0:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103ba2:	83 ec 0c             	sub    $0xc,%esp
80103ba5:	68 a0 42 11 80       	push   $0x801142a0
80103baa:	e8 ed 29 00 00       	call   8010659c <release>
80103baf:	83 c4 10             	add    $0x10,%esp
}
80103bb2:	90                   	nop
80103bb3:	c9                   	leave  
80103bb4:	c3                   	ret    

80103bb5 <v2p>:
80103bb5:	55                   	push   %ebp
80103bb6:	89 e5                	mov    %esp,%ebp
80103bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80103bbb:	05 00 00 00 80       	add    $0x80000000,%eax
80103bc0:	5d                   	pop    %ebp
80103bc1:	c3                   	ret    

80103bc2 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103bc2:	55                   	push   %ebp
80103bc3:	89 e5                	mov    %esp,%ebp
80103bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc8:	05 00 00 00 80       	add    $0x80000000,%eax
80103bcd:	5d                   	pop    %ebp
80103bce:	c3                   	ret    

80103bcf <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103bcf:	55                   	push   %ebp
80103bd0:	89 e5                	mov    %esp,%ebp
80103bd2:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103bd5:	8b 55 08             	mov    0x8(%ebp),%edx
80103bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103bde:	f0 87 02             	lock xchg %eax,(%edx)
80103be1:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103be7:	c9                   	leave  
80103be8:	c3                   	ret    

80103be9 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103be9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103bed:	83 e4 f0             	and    $0xfffffff0,%esp
80103bf0:	ff 71 fc             	pushl  -0x4(%ecx)
80103bf3:	55                   	push   %ebp
80103bf4:	89 e5                	mov    %esp,%ebp
80103bf6:	51                   	push   %ecx
80103bf7:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103bfa:	83 ec 08             	sub    $0x8,%esp
80103bfd:	68 00 00 40 80       	push   $0x80400000
80103c02:	68 7c 79 11 80       	push   $0x8011797c
80103c07:	e8 7d f2 ff ff       	call   80102e89 <kinit1>
80103c0c:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103c0f:	e8 ea 59 00 00       	call   801095fe <kvmalloc>
  mpinit();        // collect info about this machine
80103c14:	e8 43 04 00 00       	call   8010405c <mpinit>
  lapicinit();
80103c19:	e8 ea f5 ff ff       	call   80103208 <lapicinit>
  seginit();       // set up segments
80103c1e:	e8 84 53 00 00       	call   80108fa7 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103c23:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c29:	0f b6 00             	movzbl (%eax),%eax
80103c2c:	0f b6 c0             	movzbl %al,%eax
80103c2f:	83 ec 08             	sub    $0x8,%esp
80103c32:	50                   	push   %eax
80103c33:	68 30 a0 10 80       	push   $0x8010a030
80103c38:	e8 89 c7 ff ff       	call   801003c6 <cprintf>
80103c3d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103c40:	e8 6d 06 00 00       	call   801042b2 <picinit>
  ioapicinit();    // another interrupt controller
80103c45:	e8 34 f1 ff ff       	call   80102d7e <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103c4a:	e8 6f cf ff ff       	call   80100bbe <consoleinit>
  uartinit();      // serial port
80103c4f:	e8 af 46 00 00       	call   80108303 <uartinit>
  pinit();         // process table
80103c54:	e8 5d 0b 00 00       	call   801047b6 <pinit>
  tvinit();        // trap vectors
80103c59:	e8 7e 42 00 00       	call   80107edc <tvinit>
  binit();         // buffer cache
80103c5e:	e8 d1 c3 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103c63:	e8 5a d4 ff ff       	call   801010c2 <fileinit>
  ideinit();       // disk
80103c68:	e8 19 ed ff ff       	call   80102986 <ideinit>
  if(!ismp)
80103c6d:	a1 84 43 11 80       	mov    0x80114384,%eax
80103c72:	85 c0                	test   %eax,%eax
80103c74:	75 05                	jne    80103c7b <main+0x92>
    timerinit();   // uniprocessor timer
80103c76:	e8 b2 41 00 00       	call   80107e2d <timerinit>
  startothers();   // start other processors
80103c7b:	e8 7f 00 00 00       	call   80103cff <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c80:	83 ec 08             	sub    $0x8,%esp
80103c83:	68 00 00 00 8e       	push   $0x8e000000
80103c88:	68 00 00 40 80       	push   $0x80400000
80103c8d:	e8 30 f2 ff ff       	call   80102ec2 <kinit2>
80103c92:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103c95:	e8 fd 0c 00 00       	call   80104997 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c9a:	e8 1a 00 00 00       	call   80103cb9 <mpmain>

80103c9f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c9f:	55                   	push   %ebp
80103ca0:	89 e5                	mov    %esp,%ebp
80103ca2:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103ca5:	e8 6c 59 00 00       	call   80109616 <switchkvm>
  seginit();
80103caa:	e8 f8 52 00 00       	call   80108fa7 <seginit>
  lapicinit();
80103caf:	e8 54 f5 ff ff       	call   80103208 <lapicinit>
  mpmain();
80103cb4:	e8 00 00 00 00       	call   80103cb9 <mpmain>

80103cb9 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103cb9:	55                   	push   %ebp
80103cba:	89 e5                	mov    %esp,%ebp
80103cbc:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103cbf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cc5:	0f b6 00             	movzbl (%eax),%eax
80103cc8:	0f b6 c0             	movzbl %al,%eax
80103ccb:	83 ec 08             	sub    $0x8,%esp
80103cce:	50                   	push   %eax
80103ccf:	68 47 a0 10 80       	push   $0x8010a047
80103cd4:	e8 ed c6 ff ff       	call   801003c6 <cprintf>
80103cd9:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103cdc:	e8 5c 43 00 00       	call   8010803d <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103ce1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ce7:	05 a8 00 00 00       	add    $0xa8,%eax
80103cec:	83 ec 08             	sub    $0x8,%esp
80103cef:	6a 01                	push   $0x1
80103cf1:	50                   	push   %eax
80103cf2:	e8 d8 fe ff ff       	call   80103bcf <xchg>
80103cf7:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103cfa:	e8 65 15 00 00       	call   80105264 <scheduler>

80103cff <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103cff:	55                   	push   %ebp
80103d00:	89 e5                	mov    %esp,%ebp
80103d02:	53                   	push   %ebx
80103d03:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103d06:	68 00 70 00 00       	push   $0x7000
80103d0b:	e8 b2 fe ff ff       	call   80103bc2 <p2v>
80103d10:	83 c4 04             	add    $0x4,%esp
80103d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103d16:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103d1b:	83 ec 04             	sub    $0x4,%esp
80103d1e:	50                   	push   %eax
80103d1f:	68 4c d5 10 80       	push   $0x8010d54c
80103d24:	ff 75 f0             	pushl  -0x10(%ebp)
80103d27:	e8 2b 2b 00 00       	call   80106857 <memmove>
80103d2c:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103d2f:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103d36:	e9 90 00 00 00       	jmp    80103dcb <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103d3b:	e8 e6 f5 ff ff       	call   80103326 <cpunum>
80103d40:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d46:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103d4b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d4e:	74 73                	je     80103dc3 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103d50:	e8 6b f2 ff ff       	call   80102fc0 <kalloc>
80103d55:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d5b:	83 e8 04             	sub    $0x4,%eax
80103d5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103d61:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103d67:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d6c:	83 e8 08             	sub    $0x8,%eax
80103d6f:	c7 00 9f 3c 10 80    	movl   $0x80103c9f,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d78:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103d7b:	83 ec 0c             	sub    $0xc,%esp
80103d7e:	68 00 c0 10 80       	push   $0x8010c000
80103d83:	e8 2d fe ff ff       	call   80103bb5 <v2p>
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d8d:	83 ec 0c             	sub    $0xc,%esp
80103d90:	ff 75 f0             	pushl  -0x10(%ebp)
80103d93:	e8 1d fe ff ff       	call   80103bb5 <v2p>
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	89 c2                	mov    %eax,%edx
80103d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103da0:	0f b6 00             	movzbl (%eax),%eax
80103da3:	0f b6 c0             	movzbl %al,%eax
80103da6:	83 ec 08             	sub    $0x8,%esp
80103da9:	52                   	push   %edx
80103daa:	50                   	push   %eax
80103dab:	e8 f0 f5 ff ff       	call   801033a0 <lapicstartap>
80103db0:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103db3:	90                   	nop
80103db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db7:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103dbd:	85 c0                	test   %eax,%eax
80103dbf:	74 f3                	je     80103db4 <startothers+0xb5>
80103dc1:	eb 01                	jmp    80103dc4 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103dc3:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103dc4:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103dcb:	a1 80 49 11 80       	mov    0x80114980,%eax
80103dd0:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103dd6:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103ddb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103dde:	0f 87 57 ff ff ff    	ja     80103d3b <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103de4:	90                   	nop
80103de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de8:	c9                   	leave  
80103de9:	c3                   	ret    

80103dea <p2v>:
80103dea:	55                   	push   %ebp
80103deb:	89 e5                	mov    %esp,%ebp
80103ded:	8b 45 08             	mov    0x8(%ebp),%eax
80103df0:	05 00 00 00 80       	add    $0x80000000,%eax
80103df5:	5d                   	pop    %ebp
80103df6:	c3                   	ret    

80103df7 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103df7:	55                   	push   %ebp
80103df8:	89 e5                	mov    %esp,%ebp
80103dfa:	83 ec 14             	sub    $0x14,%esp
80103dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80103e00:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103e04:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103e08:	89 c2                	mov    %eax,%edx
80103e0a:	ec                   	in     (%dx),%al
80103e0b:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103e0e:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103e12:	c9                   	leave  
80103e13:	c3                   	ret    

80103e14 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e14:	55                   	push   %ebp
80103e15:	89 e5                	mov    %esp,%ebp
80103e17:	83 ec 08             	sub    $0x8,%esp
80103e1a:	8b 55 08             	mov    0x8(%ebp),%edx
80103e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e20:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e24:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e27:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e2b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e2f:	ee                   	out    %al,(%dx)
}
80103e30:	90                   	nop
80103e31:	c9                   	leave  
80103e32:	c3                   	ret    

80103e33 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103e33:	55                   	push   %ebp
80103e34:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103e36:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80103e3b:	89 c2                	mov    %eax,%edx
80103e3d:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
80103e42:	29 c2                	sub    %eax,%edx
80103e44:	89 d0                	mov    %edx,%eax
80103e46:	c1 f8 02             	sar    $0x2,%eax
80103e49:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103e4f:	5d                   	pop    %ebp
80103e50:	c3                   	ret    

80103e51 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103e51:	55                   	push   %ebp
80103e52:	89 e5                	mov    %esp,%ebp
80103e54:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103e57:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103e65:	eb 15                	jmp    80103e7c <sum+0x2b>
    sum += addr[i];
80103e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6d:	01 d0                	add    %edx,%eax
80103e6f:	0f b6 00             	movzbl (%eax),%eax
80103e72:	0f b6 c0             	movzbl %al,%eax
80103e75:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103e78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103e82:	7c e3                	jl     80103e67 <sum+0x16>
    sum += addr[i];
  return sum;
80103e84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e87:	c9                   	leave  
80103e88:	c3                   	ret    

80103e89 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e89:	55                   	push   %ebp
80103e8a:	89 e5                	mov    %esp,%ebp
80103e8c:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e8f:	ff 75 08             	pushl  0x8(%ebp)
80103e92:	e8 53 ff ff ff       	call   80103dea <p2v>
80103e97:	83 c4 04             	add    $0x4,%esp
80103e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e9d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ea3:	01 d0                	add    %edx,%eax
80103ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103eae:	eb 36                	jmp    80103ee6 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103eb0:	83 ec 04             	sub    $0x4,%esp
80103eb3:	6a 04                	push   $0x4
80103eb5:	68 58 a0 10 80       	push   $0x8010a058
80103eba:	ff 75 f4             	pushl  -0xc(%ebp)
80103ebd:	e8 3d 29 00 00       	call   801067ff <memcmp>
80103ec2:	83 c4 10             	add    $0x10,%esp
80103ec5:	85 c0                	test   %eax,%eax
80103ec7:	75 19                	jne    80103ee2 <mpsearch1+0x59>
80103ec9:	83 ec 08             	sub    $0x8,%esp
80103ecc:	6a 10                	push   $0x10
80103ece:	ff 75 f4             	pushl  -0xc(%ebp)
80103ed1:	e8 7b ff ff ff       	call   80103e51 <sum>
80103ed6:	83 c4 10             	add    $0x10,%esp
80103ed9:	84 c0                	test   %al,%al
80103edb:	75 05                	jne    80103ee2 <mpsearch1+0x59>
      return (struct mp*)p;
80103edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee0:	eb 11                	jmp    80103ef3 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ee2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103eec:	72 c2                	jb     80103eb0 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103ef3:	c9                   	leave  
80103ef4:	c3                   	ret    

80103ef5 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ef5:	55                   	push   %ebp
80103ef6:	89 e5                	mov    %esp,%ebp
80103ef8:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103efb:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f05:	83 c0 0f             	add    $0xf,%eax
80103f08:	0f b6 00             	movzbl (%eax),%eax
80103f0b:	0f b6 c0             	movzbl %al,%eax
80103f0e:	c1 e0 08             	shl    $0x8,%eax
80103f11:	89 c2                	mov    %eax,%edx
80103f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f16:	83 c0 0e             	add    $0xe,%eax
80103f19:	0f b6 00             	movzbl (%eax),%eax
80103f1c:	0f b6 c0             	movzbl %al,%eax
80103f1f:	09 d0                	or     %edx,%eax
80103f21:	c1 e0 04             	shl    $0x4,%eax
80103f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103f27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f2b:	74 21                	je     80103f4e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103f2d:	83 ec 08             	sub    $0x8,%esp
80103f30:	68 00 04 00 00       	push   $0x400
80103f35:	ff 75 f0             	pushl  -0x10(%ebp)
80103f38:	e8 4c ff ff ff       	call   80103e89 <mpsearch1>
80103f3d:	83 c4 10             	add    $0x10,%esp
80103f40:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f47:	74 51                	je     80103f9a <mpsearch+0xa5>
      return mp;
80103f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f4c:	eb 61                	jmp    80103faf <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f51:	83 c0 14             	add    $0x14,%eax
80103f54:	0f b6 00             	movzbl (%eax),%eax
80103f57:	0f b6 c0             	movzbl %al,%eax
80103f5a:	c1 e0 08             	shl    $0x8,%eax
80103f5d:	89 c2                	mov    %eax,%edx
80103f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f62:	83 c0 13             	add    $0x13,%eax
80103f65:	0f b6 00             	movzbl (%eax),%eax
80103f68:	0f b6 c0             	movzbl %al,%eax
80103f6b:	09 d0                	or     %edx,%eax
80103f6d:	c1 e0 0a             	shl    $0xa,%eax
80103f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f76:	2d 00 04 00 00       	sub    $0x400,%eax
80103f7b:	83 ec 08             	sub    $0x8,%esp
80103f7e:	68 00 04 00 00       	push   $0x400
80103f83:	50                   	push   %eax
80103f84:	e8 00 ff ff ff       	call   80103e89 <mpsearch1>
80103f89:	83 c4 10             	add    $0x10,%esp
80103f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f93:	74 05                	je     80103f9a <mpsearch+0xa5>
      return mp;
80103f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f98:	eb 15                	jmp    80103faf <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f9a:	83 ec 08             	sub    $0x8,%esp
80103f9d:	68 00 00 01 00       	push   $0x10000
80103fa2:	68 00 00 0f 00       	push   $0xf0000
80103fa7:	e8 dd fe ff ff       	call   80103e89 <mpsearch1>
80103fac:	83 c4 10             	add    $0x10,%esp
}
80103faf:	c9                   	leave  
80103fb0:	c3                   	ret    

80103fb1 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103fb1:	55                   	push   %ebp
80103fb2:	89 e5                	mov    %esp,%ebp
80103fb4:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103fb7:	e8 39 ff ff ff       	call   80103ef5 <mpsearch>
80103fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103fc3:	74 0a                	je     80103fcf <mpconfig+0x1e>
80103fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc8:	8b 40 04             	mov    0x4(%eax),%eax
80103fcb:	85 c0                	test   %eax,%eax
80103fcd:	75 0a                	jne    80103fd9 <mpconfig+0x28>
    return 0;
80103fcf:	b8 00 00 00 00       	mov    $0x0,%eax
80103fd4:	e9 81 00 00 00       	jmp    8010405a <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fdc:	8b 40 04             	mov    0x4(%eax),%eax
80103fdf:	83 ec 0c             	sub    $0xc,%esp
80103fe2:	50                   	push   %eax
80103fe3:	e8 02 fe ff ff       	call   80103dea <p2v>
80103fe8:	83 c4 10             	add    $0x10,%esp
80103feb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103fee:	83 ec 04             	sub    $0x4,%esp
80103ff1:	6a 04                	push   $0x4
80103ff3:	68 5d a0 10 80       	push   $0x8010a05d
80103ff8:	ff 75 f0             	pushl  -0x10(%ebp)
80103ffb:	e8 ff 27 00 00       	call   801067ff <memcmp>
80104000:	83 c4 10             	add    $0x10,%esp
80104003:	85 c0                	test   %eax,%eax
80104005:	74 07                	je     8010400e <mpconfig+0x5d>
    return 0;
80104007:	b8 00 00 00 00       	mov    $0x0,%eax
8010400c:	eb 4c                	jmp    8010405a <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
8010400e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104011:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104015:	3c 01                	cmp    $0x1,%al
80104017:	74 12                	je     8010402b <mpconfig+0x7a>
80104019:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010401c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104020:	3c 04                	cmp    $0x4,%al
80104022:	74 07                	je     8010402b <mpconfig+0x7a>
    return 0;
80104024:	b8 00 00 00 00       	mov    $0x0,%eax
80104029:	eb 2f                	jmp    8010405a <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
8010402b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010402e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104032:	0f b7 c0             	movzwl %ax,%eax
80104035:	83 ec 08             	sub    $0x8,%esp
80104038:	50                   	push   %eax
80104039:	ff 75 f0             	pushl  -0x10(%ebp)
8010403c:	e8 10 fe ff ff       	call   80103e51 <sum>
80104041:	83 c4 10             	add    $0x10,%esp
80104044:	84 c0                	test   %al,%al
80104046:	74 07                	je     8010404f <mpconfig+0x9e>
    return 0;
80104048:	b8 00 00 00 00       	mov    $0x0,%eax
8010404d:	eb 0b                	jmp    8010405a <mpconfig+0xa9>
  *pmp = mp;
8010404f:	8b 45 08             	mov    0x8(%ebp),%eax
80104052:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104055:	89 10                	mov    %edx,(%eax)
  return conf;
80104057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010405a:	c9                   	leave  
8010405b:	c3                   	ret    

8010405c <mpinit>:

void
mpinit(void)
{
8010405c:	55                   	push   %ebp
8010405d:	89 e5                	mov    %esp,%ebp
8010405f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80104062:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80104069:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
8010406c:	83 ec 0c             	sub    $0xc,%esp
8010406f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104072:	50                   	push   %eax
80104073:	e8 39 ff ff ff       	call   80103fb1 <mpconfig>
80104078:	83 c4 10             	add    $0x10,%esp
8010407b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010407e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104082:	0f 84 96 01 00 00    	je     8010421e <mpinit+0x1c2>
    return;
  ismp = 1;
80104088:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
8010408f:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104092:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104095:	8b 40 24             	mov    0x24(%eax),%eax
80104098:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010409d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040a0:	83 c0 2c             	add    $0x2c,%eax
801040a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040a9:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801040ad:	0f b7 d0             	movzwl %ax,%edx
801040b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040b3:	01 d0                	add    %edx,%eax
801040b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801040b8:	e9 f2 00 00 00       	jmp    801041af <mpinit+0x153>
    switch(*p){
801040bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c0:	0f b6 00             	movzbl (%eax),%eax
801040c3:	0f b6 c0             	movzbl %al,%eax
801040c6:	83 f8 04             	cmp    $0x4,%eax
801040c9:	0f 87 bc 00 00 00    	ja     8010418b <mpinit+0x12f>
801040cf:	8b 04 85 a0 a0 10 80 	mov    -0x7fef5f60(,%eax,4),%eax
801040d6:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801040d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040db:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801040de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040e1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040e5:	0f b6 d0             	movzbl %al,%edx
801040e8:	a1 80 49 11 80       	mov    0x80114980,%eax
801040ed:	39 c2                	cmp    %eax,%edx
801040ef:	74 2b                	je     8010411c <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801040f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040f4:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040f8:	0f b6 d0             	movzbl %al,%edx
801040fb:	a1 80 49 11 80       	mov    0x80114980,%eax
80104100:	83 ec 04             	sub    $0x4,%esp
80104103:	52                   	push   %edx
80104104:	50                   	push   %eax
80104105:	68 62 a0 10 80       	push   $0x8010a062
8010410a:	e8 b7 c2 ff ff       	call   801003c6 <cprintf>
8010410f:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80104112:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80104119:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010411c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010411f:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80104123:	0f b6 c0             	movzbl %al,%eax
80104126:	83 e0 02             	and    $0x2,%eax
80104129:	85 c0                	test   %eax,%eax
8010412b:	74 15                	je     80104142 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
8010412d:	a1 80 49 11 80       	mov    0x80114980,%eax
80104132:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104138:	05 a0 43 11 80       	add    $0x801143a0,%eax
8010413d:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
80104142:	a1 80 49 11 80       	mov    0x80114980,%eax
80104147:	8b 15 80 49 11 80    	mov    0x80114980,%edx
8010414d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104153:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104158:	88 10                	mov    %dl,(%eax)
      ncpu++;
8010415a:	a1 80 49 11 80       	mov    0x80114980,%eax
8010415f:	83 c0 01             	add    $0x1,%eax
80104162:	a3 80 49 11 80       	mov    %eax,0x80114980
      p += sizeof(struct mpproc);
80104167:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010416b:	eb 42                	jmp    801041af <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104170:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80104173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104176:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010417a:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
8010417f:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104183:	eb 2a                	jmp    801041af <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104185:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104189:	eb 24                	jmp    801041af <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010418b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418e:	0f b6 00             	movzbl (%eax),%eax
80104191:	0f b6 c0             	movzbl %al,%eax
80104194:	83 ec 08             	sub    $0x8,%esp
80104197:	50                   	push   %eax
80104198:	68 80 a0 10 80       	push   $0x8010a080
8010419d:	e8 24 c2 ff ff       	call   801003c6 <cprintf>
801041a2:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
801041a5:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
801041ac:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801041af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801041b5:	0f 82 02 ff ff ff    	jb     801040bd <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801041bb:	a1 84 43 11 80       	mov    0x80114384,%eax
801041c0:	85 c0                	test   %eax,%eax
801041c2:	75 1d                	jne    801041e1 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801041c4:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
801041cb:	00 00 00 
    lapic = 0;
801041ce:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
801041d5:	00 00 00 
    ioapicid = 0;
801041d8:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
801041df:	eb 3e                	jmp    8010421f <mpinit+0x1c3>
  }

  if(mp->imcrp){
801041e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801041e4:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801041e8:	84 c0                	test   %al,%al
801041ea:	74 33                	je     8010421f <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801041ec:	83 ec 08             	sub    $0x8,%esp
801041ef:	6a 70                	push   $0x70
801041f1:	6a 22                	push   $0x22
801041f3:	e8 1c fc ff ff       	call   80103e14 <outb>
801041f8:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801041fb:	83 ec 0c             	sub    $0xc,%esp
801041fe:	6a 23                	push   $0x23
80104200:	e8 f2 fb ff ff       	call   80103df7 <inb>
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	83 c8 01             	or     $0x1,%eax
8010420b:	0f b6 c0             	movzbl %al,%eax
8010420e:	83 ec 08             	sub    $0x8,%esp
80104211:	50                   	push   %eax
80104212:	6a 23                	push   $0x23
80104214:	e8 fb fb ff ff       	call   80103e14 <outb>
80104219:	83 c4 10             	add    $0x10,%esp
8010421c:	eb 01                	jmp    8010421f <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
8010421e:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010421f:	c9                   	leave  
80104220:	c3                   	ret    

80104221 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80104221:	55                   	push   %ebp
80104222:	89 e5                	mov    %esp,%ebp
80104224:	83 ec 08             	sub    $0x8,%esp
80104227:	8b 55 08             	mov    0x8(%ebp),%edx
8010422a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010422d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104231:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104234:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104238:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010423c:	ee                   	out    %al,(%dx)
}
8010423d:	90                   	nop
8010423e:	c9                   	leave  
8010423f:	c3                   	ret    

80104240 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	83 ec 04             	sub    $0x4,%esp
80104246:	8b 45 08             	mov    0x8(%ebp),%eax
80104249:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
8010424d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104251:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104257:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010425b:	0f b6 c0             	movzbl %al,%eax
8010425e:	50                   	push   %eax
8010425f:	6a 21                	push   $0x21
80104261:	e8 bb ff ff ff       	call   80104221 <outb>
80104266:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104269:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010426d:	66 c1 e8 08          	shr    $0x8,%ax
80104271:	0f b6 c0             	movzbl %al,%eax
80104274:	50                   	push   %eax
80104275:	68 a1 00 00 00       	push   $0xa1
8010427a:	e8 a2 ff ff ff       	call   80104221 <outb>
8010427f:	83 c4 08             	add    $0x8,%esp
}
80104282:	90                   	nop
80104283:	c9                   	leave  
80104284:	c3                   	ret    

80104285 <picenable>:

void
picenable(int irq)
{
80104285:	55                   	push   %ebp
80104286:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104288:	8b 45 08             	mov    0x8(%ebp),%eax
8010428b:	ba 01 00 00 00       	mov    $0x1,%edx
80104290:	89 c1                	mov    %eax,%ecx
80104292:	d3 e2                	shl    %cl,%edx
80104294:	89 d0                	mov    %edx,%eax
80104296:	f7 d0                	not    %eax
80104298:	89 c2                	mov    %eax,%edx
8010429a:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801042a1:	21 d0                	and    %edx,%eax
801042a3:	0f b7 c0             	movzwl %ax,%eax
801042a6:	50                   	push   %eax
801042a7:	e8 94 ff ff ff       	call   80104240 <picsetmask>
801042ac:	83 c4 04             	add    $0x4,%esp
}
801042af:	90                   	nop
801042b0:	c9                   	leave  
801042b1:	c3                   	ret    

801042b2 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801042b2:	55                   	push   %ebp
801042b3:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
801042b5:	68 ff 00 00 00       	push   $0xff
801042ba:	6a 21                	push   $0x21
801042bc:	e8 60 ff ff ff       	call   80104221 <outb>
801042c1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801042c4:	68 ff 00 00 00       	push   $0xff
801042c9:	68 a1 00 00 00       	push   $0xa1
801042ce:	e8 4e ff ff ff       	call   80104221 <outb>
801042d3:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801042d6:	6a 11                	push   $0x11
801042d8:	6a 20                	push   $0x20
801042da:	e8 42 ff ff ff       	call   80104221 <outb>
801042df:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801042e2:	6a 20                	push   $0x20
801042e4:	6a 21                	push   $0x21
801042e6:	e8 36 ff ff ff       	call   80104221 <outb>
801042eb:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801042ee:	6a 04                	push   $0x4
801042f0:	6a 21                	push   $0x21
801042f2:	e8 2a ff ff ff       	call   80104221 <outb>
801042f7:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801042fa:	6a 03                	push   $0x3
801042fc:	6a 21                	push   $0x21
801042fe:	e8 1e ff ff ff       	call   80104221 <outb>
80104303:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104306:	6a 11                	push   $0x11
80104308:	68 a0 00 00 00       	push   $0xa0
8010430d:	e8 0f ff ff ff       	call   80104221 <outb>
80104312:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104315:	6a 28                	push   $0x28
80104317:	68 a1 00 00 00       	push   $0xa1
8010431c:	e8 00 ff ff ff       	call   80104221 <outb>
80104321:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104324:	6a 02                	push   $0x2
80104326:	68 a1 00 00 00       	push   $0xa1
8010432b:	e8 f1 fe ff ff       	call   80104221 <outb>
80104330:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104333:	6a 03                	push   $0x3
80104335:	68 a1 00 00 00       	push   $0xa1
8010433a:	e8 e2 fe ff ff       	call   80104221 <outb>
8010433f:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104342:	6a 68                	push   $0x68
80104344:	6a 20                	push   $0x20
80104346:	e8 d6 fe ff ff       	call   80104221 <outb>
8010434b:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010434e:	6a 0a                	push   $0xa
80104350:	6a 20                	push   $0x20
80104352:	e8 ca fe ff ff       	call   80104221 <outb>
80104357:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010435a:	6a 68                	push   $0x68
8010435c:	68 a0 00 00 00       	push   $0xa0
80104361:	e8 bb fe ff ff       	call   80104221 <outb>
80104366:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104369:	6a 0a                	push   $0xa
8010436b:	68 a0 00 00 00       	push   $0xa0
80104370:	e8 ac fe ff ff       	call   80104221 <outb>
80104375:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104378:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010437f:	66 83 f8 ff          	cmp    $0xffff,%ax
80104383:	74 13                	je     80104398 <picinit+0xe6>
    picsetmask(irqmask);
80104385:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010438c:	0f b7 c0             	movzwl %ax,%eax
8010438f:	50                   	push   %eax
80104390:	e8 ab fe ff ff       	call   80104240 <picsetmask>
80104395:	83 c4 04             	add    $0x4,%esp
}
80104398:	90                   	nop
80104399:	c9                   	leave  
8010439a:	c3                   	ret    

8010439b <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010439b:	55                   	push   %ebp
8010439c:	89 e5                	mov    %esp,%ebp
8010439e:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801043a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801043a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801043b4:	8b 10                	mov    (%eax),%edx
801043b6:	8b 45 08             	mov    0x8(%ebp),%eax
801043b9:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801043bb:	e8 20 cd ff ff       	call   801010e0 <filealloc>
801043c0:	89 c2                	mov    %eax,%edx
801043c2:	8b 45 08             	mov    0x8(%ebp),%eax
801043c5:	89 10                	mov    %edx,(%eax)
801043c7:	8b 45 08             	mov    0x8(%ebp),%eax
801043ca:	8b 00                	mov    (%eax),%eax
801043cc:	85 c0                	test   %eax,%eax
801043ce:	0f 84 cb 00 00 00    	je     8010449f <pipealloc+0x104>
801043d4:	e8 07 cd ff ff       	call   801010e0 <filealloc>
801043d9:	89 c2                	mov    %eax,%edx
801043db:	8b 45 0c             	mov    0xc(%ebp),%eax
801043de:	89 10                	mov    %edx,(%eax)
801043e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801043e3:	8b 00                	mov    (%eax),%eax
801043e5:	85 c0                	test   %eax,%eax
801043e7:	0f 84 b2 00 00 00    	je     8010449f <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801043ed:	e8 ce eb ff ff       	call   80102fc0 <kalloc>
801043f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043f9:	0f 84 9f 00 00 00    	je     8010449e <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801043ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104402:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104409:	00 00 00 
  p->writeopen = 1;
8010440c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440f:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104416:	00 00 00 
  p->nwrite = 0;
80104419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104423:	00 00 00 
  p->nread = 0;
80104426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104429:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104430:	00 00 00 
  initlock(&p->lock, "pipe");
80104433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104436:	83 ec 08             	sub    $0x8,%esp
80104439:	68 b4 a0 10 80       	push   $0x8010a0b4
8010443e:	50                   	push   %eax
8010443f:	e8 cf 20 00 00       	call   80106513 <initlock>
80104444:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104447:	8b 45 08             	mov    0x8(%ebp),%eax
8010444a:	8b 00                	mov    (%eax),%eax
8010444c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104452:	8b 45 08             	mov    0x8(%ebp),%eax
80104455:	8b 00                	mov    (%eax),%eax
80104457:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010445b:	8b 45 08             	mov    0x8(%ebp),%eax
8010445e:	8b 00                	mov    (%eax),%eax
80104460:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104464:	8b 45 08             	mov    0x8(%ebp),%eax
80104467:	8b 00                	mov    (%eax),%eax
80104469:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446c:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010446f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104472:	8b 00                	mov    (%eax),%eax
80104474:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010447a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010447d:	8b 00                	mov    (%eax),%eax
8010447f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104483:	8b 45 0c             	mov    0xc(%ebp),%eax
80104486:	8b 00                	mov    (%eax),%eax
80104488:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010448c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010448f:	8b 00                	mov    (%eax),%eax
80104491:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104494:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104497:	b8 00 00 00 00       	mov    $0x0,%eax
8010449c:	eb 4e                	jmp    801044ec <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
8010449e:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
8010449f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801044a3:	74 0e                	je     801044b3 <pipealloc+0x118>
    kfree((char*)p);
801044a5:	83 ec 0c             	sub    $0xc,%esp
801044a8:	ff 75 f4             	pushl  -0xc(%ebp)
801044ab:	e8 73 ea ff ff       	call   80102f23 <kfree>
801044b0:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801044b3:	8b 45 08             	mov    0x8(%ebp),%eax
801044b6:	8b 00                	mov    (%eax),%eax
801044b8:	85 c0                	test   %eax,%eax
801044ba:	74 11                	je     801044cd <pipealloc+0x132>
    fileclose(*f0);
801044bc:	8b 45 08             	mov    0x8(%ebp),%eax
801044bf:	8b 00                	mov    (%eax),%eax
801044c1:	83 ec 0c             	sub    $0xc,%esp
801044c4:	50                   	push   %eax
801044c5:	e8 d4 cc ff ff       	call   8010119e <fileclose>
801044ca:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801044cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801044d0:	8b 00                	mov    (%eax),%eax
801044d2:	85 c0                	test   %eax,%eax
801044d4:	74 11                	je     801044e7 <pipealloc+0x14c>
    fileclose(*f1);
801044d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801044d9:	8b 00                	mov    (%eax),%eax
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	50                   	push   %eax
801044df:	e8 ba cc ff ff       	call   8010119e <fileclose>
801044e4:	83 c4 10             	add    $0x10,%esp
  return -1;
801044e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044ec:	c9                   	leave  
801044ed:	c3                   	ret    

801044ee <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801044ee:	55                   	push   %ebp
801044ef:	89 e5                	mov    %esp,%ebp
801044f1:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801044f4:	8b 45 08             	mov    0x8(%ebp),%eax
801044f7:	83 ec 0c             	sub    $0xc,%esp
801044fa:	50                   	push   %eax
801044fb:	e8 35 20 00 00       	call   80106535 <acquire>
80104500:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104507:	74 23                	je     8010452c <pipeclose+0x3e>
    p->writeopen = 0;
80104509:	8b 45 08             	mov    0x8(%ebp),%eax
8010450c:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104513:	00 00 00 
    wakeup(&p->nread);
80104516:	8b 45 08             	mov    0x8(%ebp),%eax
80104519:	05 34 02 00 00       	add    $0x234,%eax
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	50                   	push   %eax
80104522:	e8 6d 13 00 00       	call   80105894 <wakeup>
80104527:	83 c4 10             	add    $0x10,%esp
8010452a:	eb 21                	jmp    8010454d <pipeclose+0x5f>
  } else {
    p->readopen = 0;
8010452c:	8b 45 08             	mov    0x8(%ebp),%eax
8010452f:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104536:	00 00 00 
    wakeup(&p->nwrite);
80104539:	8b 45 08             	mov    0x8(%ebp),%eax
8010453c:	05 38 02 00 00       	add    $0x238,%eax
80104541:	83 ec 0c             	sub    $0xc,%esp
80104544:	50                   	push   %eax
80104545:	e8 4a 13 00 00       	call   80105894 <wakeup>
8010454a:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010454d:	8b 45 08             	mov    0x8(%ebp),%eax
80104550:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104556:	85 c0                	test   %eax,%eax
80104558:	75 2c                	jne    80104586 <pipeclose+0x98>
8010455a:	8b 45 08             	mov    0x8(%ebp),%eax
8010455d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104563:	85 c0                	test   %eax,%eax
80104565:	75 1f                	jne    80104586 <pipeclose+0x98>
    release(&p->lock);
80104567:	8b 45 08             	mov    0x8(%ebp),%eax
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	50                   	push   %eax
8010456e:	e8 29 20 00 00       	call   8010659c <release>
80104573:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	ff 75 08             	pushl  0x8(%ebp)
8010457c:	e8 a2 e9 ff ff       	call   80102f23 <kfree>
80104581:	83 c4 10             	add    $0x10,%esp
80104584:	eb 0f                	jmp    80104595 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104586:	8b 45 08             	mov    0x8(%ebp),%eax
80104589:	83 ec 0c             	sub    $0xc,%esp
8010458c:	50                   	push   %eax
8010458d:	e8 0a 20 00 00       	call   8010659c <release>
80104592:	83 c4 10             	add    $0x10,%esp
}
80104595:	90                   	nop
80104596:	c9                   	leave  
80104597:	c3                   	ret    

80104598 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80104598:	55                   	push   %ebp
80104599:	89 e5                	mov    %esp,%ebp
8010459b:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010459e:	8b 45 08             	mov    0x8(%ebp),%eax
801045a1:	83 ec 0c             	sub    $0xc,%esp
801045a4:	50                   	push   %eax
801045a5:	e8 8b 1f 00 00       	call   80106535 <acquire>
801045aa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801045ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801045b4:	e9 ad 00 00 00       	jmp    80104666 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801045b9:	8b 45 08             	mov    0x8(%ebp),%eax
801045bc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801045c2:	85 c0                	test   %eax,%eax
801045c4:	74 0d                	je     801045d3 <pipewrite+0x3b>
801045c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045cc:	8b 40 24             	mov    0x24(%eax),%eax
801045cf:	85 c0                	test   %eax,%eax
801045d1:	74 19                	je     801045ec <pipewrite+0x54>
        release(&p->lock);
801045d3:	8b 45 08             	mov    0x8(%ebp),%eax
801045d6:	83 ec 0c             	sub    $0xc,%esp
801045d9:	50                   	push   %eax
801045da:	e8 bd 1f 00 00       	call   8010659c <release>
801045df:	83 c4 10             	add    $0x10,%esp
        return -1;
801045e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045e7:	e9 a8 00 00 00       	jmp    80104694 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801045ec:	8b 45 08             	mov    0x8(%ebp),%eax
801045ef:	05 34 02 00 00       	add    $0x234,%eax
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	50                   	push   %eax
801045f8:	e8 97 12 00 00       	call   80105894 <wakeup>
801045fd:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104600:	8b 45 08             	mov    0x8(%ebp),%eax
80104603:	8b 55 08             	mov    0x8(%ebp),%edx
80104606:	81 c2 38 02 00 00    	add    $0x238,%edx
8010460c:	83 ec 08             	sub    $0x8,%esp
8010460f:	50                   	push   %eax
80104610:	52                   	push   %edx
80104611:	e8 4d 10 00 00       	call   80105663 <sleep>
80104616:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104619:	8b 45 08             	mov    0x8(%ebp),%eax
8010461c:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104622:	8b 45 08             	mov    0x8(%ebp),%eax
80104625:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010462b:	05 00 02 00 00       	add    $0x200,%eax
80104630:	39 c2                	cmp    %eax,%edx
80104632:	74 85                	je     801045b9 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104634:	8b 45 08             	mov    0x8(%ebp),%eax
80104637:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010463d:	8d 48 01             	lea    0x1(%eax),%ecx
80104640:	8b 55 08             	mov    0x8(%ebp),%edx
80104643:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104649:	25 ff 01 00 00       	and    $0x1ff,%eax
8010464e:	89 c1                	mov    %eax,%ecx
80104650:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104653:	8b 45 0c             	mov    0xc(%ebp),%eax
80104656:	01 d0                	add    %edx,%eax
80104658:	0f b6 10             	movzbl (%eax),%edx
8010465b:	8b 45 08             	mov    0x8(%ebp),%eax
8010465e:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104662:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104669:	3b 45 10             	cmp    0x10(%ebp),%eax
8010466c:	7c ab                	jl     80104619 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010466e:	8b 45 08             	mov    0x8(%ebp),%eax
80104671:	05 34 02 00 00       	add    $0x234,%eax
80104676:	83 ec 0c             	sub    $0xc,%esp
80104679:	50                   	push   %eax
8010467a:	e8 15 12 00 00       	call   80105894 <wakeup>
8010467f:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104682:	8b 45 08             	mov    0x8(%ebp),%eax
80104685:	83 ec 0c             	sub    $0xc,%esp
80104688:	50                   	push   %eax
80104689:	e8 0e 1f 00 00       	call   8010659c <release>
8010468e:	83 c4 10             	add    $0x10,%esp
  return n;
80104691:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104694:	c9                   	leave  
80104695:	c3                   	ret    

80104696 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104696:	55                   	push   %ebp
80104697:	89 e5                	mov    %esp,%ebp
80104699:	53                   	push   %ebx
8010469a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010469d:	8b 45 08             	mov    0x8(%ebp),%eax
801046a0:	83 ec 0c             	sub    $0xc,%esp
801046a3:	50                   	push   %eax
801046a4:	e8 8c 1e 00 00       	call   80106535 <acquire>
801046a9:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801046ac:	eb 3f                	jmp    801046ed <piperead+0x57>
    if(proc->killed){
801046ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b4:	8b 40 24             	mov    0x24(%eax),%eax
801046b7:	85 c0                	test   %eax,%eax
801046b9:	74 19                	je     801046d4 <piperead+0x3e>
      release(&p->lock);
801046bb:	8b 45 08             	mov    0x8(%ebp),%eax
801046be:	83 ec 0c             	sub    $0xc,%esp
801046c1:	50                   	push   %eax
801046c2:	e8 d5 1e 00 00       	call   8010659c <release>
801046c7:	83 c4 10             	add    $0x10,%esp
      return -1;
801046ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046cf:	e9 bf 00 00 00       	jmp    80104793 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801046d4:	8b 45 08             	mov    0x8(%ebp),%eax
801046d7:	8b 55 08             	mov    0x8(%ebp),%edx
801046da:	81 c2 34 02 00 00    	add    $0x234,%edx
801046e0:	83 ec 08             	sub    $0x8,%esp
801046e3:	50                   	push   %eax
801046e4:	52                   	push   %edx
801046e5:	e8 79 0f 00 00       	call   80105663 <sleep>
801046ea:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801046ed:	8b 45 08             	mov    0x8(%ebp),%eax
801046f0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046f6:	8b 45 08             	mov    0x8(%ebp),%eax
801046f9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046ff:	39 c2                	cmp    %eax,%edx
80104701:	75 0d                	jne    80104710 <piperead+0x7a>
80104703:	8b 45 08             	mov    0x8(%ebp),%eax
80104706:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010470c:	85 c0                	test   %eax,%eax
8010470e:	75 9e                	jne    801046ae <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104710:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104717:	eb 49                	jmp    80104762 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104719:	8b 45 08             	mov    0x8(%ebp),%eax
8010471c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104722:	8b 45 08             	mov    0x8(%ebp),%eax
80104725:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010472b:	39 c2                	cmp    %eax,%edx
8010472d:	74 3d                	je     8010476c <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010472f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104732:	8b 45 0c             	mov    0xc(%ebp),%eax
80104735:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104738:	8b 45 08             	mov    0x8(%ebp),%eax
8010473b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104741:	8d 48 01             	lea    0x1(%eax),%ecx
80104744:	8b 55 08             	mov    0x8(%ebp),%edx
80104747:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010474d:	25 ff 01 00 00       	and    $0x1ff,%eax
80104752:	89 c2                	mov    %eax,%edx
80104754:	8b 45 08             	mov    0x8(%ebp),%eax
80104757:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010475c:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010475e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104765:	3b 45 10             	cmp    0x10(%ebp),%eax
80104768:	7c af                	jl     80104719 <piperead+0x83>
8010476a:	eb 01                	jmp    8010476d <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
8010476c:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010476d:	8b 45 08             	mov    0x8(%ebp),%eax
80104770:	05 38 02 00 00       	add    $0x238,%eax
80104775:	83 ec 0c             	sub    $0xc,%esp
80104778:	50                   	push   %eax
80104779:	e8 16 11 00 00       	call   80105894 <wakeup>
8010477e:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104781:	8b 45 08             	mov    0x8(%ebp),%eax
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	50                   	push   %eax
80104788:	e8 0f 1e 00 00       	call   8010659c <release>
8010478d:	83 c4 10             	add    $0x10,%esp
  return i;
80104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104793:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104796:	c9                   	leave  
80104797:	c3                   	ret    

80104798 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
80104798:	55                   	push   %ebp
80104799:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
8010479b:	f4                   	hlt    
}
8010479c:	90                   	nop
8010479d:	5d                   	pop    %ebp
8010479e:	c3                   	ret    

8010479f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010479f:	55                   	push   %ebp
801047a0:	89 e5                	mov    %esp,%ebp
801047a2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047a5:	9c                   	pushf  
801047a6:	58                   	pop    %eax
801047a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801047aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801047ad:	c9                   	leave  
801047ae:	c3                   	ret    

801047af <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801047af:	55                   	push   %ebp
801047b0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801047b2:	fb                   	sti    
}
801047b3:	90                   	nop
801047b4:	5d                   	pop    %ebp
801047b5:	c3                   	ret    

801047b6 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801047b6:	55                   	push   %ebp
801047b7:	89 e5                	mov    %esp,%ebp
801047b9:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801047bc:	83 ec 08             	sub    $0x8,%esp
801047bf:	68 bc a0 10 80       	push   $0x8010a0bc
801047c4:	68 a0 49 11 80       	push   $0x801149a0
801047c9:	e8 45 1d 00 00       	call   80106513 <initlock>
801047ce:	83 c4 10             	add    $0x10,%esp
}
801047d1:	90                   	nop
801047d2:	c9                   	leave  
801047d3:	c3                   	ret    

801047d4 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801047da:	83 ec 0c             	sub    $0xc,%esp
801047dd:	68 a0 49 11 80       	push   $0x801149a0
801047e2:	e8 4e 1d 00 00       	call   80106535 <acquire>
801047e7:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
    p = removeFront(&ptable.pLists.free);
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	68 f0 70 11 80       	push   $0x801170f0
801047f2:	e8 a1 17 00 00       	call   80105f98 <removeFront>
801047f7:	83 c4 10             	add    $0x10,%esp
801047fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p != 0){
801047fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104801:	74 71                	je     80104874 <allocproc+0xa0>
      assertState(p, UNUSED);
80104803:	83 ec 08             	sub    $0x8,%esp
80104806:	6a 00                	push   $0x0
80104808:	ff 75 f4             	pushl  -0xc(%ebp)
8010480b:	e8 6d 15 00 00       	call   80105d7d <assertState>
80104810:	83 c4 10             	add    $0x10,%esp
      goto found;
80104813:	90                   	nop

found:
  // remove from freeList, assert state, insert in Embryo
  #ifdef CS333_P3P4
    
      p->state = EMBRYO;
80104814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104817:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
      insertAtHead(&ptable.pLists.embryo, p);
8010481e:	83 ec 08             	sub    $0x8,%esp
80104821:	ff 75 f4             	pushl  -0xc(%ebp)
80104824:	68 00 71 11 80       	push   $0x80117100
80104829:	e8 e5 18 00 00       	call   80106113 <insertAtHead>
8010482e:	83 c4 10             	add    $0x10,%esp
   
  #else
   p->state = EMBRYO;              // check this
  #endif

  p->pid = nextpid++;
80104831:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104836:	8d 50 01             	lea    0x1(%eax),%edx
80104839:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
8010483f:	89 c2                	mov    %eax,%edx
80104841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104844:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104847:	83 ec 0c             	sub    $0xc,%esp
8010484a:	68 a0 49 11 80       	push   $0x801149a0
8010484f:	e8 48 1d 00 00       	call   8010659c <release>
80104854:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104857:	e8 64 e7 ff ff       	call   80102fc0 <kalloc>
8010485c:	89 c2                	mov    %eax,%edx
8010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104861:	89 50 08             	mov    %edx,0x8(%eax)
80104864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104867:	8b 40 08             	mov    0x8(%eax),%eax
8010486a:	85 c0                	test   %eax,%eax
8010486c:	0f 85 86 00 00 00    	jne    801048f8 <allocproc+0x124>
80104872:	eb 1a                	jmp    8010488e <allocproc+0xba>
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #endif
  release(&ptable.lock);
80104874:	83 ec 0c             	sub    $0xc,%esp
80104877:	68 a0 49 11 80       	push   $0x801149a0
8010487c:	e8 1b 1d 00 00       	call   8010659c <release>
80104881:	83 c4 10             	add    $0x10,%esp
  return 0;
80104884:	b8 00 00 00 00       	mov    $0x0,%eax
80104889:	e9 07 01 00 00       	jmp    80104995 <allocproc+0x1c1>
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4                       //******* check this logic IMPORTant
    acquire(&ptable.lock);
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	68 a0 49 11 80       	push   $0x801149a0
80104896:	e8 9a 1c 00 00       	call   80106535 <acquire>
8010489b:	83 c4 10             	add    $0x10,%esp
    assertState(p, EMBRYO);
8010489e:	83 ec 08             	sub    $0x8,%esp
801048a1:	6a 01                	push   $0x1
801048a3:	ff 75 f4             	pushl  -0xc(%ebp)
801048a6:	e8 d2 14 00 00       	call   80105d7d <assertState>
801048ab:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, p);
801048ae:	83 ec 08             	sub    $0x8,%esp
801048b1:	ff 75 f4             	pushl  -0xc(%ebp)
801048b4:	68 00 71 11 80       	push   $0x80117100
801048b9:	e8 09 15 00 00       	call   80105dc7 <removeFromStateList>
801048be:	83 c4 10             	add    $0x10,%esp
    p->state = UNUSED;                // should I put it in the else block
801048c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, p);
801048cb:	83 ec 08             	sub    $0x8,%esp
801048ce:	ff 75 f4             	pushl  -0xc(%ebp)
801048d1:	68 f0 70 11 80       	push   $0x801170f0
801048d6:	e8 38 18 00 00       	call   80106113 <insertAtHead>
801048db:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801048de:	83 ec 0c             	sub    $0xc,%esp
801048e1:	68 a0 49 11 80       	push   $0x801149a0
801048e6:	e8 b1 1c 00 00       	call   8010659c <release>
801048eb:	83 c4 10             	add    $0x10,%esp
    
    #else
    p->state = UNUSED;               
    #endif

    return 0;
801048ee:	b8 00 00 00 00       	mov    $0x0,%eax
801048f3:	e9 9d 00 00 00       	jmp    80104995 <allocproc+0x1c1>
  }
  sp = p->kstack + KSTACKSIZE;
801048f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fb:	8b 40 08             	mov    0x8(%eax),%eax
801048fe:	05 00 10 00 00       	add    $0x1000,%eax
80104903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104906:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010490a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104910:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104913:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104917:	ba 8a 7e 10 80       	mov    $0x80107e8a,%edx
8010491c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491f:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104921:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104928:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010492b:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104931:	8b 40 1c             	mov    0x1c(%eax),%eax
80104934:	83 ec 04             	sub    $0x4,%esp
80104937:	6a 14                	push   $0x14
80104939:	6a 00                	push   $0x0
8010493b:	50                   	push   %eax
8010493c:	e8 57 1e 00 00       	call   80106798 <memset>
80104941:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104947:	8b 40 1c             	mov    0x1c(%eax),%eax
8010494a:	ba 1d 56 10 80       	mov    $0x8010561d,%edx
8010494f:	89 50 10             	mov    %edx,0x10(%eax)
  p->start_ticks = ticks;
80104952:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80104958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495b:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total =0;
8010495e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104961:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104968:	00 00 00 
  p->cpu_ticks_in =0;
8010496b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496e:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104975:	00 00 00 

  p->priority = 0;
80104978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497b:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104982:	00 00 00 
  p->budget = BUDGET;
80104985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104988:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
8010498f:	13 00 00 

  return p;
80104992:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
80104995:	c9                   	leave  
80104996:	c3                   	ret    

80104997 <userinit>:

// Set up first user process.
void
userinit(void)
{
80104997:	55                   	push   %ebp
80104998:	89 e5                	mov    %esp,%ebp
8010499a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
8010499d:	83 ec 0c             	sub    $0xc,%esp
801049a0:	68 a0 49 11 80       	push   $0x801149a0
801049a5:	e8 8b 1b 00 00       	call   80106535 <acquire>
801049aa:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
801049ad:	c7 05 f0 70 11 80 00 	movl   $0x0,0x801170f0
801049b4:	00 00 00 
  for(int i =0; i <= MAX; i++){                  //P4 initialize array list
801049b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049be:	eb 17                	jmp    801049d7 <userinit+0x40>
    ptable.pLists.ready[i] = 0;
801049c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c3:	05 cc 09 00 00       	add    $0x9cc,%eax
801049c8:	c7 04 85 a4 49 11 80 	movl   $0x0,-0x7feeb65c(,%eax,4)
801049cf:	00 00 00 00 
  extern char _binary_initcode_start[], _binary_initcode_size[];

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  ptable.pLists.free = 0;
  for(int i =0; i <= MAX; i++){                  //P4 initialize array list
801049d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801049d7:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
801049db:	7e e3                	jle    801049c0 <userinit+0x29>
    ptable.pLists.ready[i] = 0;
  }
  ptable.pLists.sleep = 0;
801049dd:	c7 05 f4 70 11 80 00 	movl   $0x0,0x801170f4
801049e4:	00 00 00 
  ptable.pLists.embryo = 0;
801049e7:	c7 05 00 71 11 80 00 	movl   $0x0,0x80117100
801049ee:	00 00 00 
  ptable.pLists.running = 0;
801049f1:	c7 05 fc 70 11 80 00 	movl   $0x0,0x801170fc
801049f8:	00 00 00 
  ptable.pLists.zombie = 0;
801049fb:	c7 05 f8 70 11 80 00 	movl   $0x0,0x801170f8
80104a02:	00 00 00 

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;   //P4 initilize ticksToPromote
80104a05:	a1 20 79 11 80       	mov    0x80117920,%eax
80104a0a:	05 b8 0b 00 00       	add    $0xbb8,%eax
80104a0f:	a3 04 71 11 80       	mov    %eax,0x80117104

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a14:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80104a1b:	eb 24                	jmp    80104a41 <userinit+0xaa>
    p -> state = UNUSED;
80104a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, p);
80104a27:	83 ec 08             	sub    $0x8,%esp
80104a2a:	ff 75 f4             	pushl  -0xc(%ebp)
80104a2d:	68 f0 70 11 80       	push   $0x801170f0
80104a32:	e8 dc 16 00 00       	call   80106113 <insertAtHead>
80104a37:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.zombie = 0;

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;   //P4 initilize ticksToPromote

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a3a:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104a41:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80104a48:	72 d3                	jb     80104a1d <userinit+0x86>
    p -> state = UNUSED;
    insertAtHead(&ptable.pLists.free, p);
 }
  release(&ptable.lock);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	68 a0 49 11 80       	push   $0x801149a0
80104a52:	e8 45 1b 00 00       	call   8010659c <release>
80104a57:	83 c4 10             	add    $0x10,%esp
  #endif

  p = allocproc();
80104a5a:	e8 75 fd ff ff       	call   801047d4 <allocproc>
80104a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a65:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
80104a6a:	e8 dd 4a 00 00       	call   8010954c <setupkvm>
80104a6f:	89 c2                	mov    %eax,%edx
80104a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a74:	89 50 04             	mov    %edx,0x4(%eax)
80104a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a7a:	8b 40 04             	mov    0x4(%eax),%eax
80104a7d:	85 c0                	test   %eax,%eax
80104a7f:	75 0d                	jne    80104a8e <userinit+0xf7>
    panic("userinit: out of memory?");
80104a81:	83 ec 0c             	sub    $0xc,%esp
80104a84:	68 c3 a0 10 80       	push   $0x8010a0c3
80104a89:	e8 d8 ba ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104a8e:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a96:	8b 40 04             	mov    0x4(%eax),%eax
80104a99:	83 ec 04             	sub    $0x4,%esp
80104a9c:	52                   	push   %edx
80104a9d:	68 20 d5 10 80       	push   $0x8010d520
80104aa2:	50                   	push   %eax
80104aa3:	e8 fe 4c 00 00       	call   801097a6 <inituvm>
80104aa8:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aae:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab7:	8b 40 18             	mov    0x18(%eax),%eax
80104aba:	83 ec 04             	sub    $0x4,%esp
80104abd:	6a 4c                	push   $0x4c
80104abf:	6a 00                	push   $0x0
80104ac1:	50                   	push   %eax
80104ac2:	e8 d1 1c 00 00       	call   80106798 <memset>
80104ac7:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104acd:	8b 40 18             	mov    0x18(%eax),%eax
80104ad0:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad9:	8b 40 18             	mov    0x18(%eax),%eax
80104adc:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae5:	8b 40 18             	mov    0x18(%eax),%eax
80104ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aeb:	8b 52 18             	mov    0x18(%edx),%edx
80104aee:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104af2:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af9:	8b 40 18             	mov    0x18(%eax),%eax
80104afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aff:	8b 52 18             	mov    0x18(%edx),%edx
80104b02:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104b06:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0d:	8b 40 18             	mov    0x18(%eax),%eax
80104b10:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1a:	8b 40 18             	mov    0x18(%eax),%eax
80104b1d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b27:	8b 40 18             	mov    0x18(%eax),%eax
80104b2a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b34:	83 c0 6c             	add    $0x6c,%eax
80104b37:	83 ec 04             	sub    $0x4,%esp
80104b3a:	6a 10                	push   $0x10
80104b3c:	68 dc a0 10 80       	push   $0x8010a0dc
80104b41:	50                   	push   %eax
80104b42:	e8 54 1e 00 00       	call   8010699b <safestrcpy>
80104b47:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	68 e5 a0 10 80       	push   $0x8010a0e5
80104b52:	e8 b2 db ff ff       	call   80102709 <namei>
80104b57:	83 c4 10             	add    $0x10,%esp
80104b5a:	89 c2                	mov    %eax,%edx
80104b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5f:	89 50 68             	mov    %edx,0x68(%eax)
  p->parent = p;            // set up parent  -- change it later to zero
80104b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b68:	89 50 14             	mov    %edx,0x14(%eax)
  // change the state
  // assert new state
  // insert into ready 

  #ifdef CS333_P3P4                             
    acquire(&ptable.lock);
80104b6b:	83 ec 0c             	sub    $0xc,%esp
80104b6e:	68 a0 49 11 80       	push   $0x801149a0
80104b73:	e8 bd 19 00 00       	call   80106535 <acquire>
80104b78:	83 c4 10             	add    $0x10,%esp
    assertState(p, EMBRYO);
80104b7b:	83 ec 08             	sub    $0x8,%esp
80104b7e:	6a 01                	push   $0x1
80104b80:	ff 75 f4             	pushl  -0xc(%ebp)
80104b83:	e8 f5 11 00 00       	call   80105d7d <assertState>
80104b88:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, p);
80104b8b:	83 ec 08             	sub    $0x8,%esp
80104b8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104b91:	68 00 71 11 80       	push   $0x80117100
80104b96:	e8 2c 12 00 00       	call   80105dc7 <removeFromStateList>
80104b9b:	83 c4 10             	add    $0x10,%esp
    p->state = RUNNABLE;                        //P4 insert the first process at ready[0]
80104b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready[0], p);
80104ba8:	83 ec 08             	sub    $0x8,%esp
80104bab:	ff 75 f4             	pushl  -0xc(%ebp)
80104bae:	68 d4 70 11 80       	push   $0x801170d4
80104bb3:	e8 f4 14 00 00       	call   801060ac <insertTail>
80104bb8:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104bbb:	83 ec 0c             	sub    $0xc,%esp
80104bbe:	68 a0 49 11 80       	push   $0x801149a0
80104bc3:	e8 d4 19 00 00       	call   8010659c <release>
80104bc8:	83 c4 10             	add    $0x10,%esp
  #else
    p->state = RUNNABLE;                        
  #endif  
  p->uid = UID;
80104bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bce:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104bd5:	00 00 00 
  p->gid = GID;                                 
80104bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdb:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104be2:	00 00 00 
}
80104be5:	90                   	nop
80104be6:	c9                   	leave  
80104be7:	c3                   	ret    

80104be8 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104be8:	55                   	push   %ebp
80104be9:	89 e5                	mov    %esp,%ebp
80104beb:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104bee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf4:	8b 00                	mov    (%eax),%eax
80104bf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104bf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104bfd:	7e 31                	jle    80104c30 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104bff:	8b 55 08             	mov    0x8(%ebp),%edx
80104c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c05:	01 c2                	add    %eax,%edx
80104c07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c0d:	8b 40 04             	mov    0x4(%eax),%eax
80104c10:	83 ec 04             	sub    $0x4,%esp
80104c13:	52                   	push   %edx
80104c14:	ff 75 f4             	pushl  -0xc(%ebp)
80104c17:	50                   	push   %eax
80104c18:	e8 d6 4c 00 00       	call   801098f3 <allocuvm>
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c27:	75 3e                	jne    80104c67 <growproc+0x7f>
      return -1;
80104c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c2e:	eb 59                	jmp    80104c89 <growproc+0xa1>
  } else if(n < 0){
80104c30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104c34:	79 31                	jns    80104c67 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104c36:	8b 55 08             	mov    0x8(%ebp),%edx
80104c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3c:	01 c2                	add    %eax,%edx
80104c3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c44:	8b 40 04             	mov    0x4(%eax),%eax
80104c47:	83 ec 04             	sub    $0x4,%esp
80104c4a:	52                   	push   %edx
80104c4b:	ff 75 f4             	pushl  -0xc(%ebp)
80104c4e:	50                   	push   %eax
80104c4f:	e8 68 4d 00 00       	call   801099bc <deallocuvm>
80104c54:	83 c4 10             	add    $0x10,%esp
80104c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c5e:	75 07                	jne    80104c67 <growproc+0x7f>
      return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c65:	eb 22                	jmp    80104c89 <growproc+0xa1>
  }
  proc->sz = sz;
80104c67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c70:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104c72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c78:	83 ec 0c             	sub    $0xc,%esp
80104c7b:	50                   	push   %eax
80104c7c:	e8 b2 49 00 00       	call   80109633 <switchuvm>
80104c81:	83 c4 10             	add    $0x10,%esp
  return 0;
80104c84:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c89:	c9                   	leave  
80104c8a:	c3                   	ret    

80104c8b <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104c8b:	55                   	push   %ebp
80104c8c:	89 e5                	mov    %esp,%ebp
80104c8e:	57                   	push   %edi
80104c8f:	56                   	push   %esi
80104c90:	53                   	push   %ebx
80104c91:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104c94:	e8 3b fb ff ff       	call   801047d4 <allocproc>
80104c99:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104c9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104ca0:	75 0a                	jne    80104cac <fork+0x21>
    return -1;
80104ca2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca7:	e9 37 02 00 00       	jmp    80104ee3 <fork+0x258>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104cac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb2:	8b 10                	mov    (%eax),%edx
80104cb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cba:	8b 40 04             	mov    0x4(%eax),%eax
80104cbd:	83 ec 08             	sub    $0x8,%esp
80104cc0:	52                   	push   %edx
80104cc1:	50                   	push   %eax
80104cc2:	e8 93 4e 00 00       	call   80109b5a <copyuvm>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	89 c2                	mov    %eax,%edx
80104ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ccf:	89 50 04             	mov    %edx,0x4(%eax)
80104cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cd5:	8b 40 04             	mov    0x4(%eax),%eax
80104cd8:	85 c0                	test   %eax,%eax
80104cda:	0f 85 86 00 00 00    	jne    80104d66 <fork+0xdb>
    kfree(np->kstack);
80104ce0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ce3:	8b 40 08             	mov    0x8(%eax),%eax
80104ce6:	83 ec 0c             	sub    $0xc,%esp
80104ce9:	50                   	push   %eax
80104cea:	e8 34 e2 ff ff       	call   80102f23 <kfree>
80104cef:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cf5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

  #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104cfc:	83 ec 0c             	sub    $0xc,%esp
80104cff:	68 a0 49 11 80       	push   $0x801149a0
80104d04:	e8 2c 18 00 00       	call   80106535 <acquire>
80104d09:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104d0c:	83 ec 08             	sub    $0x8,%esp
80104d0f:	6a 01                	push   $0x1
80104d11:	ff 75 e0             	pushl  -0x20(%ebp)
80104d14:	e8 64 10 00 00       	call   80105d7d <assertState>
80104d19:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, np);
80104d1c:	83 ec 08             	sub    $0x8,%esp
80104d1f:	ff 75 e0             	pushl  -0x20(%ebp)
80104d22:	68 00 71 11 80       	push   $0x80117100
80104d27:	e8 9b 10 00 00       	call   80105dc7 <removeFromStateList>
80104d2c:	83 c4 10             	add    $0x10,%esp

    np->state = UNUSED;                         // *** assert and add it back to free list
80104d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, np);
80104d39:	83 ec 08             	sub    $0x8,%esp
80104d3c:	ff 75 e0             	pushl  -0x20(%ebp)
80104d3f:	68 f0 70 11 80       	push   $0x801170f0
80104d44:	e8 ca 13 00 00       	call   80106113 <insertAtHead>
80104d49:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	68 a0 49 11 80       	push   $0x801149a0
80104d54:	e8 43 18 00 00       	call   8010659c <release>
80104d59:	83 c4 10             	add    $0x10,%esp
  #else
    np->state = UNUSED;                         // *** assert and add it back to free list
  #endif

  return -1;
80104d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d61:	e9 7d 01 00 00       	jmp    80104ee3 <fork+0x258>
  }
  np->sz = proc->sz;
80104d66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6c:	8b 10                	mov    (%eax),%edx
80104d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d71:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104d73:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d7d:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d83:	8b 50 18             	mov    0x18(%eax),%edx
80104d86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8c:	8b 40 18             	mov    0x18(%eax),%eax
80104d8f:	89 c3                	mov    %eax,%ebx
80104d91:	b8 13 00 00 00       	mov    $0x13,%eax
80104d96:	89 d7                	mov    %edx,%edi
80104d98:	89 de                	mov    %ebx,%esi
80104d9a:	89 c1                	mov    %eax,%ecx
80104d9c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->uid = proc->uid;
80104d9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da4:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104daa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dad:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;                          
80104db3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db9:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dc2:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dcb:	8b 40 18             	mov    0x18(%eax),%eax
80104dce:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104dd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104ddc:	eb 43                	jmp    80104e21 <fork+0x196>
    if(proc->ofile[i])
80104dde:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104de7:	83 c2 08             	add    $0x8,%edx
80104dea:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104dee:	85 c0                	test   %eax,%eax
80104df0:	74 2b                	je     80104e1d <fork+0x192>
      np->ofile[i] = filedup(proc->ofile[i]);
80104df2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104dfb:	83 c2 08             	add    $0x8,%edx
80104dfe:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104e02:	83 ec 0c             	sub    $0xc,%esp
80104e05:	50                   	push   %eax
80104e06:	e8 42 c3 ff ff       	call   8010114d <filedup>
80104e0b:	83 c4 10             	add    $0x10,%esp
80104e0e:	89 c1                	mov    %eax,%ecx
80104e10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e16:	83 c2 08             	add    $0x8,%edx
80104e19:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid;                          

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104e1d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104e21:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104e25:	7e b7                	jle    80104dde <fork+0x153>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104e27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2d:	8b 40 68             	mov    0x68(%eax),%eax
80104e30:	83 ec 0c             	sub    $0xc,%esp
80104e33:	50                   	push   %eax
80104e34:	e8 88 cc ff ff       	call   80101ac1 <idup>
80104e39:	83 c4 10             	add    $0x10,%esp
80104e3c:	89 c2                	mov    %eax,%edx
80104e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e41:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104e44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4a:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e50:	83 c0 6c             	add    $0x6c,%eax
80104e53:	83 ec 04             	sub    $0x4,%esp
80104e56:	6a 10                	push   $0x10
80104e58:	52                   	push   %edx
80104e59:	50                   	push   %eax
80104e5a:	e8 3c 1b 00 00       	call   8010699b <safestrcpy>
80104e5f:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e65:	8b 40 10             	mov    0x10(%eax),%eax
80104e68:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.

 #ifdef CS333_P3P4                          // ****** check this block
    acquire(&ptable.lock);
80104e6b:	83 ec 0c             	sub    $0xc,%esp
80104e6e:	68 a0 49 11 80       	push   $0x801149a0
80104e73:	e8 bd 16 00 00       	call   80106535 <acquire>
80104e78:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104e7b:	83 ec 08             	sub    $0x8,%esp
80104e7e:	6a 01                	push   $0x1
80104e80:	ff 75 e0             	pushl  -0x20(%ebp)
80104e83:	e8 f5 0e 00 00       	call   80105d7d <assertState>
80104e88:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, np);
80104e8b:	83 ec 08             	sub    $0x8,%esp
80104e8e:	ff 75 e0             	pushl  -0x20(%ebp)
80104e91:	68 00 71 11 80       	push   $0x80117100
80104e96:	e8 2c 0f 00 00       	call   80105dc7 <removeFromStateList>
80104e9b:	83 c4 10             	add    $0x10,%esp
    np->state = RUNNABLE;
80104e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ea1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready[np -> priority], np);                 //P4 inserting at the priority index
80104ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eab:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104eb1:	05 cc 09 00 00       	add    $0x9cc,%eax
80104eb6:	c1 e0 02             	shl    $0x2,%eax
80104eb9:	05 a0 49 11 80       	add    $0x801149a0,%eax
80104ebe:	83 c0 04             	add    $0x4,%eax
80104ec1:	83 ec 08             	sub    $0x8,%esp
80104ec4:	ff 75 e0             	pushl  -0x20(%ebp)
80104ec7:	50                   	push   %eax
80104ec8:	e8 df 11 00 00       	call   801060ac <insertTail>
80104ecd:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104ed0:	83 ec 0c             	sub    $0xc,%esp
80104ed3:	68 a0 49 11 80       	push   $0x801149a0
80104ed8:	e8 bf 16 00 00       	call   8010659c <release>
80104edd:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
    np->state = RUNNABLE;                   // *** repeat same logic as above  coming from Embryo to runnable
    release(&ptable.lock);
  #endif
  
  return pid;
80104ee0:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee6:	5b                   	pop    %ebx
80104ee7:	5e                   	pop    %esi
80104ee8:	5f                   	pop    %edi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    

80104eeb <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104eeb:	55                   	push   %ebp
80104eec:	89 e5                	mov    %esp,%ebp
80104eee:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104ef1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ef8:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104efd:	39 c2                	cmp    %eax,%edx
80104eff:	75 0d                	jne    80104f0e <exit+0x23>
    panic("init exiting");
80104f01:	83 ec 0c             	sub    $0xc,%esp
80104f04:	68 e7 a0 10 80       	push   $0x8010a0e7
80104f09:	e8 58 b6 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104f0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104f15:	eb 48                	jmp    80104f5f <exit+0x74>
    if(proc->ofile[fd]){
80104f17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f20:	83 c2 08             	add    $0x8,%edx
80104f23:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f27:	85 c0                	test   %eax,%eax
80104f29:	74 30                	je     80104f5b <exit+0x70>
      fileclose(proc->ofile[fd]);
80104f2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f34:	83 c2 08             	add    $0x8,%edx
80104f37:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f3b:	83 ec 0c             	sub    $0xc,%esp
80104f3e:	50                   	push   %eax
80104f3f:	e8 5a c2 ff ff       	call   8010119e <fileclose>
80104f44:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104f47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f50:	83 c2 08             	add    $0x8,%edx
80104f53:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104f5a:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104f5b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104f5f:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104f63:	7e b2                	jle    80104f17 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104f65:	e8 3d e9 ff ff       	call   801038a7 <begin_op>
  iput(proc->cwd);
80104f6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f70:	8b 40 68             	mov    0x68(%eax),%eax
80104f73:	83 ec 0c             	sub    $0xc,%esp
80104f76:	50                   	push   %eax
80104f77:	e8 77 cd ff ff       	call   80101cf3 <iput>
80104f7c:	83 c4 10             	add    $0x10,%esp
  end_op();
80104f7f:	e8 af e9 ff ff       	call   80103933 <end_op>
  proc->cwd = 0;
80104f84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f8a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104f91:	83 ec 0c             	sub    $0xc,%esp
80104f94:	68 a0 49 11 80       	push   $0x801149a0
80104f99:	e8 97 15 00 00       	call   80106535 <acquire>
80104f9e:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104fa1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa7:	8b 40 14             	mov    0x14(%eax),%eax
80104faa:	83 ec 0c             	sub    $0xc,%esp
80104fad:	50                   	push   %eax
80104fae:	e8 1c 08 00 00       	call   801057cf <wakeup1>
80104fb3:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104fb6:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80104fbd:	eb 3f                	jmp    80104ffe <exit+0x113>
    if(p->parent == proc){
80104fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc2:	8b 50 14             	mov    0x14(%eax),%edx
80104fc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fcb:	39 c2                	cmp    %eax,%edx
80104fcd:	75 28                	jne    80104ff7 <exit+0x10c>
      p->parent = initproc;
80104fcf:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80104fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd8:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)                 
80104fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fde:	8b 40 0c             	mov    0xc(%eax),%eax
80104fe1:	83 f8 05             	cmp    $0x5,%eax
80104fe4:	75 11                	jne    80104ff7 <exit+0x10c>
        wakeup1(initproc);
80104fe6:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104feb:	83 ec 0c             	sub    $0xc,%esp
80104fee:	50                   	push   %eax
80104fef:	e8 db 07 00 00       	call   801057cf <wakeup1>
80104ff4:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff7:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104ffe:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80105005:	72 b8                	jb     80104fbf <exit+0xd4>
      if(p->state == ZOMBIE)                 
        wakeup1(initproc);
    }
  }

  if(removeFromStateList(&ptable.pLists.running, proc)){
80105007:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010500d:	83 ec 08             	sub    $0x8,%esp
80105010:	50                   	push   %eax
80105011:	68 fc 70 11 80       	push   $0x801170fc
80105016:	e8 ac 0d 00 00       	call   80105dc7 <removeFromStateList>
8010501b:	83 c4 10             	add    $0x10,%esp
8010501e:	85 c0                	test   %eax,%eax
80105020:	74 4a                	je     8010506c <exit+0x181>
  assertState(proc, RUNNING);
80105022:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105028:	83 ec 08             	sub    $0x8,%esp
8010502b:	6a 04                	push   $0x4
8010502d:	50                   	push   %eax
8010502e:	e8 4a 0d 00 00       	call   80105d7d <assertState>
80105033:	83 c4 10             	add    $0x10,%esp
  proc -> state = ZOMBIE;
80105036:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010503c:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  insertAtHead(&ptable.pLists.zombie, proc);
80105043:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105049:	83 ec 08             	sub    $0x8,%esp
8010504c:	50                   	push   %eax
8010504d:	68 f8 70 11 80       	push   $0x801170f8
80105052:	e8 bc 10 00 00       	call   80106113 <insertAtHead>
80105057:	83 c4 10             	add    $0x10,%esp
  }else{
    panic("Removing from the Exit call");
  }
  sched();
8010505a:	e8 af 03 00 00       	call   8010540e <sched>
  panic("zombie exit");
8010505f:	83 ec 0c             	sub    $0xc,%esp
80105062:	68 10 a1 10 80       	push   $0x8010a110
80105067:	e8 fa b4 ff ff       	call   80100566 <panic>
  if(removeFromStateList(&ptable.pLists.running, proc)){
  assertState(proc, RUNNING);
  proc -> state = ZOMBIE;
  insertAtHead(&ptable.pLists.zombie, proc);
  }else{
    panic("Removing from the Exit call");
8010506c:	83 ec 0c             	sub    $0xc,%esp
8010506f:	68 f4 a0 10 80       	push   $0x8010a0f4
80105074:	e8 ed b4 ff ff       	call   80100566 <panic>

80105079 <wait>:
  }
}
#else
int
wait(void)
{
80105079:	55                   	push   %ebp
8010507a:	89 e5                	mov    %esp,%ebp
8010507c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	68 a0 49 11 80       	push   $0x801149a0
80105087:	e8 a9 14 00 00       	call   80106535 <acquire>
8010508c:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
8010508f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
80105096:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010509b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      while(p){
8010509e:	e9 db 00 00 00       	jmp    8010517e <wait+0x105>
        if(p -> parent == proc){
801050a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a6:	8b 50 14             	mov    0x14(%eax),%edx
801050a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050af:	39 c2                	cmp    %eax,%edx
801050b1:	0f 85 bb 00 00 00    	jne    80105172 <wait+0xf9>
          havekids = 1;
801050b7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
          pid = p->pid;
801050be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c1:	8b 40 10             	mov    0x10(%eax),%eax
801050c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
          kfree(p->kstack);
801050c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ca:	8b 40 08             	mov    0x8(%eax),%eax
801050cd:	83 ec 0c             	sub    $0xc,%esp
801050d0:	50                   	push   %eax
801050d1:	e8 4d de ff ff       	call   80102f23 <kfree>
801050d6:	83 c4 10             	add    $0x10,%esp
          p->kstack = 0;
801050d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          freevm(p->pgdir);
801050e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e6:	8b 40 04             	mov    0x4(%eax),%eax
801050e9:	83 ec 0c             	sub    $0xc,%esp
801050ec:	50                   	push   %eax
801050ed:	e8 87 49 00 00       	call   80109a79 <freevm>
801050f2:	83 c4 10             	add    $0x10,%esp

          assertState(p, ZOMBIE);
801050f5:	83 ec 08             	sub    $0x8,%esp
801050f8:	6a 05                	push   $0x5
801050fa:	ff 75 f4             	pushl  -0xc(%ebp)
801050fd:	e8 7b 0c 00 00       	call   80105d7d <assertState>
80105102:	83 c4 10             	add    $0x10,%esp
          removeFromStateList(&ptable.pLists.zombie, p);  
80105105:	83 ec 08             	sub    $0x8,%esp
80105108:	ff 75 f4             	pushl  -0xc(%ebp)
8010510b:	68 f8 70 11 80       	push   $0x801170f8
80105110:	e8 b2 0c 00 00       	call   80105dc7 <removeFromStateList>
80105115:	83 c4 10             	add    $0x10,%esp
          p->state = UNUSED;
80105118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
          insertAtHead(&ptable.pLists.free, p);
80105122:	83 ec 08             	sub    $0x8,%esp
80105125:	ff 75 f4             	pushl  -0xc(%ebp)
80105128:	68 f0 70 11 80       	push   $0x801170f0
8010512d:	e8 e1 0f 00 00       	call   80106113 <insertAtHead>
80105132:	83 c4 10             	add    $0x10,%esp
          p->pid = 0;
80105135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105138:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
          p->parent = 0;
8010513f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105142:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
          p->name[0] = 0;
80105149:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010514c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
          p->killed = 0;
80105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105153:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
          release(&ptable.lock);
8010515a:	83 ec 0c             	sub    $0xc,%esp
8010515d:	68 a0 49 11 80       	push   $0x801149a0
80105162:	e8 35 14 00 00       	call   8010659c <release>
80105167:	83 c4 10             	add    $0x10,%esp
          return pid; 
8010516a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010516d:	e9 f0 00 00 00       	jmp    80105262 <wait+0x1e9>
        }else{
          p = p -> next;                         // ****** not sure about this one
80105172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105175:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010517b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
      while(p){
8010517e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105182:	0f 85 1b ff ff ff    	jne    801050a3 <wait+0x2a>
        }else{
          p = p -> next;                         // ****** not sure about this one
      }     
  }

  for(int i =0; i <= MAX; i++){                    //P4 make the call traversing the array list of ready
80105188:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010518f:	eb 30                	jmp    801051c1 <wait+0x148>
    if(traverseList(&ptable.pLists.ready[i])){
80105191:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105194:	05 cc 09 00 00       	add    $0x9cc,%eax
80105199:	c1 e0 02             	shl    $0x2,%eax
8010519c:	05 a0 49 11 80       	add    $0x801149a0,%eax
801051a1:	83 c0 04             	add    $0x4,%eax
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	50                   	push   %eax
801051a8:	e8 d0 0c 00 00       	call   80105e7d <traverseList>
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	85 c0                	test   %eax,%eax
801051b2:	74 09                	je     801051bd <wait+0x144>
      havekids = 1;
801051b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;                                         
801051bb:	eb 0a                	jmp    801051c7 <wait+0x14e>
        }else{
          p = p -> next;                         // ****** not sure about this one
      }     
  }

  for(int i =0; i <= MAX; i++){                    //P4 make the call traversing the array list of ready
801051bd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801051c1:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
801051c5:	7e ca                	jle    80105191 <wait+0x118>
    if(traverseList(&ptable.pLists.ready[i])){
      havekids = 1;
      break;                                         
    }
  }
  if(traverseList(&ptable.pLists.running)){
801051c7:	83 ec 0c             	sub    $0xc,%esp
801051ca:	68 fc 70 11 80       	push   $0x801170fc
801051cf:	e8 a9 0c 00 00       	call   80105e7d <traverseList>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	74 09                	je     801051e4 <wait+0x16b>
    havekids = 1;
801051db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801051e2:	eb 38                	jmp    8010521c <wait+0x1a3>
  }else if(traverseList(&ptable.pLists.sleep)){
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	68 f4 70 11 80       	push   $0x801170f4
801051ec:	e8 8c 0c 00 00       	call   80105e7d <traverseList>
801051f1:	83 c4 10             	add    $0x10,%esp
801051f4:	85 c0                	test   %eax,%eax
801051f6:	74 09                	je     80105201 <wait+0x188>
    havekids = 1;
801051f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801051ff:	eb 1b                	jmp    8010521c <wait+0x1a3>
  }else if(traverseList(&ptable.pLists.embryo)){
80105201:	83 ec 0c             	sub    $0xc,%esp
80105204:	68 00 71 11 80       	push   $0x80117100
80105209:	e8 6f 0c 00 00       	call   80105e7d <traverseList>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	74 07                	je     8010521c <wait+0x1a3>
    havekids =1;
80105215:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  }  

  // traverse through all the lists except free and zombie and check p -> parent == proc
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010521c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105220:	74 0d                	je     8010522f <wait+0x1b6>
80105222:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105228:	8b 40 24             	mov    0x24(%eax),%eax
8010522b:	85 c0                	test   %eax,%eax
8010522d:	74 17                	je     80105246 <wait+0x1cd>
      release(&ptable.lock);
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	68 a0 49 11 80       	push   $0x801149a0
80105237:	e8 60 13 00 00       	call   8010659c <release>
8010523c:	83 c4 10             	add    $0x10,%esp
      return -1;
8010523f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105244:	eb 1c                	jmp    80105262 <wait+0x1e9>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105246:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524c:	83 ec 08             	sub    $0x8,%esp
8010524f:	68 a0 49 11 80       	push   $0x801149a0
80105254:	50                   	push   %eax
80105255:	e8 09 04 00 00       	call   80105663 <sleep>
8010525a:	83 c4 10             	add    $0x10,%esp
  }
8010525d:	e9 2d fe ff ff       	jmp    8010508f <wait+0x16>
  return 0;  // placeholder
}
80105262:	c9                   	leave  
80105263:	c3                   	ret    

80105264 <scheduler>:
}

#else
void
scheduler(void)
{
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	83 ec 18             	sub    $0x18,%esp
struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
8010526a:	e8 40 f5 ff ff       	call   801047af <sti>

    idle = 1;  // assume idle unless we schedule a process
8010526f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80105276:	83 ec 0c             	sub    $0xc,%esp
80105279:	68 a0 49 11 80       	push   $0x801149a0
8010527e:	e8 b2 12 00 00       	call   80106535 <acquire>
80105283:	83 c4 10             	add    $0x10,%esp

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.

      if(ticks >= ptable.PromoteAtTime){                          //P4 preparing for promotion
80105286:	8b 15 04 71 11 80    	mov    0x80117104,%edx
8010528c:	a1 20 79 11 80       	mov    0x80117920,%eax
80105291:	39 c2                	cmp    %eax,%edx
80105293:	77 61                	ja     801052f6 <scheduler+0x92>
        ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
80105295:	a1 20 79 11 80       	mov    0x80117920,%eax
8010529a:	05 b8 0b 00 00       	add    $0xbb8,%eax
8010529f:	a3 04 71 11 80       	mov    %eax,0x80117104
        for(int i =1; i <= MAX; i++){                  
801052a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801052ab:	eb 23                	jmp    801052d0 <scheduler+0x6c>
          promoteOneLevelUp(&ptable.pLists.ready[i]);
801052ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052b0:	05 cc 09 00 00       	add    $0x9cc,%eax
801052b5:	c1 e0 02             	shl    $0x2,%eax
801052b8:	05 a0 49 11 80       	add    $0x801149a0,%eax
801052bd:	83 c0 04             	add    $0x4,%eax
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	50                   	push   %eax
801052c4:	e8 fd 0c 00 00       	call   80105fc6 <promoteOneLevelUp>
801052c9:	83 c4 10             	add    $0x10,%esp
      // to release ptable.lock and then reacquire it
      // before jumping back to us.

      if(ticks >= ptable.PromoteAtTime){                          //P4 preparing for promotion
        ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
        for(int i =1; i <= MAX; i++){                  
801052cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801052d0:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
801052d4:	7e d7                	jle    801052ad <scheduler+0x49>
          promoteOneLevelUp(&ptable.pLists.ready[i]);
        }
        promoteOneLevelUpRunSleep(&ptable.pLists.sleep);
801052d6:	83 ec 0c             	sub    $0xc,%esp
801052d9:	68 f4 70 11 80       	push   $0x801170f4
801052de:	e8 73 0d 00 00       	call   80106056 <promoteOneLevelUpRunSleep>
801052e3:	83 c4 10             	add    $0x10,%esp
        promoteOneLevelUpRunSleep(&ptable.pLists.running);
801052e6:	83 ec 0c             	sub    $0xc,%esp
801052e9:	68 fc 70 11 80       	push   $0x801170fc
801052ee:	e8 63 0d 00 00       	call   80106056 <promoteOneLevelUpRunSleep>
801052f3:	83 c4 10             	add    $0x10,%esp
      }
      // call with sleep and running list
      for(int i = 0; i <= MAX; i++){
801052f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801052fd:	e9 d9 00 00 00       	jmp    801053db <scheduler+0x177>
      if(ptable.pLists.ready[i]){
80105302:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105305:	05 cc 09 00 00       	add    $0x9cc,%eax
8010530a:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80105311:	85 c0                	test   %eax,%eax
80105313:	0f 84 be 00 00 00    	je     801053d7 <scheduler+0x173>
        p = removeFront(&ptable.pLists.ready[i]);                            //P4 *** pending -- removes from the highest priority
80105319:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010531c:	05 cc 09 00 00       	add    $0x9cc,%eax
80105321:	c1 e0 02             	shl    $0x2,%eax
80105324:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105329:	83 c0 04             	add    $0x4,%eax
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	50                   	push   %eax
80105330:	e8 63 0c 00 00       	call   80105f98 <removeFront>
80105335:	83 c4 10             	add    $0x10,%esp
80105338:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assertState(p, RUNNABLE);
8010533b:	83 ec 08             	sub    $0x8,%esp
8010533e:	6a 03                	push   $0x3
80105340:	ff 75 e8             	pushl  -0x18(%ebp)
80105343:	e8 35 0a 00 00       	call   80105d7d <assertState>
80105348:	83 c4 10             	add    $0x10,%esp

      idle = 0;  // not idle this timeslice
8010534b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      proc = p;
80105352:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105355:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
8010535b:	83 ec 0c             	sub    $0xc,%esp
8010535e:	ff 75 e8             	pushl  -0x18(%ebp)
80105361:	e8 cd 42 00 00       	call   80109633 <switchuvm>
80105366:	83 c4 10             	add    $0x10,%esp
      p->cpu_ticks_in = ticks;
80105369:	8b 15 20 79 11 80    	mov    0x80117920,%edx
8010536f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105372:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      p->state = RUNNING;
80105378:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010537b:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      assertState(p, RUNNING);
80105382:	83 ec 08             	sub    $0x8,%esp
80105385:	6a 04                	push   $0x4
80105387:	ff 75 e8             	pushl  -0x18(%ebp)
8010538a:	e8 ee 09 00 00       	call   80105d7d <assertState>
8010538f:	83 c4 10             	add    $0x10,%esp
      insertAtHead(&ptable.pLists.running, p);
80105392:	83 ec 08             	sub    $0x8,%esp
80105395:	ff 75 e8             	pushl  -0x18(%ebp)
80105398:	68 fc 70 11 80       	push   $0x801170fc
8010539d:	e8 71 0d 00 00       	call   80106113 <insertAtHead>
801053a2:	83 c4 10             	add    $0x10,%esp

      swtch(&cpu->scheduler, proc->context);
801053a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ab:	8b 40 1c             	mov    0x1c(%eax),%eax
801053ae:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053b5:	83 c2 04             	add    $0x4,%edx
801053b8:	83 ec 08             	sub    $0x8,%esp
801053bb:	50                   	push   %eax
801053bc:	52                   	push   %edx
801053bd:	e8 4a 16 00 00       	call   80106a0c <swtch>
801053c2:	83 c4 10             	add    $0x10,%esp
      switchkvm();
801053c5:	e8 4c 42 00 00       	call   80109616 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801053ca:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801053d1:	00 00 00 00 
      break;
801053d5:	eb 0e                	jmp    801053e5 <scheduler+0x181>
        }
        promoteOneLevelUpRunSleep(&ptable.pLists.sleep);
        promoteOneLevelUpRunSleep(&ptable.pLists.running);
      }
      // call with sleep and running list
      for(int i = 0; i <= MAX; i++){
801053d7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801053db:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
801053df:	0f 8e 1d ff ff ff    	jle    80105302 <scheduler+0x9e>
      proc = 0;
      break;
    }
  }
  
    release(&ptable.lock);
801053e5:	83 ec 0c             	sub    $0xc,%esp
801053e8:	68 a0 49 11 80       	push   $0x801149a0
801053ed:	e8 aa 11 00 00       	call   8010659c <release>
801053f2:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
801053f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053f9:	0f 84 6b fe ff ff    	je     8010526a <scheduler+0x6>
      sti();
801053ff:	e8 ab f3 ff ff       	call   801047af <sti>
      hlt();
80105404:	e8 8f f3 ff ff       	call   80104798 <hlt>
    }
  }
80105409:	e9 5c fe ff ff       	jmp    8010526a <scheduler+0x6>

8010540e <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
8010540e:	55                   	push   %ebp
8010540f:	89 e5                	mov    %esp,%ebp
80105411:	53                   	push   %ebx
80105412:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80105415:	83 ec 0c             	sub    $0xc,%esp
80105418:	68 a0 49 11 80       	push   $0x801149a0
8010541d:	e8 46 12 00 00       	call   80106668 <holding>
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	85 c0                	test   %eax,%eax
80105427:	75 0d                	jne    80105436 <sched+0x28>
    panic("sched ptable.lock");
80105429:	83 ec 0c             	sub    $0xc,%esp
8010542c:	68 1c a1 10 80       	push   $0x8010a11c
80105431:	e8 30 b1 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105436:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010543c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105442:	83 f8 01             	cmp    $0x1,%eax
80105445:	74 0d                	je     80105454 <sched+0x46>
    panic("sched locks");
80105447:	83 ec 0c             	sub    $0xc,%esp
8010544a:	68 2e a1 10 80       	push   $0x8010a12e
8010544f:	e8 12 b1 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105454:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010545a:	8b 40 0c             	mov    0xc(%eax),%eax
8010545d:	83 f8 04             	cmp    $0x4,%eax
80105460:	75 0d                	jne    8010546f <sched+0x61>
    panic("sched running");
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	68 3a a1 10 80       	push   $0x8010a13a
8010546a:	e8 f7 b0 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
8010546f:	e8 2b f3 ff ff       	call   8010479f <readeflags>
80105474:	25 00 02 00 00       	and    $0x200,%eax
80105479:	85 c0                	test   %eax,%eax
8010547b:	74 0d                	je     8010548a <sched+0x7c>
    panic("sched interruptible");
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	68 48 a1 10 80       	push   $0x8010a148
80105485:	e8 dc b0 ff ff       	call   80100566 <panic>
  intena = cpu->intena;                                       //P4 check budget and reset it
8010548a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105490:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;        // updaates the cpu ticks total
80105499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010549f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054a6:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801054ac:	8b 1d 20 79 11 80    	mov    0x80117920,%ebx
801054b2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054b9:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801054bf:	29 d3                	sub    %edx,%ebx
801054c1:	89 da                	mov    %ebx,%edx
801054c3:	01 ca                	add    %ecx,%edx
801054c5:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
801054cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054d1:	8b 40 04             	mov    0x4(%eax),%eax
801054d4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054db:	83 c2 1c             	add    $0x1c,%edx
801054de:	83 ec 08             	sub    $0x8,%esp
801054e1:	50                   	push   %eax
801054e2:	52                   	push   %edx
801054e3:	e8 24 15 00 00       	call   80106a0c <swtch>
801054e8:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801054eb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054f4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801054fa:	90                   	nop
801054fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054fe:	c9                   	leave  
801054ff:	c3                   	ret    

80105500 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	53                   	push   %ebx
80105504:	83 ec 04             	sub    $0x4,%esp
  #ifdef CS333_P3P4                             // ******* check out this one
    acquire(&ptable.lock);
80105507:	83 ec 0c             	sub    $0xc,%esp
8010550a:	68 a0 49 11 80       	push   $0x801149a0
8010550f:	e8 21 10 00 00       	call   80106535 <acquire>
80105514:	83 c4 10             	add    $0x10,%esp
    assertState(proc, RUNNING);
80105517:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010551d:	83 ec 08             	sub    $0x8,%esp
80105520:	6a 04                	push   $0x4
80105522:	50                   	push   %eax
80105523:	e8 55 08 00 00       	call   80105d7d <assertState>
80105528:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.running, proc);
8010552b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105531:	83 ec 08             	sub    $0x8,%esp
80105534:	50                   	push   %eax
80105535:	68 fc 70 11 80       	push   $0x801170fc
8010553a:	e8 88 08 00 00       	call   80105dc7 <removeFromStateList>
8010553f:	83 c4 10             	add    $0x10,%esp
    proc -> state = RUNNABLE;
80105542:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105548:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    //P4 do logic budget -- either reset it or update
    proc -> budget -= (ticks - proc -> cpu_ticks_in);
8010554f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105555:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010555c:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105562:	89 d3                	mov    %edx,%ebx
80105564:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010556b:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105571:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105577:	29 d1                	sub    %edx,%ecx
80105579:	89 ca                	mov    %ecx,%edx
8010557b:	01 da                	add    %ebx,%edx
8010557d:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if(proc -> budget <= 0){
80105583:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105589:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010558f:	85 c0                	test   %eax,%eax
80105591:	7f 3d                	jg     801055d0 <yield+0xd0>
      proc -> budget = BUDGET;
80105593:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105599:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
801055a0:	13 00 00 
      if(proc -> priority < MAX){
801055a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a9:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801055af:	83 f8 05             	cmp    $0x5,%eax
801055b2:	7f 1c                	jg     801055d0 <yield+0xd0>
        proc -> priority = proc -> priority + 1;
801055b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ba:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801055c1:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
801055c7:	83 c2 01             	add    $0x1,%edx
801055ca:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      }
    }
    insertTail(&ptable.pLists.ready[proc -> priority], proc);
801055d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801055dd:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
801055e3:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
801055e9:	c1 e2 02             	shl    $0x2,%edx
801055ec:	81 c2 a0 49 11 80    	add    $0x801149a0,%edx
801055f2:	83 c2 04             	add    $0x4,%edx
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	50                   	push   %eax
801055f9:	52                   	push   %edx
801055fa:	e8 ad 0a 00 00       	call   801060ac <insertTail>
801055ff:	83 c4 10             	add    $0x10,%esp
    sched();
80105602:	e8 07 fe ff ff       	call   8010540e <sched>
    release(&ptable.lock);
80105607:	83 ec 0c             	sub    $0xc,%esp
8010560a:	68 a0 49 11 80       	push   $0x801149a0
8010560f:	e8 88 0f 00 00       	call   8010659c <release>
80105614:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;     // insert at tail remove from runnig and add to runnable:
    sched();
    release(&ptable.lock);
  #endif
}
80105617:	90                   	nop
80105618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010561b:	c9                   	leave  
8010561c:	c3                   	ret    

8010561d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010561d:	55                   	push   %ebp
8010561e:	89 e5                	mov    %esp,%ebp
80105620:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105623:	83 ec 0c             	sub    $0xc,%esp
80105626:	68 a0 49 11 80       	push   $0x801149a0
8010562b:	e8 6c 0f 00 00       	call   8010659c <release>
80105630:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105633:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105638:	85 c0                	test   %eax,%eax
8010563a:	74 24                	je     80105660 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
8010563c:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105643:	00 00 00 
    iinit(ROOTDEV);
80105646:	83 ec 0c             	sub    $0xc,%esp
80105649:	6a 01                	push   $0x1
8010564b:	e8 3b c1 ff ff       	call   8010178b <iinit>
80105650:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105653:	83 ec 0c             	sub    $0xc,%esp
80105656:	6a 01                	push   $0x1
80105658:	e8 2c e0 ff ff       	call   80103689 <initlog>
8010565d:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105660:	90                   	nop
80105661:	c9                   	leave  
80105662:	c3                   	ret    

80105663 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105663:	55                   	push   %ebp
80105664:	89 e5                	mov    %esp,%ebp
80105666:	53                   	push   %ebx
80105667:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
8010566a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105670:	85 c0                	test   %eax,%eax
80105672:	75 0d                	jne    80105681 <sleep+0x1e>
    panic("sleep");
80105674:	83 ec 0c             	sub    $0xc,%esp
80105677:	68 5c a1 10 80       	push   $0x8010a15c
8010567c:	e8 e5 ae ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105681:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105688:	74 24                	je     801056ae <sleep+0x4b>
    acquire(&ptable.lock);
8010568a:	83 ec 0c             	sub    $0xc,%esp
8010568d:	68 a0 49 11 80       	push   $0x801149a0
80105692:	e8 9e 0e 00 00       	call   80106535 <acquire>
80105697:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
8010569a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010569e:	74 0e                	je     801056ae <sleep+0x4b>
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	ff 75 0c             	pushl  0xc(%ebp)
801056a6:	e8 f1 0e 00 00       	call   8010659c <release>
801056ab:	83 c4 10             	add    $0x10,%esp
  }

  #ifdef CS333_P3P4                         // ******check it out 
    //acquire(&ptable.lock);
    assertState(proc, RUNNING);
801056ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b4:	83 ec 08             	sub    $0x8,%esp
801056b7:	6a 04                	push   $0x4
801056b9:	50                   	push   %eax
801056ba:	e8 be 06 00 00       	call   80105d7d <assertState>
801056bf:	83 c4 10             	add    $0x10,%esp
    proc -> chan = chan;
801056c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c8:	8b 55 08             	mov    0x8(%ebp),%edx
801056cb:	89 50 20             	mov    %edx,0x20(%eax)
    removeFromStateList(&ptable.pLists.running, proc);
801056ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	50                   	push   %eax
801056d8:	68 fc 70 11 80       	push   $0x801170fc
801056dd:	e8 e5 06 00 00       	call   80105dc7 <removeFromStateList>
801056e2:	83 c4 10             	add    $0x10,%esp
    proc->state = SLEEPING;
801056e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056eb:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    proc -> budget -= (ticks - proc -> cpu_ticks_in);             //P4 demoting 
801056f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056ff:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105705:	89 d3                	mov    %edx,%ebx
80105707:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010570e:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105714:	8b 15 20 79 11 80    	mov    0x80117920,%edx
8010571a:	29 d1                	sub    %edx,%ecx
8010571c:	89 ca                	mov    %ecx,%edx
8010571e:	01 da                	add    %ebx,%edx
80105720:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if(proc -> budget <= 0){
80105726:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010572c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105732:	85 c0                	test   %eax,%eax
80105734:	7f 3d                	jg     80105773 <sleep+0x110>
      proc -> budget = BUDGET;
80105736:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573c:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
80105743:	13 00 00 
      if(proc -> priority < MAX){
80105746:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010574c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105752:	83 f8 05             	cmp    $0x5,%eax
80105755:	7f 1c                	jg     80105773 <sleep+0x110>
        proc -> priority = proc -> priority + 1;
80105757:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010575d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105764:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
8010576a:	83 c2 01             	add    $0x1,%edx
8010576d:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      }
    }
    insertAtHead(&ptable.pLists.sleep, proc);
80105773:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105779:	83 ec 08             	sub    $0x8,%esp
8010577c:	50                   	push   %eax
8010577d:	68 f4 70 11 80       	push   $0x801170f4
80105782:	e8 8c 09 00 00       	call   80106113 <insertAtHead>
80105787:	83 c4 10             	add    $0x10,%esp
  // Go to sleep.
  proc->chan = chan;      // remove it from running list and add it to the sleeping ....add flag first locally
  proc->state = SLEEPING;
  #endif

  sched();
8010578a:	e8 7f fc ff ff       	call   8010540e <sched>

  // Tidy up.
  proc->chan = 0;
8010578f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105795:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
8010579c:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
801057a3:	74 24                	je     801057c9 <sleep+0x166>
    release(&ptable.lock);
801057a5:	83 ec 0c             	sub    $0xc,%esp
801057a8:	68 a0 49 11 80       	push   $0x801149a0
801057ad:	e8 ea 0d 00 00       	call   8010659c <release>
801057b2:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801057b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057b9:	74 0e                	je     801057c9 <sleep+0x166>
801057bb:	83 ec 0c             	sub    $0xc,%esp
801057be:	ff 75 0c             	pushl  0xc(%ebp)
801057c1:	e8 6f 0d 00 00       	call   80106535 <acquire>
801057c6:	83 c4 10             	add    $0x10,%esp
  }
}
801057c9:	90                   	nop
801057ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057cd:	c9                   	leave  
801057ce:	c3                   	ret    

801057cf <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)                   // ****** check it out --- should I hold the lock
{
801057cf:	55                   	push   %ebp
801057d0:	89 e5                	mov    %esp,%ebp
801057d2:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;
801057d5:	a1 f4 70 11 80       	mov    0x801170f4,%eax
801057da:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(current){
801057dd:	e9 a5 00 00 00       	jmp    80105887 <wakeup1+0xb8>
    if(current -> chan == chan){
801057e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e5:	8b 40 20             	mov    0x20(%eax),%eax
801057e8:	3b 45 08             	cmp    0x8(%ebp),%eax
801057eb:	0f 85 8a 00 00 00    	jne    8010587b <wakeup1+0xac>
      temp = current -> next;
801057f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
      assertState(current, SLEEPING);
801057fd:	83 ec 08             	sub    $0x8,%esp
80105800:	6a 02                	push   $0x2
80105802:	ff 75 f4             	pushl  -0xc(%ebp)
80105805:	e8 73 05 00 00       	call   80105d7d <assertState>
8010580a:	83 c4 10             	add    $0x10,%esp
      if(removeFromStateList(&ptable.pLists.sleep, current)){
8010580d:	83 ec 08             	sub    $0x8,%esp
80105810:	ff 75 f4             	pushl  -0xc(%ebp)
80105813:	68 f4 70 11 80       	push   $0x801170f4
80105818:	e8 aa 05 00 00       	call   80105dc7 <removeFromStateList>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	74 4a                	je     8010586e <wakeup1+0x9f>
      current -> state = RUNNABLE;
80105824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105827:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      assertState(current, RUNNABLE);
8010582e:	83 ec 08             	sub    $0x8,%esp
80105831:	6a 03                	push   $0x3
80105833:	ff 75 f4             	pushl  -0xc(%ebp)
80105836:	e8 42 05 00 00       	call   80105d7d <assertState>
8010583b:	83 c4 10             	add    $0x10,%esp
      insertTail(&ptable.pLists.ready[current -> priority], current);            //P4 insert proper list
8010583e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105841:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105847:	05 cc 09 00 00       	add    $0x9cc,%eax
8010584c:	c1 e0 02             	shl    $0x2,%eax
8010584f:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105854:	83 c0 04             	add    $0x4,%eax
80105857:	83 ec 08             	sub    $0x8,%esp
8010585a:	ff 75 f4             	pushl  -0xc(%ebp)
8010585d:	50                   	push   %eax
8010585e:	e8 49 08 00 00       	call   801060ac <insertTail>
80105863:	83 c4 10             	add    $0x10,%esp
      }else{
        panic("wakeup1 not doing the job");
      }
      current = temp;    
80105866:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105869:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010586c:	eb 19                	jmp    80105887 <wakeup1+0xb8>
      if(removeFromStateList(&ptable.pLists.sleep, current)){
      current -> state = RUNNABLE;
      assertState(current, RUNNABLE);
      insertTail(&ptable.pLists.ready[current -> priority], current);            //P4 insert proper list
      }else{
        panic("wakeup1 not doing the job");
8010586e:	83 ec 0c             	sub    $0xc,%esp
80105871:	68 62 a1 10 80       	push   $0x8010a162
80105876:	e8 eb ac ff ff       	call   80100566 <panic>
      }
      current = temp;    
    }else{
      current = current -> next;
8010587b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010587e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105884:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;

  while(current){
80105887:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010588b:	0f 85 51 ff ff ff    	jne    801057e2 <wakeup1+0x13>
      current = temp;    
    }else{
      current = current -> next;
    }
  }  
}
80105891:	90                   	nop
80105892:	c9                   	leave  
80105893:	c3                   	ret    

80105894 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
8010589a:	83 ec 0c             	sub    $0xc,%esp
8010589d:	68 a0 49 11 80       	push   $0x801149a0
801058a2:	e8 8e 0c 00 00       	call   80106535 <acquire>
801058a7:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801058aa:	83 ec 0c             	sub    $0xc,%esp
801058ad:	ff 75 08             	pushl  0x8(%ebp)
801058b0:	e8 1a ff ff ff       	call   801057cf <wakeup1>
801058b5:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	68 a0 49 11 80       	push   $0x801149a0
801058c0:	e8 d7 0c 00 00       	call   8010659c <release>
801058c5:	83 c4 10             	add    $0x10,%esp
}
801058c8:	90                   	nop
801058c9:	c9                   	leave  
801058ca:	c3                   	ret    

801058cb <kill>:
  return -1;
}
#else
int
kill(int pid)                 //******* move the logic from the helper function here
{
801058cb:	55                   	push   %ebp
801058cc:	89 e5                	mov    %esp,%ebp
801058ce:	83 ec 18             	sub    $0x18,%esp
  if(traverseToKill(&ptable.pLists.sleep, pid) == 0)
801058d1:	83 ec 08             	sub    $0x8,%esp
801058d4:	ff 75 08             	pushl  0x8(%ebp)
801058d7:	68 f4 70 11 80       	push   $0x801170f4
801058dc:	e8 dc 05 00 00       	call   80105ebd <traverseToKill>
801058e1:	83 c4 10             	add    $0x10,%esp
801058e4:	85 c0                	test   %eax,%eax
801058e6:	75 0a                	jne    801058f2 <kill+0x27>
  return 1;
801058e8:	b8 01 00 00 00       	mov    $0x1,%eax
801058ed:	e9 a2 00 00 00       	jmp    80105994 <kill+0xc9>
  if(traverseToKill(&ptable.pLists.zombie, pid) == 0)
801058f2:	83 ec 08             	sub    $0x8,%esp
801058f5:	ff 75 08             	pushl  0x8(%ebp)
801058f8:	68 f8 70 11 80       	push   $0x801170f8
801058fd:	e8 bb 05 00 00       	call   80105ebd <traverseToKill>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	75 0a                	jne    80105913 <kill+0x48>
  return 1; 
80105909:	b8 01 00 00 00       	mov    $0x1,%eax
8010590e:	e9 81 00 00 00       	jmp    80105994 <kill+0xc9>
  if(traverseToKill(&ptable.pLists.running, pid) == 0)
80105913:	83 ec 08             	sub    $0x8,%esp
80105916:	ff 75 08             	pushl  0x8(%ebp)
80105919:	68 fc 70 11 80       	push   $0x801170fc
8010591e:	e8 9a 05 00 00       	call   80105ebd <traverseToKill>
80105923:	83 c4 10             	add    $0x10,%esp
80105926:	85 c0                	test   %eax,%eax
80105928:	75 07                	jne    80105931 <kill+0x66>
  return 1;
8010592a:	b8 01 00 00 00       	mov    $0x1,%eax
8010592f:	eb 63                	jmp    80105994 <kill+0xc9>
  if(traverseToKill(&ptable.pLists.embryo, pid) == 0)
80105931:	83 ec 08             	sub    $0x8,%esp
80105934:	ff 75 08             	pushl  0x8(%ebp)
80105937:	68 00 71 11 80       	push   $0x80117100
8010593c:	e8 7c 05 00 00       	call   80105ebd <traverseToKill>
80105941:	83 c4 10             	add    $0x10,%esp
80105944:	85 c0                	test   %eax,%eax
80105946:	75 07                	jne    8010594f <kill+0x84>
  return 1;
80105948:	b8 01 00 00 00       	mov    $0x1,%eax
8010594d:	eb 45                	jmp    80105994 <kill+0xc9>
  for(int i =0; i <= MAX; i++){                            //P4 iterate through the array
8010594f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105956:	eb 31                	jmp    80105989 <kill+0xbe>
    if(traverseToKill(&ptable.pLists.ready[i],pid) ==0)
80105958:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595b:	05 cc 09 00 00       	add    $0x9cc,%eax
80105960:	c1 e0 02             	shl    $0x2,%eax
80105963:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105968:	83 c0 04             	add    $0x4,%eax
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	ff 75 08             	pushl  0x8(%ebp)
80105971:	50                   	push   %eax
80105972:	e8 46 05 00 00       	call   80105ebd <traverseToKill>
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	85 c0                	test   %eax,%eax
8010597c:	75 07                	jne    80105985 <kill+0xba>
      return 1;
8010597e:	b8 01 00 00 00       	mov    $0x1,%eax
80105983:	eb 0f                	jmp    80105994 <kill+0xc9>
  return 1; 
  if(traverseToKill(&ptable.pLists.running, pid) == 0)
  return 1;
  if(traverseToKill(&ptable.pLists.embryo, pid) == 0)
  return 1;
  for(int i =0; i <= MAX; i++){                            //P4 iterate through the array
80105985:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105989:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
8010598d:	7e c9                	jle    80105958 <kill+0x8d>
    if(traverseToKill(&ptable.pLists.ready[i],pid) ==0)
      return 1;
  }

  return -1;  // placeholder
8010598f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105994:	c9                   	leave  
80105995:	c3                   	ret    

80105996 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105996:	55                   	push   %ebp
80105997:	89 e5                	mov    %esp,%ebp
80105999:	57                   	push   %edi
8010599a:	56                   	push   %esi
8010599b:	53                   	push   %ebx
8010599c:	83 ec 6c             	sub    $0x6c,%esp
  int time_difference; 
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
8010599f:	83 ec 0c             	sub    $0xc,%esp
801059a2:	68 a4 a1 10 80       	push   $0x8010a1a4
801059a7:	e8 1a aa ff ff       	call   801003c6 <cprintf>
801059ac:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059af:	c7 45 e0 d4 49 11 80 	movl   $0x801149d4,-0x20(%ebp)
801059b6:	e9 ad 01 00 00       	jmp    80105b68 <procdump+0x1d2>
    if(p->state == UNUSED)
801059bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059be:	8b 40 0c             	mov    0xc(%eax),%eax
801059c1:	85 c0                	test   %eax,%eax
801059c3:	0f 84 97 01 00 00    	je     80105b60 <procdump+0x1ca>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state]){
801059c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059cc:	8b 40 0c             	mov    0xc(%eax),%eax
801059cf:	83 f8 05             	cmp    $0x5,%eax
801059d2:	77 23                	ja     801059f7 <procdump+0x61>
801059d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059d7:	8b 40 0c             	mov    0xc(%eax),%eax
801059da:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801059e1:	85 c0                	test   %eax,%eax
801059e3:	74 12                	je     801059f7 <procdump+0x61>
      state = states[p->state];
801059e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801059e8:	8b 40 0c             	mov    0xc(%eax),%eax
801059eb:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801059f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801059f5:	eb 07                	jmp    801059fe <procdump+0x68>
    }	
    else
      state = "???";
801059f7:	c7 45 dc d9 a1 10 80 	movl   $0x8010a1d9,-0x24(%ebp)
      time_difference = ticks - p->start_ticks;
801059fe:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a07:	8b 40 7c             	mov    0x7c(%eax),%eax
80105a0a:	29 c2                	sub    %eax,%edx
80105a0c:	89 d0                	mov    %edx,%eax
80105a0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
      seconds = (time_difference)/1000;
80105a11:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a14:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105a19:	89 c8                	mov    %ecx,%eax
80105a1b:	f7 ea                	imul   %edx
80105a1d:	c1 fa 06             	sar    $0x6,%edx
80105a20:	89 c8                	mov    %ecx,%eax
80105a22:	c1 f8 1f             	sar    $0x1f,%eax
80105a25:	29 c2                	sub    %eax,%edx
80105a27:	89 d0                	mov    %edx,%eax
80105a29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      time_difference -= seconds * 1000;
80105a2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105a2f:	69 c0 18 fc ff ff    	imul   $0xfffffc18,%eax,%eax
80105a35:	01 45 d8             	add    %eax,-0x28(%ebp)
      milliseconds = time_difference/100;
80105a38:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a3b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105a40:	89 c8                	mov    %ecx,%eax
80105a42:	f7 ea                	imul   %edx
80105a44:	c1 fa 05             	sar    $0x5,%edx
80105a47:	89 c8                	mov    %ecx,%eax
80105a49:	c1 f8 1f             	sar    $0x1f,%eax
80105a4c:	29 c2                	sub    %eax,%edx
80105a4e:	89 d0                	mov    %edx,%eax
80105a50:	89 45 d0             	mov    %eax,-0x30(%ebp)
      time_difference -= milliseconds *100;
80105a53:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105a56:	6b c0 9c             	imul   $0xffffff9c,%eax,%eax
80105a59:	01 45 d8             	add    %eax,-0x28(%ebp)
      temp = (time_difference)/10;
80105a5c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a5f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80105a64:	89 c8                	mov    %ecx,%eax
80105a66:	f7 ea                	imul   %edx
80105a68:	c1 fa 02             	sar    $0x2,%edx
80105a6b:	89 c8                	mov    %ecx,%eax
80105a6d:	c1 f8 1f             	sar    $0x1f,%eax
80105a70:	29 c2                	sub    %eax,%edx
80105a72:	89 d0                	mov    %edx,%eax
80105a74:	89 45 cc             	mov    %eax,-0x34(%ebp)
      time_difference -= temp * 10; 
80105a77:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105a7a:	6b c0 f6             	imul   $0xfffffff6,%eax,%eax
80105a7d:	01 45 d8             	add    %eax,-0x28(%ebp)
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->priority,p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
80105a80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a83:	8b 10                	mov    (%eax),%edx
80105a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a88:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105a8e:	89 45 94             	mov    %eax,-0x6c(%ebp)
80105a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a94:	8b b8 94 00 00 00    	mov    0x94(%eax),%edi
80105a9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a9d:	8b 40 14             	mov    0x14(%eax),%eax
80105aa0:	8b 70 10             	mov    0x10(%eax),%esi
80105aa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aa6:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
80105aac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aaf:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80105ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ab8:	83 c0 6c             	add    $0x6c,%eax
80105abb:	89 45 90             	mov    %eax,-0x70(%ebp)
80105abe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ac1:	8b 40 10             	mov    0x10(%eax),%eax
80105ac4:	83 ec 08             	sub    $0x8,%esp
80105ac7:	ff 75 d8             	pushl  -0x28(%ebp)
80105aca:	ff 75 cc             	pushl  -0x34(%ebp)
80105acd:	ff 75 d0             	pushl  -0x30(%ebp)
80105ad0:	ff 75 d4             	pushl  -0x2c(%ebp)
80105ad3:	52                   	push   %edx
80105ad4:	ff 75 94             	pushl  -0x6c(%ebp)
80105ad7:	57                   	push   %edi
80105ad8:	56                   	push   %esi
80105ad9:	53                   	push   %ebx
80105ada:	51                   	push   %ecx
80105adb:	ff 75 90             	pushl  -0x70(%ebp)
80105ade:	ff 75 dc             	pushl  -0x24(%ebp)
80105ae1:	50                   	push   %eax
80105ae2:	68 e0 a1 10 80       	push   $0x8010a1e0
80105ae7:	e8 da a8 ff ff       	call   801003c6 <cprintf>
80105aec:	83 c4 40             	add    $0x40,%esp
    if(p->state == SLEEPING){
80105aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105af2:	8b 40 0c             	mov    0xc(%eax),%eax
80105af5:	83 f8 02             	cmp    $0x2,%eax
80105af8:	75 54                	jne    80105b4e <procdump+0x1b8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105afa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105afd:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b00:	8b 40 0c             	mov    0xc(%eax),%eax
80105b03:	83 c0 08             	add    $0x8,%eax
80105b06:	89 c2                	mov    %eax,%edx
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
80105b0e:	50                   	push   %eax
80105b0f:	52                   	push   %edx
80105b10:	e8 d9 0a 00 00       	call   801065ee <getcallerpcs>
80105b15:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105b18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105b1f:	eb 1c                	jmp    80105b3d <procdump+0x1a7>
        cprintf(" %p", pc[i]);
80105b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b24:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
80105b28:	83 ec 08             	sub    $0x8,%esp
80105b2b:	50                   	push   %eax
80105b2c:	68 06 a2 10 80       	push   $0x8010a206
80105b31:	e8 90 a8 ff ff       	call   801003c6 <cprintf>
80105b36:	83 c4 10             	add    $0x10,%esp
      time_difference -= temp * 10; 
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->priority,p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105b39:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105b3d:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105b41:	7f 0b                	jg     80105b4e <procdump+0x1b8>
80105b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b46:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
80105b4a:	85 c0                	test   %eax,%eax
80105b4c:	75 d3                	jne    80105b21 <procdump+0x18b>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105b4e:	83 ec 0c             	sub    $0xc,%esp
80105b51:	68 0a a2 10 80       	push   $0x8010a20a
80105b56:	e8 6b a8 ff ff       	call   801003c6 <cprintf>
80105b5b:	83 c4 10             	add    $0x10,%esp
80105b5e:	eb 01                	jmp    80105b61 <procdump+0x1cb>
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105b60:	90                   	nop
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105b61:	81 45 e0 9c 00 00 00 	addl   $0x9c,-0x20(%ebp)
80105b68:	81 7d e0 d4 70 11 80 	cmpl   $0x801170d4,-0x20(%ebp)
80105b6f:	0f 82 46 fe ff ff    	jb     801059bb <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105b75:	90                   	nop
80105b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b79:	5b                   	pop    %ebx
80105b7a:	5e                   	pop    %esi
80105b7b:	5f                   	pop    %edi
80105b7c:	5d                   	pop    %ebp
80105b7d:	c3                   	ret    

80105b7e <getprocs>:

int
getprocs(uint max, struct uproc* table){
80105b7e:	55                   	push   %ebp
80105b7f:	89 e5                	mov    %esp,%ebp
80105b81:	83 ec 18             	sub    $0x18,%esp
  int index = 0;      // which is my count of processes at the same time
80105b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  
    acquire(&ptable.lock);
80105b8b:	83 ec 0c             	sub    $0xc,%esp
80105b8e:	68 a0 49 11 80       	push   $0x801149a0
80105b93:	e8 9d 09 00 00       	call   80106535 <acquire>
80105b98:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
80105b9b:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105ba2:	e9 ac 01 00 00       	jmp    80105d53 <getprocs+0x1d5>
      if(p->state == RUNNABLE || p->state == SLEEPING || p->state == RUNNING){
80105ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105baa:	8b 40 0c             	mov    0xc(%eax),%eax
80105bad:	83 f8 03             	cmp    $0x3,%eax
80105bb0:	74 1a                	je     80105bcc <getprocs+0x4e>
80105bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb5:	8b 40 0c             	mov    0xc(%eax),%eax
80105bb8:	83 f8 02             	cmp    $0x2,%eax
80105bbb:	74 0f                	je     80105bcc <getprocs+0x4e>
80105bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc0:	8b 40 0c             	mov    0xc(%eax),%eax
80105bc3:	83 f8 04             	cmp    $0x4,%eax
80105bc6:	0f 85 80 01 00 00    	jne    80105d4c <getprocs+0x1ce>
        table[index].pid = p -> pid;
80105bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bcf:	89 d0                	mov    %edx,%eax
80105bd1:	01 c0                	add    %eax,%eax
80105bd3:	01 d0                	add    %edx,%eax
80105bd5:	c1 e0 05             	shl    $0x5,%eax
80105bd8:	89 c2                	mov    %eax,%edx
80105bda:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bdd:	01 c2                	add    %eax,%edx
80105bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be2:	8b 40 10             	mov    0x10(%eax),%eax
80105be5:	89 02                	mov    %eax,(%edx)
        table[index].uid = p -> uid;
80105be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bea:	89 d0                	mov    %edx,%eax
80105bec:	01 c0                	add    %eax,%eax
80105bee:	01 d0                	add    %edx,%eax
80105bf0:	c1 e0 05             	shl    $0x5,%eax
80105bf3:	89 c2                	mov    %eax,%edx
80105bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bf8:	01 c2                	add    %eax,%edx
80105bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfd:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105c03:	89 42 04             	mov    %eax,0x4(%edx)
        table[index].gid = p -> gid;
80105c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c09:	89 d0                	mov    %edx,%eax
80105c0b:	01 c0                	add    %eax,%eax
80105c0d:	01 d0                	add    %edx,%eax
80105c0f:	c1 e0 05             	shl    $0x5,%eax
80105c12:	89 c2                	mov    %eax,%edx
80105c14:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c17:	01 c2                	add    %eax,%edx
80105c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105c22:	89 42 08             	mov    %eax,0x8(%edx)
        if(p -> parent == 0)
80105c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c28:	8b 40 14             	mov    0x14(%eax),%eax
80105c2b:	85 c0                	test   %eax,%eax
80105c2d:	75 1e                	jne    80105c4d <getprocs+0xcf>
		      table[index].ppid = p->pid;
80105c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c32:	89 d0                	mov    %edx,%eax
80105c34:	01 c0                	add    %eax,%eax
80105c36:	01 d0                	add    %edx,%eax
80105c38:	c1 e0 05             	shl    $0x5,%eax
80105c3b:	89 c2                	mov    %eax,%edx
80105c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c40:	01 c2                	add    %eax,%edx
80105c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c45:	8b 40 10             	mov    0x10(%eax),%eax
80105c48:	89 42 0c             	mov    %eax,0xc(%edx)
80105c4b:	eb 1f                	jmp    80105c6c <getprocs+0xee>
	      else 	
        	table[index].ppid = p -> parent -> pid;
80105c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c50:	89 d0                	mov    %edx,%eax
80105c52:	01 c0                	add    %eax,%eax
80105c54:	01 d0                	add    %edx,%eax
80105c56:	c1 e0 05             	shl    $0x5,%eax
80105c59:	89 c2                	mov    %eax,%edx
80105c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c5e:	01 c2                	add    %eax,%edx
80105c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c63:	8b 40 14             	mov    0x14(%eax),%eax
80105c66:	8b 40 10             	mov    0x10(%eax),%eax
80105c69:	89 42 0c             	mov    %eax,0xc(%edx)
        table[index].priority = p -> priority;                  //P4
80105c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c6f:	89 d0                	mov    %edx,%eax
80105c71:	01 c0                	add    %eax,%eax
80105c73:	01 d0                	add    %edx,%eax
80105c75:	c1 e0 05             	shl    $0x5,%eax
80105c78:	89 c2                	mov    %eax,%edx
80105c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c7d:	01 c2                	add    %eax,%edx
80105c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c82:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c88:	89 42 5c             	mov    %eax,0x5c(%edx)
        table[index].elapsed_ticks = ticks - p -> start_ticks;
80105c8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c8e:	89 d0                	mov    %edx,%eax
80105c90:	01 c0                	add    %eax,%eax
80105c92:	01 d0                	add    %edx,%eax
80105c94:	c1 e0 05             	shl    $0x5,%eax
80105c97:	89 c2                	mov    %eax,%edx
80105c99:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c9c:	01 c2                	add    %eax,%edx
80105c9e:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80105ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca7:	8b 40 7c             	mov    0x7c(%eax),%eax
80105caa:	29 c1                	sub    %eax,%ecx
80105cac:	89 c8                	mov    %ecx,%eax
80105cae:	89 42 10             	mov    %eax,0x10(%edx)
        table[index].CPU_total_ticks = p -> cpu_ticks_total;
80105cb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cb4:	89 d0                	mov    %edx,%eax
80105cb6:	01 c0                	add    %eax,%eax
80105cb8:	01 d0                	add    %edx,%eax
80105cba:	c1 e0 05             	shl    $0x5,%eax
80105cbd:	89 c2                	mov    %eax,%edx
80105cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cc2:	01 c2                	add    %eax,%edx
80105cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105ccd:	89 42 14             	mov    %eax,0x14(%edx)
        safestrcpy(table[index].state, states[p-> state], STRMAX);      
80105cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cd3:	8b 40 0c             	mov    0xc(%eax),%eax
80105cd6:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ce0:	89 d0                	mov    %edx,%eax
80105ce2:	01 c0                	add    %eax,%eax
80105ce4:	01 d0                	add    %edx,%eax
80105ce6:	c1 e0 05             	shl    $0x5,%eax
80105ce9:	89 c2                	mov    %eax,%edx
80105ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cee:	01 d0                	add    %edx,%eax
80105cf0:	83 c0 18             	add    $0x18,%eax
80105cf3:	83 ec 04             	sub    $0x4,%esp
80105cf6:	6a 20                	push   $0x20
80105cf8:	51                   	push   %ecx
80105cf9:	50                   	push   %eax
80105cfa:	e8 9c 0c 00 00       	call   8010699b <safestrcpy>
80105cff:	83 c4 10             	add    $0x10,%esp
        table[index].size = p -> sz;
80105d02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d05:	89 d0                	mov    %edx,%eax
80105d07:	01 c0                	add    %eax,%eax
80105d09:	01 d0                	add    %edx,%eax
80105d0b:	c1 e0 05             	shl    $0x5,%eax
80105d0e:	89 c2                	mov    %eax,%edx
80105d10:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d13:	01 c2                	add    %eax,%edx
80105d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d18:	8b 00                	mov    (%eax),%eax
80105d1a:	89 42 38             	mov    %eax,0x38(%edx)
        safestrcpy(table[index].name, p-> name, STRMAX);          
80105d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d20:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d26:	89 d0                	mov    %edx,%eax
80105d28:	01 c0                	add    %eax,%eax
80105d2a:	01 d0                	add    %edx,%eax
80105d2c:	c1 e0 05             	shl    $0x5,%eax
80105d2f:	89 c2                	mov    %eax,%edx
80105d31:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d34:	01 d0                	add    %edx,%eax
80105d36:	83 c0 3c             	add    $0x3c,%eax
80105d39:	83 ec 04             	sub    $0x4,%esp
80105d3c:	6a 20                	push   $0x20
80105d3e:	51                   	push   %ecx
80105d3f:	50                   	push   %eax
80105d40:	e8 56 0c 00 00       	call   8010699b <safestrcpy>
80105d45:	83 c4 10             	add    $0x10,%esp
        index++; // after 
80105d48:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc* table){
  int index = 0;      // which is my count of processes at the same time
  struct proc *p;
  
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
80105d4c:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105d53:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80105d5a:	73 0c                	jae    80105d68 <getprocs+0x1ea>
80105d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d5f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105d62:	0f 82 3f fe ff ff    	jb     80105ba7 <getprocs+0x29>
        table[index].size = p -> sz;
        safestrcpy(table[index].name, p-> name, STRMAX);          
        index++; // after 
      }
    }
    release(&ptable.lock);
80105d68:	83 ec 0c             	sub    $0xc,%esp
80105d6b:	68 a0 49 11 80       	push   $0x801149a0
80105d70:	e8 27 08 00 00       	call   8010659c <release>
80105d75:	83 c4 10             	add    $0x10,%esp
    return index;    
80105d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d7b:	c9                   	leave  
80105d7c:	c3                   	ret    

80105d7d <assertState>:

// Project #3 helper functions 

#ifdef CS333_P3P4
static void
assertState(struct proc * p, enum procstate state){
80105d7d:	55                   	push   %ebp
80105d7e:	89 e5                	mov    %esp,%ebp
80105d80:	83 ec 08             	sub    $0x8,%esp
  if( p -> state != state){
80105d83:	8b 45 08             	mov    0x8(%ebp),%eax
80105d86:	8b 40 0c             	mov    0xc(%eax),%eax
80105d89:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105d8c:	74 36                	je     80105dc4 <assertState+0x47>
    cprintf("Different states: current %s and expected %s\n", states[p-> state], states[state]);
80105d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d91:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80105d98:	8b 45 08             	mov    0x8(%ebp),%eax
80105d9b:	8b 40 0c             	mov    0xc(%eax),%eax
80105d9e:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105da5:	83 ec 04             	sub    $0x4,%esp
80105da8:	52                   	push   %edx
80105da9:	50                   	push   %eax
80105daa:	68 0c a2 10 80       	push   $0x8010a20c
80105daf:	e8 12 a6 ff ff       	call   801003c6 <cprintf>
80105db4:	83 c4 10             	add    $0x10,%esp
    panic("Panic different states");
80105db7:	83 ec 0c             	sub    $0xc,%esp
80105dba:	68 3a a2 10 80       	push   $0x8010a23a
80105dbf:	e8 a2 a7 ff ff       	call   80100566 <panic>
  }
}
80105dc4:	90                   	nop
80105dc5:	c9                   	leave  
80105dc6:	c3                   	ret    

80105dc7 <removeFromStateList>:

static int
removeFromStateList(struct proc** sList, struct proc * p){
80105dc7:	55                   	push   %ebp
80105dc8:	89 e5                	mov    %esp,%ebp
80105dca:	83 ec 18             	sub    $0x18,%esp
  struct proc * current; 
  struct proc * previous;
  current = *sList;
80105dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd0:	8b 00                	mov    (%eax),%eax
80105dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(current == 0)
80105dd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dd9:	75 0d                	jne    80105de8 <removeFromStateList+0x21>
    panic("Nothing in sList");
80105ddb:	83 ec 0c             	sub    $0xc,%esp
80105dde:	68 51 a2 10 80       	push   $0x8010a251
80105de3:	e8 7e a7 ff ff       	call   80100566 <panic>

  if(current == p){
80105de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105deb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105dee:	75 22                	jne    80105e12 <removeFromStateList+0x4b>
    *sList = p -> next;
80105df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105df3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105df9:	8b 45 08             	mov    0x8(%ebp),%eax
80105dfc:	89 10                	mov    %edx,(%eax)
    p -> next = 0;
80105dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e01:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e08:	00 00 00 
    return 1;
80105e0b:	b8 01 00 00 00       	mov    $0x1,%eax
80105e10:	eb 69                	jmp    80105e7b <removeFromStateList+0xb4>
  }

  previous = *sList;
80105e12:	8b 45 08             	mov    0x8(%ebp),%eax
80105e15:	8b 00                	mov    (%eax),%eax
80105e17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  current = current -> next;
80105e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  while(current){
80105e26:	eb 40                	jmp    80105e68 <removeFromStateList+0xa1>
    if(current == p){
80105e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105e2e:	75 26                	jne    80105e56 <removeFromStateList+0x8f>
      previous -> next = current -> next;
80105e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e33:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3c:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      current -> next = 0;
80105e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e45:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e4c:	00 00 00 
      return 1 ;
80105e4f:	b8 01 00 00 00       	mov    $0x1,%eax
80105e54:	eb 25                	jmp    80105e7b <removeFromStateList+0xb4>
    }
    previous = current;
80105e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    current = current -> next;
80105e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  previous = *sList;
  current = current -> next;
 
  while(current){
80105e68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e6c:	75 ba                	jne    80105e28 <removeFromStateList+0x61>
      return 1 ;
    }
    previous = current;
    current = current -> next;
  }
  panic("I'm not in the list -- removeFromStateList call");
80105e6e:	83 ec 0c             	sub    $0xc,%esp
80105e71:	68 64 a2 10 80       	push   $0x8010a264
80105e76:	e8 eb a6 ff ff       	call   80100566 <panic>
  return 0;
}
80105e7b:	c9                   	leave  
80105e7c:	c3                   	ret    

80105e7d <traverseList>:


static int
traverseList(struct proc **sList){
80105e7d:	55                   	push   %ebp
80105e7e:	89 e5                	mov    %esp,%ebp
80105e80:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;
    current = *sList;
80105e83:	8b 45 08             	mov    0x8(%ebp),%eax
80105e86:	8b 00                	mov    (%eax),%eax
80105e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
    //int count = 0;
    while(current){
80105e8b:	eb 23                	jmp    80105eb0 <traverseList+0x33>
      if(current -> parent == proc){
80105e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e90:	8b 50 14             	mov    0x14(%eax),%edx
80105e93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e99:	39 c2                	cmp    %eax,%edx
80105e9b:	75 07                	jne    80105ea4 <traverseList+0x27>
        return 1;
80105e9d:	b8 01 00 00 00       	mov    $0x1,%eax
80105ea2:	eb 17                	jmp    80105ebb <traverseList+0x3e>
      }
      current = current -> next;
80105ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ea7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
static int
traverseList(struct proc **sList){
    struct proc * current;
    current = *sList;
    //int count = 0;
    while(current){
80105eb0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105eb4:	75 d7                	jne    80105e8d <traverseList+0x10>
      if(current -> parent == proc){
        return 1;
      }
      current = current -> next;
    }
    return 0;
80105eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ebb:	c9                   	leave  
80105ebc:	c3                   	ret    

80105ebd <traverseToKill>:

static int 
traverseToKill(struct proc **sList, int pid){
80105ebd:	55                   	push   %ebp
80105ebe:	89 e5                	mov    %esp,%ebp
80105ec0:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
80105ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ec6:	8b 00                	mov    (%eax),%eax
80105ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);     // *****move the lock before the function call outside
80105ecb:	83 ec 0c             	sub    $0xc,%esp
80105ece:	68 a0 49 11 80       	push   $0x801149a0
80105ed3:	e8 5d 06 00 00       	call   80106535 <acquire>
80105ed8:	83 c4 10             	add    $0x10,%esp

  while(current){
80105edb:	e9 97 00 00 00       	jmp    80105f77 <traverseToKill+0xba>
    if(current -> pid == pid){
80105ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee3:	8b 50 10             	mov    0x10(%eax),%edx
80105ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ee9:	39 c2                	cmp    %eax,%edx
80105eeb:	75 7e                	jne    80105f6b <traverseToKill+0xae>
      current -> killed = 1;
80105eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef0:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(current -> state == SLEEPING){ // assert state sleeping
80105ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efa:	8b 40 0c             	mov    0xc(%eax),%eax
80105efd:	83 f8 02             	cmp    $0x2,%eax
80105f00:	75 52                	jne    80105f54 <traverseToKill+0x97>
        removeFromStateList(&ptable.pLists.sleep, current);
80105f02:	83 ec 08             	sub    $0x8,%esp
80105f05:	ff 75 f4             	pushl  -0xc(%ebp)
80105f08:	68 f4 70 11 80       	push   $0x801170f4
80105f0d:	e8 b5 fe ff ff       	call   80105dc7 <removeFromStateList>
80105f12:	83 c4 10             	add    $0x10,%esp
        current -> state = RUNNABLE;
80105f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f18:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        current -> priority = 0;                  //P4 put it to the first priority queue -- it gets out of the system sooner 
80105f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f22:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80105f29:	00 00 00 
        insertTail(&ptable.pLists.ready[current -> priority], current);                  //P4 put it at the same priority level
80105f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105f35:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f3a:	c1 e0 02             	shl    $0x2,%eax
80105f3d:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105f42:	83 c0 04             	add    $0x4,%eax
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	ff 75 f4             	pushl  -0xc(%ebp)
80105f4b:	50                   	push   %eax
80105f4c:	e8 5b 01 00 00       	call   801060ac <insertTail>
80105f51:	83 c4 10             	add    $0x10,%esp
      }
      release(&ptable.lock);
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	68 a0 49 11 80       	push   $0x801149a0
80105f5c:	e8 3b 06 00 00       	call   8010659c <release>
80105f61:	83 c4 10             	add    $0x10,%esp
      return 1;
80105f64:	b8 01 00 00 00       	mov    $0x1,%eax
80105f69:	eb 2b                	jmp    80105f96 <traverseToKill+0xd9>
    }else{
      current = current -> next;
80105f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc * current;
  current = *sList;

  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
80105f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f7b:	0f 85 5f ff ff ff    	jne    80105ee0 <traverseToKill+0x23>
      return 1;
    }else{
      current = current -> next;
    }
  }
  release(&ptable.lock);
80105f81:	83 ec 0c             	sub    $0xc,%esp
80105f84:	68 a0 49 11 80       	push   $0x801149a0
80105f89:	e8 0e 06 00 00       	call   8010659c <release>
80105f8e:	83 c4 10             	add    $0x10,%esp
  return -1;
80105f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f96:	c9                   	leave  
80105f97:	c3                   	ret    

80105f98 <removeFront>:

static struct proc *
removeFront(struct proc** sList){
80105f98:	55                   	push   %ebp
80105f99:	89 e5                	mov    %esp,%ebp
80105f9b:	83 ec 10             	sub    $0x10,%esp
  struct proc * temp;
  temp = *sList;
80105f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa1:	8b 00                	mov    (%eax),%eax
80105fa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(temp == 0)
80105fa6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105faa:	75 05                	jne    80105fb1 <removeFront+0x19>
    return temp;
80105fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105faf:	eb 13                	jmp    80105fc4 <removeFront+0x2c>

  *sList = (* sList) -> next;
80105fb1:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb4:	8b 00                	mov    (%eax),%eax
80105fb6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80105fbf:	89 10                	mov    %edx,(%eax)

  return temp;
80105fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105fc4:	c9                   	leave  
80105fc5:	c3                   	ret    

80105fc6 <promoteOneLevelUp>:

static int                                        //P4 helper function promote up
promoteOneLevelUp(struct proc** sList){
80105fc6:	55                   	push   %ebp
80105fc7:	89 e5                	mov    %esp,%ebp
80105fc9:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
80105fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80105fcf:	8b 00                	mov    (%eax),%eax
80105fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(current == 0){
80105fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fd8:	75 07                	jne    80105fe1 <promoteOneLevelUp+0x1b>
    return 0;
80105fda:	b8 00 00 00 00       	mov    $0x0,%eax
80105fdf:	eb 73                	jmp    80106054 <promoteOneLevelUp+0x8e>
  }
  if(current -> priority == 0){
80105fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105fea:	85 c0                	test   %eax,%eax
80105fec:	75 58                	jne    80106046 <promoteOneLevelUp+0x80>
    return 1;
80105fee:	b8 01 00 00 00       	mov    $0x1,%eax
80105ff3:	eb 5f                	jmp    80106054 <promoteOneLevelUp+0x8e>
  }
  while(*sList){
    current = removeFront(sList);
80105ff5:	ff 75 08             	pushl  0x8(%ebp)
80105ff8:	e8 9b ff ff ff       	call   80105f98 <removeFront>
80105ffd:	83 c4 04             	add    $0x4,%esp
80106000:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(current){
80106003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106007:	74 3d                	je     80106046 <promoteOneLevelUp+0x80>
      current -> priority = current -> priority - 1;
80106009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106012:	8d 50 ff             	lea    -0x1(%eax),%edx
80106015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106018:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      insertTail(&ptable.pLists.ready[current -> priority], current);
8010601e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106021:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106027:	05 cc 09 00 00       	add    $0x9cc,%eax
8010602c:	c1 e0 02             	shl    $0x2,%eax
8010602f:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106034:	83 c0 04             	add    $0x4,%eax
80106037:	83 ec 08             	sub    $0x8,%esp
8010603a:	ff 75 f4             	pushl  -0xc(%ebp)
8010603d:	50                   	push   %eax
8010603e:	e8 69 00 00 00       	call   801060ac <insertTail>
80106043:	83 c4 10             	add    $0x10,%esp
    return 0;
  }
  if(current -> priority == 0){
    return 1;
  }
  while(*sList){
80106046:	8b 45 08             	mov    0x8(%ebp),%eax
80106049:	8b 00                	mov    (%eax),%eax
8010604b:	85 c0                	test   %eax,%eax
8010604d:	75 a6                	jne    80105ff5 <promoteOneLevelUp+0x2f>
    if(current){
      current -> priority = current -> priority - 1;
      insertTail(&ptable.pLists.ready[current -> priority], current);
    }
  }
  return 1;
8010604f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106054:	c9                   	leave  
80106055:	c3                   	ret    

80106056 <promoteOneLevelUpRunSleep>:

static int                                        //P4 helper function promote up
promoteOneLevelUpRunSleep(struct proc** sList){
80106056:	55                   	push   %ebp
80106057:	89 e5                	mov    %esp,%ebp
80106059:	83 ec 10             	sub    $0x10,%esp
  struct proc * current;
  current = *sList;
8010605c:	8b 45 08             	mov    0x8(%ebp),%eax
8010605f:	8b 00                	mov    (%eax),%eax
80106061:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(current == 0){
80106064:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106068:	75 35                	jne    8010609f <promoteOneLevelUpRunSleep+0x49>
    return 0;
8010606a:	b8 00 00 00 00       	mov    $0x0,%eax
8010606f:	eb 39                	jmp    801060aa <promoteOneLevelUpRunSleep+0x54>
  }
  while(current){
    if(current -> priority > 0){
80106071:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106074:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010607a:	85 c0                	test   %eax,%eax
8010607c:	7e 15                	jle    80106093 <promoteOneLevelUpRunSleep+0x3d>
      current -> priority = current -> priority - 1;
8010607e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106081:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106087:	8d 50 ff             	lea    -0x1(%eax),%edx
8010608a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010608d:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    }
    current = current -> next;
80106093:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106096:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010609c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc * current;
  current = *sList;
  if(current == 0){
    return 0;
  }
  while(current){
8010609f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801060a3:	75 cc                	jne    80106071 <promoteOneLevelUpRunSleep+0x1b>
    if(current -> priority > 0){
      current -> priority = current -> priority - 1;
    }
    current = current -> next;
  }
  return 1;
801060a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
801060aa:	c9                   	leave  
801060ab:	c3                   	ret    

801060ac <insertTail>:

static void
insertTail(struct proc** sList, struct proc * p){
801060ac:	55                   	push   %ebp
801060ad:	89 e5                	mov    %esp,%ebp
801060af:	83 ec 10             	sub    $0x10,%esp
  if(*sList == 0){
801060b2:	8b 45 08             	mov    0x8(%ebp),%eax
801060b5:	8b 00                	mov    (%eax),%eax
801060b7:	85 c0                	test   %eax,%eax
801060b9:	75 19                	jne    801060d4 <insertTail+0x28>
    *sList = p;
801060bb:	8b 45 08             	mov    0x8(%ebp),%eax
801060be:	8b 55 0c             	mov    0xc(%ebp),%edx
801060c1:	89 10                	mov    %edx,(%eax)
    (*sList) -> next = 0;
801060c3:	8b 45 08             	mov    0x8(%ebp),%eax
801060c6:	8b 00                	mov    (%eax),%eax
801060c8:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060cf:	00 00 00 
    return;
801060d2:	eb 3d                	jmp    80106111 <insertTail+0x65>
  }

  struct proc * current;
  current = *sList;
801060d4:	8b 45 08             	mov    0x8(%ebp),%eax
801060d7:	8b 00                	mov    (%eax),%eax
801060d9:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(current -> next != 0){
801060dc:	eb 0c                	jmp    801060ea <insertTail+0x3e>
    current = current -> next;
801060de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801060e1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  }

  struct proc * current;
  current = *sList;

  while(current -> next != 0){
801060ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801060ed:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060f3:	85 c0                	test   %eax,%eax
801060f5:	75 e7                	jne    801060de <insertTail+0x32>
    current = current -> next;
  }
  current -> next = p;
801060f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801060fa:	8b 55 0c             	mov    0xc(%ebp),%edx
801060fd:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  p -> next = 0;
80106103:	8b 45 0c             	mov    0xc(%ebp),%eax
80106106:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010610d:	00 00 00 
  return;
80106110:	90                   	nop
}
80106111:	c9                   	leave  
80106112:	c3                   	ret    

80106113 <insertAtHead>:

static void
insertAtHead(struct proc** sList, struct proc * p){
80106113:	55                   	push   %ebp
80106114:	89 e5                	mov    %esp,%ebp
  p->next = *sList;
80106116:	8b 45 08             	mov    0x8(%ebp),%eax
80106119:	8b 10                	mov    (%eax),%edx
8010611b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010611e:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
80106124:	8b 45 08             	mov    0x8(%ebp),%eax
80106127:	8b 55 0c             	mov    0xc(%ebp),%edx
8010612a:	89 10                	mov    %edx,(%eax)
}
8010612c:	90                   	nop
8010612d:	5d                   	pop    %ebp
8010612e:	c3                   	ret    

8010612f <printPidReadyList>:

#endif

void
printPidReadyList(void){
8010612f:	55                   	push   %ebp
80106130:	89 e5                	mov    %esp,%ebp
80106132:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80106135:	83 ec 0c             	sub    $0xc,%esp
80106138:	68 a0 49 11 80       	push   $0x801149a0
8010613d:	e8 f3 03 00 00       	call   80106535 <acquire>
80106142:	83 c4 10             	add    $0x10,%esp
   cprintf("Ready List processes: \n");
80106145:	83 ec 0c             	sub    $0xc,%esp
80106148:	68 94 a2 10 80       	push   $0x8010a294
8010614d:	e8 74 a2 ff ff       	call   801003c6 <cprintf>
80106152:	83 c4 10             	add    $0x10,%esp
   for(int i = 0; i <= MAX; i++){
80106155:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010615c:	eb 6e                	jmp    801061cc <printPidReadyList+0x9d>
    cprintf("%d: ", i);
8010615e:	83 ec 08             	sub    $0x8,%esp
80106161:	ff 75 f0             	pushl  -0x10(%ebp)
80106164:	68 ac a2 10 80       	push   $0x8010a2ac
80106169:	e8 58 a2 ff ff       	call   801003c6 <cprintf>
8010616e:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.ready[i];
80106171:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106174:	05 cc 09 00 00       	add    $0x9cc,%eax
80106179:	8b 04 85 a4 49 11 80 	mov    -0x7feeb65c(,%eax,4),%eax
80106180:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(current){
80106183:	eb 2d                	jmp    801061b2 <printPidReadyList+0x83>
      cprintf("(%d, %d) ->", current -> pid, current -> budget);
80106185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106188:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010618e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106191:	8b 40 10             	mov    0x10(%eax),%eax
80106194:	83 ec 04             	sub    $0x4,%esp
80106197:	52                   	push   %edx
80106198:	50                   	push   %eax
80106199:	68 b1 a2 10 80       	push   $0x8010a2b1
8010619e:	e8 23 a2 ff ff       	call   801003c6 <cprintf>
801061a3:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
801061a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801061af:	89 45 f4             	mov    %eax,-0xc(%ebp)
   acquire(&ptable.lock);
   cprintf("Ready List processes: \n");
   for(int i = 0; i <= MAX; i++){
    cprintf("%d: ", i);
    current = ptable.pLists.ready[i];
    while(current){
801061b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061b6:	75 cd                	jne    80106185 <printPidReadyList+0x56>
      cprintf("(%d, %d) ->", current -> pid, current -> budget);
      current = current -> next;
    }
    cprintf("\n");
801061b8:	83 ec 0c             	sub    $0xc,%esp
801061bb:	68 0a a2 10 80       	push   $0x8010a20a
801061c0:	e8 01 a2 ff ff       	call   801003c6 <cprintf>
801061c5:	83 c4 10             	add    $0x10,%esp
void
printPidReadyList(void){
   struct proc * current;
   acquire(&ptable.lock);
   cprintf("Ready List processes: \n");
   for(int i = 0; i <= MAX; i++){
801061c8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801061cc:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
801061d0:	7e 8c                	jle    8010615e <printPidReadyList+0x2f>
      current = current -> next;
    }
    cprintf("\n");
  }

    release(&ptable.lock);
801061d2:	83 ec 0c             	sub    $0xc,%esp
801061d5:	68 a0 49 11 80       	push   $0x801149a0
801061da:	e8 bd 03 00 00       	call   8010659c <release>
801061df:	83 c4 10             	add    $0x10,%esp
}
801061e2:	90                   	nop
801061e3:	c9                   	leave  
801061e4:	c3                   	ret    

801061e5 <countFreeList>:

void
countFreeList(void){
801061e5:	55                   	push   %ebp
801061e6:	89 e5                	mov    %esp,%ebp
801061e8:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
801061eb:	83 ec 0c             	sub    $0xc,%esp
801061ee:	68 a0 49 11 80       	push   $0x801149a0
801061f3:	e8 3d 03 00 00       	call   80106535 <acquire>
801061f8:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.free;
801061fb:	a1 f0 70 11 80       	mov    0x801170f0,%eax
80106200:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int count = 0;
80106203:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(current){
8010620a:	eb 10                	jmp    8010621c <countFreeList+0x37>
      count++;
8010620c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      current = current -> next;
80106210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106213:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106219:	89 45 f4             	mov    %eax,-0xc(%ebp)
countFreeList(void){
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.free;
    int count = 0;
    while(current){
8010621c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106220:	75 ea                	jne    8010620c <countFreeList+0x27>
      count++;
      current = current -> next;
    }
    cprintf("Free List size: %d\n", count);
80106222:	83 ec 08             	sub    $0x8,%esp
80106225:	ff 75 f0             	pushl  -0x10(%ebp)
80106228:	68 bd a2 10 80       	push   $0x8010a2bd
8010622d:	e8 94 a1 ff ff       	call   801003c6 <cprintf>
80106232:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80106235:	83 ec 0c             	sub    $0xc,%esp
80106238:	68 a0 49 11 80       	push   $0x801149a0
8010623d:	e8 5a 03 00 00       	call   8010659c <release>
80106242:	83 c4 10             	add    $0x10,%esp
}
80106245:	90                   	nop
80106246:	c9                   	leave  
80106247:	c3                   	ret    

80106248 <printPidSleepList>:

void
printPidSleepList(void){
80106248:	55                   	push   %ebp
80106249:	89 e5                	mov    %esp,%ebp
8010624b:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
8010624e:	83 ec 0c             	sub    $0xc,%esp
80106251:	68 a0 49 11 80       	push   $0x801149a0
80106256:	e8 da 02 00 00       	call   80106535 <acquire>
8010625b:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.sleep;
8010625e:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80106263:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Sleep List processes: \n");
80106266:	83 ec 0c             	sub    $0xc,%esp
80106269:	68 d1 a2 10 80       	push   $0x8010a2d1
8010626e:	e8 53 a1 ff ff       	call   801003c6 <cprintf>
80106273:	83 c4 10             	add    $0x10,%esp
    while(current){
80106276:	eb 23                	jmp    8010629b <printPidSleepList+0x53>
      cprintf("%d ->", current -> pid);
80106278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627b:	8b 40 10             	mov    0x10(%eax),%eax
8010627e:	83 ec 08             	sub    $0x8,%esp
80106281:	50                   	push   %eax
80106282:	68 e9 a2 10 80       	push   $0x8010a2e9
80106287:	e8 3a a1 ff ff       	call   801003c6 <cprintf>
8010628c:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
8010628f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106292:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106298:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.sleep;
    //int count = 0;
    cprintf("Sleep List processes: \n");
    while(current){
8010629b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010629f:	75 d7                	jne    80106278 <printPidSleepList+0x30>
      cprintf("%d ->", current -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
801062a1:	83 ec 0c             	sub    $0xc,%esp
801062a4:	68 a0 49 11 80       	push   $0x801149a0
801062a9:	e8 ee 02 00 00       	call   8010659c <release>
801062ae:	83 c4 10             	add    $0x10,%esp
}
801062b1:	90                   	nop
801062b2:	c9                   	leave  
801062b3:	c3                   	ret    

801062b4 <printZombieList>:

void
printZombieList(void){
801062b4:	55                   	push   %ebp
801062b5:	89 e5                	mov    %esp,%ebp
801062b7:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
801062ba:	83 ec 0c             	sub    $0xc,%esp
801062bd:	68 a0 49 11 80       	push   $0x801149a0
801062c2:	e8 6e 02 00 00       	call   80106535 <acquire>
801062c7:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.zombie;
801062ca:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801062cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Zombie List processes: \n");
801062d2:	83 ec 0c             	sub    $0xc,%esp
801062d5:	68 ef a2 10 80       	push   $0x8010a2ef
801062da:	e8 e7 a0 ff ff       	call   801003c6 <cprintf>
801062df:	83 c4 10             	add    $0x10,%esp
    while(current){
801062e2:	eb 2d                	jmp    80106311 <printZombieList+0x5d>
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
801062e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e7:	8b 40 14             	mov    0x14(%eax),%eax
801062ea:	8b 50 10             	mov    0x10(%eax),%edx
801062ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f0:	8b 40 10             	mov    0x10(%eax),%eax
801062f3:	83 ec 04             	sub    $0x4,%esp
801062f6:	52                   	push   %edx
801062f7:	50                   	push   %eax
801062f8:	68 08 a3 10 80       	push   $0x8010a308
801062fd:	e8 c4 a0 ff ff       	call   801003c6 <cprintf>
80106302:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80106305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106308:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010630e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.zombie;
    //int count = 0;
    cprintf("Zombie List processes: \n");
    while(current){
80106311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106315:	75 cd                	jne    801062e4 <printZombieList+0x30>
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
80106317:	83 ec 0c             	sub    $0xc,%esp
8010631a:	68 a0 49 11 80       	push   $0x801149a0
8010631f:	e8 78 02 00 00       	call   8010659c <release>
80106324:	83 c4 10             	add    $0x10,%esp
}
80106327:	90                   	nop
80106328:	c9                   	leave  
80106329:	c3                   	ret    

8010632a <setpriority>:

#ifdef CS333_P3P4

int
setpriority(int pid, int priority){
8010632a:	55                   	push   %ebp
8010632b:	89 e5                	mov    %esp,%ebp
8010632d:	83 ec 18             	sub    $0x18,%esp
  if(priority < 0 || priority > MAX){
80106330:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106334:	78 06                	js     8010633c <setpriority+0x12>
80106336:	83 7d 0c 06          	cmpl   $0x6,0xc(%ebp)
8010633a:	7e 0a                	jle    80106346 <setpriority+0x1c>
    return -1;
8010633c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106341:	e9 8d 00 00 00       	jmp    801063d3 <setpriority+0xa9>
  }
  if(updatePriority(&ptable.pLists.sleep, pid, priority) == 1)
80106346:	83 ec 04             	sub    $0x4,%esp
80106349:	ff 75 0c             	pushl  0xc(%ebp)
8010634c:	ff 75 08             	pushl  0x8(%ebp)
8010634f:	68 f4 70 11 80       	push   $0x801170f4
80106354:	e8 7c 00 00 00       	call   801063d5 <updatePriority>
80106359:	83 c4 10             	add    $0x10,%esp
8010635c:	83 f8 01             	cmp    $0x1,%eax
8010635f:	75 07                	jne    80106368 <setpriority+0x3e>
    return 0;
80106361:	b8 00 00 00 00       	mov    $0x0,%eax
80106366:	eb 6b                	jmp    801063d3 <setpriority+0xa9>
  if(updatePriority(&ptable.pLists.running, pid, priority) == 1)
80106368:	83 ec 04             	sub    $0x4,%esp
8010636b:	ff 75 0c             	pushl  0xc(%ebp)
8010636e:	ff 75 08             	pushl  0x8(%ebp)
80106371:	68 fc 70 11 80       	push   $0x801170fc
80106376:	e8 5a 00 00 00       	call   801063d5 <updatePriority>
8010637b:	83 c4 10             	add    $0x10,%esp
8010637e:	83 f8 01             	cmp    $0x1,%eax
80106381:	75 07                	jne    8010638a <setpriority+0x60>
    return 0;
80106383:	b8 00 00 00 00       	mov    $0x0,%eax
80106388:	eb 49                	jmp    801063d3 <setpriority+0xa9>
  for(int i = 0; i <=MAX; i++){
8010638a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106391:	eb 35                	jmp    801063c8 <setpriority+0x9e>
    if(updatePriority(&ptable.pLists.ready[i], pid, priority)== 1)
80106393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106396:	05 cc 09 00 00       	add    $0x9cc,%eax
8010639b:	c1 e0 02             	shl    $0x2,%eax
8010639e:	05 a0 49 11 80       	add    $0x801149a0,%eax
801063a3:	83 c0 04             	add    $0x4,%eax
801063a6:	83 ec 04             	sub    $0x4,%esp
801063a9:	ff 75 0c             	pushl  0xc(%ebp)
801063ac:	ff 75 08             	pushl  0x8(%ebp)
801063af:	50                   	push   %eax
801063b0:	e8 20 00 00 00       	call   801063d5 <updatePriority>
801063b5:	83 c4 10             	add    $0x10,%esp
801063b8:	83 f8 01             	cmp    $0x1,%eax
801063bb:	75 07                	jne    801063c4 <setpriority+0x9a>
      return 0;
801063bd:	b8 00 00 00 00       	mov    $0x0,%eax
801063c2:	eb 0f                	jmp    801063d3 <setpriority+0xa9>
  }
  if(updatePriority(&ptable.pLists.sleep, pid, priority) == 1)
    return 0;
  if(updatePriority(&ptable.pLists.running, pid, priority) == 1)
    return 0;
  for(int i = 0; i <=MAX; i++){
801063c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801063c8:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
801063cc:	7e c5                	jle    80106393 <setpriority+0x69>
    if(updatePriority(&ptable.pLists.ready[i], pid, priority)== 1)
      return 0;
  }

  return -1;
801063ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063d3:	c9                   	leave  
801063d4:	c3                   	ret    

801063d5 <updatePriority>:

static int
updatePriority(struct proc** sList, int pid, int priority){
801063d5:	55                   	push   %ebp
801063d6:	89 e5                	mov    %esp,%ebp
801063d8:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
801063db:	8b 45 08             	mov    0x8(%ebp),%eax
801063de:	8b 00                	mov    (%eax),%eax
801063e0:	89 45 f4             	mov    %eax,-0xc(%ebp)


  acquire(&ptable.lock);     // *****move the lock before the function call outside
801063e3:	83 ec 0c             	sub    $0xc,%esp
801063e6:	68 a0 49 11 80       	push   $0x801149a0
801063eb:	e8 45 01 00 00       	call   80106535 <acquire>
801063f0:	83 c4 10             	add    $0x10,%esp

  while(current){
801063f3:	e9 c2 00 00 00       	jmp    801064ba <updatePriority+0xe5>
    if(current -> pid == pid){
801063f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063fb:	8b 50 10             	mov    0x10(%eax),%edx
801063fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106401:	39 c2                	cmp    %eax,%edx
80106403:	0f 85 a5 00 00 00    	jne    801064ae <updatePriority+0xd9>
      if(current -> priority != priority && current -> state == RUNNABLE){
80106409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106412:	3b 45 10             	cmp    0x10(%ebp),%eax
80106415:	74 67                	je     8010647e <updatePriority+0xa9>
80106417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641a:	8b 40 0c             	mov    0xc(%eax),%eax
8010641d:	83 f8 03             	cmp    $0x3,%eax
80106420:	75 5c                	jne    8010647e <updatePriority+0xa9>
        removeFromStateList(&ptable.pLists.ready[current -> priority], current);
80106422:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106425:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010642b:	05 cc 09 00 00       	add    $0x9cc,%eax
80106430:	c1 e0 02             	shl    $0x2,%eax
80106433:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106438:	83 c0 04             	add    $0x4,%eax
8010643b:	83 ec 08             	sub    $0x8,%esp
8010643e:	ff 75 f4             	pushl  -0xc(%ebp)
80106441:	50                   	push   %eax
80106442:	e8 80 f9 ff ff       	call   80105dc7 <removeFromStateList>
80106447:	83 c4 10             	add    $0x10,%esp
        current -> priority = priority;
8010644a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644d:	8b 55 10             	mov    0x10(%ebp),%edx
80106450:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        insertTail(&ptable.pLists.ready[current -> priority], current);                           //P4 put it at the same priority level
80106456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106459:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010645f:	05 cc 09 00 00       	add    $0x9cc,%eax
80106464:	c1 e0 02             	shl    $0x2,%eax
80106467:	05 a0 49 11 80       	add    $0x801149a0,%eax
8010646c:	83 c0 04             	add    $0x4,%eax
8010646f:	83 ec 08             	sub    $0x8,%esp
80106472:	ff 75 f4             	pushl  -0xc(%ebp)
80106475:	50                   	push   %eax
80106476:	e8 31 fc ff ff       	call   801060ac <insertTail>
8010647b:	83 c4 10             	add    $0x10,%esp
      }
      current -> priority = priority;
8010647e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106481:	8b 55 10             	mov    0x10(%ebp),%edx
80106484:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      current -> budget = BUDGET;
8010648a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010648d:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
80106494:	13 00 00 
      release(&ptable.lock);
80106497:	83 ec 0c             	sub    $0xc,%esp
8010649a:	68 a0 49 11 80       	push   $0x801149a0
8010649f:	e8 f8 00 00 00       	call   8010659c <release>
801064a4:	83 c4 10             	add    $0x10,%esp
      return 1; 
801064a7:	b8 01 00 00 00       	mov    $0x1,%eax
801064ac:	eb 2b                	jmp    801064d9 <updatePriority+0x104>
    }
    current = current -> next;
801064ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801064b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  current = *sList;


  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
801064ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064be:	0f 85 34 ff ff ff    	jne    801063f8 <updatePriority+0x23>
      release(&ptable.lock);
      return 1; 
    }
    current = current -> next;
  }
  release(&ptable.lock);
801064c4:	83 ec 0c             	sub    $0xc,%esp
801064c7:	68 a0 49 11 80       	push   $0x801149a0
801064cc:	e8 cb 00 00 00       	call   8010659c <release>
801064d1:	83 c4 10             	add    $0x10,%esp
  return -1;  
801064d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064d9:	c9                   	leave  
801064da:	c3                   	ret    

801064db <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801064db:	55                   	push   %ebp
801064dc:	89 e5                	mov    %esp,%ebp
801064de:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801064e1:	9c                   	pushf  
801064e2:	58                   	pop    %eax
801064e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801064e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801064e9:	c9                   	leave  
801064ea:	c3                   	ret    

801064eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801064eb:	55                   	push   %ebp
801064ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801064ee:	fa                   	cli    
}
801064ef:	90                   	nop
801064f0:	5d                   	pop    %ebp
801064f1:	c3                   	ret    

801064f2 <sti>:

static inline void
sti(void)
{
801064f2:	55                   	push   %ebp
801064f3:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801064f5:	fb                   	sti    
}
801064f6:	90                   	nop
801064f7:	5d                   	pop    %ebp
801064f8:	c3                   	ret    

801064f9 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801064f9:	55                   	push   %ebp
801064fa:	89 e5                	mov    %esp,%ebp
801064fc:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801064ff:	8b 55 08             	mov    0x8(%ebp),%edx
80106502:	8b 45 0c             	mov    0xc(%ebp),%eax
80106505:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106508:	f0 87 02             	lock xchg %eax,(%edx)
8010650b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010650e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106511:	c9                   	leave  
80106512:	c3                   	ret    

80106513 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106513:	55                   	push   %ebp
80106514:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106516:	8b 45 08             	mov    0x8(%ebp),%eax
80106519:	8b 55 0c             	mov    0xc(%ebp),%edx
8010651c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010651f:	8b 45 08             	mov    0x8(%ebp),%eax
80106522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106528:	8b 45 08             	mov    0x8(%ebp),%eax
8010652b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106532:	90                   	nop
80106533:	5d                   	pop    %ebp
80106534:	c3                   	ret    

80106535 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106535:	55                   	push   %ebp
80106536:	89 e5                	mov    %esp,%ebp
80106538:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010653b:	e8 52 01 00 00       	call   80106692 <pushcli>
  if(holding(lk))
80106540:	8b 45 08             	mov    0x8(%ebp),%eax
80106543:	83 ec 0c             	sub    $0xc,%esp
80106546:	50                   	push   %eax
80106547:	e8 1c 01 00 00       	call   80106668 <holding>
8010654c:	83 c4 10             	add    $0x10,%esp
8010654f:	85 c0                	test   %eax,%eax
80106551:	74 0d                	je     80106560 <acquire+0x2b>
    panic("acquire");
80106553:	83 ec 0c             	sub    $0xc,%esp
80106556:	68 13 a3 10 80       	push   $0x8010a313
8010655b:	e8 06 a0 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106560:	90                   	nop
80106561:	8b 45 08             	mov    0x8(%ebp),%eax
80106564:	83 ec 08             	sub    $0x8,%esp
80106567:	6a 01                	push   $0x1
80106569:	50                   	push   %eax
8010656a:	e8 8a ff ff ff       	call   801064f9 <xchg>
8010656f:	83 c4 10             	add    $0x10,%esp
80106572:	85 c0                	test   %eax,%eax
80106574:	75 eb                	jne    80106561 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106576:	8b 45 08             	mov    0x8(%ebp),%eax
80106579:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106580:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106583:	8b 45 08             	mov    0x8(%ebp),%eax
80106586:	83 c0 0c             	add    $0xc,%eax
80106589:	83 ec 08             	sub    $0x8,%esp
8010658c:	50                   	push   %eax
8010658d:	8d 45 08             	lea    0x8(%ebp),%eax
80106590:	50                   	push   %eax
80106591:	e8 58 00 00 00       	call   801065ee <getcallerpcs>
80106596:	83 c4 10             	add    $0x10,%esp
}
80106599:	90                   	nop
8010659a:	c9                   	leave  
8010659b:	c3                   	ret    

8010659c <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010659c:	55                   	push   %ebp
8010659d:	89 e5                	mov    %esp,%ebp
8010659f:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801065a2:	83 ec 0c             	sub    $0xc,%esp
801065a5:	ff 75 08             	pushl  0x8(%ebp)
801065a8:	e8 bb 00 00 00       	call   80106668 <holding>
801065ad:	83 c4 10             	add    $0x10,%esp
801065b0:	85 c0                	test   %eax,%eax
801065b2:	75 0d                	jne    801065c1 <release+0x25>
    panic("release");
801065b4:	83 ec 0c             	sub    $0xc,%esp
801065b7:	68 1b a3 10 80       	push   $0x8010a31b
801065bc:	e8 a5 9f ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801065c1:	8b 45 08             	mov    0x8(%ebp),%eax
801065c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801065cb:	8b 45 08             	mov    0x8(%ebp),%eax
801065ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801065d5:	8b 45 08             	mov    0x8(%ebp),%eax
801065d8:	83 ec 08             	sub    $0x8,%esp
801065db:	6a 00                	push   $0x0
801065dd:	50                   	push   %eax
801065de:	e8 16 ff ff ff       	call   801064f9 <xchg>
801065e3:	83 c4 10             	add    $0x10,%esp

  popcli();
801065e6:	e8 ec 00 00 00       	call   801066d7 <popcli>
}
801065eb:	90                   	nop
801065ec:	c9                   	leave  
801065ed:	c3                   	ret    

801065ee <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801065ee:	55                   	push   %ebp
801065ef:	89 e5                	mov    %esp,%ebp
801065f1:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801065f4:	8b 45 08             	mov    0x8(%ebp),%eax
801065f7:	83 e8 08             	sub    $0x8,%eax
801065fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801065fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106604:	eb 38                	jmp    8010663e <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106606:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010660a:	74 53                	je     8010665f <getcallerpcs+0x71>
8010660c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106613:	76 4a                	jbe    8010665f <getcallerpcs+0x71>
80106615:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106619:	74 44                	je     8010665f <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010661b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010661e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106625:	8b 45 0c             	mov    0xc(%ebp),%eax
80106628:	01 c2                	add    %eax,%edx
8010662a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010662d:	8b 40 04             	mov    0x4(%eax),%eax
80106630:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106632:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106635:	8b 00                	mov    (%eax),%eax
80106637:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010663a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010663e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106642:	7e c2                	jle    80106606 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106644:	eb 19                	jmp    8010665f <getcallerpcs+0x71>
    pcs[i] = 0;
80106646:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106649:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106650:	8b 45 0c             	mov    0xc(%ebp),%eax
80106653:	01 d0                	add    %edx,%eax
80106655:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010665b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010665f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106663:	7e e1                	jle    80106646 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106665:	90                   	nop
80106666:	c9                   	leave  
80106667:	c3                   	ret    

80106668 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106668:	55                   	push   %ebp
80106669:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010666b:	8b 45 08             	mov    0x8(%ebp),%eax
8010666e:	8b 00                	mov    (%eax),%eax
80106670:	85 c0                	test   %eax,%eax
80106672:	74 17                	je     8010668b <holding+0x23>
80106674:	8b 45 08             	mov    0x8(%ebp),%eax
80106677:	8b 50 08             	mov    0x8(%eax),%edx
8010667a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106680:	39 c2                	cmp    %eax,%edx
80106682:	75 07                	jne    8010668b <holding+0x23>
80106684:	b8 01 00 00 00       	mov    $0x1,%eax
80106689:	eb 05                	jmp    80106690 <holding+0x28>
8010668b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106690:	5d                   	pop    %ebp
80106691:	c3                   	ret    

80106692 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106692:	55                   	push   %ebp
80106693:	89 e5                	mov    %esp,%ebp
80106695:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106698:	e8 3e fe ff ff       	call   801064db <readeflags>
8010669d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801066a0:	e8 46 fe ff ff       	call   801064eb <cli>
  if(cpu->ncli++ == 0)
801066a5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801066ac:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801066b2:	8d 48 01             	lea    0x1(%eax),%ecx
801066b5:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801066bb:	85 c0                	test   %eax,%eax
801066bd:	75 15                	jne    801066d4 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801066bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801066c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801066c8:	81 e2 00 02 00 00    	and    $0x200,%edx
801066ce:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801066d4:	90                   	nop
801066d5:	c9                   	leave  
801066d6:	c3                   	ret    

801066d7 <popcli>:

void
popcli(void)
{
801066d7:	55                   	push   %ebp
801066d8:	89 e5                	mov    %esp,%ebp
801066da:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801066dd:	e8 f9 fd ff ff       	call   801064db <readeflags>
801066e2:	25 00 02 00 00       	and    $0x200,%eax
801066e7:	85 c0                	test   %eax,%eax
801066e9:	74 0d                	je     801066f8 <popcli+0x21>
    panic("popcli - interruptible");
801066eb:	83 ec 0c             	sub    $0xc,%esp
801066ee:	68 23 a3 10 80       	push   $0x8010a323
801066f3:	e8 6e 9e ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
801066f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801066fe:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106704:	83 ea 01             	sub    $0x1,%edx
80106707:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010670d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106713:	85 c0                	test   %eax,%eax
80106715:	79 0d                	jns    80106724 <popcli+0x4d>
    panic("popcli");
80106717:	83 ec 0c             	sub    $0xc,%esp
8010671a:	68 3a a3 10 80       	push   $0x8010a33a
8010671f:	e8 42 9e ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106724:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010672a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106730:	85 c0                	test   %eax,%eax
80106732:	75 15                	jne    80106749 <popcli+0x72>
80106734:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010673a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106740:	85 c0                	test   %eax,%eax
80106742:	74 05                	je     80106749 <popcli+0x72>
    sti();
80106744:	e8 a9 fd ff ff       	call   801064f2 <sti>
}
80106749:	90                   	nop
8010674a:	c9                   	leave  
8010674b:	c3                   	ret    

8010674c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010674c:	55                   	push   %ebp
8010674d:	89 e5                	mov    %esp,%ebp
8010674f:	57                   	push   %edi
80106750:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106751:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106754:	8b 55 10             	mov    0x10(%ebp),%edx
80106757:	8b 45 0c             	mov    0xc(%ebp),%eax
8010675a:	89 cb                	mov    %ecx,%ebx
8010675c:	89 df                	mov    %ebx,%edi
8010675e:	89 d1                	mov    %edx,%ecx
80106760:	fc                   	cld    
80106761:	f3 aa                	rep stos %al,%es:(%edi)
80106763:	89 ca                	mov    %ecx,%edx
80106765:	89 fb                	mov    %edi,%ebx
80106767:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010676a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010676d:	90                   	nop
8010676e:	5b                   	pop    %ebx
8010676f:	5f                   	pop    %edi
80106770:	5d                   	pop    %ebp
80106771:	c3                   	ret    

80106772 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106772:	55                   	push   %ebp
80106773:	89 e5                	mov    %esp,%ebp
80106775:	57                   	push   %edi
80106776:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106777:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010677a:	8b 55 10             	mov    0x10(%ebp),%edx
8010677d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106780:	89 cb                	mov    %ecx,%ebx
80106782:	89 df                	mov    %ebx,%edi
80106784:	89 d1                	mov    %edx,%ecx
80106786:	fc                   	cld    
80106787:	f3 ab                	rep stos %eax,%es:(%edi)
80106789:	89 ca                	mov    %ecx,%edx
8010678b:	89 fb                	mov    %edi,%ebx
8010678d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106790:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106793:	90                   	nop
80106794:	5b                   	pop    %ebx
80106795:	5f                   	pop    %edi
80106796:	5d                   	pop    %ebp
80106797:	c3                   	ret    

80106798 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106798:	55                   	push   %ebp
80106799:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
8010679b:	8b 45 08             	mov    0x8(%ebp),%eax
8010679e:	83 e0 03             	and    $0x3,%eax
801067a1:	85 c0                	test   %eax,%eax
801067a3:	75 43                	jne    801067e8 <memset+0x50>
801067a5:	8b 45 10             	mov    0x10(%ebp),%eax
801067a8:	83 e0 03             	and    $0x3,%eax
801067ab:	85 c0                	test   %eax,%eax
801067ad:	75 39                	jne    801067e8 <memset+0x50>
    c &= 0xFF;
801067af:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801067b6:	8b 45 10             	mov    0x10(%ebp),%eax
801067b9:	c1 e8 02             	shr    $0x2,%eax
801067bc:	89 c1                	mov    %eax,%ecx
801067be:	8b 45 0c             	mov    0xc(%ebp),%eax
801067c1:	c1 e0 18             	shl    $0x18,%eax
801067c4:	89 c2                	mov    %eax,%edx
801067c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801067c9:	c1 e0 10             	shl    $0x10,%eax
801067cc:	09 c2                	or     %eax,%edx
801067ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d1:	c1 e0 08             	shl    $0x8,%eax
801067d4:	09 d0                	or     %edx,%eax
801067d6:	0b 45 0c             	or     0xc(%ebp),%eax
801067d9:	51                   	push   %ecx
801067da:	50                   	push   %eax
801067db:	ff 75 08             	pushl  0x8(%ebp)
801067de:	e8 8f ff ff ff       	call   80106772 <stosl>
801067e3:	83 c4 0c             	add    $0xc,%esp
801067e6:	eb 12                	jmp    801067fa <memset+0x62>
  } else
    stosb(dst, c, n);
801067e8:	8b 45 10             	mov    0x10(%ebp),%eax
801067eb:	50                   	push   %eax
801067ec:	ff 75 0c             	pushl  0xc(%ebp)
801067ef:	ff 75 08             	pushl  0x8(%ebp)
801067f2:	e8 55 ff ff ff       	call   8010674c <stosb>
801067f7:	83 c4 0c             	add    $0xc,%esp
  return dst;
801067fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
801067fd:	c9                   	leave  
801067fe:	c3                   	ret    

801067ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801067ff:	55                   	push   %ebp
80106800:	89 e5                	mov    %esp,%ebp
80106802:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106805:	8b 45 08             	mov    0x8(%ebp),%eax
80106808:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010680b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010680e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106811:	eb 30                	jmp    80106843 <memcmp+0x44>
    if(*s1 != *s2)
80106813:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106816:	0f b6 10             	movzbl (%eax),%edx
80106819:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010681c:	0f b6 00             	movzbl (%eax),%eax
8010681f:	38 c2                	cmp    %al,%dl
80106821:	74 18                	je     8010683b <memcmp+0x3c>
      return *s1 - *s2;
80106823:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106826:	0f b6 00             	movzbl (%eax),%eax
80106829:	0f b6 d0             	movzbl %al,%edx
8010682c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010682f:	0f b6 00             	movzbl (%eax),%eax
80106832:	0f b6 c0             	movzbl %al,%eax
80106835:	29 c2                	sub    %eax,%edx
80106837:	89 d0                	mov    %edx,%eax
80106839:	eb 1a                	jmp    80106855 <memcmp+0x56>
    s1++, s2++;
8010683b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010683f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106843:	8b 45 10             	mov    0x10(%ebp),%eax
80106846:	8d 50 ff             	lea    -0x1(%eax),%edx
80106849:	89 55 10             	mov    %edx,0x10(%ebp)
8010684c:	85 c0                	test   %eax,%eax
8010684e:	75 c3                	jne    80106813 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106850:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106855:	c9                   	leave  
80106856:	c3                   	ret    

80106857 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106857:	55                   	push   %ebp
80106858:	89 e5                	mov    %esp,%ebp
8010685a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010685d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106860:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106863:	8b 45 08             	mov    0x8(%ebp),%eax
80106866:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106869:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010686c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010686f:	73 54                	jae    801068c5 <memmove+0x6e>
80106871:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106874:	8b 45 10             	mov    0x10(%ebp),%eax
80106877:	01 d0                	add    %edx,%eax
80106879:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010687c:	76 47                	jbe    801068c5 <memmove+0x6e>
    s += n;
8010687e:	8b 45 10             	mov    0x10(%ebp),%eax
80106881:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106884:	8b 45 10             	mov    0x10(%ebp),%eax
80106887:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010688a:	eb 13                	jmp    8010689f <memmove+0x48>
      *--d = *--s;
8010688c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106890:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106894:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106897:	0f b6 10             	movzbl (%eax),%edx
8010689a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010689d:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010689f:	8b 45 10             	mov    0x10(%ebp),%eax
801068a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801068a5:	89 55 10             	mov    %edx,0x10(%ebp)
801068a8:	85 c0                	test   %eax,%eax
801068aa:	75 e0                	jne    8010688c <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801068ac:	eb 24                	jmp    801068d2 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801068ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801068b1:	8d 50 01             	lea    0x1(%eax),%edx
801068b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
801068b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801068ba:	8d 4a 01             	lea    0x1(%edx),%ecx
801068bd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801068c0:	0f b6 12             	movzbl (%edx),%edx
801068c3:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801068c5:	8b 45 10             	mov    0x10(%ebp),%eax
801068c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801068cb:	89 55 10             	mov    %edx,0x10(%ebp)
801068ce:	85 c0                	test   %eax,%eax
801068d0:	75 dc                	jne    801068ae <memmove+0x57>
      *d++ = *s++;

  return dst;
801068d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801068d5:	c9                   	leave  
801068d6:	c3                   	ret    

801068d7 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801068d7:	55                   	push   %ebp
801068d8:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801068da:	ff 75 10             	pushl  0x10(%ebp)
801068dd:	ff 75 0c             	pushl  0xc(%ebp)
801068e0:	ff 75 08             	pushl  0x8(%ebp)
801068e3:	e8 6f ff ff ff       	call   80106857 <memmove>
801068e8:	83 c4 0c             	add    $0xc,%esp
}
801068eb:	c9                   	leave  
801068ec:	c3                   	ret    

801068ed <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801068ed:	55                   	push   %ebp
801068ee:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801068f0:	eb 0c                	jmp    801068fe <strncmp+0x11>
    n--, p++, q++;
801068f2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801068f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801068fa:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801068fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106902:	74 1a                	je     8010691e <strncmp+0x31>
80106904:	8b 45 08             	mov    0x8(%ebp),%eax
80106907:	0f b6 00             	movzbl (%eax),%eax
8010690a:	84 c0                	test   %al,%al
8010690c:	74 10                	je     8010691e <strncmp+0x31>
8010690e:	8b 45 08             	mov    0x8(%ebp),%eax
80106911:	0f b6 10             	movzbl (%eax),%edx
80106914:	8b 45 0c             	mov    0xc(%ebp),%eax
80106917:	0f b6 00             	movzbl (%eax),%eax
8010691a:	38 c2                	cmp    %al,%dl
8010691c:	74 d4                	je     801068f2 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010691e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106922:	75 07                	jne    8010692b <strncmp+0x3e>
    return 0;
80106924:	b8 00 00 00 00       	mov    $0x0,%eax
80106929:	eb 16                	jmp    80106941 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010692b:	8b 45 08             	mov    0x8(%ebp),%eax
8010692e:	0f b6 00             	movzbl (%eax),%eax
80106931:	0f b6 d0             	movzbl %al,%edx
80106934:	8b 45 0c             	mov    0xc(%ebp),%eax
80106937:	0f b6 00             	movzbl (%eax),%eax
8010693a:	0f b6 c0             	movzbl %al,%eax
8010693d:	29 c2                	sub    %eax,%edx
8010693f:	89 d0                	mov    %edx,%eax
}
80106941:	5d                   	pop    %ebp
80106942:	c3                   	ret    

80106943 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106943:	55                   	push   %ebp
80106944:	89 e5                	mov    %esp,%ebp
80106946:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106949:	8b 45 08             	mov    0x8(%ebp),%eax
8010694c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010694f:	90                   	nop
80106950:	8b 45 10             	mov    0x10(%ebp),%eax
80106953:	8d 50 ff             	lea    -0x1(%eax),%edx
80106956:	89 55 10             	mov    %edx,0x10(%ebp)
80106959:	85 c0                	test   %eax,%eax
8010695b:	7e 2c                	jle    80106989 <strncpy+0x46>
8010695d:	8b 45 08             	mov    0x8(%ebp),%eax
80106960:	8d 50 01             	lea    0x1(%eax),%edx
80106963:	89 55 08             	mov    %edx,0x8(%ebp)
80106966:	8b 55 0c             	mov    0xc(%ebp),%edx
80106969:	8d 4a 01             	lea    0x1(%edx),%ecx
8010696c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010696f:	0f b6 12             	movzbl (%edx),%edx
80106972:	88 10                	mov    %dl,(%eax)
80106974:	0f b6 00             	movzbl (%eax),%eax
80106977:	84 c0                	test   %al,%al
80106979:	75 d5                	jne    80106950 <strncpy+0xd>
    ;
  while(n-- > 0)
8010697b:	eb 0c                	jmp    80106989 <strncpy+0x46>
    *s++ = 0;
8010697d:	8b 45 08             	mov    0x8(%ebp),%eax
80106980:	8d 50 01             	lea    0x1(%eax),%edx
80106983:	89 55 08             	mov    %edx,0x8(%ebp)
80106986:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106989:	8b 45 10             	mov    0x10(%ebp),%eax
8010698c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010698f:	89 55 10             	mov    %edx,0x10(%ebp)
80106992:	85 c0                	test   %eax,%eax
80106994:	7f e7                	jg     8010697d <strncpy+0x3a>
    *s++ = 0;
  return os;
80106996:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106999:	c9                   	leave  
8010699a:	c3                   	ret    

8010699b <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010699b:	55                   	push   %ebp
8010699c:	89 e5                	mov    %esp,%ebp
8010699e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801069a1:	8b 45 08             	mov    0x8(%ebp),%eax
801069a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801069a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801069ab:	7f 05                	jg     801069b2 <safestrcpy+0x17>
    return os;
801069ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069b0:	eb 31                	jmp    801069e3 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801069b2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801069b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801069ba:	7e 1e                	jle    801069da <safestrcpy+0x3f>
801069bc:	8b 45 08             	mov    0x8(%ebp),%eax
801069bf:	8d 50 01             	lea    0x1(%eax),%edx
801069c2:	89 55 08             	mov    %edx,0x8(%ebp)
801069c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801069c8:	8d 4a 01             	lea    0x1(%edx),%ecx
801069cb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801069ce:	0f b6 12             	movzbl (%edx),%edx
801069d1:	88 10                	mov    %dl,(%eax)
801069d3:	0f b6 00             	movzbl (%eax),%eax
801069d6:	84 c0                	test   %al,%al
801069d8:	75 d8                	jne    801069b2 <safestrcpy+0x17>
    ;
  *s = 0;
801069da:	8b 45 08             	mov    0x8(%ebp),%eax
801069dd:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801069e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801069e3:	c9                   	leave  
801069e4:	c3                   	ret    

801069e5 <strlen>:

int
strlen(const char *s)
{
801069e5:	55                   	push   %ebp
801069e6:	89 e5                	mov    %esp,%ebp
801069e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801069eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801069f2:	eb 04                	jmp    801069f8 <strlen+0x13>
801069f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801069f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069fb:	8b 45 08             	mov    0x8(%ebp),%eax
801069fe:	01 d0                	add    %edx,%eax
80106a00:	0f b6 00             	movzbl (%eax),%eax
80106a03:	84 c0                	test   %al,%al
80106a05:	75 ed                	jne    801069f4 <strlen+0xf>
    ;
  return n;
80106a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a0a:	c9                   	leave  
80106a0b:	c3                   	ret    

80106a0c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106a0c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106a10:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106a14:	55                   	push   %ebp
  pushl %ebx
80106a15:	53                   	push   %ebx
  pushl %esi
80106a16:	56                   	push   %esi
  pushl %edi
80106a17:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106a18:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106a1a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106a1c:	5f                   	pop    %edi
  popl %esi
80106a1d:	5e                   	pop    %esi
  popl %ebx
80106a1e:	5b                   	pop    %ebx
  popl %ebp
80106a1f:	5d                   	pop    %ebp
  ret
80106a20:	c3                   	ret    

80106a21 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106a21:	55                   	push   %ebp
80106a22:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106a24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a2a:	8b 00                	mov    (%eax),%eax
80106a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
80106a2f:	76 12                	jbe    80106a43 <fetchint+0x22>
80106a31:	8b 45 08             	mov    0x8(%ebp),%eax
80106a34:	8d 50 04             	lea    0x4(%eax),%edx
80106a37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a3d:	8b 00                	mov    (%eax),%eax
80106a3f:	39 c2                	cmp    %eax,%edx
80106a41:	76 07                	jbe    80106a4a <fetchint+0x29>
    return -1;
80106a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a48:	eb 0f                	jmp    80106a59 <fetchint+0x38>
  *ip = *(int*)(addr);
80106a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4d:	8b 10                	mov    (%eax),%edx
80106a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a52:	89 10                	mov    %edx,(%eax)
  return 0;
80106a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a59:	5d                   	pop    %ebp
80106a5a:	c3                   	ret    

80106a5b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106a5b:	55                   	push   %ebp
80106a5c:	89 e5                	mov    %esp,%ebp
80106a5e:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106a61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a67:	8b 00                	mov    (%eax),%eax
80106a69:	3b 45 08             	cmp    0x8(%ebp),%eax
80106a6c:	77 07                	ja     80106a75 <fetchstr+0x1a>
    return -1;
80106a6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a73:	eb 46                	jmp    80106abb <fetchstr+0x60>
  *pp = (char*)addr;
80106a75:	8b 55 08             	mov    0x8(%ebp),%edx
80106a78:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a7b:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106a7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a83:	8b 00                	mov    (%eax),%eax
80106a85:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106a88:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a8b:	8b 00                	mov    (%eax),%eax
80106a8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106a90:	eb 1c                	jmp    80106aae <fetchstr+0x53>
    if(*s == 0)
80106a92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106a95:	0f b6 00             	movzbl (%eax),%eax
80106a98:	84 c0                	test   %al,%al
80106a9a:	75 0e                	jne    80106aaa <fetchstr+0x4f>
      return s - *pp;
80106a9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aa2:	8b 00                	mov    (%eax),%eax
80106aa4:	29 c2                	sub    %eax,%edx
80106aa6:	89 d0                	mov    %edx,%eax
80106aa8:	eb 11                	jmp    80106abb <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106aaa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ab1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106ab4:	72 dc                	jb     80106a92 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106abb:	c9                   	leave  
80106abc:	c3                   	ret    

80106abd <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106abd:	55                   	push   %ebp
80106abe:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106ac0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ac6:	8b 40 18             	mov    0x18(%eax),%eax
80106ac9:	8b 40 44             	mov    0x44(%eax),%eax
80106acc:	8b 55 08             	mov    0x8(%ebp),%edx
80106acf:	c1 e2 02             	shl    $0x2,%edx
80106ad2:	01 d0                	add    %edx,%eax
80106ad4:	83 c0 04             	add    $0x4,%eax
80106ad7:	ff 75 0c             	pushl  0xc(%ebp)
80106ada:	50                   	push   %eax
80106adb:	e8 41 ff ff ff       	call   80106a21 <fetchint>
80106ae0:	83 c4 08             	add    $0x8,%esp
}
80106ae3:	c9                   	leave  
80106ae4:	c3                   	ret    

80106ae5 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106ae5:	55                   	push   %ebp
80106ae6:	89 e5                	mov    %esp,%ebp
80106ae8:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106aeb:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106aee:	50                   	push   %eax
80106aef:	ff 75 08             	pushl  0x8(%ebp)
80106af2:	e8 c6 ff ff ff       	call   80106abd <argint>
80106af7:	83 c4 08             	add    $0x8,%esp
80106afa:	85 c0                	test   %eax,%eax
80106afc:	79 07                	jns    80106b05 <argptr+0x20>
    return -1;
80106afe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b03:	eb 3b                	jmp    80106b40 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106b05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b0b:	8b 00                	mov    (%eax),%eax
80106b0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b10:	39 d0                	cmp    %edx,%eax
80106b12:	76 16                	jbe    80106b2a <argptr+0x45>
80106b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b17:	89 c2                	mov    %eax,%edx
80106b19:	8b 45 10             	mov    0x10(%ebp),%eax
80106b1c:	01 c2                	add    %eax,%edx
80106b1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b24:	8b 00                	mov    (%eax),%eax
80106b26:	39 c2                	cmp    %eax,%edx
80106b28:	76 07                	jbe    80106b31 <argptr+0x4c>
    return -1;
80106b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b2f:	eb 0f                	jmp    80106b40 <argptr+0x5b>
  *pp = (char*)i;
80106b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b34:	89 c2                	mov    %eax,%edx
80106b36:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b39:	89 10                	mov    %edx,(%eax)
  return 0;
80106b3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b40:	c9                   	leave  
80106b41:	c3                   	ret    

80106b42 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106b42:	55                   	push   %ebp
80106b43:	89 e5                	mov    %esp,%ebp
80106b45:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106b48:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106b4b:	50                   	push   %eax
80106b4c:	ff 75 08             	pushl  0x8(%ebp)
80106b4f:	e8 69 ff ff ff       	call   80106abd <argint>
80106b54:	83 c4 08             	add    $0x8,%esp
80106b57:	85 c0                	test   %eax,%eax
80106b59:	79 07                	jns    80106b62 <argstr+0x20>
    return -1;
80106b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b60:	eb 0f                	jmp    80106b71 <argstr+0x2f>
  return fetchstr(addr, pp);
80106b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b65:	ff 75 0c             	pushl  0xc(%ebp)
80106b68:	50                   	push   %eax
80106b69:	e8 ed fe ff ff       	call   80106a5b <fetchstr>
80106b6e:	83 c4 08             	add    $0x8,%esp
}
80106b71:	c9                   	leave  
80106b72:	c3                   	ret    

80106b73 <syscall>:
"chgrp",
};
#endif 
void
syscall(void)
{
80106b73:	55                   	push   %ebp
80106b74:	89 e5                	mov    %esp,%ebp
80106b76:	53                   	push   %ebx
80106b77:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106b7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b80:	8b 40 18             	mov    0x18(%eax),%eax
80106b83:	8b 40 1c             	mov    0x1c(%eax),%eax
80106b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b8d:	7e 30                	jle    80106bbf <syscall+0x4c>
80106b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b92:	83 f8 21             	cmp    $0x21,%eax
80106b95:	77 28                	ja     80106bbf <syscall+0x4c>
80106b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b9a:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106ba1:	85 c0                	test   %eax,%eax
80106ba3:	74 1a                	je     80106bbf <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106ba5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bab:	8b 58 18             	mov    0x18(%eax),%ebx
80106bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bb1:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106bb8:	ff d0                	call   *%eax
80106bba:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106bbd:	eb 34                	jmp    80106bf3 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
      cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif 
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106bbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bc5:	8d 50 6c             	lea    0x6c(%eax),%edx
80106bc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    proc->tf->eax = syscalls[num]();
    #ifdef PRINT_SYSCALLS
      cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif 
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106bce:	8b 40 10             	mov    0x10(%eax),%eax
80106bd1:	ff 75 f4             	pushl  -0xc(%ebp)
80106bd4:	52                   	push   %edx
80106bd5:	50                   	push   %eax
80106bd6:	68 41 a3 10 80       	push   $0x8010a341
80106bdb:	e8 e6 97 ff ff       	call   801003c6 <cprintf>
80106be0:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106be3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106be9:	8b 40 18             	mov    0x18(%eax),%eax
80106bec:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106bf3:	90                   	nop
80106bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106bf7:	c9                   	leave  
80106bf8:	c3                   	ret    

80106bf9 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106bf9:	55                   	push   %ebp
80106bfa:	89 e5                	mov    %esp,%ebp
80106bfc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106bff:	83 ec 08             	sub    $0x8,%esp
80106c02:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c05:	50                   	push   %eax
80106c06:	ff 75 08             	pushl  0x8(%ebp)
80106c09:	e8 af fe ff ff       	call   80106abd <argint>
80106c0e:	83 c4 10             	add    $0x10,%esp
80106c11:	85 c0                	test   %eax,%eax
80106c13:	79 07                	jns    80106c1c <argfd+0x23>
    return -1;
80106c15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c1a:	eb 50                	jmp    80106c6c <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c1f:	85 c0                	test   %eax,%eax
80106c21:	78 21                	js     80106c44 <argfd+0x4b>
80106c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c26:	83 f8 0f             	cmp    $0xf,%eax
80106c29:	7f 19                	jg     80106c44 <argfd+0x4b>
80106c2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c31:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c34:	83 c2 08             	add    $0x8,%edx
80106c37:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c42:	75 07                	jne    80106c4b <argfd+0x52>
    return -1;
80106c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c49:	eb 21                	jmp    80106c6c <argfd+0x73>
  if(pfd)
80106c4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106c4f:	74 08                	je     80106c59 <argfd+0x60>
    *pfd = fd;
80106c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c54:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c57:	89 10                	mov    %edx,(%eax)
  if(pf)
80106c59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c5d:	74 08                	je     80106c67 <argfd+0x6e>
    *pf = f;
80106c5f:	8b 45 10             	mov    0x10(%ebp),%eax
80106c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106c65:	89 10                	mov    %edx,(%eax)
  return 0;
80106c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c6c:	c9                   	leave  
80106c6d:	c3                   	ret    

80106c6e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106c6e:	55                   	push   %ebp
80106c6f:	89 e5                	mov    %esp,%ebp
80106c71:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106c7b:	eb 30                	jmp    80106cad <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106c7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c83:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c86:	83 c2 08             	add    $0x8,%edx
80106c89:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106c8d:	85 c0                	test   %eax,%eax
80106c8f:	75 18                	jne    80106ca9 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c97:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c9a:	8d 4a 08             	lea    0x8(%edx),%ecx
80106c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80106ca0:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ca7:	eb 0f                	jmp    80106cb8 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106ca9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106cad:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106cb1:	7e ca                	jle    80106c7d <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cb8:	c9                   	leave  
80106cb9:	c3                   	ret    

80106cba <sys_dup>:

int
sys_dup(void)
{
80106cba:	55                   	push   %ebp
80106cbb:	89 e5                	mov    %esp,%ebp
80106cbd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106cc0:	83 ec 04             	sub    $0x4,%esp
80106cc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cc6:	50                   	push   %eax
80106cc7:	6a 00                	push   $0x0
80106cc9:	6a 00                	push   $0x0
80106ccb:	e8 29 ff ff ff       	call   80106bf9 <argfd>
80106cd0:	83 c4 10             	add    $0x10,%esp
80106cd3:	85 c0                	test   %eax,%eax
80106cd5:	79 07                	jns    80106cde <sys_dup+0x24>
    return -1;
80106cd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cdc:	eb 31                	jmp    80106d0f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ce1:	83 ec 0c             	sub    $0xc,%esp
80106ce4:	50                   	push   %eax
80106ce5:	e8 84 ff ff ff       	call   80106c6e <fdalloc>
80106cea:	83 c4 10             	add    $0x10,%esp
80106ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cf4:	79 07                	jns    80106cfd <sys_dup+0x43>
    return -1;
80106cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cfb:	eb 12                	jmp    80106d0f <sys_dup+0x55>
  filedup(f);
80106cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d00:	83 ec 0c             	sub    $0xc,%esp
80106d03:	50                   	push   %eax
80106d04:	e8 44 a4 ff ff       	call   8010114d <filedup>
80106d09:	83 c4 10             	add    $0x10,%esp
  return fd;
80106d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d0f:	c9                   	leave  
80106d10:	c3                   	ret    

80106d11 <sys_read>:

int
sys_read(void)
{
80106d11:	55                   	push   %ebp
80106d12:	89 e5                	mov    %esp,%ebp
80106d14:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106d17:	83 ec 04             	sub    $0x4,%esp
80106d1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d1d:	50                   	push   %eax
80106d1e:	6a 00                	push   $0x0
80106d20:	6a 00                	push   $0x0
80106d22:	e8 d2 fe ff ff       	call   80106bf9 <argfd>
80106d27:	83 c4 10             	add    $0x10,%esp
80106d2a:	85 c0                	test   %eax,%eax
80106d2c:	78 2e                	js     80106d5c <sys_read+0x4b>
80106d2e:	83 ec 08             	sub    $0x8,%esp
80106d31:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d34:	50                   	push   %eax
80106d35:	6a 02                	push   $0x2
80106d37:	e8 81 fd ff ff       	call   80106abd <argint>
80106d3c:	83 c4 10             	add    $0x10,%esp
80106d3f:	85 c0                	test   %eax,%eax
80106d41:	78 19                	js     80106d5c <sys_read+0x4b>
80106d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d46:	83 ec 04             	sub    $0x4,%esp
80106d49:	50                   	push   %eax
80106d4a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106d4d:	50                   	push   %eax
80106d4e:	6a 01                	push   $0x1
80106d50:	e8 90 fd ff ff       	call   80106ae5 <argptr>
80106d55:	83 c4 10             	add    $0x10,%esp
80106d58:	85 c0                	test   %eax,%eax
80106d5a:	79 07                	jns    80106d63 <sys_read+0x52>
    return -1;
80106d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d61:	eb 17                	jmp    80106d7a <sys_read+0x69>
  return fileread(f, p, n);
80106d63:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106d66:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6c:	83 ec 04             	sub    $0x4,%esp
80106d6f:	51                   	push   %ecx
80106d70:	52                   	push   %edx
80106d71:	50                   	push   %eax
80106d72:	e8 66 a5 ff ff       	call   801012dd <fileread>
80106d77:	83 c4 10             	add    $0x10,%esp
}
80106d7a:	c9                   	leave  
80106d7b:	c3                   	ret    

80106d7c <sys_write>:

int
sys_write(void)
{
80106d7c:	55                   	push   %ebp
80106d7d:	89 e5                	mov    %esp,%ebp
80106d7f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106d82:	83 ec 04             	sub    $0x4,%esp
80106d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d88:	50                   	push   %eax
80106d89:	6a 00                	push   $0x0
80106d8b:	6a 00                	push   $0x0
80106d8d:	e8 67 fe ff ff       	call   80106bf9 <argfd>
80106d92:	83 c4 10             	add    $0x10,%esp
80106d95:	85 c0                	test   %eax,%eax
80106d97:	78 2e                	js     80106dc7 <sys_write+0x4b>
80106d99:	83 ec 08             	sub    $0x8,%esp
80106d9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d9f:	50                   	push   %eax
80106da0:	6a 02                	push   $0x2
80106da2:	e8 16 fd ff ff       	call   80106abd <argint>
80106da7:	83 c4 10             	add    $0x10,%esp
80106daa:	85 c0                	test   %eax,%eax
80106dac:	78 19                	js     80106dc7 <sys_write+0x4b>
80106dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106db1:	83 ec 04             	sub    $0x4,%esp
80106db4:	50                   	push   %eax
80106db5:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106db8:	50                   	push   %eax
80106db9:	6a 01                	push   $0x1
80106dbb:	e8 25 fd ff ff       	call   80106ae5 <argptr>
80106dc0:	83 c4 10             	add    $0x10,%esp
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	79 07                	jns    80106dce <sys_write+0x52>
    return -1;
80106dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dcc:	eb 17                	jmp    80106de5 <sys_write+0x69>
  return filewrite(f, p, n);
80106dce:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106dd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dd7:	83 ec 04             	sub    $0x4,%esp
80106dda:	51                   	push   %ecx
80106ddb:	52                   	push   %edx
80106ddc:	50                   	push   %eax
80106ddd:	e8 b3 a5 ff ff       	call   80101395 <filewrite>
80106de2:	83 c4 10             	add    $0x10,%esp
}
80106de5:	c9                   	leave  
80106de6:	c3                   	ret    

80106de7 <sys_close>:

int
sys_close(void)
{
80106de7:	55                   	push   %ebp
80106de8:	89 e5                	mov    %esp,%ebp
80106dea:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106ded:	83 ec 04             	sub    $0x4,%esp
80106df0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106df3:	50                   	push   %eax
80106df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106df7:	50                   	push   %eax
80106df8:	6a 00                	push   $0x0
80106dfa:	e8 fa fd ff ff       	call   80106bf9 <argfd>
80106dff:	83 c4 10             	add    $0x10,%esp
80106e02:	85 c0                	test   %eax,%eax
80106e04:	79 07                	jns    80106e0d <sys_close+0x26>
    return -1;
80106e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e0b:	eb 28                	jmp    80106e35 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106e0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106e16:	83 c2 08             	add    $0x8,%edx
80106e19:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106e20:	00 
  fileclose(f);
80106e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e24:	83 ec 0c             	sub    $0xc,%esp
80106e27:	50                   	push   %eax
80106e28:	e8 71 a3 ff ff       	call   8010119e <fileclose>
80106e2d:	83 c4 10             	add    $0x10,%esp
  return 0;
80106e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e35:	c9                   	leave  
80106e36:	c3                   	ret    

80106e37 <sys_fstat>:

int
sys_fstat(void)
{
80106e37:	55                   	push   %ebp
80106e38:	89 e5                	mov    %esp,%ebp
80106e3a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106e3d:	83 ec 04             	sub    $0x4,%esp
80106e40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e43:	50                   	push   %eax
80106e44:	6a 00                	push   $0x0
80106e46:	6a 00                	push   $0x0
80106e48:	e8 ac fd ff ff       	call   80106bf9 <argfd>
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	85 c0                	test   %eax,%eax
80106e52:	78 17                	js     80106e6b <sys_fstat+0x34>
80106e54:	83 ec 04             	sub    $0x4,%esp
80106e57:	6a 1c                	push   $0x1c
80106e59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e5c:	50                   	push   %eax
80106e5d:	6a 01                	push   $0x1
80106e5f:	e8 81 fc ff ff       	call   80106ae5 <argptr>
80106e64:	83 c4 10             	add    $0x10,%esp
80106e67:	85 c0                	test   %eax,%eax
80106e69:	79 07                	jns    80106e72 <sys_fstat+0x3b>
    return -1;
80106e6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e70:	eb 13                	jmp    80106e85 <sys_fstat+0x4e>
  return filestat(f, st);
80106e72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e78:	83 ec 08             	sub    $0x8,%esp
80106e7b:	52                   	push   %edx
80106e7c:	50                   	push   %eax
80106e7d:	e8 04 a4 ff ff       	call   80101286 <filestat>
80106e82:	83 c4 10             	add    $0x10,%esp
}
80106e85:	c9                   	leave  
80106e86:	c3                   	ret    

80106e87 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106e87:	55                   	push   %ebp
80106e88:	89 e5                	mov    %esp,%ebp
80106e8a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106e8d:	83 ec 08             	sub    $0x8,%esp
80106e90:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106e93:	50                   	push   %eax
80106e94:	6a 00                	push   $0x0
80106e96:	e8 a7 fc ff ff       	call   80106b42 <argstr>
80106e9b:	83 c4 10             	add    $0x10,%esp
80106e9e:	85 c0                	test   %eax,%eax
80106ea0:	78 15                	js     80106eb7 <sys_link+0x30>
80106ea2:	83 ec 08             	sub    $0x8,%esp
80106ea5:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106ea8:	50                   	push   %eax
80106ea9:	6a 01                	push   $0x1
80106eab:	e8 92 fc ff ff       	call   80106b42 <argstr>
80106eb0:	83 c4 10             	add    $0x10,%esp
80106eb3:	85 c0                	test   %eax,%eax
80106eb5:	79 0a                	jns    80106ec1 <sys_link+0x3a>
    return -1;
80106eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ebc:	e9 68 01 00 00       	jmp    80107029 <sys_link+0x1a2>

  begin_op();
80106ec1:	e8 e1 c9 ff ff       	call   801038a7 <begin_op>
  if((ip = namei(old)) == 0){
80106ec6:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106ec9:	83 ec 0c             	sub    $0xc,%esp
80106ecc:	50                   	push   %eax
80106ecd:	e8 37 b8 ff ff       	call   80102709 <namei>
80106ed2:	83 c4 10             	add    $0x10,%esp
80106ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106edc:	75 0f                	jne    80106eed <sys_link+0x66>
    end_op();
80106ede:	e8 50 ca ff ff       	call   80103933 <end_op>
    return -1;
80106ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee8:	e9 3c 01 00 00       	jmp    80107029 <sys_link+0x1a2>
  }

  ilock(ip);
80106eed:	83 ec 0c             	sub    $0xc,%esp
80106ef0:	ff 75 f4             	pushl  -0xc(%ebp)
80106ef3:	e8 03 ac ff ff       	call   80101afb <ilock>
80106ef8:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106efe:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f02:	66 83 f8 01          	cmp    $0x1,%ax
80106f06:	75 1d                	jne    80106f25 <sys_link+0x9e>
    iunlockput(ip);
80106f08:	83 ec 0c             	sub    $0xc,%esp
80106f0b:	ff 75 f4             	pushl  -0xc(%ebp)
80106f0e:	e8 d0 ae ff ff       	call   80101de3 <iunlockput>
80106f13:	83 c4 10             	add    $0x10,%esp
    end_op();
80106f16:	e8 18 ca ff ff       	call   80103933 <end_op>
    return -1;
80106f1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f20:	e9 04 01 00 00       	jmp    80107029 <sys_link+0x1a2>
  }

  ip->nlink++;
80106f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f28:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106f2c:	83 c0 01             	add    $0x1,%eax
80106f2f:	89 c2                	mov    %eax,%edx
80106f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f34:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106f38:	83 ec 0c             	sub    $0xc,%esp
80106f3b:	ff 75 f4             	pushl  -0xc(%ebp)
80106f3e:	e8 b6 a9 ff ff       	call   801018f9 <iupdate>
80106f43:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106f46:	83 ec 0c             	sub    $0xc,%esp
80106f49:	ff 75 f4             	pushl  -0xc(%ebp)
80106f4c:	e8 30 ad ff ff       	call   80101c81 <iunlock>
80106f51:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106f54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106f57:	83 ec 08             	sub    $0x8,%esp
80106f5a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106f5d:	52                   	push   %edx
80106f5e:	50                   	push   %eax
80106f5f:	e8 c1 b7 ff ff       	call   80102725 <nameiparent>
80106f64:	83 c4 10             	add    $0x10,%esp
80106f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f6e:	74 71                	je     80106fe1 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106f70:	83 ec 0c             	sub    $0xc,%esp
80106f73:	ff 75 f0             	pushl  -0x10(%ebp)
80106f76:	e8 80 ab ff ff       	call   80101afb <ilock>
80106f7b:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f81:	8b 10                	mov    (%eax),%edx
80106f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f86:	8b 00                	mov    (%eax),%eax
80106f88:	39 c2                	cmp    %eax,%edx
80106f8a:	75 1d                	jne    80106fa9 <sys_link+0x122>
80106f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f8f:	8b 40 04             	mov    0x4(%eax),%eax
80106f92:	83 ec 04             	sub    $0x4,%esp
80106f95:	50                   	push   %eax
80106f96:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106f99:	50                   	push   %eax
80106f9a:	ff 75 f0             	pushl  -0x10(%ebp)
80106f9d:	e8 cb b4 ff ff       	call   8010246d <dirlink>
80106fa2:	83 c4 10             	add    $0x10,%esp
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	79 10                	jns    80106fb9 <sys_link+0x132>
    iunlockput(dp);
80106fa9:	83 ec 0c             	sub    $0xc,%esp
80106fac:	ff 75 f0             	pushl  -0x10(%ebp)
80106faf:	e8 2f ae ff ff       	call   80101de3 <iunlockput>
80106fb4:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106fb7:	eb 29                	jmp    80106fe2 <sys_link+0x15b>
  }
  iunlockput(dp);
80106fb9:	83 ec 0c             	sub    $0xc,%esp
80106fbc:	ff 75 f0             	pushl  -0x10(%ebp)
80106fbf:	e8 1f ae ff ff       	call   80101de3 <iunlockput>
80106fc4:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106fc7:	83 ec 0c             	sub    $0xc,%esp
80106fca:	ff 75 f4             	pushl  -0xc(%ebp)
80106fcd:	e8 21 ad ff ff       	call   80101cf3 <iput>
80106fd2:	83 c4 10             	add    $0x10,%esp

  end_op();
80106fd5:	e8 59 c9 ff ff       	call   80103933 <end_op>

  return 0;
80106fda:	b8 00 00 00 00       	mov    $0x0,%eax
80106fdf:	eb 48                	jmp    80107029 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106fe1:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106fe2:	83 ec 0c             	sub    $0xc,%esp
80106fe5:	ff 75 f4             	pushl  -0xc(%ebp)
80106fe8:	e8 0e ab ff ff       	call   80101afb <ilock>
80106fed:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ff3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106ff7:	83 e8 01             	sub    $0x1,%eax
80106ffa:	89 c2                	mov    %eax,%edx
80106ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fff:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107003:	83 ec 0c             	sub    $0xc,%esp
80107006:	ff 75 f4             	pushl  -0xc(%ebp)
80107009:	e8 eb a8 ff ff       	call   801018f9 <iupdate>
8010700e:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107011:	83 ec 0c             	sub    $0xc,%esp
80107014:	ff 75 f4             	pushl  -0xc(%ebp)
80107017:	e8 c7 ad ff ff       	call   80101de3 <iunlockput>
8010701c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010701f:	e8 0f c9 ff ff       	call   80103933 <end_op>
  return -1;
80107024:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107029:	c9                   	leave  
8010702a:	c3                   	ret    

8010702b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010702b:	55                   	push   %ebp
8010702c:	89 e5                	mov    %esp,%ebp
8010702e:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107031:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80107038:	eb 40                	jmp    8010707a <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010703a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010703d:	6a 10                	push   $0x10
8010703f:	50                   	push   %eax
80107040:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107043:	50                   	push   %eax
80107044:	ff 75 08             	pushl  0x8(%ebp)
80107047:	e8 6d b0 ff ff       	call   801020b9 <readi>
8010704c:	83 c4 10             	add    $0x10,%esp
8010704f:	83 f8 10             	cmp    $0x10,%eax
80107052:	74 0d                	je     80107061 <isdirempty+0x36>
      panic("isdirempty: readi");
80107054:	83 ec 0c             	sub    $0xc,%esp
80107057:	68 5d a3 10 80       	push   $0x8010a35d
8010705c:	e8 05 95 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80107061:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107065:	66 85 c0             	test   %ax,%ax
80107068:	74 07                	je     80107071 <isdirempty+0x46>
      return 0;
8010706a:	b8 00 00 00 00       	mov    $0x0,%eax
8010706f:	eb 1b                	jmp    8010708c <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107074:	83 c0 10             	add    $0x10,%eax
80107077:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010707a:	8b 45 08             	mov    0x8(%ebp),%eax
8010707d:	8b 50 18             	mov    0x18(%eax),%edx
80107080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107083:	39 c2                	cmp    %eax,%edx
80107085:	77 b3                	ja     8010703a <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80107087:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010708c:	c9                   	leave  
8010708d:	c3                   	ret    

8010708e <sys_unlink>:

int
sys_unlink(void)
{
8010708e:	55                   	push   %ebp
8010708f:	89 e5                	mov    %esp,%ebp
80107091:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80107094:	83 ec 08             	sub    $0x8,%esp
80107097:	8d 45 cc             	lea    -0x34(%ebp),%eax
8010709a:	50                   	push   %eax
8010709b:	6a 00                	push   $0x0
8010709d:	e8 a0 fa ff ff       	call   80106b42 <argstr>
801070a2:	83 c4 10             	add    $0x10,%esp
801070a5:	85 c0                	test   %eax,%eax
801070a7:	79 0a                	jns    801070b3 <sys_unlink+0x25>
    return -1;
801070a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070ae:	e9 bc 01 00 00       	jmp    8010726f <sys_unlink+0x1e1>

  begin_op();
801070b3:	e8 ef c7 ff ff       	call   801038a7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801070b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
801070bb:	83 ec 08             	sub    $0x8,%esp
801070be:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801070c1:	52                   	push   %edx
801070c2:	50                   	push   %eax
801070c3:	e8 5d b6 ff ff       	call   80102725 <nameiparent>
801070c8:	83 c4 10             	add    $0x10,%esp
801070cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801070ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801070d2:	75 0f                	jne    801070e3 <sys_unlink+0x55>
    end_op();
801070d4:	e8 5a c8 ff ff       	call   80103933 <end_op>
    return -1;
801070d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070de:	e9 8c 01 00 00       	jmp    8010726f <sys_unlink+0x1e1>
  }

  ilock(dp);
801070e3:	83 ec 0c             	sub    $0xc,%esp
801070e6:	ff 75 f4             	pushl  -0xc(%ebp)
801070e9:	e8 0d aa ff ff       	call   80101afb <ilock>
801070ee:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801070f1:	83 ec 08             	sub    $0x8,%esp
801070f4:	68 6f a3 10 80       	push   $0x8010a36f
801070f9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801070fc:	50                   	push   %eax
801070fd:	e8 96 b2 ff ff       	call   80102398 <namecmp>
80107102:	83 c4 10             	add    $0x10,%esp
80107105:	85 c0                	test   %eax,%eax
80107107:	0f 84 4a 01 00 00    	je     80107257 <sys_unlink+0x1c9>
8010710d:	83 ec 08             	sub    $0x8,%esp
80107110:	68 71 a3 10 80       	push   $0x8010a371
80107115:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107118:	50                   	push   %eax
80107119:	e8 7a b2 ff ff       	call   80102398 <namecmp>
8010711e:	83 c4 10             	add    $0x10,%esp
80107121:	85 c0                	test   %eax,%eax
80107123:	0f 84 2e 01 00 00    	je     80107257 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80107129:	83 ec 04             	sub    $0x4,%esp
8010712c:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010712f:	50                   	push   %eax
80107130:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107133:	50                   	push   %eax
80107134:	ff 75 f4             	pushl  -0xc(%ebp)
80107137:	e8 77 b2 ff ff       	call   801023b3 <dirlookup>
8010713c:	83 c4 10             	add    $0x10,%esp
8010713f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107142:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107146:	0f 84 0a 01 00 00    	je     80107256 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010714c:	83 ec 0c             	sub    $0xc,%esp
8010714f:	ff 75 f0             	pushl  -0x10(%ebp)
80107152:	e8 a4 a9 ff ff       	call   80101afb <ilock>
80107157:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010715a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010715d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107161:	66 85 c0             	test   %ax,%ax
80107164:	7f 0d                	jg     80107173 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	68 74 a3 10 80       	push   $0x8010a374
8010716e:	e8 f3 93 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80107173:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107176:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010717a:	66 83 f8 01          	cmp    $0x1,%ax
8010717e:	75 25                	jne    801071a5 <sys_unlink+0x117>
80107180:	83 ec 0c             	sub    $0xc,%esp
80107183:	ff 75 f0             	pushl  -0x10(%ebp)
80107186:	e8 a0 fe ff ff       	call   8010702b <isdirempty>
8010718b:	83 c4 10             	add    $0x10,%esp
8010718e:	85 c0                	test   %eax,%eax
80107190:	75 13                	jne    801071a5 <sys_unlink+0x117>
    iunlockput(ip);
80107192:	83 ec 0c             	sub    $0xc,%esp
80107195:	ff 75 f0             	pushl  -0x10(%ebp)
80107198:	e8 46 ac ff ff       	call   80101de3 <iunlockput>
8010719d:	83 c4 10             	add    $0x10,%esp
    goto bad;
801071a0:	e9 b2 00 00 00       	jmp    80107257 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801071a5:	83 ec 04             	sub    $0x4,%esp
801071a8:	6a 10                	push   $0x10
801071aa:	6a 00                	push   $0x0
801071ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801071af:	50                   	push   %eax
801071b0:	e8 e3 f5 ff ff       	call   80106798 <memset>
801071b5:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801071b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
801071bb:	6a 10                	push   $0x10
801071bd:	50                   	push   %eax
801071be:	8d 45 e0             	lea    -0x20(%ebp),%eax
801071c1:	50                   	push   %eax
801071c2:	ff 75 f4             	pushl  -0xc(%ebp)
801071c5:	e8 46 b0 ff ff       	call   80102210 <writei>
801071ca:	83 c4 10             	add    $0x10,%esp
801071cd:	83 f8 10             	cmp    $0x10,%eax
801071d0:	74 0d                	je     801071df <sys_unlink+0x151>
    panic("unlink: writei");
801071d2:	83 ec 0c             	sub    $0xc,%esp
801071d5:	68 86 a3 10 80       	push   $0x8010a386
801071da:	e8 87 93 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801071df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071e2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801071e6:	66 83 f8 01          	cmp    $0x1,%ax
801071ea:	75 21                	jne    8010720d <sys_unlink+0x17f>
    dp->nlink--;
801071ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071ef:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801071f3:	83 e8 01             	sub    $0x1,%eax
801071f6:	89 c2                	mov    %eax,%edx
801071f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071fb:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801071ff:	83 ec 0c             	sub    $0xc,%esp
80107202:	ff 75 f4             	pushl  -0xc(%ebp)
80107205:	e8 ef a6 ff ff       	call   801018f9 <iupdate>
8010720a:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010720d:	83 ec 0c             	sub    $0xc,%esp
80107210:	ff 75 f4             	pushl  -0xc(%ebp)
80107213:	e8 cb ab ff ff       	call   80101de3 <iunlockput>
80107218:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010721b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010721e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107222:	83 e8 01             	sub    $0x1,%eax
80107225:	89 c2                	mov    %eax,%edx
80107227:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010722a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010722e:	83 ec 0c             	sub    $0xc,%esp
80107231:	ff 75 f0             	pushl  -0x10(%ebp)
80107234:	e8 c0 a6 ff ff       	call   801018f9 <iupdate>
80107239:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	ff 75 f0             	pushl  -0x10(%ebp)
80107242:	e8 9c ab ff ff       	call   80101de3 <iunlockput>
80107247:	83 c4 10             	add    $0x10,%esp

  end_op();
8010724a:	e8 e4 c6 ff ff       	call   80103933 <end_op>

  return 0;
8010724f:	b8 00 00 00 00       	mov    $0x0,%eax
80107254:	eb 19                	jmp    8010726f <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107256:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107257:	83 ec 0c             	sub    $0xc,%esp
8010725a:	ff 75 f4             	pushl  -0xc(%ebp)
8010725d:	e8 81 ab ff ff       	call   80101de3 <iunlockput>
80107262:	83 c4 10             	add    $0x10,%esp
  end_op();
80107265:	e8 c9 c6 ff ff       	call   80103933 <end_op>
  return -1;
8010726a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010726f:	c9                   	leave  
80107270:	c3                   	ret    

80107271 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107271:	55                   	push   %ebp
80107272:	89 e5                	mov    %esp,%ebp
80107274:	83 ec 38             	sub    $0x38,%esp
80107277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010727a:	8b 55 10             	mov    0x10(%ebp),%edx
8010727d:	8b 45 14             	mov    0x14(%ebp),%eax
80107280:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80107284:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107288:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010728c:	83 ec 08             	sub    $0x8,%esp
8010728f:	8d 45 de             	lea    -0x22(%ebp),%eax
80107292:	50                   	push   %eax
80107293:	ff 75 08             	pushl  0x8(%ebp)
80107296:	e8 8a b4 ff ff       	call   80102725 <nameiparent>
8010729b:	83 c4 10             	add    $0x10,%esp
8010729e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801072a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801072a5:	75 0a                	jne    801072b1 <create+0x40>
    return 0;
801072a7:	b8 00 00 00 00       	mov    $0x0,%eax
801072ac:	e9 90 01 00 00       	jmp    80107441 <create+0x1d0>
  ilock(dp);
801072b1:	83 ec 0c             	sub    $0xc,%esp
801072b4:	ff 75 f4             	pushl  -0xc(%ebp)
801072b7:	e8 3f a8 ff ff       	call   80101afb <ilock>
801072bc:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801072bf:	83 ec 04             	sub    $0x4,%esp
801072c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801072c5:	50                   	push   %eax
801072c6:	8d 45 de             	lea    -0x22(%ebp),%eax
801072c9:	50                   	push   %eax
801072ca:	ff 75 f4             	pushl  -0xc(%ebp)
801072cd:	e8 e1 b0 ff ff       	call   801023b3 <dirlookup>
801072d2:	83 c4 10             	add    $0x10,%esp
801072d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072dc:	74 50                	je     8010732e <create+0xbd>
    iunlockput(dp);
801072de:	83 ec 0c             	sub    $0xc,%esp
801072e1:	ff 75 f4             	pushl  -0xc(%ebp)
801072e4:	e8 fa aa ff ff       	call   80101de3 <iunlockput>
801072e9:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	ff 75 f0             	pushl  -0x10(%ebp)
801072f2:	e8 04 a8 ff ff       	call   80101afb <ilock>
801072f7:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801072fa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801072ff:	75 15                	jne    80107316 <create+0xa5>
80107301:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107304:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107308:	66 83 f8 02          	cmp    $0x2,%ax
8010730c:	75 08                	jne    80107316 <create+0xa5>
      return ip;
8010730e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107311:	e9 2b 01 00 00       	jmp    80107441 <create+0x1d0>
    iunlockput(ip);
80107316:	83 ec 0c             	sub    $0xc,%esp
80107319:	ff 75 f0             	pushl  -0x10(%ebp)
8010731c:	e8 c2 aa ff ff       	call   80101de3 <iunlockput>
80107321:	83 c4 10             	add    $0x10,%esp
    return 0;
80107324:	b8 00 00 00 00       	mov    $0x0,%eax
80107329:	e9 13 01 00 00       	jmp    80107441 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010732e:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107335:	8b 00                	mov    (%eax),%eax
80107337:	83 ec 08             	sub    $0x8,%esp
8010733a:	52                   	push   %edx
8010733b:	50                   	push   %eax
8010733c:	e8 c5 a4 ff ff       	call   80101806 <ialloc>
80107341:	83 c4 10             	add    $0x10,%esp
80107344:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107347:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010734b:	75 0d                	jne    8010735a <create+0xe9>
    panic("create: ialloc");
8010734d:	83 ec 0c             	sub    $0xc,%esp
80107350:	68 95 a3 10 80       	push   $0x8010a395
80107355:	e8 0c 92 ff ff       	call   80100566 <panic>

  ilock(ip);
8010735a:	83 ec 0c             	sub    $0xc,%esp
8010735d:	ff 75 f0             	pushl  -0x10(%ebp)
80107360:	e8 96 a7 ff ff       	call   80101afb <ilock>
80107365:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010736b:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010736f:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80107373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107376:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010737a:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010737e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107381:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107387:	83 ec 0c             	sub    $0xc,%esp
8010738a:	ff 75 f0             	pushl  -0x10(%ebp)
8010738d:	e8 67 a5 ff ff       	call   801018f9 <iupdate>
80107392:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80107395:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010739a:	75 6a                	jne    80107406 <create+0x195>
    dp->nlink++;  // for ".."
8010739c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801073a3:	83 c0 01             	add    $0x1,%eax
801073a6:	89 c2                	mov    %eax,%edx
801073a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ab:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801073af:	83 ec 0c             	sub    $0xc,%esp
801073b2:	ff 75 f4             	pushl  -0xc(%ebp)
801073b5:	e8 3f a5 ff ff       	call   801018f9 <iupdate>
801073ba:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801073bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073c0:	8b 40 04             	mov    0x4(%eax),%eax
801073c3:	83 ec 04             	sub    $0x4,%esp
801073c6:	50                   	push   %eax
801073c7:	68 6f a3 10 80       	push   $0x8010a36f
801073cc:	ff 75 f0             	pushl  -0x10(%ebp)
801073cf:	e8 99 b0 ff ff       	call   8010246d <dirlink>
801073d4:	83 c4 10             	add    $0x10,%esp
801073d7:	85 c0                	test   %eax,%eax
801073d9:	78 1e                	js     801073f9 <create+0x188>
801073db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073de:	8b 40 04             	mov    0x4(%eax),%eax
801073e1:	83 ec 04             	sub    $0x4,%esp
801073e4:	50                   	push   %eax
801073e5:	68 71 a3 10 80       	push   $0x8010a371
801073ea:	ff 75 f0             	pushl  -0x10(%ebp)
801073ed:	e8 7b b0 ff ff       	call   8010246d <dirlink>
801073f2:	83 c4 10             	add    $0x10,%esp
801073f5:	85 c0                	test   %eax,%eax
801073f7:	79 0d                	jns    80107406 <create+0x195>
      panic("create dots");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 a4 a3 10 80       	push   $0x8010a3a4
80107401:	e8 60 91 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107406:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107409:	8b 40 04             	mov    0x4(%eax),%eax
8010740c:	83 ec 04             	sub    $0x4,%esp
8010740f:	50                   	push   %eax
80107410:	8d 45 de             	lea    -0x22(%ebp),%eax
80107413:	50                   	push   %eax
80107414:	ff 75 f4             	pushl  -0xc(%ebp)
80107417:	e8 51 b0 ff ff       	call   8010246d <dirlink>
8010741c:	83 c4 10             	add    $0x10,%esp
8010741f:	85 c0                	test   %eax,%eax
80107421:	79 0d                	jns    80107430 <create+0x1bf>
    panic("create: dirlink");
80107423:	83 ec 0c             	sub    $0xc,%esp
80107426:	68 b0 a3 10 80       	push   $0x8010a3b0
8010742b:	e8 36 91 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107430:	83 ec 0c             	sub    $0xc,%esp
80107433:	ff 75 f4             	pushl  -0xc(%ebp)
80107436:	e8 a8 a9 ff ff       	call   80101de3 <iunlockput>
8010743b:	83 c4 10             	add    $0x10,%esp

  return ip;
8010743e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107441:	c9                   	leave  
80107442:	c3                   	ret    

80107443 <sys_open>:

int
sys_open(void)
{
80107443:	55                   	push   %ebp
80107444:	89 e5                	mov    %esp,%ebp
80107446:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107449:	83 ec 08             	sub    $0x8,%esp
8010744c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010744f:	50                   	push   %eax
80107450:	6a 00                	push   $0x0
80107452:	e8 eb f6 ff ff       	call   80106b42 <argstr>
80107457:	83 c4 10             	add    $0x10,%esp
8010745a:	85 c0                	test   %eax,%eax
8010745c:	78 15                	js     80107473 <sys_open+0x30>
8010745e:	83 ec 08             	sub    $0x8,%esp
80107461:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107464:	50                   	push   %eax
80107465:	6a 01                	push   $0x1
80107467:	e8 51 f6 ff ff       	call   80106abd <argint>
8010746c:	83 c4 10             	add    $0x10,%esp
8010746f:	85 c0                	test   %eax,%eax
80107471:	79 0a                	jns    8010747d <sys_open+0x3a>
    return -1;
80107473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107478:	e9 61 01 00 00       	jmp    801075de <sys_open+0x19b>

  begin_op();
8010747d:	e8 25 c4 ff ff       	call   801038a7 <begin_op>

  if(omode & O_CREATE){
80107482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107485:	25 00 02 00 00       	and    $0x200,%eax
8010748a:	85 c0                	test   %eax,%eax
8010748c:	74 2a                	je     801074b8 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010748e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107491:	6a 00                	push   $0x0
80107493:	6a 00                	push   $0x0
80107495:	6a 02                	push   $0x2
80107497:	50                   	push   %eax
80107498:	e8 d4 fd ff ff       	call   80107271 <create>
8010749d:	83 c4 10             	add    $0x10,%esp
801074a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801074a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074a7:	75 75                	jne    8010751e <sys_open+0xdb>
      end_op();
801074a9:	e8 85 c4 ff ff       	call   80103933 <end_op>
      return -1;
801074ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074b3:	e9 26 01 00 00       	jmp    801075de <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801074b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801074bb:	83 ec 0c             	sub    $0xc,%esp
801074be:	50                   	push   %eax
801074bf:	e8 45 b2 ff ff       	call   80102709 <namei>
801074c4:	83 c4 10             	add    $0x10,%esp
801074c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801074ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801074ce:	75 0f                	jne    801074df <sys_open+0x9c>
      end_op();
801074d0:	e8 5e c4 ff ff       	call   80103933 <end_op>
      return -1;
801074d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074da:	e9 ff 00 00 00       	jmp    801075de <sys_open+0x19b>
    }
    ilock(ip);
801074df:	83 ec 0c             	sub    $0xc,%esp
801074e2:	ff 75 f4             	pushl  -0xc(%ebp)
801074e5:	e8 11 a6 ff ff       	call   80101afb <ilock>
801074ea:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801074ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074f4:	66 83 f8 01          	cmp    $0x1,%ax
801074f8:	75 24                	jne    8010751e <sys_open+0xdb>
801074fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074fd:	85 c0                	test   %eax,%eax
801074ff:	74 1d                	je     8010751e <sys_open+0xdb>
      iunlockput(ip);
80107501:	83 ec 0c             	sub    $0xc,%esp
80107504:	ff 75 f4             	pushl  -0xc(%ebp)
80107507:	e8 d7 a8 ff ff       	call   80101de3 <iunlockput>
8010750c:	83 c4 10             	add    $0x10,%esp
      end_op();
8010750f:	e8 1f c4 ff ff       	call   80103933 <end_op>
      return -1;
80107514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107519:	e9 c0 00 00 00       	jmp    801075de <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010751e:	e8 bd 9b ff ff       	call   801010e0 <filealloc>
80107523:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107526:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010752a:	74 17                	je     80107543 <sys_open+0x100>
8010752c:	83 ec 0c             	sub    $0xc,%esp
8010752f:	ff 75 f0             	pushl  -0x10(%ebp)
80107532:	e8 37 f7 ff ff       	call   80106c6e <fdalloc>
80107537:	83 c4 10             	add    $0x10,%esp
8010753a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010753d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107541:	79 2e                	jns    80107571 <sys_open+0x12e>
    if(f)
80107543:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107547:	74 0e                	je     80107557 <sys_open+0x114>
      fileclose(f);
80107549:	83 ec 0c             	sub    $0xc,%esp
8010754c:	ff 75 f0             	pushl  -0x10(%ebp)
8010754f:	e8 4a 9c ff ff       	call   8010119e <fileclose>
80107554:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107557:	83 ec 0c             	sub    $0xc,%esp
8010755a:	ff 75 f4             	pushl  -0xc(%ebp)
8010755d:	e8 81 a8 ff ff       	call   80101de3 <iunlockput>
80107562:	83 c4 10             	add    $0x10,%esp
    end_op();
80107565:	e8 c9 c3 ff ff       	call   80103933 <end_op>
    return -1;
8010756a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010756f:	eb 6d                	jmp    801075de <sys_open+0x19b>
  }
  iunlock(ip);
80107571:	83 ec 0c             	sub    $0xc,%esp
80107574:	ff 75 f4             	pushl  -0xc(%ebp)
80107577:	e8 05 a7 ff ff       	call   80101c81 <iunlock>
8010757c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010757f:	e8 af c3 ff ff       	call   80103933 <end_op>

  f->type = FD_INODE;
80107584:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107587:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010758d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107593:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107596:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107599:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801075a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075a3:	83 e0 01             	and    $0x1,%eax
801075a6:	85 c0                	test   %eax,%eax
801075a8:	0f 94 c0             	sete   %al
801075ab:	89 c2                	mov    %eax,%edx
801075ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075b0:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801075b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075b6:	83 e0 01             	and    $0x1,%eax
801075b9:	85 c0                	test   %eax,%eax
801075bb:	75 0a                	jne    801075c7 <sys_open+0x184>
801075bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075c0:	83 e0 02             	and    $0x2,%eax
801075c3:	85 c0                	test   %eax,%eax
801075c5:	74 07                	je     801075ce <sys_open+0x18b>
801075c7:	b8 01 00 00 00       	mov    $0x1,%eax
801075cc:	eb 05                	jmp    801075d3 <sys_open+0x190>
801075ce:	b8 00 00 00 00       	mov    $0x0,%eax
801075d3:	89 c2                	mov    %eax,%edx
801075d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075d8:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801075db:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801075de:	c9                   	leave  
801075df:	c3                   	ret    

801075e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801075e6:	e8 bc c2 ff ff       	call   801038a7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801075eb:	83 ec 08             	sub    $0x8,%esp
801075ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
801075f1:	50                   	push   %eax
801075f2:	6a 00                	push   $0x0
801075f4:	e8 49 f5 ff ff       	call   80106b42 <argstr>
801075f9:	83 c4 10             	add    $0x10,%esp
801075fc:	85 c0                	test   %eax,%eax
801075fe:	78 1b                	js     8010761b <sys_mkdir+0x3b>
80107600:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107603:	6a 00                	push   $0x0
80107605:	6a 00                	push   $0x0
80107607:	6a 01                	push   $0x1
80107609:	50                   	push   %eax
8010760a:	e8 62 fc ff ff       	call   80107271 <create>
8010760f:	83 c4 10             	add    $0x10,%esp
80107612:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107619:	75 0c                	jne    80107627 <sys_mkdir+0x47>
    end_op();
8010761b:	e8 13 c3 ff ff       	call   80103933 <end_op>
    return -1;
80107620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107625:	eb 18                	jmp    8010763f <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107627:	83 ec 0c             	sub    $0xc,%esp
8010762a:	ff 75 f4             	pushl  -0xc(%ebp)
8010762d:	e8 b1 a7 ff ff       	call   80101de3 <iunlockput>
80107632:	83 c4 10             	add    $0x10,%esp
  end_op();
80107635:	e8 f9 c2 ff ff       	call   80103933 <end_op>
  return 0;
8010763a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010763f:	c9                   	leave  
80107640:	c3                   	ret    

80107641 <sys_mknod>:

int
sys_mknod(void)
{
80107641:	55                   	push   %ebp
80107642:	89 e5                	mov    %esp,%ebp
80107644:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107647:	e8 5b c2 ff ff       	call   801038a7 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010764c:	83 ec 08             	sub    $0x8,%esp
8010764f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107652:	50                   	push   %eax
80107653:	6a 00                	push   $0x0
80107655:	e8 e8 f4 ff ff       	call   80106b42 <argstr>
8010765a:	83 c4 10             	add    $0x10,%esp
8010765d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107664:	78 4f                	js     801076b5 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107666:	83 ec 08             	sub    $0x8,%esp
80107669:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010766c:	50                   	push   %eax
8010766d:	6a 01                	push   $0x1
8010766f:	e8 49 f4 ff ff       	call   80106abd <argint>
80107674:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107677:	85 c0                	test   %eax,%eax
80107679:	78 3a                	js     801076b5 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010767b:	83 ec 08             	sub    $0x8,%esp
8010767e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107681:	50                   	push   %eax
80107682:	6a 02                	push   $0x2
80107684:	e8 34 f4 ff ff       	call   80106abd <argint>
80107689:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010768c:	85 c0                	test   %eax,%eax
8010768e:	78 25                	js     801076b5 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107693:	0f bf c8             	movswl %ax,%ecx
80107696:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107699:	0f bf d0             	movswl %ax,%edx
8010769c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010769f:	51                   	push   %ecx
801076a0:	52                   	push   %edx
801076a1:	6a 03                	push   $0x3
801076a3:	50                   	push   %eax
801076a4:	e8 c8 fb ff ff       	call   80107271 <create>
801076a9:	83 c4 10             	add    $0x10,%esp
801076ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076b3:	75 0c                	jne    801076c1 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801076b5:	e8 79 c2 ff ff       	call   80103933 <end_op>
    return -1;
801076ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076bf:	eb 18                	jmp    801076d9 <sys_mknod+0x98>
  }
  iunlockput(ip);
801076c1:	83 ec 0c             	sub    $0xc,%esp
801076c4:	ff 75 f0             	pushl  -0x10(%ebp)
801076c7:	e8 17 a7 ff ff       	call   80101de3 <iunlockput>
801076cc:	83 c4 10             	add    $0x10,%esp
  end_op();
801076cf:	e8 5f c2 ff ff       	call   80103933 <end_op>
  return 0;
801076d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076d9:	c9                   	leave  
801076da:	c3                   	ret    

801076db <sys_chdir>:

int
sys_chdir(void)
{
801076db:	55                   	push   %ebp
801076dc:	89 e5                	mov    %esp,%ebp
801076de:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801076e1:	e8 c1 c1 ff ff       	call   801038a7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801076e6:	83 ec 08             	sub    $0x8,%esp
801076e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801076ec:	50                   	push   %eax
801076ed:	6a 00                	push   $0x0
801076ef:	e8 4e f4 ff ff       	call   80106b42 <argstr>
801076f4:	83 c4 10             	add    $0x10,%esp
801076f7:	85 c0                	test   %eax,%eax
801076f9:	78 18                	js     80107713 <sys_chdir+0x38>
801076fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076fe:	83 ec 0c             	sub    $0xc,%esp
80107701:	50                   	push   %eax
80107702:	e8 02 b0 ff ff       	call   80102709 <namei>
80107707:	83 c4 10             	add    $0x10,%esp
8010770a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010770d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107711:	75 0c                	jne    8010771f <sys_chdir+0x44>
    end_op();
80107713:	e8 1b c2 ff ff       	call   80103933 <end_op>
    return -1;
80107718:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010771d:	eb 6e                	jmp    8010778d <sys_chdir+0xb2>
  }
  ilock(ip);
8010771f:	83 ec 0c             	sub    $0xc,%esp
80107722:	ff 75 f4             	pushl  -0xc(%ebp)
80107725:	e8 d1 a3 ff ff       	call   80101afb <ilock>
8010772a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010772d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107730:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107734:	66 83 f8 01          	cmp    $0x1,%ax
80107738:	74 1a                	je     80107754 <sys_chdir+0x79>
    iunlockput(ip);
8010773a:	83 ec 0c             	sub    $0xc,%esp
8010773d:	ff 75 f4             	pushl  -0xc(%ebp)
80107740:	e8 9e a6 ff ff       	call   80101de3 <iunlockput>
80107745:	83 c4 10             	add    $0x10,%esp
    end_op();
80107748:	e8 e6 c1 ff ff       	call   80103933 <end_op>
    return -1;
8010774d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107752:	eb 39                	jmp    8010778d <sys_chdir+0xb2>
  }
  iunlock(ip);
80107754:	83 ec 0c             	sub    $0xc,%esp
80107757:	ff 75 f4             	pushl  -0xc(%ebp)
8010775a:	e8 22 a5 ff ff       	call   80101c81 <iunlock>
8010775f:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107762:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107768:	8b 40 68             	mov    0x68(%eax),%eax
8010776b:	83 ec 0c             	sub    $0xc,%esp
8010776e:	50                   	push   %eax
8010776f:	e8 7f a5 ff ff       	call   80101cf3 <iput>
80107774:	83 c4 10             	add    $0x10,%esp
  end_op();
80107777:	e8 b7 c1 ff ff       	call   80103933 <end_op>
  proc->cwd = ip;
8010777c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107782:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107785:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107788:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010778d:	c9                   	leave  
8010778e:	c3                   	ret    

8010778f <sys_exec>:

int
sys_exec(void)
{
8010778f:	55                   	push   %ebp
80107790:	89 e5                	mov    %esp,%ebp
80107792:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107798:	83 ec 08             	sub    $0x8,%esp
8010779b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010779e:	50                   	push   %eax
8010779f:	6a 00                	push   $0x0
801077a1:	e8 9c f3 ff ff       	call   80106b42 <argstr>
801077a6:	83 c4 10             	add    $0x10,%esp
801077a9:	85 c0                	test   %eax,%eax
801077ab:	78 18                	js     801077c5 <sys_exec+0x36>
801077ad:	83 ec 08             	sub    $0x8,%esp
801077b0:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801077b6:	50                   	push   %eax
801077b7:	6a 01                	push   $0x1
801077b9:	e8 ff f2 ff ff       	call   80106abd <argint>
801077be:	83 c4 10             	add    $0x10,%esp
801077c1:	85 c0                	test   %eax,%eax
801077c3:	79 0a                	jns    801077cf <sys_exec+0x40>
    return -1;
801077c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077ca:	e9 c6 00 00 00       	jmp    80107895 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801077cf:	83 ec 04             	sub    $0x4,%esp
801077d2:	68 80 00 00 00       	push   $0x80
801077d7:	6a 00                	push   $0x0
801077d9:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801077df:	50                   	push   %eax
801077e0:	e8 b3 ef ff ff       	call   80106798 <memset>
801077e5:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801077e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801077ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f2:	83 f8 1f             	cmp    $0x1f,%eax
801077f5:	76 0a                	jbe    80107801 <sys_exec+0x72>
      return -1;
801077f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077fc:	e9 94 00 00 00       	jmp    80107895 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107801:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107804:	c1 e0 02             	shl    $0x2,%eax
80107807:	89 c2                	mov    %eax,%edx
80107809:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010780f:	01 c2                	add    %eax,%edx
80107811:	83 ec 08             	sub    $0x8,%esp
80107814:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010781a:	50                   	push   %eax
8010781b:	52                   	push   %edx
8010781c:	e8 00 f2 ff ff       	call   80106a21 <fetchint>
80107821:	83 c4 10             	add    $0x10,%esp
80107824:	85 c0                	test   %eax,%eax
80107826:	79 07                	jns    8010782f <sys_exec+0xa0>
      return -1;
80107828:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010782d:	eb 66                	jmp    80107895 <sys_exec+0x106>
    if(uarg == 0){
8010782f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107835:	85 c0                	test   %eax,%eax
80107837:	75 27                	jne    80107860 <sys_exec+0xd1>
      argv[i] = 0;
80107839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783c:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107843:	00 00 00 00 
      break;
80107847:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010784b:	83 ec 08             	sub    $0x8,%esp
8010784e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107854:	52                   	push   %edx
80107855:	50                   	push   %eax
80107856:	e8 bb 93 ff ff       	call   80100c16 <exec>
8010785b:	83 c4 10             	add    $0x10,%esp
8010785e:	eb 35                	jmp    80107895 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107860:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107866:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107869:	c1 e2 02             	shl    $0x2,%edx
8010786c:	01 c2                	add    %eax,%edx
8010786e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107874:	83 ec 08             	sub    $0x8,%esp
80107877:	52                   	push   %edx
80107878:	50                   	push   %eax
80107879:	e8 dd f1 ff ff       	call   80106a5b <fetchstr>
8010787e:	83 c4 10             	add    $0x10,%esp
80107881:	85 c0                	test   %eax,%eax
80107883:	79 07                	jns    8010788c <sys_exec+0xfd>
      return -1;
80107885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010788a:	eb 09                	jmp    80107895 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
8010788c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107890:	e9 5a ff ff ff       	jmp    801077ef <sys_exec+0x60>
  return exec(path, argv);
}
80107895:	c9                   	leave  
80107896:	c3                   	ret    

80107897 <sys_pipe>:

int
sys_pipe(void)
{
80107897:	55                   	push   %ebp
80107898:	89 e5                	mov    %esp,%ebp
8010789a:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010789d:	83 ec 04             	sub    $0x4,%esp
801078a0:	6a 08                	push   $0x8
801078a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801078a5:	50                   	push   %eax
801078a6:	6a 00                	push   $0x0
801078a8:	e8 38 f2 ff ff       	call   80106ae5 <argptr>
801078ad:	83 c4 10             	add    $0x10,%esp
801078b0:	85 c0                	test   %eax,%eax
801078b2:	79 0a                	jns    801078be <sys_pipe+0x27>
    return -1;
801078b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078b9:	e9 af 00 00 00       	jmp    8010796d <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801078be:	83 ec 08             	sub    $0x8,%esp
801078c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801078c4:	50                   	push   %eax
801078c5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801078c8:	50                   	push   %eax
801078c9:	e8 cd ca ff ff       	call   8010439b <pipealloc>
801078ce:	83 c4 10             	add    $0x10,%esp
801078d1:	85 c0                	test   %eax,%eax
801078d3:	79 0a                	jns    801078df <sys_pipe+0x48>
    return -1;
801078d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078da:	e9 8e 00 00 00       	jmp    8010796d <sys_pipe+0xd6>
  fd0 = -1;
801078df:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801078e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	50                   	push   %eax
801078ed:	e8 7c f3 ff ff       	call   80106c6e <fdalloc>
801078f2:	83 c4 10             	add    $0x10,%esp
801078f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801078f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801078fc:	78 18                	js     80107916 <sys_pipe+0x7f>
801078fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107901:	83 ec 0c             	sub    $0xc,%esp
80107904:	50                   	push   %eax
80107905:	e8 64 f3 ff ff       	call   80106c6e <fdalloc>
8010790a:	83 c4 10             	add    $0x10,%esp
8010790d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107910:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107914:	79 3f                	jns    80107955 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010791a:	78 14                	js     80107930 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010791c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107922:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107925:	83 c2 08             	add    $0x8,%edx
80107928:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010792f:	00 
    fileclose(rf);
80107930:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107933:	83 ec 0c             	sub    $0xc,%esp
80107936:	50                   	push   %eax
80107937:	e8 62 98 ff ff       	call   8010119e <fileclose>
8010793c:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010793f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107942:	83 ec 0c             	sub    $0xc,%esp
80107945:	50                   	push   %eax
80107946:	e8 53 98 ff ff       	call   8010119e <fileclose>
8010794b:	83 c4 10             	add    $0x10,%esp
    return -1;
8010794e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107953:	eb 18                	jmp    8010796d <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107955:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107958:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010795b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010795d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107960:	8d 50 04             	lea    0x4(%eax),%edx
80107963:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107966:	89 02                	mov    %eax,(%edx)
  return 0;
80107968:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010796d:	c9                   	leave  
8010796e:	c3                   	ret    

8010796f <sys_chmod>:

int 
sys_chmod(){
8010796f:	55                   	push   %ebp
80107970:	89 e5                	mov    %esp,%ebp
80107972:	83 ec 18             	sub    $0x18,%esp
  char *pathname;
  int mode;
  // double check what you fetch from the stack
  if(argstr(0, &pathname) < 0 || argint(1, (int*)&mode) < 0){
80107975:	83 ec 08             	sub    $0x8,%esp
80107978:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010797b:	50                   	push   %eax
8010797c:	6a 00                	push   $0x0
8010797e:	e8 bf f1 ff ff       	call   80106b42 <argstr>
80107983:	83 c4 10             	add    $0x10,%esp
80107986:	85 c0                	test   %eax,%eax
80107988:	78 15                	js     8010799f <sys_chmod+0x30>
8010798a:	83 ec 08             	sub    $0x8,%esp
8010798d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107990:	50                   	push   %eax
80107991:	6a 01                	push   $0x1
80107993:	e8 25 f1 ff ff       	call   80106abd <argint>
80107998:	83 c4 10             	add    $0x10,%esp
8010799b:	85 c0                	test   %eax,%eax
8010799d:	79 07                	jns    801079a6 <sys_chmod+0x37>
    return -1;
8010799f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079a4:	eb 2b                	jmp    801079d1 <sys_chmod+0x62>
  }
  if(0 > mode || mode > 1023){
801079a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079a9:	85 c0                	test   %eax,%eax
801079ab:	78 0a                	js     801079b7 <sys_chmod+0x48>
801079ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079b0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
801079b5:	7e 07                	jle    801079be <sys_chmod+0x4f>
    return -1;
801079b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079bc:	eb 13                	jmp    801079d1 <sys_chmod+0x62>
  }
  //cprintf("%s %d\n", pathname, mode);
  return chmod(pathname, mode);
801079be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801079c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c4:	83 ec 08             	sub    $0x8,%esp
801079c7:	52                   	push   %edx
801079c8:	50                   	push   %eax
801079c9:	e8 72 ad ff ff       	call   80102740 <chmod>
801079ce:	83 c4 10             	add    $0x10,%esp
}
801079d1:	c9                   	leave  
801079d2:	c3                   	ret    

801079d3 <sys_chown>:

int 
sys_chown(){
801079d3:	55                   	push   %ebp
801079d4:	89 e5                	mov    %esp,%ebp
801079d6:	83 ec 18             	sub    $0x18,%esp
  char *pathname;
  int owner;
  // double check what you fetch from the stack
  if(argstr(0, &pathname) < 0 || argint(1, (int*)&owner) < 0){
801079d9:	83 ec 08             	sub    $0x8,%esp
801079dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079df:	50                   	push   %eax
801079e0:	6a 00                	push   $0x0
801079e2:	e8 5b f1 ff ff       	call   80106b42 <argstr>
801079e7:	83 c4 10             	add    $0x10,%esp
801079ea:	85 c0                	test   %eax,%eax
801079ec:	78 15                	js     80107a03 <sys_chown+0x30>
801079ee:	83 ec 08             	sub    $0x8,%esp
801079f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801079f4:	50                   	push   %eax
801079f5:	6a 01                	push   $0x1
801079f7:	e8 c1 f0 ff ff       	call   80106abd <argint>
801079fc:	83 c4 10             	add    $0x10,%esp
801079ff:	85 c0                	test   %eax,%eax
80107a01:	79 07                	jns    80107a0a <sys_chown+0x37>
    return -1;
80107a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a08:	eb 2b                	jmp    80107a35 <sys_chown+0x62>
  }
  if(owner < 0 || owner > 32767){
80107a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a0d:	85 c0                	test   %eax,%eax
80107a0f:	78 0a                	js     80107a1b <sys_chown+0x48>
80107a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a14:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107a19:	7e 07                	jle    80107a22 <sys_chown+0x4f>
    return -1;
80107a1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a20:	eb 13                	jmp    80107a35 <sys_chown+0x62>
  }
  return chown(pathname, owner);
80107a22:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a28:	83 ec 08             	sub    $0x8,%esp
80107a2b:	52                   	push   %edx
80107a2c:	50                   	push   %eax
80107a2d:	e8 7b ad ff ff       	call   801027ad <chown>
80107a32:	83 c4 10             	add    $0x10,%esp
}
80107a35:	c9                   	leave  
80107a36:	c3                   	ret    

80107a37 <sys_chgrp>:

int 
sys_chgrp(){
80107a37:	55                   	push   %ebp
80107a38:	89 e5                	mov    %esp,%ebp
80107a3a:	83 ec 18             	sub    $0x18,%esp
  char *pathname;
  int group;
  // double check what you fetch from the stack
  if(argstr(0, &pathname) < 0 || argint(1, (int*)&group) < 0){
80107a3d:	83 ec 08             	sub    $0x8,%esp
80107a40:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107a43:	50                   	push   %eax
80107a44:	6a 00                	push   $0x0
80107a46:	e8 f7 f0 ff ff       	call   80106b42 <argstr>
80107a4b:	83 c4 10             	add    $0x10,%esp
80107a4e:	85 c0                	test   %eax,%eax
80107a50:	78 15                	js     80107a67 <sys_chgrp+0x30>
80107a52:	83 ec 08             	sub    $0x8,%esp
80107a55:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a58:	50                   	push   %eax
80107a59:	6a 01                	push   $0x1
80107a5b:	e8 5d f0 ff ff       	call   80106abd <argint>
80107a60:	83 c4 10             	add    $0x10,%esp
80107a63:	85 c0                	test   %eax,%eax
80107a65:	79 07                	jns    80107a6e <sys_chgrp+0x37>
    return -1;
80107a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a6c:	eb 2b                	jmp    80107a99 <sys_chgrp+0x62>
  }
  if(group < 0 || group > 32767){
80107a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a71:	85 c0                	test   %eax,%eax
80107a73:	78 0a                	js     80107a7f <sys_chgrp+0x48>
80107a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a78:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107a7d:	7e 07                	jle    80107a86 <sys_chgrp+0x4f>
    return -1;
80107a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a84:	eb 13                	jmp    80107a99 <sys_chgrp+0x62>
  }
  return chgrp(pathname, group);
80107a86:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8c:	83 ec 08             	sub    $0x8,%esp
80107a8f:	52                   	push   %edx
80107a90:	50                   	push   %eax
80107a91:	e8 9d ad ff ff       	call   80102833 <chgrp>
80107a96:	83 c4 10             	add    $0x10,%esp
80107a99:	c9                   	leave  
80107a9a:	c3                   	ret    

80107a9b <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107a9b:	55                   	push   %ebp
80107a9c:	89 e5                	mov    %esp,%ebp
80107a9e:	83 ec 08             	sub    $0x8,%esp
80107aa1:	8b 55 08             	mov    0x8(%ebp),%edx
80107aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107aab:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107aaf:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107ab3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ab7:	66 ef                	out    %ax,(%dx)
}
80107ab9:	90                   	nop
80107aba:	c9                   	leave  
80107abb:	c3                   	ret    

80107abc <sys_fork>:
#include "mmu.h"
#include "proc.h"
#include "uproc.h"
int
sys_fork(void)
{
80107abc:	55                   	push   %ebp
80107abd:	89 e5                	mov    %esp,%ebp
80107abf:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107ac2:	e8 c4 d1 ff ff       	call   80104c8b <fork>
}
80107ac7:	c9                   	leave  
80107ac8:	c3                   	ret    

80107ac9 <sys_exit>:

int
sys_exit(void)
{
80107ac9:	55                   	push   %ebp
80107aca:	89 e5                	mov    %esp,%ebp
80107acc:	83 ec 08             	sub    $0x8,%esp
  exit();
80107acf:	e8 17 d4 ff ff       	call   80104eeb <exit>
  return 0;  // not reached
80107ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ad9:	c9                   	leave  
80107ada:	c3                   	ret    

80107adb <sys_wait>:

int
sys_wait(void)
{
80107adb:	55                   	push   %ebp
80107adc:	89 e5                	mov    %esp,%ebp
80107ade:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107ae1:	e8 93 d5 ff ff       	call   80105079 <wait>
}
80107ae6:	c9                   	leave  
80107ae7:	c3                   	ret    

80107ae8 <sys_kill>:

int
sys_kill(void)
{
80107ae8:	55                   	push   %ebp
80107ae9:	89 e5                	mov    %esp,%ebp
80107aeb:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107aee:	83 ec 08             	sub    $0x8,%esp
80107af1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107af4:	50                   	push   %eax
80107af5:	6a 00                	push   $0x0
80107af7:	e8 c1 ef ff ff       	call   80106abd <argint>
80107afc:	83 c4 10             	add    $0x10,%esp
80107aff:	85 c0                	test   %eax,%eax
80107b01:	79 07                	jns    80107b0a <sys_kill+0x22>
    return -1;
80107b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b08:	eb 0f                	jmp    80107b19 <sys_kill+0x31>
  return kill(pid);
80107b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0d:	83 ec 0c             	sub    $0xc,%esp
80107b10:	50                   	push   %eax
80107b11:	e8 b5 dd ff ff       	call   801058cb <kill>
80107b16:	83 c4 10             	add    $0x10,%esp
}
80107b19:	c9                   	leave  
80107b1a:	c3                   	ret    

80107b1b <sys_getpid>:

int
sys_getpid(void)
{
80107b1b:	55                   	push   %ebp
80107b1c:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107b1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b24:	8b 40 10             	mov    0x10(%eax),%eax
}
80107b27:	5d                   	pop    %ebp
80107b28:	c3                   	ret    

80107b29 <sys_sbrk>:

int
sys_sbrk(void)
{
80107b29:	55                   	push   %ebp
80107b2a:	89 e5                	mov    %esp,%ebp
80107b2c:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)// remove this stub once you implement the date() system call.
80107b2f:	83 ec 08             	sub    $0x8,%esp
80107b32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b35:	50                   	push   %eax
80107b36:	6a 00                	push   $0x0
80107b38:	e8 80 ef ff ff       	call   80106abd <argint>
80107b3d:	83 c4 10             	add    $0x10,%esp
80107b40:	85 c0                	test   %eax,%eax
80107b42:	79 07                	jns    80107b4b <sys_sbrk+0x22>
   return -1;
80107b44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b49:	eb 28                	jmp    80107b73 <sys_sbrk+0x4a>
  addr = proc->sz;
80107b4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b51:	8b 00                	mov    (%eax),%eax
80107b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b59:	83 ec 0c             	sub    $0xc,%esp
80107b5c:	50                   	push   %eax
80107b5d:	e8 86 d0 ff ff       	call   80104be8 <growproc>
80107b62:	83 c4 10             	add    $0x10,%esp
80107b65:	85 c0                	test   %eax,%eax
80107b67:	79 07                	jns    80107b70 <sys_sbrk+0x47>
    return -1;
80107b69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b6e:	eb 03                	jmp    80107b73 <sys_sbrk+0x4a>
  return addr;
80107b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107b73:	c9                   	leave  
80107b74:	c3                   	ret    

80107b75 <sys_sleep>:

int
sys_sleep(void)
{
80107b75:	55                   	push   %ebp
80107b76:	89 e5                	mov    %esp,%ebp
80107b78:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107b7b:	83 ec 08             	sub    $0x8,%esp
80107b7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b81:	50                   	push   %eax
80107b82:	6a 00                	push   $0x0
80107b84:	e8 34 ef ff ff       	call   80106abd <argint>
80107b89:	83 c4 10             	add    $0x10,%esp
80107b8c:	85 c0                	test   %eax,%eax
80107b8e:	79 07                	jns    80107b97 <sys_sleep+0x22>
    return -1;
80107b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b95:	eb 44                	jmp    80107bdb <sys_sleep+0x66>
  ticks0 = ticks;
80107b97:	a1 20 79 11 80       	mov    0x80117920,%eax
80107b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107b9f:	eb 26                	jmp    80107bc7 <sys_sleep+0x52>
    if(proc->killed){
80107ba1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ba7:	8b 40 24             	mov    0x24(%eax),%eax
80107baa:	85 c0                	test   %eax,%eax
80107bac:	74 07                	je     80107bb5 <sys_sleep+0x40>
      return -1;
80107bae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bb3:	eb 26                	jmp    80107bdb <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107bb5:	83 ec 08             	sub    $0x8,%esp
80107bb8:	6a 00                	push   $0x0
80107bba:	68 20 79 11 80       	push   $0x80117920
80107bbf:	e8 9f da ff ff       	call   80105663 <sleep>
80107bc4:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107bc7:	a1 20 79 11 80       	mov    0x80117920,%eax
80107bcc:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107bcf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107bd2:	39 d0                	cmp    %edx,%eax
80107bd4:	72 cb                	jb     80107ba1 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107bdb:	c9                   	leave  
80107bdc:	c3                   	ret    

80107bdd <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107bdd:	55                   	push   %ebp
80107bde:	89 e5                	mov    %esp,%ebp
80107be0:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107be3:	a1 20 79 11 80       	mov    0x80117920,%eax
80107be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107bee:	c9                   	leave  
80107bef:	c3                   	ret    

80107bf0 <sys_halt>:

//Turn of the computer
int 
sys_halt(void){
80107bf0:	55                   	push   %ebp
80107bf1:	89 e5                	mov    %esp,%ebp
80107bf3:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107bf6:	83 ec 0c             	sub    $0xc,%esp
80107bf9:	68 c0 a3 10 80       	push   $0x8010a3c0
80107bfe:	e8 c3 87 ff ff       	call   801003c6 <cprintf>
80107c03:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107c06:	83 ec 08             	sub    $0x8,%esp
80107c09:	68 00 20 00 00       	push   $0x2000
80107c0e:	68 04 06 00 00       	push   $0x604
80107c13:	e8 83 fe ff ff       	call   80107a9b <outw>
80107c18:	83 c4 10             	add    $0x10,%esp
  return 0;
80107c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c20:	c9                   	leave  
80107c21:	c3                   	ret    

80107c22 <sys_date>:

// return the date
int 
sys_date(void){
80107c22:	55                   	push   %ebp
80107c23:	89 e5                	mov    %esp,%ebp
80107c25:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;
  if(argptr(0,(void*)&d, sizeof(struct rtcdate)) < 0)
80107c28:	83 ec 04             	sub    $0x4,%esp
80107c2b:	6a 18                	push   $0x18
80107c2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107c30:	50                   	push   %eax
80107c31:	6a 00                	push   $0x0
80107c33:	e8 ad ee ff ff       	call   80106ae5 <argptr>
80107c38:	83 c4 10             	add    $0x10,%esp
80107c3b:	85 c0                	test   %eax,%eax
80107c3d:	79 07                	jns    80107c46 <sys_date+0x24>
    return -1;
80107c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c44:	eb 14                	jmp    80107c5a <sys_date+0x38>
  
  cmostime(d); //d updated
80107c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c49:	83 ec 0c             	sub    $0xc,%esp
80107c4c:	50                   	push   %eax
80107c4d:	e8 d0 b8 ff ff       	call   80103522 <cmostime>
80107c52:	83 c4 10             	add    $0x10,%esp
  
  return 0;
80107c55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c5a:	c9                   	leave  
80107c5b:	c3                   	ret    

80107c5c <sys_getuid>:

uint 
sys_getuid(void){
80107c5c:	55                   	push   %ebp
80107c5d:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80107c5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c65:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}       
80107c6b:	5d                   	pop    %ebp
80107c6c:	c3                   	ret    

80107c6d <sys_getgid>:

uint 
sys_getgid(void){
80107c6d:	55                   	push   %ebp
80107c6e:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80107c70:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c76:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107c7c:	5d                   	pop    %ebp
80107c7d:	c3                   	ret    

80107c7e <sys_getppid>:

uint
sys_getppid(void){
80107c7e:	55                   	push   %ebp
80107c7f:	89 e5                	mov    %esp,%ebp
80107c81:	83 ec 10             	sub    $0x10,%esp
  if(proc->parent)
80107c84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c8a:	8b 40 14             	mov    0x14(%eax),%eax
80107c8d:	85 c0                	test   %eax,%eax
80107c8f:	74 0b                	je     80107c9c <sys_getppid+0x1e>
  return proc->pid;
80107c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c97:	8b 40 10             	mov    0x10(%eax),%eax
80107c9a:	eb 12                	jmp    80107cae <sys_getppid+0x30>
  int parent_id = proc->parent->pid;
80107c9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ca2:	8b 40 14             	mov    0x14(%eax),%eax
80107ca5:	8b 40 10             	mov    0x10(%eax),%eax
80107ca8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return parent_id;
80107cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107cae:	c9                   	leave  
80107caf:	c3                   	ret    

80107cb0 <sys_setuid>:

int 
sys_setuid(void){     
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	83 ec 18             	sub    $0x18,%esp
int uid;
if(argint(0, &uid) < 0)
80107cb6:	83 ec 08             	sub    $0x8,%esp
80107cb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107cbc:	50                   	push   %eax
80107cbd:	6a 00                	push   $0x0
80107cbf:	e8 f9 ed ff ff       	call   80106abd <argint>
80107cc4:	83 c4 10             	add    $0x10,%esp
80107cc7:	85 c0                	test   %eax,%eax
80107cc9:	79 07                	jns    80107cd2 <sys_setuid+0x22>
    return -1;
80107ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cd0:	eb 2c                	jmp    80107cfe <sys_setuid+0x4e>

  if(uid <0 || uid > 32767){
80107cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd5:	85 c0                	test   %eax,%eax
80107cd7:	78 0a                	js     80107ce3 <sys_setuid+0x33>
80107cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdc:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107ce1:	7e 07                	jle    80107cea <sys_setuid+0x3a>
    return -1;
80107ce3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ce8:	eb 14                	jmp    80107cfe <sys_setuid+0x4e>
  }
  proc->uid = uid;
80107cea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cf3:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)

  return 0;
80107cf9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cfe:	c9                   	leave  
80107cff:	c3                   	ret    

80107d00 <sys_setgid>:

int 
sys_setgid(void){
80107d00:	55                   	push   %ebp
80107d01:	89 e5                	mov    %esp,%ebp
80107d03:	83 ec 18             	sub    $0x18,%esp
int gid;
 if(argint(0, &gid) < 0)
80107d06:	83 ec 08             	sub    $0x8,%esp
80107d09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d0c:	50                   	push   %eax
80107d0d:	6a 00                	push   $0x0
80107d0f:	e8 a9 ed ff ff       	call   80106abd <argint>
80107d14:	83 c4 10             	add    $0x10,%esp
80107d17:	85 c0                	test   %eax,%eax
80107d19:	79 07                	jns    80107d22 <sys_setgid+0x22>
    return -1;
80107d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d20:	eb 2c                	jmp    80107d4e <sys_setgid+0x4e>


  if(gid <0 || gid > 32767){
80107d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d25:	85 c0                	test   %eax,%eax
80107d27:	78 0a                	js     80107d33 <sys_setgid+0x33>
80107d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2c:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107d31:	7e 07                	jle    80107d3a <sys_setgid+0x3a>
    return -1;
80107d33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d38:	eb 14                	jmp    80107d4e <sys_setgid+0x4e>
  }

  proc->gid = gid;
80107d3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d43:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  return 0;
80107d49:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d4e:	c9                   	leave  
80107d4f:	c3                   	ret    

80107d50 <sys_getprocs>:

int 
sys_getprocs(void){
80107d50:	55                   	push   %ebp
80107d51:	89 e5                	mov    %esp,%ebp
80107d53:	83 ec 18             	sub    $0x18,%esp
  struct uproc *d;
  int n;
  
  if(argint(0, &n) < 0)
80107d56:	83 ec 08             	sub    $0x8,%esp
80107d59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d5c:	50                   	push   %eax
80107d5d:	6a 00                	push   $0x0
80107d5f:	e8 59 ed ff ff       	call   80106abd <argint>
80107d64:	83 c4 10             	add    $0x10,%esp
80107d67:	85 c0                	test   %eax,%eax
80107d69:	79 07                	jns    80107d72 <sys_getprocs+0x22>
    return -1;
80107d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d70:	eb 31                	jmp    80107da3 <sys_getprocs+0x53>

  if(argptr(1,(void*)&d, sizeof(struct uproc)) < 0)
80107d72:	83 ec 04             	sub    $0x4,%esp
80107d75:	6a 60                	push   $0x60
80107d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d7a:	50                   	push   %eax
80107d7b:	6a 01                	push   $0x1
80107d7d:	e8 63 ed ff ff       	call   80106ae5 <argptr>
80107d82:	83 c4 10             	add    $0x10,%esp
80107d85:	85 c0                	test   %eax,%eax
80107d87:	79 07                	jns    80107d90 <sys_getprocs+0x40>
    return -1;
80107d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d8e:	eb 13                	jmp    80107da3 <sys_getprocs+0x53>
  return getprocs(n, d);
80107d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d93:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107d96:	83 ec 08             	sub    $0x8,%esp
80107d99:	50                   	push   %eax
80107d9a:	52                   	push   %edx
80107d9b:	e8 de dd ff ff       	call   80105b7e <getprocs>
80107da0:	83 c4 10             	add    $0x10,%esp
}
80107da3:	c9                   	leave  
80107da4:	c3                   	ret    

80107da5 <sys_setpriority>:

#ifdef CS333_P3P4

int
sys_setpriority(void){
80107da5:	55                   	push   %ebp
80107da6:	89 e5                	mov    %esp,%ebp
80107da8:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int priority;
  
  if(argint(0, &pid) < 0)
80107dab:	83 ec 08             	sub    $0x8,%esp
80107dae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107db1:	50                   	push   %eax
80107db2:	6a 00                	push   $0x0
80107db4:	e8 04 ed ff ff       	call   80106abd <argint>
80107db9:	83 c4 10             	add    $0x10,%esp
80107dbc:	85 c0                	test   %eax,%eax
80107dbe:	79 07                	jns    80107dc7 <sys_setpriority+0x22>
    return -1;
80107dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dc5:	eb 45                	jmp    80107e0c <sys_setpriority+0x67>
   if(argint(1, &priority) < 0)
80107dc7:	83 ec 08             	sub    $0x8,%esp
80107dca:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107dcd:	50                   	push   %eax
80107dce:	6a 01                	push   $0x1
80107dd0:	e8 e8 ec ff ff       	call   80106abd <argint>
80107dd5:	83 c4 10             	add    $0x10,%esp
80107dd8:	85 c0                	test   %eax,%eax
80107dda:	79 07                	jns    80107de3 <sys_setpriority+0x3e>
    return -1;
80107ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107de1:	eb 29                	jmp    80107e0c <sys_setpriority+0x67>

  if(priority < 0 || priority > MAX){
80107de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107de6:	85 c0                	test   %eax,%eax
80107de8:	78 08                	js     80107df2 <sys_setpriority+0x4d>
80107dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ded:	83 f8 06             	cmp    $0x6,%eax
80107df0:	7e 07                	jle    80107df9 <sys_setpriority+0x54>
    return -1;
80107df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107df7:	eb 13                	jmp    80107e0c <sys_setpriority+0x67>
  }


  return setpriority(pid, priority);
80107df9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dff:	83 ec 08             	sub    $0x8,%esp
80107e02:	52                   	push   %edx
80107e03:	50                   	push   %eax
80107e04:	e8 21 e5 ff ff       	call   8010632a <setpriority>
80107e09:	83 c4 10             	add    $0x10,%esp
}
80107e0c:	c9                   	leave  
80107e0d:	c3                   	ret    

80107e0e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107e0e:	55                   	push   %ebp
80107e0f:	89 e5                	mov    %esp,%ebp
80107e11:	83 ec 08             	sub    $0x8,%esp
80107e14:	8b 55 08             	mov    0x8(%ebp),%edx
80107e17:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e1a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107e1e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e21:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107e25:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e29:	ee                   	out    %al,(%dx)
}
80107e2a:	90                   	nop
80107e2b:	c9                   	leave  
80107e2c:	c3                   	ret    

80107e2d <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107e2d:	55                   	push   %ebp
80107e2e:	89 e5                	mov    %esp,%ebp
80107e30:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107e33:	6a 34                	push   $0x34
80107e35:	6a 43                	push   $0x43
80107e37:	e8 d2 ff ff ff       	call   80107e0e <outb>
80107e3c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
80107e3f:	68 a9 00 00 00       	push   $0xa9
80107e44:	6a 40                	push   $0x40
80107e46:	e8 c3 ff ff ff       	call   80107e0e <outb>
80107e4b:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
80107e4e:	6a 04                	push   $0x4
80107e50:	6a 40                	push   $0x40
80107e52:	e8 b7 ff ff ff       	call   80107e0e <outb>
80107e57:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107e5a:	83 ec 0c             	sub    $0xc,%esp
80107e5d:	6a 00                	push   $0x0
80107e5f:	e8 21 c4 ff ff       	call   80104285 <picenable>
80107e64:	83 c4 10             	add    $0x10,%esp
}
80107e67:	90                   	nop
80107e68:	c9                   	leave  
80107e69:	c3                   	ret    

80107e6a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107e6a:	1e                   	push   %ds
  pushl %es
80107e6b:	06                   	push   %es
  pushl %fs
80107e6c:	0f a0                	push   %fs
  pushl %gs
80107e6e:	0f a8                	push   %gs
  pushal
80107e70:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107e71:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107e75:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107e77:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107e79:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107e7d:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107e7f:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107e81:	54                   	push   %esp
  call trap
80107e82:	e8 ce 01 00 00       	call   80108055 <trap>
  addl $4, %esp
80107e87:	83 c4 04             	add    $0x4,%esp

80107e8a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107e8a:	61                   	popa   
  popl %gs
80107e8b:	0f a9                	pop    %gs
  popl %fs
80107e8d:	0f a1                	pop    %fs
  popl %es
80107e8f:	07                   	pop    %es
  popl %ds
80107e90:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107e91:	83 c4 08             	add    $0x8,%esp
  iret
80107e94:	cf                   	iret   

80107e95 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107e95:	55                   	push   %ebp
80107e96:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107e98:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9b:	f0 ff 00             	lock incl (%eax)
}
80107e9e:	90                   	nop
80107e9f:	5d                   	pop    %ebp
80107ea0:	c3                   	ret    

80107ea1 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107ea1:	55                   	push   %ebp
80107ea2:	89 e5                	mov    %esp,%ebp
80107ea4:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eaa:	83 e8 01             	sub    $0x1,%eax
80107ead:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107eb1:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebb:	c1 e8 10             	shr    $0x10,%eax
80107ebe:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107ec2:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ec5:	0f 01 18             	lidtl  (%eax)
}
80107ec8:	90                   	nop
80107ec9:	c9                   	leave  
80107eca:	c3                   	ret    

80107ecb <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107ecb:	55                   	push   %ebp
80107ecc:	89 e5                	mov    %esp,%ebp
80107ece:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107ed1:	0f 20 d0             	mov    %cr2,%eax
80107ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107eda:	c9                   	leave  
80107edb:	c3                   	ret    

80107edc <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107edc:	55                   	push   %ebp
80107edd:	89 e5                	mov    %esp,%ebp
80107edf:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107ee2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107ee9:	e9 c3 00 00 00       	jmp    80107fb1 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ef1:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80107ef8:	89 c2                	mov    %eax,%edx
80107efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107efd:	66 89 14 c5 20 71 11 	mov    %dx,-0x7fee8ee0(,%eax,8)
80107f04:	80 
80107f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f08:	66 c7 04 c5 22 71 11 	movw   $0x8,-0x7fee8ede(,%eax,8)
80107f0f:	80 08 00 
80107f12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f15:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
80107f1c:	80 
80107f1d:	83 e2 e0             	and    $0xffffffe0,%edx
80107f20:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
80107f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f2a:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
80107f31:	80 
80107f32:	83 e2 1f             	and    $0x1f,%edx
80107f35:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
80107f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f3f:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80107f46:	80 
80107f47:	83 e2 f0             	and    $0xfffffff0,%edx
80107f4a:	83 ca 0e             	or     $0xe,%edx
80107f4d:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80107f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f57:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80107f5e:	80 
80107f5f:	83 e2 ef             	and    $0xffffffef,%edx
80107f62:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80107f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f6c:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80107f73:	80 
80107f74:	83 e2 9f             	and    $0xffffff9f,%edx
80107f77:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80107f7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f81:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80107f88:	80 
80107f89:	83 ca 80             	or     $0xffffff80,%edx
80107f8c:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
80107f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f96:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80107f9d:	c1 e8 10             	shr    $0x10,%eax
80107fa0:	89 c2                	mov    %eax,%edx
80107fa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107fa5:	66 89 14 c5 26 71 11 	mov    %dx,-0x7fee8eda(,%eax,8)
80107fac:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107fad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107fb1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107fb8:	0f 8e 30 ff ff ff    	jle    80107eee <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107fbe:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
80107fc3:	66 a3 20 73 11 80    	mov    %ax,0x80117320
80107fc9:	66 c7 05 22 73 11 80 	movw   $0x8,0x80117322
80107fd0:	08 00 
80107fd2:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80107fd9:	83 e0 e0             	and    $0xffffffe0,%eax
80107fdc:	a2 24 73 11 80       	mov    %al,0x80117324
80107fe1:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80107fe8:	83 e0 1f             	and    $0x1f,%eax
80107feb:	a2 24 73 11 80       	mov    %al,0x80117324
80107ff0:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80107ff7:	83 c8 0f             	or     $0xf,%eax
80107ffa:	a2 25 73 11 80       	mov    %al,0x80117325
80107fff:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108006:	83 e0 ef             	and    $0xffffffef,%eax
80108009:	a2 25 73 11 80       	mov    %al,0x80117325
8010800e:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108015:	83 c8 60             	or     $0x60,%eax
80108018:	a2 25 73 11 80       	mov    %al,0x80117325
8010801d:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108024:	83 c8 80             	or     $0xffffff80,%eax
80108027:	a2 25 73 11 80       	mov    %al,0x80117325
8010802c:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
80108031:	c1 e8 10             	shr    $0x10,%eax
80108034:	66 a3 26 73 11 80    	mov    %ax,0x80117326
  
}
8010803a:	90                   	nop
8010803b:	c9                   	leave  
8010803c:	c3                   	ret    

8010803d <idtinit>:

void
idtinit(void)
{
8010803d:	55                   	push   %ebp
8010803e:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80108040:	68 00 08 00 00       	push   $0x800
80108045:	68 20 71 11 80       	push   $0x80117120
8010804a:	e8 52 fe ff ff       	call   80107ea1 <lidt>
8010804f:	83 c4 08             	add    $0x8,%esp
}
80108052:	90                   	nop
80108053:	c9                   	leave  
80108054:	c3                   	ret    

80108055 <trap>:

void
trap(struct trapframe *tf)
{
80108055:	55                   	push   %ebp
80108056:	89 e5                	mov    %esp,%ebp
80108058:	57                   	push   %edi
80108059:	56                   	push   %esi
8010805a:	53                   	push   %ebx
8010805b:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010805e:	8b 45 08             	mov    0x8(%ebp),%eax
80108061:	8b 40 30             	mov    0x30(%eax),%eax
80108064:	83 f8 40             	cmp    $0x40,%eax
80108067:	75 3e                	jne    801080a7 <trap+0x52>
    if(proc->killed)
80108069:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010806f:	8b 40 24             	mov    0x24(%eax),%eax
80108072:	85 c0                	test   %eax,%eax
80108074:	74 05                	je     8010807b <trap+0x26>
      exit();
80108076:	e8 70 ce ff ff       	call   80104eeb <exit>
    proc->tf = tf;
8010807b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108081:	8b 55 08             	mov    0x8(%ebp),%edx
80108084:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80108087:	e8 e7 ea ff ff       	call   80106b73 <syscall>
    if(proc->killed)
8010808c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108092:	8b 40 24             	mov    0x24(%eax),%eax
80108095:	85 c0                	test   %eax,%eax
80108097:	0f 84 21 02 00 00    	je     801082be <trap+0x269>
      exit();
8010809d:	e8 49 ce ff ff       	call   80104eeb <exit>
    return;
801080a2:	e9 17 02 00 00       	jmp    801082be <trap+0x269>
  }

  switch(tf->trapno){
801080a7:	8b 45 08             	mov    0x8(%ebp),%eax
801080aa:	8b 40 30             	mov    0x30(%eax),%eax
801080ad:	83 e8 20             	sub    $0x20,%eax
801080b0:	83 f8 1f             	cmp    $0x1f,%eax
801080b3:	0f 87 a3 00 00 00    	ja     8010815c <trap+0x107>
801080b9:	8b 04 85 74 a4 10 80 	mov    -0x7fef5b8c(,%eax,4),%eax
801080c0:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801080c2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080c8:	0f b6 00             	movzbl (%eax),%eax
801080cb:	84 c0                	test   %al,%al
801080cd:	75 20                	jne    801080ef <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801080cf:	83 ec 0c             	sub    $0xc,%esp
801080d2:	68 20 79 11 80       	push   $0x80117920
801080d7:	e8 b9 fd ff ff       	call   80107e95 <atom_inc>
801080dc:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
801080df:	83 ec 0c             	sub    $0xc,%esp
801080e2:	68 20 79 11 80       	push   $0x80117920
801080e7:	e8 a8 d7 ff ff       	call   80105894 <wakeup>
801080ec:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801080ef:	e8 8b b2 ff ff       	call   8010337f <lapiceoi>
    break;
801080f4:	e9 1c 01 00 00       	jmp    80108215 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801080f9:	e8 94 aa ff ff       	call   80102b92 <ideintr>
    lapiceoi();
801080fe:	e8 7c b2 ff ff       	call   8010337f <lapiceoi>
    break;
80108103:	e9 0d 01 00 00       	jmp    80108215 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80108108:	e8 74 b0 ff ff       	call   80103181 <kbdintr>
    lapiceoi();
8010810d:	e8 6d b2 ff ff       	call   8010337f <lapiceoi>
    break;
80108112:	e9 fe 00 00 00       	jmp    80108215 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108117:	e8 83 03 00 00       	call   8010849f <uartintr>
    lapiceoi();
8010811c:	e8 5e b2 ff ff       	call   8010337f <lapiceoi>
    break;
80108121:	e9 ef 00 00 00       	jmp    80108215 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108126:	8b 45 08             	mov    0x8(%ebp),%eax
80108129:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010812c:	8b 45 08             	mov    0x8(%ebp),%eax
8010812f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108133:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108136:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010813c:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010813f:	0f b6 c0             	movzbl %al,%eax
80108142:	51                   	push   %ecx
80108143:	52                   	push   %edx
80108144:	50                   	push   %eax
80108145:	68 d4 a3 10 80       	push   $0x8010a3d4
8010814a:	e8 77 82 ff ff       	call   801003c6 <cprintf>
8010814f:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80108152:	e8 28 b2 ff ff       	call   8010337f <lapiceoi>
    break;
80108157:	e9 b9 00 00 00       	jmp    80108215 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010815c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108162:	85 c0                	test   %eax,%eax
80108164:	74 11                	je     80108177 <trap+0x122>
80108166:	8b 45 08             	mov    0x8(%ebp),%eax
80108169:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010816d:	0f b7 c0             	movzwl %ax,%eax
80108170:	83 e0 03             	and    $0x3,%eax
80108173:	85 c0                	test   %eax,%eax
80108175:	75 40                	jne    801081b7 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108177:	e8 4f fd ff ff       	call   80107ecb <rcr2>
8010817c:	89 c3                	mov    %eax,%ebx
8010817e:	8b 45 08             	mov    0x8(%ebp),%eax
80108181:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80108184:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010818a:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010818d:	0f b6 d0             	movzbl %al,%edx
80108190:	8b 45 08             	mov    0x8(%ebp),%eax
80108193:	8b 40 30             	mov    0x30(%eax),%eax
80108196:	83 ec 0c             	sub    $0xc,%esp
80108199:	53                   	push   %ebx
8010819a:	51                   	push   %ecx
8010819b:	52                   	push   %edx
8010819c:	50                   	push   %eax
8010819d:	68 f8 a3 10 80       	push   $0x8010a3f8
801081a2:	e8 1f 82 ff ff       	call   801003c6 <cprintf>
801081a7:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801081aa:	83 ec 0c             	sub    $0xc,%esp
801081ad:	68 2a a4 10 80       	push   $0x8010a42a
801081b2:	e8 af 83 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801081b7:	e8 0f fd ff ff       	call   80107ecb <rcr2>
801081bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801081bf:	8b 45 08             	mov    0x8(%ebp),%eax
801081c2:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801081c5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081cb:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801081ce:	0f b6 d8             	movzbl %al,%ebx
801081d1:	8b 45 08             	mov    0x8(%ebp),%eax
801081d4:	8b 48 34             	mov    0x34(%eax),%ecx
801081d7:	8b 45 08             	mov    0x8(%ebp),%eax
801081da:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801081dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081e3:	8d 78 6c             	lea    0x6c(%eax),%edi
801081e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801081ec:	8b 40 10             	mov    0x10(%eax),%eax
801081ef:	ff 75 e4             	pushl  -0x1c(%ebp)
801081f2:	56                   	push   %esi
801081f3:	53                   	push   %ebx
801081f4:	51                   	push   %ecx
801081f5:	52                   	push   %edx
801081f6:	57                   	push   %edi
801081f7:	50                   	push   %eax
801081f8:	68 30 a4 10 80       	push   $0x8010a430
801081fd:	e8 c4 81 ff ff       	call   801003c6 <cprintf>
80108202:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80108205:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010820b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80108212:	eb 01                	jmp    80108215 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80108214:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108215:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010821b:	85 c0                	test   %eax,%eax
8010821d:	74 24                	je     80108243 <trap+0x1ee>
8010821f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108225:	8b 40 24             	mov    0x24(%eax),%eax
80108228:	85 c0                	test   %eax,%eax
8010822a:	74 17                	je     80108243 <trap+0x1ee>
8010822c:	8b 45 08             	mov    0x8(%ebp),%eax
8010822f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108233:	0f b7 c0             	movzwl %ax,%eax
80108236:	83 e0 03             	and    $0x3,%eax
80108239:	83 f8 03             	cmp    $0x3,%eax
8010823c:	75 05                	jne    80108243 <trap+0x1ee>
    exit();
8010823e:	e8 a8 cc ff ff       	call   80104eeb <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108243:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108249:	85 c0                	test   %eax,%eax
8010824b:	74 41                	je     8010828e <trap+0x239>
8010824d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108253:	8b 40 0c             	mov    0xc(%eax),%eax
80108256:	83 f8 04             	cmp    $0x4,%eax
80108259:	75 33                	jne    8010828e <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010825b:	8b 45 08             	mov    0x8(%ebp),%eax
8010825e:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108261:	83 f8 20             	cmp    $0x20,%eax
80108264:	75 28                	jne    8010828e <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108266:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
8010826c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80108271:	89 c8                	mov    %ecx,%eax
80108273:	f7 e2                	mul    %edx
80108275:	c1 ea 03             	shr    $0x3,%edx
80108278:	89 d0                	mov    %edx,%eax
8010827a:	c1 e0 02             	shl    $0x2,%eax
8010827d:	01 d0                	add    %edx,%eax
8010827f:	01 c0                	add    %eax,%eax
80108281:	29 c1                	sub    %eax,%ecx
80108283:	89 ca                	mov    %ecx,%edx
80108285:	85 d2                	test   %edx,%edx
80108287:	75 05                	jne    8010828e <trap+0x239>
    yield();
80108289:	e8 72 d2 ff ff       	call   80105500 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010828e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108294:	85 c0                	test   %eax,%eax
80108296:	74 27                	je     801082bf <trap+0x26a>
80108298:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010829e:	8b 40 24             	mov    0x24(%eax),%eax
801082a1:	85 c0                	test   %eax,%eax
801082a3:	74 1a                	je     801082bf <trap+0x26a>
801082a5:	8b 45 08             	mov    0x8(%ebp),%eax
801082a8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801082ac:	0f b7 c0             	movzwl %ax,%eax
801082af:	83 e0 03             	and    $0x3,%eax
801082b2:	83 f8 03             	cmp    $0x3,%eax
801082b5:	75 08                	jne    801082bf <trap+0x26a>
    exit();
801082b7:	e8 2f cc ff ff       	call   80104eeb <exit>
801082bc:	eb 01                	jmp    801082bf <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801082be:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801082bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082c2:	5b                   	pop    %ebx
801082c3:	5e                   	pop    %esi
801082c4:	5f                   	pop    %edi
801082c5:	5d                   	pop    %ebp
801082c6:	c3                   	ret    

801082c7 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801082c7:	55                   	push   %ebp
801082c8:	89 e5                	mov    %esp,%ebp
801082ca:	83 ec 14             	sub    $0x14,%esp
801082cd:	8b 45 08             	mov    0x8(%ebp),%eax
801082d0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801082d4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801082d8:	89 c2                	mov    %eax,%edx
801082da:	ec                   	in     (%dx),%al
801082db:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801082de:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801082e2:	c9                   	leave  
801082e3:	c3                   	ret    

801082e4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801082e4:	55                   	push   %ebp
801082e5:	89 e5                	mov    %esp,%ebp
801082e7:	83 ec 08             	sub    $0x8,%esp
801082ea:	8b 55 08             	mov    0x8(%ebp),%edx
801082ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801082f0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801082f4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801082f7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801082fb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801082ff:	ee                   	out    %al,(%dx)
}
80108300:	90                   	nop
80108301:	c9                   	leave  
80108302:	c3                   	ret    

80108303 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80108303:	55                   	push   %ebp
80108304:	89 e5                	mov    %esp,%ebp
80108306:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80108309:	6a 00                	push   $0x0
8010830b:	68 fa 03 00 00       	push   $0x3fa
80108310:	e8 cf ff ff ff       	call   801082e4 <outb>
80108315:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108318:	68 80 00 00 00       	push   $0x80
8010831d:	68 fb 03 00 00       	push   $0x3fb
80108322:	e8 bd ff ff ff       	call   801082e4 <outb>
80108327:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010832a:	6a 0c                	push   $0xc
8010832c:	68 f8 03 00 00       	push   $0x3f8
80108331:	e8 ae ff ff ff       	call   801082e4 <outb>
80108336:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108339:	6a 00                	push   $0x0
8010833b:	68 f9 03 00 00       	push   $0x3f9
80108340:	e8 9f ff ff ff       	call   801082e4 <outb>
80108345:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108348:	6a 03                	push   $0x3
8010834a:	68 fb 03 00 00       	push   $0x3fb
8010834f:	e8 90 ff ff ff       	call   801082e4 <outb>
80108354:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108357:	6a 00                	push   $0x0
80108359:	68 fc 03 00 00       	push   $0x3fc
8010835e:	e8 81 ff ff ff       	call   801082e4 <outb>
80108363:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80108366:	6a 01                	push   $0x1
80108368:	68 f9 03 00 00       	push   $0x3f9
8010836d:	e8 72 ff ff ff       	call   801082e4 <outb>
80108372:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80108375:	68 fd 03 00 00       	push   $0x3fd
8010837a:	e8 48 ff ff ff       	call   801082c7 <inb>
8010837f:	83 c4 04             	add    $0x4,%esp
80108382:	3c ff                	cmp    $0xff,%al
80108384:	74 6e                	je     801083f4 <uartinit+0xf1>
    return;
  uart = 1;
80108386:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
8010838d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108390:	68 fa 03 00 00       	push   $0x3fa
80108395:	e8 2d ff ff ff       	call   801082c7 <inb>
8010839a:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010839d:	68 f8 03 00 00       	push   $0x3f8
801083a2:	e8 20 ff ff ff       	call   801082c7 <inb>
801083a7:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801083aa:	83 ec 0c             	sub    $0xc,%esp
801083ad:	6a 04                	push   $0x4
801083af:	e8 d1 be ff ff       	call   80104285 <picenable>
801083b4:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801083b7:	83 ec 08             	sub    $0x8,%esp
801083ba:	6a 00                	push   $0x0
801083bc:	6a 04                	push   $0x4
801083be:	e8 71 aa ff ff       	call   80102e34 <ioapicenable>
801083c3:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801083c6:	c7 45 f4 f4 a4 10 80 	movl   $0x8010a4f4,-0xc(%ebp)
801083cd:	eb 19                	jmp    801083e8 <uartinit+0xe5>
    uartputc(*p);
801083cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d2:	0f b6 00             	movzbl (%eax),%eax
801083d5:	0f be c0             	movsbl %al,%eax
801083d8:	83 ec 0c             	sub    $0xc,%esp
801083db:	50                   	push   %eax
801083dc:	e8 16 00 00 00       	call   801083f7 <uartputc>
801083e1:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801083e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801083e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083eb:	0f b6 00             	movzbl (%eax),%eax
801083ee:	84 c0                	test   %al,%al
801083f0:	75 dd                	jne    801083cf <uartinit+0xcc>
801083f2:	eb 01                	jmp    801083f5 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801083f4:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801083f5:	c9                   	leave  
801083f6:	c3                   	ret    

801083f7 <uartputc>:

void
uartputc(int c)
{
801083f7:	55                   	push   %ebp
801083f8:	89 e5                	mov    %esp,%ebp
801083fa:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801083fd:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
80108402:	85 c0                	test   %eax,%eax
80108404:	74 53                	je     80108459 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010840d:	eb 11                	jmp    80108420 <uartputc+0x29>
    microdelay(10);
8010840f:	83 ec 0c             	sub    $0xc,%esp
80108412:	6a 0a                	push   $0xa
80108414:	e8 81 af ff ff       	call   8010339a <microdelay>
80108419:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010841c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108420:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108424:	7f 1a                	jg     80108440 <uartputc+0x49>
80108426:	83 ec 0c             	sub    $0xc,%esp
80108429:	68 fd 03 00 00       	push   $0x3fd
8010842e:	e8 94 fe ff ff       	call   801082c7 <inb>
80108433:	83 c4 10             	add    $0x10,%esp
80108436:	0f b6 c0             	movzbl %al,%eax
80108439:	83 e0 20             	and    $0x20,%eax
8010843c:	85 c0                	test   %eax,%eax
8010843e:	74 cf                	je     8010840f <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80108440:	8b 45 08             	mov    0x8(%ebp),%eax
80108443:	0f b6 c0             	movzbl %al,%eax
80108446:	83 ec 08             	sub    $0x8,%esp
80108449:	50                   	push   %eax
8010844a:	68 f8 03 00 00       	push   $0x3f8
8010844f:	e8 90 fe ff ff       	call   801082e4 <outb>
80108454:	83 c4 10             	add    $0x10,%esp
80108457:	eb 01                	jmp    8010845a <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108459:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010845a:	c9                   	leave  
8010845b:	c3                   	ret    

8010845c <uartgetc>:

static int
uartgetc(void)
{
8010845c:	55                   	push   %ebp
8010845d:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010845f:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
80108464:	85 c0                	test   %eax,%eax
80108466:	75 07                	jne    8010846f <uartgetc+0x13>
    return -1;
80108468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010846d:	eb 2e                	jmp    8010849d <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010846f:	68 fd 03 00 00       	push   $0x3fd
80108474:	e8 4e fe ff ff       	call   801082c7 <inb>
80108479:	83 c4 04             	add    $0x4,%esp
8010847c:	0f b6 c0             	movzbl %al,%eax
8010847f:	83 e0 01             	and    $0x1,%eax
80108482:	85 c0                	test   %eax,%eax
80108484:	75 07                	jne    8010848d <uartgetc+0x31>
    return -1;
80108486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010848b:	eb 10                	jmp    8010849d <uartgetc+0x41>
  return inb(COM1+0);
8010848d:	68 f8 03 00 00       	push   $0x3f8
80108492:	e8 30 fe ff ff       	call   801082c7 <inb>
80108497:	83 c4 04             	add    $0x4,%esp
8010849a:	0f b6 c0             	movzbl %al,%eax
}
8010849d:	c9                   	leave  
8010849e:	c3                   	ret    

8010849f <uartintr>:

void
uartintr(void)
{
8010849f:	55                   	push   %ebp
801084a0:	89 e5                	mov    %esp,%ebp
801084a2:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801084a5:	83 ec 0c             	sub    $0xc,%esp
801084a8:	68 5c 84 10 80       	push   $0x8010845c
801084ad:	e8 47 83 ff ff       	call   801007f9 <consoleintr>
801084b2:	83 c4 10             	add    $0x10,%esp
}
801084b5:	90                   	nop
801084b6:	c9                   	leave  
801084b7:	c3                   	ret    

801084b8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801084b8:	6a 00                	push   $0x0
  pushl $0
801084ba:	6a 00                	push   $0x0
  jmp alltraps
801084bc:	e9 a9 f9 ff ff       	jmp    80107e6a <alltraps>

801084c1 <vector1>:
.globl vector1
vector1:
  pushl $0
801084c1:	6a 00                	push   $0x0
  pushl $1
801084c3:	6a 01                	push   $0x1
  jmp alltraps
801084c5:	e9 a0 f9 ff ff       	jmp    80107e6a <alltraps>

801084ca <vector2>:
.globl vector2
vector2:
  pushl $0
801084ca:	6a 00                	push   $0x0
  pushl $2
801084cc:	6a 02                	push   $0x2
  jmp alltraps
801084ce:	e9 97 f9 ff ff       	jmp    80107e6a <alltraps>

801084d3 <vector3>:
.globl vector3
vector3:
  pushl $0
801084d3:	6a 00                	push   $0x0
  pushl $3
801084d5:	6a 03                	push   $0x3
  jmp alltraps
801084d7:	e9 8e f9 ff ff       	jmp    80107e6a <alltraps>

801084dc <vector4>:
.globl vector4
vector4:
  pushl $0
801084dc:	6a 00                	push   $0x0
  pushl $4
801084de:	6a 04                	push   $0x4
  jmp alltraps
801084e0:	e9 85 f9 ff ff       	jmp    80107e6a <alltraps>

801084e5 <vector5>:
.globl vector5
vector5:
  pushl $0
801084e5:	6a 00                	push   $0x0
  pushl $5
801084e7:	6a 05                	push   $0x5
  jmp alltraps
801084e9:	e9 7c f9 ff ff       	jmp    80107e6a <alltraps>

801084ee <vector6>:
.globl vector6
vector6:
  pushl $0
801084ee:	6a 00                	push   $0x0
  pushl $6
801084f0:	6a 06                	push   $0x6
  jmp alltraps
801084f2:	e9 73 f9 ff ff       	jmp    80107e6a <alltraps>

801084f7 <vector7>:
.globl vector7
vector7:
  pushl $0
801084f7:	6a 00                	push   $0x0
  pushl $7
801084f9:	6a 07                	push   $0x7
  jmp alltraps
801084fb:	e9 6a f9 ff ff       	jmp    80107e6a <alltraps>

80108500 <vector8>:
.globl vector8
vector8:
  pushl $8
80108500:	6a 08                	push   $0x8
  jmp alltraps
80108502:	e9 63 f9 ff ff       	jmp    80107e6a <alltraps>

80108507 <vector9>:
.globl vector9
vector9:
  pushl $0
80108507:	6a 00                	push   $0x0
  pushl $9
80108509:	6a 09                	push   $0x9
  jmp alltraps
8010850b:	e9 5a f9 ff ff       	jmp    80107e6a <alltraps>

80108510 <vector10>:
.globl vector10
vector10:
  pushl $10
80108510:	6a 0a                	push   $0xa
  jmp alltraps
80108512:	e9 53 f9 ff ff       	jmp    80107e6a <alltraps>

80108517 <vector11>:
.globl vector11
vector11:
  pushl $11
80108517:	6a 0b                	push   $0xb
  jmp alltraps
80108519:	e9 4c f9 ff ff       	jmp    80107e6a <alltraps>

8010851e <vector12>:
.globl vector12
vector12:
  pushl $12
8010851e:	6a 0c                	push   $0xc
  jmp alltraps
80108520:	e9 45 f9 ff ff       	jmp    80107e6a <alltraps>

80108525 <vector13>:
.globl vector13
vector13:
  pushl $13
80108525:	6a 0d                	push   $0xd
  jmp alltraps
80108527:	e9 3e f9 ff ff       	jmp    80107e6a <alltraps>

8010852c <vector14>:
.globl vector14
vector14:
  pushl $14
8010852c:	6a 0e                	push   $0xe
  jmp alltraps
8010852e:	e9 37 f9 ff ff       	jmp    80107e6a <alltraps>

80108533 <vector15>:
.globl vector15
vector15:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $15
80108535:	6a 0f                	push   $0xf
  jmp alltraps
80108537:	e9 2e f9 ff ff       	jmp    80107e6a <alltraps>

8010853c <vector16>:
.globl vector16
vector16:
  pushl $0
8010853c:	6a 00                	push   $0x0
  pushl $16
8010853e:	6a 10                	push   $0x10
  jmp alltraps
80108540:	e9 25 f9 ff ff       	jmp    80107e6a <alltraps>

80108545 <vector17>:
.globl vector17
vector17:
  pushl $17
80108545:	6a 11                	push   $0x11
  jmp alltraps
80108547:	e9 1e f9 ff ff       	jmp    80107e6a <alltraps>

8010854c <vector18>:
.globl vector18
vector18:
  pushl $0
8010854c:	6a 00                	push   $0x0
  pushl $18
8010854e:	6a 12                	push   $0x12
  jmp alltraps
80108550:	e9 15 f9 ff ff       	jmp    80107e6a <alltraps>

80108555 <vector19>:
.globl vector19
vector19:
  pushl $0
80108555:	6a 00                	push   $0x0
  pushl $19
80108557:	6a 13                	push   $0x13
  jmp alltraps
80108559:	e9 0c f9 ff ff       	jmp    80107e6a <alltraps>

8010855e <vector20>:
.globl vector20
vector20:
  pushl $0
8010855e:	6a 00                	push   $0x0
  pushl $20
80108560:	6a 14                	push   $0x14
  jmp alltraps
80108562:	e9 03 f9 ff ff       	jmp    80107e6a <alltraps>

80108567 <vector21>:
.globl vector21
vector21:
  pushl $0
80108567:	6a 00                	push   $0x0
  pushl $21
80108569:	6a 15                	push   $0x15
  jmp alltraps
8010856b:	e9 fa f8 ff ff       	jmp    80107e6a <alltraps>

80108570 <vector22>:
.globl vector22
vector22:
  pushl $0
80108570:	6a 00                	push   $0x0
  pushl $22
80108572:	6a 16                	push   $0x16
  jmp alltraps
80108574:	e9 f1 f8 ff ff       	jmp    80107e6a <alltraps>

80108579 <vector23>:
.globl vector23
vector23:
  pushl $0
80108579:	6a 00                	push   $0x0
  pushl $23
8010857b:	6a 17                	push   $0x17
  jmp alltraps
8010857d:	e9 e8 f8 ff ff       	jmp    80107e6a <alltraps>

80108582 <vector24>:
.globl vector24
vector24:
  pushl $0
80108582:	6a 00                	push   $0x0
  pushl $24
80108584:	6a 18                	push   $0x18
  jmp alltraps
80108586:	e9 df f8 ff ff       	jmp    80107e6a <alltraps>

8010858b <vector25>:
.globl vector25
vector25:
  pushl $0
8010858b:	6a 00                	push   $0x0
  pushl $25
8010858d:	6a 19                	push   $0x19
  jmp alltraps
8010858f:	e9 d6 f8 ff ff       	jmp    80107e6a <alltraps>

80108594 <vector26>:
.globl vector26
vector26:
  pushl $0
80108594:	6a 00                	push   $0x0
  pushl $26
80108596:	6a 1a                	push   $0x1a
  jmp alltraps
80108598:	e9 cd f8 ff ff       	jmp    80107e6a <alltraps>

8010859d <vector27>:
.globl vector27
vector27:
  pushl $0
8010859d:	6a 00                	push   $0x0
  pushl $27
8010859f:	6a 1b                	push   $0x1b
  jmp alltraps
801085a1:	e9 c4 f8 ff ff       	jmp    80107e6a <alltraps>

801085a6 <vector28>:
.globl vector28
vector28:
  pushl $0
801085a6:	6a 00                	push   $0x0
  pushl $28
801085a8:	6a 1c                	push   $0x1c
  jmp alltraps
801085aa:	e9 bb f8 ff ff       	jmp    80107e6a <alltraps>

801085af <vector29>:
.globl vector29
vector29:
  pushl $0
801085af:	6a 00                	push   $0x0
  pushl $29
801085b1:	6a 1d                	push   $0x1d
  jmp alltraps
801085b3:	e9 b2 f8 ff ff       	jmp    80107e6a <alltraps>

801085b8 <vector30>:
.globl vector30
vector30:
  pushl $0
801085b8:	6a 00                	push   $0x0
  pushl $30
801085ba:	6a 1e                	push   $0x1e
  jmp alltraps
801085bc:	e9 a9 f8 ff ff       	jmp    80107e6a <alltraps>

801085c1 <vector31>:
.globl vector31
vector31:
  pushl $0
801085c1:	6a 00                	push   $0x0
  pushl $31
801085c3:	6a 1f                	push   $0x1f
  jmp alltraps
801085c5:	e9 a0 f8 ff ff       	jmp    80107e6a <alltraps>

801085ca <vector32>:
.globl vector32
vector32:
  pushl $0
801085ca:	6a 00                	push   $0x0
  pushl $32
801085cc:	6a 20                	push   $0x20
  jmp alltraps
801085ce:	e9 97 f8 ff ff       	jmp    80107e6a <alltraps>

801085d3 <vector33>:
.globl vector33
vector33:
  pushl $0
801085d3:	6a 00                	push   $0x0
  pushl $33
801085d5:	6a 21                	push   $0x21
  jmp alltraps
801085d7:	e9 8e f8 ff ff       	jmp    80107e6a <alltraps>

801085dc <vector34>:
.globl vector34
vector34:
  pushl $0
801085dc:	6a 00                	push   $0x0
  pushl $34
801085de:	6a 22                	push   $0x22
  jmp alltraps
801085e0:	e9 85 f8 ff ff       	jmp    80107e6a <alltraps>

801085e5 <vector35>:
.globl vector35
vector35:
  pushl $0
801085e5:	6a 00                	push   $0x0
  pushl $35
801085e7:	6a 23                	push   $0x23
  jmp alltraps
801085e9:	e9 7c f8 ff ff       	jmp    80107e6a <alltraps>

801085ee <vector36>:
.globl vector36
vector36:
  pushl $0
801085ee:	6a 00                	push   $0x0
  pushl $36
801085f0:	6a 24                	push   $0x24
  jmp alltraps
801085f2:	e9 73 f8 ff ff       	jmp    80107e6a <alltraps>

801085f7 <vector37>:
.globl vector37
vector37:
  pushl $0
801085f7:	6a 00                	push   $0x0
  pushl $37
801085f9:	6a 25                	push   $0x25
  jmp alltraps
801085fb:	e9 6a f8 ff ff       	jmp    80107e6a <alltraps>

80108600 <vector38>:
.globl vector38
vector38:
  pushl $0
80108600:	6a 00                	push   $0x0
  pushl $38
80108602:	6a 26                	push   $0x26
  jmp alltraps
80108604:	e9 61 f8 ff ff       	jmp    80107e6a <alltraps>

80108609 <vector39>:
.globl vector39
vector39:
  pushl $0
80108609:	6a 00                	push   $0x0
  pushl $39
8010860b:	6a 27                	push   $0x27
  jmp alltraps
8010860d:	e9 58 f8 ff ff       	jmp    80107e6a <alltraps>

80108612 <vector40>:
.globl vector40
vector40:
  pushl $0
80108612:	6a 00                	push   $0x0
  pushl $40
80108614:	6a 28                	push   $0x28
  jmp alltraps
80108616:	e9 4f f8 ff ff       	jmp    80107e6a <alltraps>

8010861b <vector41>:
.globl vector41
vector41:
  pushl $0
8010861b:	6a 00                	push   $0x0
  pushl $41
8010861d:	6a 29                	push   $0x29
  jmp alltraps
8010861f:	e9 46 f8 ff ff       	jmp    80107e6a <alltraps>

80108624 <vector42>:
.globl vector42
vector42:
  pushl $0
80108624:	6a 00                	push   $0x0
  pushl $42
80108626:	6a 2a                	push   $0x2a
  jmp alltraps
80108628:	e9 3d f8 ff ff       	jmp    80107e6a <alltraps>

8010862d <vector43>:
.globl vector43
vector43:
  pushl $0
8010862d:	6a 00                	push   $0x0
  pushl $43
8010862f:	6a 2b                	push   $0x2b
  jmp alltraps
80108631:	e9 34 f8 ff ff       	jmp    80107e6a <alltraps>

80108636 <vector44>:
.globl vector44
vector44:
  pushl $0
80108636:	6a 00                	push   $0x0
  pushl $44
80108638:	6a 2c                	push   $0x2c
  jmp alltraps
8010863a:	e9 2b f8 ff ff       	jmp    80107e6a <alltraps>

8010863f <vector45>:
.globl vector45
vector45:
  pushl $0
8010863f:	6a 00                	push   $0x0
  pushl $45
80108641:	6a 2d                	push   $0x2d
  jmp alltraps
80108643:	e9 22 f8 ff ff       	jmp    80107e6a <alltraps>

80108648 <vector46>:
.globl vector46
vector46:
  pushl $0
80108648:	6a 00                	push   $0x0
  pushl $46
8010864a:	6a 2e                	push   $0x2e
  jmp alltraps
8010864c:	e9 19 f8 ff ff       	jmp    80107e6a <alltraps>

80108651 <vector47>:
.globl vector47
vector47:
  pushl $0
80108651:	6a 00                	push   $0x0
  pushl $47
80108653:	6a 2f                	push   $0x2f
  jmp alltraps
80108655:	e9 10 f8 ff ff       	jmp    80107e6a <alltraps>

8010865a <vector48>:
.globl vector48
vector48:
  pushl $0
8010865a:	6a 00                	push   $0x0
  pushl $48
8010865c:	6a 30                	push   $0x30
  jmp alltraps
8010865e:	e9 07 f8 ff ff       	jmp    80107e6a <alltraps>

80108663 <vector49>:
.globl vector49
vector49:
  pushl $0
80108663:	6a 00                	push   $0x0
  pushl $49
80108665:	6a 31                	push   $0x31
  jmp alltraps
80108667:	e9 fe f7 ff ff       	jmp    80107e6a <alltraps>

8010866c <vector50>:
.globl vector50
vector50:
  pushl $0
8010866c:	6a 00                	push   $0x0
  pushl $50
8010866e:	6a 32                	push   $0x32
  jmp alltraps
80108670:	e9 f5 f7 ff ff       	jmp    80107e6a <alltraps>

80108675 <vector51>:
.globl vector51
vector51:
  pushl $0
80108675:	6a 00                	push   $0x0
  pushl $51
80108677:	6a 33                	push   $0x33
  jmp alltraps
80108679:	e9 ec f7 ff ff       	jmp    80107e6a <alltraps>

8010867e <vector52>:
.globl vector52
vector52:
  pushl $0
8010867e:	6a 00                	push   $0x0
  pushl $52
80108680:	6a 34                	push   $0x34
  jmp alltraps
80108682:	e9 e3 f7 ff ff       	jmp    80107e6a <alltraps>

80108687 <vector53>:
.globl vector53
vector53:
  pushl $0
80108687:	6a 00                	push   $0x0
  pushl $53
80108689:	6a 35                	push   $0x35
  jmp alltraps
8010868b:	e9 da f7 ff ff       	jmp    80107e6a <alltraps>

80108690 <vector54>:
.globl vector54
vector54:
  pushl $0
80108690:	6a 00                	push   $0x0
  pushl $54
80108692:	6a 36                	push   $0x36
  jmp alltraps
80108694:	e9 d1 f7 ff ff       	jmp    80107e6a <alltraps>

80108699 <vector55>:
.globl vector55
vector55:
  pushl $0
80108699:	6a 00                	push   $0x0
  pushl $55
8010869b:	6a 37                	push   $0x37
  jmp alltraps
8010869d:	e9 c8 f7 ff ff       	jmp    80107e6a <alltraps>

801086a2 <vector56>:
.globl vector56
vector56:
  pushl $0
801086a2:	6a 00                	push   $0x0
  pushl $56
801086a4:	6a 38                	push   $0x38
  jmp alltraps
801086a6:	e9 bf f7 ff ff       	jmp    80107e6a <alltraps>

801086ab <vector57>:
.globl vector57
vector57:
  pushl $0
801086ab:	6a 00                	push   $0x0
  pushl $57
801086ad:	6a 39                	push   $0x39
  jmp alltraps
801086af:	e9 b6 f7 ff ff       	jmp    80107e6a <alltraps>

801086b4 <vector58>:
.globl vector58
vector58:
  pushl $0
801086b4:	6a 00                	push   $0x0
  pushl $58
801086b6:	6a 3a                	push   $0x3a
  jmp alltraps
801086b8:	e9 ad f7 ff ff       	jmp    80107e6a <alltraps>

801086bd <vector59>:
.globl vector59
vector59:
  pushl $0
801086bd:	6a 00                	push   $0x0
  pushl $59
801086bf:	6a 3b                	push   $0x3b
  jmp alltraps
801086c1:	e9 a4 f7 ff ff       	jmp    80107e6a <alltraps>

801086c6 <vector60>:
.globl vector60
vector60:
  pushl $0
801086c6:	6a 00                	push   $0x0
  pushl $60
801086c8:	6a 3c                	push   $0x3c
  jmp alltraps
801086ca:	e9 9b f7 ff ff       	jmp    80107e6a <alltraps>

801086cf <vector61>:
.globl vector61
vector61:
  pushl $0
801086cf:	6a 00                	push   $0x0
  pushl $61
801086d1:	6a 3d                	push   $0x3d
  jmp alltraps
801086d3:	e9 92 f7 ff ff       	jmp    80107e6a <alltraps>

801086d8 <vector62>:
.globl vector62
vector62:
  pushl $0
801086d8:	6a 00                	push   $0x0
  pushl $62
801086da:	6a 3e                	push   $0x3e
  jmp alltraps
801086dc:	e9 89 f7 ff ff       	jmp    80107e6a <alltraps>

801086e1 <vector63>:
.globl vector63
vector63:
  pushl $0
801086e1:	6a 00                	push   $0x0
  pushl $63
801086e3:	6a 3f                	push   $0x3f
  jmp alltraps
801086e5:	e9 80 f7 ff ff       	jmp    80107e6a <alltraps>

801086ea <vector64>:
.globl vector64
vector64:
  pushl $0
801086ea:	6a 00                	push   $0x0
  pushl $64
801086ec:	6a 40                	push   $0x40
  jmp alltraps
801086ee:	e9 77 f7 ff ff       	jmp    80107e6a <alltraps>

801086f3 <vector65>:
.globl vector65
vector65:
  pushl $0
801086f3:	6a 00                	push   $0x0
  pushl $65
801086f5:	6a 41                	push   $0x41
  jmp alltraps
801086f7:	e9 6e f7 ff ff       	jmp    80107e6a <alltraps>

801086fc <vector66>:
.globl vector66
vector66:
  pushl $0
801086fc:	6a 00                	push   $0x0
  pushl $66
801086fe:	6a 42                	push   $0x42
  jmp alltraps
80108700:	e9 65 f7 ff ff       	jmp    80107e6a <alltraps>

80108705 <vector67>:
.globl vector67
vector67:
  pushl $0
80108705:	6a 00                	push   $0x0
  pushl $67
80108707:	6a 43                	push   $0x43
  jmp alltraps
80108709:	e9 5c f7 ff ff       	jmp    80107e6a <alltraps>

8010870e <vector68>:
.globl vector68
vector68:
  pushl $0
8010870e:	6a 00                	push   $0x0
  pushl $68
80108710:	6a 44                	push   $0x44
  jmp alltraps
80108712:	e9 53 f7 ff ff       	jmp    80107e6a <alltraps>

80108717 <vector69>:
.globl vector69
vector69:
  pushl $0
80108717:	6a 00                	push   $0x0
  pushl $69
80108719:	6a 45                	push   $0x45
  jmp alltraps
8010871b:	e9 4a f7 ff ff       	jmp    80107e6a <alltraps>

80108720 <vector70>:
.globl vector70
vector70:
  pushl $0
80108720:	6a 00                	push   $0x0
  pushl $70
80108722:	6a 46                	push   $0x46
  jmp alltraps
80108724:	e9 41 f7 ff ff       	jmp    80107e6a <alltraps>

80108729 <vector71>:
.globl vector71
vector71:
  pushl $0
80108729:	6a 00                	push   $0x0
  pushl $71
8010872b:	6a 47                	push   $0x47
  jmp alltraps
8010872d:	e9 38 f7 ff ff       	jmp    80107e6a <alltraps>

80108732 <vector72>:
.globl vector72
vector72:
  pushl $0
80108732:	6a 00                	push   $0x0
  pushl $72
80108734:	6a 48                	push   $0x48
  jmp alltraps
80108736:	e9 2f f7 ff ff       	jmp    80107e6a <alltraps>

8010873b <vector73>:
.globl vector73
vector73:
  pushl $0
8010873b:	6a 00                	push   $0x0
  pushl $73
8010873d:	6a 49                	push   $0x49
  jmp alltraps
8010873f:	e9 26 f7 ff ff       	jmp    80107e6a <alltraps>

80108744 <vector74>:
.globl vector74
vector74:
  pushl $0
80108744:	6a 00                	push   $0x0
  pushl $74
80108746:	6a 4a                	push   $0x4a
  jmp alltraps
80108748:	e9 1d f7 ff ff       	jmp    80107e6a <alltraps>

8010874d <vector75>:
.globl vector75
vector75:
  pushl $0
8010874d:	6a 00                	push   $0x0
  pushl $75
8010874f:	6a 4b                	push   $0x4b
  jmp alltraps
80108751:	e9 14 f7 ff ff       	jmp    80107e6a <alltraps>

80108756 <vector76>:
.globl vector76
vector76:
  pushl $0
80108756:	6a 00                	push   $0x0
  pushl $76
80108758:	6a 4c                	push   $0x4c
  jmp alltraps
8010875a:	e9 0b f7 ff ff       	jmp    80107e6a <alltraps>

8010875f <vector77>:
.globl vector77
vector77:
  pushl $0
8010875f:	6a 00                	push   $0x0
  pushl $77
80108761:	6a 4d                	push   $0x4d
  jmp alltraps
80108763:	e9 02 f7 ff ff       	jmp    80107e6a <alltraps>

80108768 <vector78>:
.globl vector78
vector78:
  pushl $0
80108768:	6a 00                	push   $0x0
  pushl $78
8010876a:	6a 4e                	push   $0x4e
  jmp alltraps
8010876c:	e9 f9 f6 ff ff       	jmp    80107e6a <alltraps>

80108771 <vector79>:
.globl vector79
vector79:
  pushl $0
80108771:	6a 00                	push   $0x0
  pushl $79
80108773:	6a 4f                	push   $0x4f
  jmp alltraps
80108775:	e9 f0 f6 ff ff       	jmp    80107e6a <alltraps>

8010877a <vector80>:
.globl vector80
vector80:
  pushl $0
8010877a:	6a 00                	push   $0x0
  pushl $80
8010877c:	6a 50                	push   $0x50
  jmp alltraps
8010877e:	e9 e7 f6 ff ff       	jmp    80107e6a <alltraps>

80108783 <vector81>:
.globl vector81
vector81:
  pushl $0
80108783:	6a 00                	push   $0x0
  pushl $81
80108785:	6a 51                	push   $0x51
  jmp alltraps
80108787:	e9 de f6 ff ff       	jmp    80107e6a <alltraps>

8010878c <vector82>:
.globl vector82
vector82:
  pushl $0
8010878c:	6a 00                	push   $0x0
  pushl $82
8010878e:	6a 52                	push   $0x52
  jmp alltraps
80108790:	e9 d5 f6 ff ff       	jmp    80107e6a <alltraps>

80108795 <vector83>:
.globl vector83
vector83:
  pushl $0
80108795:	6a 00                	push   $0x0
  pushl $83
80108797:	6a 53                	push   $0x53
  jmp alltraps
80108799:	e9 cc f6 ff ff       	jmp    80107e6a <alltraps>

8010879e <vector84>:
.globl vector84
vector84:
  pushl $0
8010879e:	6a 00                	push   $0x0
  pushl $84
801087a0:	6a 54                	push   $0x54
  jmp alltraps
801087a2:	e9 c3 f6 ff ff       	jmp    80107e6a <alltraps>

801087a7 <vector85>:
.globl vector85
vector85:
  pushl $0
801087a7:	6a 00                	push   $0x0
  pushl $85
801087a9:	6a 55                	push   $0x55
  jmp alltraps
801087ab:	e9 ba f6 ff ff       	jmp    80107e6a <alltraps>

801087b0 <vector86>:
.globl vector86
vector86:
  pushl $0
801087b0:	6a 00                	push   $0x0
  pushl $86
801087b2:	6a 56                	push   $0x56
  jmp alltraps
801087b4:	e9 b1 f6 ff ff       	jmp    80107e6a <alltraps>

801087b9 <vector87>:
.globl vector87
vector87:
  pushl $0
801087b9:	6a 00                	push   $0x0
  pushl $87
801087bb:	6a 57                	push   $0x57
  jmp alltraps
801087bd:	e9 a8 f6 ff ff       	jmp    80107e6a <alltraps>

801087c2 <vector88>:
.globl vector88
vector88:
  pushl $0
801087c2:	6a 00                	push   $0x0
  pushl $88
801087c4:	6a 58                	push   $0x58
  jmp alltraps
801087c6:	e9 9f f6 ff ff       	jmp    80107e6a <alltraps>

801087cb <vector89>:
.globl vector89
vector89:
  pushl $0
801087cb:	6a 00                	push   $0x0
  pushl $89
801087cd:	6a 59                	push   $0x59
  jmp alltraps
801087cf:	e9 96 f6 ff ff       	jmp    80107e6a <alltraps>

801087d4 <vector90>:
.globl vector90
vector90:
  pushl $0
801087d4:	6a 00                	push   $0x0
  pushl $90
801087d6:	6a 5a                	push   $0x5a
  jmp alltraps
801087d8:	e9 8d f6 ff ff       	jmp    80107e6a <alltraps>

801087dd <vector91>:
.globl vector91
vector91:
  pushl $0
801087dd:	6a 00                	push   $0x0
  pushl $91
801087df:	6a 5b                	push   $0x5b
  jmp alltraps
801087e1:	e9 84 f6 ff ff       	jmp    80107e6a <alltraps>

801087e6 <vector92>:
.globl vector92
vector92:
  pushl $0
801087e6:	6a 00                	push   $0x0
  pushl $92
801087e8:	6a 5c                	push   $0x5c
  jmp alltraps
801087ea:	e9 7b f6 ff ff       	jmp    80107e6a <alltraps>

801087ef <vector93>:
.globl vector93
vector93:
  pushl $0
801087ef:	6a 00                	push   $0x0
  pushl $93
801087f1:	6a 5d                	push   $0x5d
  jmp alltraps
801087f3:	e9 72 f6 ff ff       	jmp    80107e6a <alltraps>

801087f8 <vector94>:
.globl vector94
vector94:
  pushl $0
801087f8:	6a 00                	push   $0x0
  pushl $94
801087fa:	6a 5e                	push   $0x5e
  jmp alltraps
801087fc:	e9 69 f6 ff ff       	jmp    80107e6a <alltraps>

80108801 <vector95>:
.globl vector95
vector95:
  pushl $0
80108801:	6a 00                	push   $0x0
  pushl $95
80108803:	6a 5f                	push   $0x5f
  jmp alltraps
80108805:	e9 60 f6 ff ff       	jmp    80107e6a <alltraps>

8010880a <vector96>:
.globl vector96
vector96:
  pushl $0
8010880a:	6a 00                	push   $0x0
  pushl $96
8010880c:	6a 60                	push   $0x60
  jmp alltraps
8010880e:	e9 57 f6 ff ff       	jmp    80107e6a <alltraps>

80108813 <vector97>:
.globl vector97
vector97:
  pushl $0
80108813:	6a 00                	push   $0x0
  pushl $97
80108815:	6a 61                	push   $0x61
  jmp alltraps
80108817:	e9 4e f6 ff ff       	jmp    80107e6a <alltraps>

8010881c <vector98>:
.globl vector98
vector98:
  pushl $0
8010881c:	6a 00                	push   $0x0
  pushl $98
8010881e:	6a 62                	push   $0x62
  jmp alltraps
80108820:	e9 45 f6 ff ff       	jmp    80107e6a <alltraps>

80108825 <vector99>:
.globl vector99
vector99:
  pushl $0
80108825:	6a 00                	push   $0x0
  pushl $99
80108827:	6a 63                	push   $0x63
  jmp alltraps
80108829:	e9 3c f6 ff ff       	jmp    80107e6a <alltraps>

8010882e <vector100>:
.globl vector100
vector100:
  pushl $0
8010882e:	6a 00                	push   $0x0
  pushl $100
80108830:	6a 64                	push   $0x64
  jmp alltraps
80108832:	e9 33 f6 ff ff       	jmp    80107e6a <alltraps>

80108837 <vector101>:
.globl vector101
vector101:
  pushl $0
80108837:	6a 00                	push   $0x0
  pushl $101
80108839:	6a 65                	push   $0x65
  jmp alltraps
8010883b:	e9 2a f6 ff ff       	jmp    80107e6a <alltraps>

80108840 <vector102>:
.globl vector102
vector102:
  pushl $0
80108840:	6a 00                	push   $0x0
  pushl $102
80108842:	6a 66                	push   $0x66
  jmp alltraps
80108844:	e9 21 f6 ff ff       	jmp    80107e6a <alltraps>

80108849 <vector103>:
.globl vector103
vector103:
  pushl $0
80108849:	6a 00                	push   $0x0
  pushl $103
8010884b:	6a 67                	push   $0x67
  jmp alltraps
8010884d:	e9 18 f6 ff ff       	jmp    80107e6a <alltraps>

80108852 <vector104>:
.globl vector104
vector104:
  pushl $0
80108852:	6a 00                	push   $0x0
  pushl $104
80108854:	6a 68                	push   $0x68
  jmp alltraps
80108856:	e9 0f f6 ff ff       	jmp    80107e6a <alltraps>

8010885b <vector105>:
.globl vector105
vector105:
  pushl $0
8010885b:	6a 00                	push   $0x0
  pushl $105
8010885d:	6a 69                	push   $0x69
  jmp alltraps
8010885f:	e9 06 f6 ff ff       	jmp    80107e6a <alltraps>

80108864 <vector106>:
.globl vector106
vector106:
  pushl $0
80108864:	6a 00                	push   $0x0
  pushl $106
80108866:	6a 6a                	push   $0x6a
  jmp alltraps
80108868:	e9 fd f5 ff ff       	jmp    80107e6a <alltraps>

8010886d <vector107>:
.globl vector107
vector107:
  pushl $0
8010886d:	6a 00                	push   $0x0
  pushl $107
8010886f:	6a 6b                	push   $0x6b
  jmp alltraps
80108871:	e9 f4 f5 ff ff       	jmp    80107e6a <alltraps>

80108876 <vector108>:
.globl vector108
vector108:
  pushl $0
80108876:	6a 00                	push   $0x0
  pushl $108
80108878:	6a 6c                	push   $0x6c
  jmp alltraps
8010887a:	e9 eb f5 ff ff       	jmp    80107e6a <alltraps>

8010887f <vector109>:
.globl vector109
vector109:
  pushl $0
8010887f:	6a 00                	push   $0x0
  pushl $109
80108881:	6a 6d                	push   $0x6d
  jmp alltraps
80108883:	e9 e2 f5 ff ff       	jmp    80107e6a <alltraps>

80108888 <vector110>:
.globl vector110
vector110:
  pushl $0
80108888:	6a 00                	push   $0x0
  pushl $110
8010888a:	6a 6e                	push   $0x6e
  jmp alltraps
8010888c:	e9 d9 f5 ff ff       	jmp    80107e6a <alltraps>

80108891 <vector111>:
.globl vector111
vector111:
  pushl $0
80108891:	6a 00                	push   $0x0
  pushl $111
80108893:	6a 6f                	push   $0x6f
  jmp alltraps
80108895:	e9 d0 f5 ff ff       	jmp    80107e6a <alltraps>

8010889a <vector112>:
.globl vector112
vector112:
  pushl $0
8010889a:	6a 00                	push   $0x0
  pushl $112
8010889c:	6a 70                	push   $0x70
  jmp alltraps
8010889e:	e9 c7 f5 ff ff       	jmp    80107e6a <alltraps>

801088a3 <vector113>:
.globl vector113
vector113:
  pushl $0
801088a3:	6a 00                	push   $0x0
  pushl $113
801088a5:	6a 71                	push   $0x71
  jmp alltraps
801088a7:	e9 be f5 ff ff       	jmp    80107e6a <alltraps>

801088ac <vector114>:
.globl vector114
vector114:
  pushl $0
801088ac:	6a 00                	push   $0x0
  pushl $114
801088ae:	6a 72                	push   $0x72
  jmp alltraps
801088b0:	e9 b5 f5 ff ff       	jmp    80107e6a <alltraps>

801088b5 <vector115>:
.globl vector115
vector115:
  pushl $0
801088b5:	6a 00                	push   $0x0
  pushl $115
801088b7:	6a 73                	push   $0x73
  jmp alltraps
801088b9:	e9 ac f5 ff ff       	jmp    80107e6a <alltraps>

801088be <vector116>:
.globl vector116
vector116:
  pushl $0
801088be:	6a 00                	push   $0x0
  pushl $116
801088c0:	6a 74                	push   $0x74
  jmp alltraps
801088c2:	e9 a3 f5 ff ff       	jmp    80107e6a <alltraps>

801088c7 <vector117>:
.globl vector117
vector117:
  pushl $0
801088c7:	6a 00                	push   $0x0
  pushl $117
801088c9:	6a 75                	push   $0x75
  jmp alltraps
801088cb:	e9 9a f5 ff ff       	jmp    80107e6a <alltraps>

801088d0 <vector118>:
.globl vector118
vector118:
  pushl $0
801088d0:	6a 00                	push   $0x0
  pushl $118
801088d2:	6a 76                	push   $0x76
  jmp alltraps
801088d4:	e9 91 f5 ff ff       	jmp    80107e6a <alltraps>

801088d9 <vector119>:
.globl vector119
vector119:
  pushl $0
801088d9:	6a 00                	push   $0x0
  pushl $119
801088db:	6a 77                	push   $0x77
  jmp alltraps
801088dd:	e9 88 f5 ff ff       	jmp    80107e6a <alltraps>

801088e2 <vector120>:
.globl vector120
vector120:
  pushl $0
801088e2:	6a 00                	push   $0x0
  pushl $120
801088e4:	6a 78                	push   $0x78
  jmp alltraps
801088e6:	e9 7f f5 ff ff       	jmp    80107e6a <alltraps>

801088eb <vector121>:
.globl vector121
vector121:
  pushl $0
801088eb:	6a 00                	push   $0x0
  pushl $121
801088ed:	6a 79                	push   $0x79
  jmp alltraps
801088ef:	e9 76 f5 ff ff       	jmp    80107e6a <alltraps>

801088f4 <vector122>:
.globl vector122
vector122:
  pushl $0
801088f4:	6a 00                	push   $0x0
  pushl $122
801088f6:	6a 7a                	push   $0x7a
  jmp alltraps
801088f8:	e9 6d f5 ff ff       	jmp    80107e6a <alltraps>

801088fd <vector123>:
.globl vector123
vector123:
  pushl $0
801088fd:	6a 00                	push   $0x0
  pushl $123
801088ff:	6a 7b                	push   $0x7b
  jmp alltraps
80108901:	e9 64 f5 ff ff       	jmp    80107e6a <alltraps>

80108906 <vector124>:
.globl vector124
vector124:
  pushl $0
80108906:	6a 00                	push   $0x0
  pushl $124
80108908:	6a 7c                	push   $0x7c
  jmp alltraps
8010890a:	e9 5b f5 ff ff       	jmp    80107e6a <alltraps>

8010890f <vector125>:
.globl vector125
vector125:
  pushl $0
8010890f:	6a 00                	push   $0x0
  pushl $125
80108911:	6a 7d                	push   $0x7d
  jmp alltraps
80108913:	e9 52 f5 ff ff       	jmp    80107e6a <alltraps>

80108918 <vector126>:
.globl vector126
vector126:
  pushl $0
80108918:	6a 00                	push   $0x0
  pushl $126
8010891a:	6a 7e                	push   $0x7e
  jmp alltraps
8010891c:	e9 49 f5 ff ff       	jmp    80107e6a <alltraps>

80108921 <vector127>:
.globl vector127
vector127:
  pushl $0
80108921:	6a 00                	push   $0x0
  pushl $127
80108923:	6a 7f                	push   $0x7f
  jmp alltraps
80108925:	e9 40 f5 ff ff       	jmp    80107e6a <alltraps>

8010892a <vector128>:
.globl vector128
vector128:
  pushl $0
8010892a:	6a 00                	push   $0x0
  pushl $128
8010892c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108931:	e9 34 f5 ff ff       	jmp    80107e6a <alltraps>

80108936 <vector129>:
.globl vector129
vector129:
  pushl $0
80108936:	6a 00                	push   $0x0
  pushl $129
80108938:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010893d:	e9 28 f5 ff ff       	jmp    80107e6a <alltraps>

80108942 <vector130>:
.globl vector130
vector130:
  pushl $0
80108942:	6a 00                	push   $0x0
  pushl $130
80108944:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108949:	e9 1c f5 ff ff       	jmp    80107e6a <alltraps>

8010894e <vector131>:
.globl vector131
vector131:
  pushl $0
8010894e:	6a 00                	push   $0x0
  pushl $131
80108950:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108955:	e9 10 f5 ff ff       	jmp    80107e6a <alltraps>

8010895a <vector132>:
.globl vector132
vector132:
  pushl $0
8010895a:	6a 00                	push   $0x0
  pushl $132
8010895c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108961:	e9 04 f5 ff ff       	jmp    80107e6a <alltraps>

80108966 <vector133>:
.globl vector133
vector133:
  pushl $0
80108966:	6a 00                	push   $0x0
  pushl $133
80108968:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010896d:	e9 f8 f4 ff ff       	jmp    80107e6a <alltraps>

80108972 <vector134>:
.globl vector134
vector134:
  pushl $0
80108972:	6a 00                	push   $0x0
  pushl $134
80108974:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108979:	e9 ec f4 ff ff       	jmp    80107e6a <alltraps>

8010897e <vector135>:
.globl vector135
vector135:
  pushl $0
8010897e:	6a 00                	push   $0x0
  pushl $135
80108980:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108985:	e9 e0 f4 ff ff       	jmp    80107e6a <alltraps>

8010898a <vector136>:
.globl vector136
vector136:
  pushl $0
8010898a:	6a 00                	push   $0x0
  pushl $136
8010898c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108991:	e9 d4 f4 ff ff       	jmp    80107e6a <alltraps>

80108996 <vector137>:
.globl vector137
vector137:
  pushl $0
80108996:	6a 00                	push   $0x0
  pushl $137
80108998:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010899d:	e9 c8 f4 ff ff       	jmp    80107e6a <alltraps>

801089a2 <vector138>:
.globl vector138
vector138:
  pushl $0
801089a2:	6a 00                	push   $0x0
  pushl $138
801089a4:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801089a9:	e9 bc f4 ff ff       	jmp    80107e6a <alltraps>

801089ae <vector139>:
.globl vector139
vector139:
  pushl $0
801089ae:	6a 00                	push   $0x0
  pushl $139
801089b0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801089b5:	e9 b0 f4 ff ff       	jmp    80107e6a <alltraps>

801089ba <vector140>:
.globl vector140
vector140:
  pushl $0
801089ba:	6a 00                	push   $0x0
  pushl $140
801089bc:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801089c1:	e9 a4 f4 ff ff       	jmp    80107e6a <alltraps>

801089c6 <vector141>:
.globl vector141
vector141:
  pushl $0
801089c6:	6a 00                	push   $0x0
  pushl $141
801089c8:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801089cd:	e9 98 f4 ff ff       	jmp    80107e6a <alltraps>

801089d2 <vector142>:
.globl vector142
vector142:
  pushl $0
801089d2:	6a 00                	push   $0x0
  pushl $142
801089d4:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801089d9:	e9 8c f4 ff ff       	jmp    80107e6a <alltraps>

801089de <vector143>:
.globl vector143
vector143:
  pushl $0
801089de:	6a 00                	push   $0x0
  pushl $143
801089e0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801089e5:	e9 80 f4 ff ff       	jmp    80107e6a <alltraps>

801089ea <vector144>:
.globl vector144
vector144:
  pushl $0
801089ea:	6a 00                	push   $0x0
  pushl $144
801089ec:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801089f1:	e9 74 f4 ff ff       	jmp    80107e6a <alltraps>

801089f6 <vector145>:
.globl vector145
vector145:
  pushl $0
801089f6:	6a 00                	push   $0x0
  pushl $145
801089f8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801089fd:	e9 68 f4 ff ff       	jmp    80107e6a <alltraps>

80108a02 <vector146>:
.globl vector146
vector146:
  pushl $0
80108a02:	6a 00                	push   $0x0
  pushl $146
80108a04:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108a09:	e9 5c f4 ff ff       	jmp    80107e6a <alltraps>

80108a0e <vector147>:
.globl vector147
vector147:
  pushl $0
80108a0e:	6a 00                	push   $0x0
  pushl $147
80108a10:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108a15:	e9 50 f4 ff ff       	jmp    80107e6a <alltraps>

80108a1a <vector148>:
.globl vector148
vector148:
  pushl $0
80108a1a:	6a 00                	push   $0x0
  pushl $148
80108a1c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108a21:	e9 44 f4 ff ff       	jmp    80107e6a <alltraps>

80108a26 <vector149>:
.globl vector149
vector149:
  pushl $0
80108a26:	6a 00                	push   $0x0
  pushl $149
80108a28:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108a2d:	e9 38 f4 ff ff       	jmp    80107e6a <alltraps>

80108a32 <vector150>:
.globl vector150
vector150:
  pushl $0
80108a32:	6a 00                	push   $0x0
  pushl $150
80108a34:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108a39:	e9 2c f4 ff ff       	jmp    80107e6a <alltraps>

80108a3e <vector151>:
.globl vector151
vector151:
  pushl $0
80108a3e:	6a 00                	push   $0x0
  pushl $151
80108a40:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108a45:	e9 20 f4 ff ff       	jmp    80107e6a <alltraps>

80108a4a <vector152>:
.globl vector152
vector152:
  pushl $0
80108a4a:	6a 00                	push   $0x0
  pushl $152
80108a4c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108a51:	e9 14 f4 ff ff       	jmp    80107e6a <alltraps>

80108a56 <vector153>:
.globl vector153
vector153:
  pushl $0
80108a56:	6a 00                	push   $0x0
  pushl $153
80108a58:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108a5d:	e9 08 f4 ff ff       	jmp    80107e6a <alltraps>

80108a62 <vector154>:
.globl vector154
vector154:
  pushl $0
80108a62:	6a 00                	push   $0x0
  pushl $154
80108a64:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108a69:	e9 fc f3 ff ff       	jmp    80107e6a <alltraps>

80108a6e <vector155>:
.globl vector155
vector155:
  pushl $0
80108a6e:	6a 00                	push   $0x0
  pushl $155
80108a70:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108a75:	e9 f0 f3 ff ff       	jmp    80107e6a <alltraps>

80108a7a <vector156>:
.globl vector156
vector156:
  pushl $0
80108a7a:	6a 00                	push   $0x0
  pushl $156
80108a7c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108a81:	e9 e4 f3 ff ff       	jmp    80107e6a <alltraps>

80108a86 <vector157>:
.globl vector157
vector157:
  pushl $0
80108a86:	6a 00                	push   $0x0
  pushl $157
80108a88:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108a8d:	e9 d8 f3 ff ff       	jmp    80107e6a <alltraps>

80108a92 <vector158>:
.globl vector158
vector158:
  pushl $0
80108a92:	6a 00                	push   $0x0
  pushl $158
80108a94:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108a99:	e9 cc f3 ff ff       	jmp    80107e6a <alltraps>

80108a9e <vector159>:
.globl vector159
vector159:
  pushl $0
80108a9e:	6a 00                	push   $0x0
  pushl $159
80108aa0:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108aa5:	e9 c0 f3 ff ff       	jmp    80107e6a <alltraps>

80108aaa <vector160>:
.globl vector160
vector160:
  pushl $0
80108aaa:	6a 00                	push   $0x0
  pushl $160
80108aac:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108ab1:	e9 b4 f3 ff ff       	jmp    80107e6a <alltraps>

80108ab6 <vector161>:
.globl vector161
vector161:
  pushl $0
80108ab6:	6a 00                	push   $0x0
  pushl $161
80108ab8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108abd:	e9 a8 f3 ff ff       	jmp    80107e6a <alltraps>

80108ac2 <vector162>:
.globl vector162
vector162:
  pushl $0
80108ac2:	6a 00                	push   $0x0
  pushl $162
80108ac4:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108ac9:	e9 9c f3 ff ff       	jmp    80107e6a <alltraps>

80108ace <vector163>:
.globl vector163
vector163:
  pushl $0
80108ace:	6a 00                	push   $0x0
  pushl $163
80108ad0:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108ad5:	e9 90 f3 ff ff       	jmp    80107e6a <alltraps>

80108ada <vector164>:
.globl vector164
vector164:
  pushl $0
80108ada:	6a 00                	push   $0x0
  pushl $164
80108adc:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108ae1:	e9 84 f3 ff ff       	jmp    80107e6a <alltraps>

80108ae6 <vector165>:
.globl vector165
vector165:
  pushl $0
80108ae6:	6a 00                	push   $0x0
  pushl $165
80108ae8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108aed:	e9 78 f3 ff ff       	jmp    80107e6a <alltraps>

80108af2 <vector166>:
.globl vector166
vector166:
  pushl $0
80108af2:	6a 00                	push   $0x0
  pushl $166
80108af4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108af9:	e9 6c f3 ff ff       	jmp    80107e6a <alltraps>

80108afe <vector167>:
.globl vector167
vector167:
  pushl $0
80108afe:	6a 00                	push   $0x0
  pushl $167
80108b00:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108b05:	e9 60 f3 ff ff       	jmp    80107e6a <alltraps>

80108b0a <vector168>:
.globl vector168
vector168:
  pushl $0
80108b0a:	6a 00                	push   $0x0
  pushl $168
80108b0c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108b11:	e9 54 f3 ff ff       	jmp    80107e6a <alltraps>

80108b16 <vector169>:
.globl vector169
vector169:
  pushl $0
80108b16:	6a 00                	push   $0x0
  pushl $169
80108b18:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108b1d:	e9 48 f3 ff ff       	jmp    80107e6a <alltraps>

80108b22 <vector170>:
.globl vector170
vector170:
  pushl $0
80108b22:	6a 00                	push   $0x0
  pushl $170
80108b24:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108b29:	e9 3c f3 ff ff       	jmp    80107e6a <alltraps>

80108b2e <vector171>:
.globl vector171
vector171:
  pushl $0
80108b2e:	6a 00                	push   $0x0
  pushl $171
80108b30:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108b35:	e9 30 f3 ff ff       	jmp    80107e6a <alltraps>

80108b3a <vector172>:
.globl vector172
vector172:
  pushl $0
80108b3a:	6a 00                	push   $0x0
  pushl $172
80108b3c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108b41:	e9 24 f3 ff ff       	jmp    80107e6a <alltraps>

80108b46 <vector173>:
.globl vector173
vector173:
  pushl $0
80108b46:	6a 00                	push   $0x0
  pushl $173
80108b48:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108b4d:	e9 18 f3 ff ff       	jmp    80107e6a <alltraps>

80108b52 <vector174>:
.globl vector174
vector174:
  pushl $0
80108b52:	6a 00                	push   $0x0
  pushl $174
80108b54:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108b59:	e9 0c f3 ff ff       	jmp    80107e6a <alltraps>

80108b5e <vector175>:
.globl vector175
vector175:
  pushl $0
80108b5e:	6a 00                	push   $0x0
  pushl $175
80108b60:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108b65:	e9 00 f3 ff ff       	jmp    80107e6a <alltraps>

80108b6a <vector176>:
.globl vector176
vector176:
  pushl $0
80108b6a:	6a 00                	push   $0x0
  pushl $176
80108b6c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108b71:	e9 f4 f2 ff ff       	jmp    80107e6a <alltraps>

80108b76 <vector177>:
.globl vector177
vector177:
  pushl $0
80108b76:	6a 00                	push   $0x0
  pushl $177
80108b78:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108b7d:	e9 e8 f2 ff ff       	jmp    80107e6a <alltraps>

80108b82 <vector178>:
.globl vector178
vector178:
  pushl $0
80108b82:	6a 00                	push   $0x0
  pushl $178
80108b84:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108b89:	e9 dc f2 ff ff       	jmp    80107e6a <alltraps>

80108b8e <vector179>:
.globl vector179
vector179:
  pushl $0
80108b8e:	6a 00                	push   $0x0
  pushl $179
80108b90:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108b95:	e9 d0 f2 ff ff       	jmp    80107e6a <alltraps>

80108b9a <vector180>:
.globl vector180
vector180:
  pushl $0
80108b9a:	6a 00                	push   $0x0
  pushl $180
80108b9c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108ba1:	e9 c4 f2 ff ff       	jmp    80107e6a <alltraps>

80108ba6 <vector181>:
.globl vector181
vector181:
  pushl $0
80108ba6:	6a 00                	push   $0x0
  pushl $181
80108ba8:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108bad:	e9 b8 f2 ff ff       	jmp    80107e6a <alltraps>

80108bb2 <vector182>:
.globl vector182
vector182:
  pushl $0
80108bb2:	6a 00                	push   $0x0
  pushl $182
80108bb4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108bb9:	e9 ac f2 ff ff       	jmp    80107e6a <alltraps>

80108bbe <vector183>:
.globl vector183
vector183:
  pushl $0
80108bbe:	6a 00                	push   $0x0
  pushl $183
80108bc0:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108bc5:	e9 a0 f2 ff ff       	jmp    80107e6a <alltraps>

80108bca <vector184>:
.globl vector184
vector184:
  pushl $0
80108bca:	6a 00                	push   $0x0
  pushl $184
80108bcc:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108bd1:	e9 94 f2 ff ff       	jmp    80107e6a <alltraps>

80108bd6 <vector185>:
.globl vector185
vector185:
  pushl $0
80108bd6:	6a 00                	push   $0x0
  pushl $185
80108bd8:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108bdd:	e9 88 f2 ff ff       	jmp    80107e6a <alltraps>

80108be2 <vector186>:
.globl vector186
vector186:
  pushl $0
80108be2:	6a 00                	push   $0x0
  pushl $186
80108be4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108be9:	e9 7c f2 ff ff       	jmp    80107e6a <alltraps>

80108bee <vector187>:
.globl vector187
vector187:
  pushl $0
80108bee:	6a 00                	push   $0x0
  pushl $187
80108bf0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108bf5:	e9 70 f2 ff ff       	jmp    80107e6a <alltraps>

80108bfa <vector188>:
.globl vector188
vector188:
  pushl $0
80108bfa:	6a 00                	push   $0x0
  pushl $188
80108bfc:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108c01:	e9 64 f2 ff ff       	jmp    80107e6a <alltraps>

80108c06 <vector189>:
.globl vector189
vector189:
  pushl $0
80108c06:	6a 00                	push   $0x0
  pushl $189
80108c08:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108c0d:	e9 58 f2 ff ff       	jmp    80107e6a <alltraps>

80108c12 <vector190>:
.globl vector190
vector190:
  pushl $0
80108c12:	6a 00                	push   $0x0
  pushl $190
80108c14:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108c19:	e9 4c f2 ff ff       	jmp    80107e6a <alltraps>

80108c1e <vector191>:
.globl vector191
vector191:
  pushl $0
80108c1e:	6a 00                	push   $0x0
  pushl $191
80108c20:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108c25:	e9 40 f2 ff ff       	jmp    80107e6a <alltraps>

80108c2a <vector192>:
.globl vector192
vector192:
  pushl $0
80108c2a:	6a 00                	push   $0x0
  pushl $192
80108c2c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108c31:	e9 34 f2 ff ff       	jmp    80107e6a <alltraps>

80108c36 <vector193>:
.globl vector193
vector193:
  pushl $0
80108c36:	6a 00                	push   $0x0
  pushl $193
80108c38:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108c3d:	e9 28 f2 ff ff       	jmp    80107e6a <alltraps>

80108c42 <vector194>:
.globl vector194
vector194:
  pushl $0
80108c42:	6a 00                	push   $0x0
  pushl $194
80108c44:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108c49:	e9 1c f2 ff ff       	jmp    80107e6a <alltraps>

80108c4e <vector195>:
.globl vector195
vector195:
  pushl $0
80108c4e:	6a 00                	push   $0x0
  pushl $195
80108c50:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108c55:	e9 10 f2 ff ff       	jmp    80107e6a <alltraps>

80108c5a <vector196>:
.globl vector196
vector196:
  pushl $0
80108c5a:	6a 00                	push   $0x0
  pushl $196
80108c5c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108c61:	e9 04 f2 ff ff       	jmp    80107e6a <alltraps>

80108c66 <vector197>:
.globl vector197
vector197:
  pushl $0
80108c66:	6a 00                	push   $0x0
  pushl $197
80108c68:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108c6d:	e9 f8 f1 ff ff       	jmp    80107e6a <alltraps>

80108c72 <vector198>:
.globl vector198
vector198:
  pushl $0
80108c72:	6a 00                	push   $0x0
  pushl $198
80108c74:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108c79:	e9 ec f1 ff ff       	jmp    80107e6a <alltraps>

80108c7e <vector199>:
.globl vector199
vector199:
  pushl $0
80108c7e:	6a 00                	push   $0x0
  pushl $199
80108c80:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108c85:	e9 e0 f1 ff ff       	jmp    80107e6a <alltraps>

80108c8a <vector200>:
.globl vector200
vector200:
  pushl $0
80108c8a:	6a 00                	push   $0x0
  pushl $200
80108c8c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108c91:	e9 d4 f1 ff ff       	jmp    80107e6a <alltraps>

80108c96 <vector201>:
.globl vector201
vector201:
  pushl $0
80108c96:	6a 00                	push   $0x0
  pushl $201
80108c98:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108c9d:	e9 c8 f1 ff ff       	jmp    80107e6a <alltraps>

80108ca2 <vector202>:
.globl vector202
vector202:
  pushl $0
80108ca2:	6a 00                	push   $0x0
  pushl $202
80108ca4:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108ca9:	e9 bc f1 ff ff       	jmp    80107e6a <alltraps>

80108cae <vector203>:
.globl vector203
vector203:
  pushl $0
80108cae:	6a 00                	push   $0x0
  pushl $203
80108cb0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108cb5:	e9 b0 f1 ff ff       	jmp    80107e6a <alltraps>

80108cba <vector204>:
.globl vector204
vector204:
  pushl $0
80108cba:	6a 00                	push   $0x0
  pushl $204
80108cbc:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108cc1:	e9 a4 f1 ff ff       	jmp    80107e6a <alltraps>

80108cc6 <vector205>:
.globl vector205
vector205:
  pushl $0
80108cc6:	6a 00                	push   $0x0
  pushl $205
80108cc8:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108ccd:	e9 98 f1 ff ff       	jmp    80107e6a <alltraps>

80108cd2 <vector206>:
.globl vector206
vector206:
  pushl $0
80108cd2:	6a 00                	push   $0x0
  pushl $206
80108cd4:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108cd9:	e9 8c f1 ff ff       	jmp    80107e6a <alltraps>

80108cde <vector207>:
.globl vector207
vector207:
  pushl $0
80108cde:	6a 00                	push   $0x0
  pushl $207
80108ce0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108ce5:	e9 80 f1 ff ff       	jmp    80107e6a <alltraps>

80108cea <vector208>:
.globl vector208
vector208:
  pushl $0
80108cea:	6a 00                	push   $0x0
  pushl $208
80108cec:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108cf1:	e9 74 f1 ff ff       	jmp    80107e6a <alltraps>

80108cf6 <vector209>:
.globl vector209
vector209:
  pushl $0
80108cf6:	6a 00                	push   $0x0
  pushl $209
80108cf8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108cfd:	e9 68 f1 ff ff       	jmp    80107e6a <alltraps>

80108d02 <vector210>:
.globl vector210
vector210:
  pushl $0
80108d02:	6a 00                	push   $0x0
  pushl $210
80108d04:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108d09:	e9 5c f1 ff ff       	jmp    80107e6a <alltraps>

80108d0e <vector211>:
.globl vector211
vector211:
  pushl $0
80108d0e:	6a 00                	push   $0x0
  pushl $211
80108d10:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108d15:	e9 50 f1 ff ff       	jmp    80107e6a <alltraps>

80108d1a <vector212>:
.globl vector212
vector212:
  pushl $0
80108d1a:	6a 00                	push   $0x0
  pushl $212
80108d1c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108d21:	e9 44 f1 ff ff       	jmp    80107e6a <alltraps>

80108d26 <vector213>:
.globl vector213
vector213:
  pushl $0
80108d26:	6a 00                	push   $0x0
  pushl $213
80108d28:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108d2d:	e9 38 f1 ff ff       	jmp    80107e6a <alltraps>

80108d32 <vector214>:
.globl vector214
vector214:
  pushl $0
80108d32:	6a 00                	push   $0x0
  pushl $214
80108d34:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108d39:	e9 2c f1 ff ff       	jmp    80107e6a <alltraps>

80108d3e <vector215>:
.globl vector215
vector215:
  pushl $0
80108d3e:	6a 00                	push   $0x0
  pushl $215
80108d40:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108d45:	e9 20 f1 ff ff       	jmp    80107e6a <alltraps>

80108d4a <vector216>:
.globl vector216
vector216:
  pushl $0
80108d4a:	6a 00                	push   $0x0
  pushl $216
80108d4c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108d51:	e9 14 f1 ff ff       	jmp    80107e6a <alltraps>

80108d56 <vector217>:
.globl vector217
vector217:
  pushl $0
80108d56:	6a 00                	push   $0x0
  pushl $217
80108d58:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108d5d:	e9 08 f1 ff ff       	jmp    80107e6a <alltraps>

80108d62 <vector218>:
.globl vector218
vector218:
  pushl $0
80108d62:	6a 00                	push   $0x0
  pushl $218
80108d64:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108d69:	e9 fc f0 ff ff       	jmp    80107e6a <alltraps>

80108d6e <vector219>:
.globl vector219
vector219:
  pushl $0
80108d6e:	6a 00                	push   $0x0
  pushl $219
80108d70:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108d75:	e9 f0 f0 ff ff       	jmp    80107e6a <alltraps>

80108d7a <vector220>:
.globl vector220
vector220:
  pushl $0
80108d7a:	6a 00                	push   $0x0
  pushl $220
80108d7c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108d81:	e9 e4 f0 ff ff       	jmp    80107e6a <alltraps>

80108d86 <vector221>:
.globl vector221
vector221:
  pushl $0
80108d86:	6a 00                	push   $0x0
  pushl $221
80108d88:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108d8d:	e9 d8 f0 ff ff       	jmp    80107e6a <alltraps>

80108d92 <vector222>:
.globl vector222
vector222:
  pushl $0
80108d92:	6a 00                	push   $0x0
  pushl $222
80108d94:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108d99:	e9 cc f0 ff ff       	jmp    80107e6a <alltraps>

80108d9e <vector223>:
.globl vector223
vector223:
  pushl $0
80108d9e:	6a 00                	push   $0x0
  pushl $223
80108da0:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108da5:	e9 c0 f0 ff ff       	jmp    80107e6a <alltraps>

80108daa <vector224>:
.globl vector224
vector224:
  pushl $0
80108daa:	6a 00                	push   $0x0
  pushl $224
80108dac:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108db1:	e9 b4 f0 ff ff       	jmp    80107e6a <alltraps>

80108db6 <vector225>:
.globl vector225
vector225:
  pushl $0
80108db6:	6a 00                	push   $0x0
  pushl $225
80108db8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108dbd:	e9 a8 f0 ff ff       	jmp    80107e6a <alltraps>

80108dc2 <vector226>:
.globl vector226
vector226:
  pushl $0
80108dc2:	6a 00                	push   $0x0
  pushl $226
80108dc4:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108dc9:	e9 9c f0 ff ff       	jmp    80107e6a <alltraps>

80108dce <vector227>:
.globl vector227
vector227:
  pushl $0
80108dce:	6a 00                	push   $0x0
  pushl $227
80108dd0:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108dd5:	e9 90 f0 ff ff       	jmp    80107e6a <alltraps>

80108dda <vector228>:
.globl vector228
vector228:
  pushl $0
80108dda:	6a 00                	push   $0x0
  pushl $228
80108ddc:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108de1:	e9 84 f0 ff ff       	jmp    80107e6a <alltraps>

80108de6 <vector229>:
.globl vector229
vector229:
  pushl $0
80108de6:	6a 00                	push   $0x0
  pushl $229
80108de8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108ded:	e9 78 f0 ff ff       	jmp    80107e6a <alltraps>

80108df2 <vector230>:
.globl vector230
vector230:
  pushl $0
80108df2:	6a 00                	push   $0x0
  pushl $230
80108df4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108df9:	e9 6c f0 ff ff       	jmp    80107e6a <alltraps>

80108dfe <vector231>:
.globl vector231
vector231:
  pushl $0
80108dfe:	6a 00                	push   $0x0
  pushl $231
80108e00:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108e05:	e9 60 f0 ff ff       	jmp    80107e6a <alltraps>

80108e0a <vector232>:
.globl vector232
vector232:
  pushl $0
80108e0a:	6a 00                	push   $0x0
  pushl $232
80108e0c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108e11:	e9 54 f0 ff ff       	jmp    80107e6a <alltraps>

80108e16 <vector233>:
.globl vector233
vector233:
  pushl $0
80108e16:	6a 00                	push   $0x0
  pushl $233
80108e18:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108e1d:	e9 48 f0 ff ff       	jmp    80107e6a <alltraps>

80108e22 <vector234>:
.globl vector234
vector234:
  pushl $0
80108e22:	6a 00                	push   $0x0
  pushl $234
80108e24:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108e29:	e9 3c f0 ff ff       	jmp    80107e6a <alltraps>

80108e2e <vector235>:
.globl vector235
vector235:
  pushl $0
80108e2e:	6a 00                	push   $0x0
  pushl $235
80108e30:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108e35:	e9 30 f0 ff ff       	jmp    80107e6a <alltraps>

80108e3a <vector236>:
.globl vector236
vector236:
  pushl $0
80108e3a:	6a 00                	push   $0x0
  pushl $236
80108e3c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108e41:	e9 24 f0 ff ff       	jmp    80107e6a <alltraps>

80108e46 <vector237>:
.globl vector237
vector237:
  pushl $0
80108e46:	6a 00                	push   $0x0
  pushl $237
80108e48:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108e4d:	e9 18 f0 ff ff       	jmp    80107e6a <alltraps>

80108e52 <vector238>:
.globl vector238
vector238:
  pushl $0
80108e52:	6a 00                	push   $0x0
  pushl $238
80108e54:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108e59:	e9 0c f0 ff ff       	jmp    80107e6a <alltraps>

80108e5e <vector239>:
.globl vector239
vector239:
  pushl $0
80108e5e:	6a 00                	push   $0x0
  pushl $239
80108e60:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108e65:	e9 00 f0 ff ff       	jmp    80107e6a <alltraps>

80108e6a <vector240>:
.globl vector240
vector240:
  pushl $0
80108e6a:	6a 00                	push   $0x0
  pushl $240
80108e6c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108e71:	e9 f4 ef ff ff       	jmp    80107e6a <alltraps>

80108e76 <vector241>:
.globl vector241
vector241:
  pushl $0
80108e76:	6a 00                	push   $0x0
  pushl $241
80108e78:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108e7d:	e9 e8 ef ff ff       	jmp    80107e6a <alltraps>

80108e82 <vector242>:
.globl vector242
vector242:
  pushl $0
80108e82:	6a 00                	push   $0x0
  pushl $242
80108e84:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108e89:	e9 dc ef ff ff       	jmp    80107e6a <alltraps>

80108e8e <vector243>:
.globl vector243
vector243:
  pushl $0
80108e8e:	6a 00                	push   $0x0
  pushl $243
80108e90:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108e95:	e9 d0 ef ff ff       	jmp    80107e6a <alltraps>

80108e9a <vector244>:
.globl vector244
vector244:
  pushl $0
80108e9a:	6a 00                	push   $0x0
  pushl $244
80108e9c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108ea1:	e9 c4 ef ff ff       	jmp    80107e6a <alltraps>

80108ea6 <vector245>:
.globl vector245
vector245:
  pushl $0
80108ea6:	6a 00                	push   $0x0
  pushl $245
80108ea8:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108ead:	e9 b8 ef ff ff       	jmp    80107e6a <alltraps>

80108eb2 <vector246>:
.globl vector246
vector246:
  pushl $0
80108eb2:	6a 00                	push   $0x0
  pushl $246
80108eb4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108eb9:	e9 ac ef ff ff       	jmp    80107e6a <alltraps>

80108ebe <vector247>:
.globl vector247
vector247:
  pushl $0
80108ebe:	6a 00                	push   $0x0
  pushl $247
80108ec0:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108ec5:	e9 a0 ef ff ff       	jmp    80107e6a <alltraps>

80108eca <vector248>:
.globl vector248
vector248:
  pushl $0
80108eca:	6a 00                	push   $0x0
  pushl $248
80108ecc:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108ed1:	e9 94 ef ff ff       	jmp    80107e6a <alltraps>

80108ed6 <vector249>:
.globl vector249
vector249:
  pushl $0
80108ed6:	6a 00                	push   $0x0
  pushl $249
80108ed8:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108edd:	e9 88 ef ff ff       	jmp    80107e6a <alltraps>

80108ee2 <vector250>:
.globl vector250
vector250:
  pushl $0
80108ee2:	6a 00                	push   $0x0
  pushl $250
80108ee4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108ee9:	e9 7c ef ff ff       	jmp    80107e6a <alltraps>

80108eee <vector251>:
.globl vector251
vector251:
  pushl $0
80108eee:	6a 00                	push   $0x0
  pushl $251
80108ef0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108ef5:	e9 70 ef ff ff       	jmp    80107e6a <alltraps>

80108efa <vector252>:
.globl vector252
vector252:
  pushl $0
80108efa:	6a 00                	push   $0x0
  pushl $252
80108efc:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108f01:	e9 64 ef ff ff       	jmp    80107e6a <alltraps>

80108f06 <vector253>:
.globl vector253
vector253:
  pushl $0
80108f06:	6a 00                	push   $0x0
  pushl $253
80108f08:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108f0d:	e9 58 ef ff ff       	jmp    80107e6a <alltraps>

80108f12 <vector254>:
.globl vector254
vector254:
  pushl $0
80108f12:	6a 00                	push   $0x0
  pushl $254
80108f14:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108f19:	e9 4c ef ff ff       	jmp    80107e6a <alltraps>

80108f1e <vector255>:
.globl vector255
vector255:
  pushl $0
80108f1e:	6a 00                	push   $0x0
  pushl $255
80108f20:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108f25:	e9 40 ef ff ff       	jmp    80107e6a <alltraps>

80108f2a <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108f2a:	55                   	push   %ebp
80108f2b:	89 e5                	mov    %esp,%ebp
80108f2d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f33:	83 e8 01             	sub    $0x1,%eax
80108f36:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80108f3d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108f41:	8b 45 08             	mov    0x8(%ebp),%eax
80108f44:	c1 e8 10             	shr    $0x10,%eax
80108f47:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108f4b:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108f4e:	0f 01 10             	lgdtl  (%eax)
}
80108f51:	90                   	nop
80108f52:	c9                   	leave  
80108f53:	c3                   	ret    

80108f54 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108f54:	55                   	push   %ebp
80108f55:	89 e5                	mov    %esp,%ebp
80108f57:	83 ec 04             	sub    $0x4,%esp
80108f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80108f5d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108f61:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108f65:	0f 00 d8             	ltr    %ax
}
80108f68:	90                   	nop
80108f69:	c9                   	leave  
80108f6a:	c3                   	ret    

80108f6b <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108f6b:	55                   	push   %ebp
80108f6c:	89 e5                	mov    %esp,%ebp
80108f6e:	83 ec 04             	sub    $0x4,%esp
80108f71:	8b 45 08             	mov    0x8(%ebp),%eax
80108f74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108f78:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108f7c:	8e e8                	mov    %eax,%gs
}
80108f7e:	90                   	nop
80108f7f:	c9                   	leave  
80108f80:	c3                   	ret    

80108f81 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108f81:	55                   	push   %ebp
80108f82:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108f84:	8b 45 08             	mov    0x8(%ebp),%eax
80108f87:	0f 22 d8             	mov    %eax,%cr3
}
80108f8a:	90                   	nop
80108f8b:	5d                   	pop    %ebp
80108f8c:	c3                   	ret    

80108f8d <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108f8d:	55                   	push   %ebp
80108f8e:	89 e5                	mov    %esp,%ebp
80108f90:	8b 45 08             	mov    0x8(%ebp),%eax
80108f93:	05 00 00 00 80       	add    $0x80000000,%eax
80108f98:	5d                   	pop    %ebp
80108f99:	c3                   	ret    

80108f9a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108f9a:	55                   	push   %ebp
80108f9b:	89 e5                	mov    %esp,%ebp
80108f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80108fa0:	05 00 00 00 80       	add    $0x80000000,%eax
80108fa5:	5d                   	pop    %ebp
80108fa6:	c3                   	ret    

80108fa7 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108fa7:	55                   	push   %ebp
80108fa8:	89 e5                	mov    %esp,%ebp
80108faa:	53                   	push   %ebx
80108fab:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108fae:	e8 73 a3 ff ff       	call   80103326 <cpunum>
80108fb3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108fb9:	05 a0 43 11 80       	add    $0x801143a0,%eax
80108fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fcd:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd6:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fdd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108fe1:	83 e2 f0             	and    $0xfffffff0,%edx
80108fe4:	83 ca 0a             	or     $0xa,%edx
80108fe7:	88 50 7d             	mov    %dl,0x7d(%eax)
80108fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fed:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108ff1:	83 ca 10             	or     $0x10,%edx
80108ff4:	88 50 7d             	mov    %dl,0x7d(%eax)
80108ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ffa:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108ffe:	83 e2 9f             	and    $0xffffff9f,%edx
80109001:	88 50 7d             	mov    %dl,0x7d(%eax)
80109004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109007:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010900b:	83 ca 80             	or     $0xffffff80,%edx
8010900e:	88 50 7d             	mov    %dl,0x7d(%eax)
80109011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109014:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109018:	83 ca 0f             	or     $0xf,%edx
8010901b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010901e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109021:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109025:	83 e2 ef             	and    $0xffffffef,%edx
80109028:	88 50 7e             	mov    %dl,0x7e(%eax)
8010902b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010902e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109032:	83 e2 df             	and    $0xffffffdf,%edx
80109035:	88 50 7e             	mov    %dl,0x7e(%eax)
80109038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010903f:	83 ca 40             	or     $0x40,%edx
80109042:	88 50 7e             	mov    %dl,0x7e(%eax)
80109045:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109048:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010904c:	83 ca 80             	or     $0xffffff80,%edx
8010904f:	88 50 7e             	mov    %dl,0x7e(%eax)
80109052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109055:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010905c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80109063:	ff ff 
80109065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109068:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010906f:	00 00 
80109071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109074:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010907b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010907e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109085:	83 e2 f0             	and    $0xfffffff0,%edx
80109088:	83 ca 02             	or     $0x2,%edx
8010908b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109091:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109094:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010909b:	83 ca 10             	or     $0x10,%edx
8010909e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a7:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801090ae:	83 e2 9f             	and    $0xffffff9f,%edx
801090b1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ba:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801090c1:	83 ca 80             	or     $0xffffff80,%edx
801090c4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801090ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090cd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801090d4:	83 ca 0f             	or     $0xf,%edx
801090d7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801090dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090e0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801090e7:	83 e2 ef             	and    $0xffffffef,%edx
801090ea:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801090f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801090fa:	83 e2 df             	and    $0xffffffdf,%edx
801090fd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109106:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010910d:	83 ca 40             	or     $0x40,%edx
80109110:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109119:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109120:	83 ca 80             	or     $0xffffff80,%edx
80109123:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010912c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109136:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010913d:	ff ff 
8010913f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109142:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109149:	00 00 
8010914b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010914e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80109155:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109158:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010915f:	83 e2 f0             	and    $0xfffffff0,%edx
80109162:	83 ca 0a             	or     $0xa,%edx
80109165:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010916b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010916e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109175:	83 ca 10             	or     $0x10,%edx
80109178:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010917e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109181:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109188:	83 ca 60             	or     $0x60,%edx
8010918b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109194:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010919b:	83 ca 80             	or     $0xffffff80,%edx
8010919e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801091a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091a7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091ae:	83 ca 0f             	or     $0xf,%edx
801091b1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801091b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ba:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091c1:	83 e2 ef             	and    $0xffffffef,%edx
801091c4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801091ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091d4:	83 e2 df             	and    $0xffffffdf,%edx
801091d7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801091dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091e7:	83 ca 40             	or     $0x40,%edx
801091ea:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801091f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801091fa:	83 ca 80             	or     $0xffffff80,%edx
801091fd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109206:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010920d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109210:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109217:	ff ff 
80109219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109223:	00 00 
80109225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109228:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010922f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109232:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109239:	83 e2 f0             	and    $0xfffffff0,%edx
8010923c:	83 ca 02             	or     $0x2,%edx
8010923f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109245:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109248:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010924f:	83 ca 10             	or     $0x10,%edx
80109252:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010925b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109262:	83 ca 60             	or     $0x60,%edx
80109265:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010926b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010926e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109275:	83 ca 80             	or     $0xffffff80,%edx
80109278:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010927e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109281:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109288:	83 ca 0f             	or     $0xf,%edx
8010928b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109291:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109294:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010929b:	83 e2 ef             	and    $0xffffffef,%edx
8010929e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092ae:	83 e2 df             	and    $0xffffffdf,%edx
801092b1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ba:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092c1:	83 ca 40             	or     $0x40,%edx
801092c4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092cd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801092d4:	83 ca 80             	or     $0xffffff80,%edx
801092d7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801092dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e0:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801092e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ea:	05 b4 00 00 00       	add    $0xb4,%eax
801092ef:	89 c3                	mov    %eax,%ebx
801092f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f4:	05 b4 00 00 00       	add    $0xb4,%eax
801092f9:	c1 e8 10             	shr    $0x10,%eax
801092fc:	89 c2                	mov    %eax,%edx
801092fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109301:	05 b4 00 00 00       	add    $0xb4,%eax
80109306:	c1 e8 18             	shr    $0x18,%eax
80109309:	89 c1                	mov    %eax,%ecx
8010930b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010930e:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109315:	00 00 
80109317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931a:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109324:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010932a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010932d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109334:	83 e2 f0             	and    $0xfffffff0,%edx
80109337:	83 ca 02             	or     $0x2,%edx
8010933a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109343:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010934a:	83 ca 10             	or     $0x10,%edx
8010934d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109356:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010935d:	83 e2 9f             	and    $0xffffff9f,%edx
80109360:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109369:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109370:	83 ca 80             	or     $0xffffff80,%edx
80109373:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109383:	83 e2 f0             	and    $0xfffffff0,%edx
80109386:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010938c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010938f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109396:	83 e2 ef             	and    $0xffffffef,%edx
80109399:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010939f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093a9:	83 e2 df             	and    $0xffffffdf,%edx
801093ac:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093bc:	83 ca 40             	or     $0x40,%edx
801093bf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801093cf:	83 ca 80             	or     $0xffffff80,%edx
801093d2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801093d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093db:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801093e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e4:	83 c0 70             	add    $0x70,%eax
801093e7:	83 ec 08             	sub    $0x8,%esp
801093ea:	6a 38                	push   $0x38
801093ec:	50                   	push   %eax
801093ed:	e8 38 fb ff ff       	call   80108f2a <lgdt>
801093f2:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801093f5:	83 ec 0c             	sub    $0xc,%esp
801093f8:	6a 18                	push   $0x18
801093fa:	e8 6c fb ff ff       	call   80108f6b <loadgs>
801093ff:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109405:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010940b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109412:	00 00 00 00 
}
80109416:	90                   	nop
80109417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010941a:	c9                   	leave  
8010941b:	c3                   	ret    

8010941c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010941c:	55                   	push   %ebp
8010941d:	89 e5                	mov    %esp,%ebp
8010941f:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109422:	8b 45 0c             	mov    0xc(%ebp),%eax
80109425:	c1 e8 16             	shr    $0x16,%eax
80109428:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010942f:	8b 45 08             	mov    0x8(%ebp),%eax
80109432:	01 d0                	add    %edx,%eax
80109434:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109437:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010943a:	8b 00                	mov    (%eax),%eax
8010943c:	83 e0 01             	and    $0x1,%eax
8010943f:	85 c0                	test   %eax,%eax
80109441:	74 18                	je     8010945b <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109446:	8b 00                	mov    (%eax),%eax
80109448:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010944d:	50                   	push   %eax
8010944e:	e8 47 fb ff ff       	call   80108f9a <p2v>
80109453:	83 c4 04             	add    $0x4,%esp
80109456:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109459:	eb 48                	jmp    801094a3 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010945b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010945f:	74 0e                	je     8010946f <walkpgdir+0x53>
80109461:	e8 5a 9b ff ff       	call   80102fc0 <kalloc>
80109466:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010946d:	75 07                	jne    80109476 <walkpgdir+0x5a>
      return 0;
8010946f:	b8 00 00 00 00       	mov    $0x0,%eax
80109474:	eb 44                	jmp    801094ba <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109476:	83 ec 04             	sub    $0x4,%esp
80109479:	68 00 10 00 00       	push   $0x1000
8010947e:	6a 00                	push   $0x0
80109480:	ff 75 f4             	pushl  -0xc(%ebp)
80109483:	e8 10 d3 ff ff       	call   80106798 <memset>
80109488:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010948b:	83 ec 0c             	sub    $0xc,%esp
8010948e:	ff 75 f4             	pushl  -0xc(%ebp)
80109491:	e8 f7 fa ff ff       	call   80108f8d <v2p>
80109496:	83 c4 10             	add    $0x10,%esp
80109499:	83 c8 07             	or     $0x7,%eax
8010949c:	89 c2                	mov    %eax,%edx
8010949e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094a1:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801094a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801094a6:	c1 e8 0c             	shr    $0xc,%eax
801094a9:	25 ff 03 00 00       	and    $0x3ff,%eax
801094ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801094b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094b8:	01 d0                	add    %edx,%eax
}
801094ba:	c9                   	leave  
801094bb:	c3                   	ret    

801094bc <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801094bc:	55                   	push   %ebp
801094bd:	89 e5                	mov    %esp,%ebp
801094bf:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801094c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801094c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801094cd:	8b 55 0c             	mov    0xc(%ebp),%edx
801094d0:	8b 45 10             	mov    0x10(%ebp),%eax
801094d3:	01 d0                	add    %edx,%eax
801094d5:	83 e8 01             	sub    $0x1,%eax
801094d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801094e0:	83 ec 04             	sub    $0x4,%esp
801094e3:	6a 01                	push   $0x1
801094e5:	ff 75 f4             	pushl  -0xc(%ebp)
801094e8:	ff 75 08             	pushl  0x8(%ebp)
801094eb:	e8 2c ff ff ff       	call   8010941c <walkpgdir>
801094f0:	83 c4 10             	add    $0x10,%esp
801094f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801094f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801094fa:	75 07                	jne    80109503 <mappages+0x47>
      return -1;
801094fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109501:	eb 47                	jmp    8010954a <mappages+0x8e>
    if(*pte & PTE_P)
80109503:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109506:	8b 00                	mov    (%eax),%eax
80109508:	83 e0 01             	and    $0x1,%eax
8010950b:	85 c0                	test   %eax,%eax
8010950d:	74 0d                	je     8010951c <mappages+0x60>
      panic("remap");
8010950f:	83 ec 0c             	sub    $0xc,%esp
80109512:	68 fc a4 10 80       	push   $0x8010a4fc
80109517:	e8 4a 70 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010951c:	8b 45 18             	mov    0x18(%ebp),%eax
8010951f:	0b 45 14             	or     0x14(%ebp),%eax
80109522:	83 c8 01             	or     $0x1,%eax
80109525:	89 c2                	mov    %eax,%edx
80109527:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010952a:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010952c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010952f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109532:	74 10                	je     80109544 <mappages+0x88>
      break;
    a += PGSIZE;
80109534:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010953b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109542:	eb 9c                	jmp    801094e0 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109544:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109545:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010954a:	c9                   	leave  
8010954b:	c3                   	ret    

8010954c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010954c:	55                   	push   %ebp
8010954d:	89 e5                	mov    %esp,%ebp
8010954f:	53                   	push   %ebx
80109550:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109553:	e8 68 9a ff ff       	call   80102fc0 <kalloc>
80109558:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010955b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010955f:	75 0a                	jne    8010956b <setupkvm+0x1f>
    return 0;
80109561:	b8 00 00 00 00       	mov    $0x0,%eax
80109566:	e9 8e 00 00 00       	jmp    801095f9 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010956b:	83 ec 04             	sub    $0x4,%esp
8010956e:	68 00 10 00 00       	push   $0x1000
80109573:	6a 00                	push   $0x0
80109575:	ff 75 f0             	pushl  -0x10(%ebp)
80109578:	e8 1b d2 ff ff       	call   80106798 <memset>
8010957d:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109580:	83 ec 0c             	sub    $0xc,%esp
80109583:	68 00 00 00 0e       	push   $0xe000000
80109588:	e8 0d fa ff ff       	call   80108f9a <p2v>
8010958d:	83 c4 10             	add    $0x10,%esp
80109590:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109595:	76 0d                	jbe    801095a4 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109597:	83 ec 0c             	sub    $0xc,%esp
8010959a:	68 02 a5 10 80       	push   $0x8010a502
8010959f:	e8 c2 6f ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801095a4:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
801095ab:	eb 40                	jmp    801095ed <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801095ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b0:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801095b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b6:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801095b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095bc:	8b 58 08             	mov    0x8(%eax),%ebx
801095bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c2:	8b 40 04             	mov    0x4(%eax),%eax
801095c5:	29 c3                	sub    %eax,%ebx
801095c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ca:	8b 00                	mov    (%eax),%eax
801095cc:	83 ec 0c             	sub    $0xc,%esp
801095cf:	51                   	push   %ecx
801095d0:	52                   	push   %edx
801095d1:	53                   	push   %ebx
801095d2:	50                   	push   %eax
801095d3:	ff 75 f0             	pushl  -0x10(%ebp)
801095d6:	e8 e1 fe ff ff       	call   801094bc <mappages>
801095db:	83 c4 20             	add    $0x20,%esp
801095de:	85 c0                	test   %eax,%eax
801095e0:	79 07                	jns    801095e9 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801095e2:	b8 00 00 00 00       	mov    $0x0,%eax
801095e7:	eb 10                	jmp    801095f9 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801095e9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801095ed:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
801095f4:	72 b7                	jb     801095ad <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801095f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801095f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801095fc:	c9                   	leave  
801095fd:	c3                   	ret    

801095fe <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801095fe:	55                   	push   %ebp
801095ff:	89 e5                	mov    %esp,%ebp
80109601:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109604:	e8 43 ff ff ff       	call   8010954c <setupkvm>
80109609:	a3 78 79 11 80       	mov    %eax,0x80117978
  switchkvm();
8010960e:	e8 03 00 00 00       	call   80109616 <switchkvm>
}
80109613:	90                   	nop
80109614:	c9                   	leave  
80109615:	c3                   	ret    

80109616 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109616:	55                   	push   %ebp
80109617:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109619:	a1 78 79 11 80       	mov    0x80117978,%eax
8010961e:	50                   	push   %eax
8010961f:	e8 69 f9 ff ff       	call   80108f8d <v2p>
80109624:	83 c4 04             	add    $0x4,%esp
80109627:	50                   	push   %eax
80109628:	e8 54 f9 ff ff       	call   80108f81 <lcr3>
8010962d:	83 c4 04             	add    $0x4,%esp
}
80109630:	90                   	nop
80109631:	c9                   	leave  
80109632:	c3                   	ret    

80109633 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109633:	55                   	push   %ebp
80109634:	89 e5                	mov    %esp,%ebp
80109636:	56                   	push   %esi
80109637:	53                   	push   %ebx
  pushcli();
80109638:	e8 55 d0 ff ff       	call   80106692 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010963d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109643:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010964a:	83 c2 08             	add    $0x8,%edx
8010964d:	89 d6                	mov    %edx,%esi
8010964f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109656:	83 c2 08             	add    $0x8,%edx
80109659:	c1 ea 10             	shr    $0x10,%edx
8010965c:	89 d3                	mov    %edx,%ebx
8010965e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109665:	83 c2 08             	add    $0x8,%edx
80109668:	c1 ea 18             	shr    $0x18,%edx
8010966b:	89 d1                	mov    %edx,%ecx
8010966d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109674:	67 00 
80109676:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010967d:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109683:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010968a:	83 e2 f0             	and    $0xfffffff0,%edx
8010968d:	83 ca 09             	or     $0x9,%edx
80109690:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109696:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010969d:	83 ca 10             	or     $0x10,%edx
801096a0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801096a6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801096ad:	83 e2 9f             	and    $0xffffff9f,%edx
801096b0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801096b6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801096bd:	83 ca 80             	or     $0xffffff80,%edx
801096c0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801096c6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801096cd:	83 e2 f0             	and    $0xfffffff0,%edx
801096d0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801096d6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801096dd:	83 e2 ef             	and    $0xffffffef,%edx
801096e0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801096e6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801096ed:	83 e2 df             	and    $0xffffffdf,%edx
801096f0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801096f6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801096fd:	83 ca 40             	or     $0x40,%edx
80109700:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109706:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010970d:	83 e2 7f             	and    $0x7f,%edx
80109710:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109716:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010971c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109722:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109729:	83 e2 ef             	and    $0xffffffef,%edx
8010972c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109732:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109738:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010973e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109744:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010974b:	8b 52 08             	mov    0x8(%edx),%edx
8010974e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109754:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109757:	83 ec 0c             	sub    $0xc,%esp
8010975a:	6a 30                	push   $0x30
8010975c:	e8 f3 f7 ff ff       	call   80108f54 <ltr>
80109761:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109764:	8b 45 08             	mov    0x8(%ebp),%eax
80109767:	8b 40 04             	mov    0x4(%eax),%eax
8010976a:	85 c0                	test   %eax,%eax
8010976c:	75 0d                	jne    8010977b <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010976e:	83 ec 0c             	sub    $0xc,%esp
80109771:	68 13 a5 10 80       	push   $0x8010a513
80109776:	e8 eb 6d ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010977b:	8b 45 08             	mov    0x8(%ebp),%eax
8010977e:	8b 40 04             	mov    0x4(%eax),%eax
80109781:	83 ec 0c             	sub    $0xc,%esp
80109784:	50                   	push   %eax
80109785:	e8 03 f8 ff ff       	call   80108f8d <v2p>
8010978a:	83 c4 10             	add    $0x10,%esp
8010978d:	83 ec 0c             	sub    $0xc,%esp
80109790:	50                   	push   %eax
80109791:	e8 eb f7 ff ff       	call   80108f81 <lcr3>
80109796:	83 c4 10             	add    $0x10,%esp
  popcli();
80109799:	e8 39 cf ff ff       	call   801066d7 <popcli>
}
8010979e:	90                   	nop
8010979f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801097a2:	5b                   	pop    %ebx
801097a3:	5e                   	pop    %esi
801097a4:	5d                   	pop    %ebp
801097a5:	c3                   	ret    

801097a6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801097a6:	55                   	push   %ebp
801097a7:	89 e5                	mov    %esp,%ebp
801097a9:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801097ac:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801097b3:	76 0d                	jbe    801097c2 <inituvm+0x1c>
    panic("inituvm: more than a page");
801097b5:	83 ec 0c             	sub    $0xc,%esp
801097b8:	68 27 a5 10 80       	push   $0x8010a527
801097bd:	e8 a4 6d ff ff       	call   80100566 <panic>
  mem = kalloc();
801097c2:	e8 f9 97 ff ff       	call   80102fc0 <kalloc>
801097c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801097ca:	83 ec 04             	sub    $0x4,%esp
801097cd:	68 00 10 00 00       	push   $0x1000
801097d2:	6a 00                	push   $0x0
801097d4:	ff 75 f4             	pushl  -0xc(%ebp)
801097d7:	e8 bc cf ff ff       	call   80106798 <memset>
801097dc:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801097df:	83 ec 0c             	sub    $0xc,%esp
801097e2:	ff 75 f4             	pushl  -0xc(%ebp)
801097e5:	e8 a3 f7 ff ff       	call   80108f8d <v2p>
801097ea:	83 c4 10             	add    $0x10,%esp
801097ed:	83 ec 0c             	sub    $0xc,%esp
801097f0:	6a 06                	push   $0x6
801097f2:	50                   	push   %eax
801097f3:	68 00 10 00 00       	push   $0x1000
801097f8:	6a 00                	push   $0x0
801097fa:	ff 75 08             	pushl  0x8(%ebp)
801097fd:	e8 ba fc ff ff       	call   801094bc <mappages>
80109802:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109805:	83 ec 04             	sub    $0x4,%esp
80109808:	ff 75 10             	pushl  0x10(%ebp)
8010980b:	ff 75 0c             	pushl  0xc(%ebp)
8010980e:	ff 75 f4             	pushl  -0xc(%ebp)
80109811:	e8 41 d0 ff ff       	call   80106857 <memmove>
80109816:	83 c4 10             	add    $0x10,%esp
}
80109819:	90                   	nop
8010981a:	c9                   	leave  
8010981b:	c3                   	ret    

8010981c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010981c:	55                   	push   %ebp
8010981d:	89 e5                	mov    %esp,%ebp
8010981f:	53                   	push   %ebx
80109820:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109823:	8b 45 0c             	mov    0xc(%ebp),%eax
80109826:	25 ff 0f 00 00       	and    $0xfff,%eax
8010982b:	85 c0                	test   %eax,%eax
8010982d:	74 0d                	je     8010983c <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010982f:	83 ec 0c             	sub    $0xc,%esp
80109832:	68 44 a5 10 80       	push   $0x8010a544
80109837:	e8 2a 6d ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010983c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109843:	e9 95 00 00 00       	jmp    801098dd <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109848:	8b 55 0c             	mov    0xc(%ebp),%edx
8010984b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010984e:	01 d0                	add    %edx,%eax
80109850:	83 ec 04             	sub    $0x4,%esp
80109853:	6a 00                	push   $0x0
80109855:	50                   	push   %eax
80109856:	ff 75 08             	pushl  0x8(%ebp)
80109859:	e8 be fb ff ff       	call   8010941c <walkpgdir>
8010985e:	83 c4 10             	add    $0x10,%esp
80109861:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109864:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109868:	75 0d                	jne    80109877 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010986a:	83 ec 0c             	sub    $0xc,%esp
8010986d:	68 67 a5 10 80       	push   $0x8010a567
80109872:	e8 ef 6c ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109877:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010987a:	8b 00                	mov    (%eax),%eax
8010987c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109881:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109884:	8b 45 18             	mov    0x18(%ebp),%eax
80109887:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010988a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010988f:	77 0b                	ja     8010989c <loaduvm+0x80>
      n = sz - i;
80109891:	8b 45 18             	mov    0x18(%ebp),%eax
80109894:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109897:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010989a:	eb 07                	jmp    801098a3 <loaduvm+0x87>
    else
      n = PGSIZE;
8010989c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801098a3:	8b 55 14             	mov    0x14(%ebp),%edx
801098a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098a9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801098ac:	83 ec 0c             	sub    $0xc,%esp
801098af:	ff 75 e8             	pushl  -0x18(%ebp)
801098b2:	e8 e3 f6 ff ff       	call   80108f9a <p2v>
801098b7:	83 c4 10             	add    $0x10,%esp
801098ba:	ff 75 f0             	pushl  -0x10(%ebp)
801098bd:	53                   	push   %ebx
801098be:	50                   	push   %eax
801098bf:	ff 75 10             	pushl  0x10(%ebp)
801098c2:	e8 f2 87 ff ff       	call   801020b9 <readi>
801098c7:	83 c4 10             	add    $0x10,%esp
801098ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801098cd:	74 07                	je     801098d6 <loaduvm+0xba>
      return -1;
801098cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801098d4:	eb 18                	jmp    801098ee <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801098d6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801098dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098e0:	3b 45 18             	cmp    0x18(%ebp),%eax
801098e3:	0f 82 5f ff ff ff    	jb     80109848 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801098e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801098ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801098f1:	c9                   	leave  
801098f2:	c3                   	ret    

801098f3 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801098f3:	55                   	push   %ebp
801098f4:	89 e5                	mov    %esp,%ebp
801098f6:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801098f9:	8b 45 10             	mov    0x10(%ebp),%eax
801098fc:	85 c0                	test   %eax,%eax
801098fe:	79 0a                	jns    8010990a <allocuvm+0x17>
    return 0;
80109900:	b8 00 00 00 00       	mov    $0x0,%eax
80109905:	e9 b0 00 00 00       	jmp    801099ba <allocuvm+0xc7>
  if(newsz < oldsz)
8010990a:	8b 45 10             	mov    0x10(%ebp),%eax
8010990d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109910:	73 08                	jae    8010991a <allocuvm+0x27>
    return oldsz;
80109912:	8b 45 0c             	mov    0xc(%ebp),%eax
80109915:	e9 a0 00 00 00       	jmp    801099ba <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010991a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010991d:	05 ff 0f 00 00       	add    $0xfff,%eax
80109922:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109927:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010992a:	eb 7f                	jmp    801099ab <allocuvm+0xb8>
    mem = kalloc();
8010992c:	e8 8f 96 ff ff       	call   80102fc0 <kalloc>
80109931:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109934:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109938:	75 2b                	jne    80109965 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010993a:	83 ec 0c             	sub    $0xc,%esp
8010993d:	68 85 a5 10 80       	push   $0x8010a585
80109942:	e8 7f 6a ff ff       	call   801003c6 <cprintf>
80109947:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010994a:	83 ec 04             	sub    $0x4,%esp
8010994d:	ff 75 0c             	pushl  0xc(%ebp)
80109950:	ff 75 10             	pushl  0x10(%ebp)
80109953:	ff 75 08             	pushl  0x8(%ebp)
80109956:	e8 61 00 00 00       	call   801099bc <deallocuvm>
8010995b:	83 c4 10             	add    $0x10,%esp
      return 0;
8010995e:	b8 00 00 00 00       	mov    $0x0,%eax
80109963:	eb 55                	jmp    801099ba <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109965:	83 ec 04             	sub    $0x4,%esp
80109968:	68 00 10 00 00       	push   $0x1000
8010996d:	6a 00                	push   $0x0
8010996f:	ff 75 f0             	pushl  -0x10(%ebp)
80109972:	e8 21 ce ff ff       	call   80106798 <memset>
80109977:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010997a:	83 ec 0c             	sub    $0xc,%esp
8010997d:	ff 75 f0             	pushl  -0x10(%ebp)
80109980:	e8 08 f6 ff ff       	call   80108f8d <v2p>
80109985:	83 c4 10             	add    $0x10,%esp
80109988:	89 c2                	mov    %eax,%edx
8010998a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010998d:	83 ec 0c             	sub    $0xc,%esp
80109990:	6a 06                	push   $0x6
80109992:	52                   	push   %edx
80109993:	68 00 10 00 00       	push   $0x1000
80109998:	50                   	push   %eax
80109999:	ff 75 08             	pushl  0x8(%ebp)
8010999c:	e8 1b fb ff ff       	call   801094bc <mappages>
801099a1:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801099a4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801099ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099ae:	3b 45 10             	cmp    0x10(%ebp),%eax
801099b1:	0f 82 75 ff ff ff    	jb     8010992c <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801099b7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801099ba:	c9                   	leave  
801099bb:	c3                   	ret    

801099bc <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801099bc:	55                   	push   %ebp
801099bd:	89 e5                	mov    %esp,%ebp
801099bf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801099c2:	8b 45 10             	mov    0x10(%ebp),%eax
801099c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801099c8:	72 08                	jb     801099d2 <deallocuvm+0x16>
    return oldsz;
801099ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801099cd:	e9 a5 00 00 00       	jmp    80109a77 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801099d2:	8b 45 10             	mov    0x10(%ebp),%eax
801099d5:	05 ff 0f 00 00       	add    $0xfff,%eax
801099da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801099df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801099e2:	e9 81 00 00 00       	jmp    80109a68 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801099e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099ea:	83 ec 04             	sub    $0x4,%esp
801099ed:	6a 00                	push   $0x0
801099ef:	50                   	push   %eax
801099f0:	ff 75 08             	pushl  0x8(%ebp)
801099f3:	e8 24 fa ff ff       	call   8010941c <walkpgdir>
801099f8:	83 c4 10             	add    $0x10,%esp
801099fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801099fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109a02:	75 09                	jne    80109a0d <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109a04:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109a0b:	eb 54                	jmp    80109a61 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a10:	8b 00                	mov    (%eax),%eax
80109a12:	83 e0 01             	and    $0x1,%eax
80109a15:	85 c0                	test   %eax,%eax
80109a17:	74 48                	je     80109a61 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a1c:	8b 00                	mov    (%eax),%eax
80109a1e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109a26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109a2a:	75 0d                	jne    80109a39 <deallocuvm+0x7d>
        panic("kfree");
80109a2c:	83 ec 0c             	sub    $0xc,%esp
80109a2f:	68 9d a5 10 80       	push   $0x8010a59d
80109a34:	e8 2d 6b ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109a39:	83 ec 0c             	sub    $0xc,%esp
80109a3c:	ff 75 ec             	pushl  -0x14(%ebp)
80109a3f:	e8 56 f5 ff ff       	call   80108f9a <p2v>
80109a44:	83 c4 10             	add    $0x10,%esp
80109a47:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109a4a:	83 ec 0c             	sub    $0xc,%esp
80109a4d:	ff 75 e8             	pushl  -0x18(%ebp)
80109a50:	e8 ce 94 ff ff       	call   80102f23 <kfree>
80109a55:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109a61:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a6b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109a6e:	0f 82 73 ff ff ff    	jb     801099e7 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109a74:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109a77:	c9                   	leave  
80109a78:	c3                   	ret    

80109a79 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109a79:	55                   	push   %ebp
80109a7a:	89 e5                	mov    %esp,%ebp
80109a7c:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109a83:	75 0d                	jne    80109a92 <freevm+0x19>
    panic("freevm: no pgdir");
80109a85:	83 ec 0c             	sub    $0xc,%esp
80109a88:	68 a3 a5 10 80       	push   $0x8010a5a3
80109a8d:	e8 d4 6a ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109a92:	83 ec 04             	sub    $0x4,%esp
80109a95:	6a 00                	push   $0x0
80109a97:	68 00 00 00 80       	push   $0x80000000
80109a9c:	ff 75 08             	pushl  0x8(%ebp)
80109a9f:	e8 18 ff ff ff       	call   801099bc <deallocuvm>
80109aa4:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109aa7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109aae:	eb 4f                	jmp    80109aff <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ab3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109aba:	8b 45 08             	mov    0x8(%ebp),%eax
80109abd:	01 d0                	add    %edx,%eax
80109abf:	8b 00                	mov    (%eax),%eax
80109ac1:	83 e0 01             	and    $0x1,%eax
80109ac4:	85 c0                	test   %eax,%eax
80109ac6:	74 33                	je     80109afb <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109acb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80109ad5:	01 d0                	add    %edx,%eax
80109ad7:	8b 00                	mov    (%eax),%eax
80109ad9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ade:	83 ec 0c             	sub    $0xc,%esp
80109ae1:	50                   	push   %eax
80109ae2:	e8 b3 f4 ff ff       	call   80108f9a <p2v>
80109ae7:	83 c4 10             	add    $0x10,%esp
80109aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109aed:	83 ec 0c             	sub    $0xc,%esp
80109af0:	ff 75 f0             	pushl  -0x10(%ebp)
80109af3:	e8 2b 94 ff ff       	call   80102f23 <kfree>
80109af8:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109afb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109aff:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109b06:	76 a8                	jbe    80109ab0 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109b08:	83 ec 0c             	sub    $0xc,%esp
80109b0b:	ff 75 08             	pushl  0x8(%ebp)
80109b0e:	e8 10 94 ff ff       	call   80102f23 <kfree>
80109b13:	83 c4 10             	add    $0x10,%esp
}
80109b16:	90                   	nop
80109b17:	c9                   	leave  
80109b18:	c3                   	ret    

80109b19 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109b19:	55                   	push   %ebp
80109b1a:	89 e5                	mov    %esp,%ebp
80109b1c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109b1f:	83 ec 04             	sub    $0x4,%esp
80109b22:	6a 00                	push   $0x0
80109b24:	ff 75 0c             	pushl  0xc(%ebp)
80109b27:	ff 75 08             	pushl  0x8(%ebp)
80109b2a:	e8 ed f8 ff ff       	call   8010941c <walkpgdir>
80109b2f:	83 c4 10             	add    $0x10,%esp
80109b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109b39:	75 0d                	jne    80109b48 <clearpteu+0x2f>
    panic("clearpteu");
80109b3b:	83 ec 0c             	sub    $0xc,%esp
80109b3e:	68 b4 a5 10 80       	push   $0x8010a5b4
80109b43:	e8 1e 6a ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b4b:	8b 00                	mov    (%eax),%eax
80109b4d:	83 e0 fb             	and    $0xfffffffb,%eax
80109b50:	89 c2                	mov    %eax,%edx
80109b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b55:	89 10                	mov    %edx,(%eax)
}
80109b57:	90                   	nop
80109b58:	c9                   	leave  
80109b59:	c3                   	ret    

80109b5a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109b5a:	55                   	push   %ebp
80109b5b:	89 e5                	mov    %esp,%ebp
80109b5d:	53                   	push   %ebx
80109b5e:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109b61:	e8 e6 f9 ff ff       	call   8010954c <setupkvm>
80109b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109b69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109b6d:	75 0a                	jne    80109b79 <copyuvm+0x1f>
    return 0;
80109b6f:	b8 00 00 00 00       	mov    $0x0,%eax
80109b74:	e9 f8 00 00 00       	jmp    80109c71 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109b80:	e9 c4 00 00 00       	jmp    80109c49 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b88:	83 ec 04             	sub    $0x4,%esp
80109b8b:	6a 00                	push   $0x0
80109b8d:	50                   	push   %eax
80109b8e:	ff 75 08             	pushl  0x8(%ebp)
80109b91:	e8 86 f8 ff ff       	call   8010941c <walkpgdir>
80109b96:	83 c4 10             	add    $0x10,%esp
80109b99:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109b9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109ba0:	75 0d                	jne    80109baf <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109ba2:	83 ec 0c             	sub    $0xc,%esp
80109ba5:	68 be a5 10 80       	push   $0x8010a5be
80109baa:	e8 b7 69 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109bb2:	8b 00                	mov    (%eax),%eax
80109bb4:	83 e0 01             	and    $0x1,%eax
80109bb7:	85 c0                	test   %eax,%eax
80109bb9:	75 0d                	jne    80109bc8 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109bbb:	83 ec 0c             	sub    $0xc,%esp
80109bbe:	68 d8 a5 10 80       	push   $0x8010a5d8
80109bc3:	e8 9e 69 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109bcb:	8b 00                	mov    (%eax),%eax
80109bcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109bd8:	8b 00                	mov    (%eax),%eax
80109bda:	25 ff 0f 00 00       	and    $0xfff,%eax
80109bdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109be2:	e8 d9 93 ff ff       	call   80102fc0 <kalloc>
80109be7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109bea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109bee:	74 6a                	je     80109c5a <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109bf0:	83 ec 0c             	sub    $0xc,%esp
80109bf3:	ff 75 e8             	pushl  -0x18(%ebp)
80109bf6:	e8 9f f3 ff ff       	call   80108f9a <p2v>
80109bfb:	83 c4 10             	add    $0x10,%esp
80109bfe:	83 ec 04             	sub    $0x4,%esp
80109c01:	68 00 10 00 00       	push   $0x1000
80109c06:	50                   	push   %eax
80109c07:	ff 75 e0             	pushl  -0x20(%ebp)
80109c0a:	e8 48 cc ff ff       	call   80106857 <memmove>
80109c0f:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109c12:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109c15:	83 ec 0c             	sub    $0xc,%esp
80109c18:	ff 75 e0             	pushl  -0x20(%ebp)
80109c1b:	e8 6d f3 ff ff       	call   80108f8d <v2p>
80109c20:	83 c4 10             	add    $0x10,%esp
80109c23:	89 c2                	mov    %eax,%edx
80109c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c28:	83 ec 0c             	sub    $0xc,%esp
80109c2b:	53                   	push   %ebx
80109c2c:	52                   	push   %edx
80109c2d:	68 00 10 00 00       	push   $0x1000
80109c32:	50                   	push   %eax
80109c33:	ff 75 f0             	pushl  -0x10(%ebp)
80109c36:	e8 81 f8 ff ff       	call   801094bc <mappages>
80109c3b:	83 c4 20             	add    $0x20,%esp
80109c3e:	85 c0                	test   %eax,%eax
80109c40:	78 1b                	js     80109c5d <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109c42:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c4c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c4f:	0f 82 30 ff ff ff    	jb     80109b85 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c58:	eb 17                	jmp    80109c71 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109c5a:	90                   	nop
80109c5b:	eb 01                	jmp    80109c5e <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109c5d:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109c5e:	83 ec 0c             	sub    $0xc,%esp
80109c61:	ff 75 f0             	pushl  -0x10(%ebp)
80109c64:	e8 10 fe ff ff       	call   80109a79 <freevm>
80109c69:	83 c4 10             	add    $0x10,%esp
  return 0;
80109c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109c74:	c9                   	leave  
80109c75:	c3                   	ret    

80109c76 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109c76:	55                   	push   %ebp
80109c77:	89 e5                	mov    %esp,%ebp
80109c79:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109c7c:	83 ec 04             	sub    $0x4,%esp
80109c7f:	6a 00                	push   $0x0
80109c81:	ff 75 0c             	pushl  0xc(%ebp)
80109c84:	ff 75 08             	pushl  0x8(%ebp)
80109c87:	e8 90 f7 ff ff       	call   8010941c <walkpgdir>
80109c8c:	83 c4 10             	add    $0x10,%esp
80109c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c95:	8b 00                	mov    (%eax),%eax
80109c97:	83 e0 01             	and    $0x1,%eax
80109c9a:	85 c0                	test   %eax,%eax
80109c9c:	75 07                	jne    80109ca5 <uva2ka+0x2f>
    return 0;
80109c9e:	b8 00 00 00 00       	mov    $0x0,%eax
80109ca3:	eb 29                	jmp    80109cce <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ca8:	8b 00                	mov    (%eax),%eax
80109caa:	83 e0 04             	and    $0x4,%eax
80109cad:	85 c0                	test   %eax,%eax
80109caf:	75 07                	jne    80109cb8 <uva2ka+0x42>
    return 0;
80109cb1:	b8 00 00 00 00       	mov    $0x0,%eax
80109cb6:	eb 16                	jmp    80109cce <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cbb:	8b 00                	mov    (%eax),%eax
80109cbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109cc2:	83 ec 0c             	sub    $0xc,%esp
80109cc5:	50                   	push   %eax
80109cc6:	e8 cf f2 ff ff       	call   80108f9a <p2v>
80109ccb:	83 c4 10             	add    $0x10,%esp
}
80109cce:	c9                   	leave  
80109ccf:	c3                   	ret    

80109cd0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109cd0:	55                   	push   %ebp
80109cd1:	89 e5                	mov    %esp,%ebp
80109cd3:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109cd6:	8b 45 10             	mov    0x10(%ebp),%eax
80109cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109cdc:	eb 7f                	jmp    80109d5d <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109cde:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ce1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109cec:	83 ec 08             	sub    $0x8,%esp
80109cef:	50                   	push   %eax
80109cf0:	ff 75 08             	pushl  0x8(%ebp)
80109cf3:	e8 7e ff ff ff       	call   80109c76 <uva2ka>
80109cf8:	83 c4 10             	add    $0x10,%esp
80109cfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109cfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109d02:	75 07                	jne    80109d0b <copyout+0x3b>
      return -1;
80109d04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109d09:	eb 61                	jmp    80109d6c <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d0e:	2b 45 0c             	sub    0xc(%ebp),%eax
80109d11:	05 00 10 00 00       	add    $0x1000,%eax
80109d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d1c:	3b 45 14             	cmp    0x14(%ebp),%eax
80109d1f:	76 06                	jbe    80109d27 <copyout+0x57>
      n = len;
80109d21:	8b 45 14             	mov    0x14(%ebp),%eax
80109d24:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109d27:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d2a:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109d2d:	89 c2                	mov    %eax,%edx
80109d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109d32:	01 d0                	add    %edx,%eax
80109d34:	83 ec 04             	sub    $0x4,%esp
80109d37:	ff 75 f0             	pushl  -0x10(%ebp)
80109d3a:	ff 75 f4             	pushl  -0xc(%ebp)
80109d3d:	50                   	push   %eax
80109d3e:	e8 14 cb ff ff       	call   80106857 <memmove>
80109d43:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d49:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d4f:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109d55:	05 00 10 00 00       	add    $0x1000,%eax
80109d5a:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109d5d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109d61:	0f 85 77 ff ff ff    	jne    80109cde <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109d6c:	c9                   	leave  
80109d6d:	c3                   	ret    
