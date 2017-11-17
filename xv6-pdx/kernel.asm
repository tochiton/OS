
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
80100028:	bc 70 e6 10 80       	mov    $0x8010e670,%esp

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
8010003d:	68 90 99 10 80       	push   $0x80109990
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 12 62 00 00       	call   8010625e <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 25 11 80 84 	movl   $0x80112584,0x80112590
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 25 11 80 84 	movl   $0x80112584,0x80112594
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 25 11 80       	mov    0x80112594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 25 11 80       	mov    %eax,0x80112594
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 25 11 80       	mov    $0x80112584,%eax
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
801000bc:	68 80 e6 10 80       	push   $0x8010e680
801000c1:	e8 ba 61 00 00       	call   80106280 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 25 11 80       	mov    0x80112594,%eax
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
80100107:	68 80 e6 10 80       	push   $0x8010e680
8010010c:	e8 d6 61 00 00       	call   801062e7 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 82 52 00 00       	call   801053ae <sleep>
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
8010013a:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 25 11 80       	mov    0x80112590,%eax
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
80100183:	68 80 e6 10 80       	push   $0x8010e680
80100188:	e8 5a 61 00 00       	call   801062e7 <release>
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
8010019e:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 97 99 10 80       	push   $0x80109997
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
80100204:	68 a8 99 10 80       	push   $0x801099a8
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
80100243:	68 af 99 10 80       	push   $0x801099af
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 26 60 00 00       	call   80106280 <acquire>
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
8010027b:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 25 11 80       	mov    0x80112594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 25 11 80       	mov    %eax,0x80112594

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
801002b9:	e8 21 53 00 00       	call   801055df <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 19 60 00 00       	call   801062e7 <release>
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
801003cc:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 d5 10 80       	push   $0x8010d5e0
801003e2:	e8 99 5e 00 00       	call   80106280 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 b6 99 10 80       	push   $0x801099b6
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
801004cd:	c7 45 ec bf 99 10 80 	movl   $0x801099bf,-0x14(%ebp)
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
80100556:	68 e0 d5 10 80       	push   $0x8010d5e0
8010055b:	e8 87 5d 00 00       	call   801062e7 <release>
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
80100571:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 c6 99 10 80       	push   $0x801099c6
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
801005aa:	68 d5 99 10 80       	push   $0x801099d5
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 72 5d 00 00       	call   80106339 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 d7 99 10 80       	push   $0x801099d7
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
801005f5:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
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
801006ca:	68 db 99 10 80       	push   $0x801099db
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
801006f7:	e8 a6 5e 00 00       	call   801065a2 <memmove>
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
80100721:	e8 bd 5d 00 00       	call   801064e3 <memset>
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
80100798:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
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
801007b6:	e8 5b 78 00 00       	call   80108016 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 4e 78 00 00       	call   80108016 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 41 78 00 00       	call   80108016 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 31 78 00 00       	call   80108016 <uartputc>
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
8010082c:	68 e0 d5 10 80       	push   $0x8010d5e0
80100831:	e8 4a 5a 00 00       	call   80106280 <acquire>
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
801008c6:	a1 28 28 11 80       	mov    0x80112828,%eax
801008cb:	83 e8 01             	sub    $0x1,%eax
801008ce:	a3 28 28 11 80       	mov    %eax,0x80112828
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
801008e3:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008e9:	a1 24 28 11 80       	mov    0x80112824,%eax
801008ee:	39 c2                	cmp    %eax,%edx
801008f0:	0f 84 e2 00 00 00    	je     801009d8 <consoleintr+0x1df>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f6:	a1 28 28 11 80       	mov    0x80112828,%eax
801008fb:	83 e8 01             	sub    $0x1,%eax
801008fe:	83 e0 7f             	and    $0x7f,%eax
80100901:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
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
80100911:	8b 15 28 28 11 80    	mov    0x80112828,%edx
80100917:	a1 24 28 11 80       	mov    0x80112824,%eax
8010091c:	39 c2                	cmp    %eax,%edx
8010091e:	0f 84 b4 00 00 00    	je     801009d8 <consoleintr+0x1df>
        input.e--;
80100924:	a1 28 28 11 80       	mov    0x80112828,%eax
80100929:	83 e8 01             	sub    $0x1,%eax
8010092c:	a3 28 28 11 80       	mov    %eax,0x80112828
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
80100950:	8b 15 28 28 11 80    	mov    0x80112828,%edx
80100956:	a1 20 28 11 80       	mov    0x80112820,%eax
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
80100977:	a1 28 28 11 80       	mov    0x80112828,%eax
8010097c:	8d 50 01             	lea    0x1(%eax),%edx
8010097f:	89 15 28 28 11 80    	mov    %edx,0x80112828
80100985:	83 e0 7f             	and    $0x7f,%eax
80100988:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010098b:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
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
801009ab:	a1 28 28 11 80       	mov    0x80112828,%eax
801009b0:	8b 15 20 28 11 80    	mov    0x80112820,%edx
801009b6:	83 ea 80             	sub    $0xffffff80,%edx
801009b9:	39 d0                	cmp    %edx,%eax
801009bb:	75 1a                	jne    801009d7 <consoleintr+0x1de>
          input.w = input.e;
801009bd:	a1 28 28 11 80       	mov    0x80112828,%eax
801009c2:	a3 24 28 11 80       	mov    %eax,0x80112824
          wakeup(&input.r);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 28 11 80       	push   $0x80112820
801009cf:	e8 0b 4c 00 00       	call   801055df <wakeup>
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
801009ed:	68 e0 d5 10 80       	push   $0x8010d5e0
801009f2:	e8 f0 58 00 00       	call   801062e7 <release>
801009f7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009fe:	74 05                	je     80100a05 <consoleintr+0x20c>
    procdump();  // now call procdump() wo. cons.lock held
80100a00:	e8 dc 4c 00 00       	call   801056e1 <procdump>
  }
  if(printPidList){
80100a05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a09:	74 05                	je     80100a10 <consoleintr+0x217>
    printPidReadyList();
80100a0b:	e8 6a 54 00 00       	call   80105e7a <printPidReadyList>
  }
   if(doPrintCount){
80100a10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a14:	74 05                	je     80100a1b <consoleintr+0x222>
    countFreeList();
80100a16:	e8 15 55 00 00       	call   80105f30 <countFreeList>
  }
  if(doPrintSleepList){
80100a1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a1f:	74 05                	je     80100a26 <consoleintr+0x22d>
    printPidSleepList();
80100a21:	e8 6d 55 00 00       	call   80105f93 <printPidSleepList>
  }
  if(doPrintZombieList){
80100a26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2a:	74 05                	je     80100a31 <consoleintr+0x238>
    printZombieList();
80100a2c:	e8 ce 55 00 00       	call   80105fff <printZombieList>
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
80100a51:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a56:	e8 25 58 00 00       	call   80106280 <acquire>
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
80100a73:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a78:	e8 6a 58 00 00       	call   801062e7 <release>
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
80100a9b:	68 e0 d5 10 80       	push   $0x8010d5e0
80100aa0:	68 20 28 11 80       	push   $0x80112820
80100aa5:	e8 04 49 00 00       	call   801053ae <sleep>
80100aaa:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aad:	8b 15 20 28 11 80    	mov    0x80112820,%edx
80100ab3:	a1 24 28 11 80       	mov    0x80112824,%eax
80100ab8:	39 c2                	cmp    %eax,%edx
80100aba:	74 a7                	je     80100a63 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100abc:	a1 20 28 11 80       	mov    0x80112820,%eax
80100ac1:	8d 50 01             	lea    0x1(%eax),%edx
80100ac4:	89 15 20 28 11 80    	mov    %edx,0x80112820
80100aca:	83 e0 7f             	and    $0x7f,%eax
80100acd:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
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
80100ae8:	a1 20 28 11 80       	mov    0x80112820,%eax
80100aed:	83 e8 01             	sub    $0x1,%eax
80100af0:	a3 20 28 11 80       	mov    %eax,0x80112820
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
80100b1e:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b23:	e8 bf 57 00 00       	call   801062e7 <release>
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
80100b5c:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b61:	e8 1a 57 00 00       	call   80106280 <acquire>
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
80100b9e:	68 e0 d5 10 80       	push   $0x8010d5e0
80100ba3:	e8 3f 57 00 00       	call   801062e7 <release>
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
80100bc7:	68 ee 99 10 80       	push   $0x801099ee
80100bcc:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bd1:	e8 88 56 00 00       	call   8010625e <initlock>
80100bd6:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd9:	c7 05 ec 31 11 80 45 	movl   $0x80100b45,0x801131ec
80100be0:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be3:	c7 05 e8 31 11 80 34 	movl   $0x80100a34,0x801131e8
80100bea:	0a 10 80 
  cons.locking = 1;
80100bed:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
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
80100c8f:	e8 d7 84 00 00       	call   8010916b <setupkvm>
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
80100d15:	e8 f8 87 00 00       	call   80109512 <allocuvm>
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
80100d48:	e8 ee 86 00 00       	call   8010943b <loaduvm>
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
80100db7:	e8 56 87 00 00       	call   80109512 <allocuvm>
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
80100ddb:	e8 58 89 00 00       	call   80109738 <clearpteu>
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
80100e14:	e8 17 59 00 00       	call   80106730 <strlen>
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
80100e41:	e8 ea 58 00 00       	call   80106730 <strlen>
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
80100e67:	e8 83 8a 00 00       	call   801098ef <copyout>
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
80100f03:	e8 e7 89 00 00       	call   801098ef <copyout>
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
80100f54:	e8 8d 57 00 00       	call   801066e6 <safestrcpy>
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
80100faa:	e8 a3 82 00 00       	call   80109252 <switchuvm>
80100faf:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb8:	e8 db 86 00 00       	call   80109698 <freevm>
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
80100ff2:	e8 a1 86 00 00       	call   80109698 <freevm>
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
80101023:	68 f6 99 10 80       	push   $0x801099f6
80101028:	68 40 28 11 80       	push   $0x80112840
8010102d:	e8 2c 52 00 00       	call   8010625e <initlock>
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
80101041:	68 40 28 11 80       	push   $0x80112840
80101046:	e8 35 52 00 00       	call   80106280 <acquire>
8010104b:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010104e:	c7 45 f4 74 28 11 80 	movl   $0x80112874,-0xc(%ebp)
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
8010106e:	68 40 28 11 80       	push   $0x80112840
80101073:	e8 6f 52 00 00       	call   801062e7 <release>
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
80101084:	b8 d4 31 11 80       	mov    $0x801131d4,%eax
80101089:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010108c:	72 c9                	jb     80101057 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010108e:	83 ec 0c             	sub    $0xc,%esp
80101091:	68 40 28 11 80       	push   $0x80112840
80101096:	e8 4c 52 00 00       	call   801062e7 <release>
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
801010ae:	68 40 28 11 80       	push   $0x80112840
801010b3:	e8 c8 51 00 00       	call   80106280 <acquire>
801010b8:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010bb:	8b 45 08             	mov    0x8(%ebp),%eax
801010be:	8b 40 04             	mov    0x4(%eax),%eax
801010c1:	85 c0                	test   %eax,%eax
801010c3:	7f 0d                	jg     801010d2 <filedup+0x2d>
    panic("filedup");
801010c5:	83 ec 0c             	sub    $0xc,%esp
801010c8:	68 fd 99 10 80       	push   $0x801099fd
801010cd:	e8 94 f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d2:	8b 45 08             	mov    0x8(%ebp),%eax
801010d5:	8b 40 04             	mov    0x4(%eax),%eax
801010d8:	8d 50 01             	lea    0x1(%eax),%edx
801010db:	8b 45 08             	mov    0x8(%ebp),%eax
801010de:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 40 28 11 80       	push   $0x80112840
801010e9:	e8 f9 51 00 00       	call   801062e7 <release>
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
801010ff:	68 40 28 11 80       	push   $0x80112840
80101104:	e8 77 51 00 00       	call   80106280 <acquire>
80101109:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010110c:	8b 45 08             	mov    0x8(%ebp),%eax
8010110f:	8b 40 04             	mov    0x4(%eax),%eax
80101112:	85 c0                	test   %eax,%eax
80101114:	7f 0d                	jg     80101123 <fileclose+0x2d>
    panic("fileclose");
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	68 05 9a 10 80       	push   $0x80109a05
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
8010113f:	68 40 28 11 80       	push   $0x80112840
80101144:	e8 9e 51 00 00       	call   801062e7 <release>
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
8010118d:	68 40 28 11 80       	push   $0x80112840
80101192:	e8 50 51 00 00       	call   801062e7 <release>
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
801012e1:	68 0f 9a 10 80       	push   $0x80109a0f
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
801013e4:	68 18 9a 10 80       	push   $0x80109a18
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
8010141a:	68 28 9a 10 80       	push   $0x80109a28
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
80101452:	e8 4b 51 00 00       	call   801065a2 <memmove>
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
80101498:	e8 46 50 00 00       	call   801064e3 <memset>
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
801014eb:	a1 58 32 11 80       	mov    0x80113258,%eax
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
801015c9:	a1 40 32 11 80       	mov    0x80113240,%eax
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
801015eb:	8b 15 40 32 11 80    	mov    0x80113240,%edx
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
801015ff:	68 34 9a 10 80       	push   $0x80109a34
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
80101614:	68 40 32 11 80       	push   $0x80113240
80101619:	ff 75 08             	pushl  0x8(%ebp)
8010161c:	e8 08 fe ff ff       	call   80101429 <readsb>
80101621:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101624:	8b 45 0c             	mov    0xc(%ebp),%eax
80101627:	c1 e8 0c             	shr    $0xc,%eax
8010162a:	89 c2                	mov    %eax,%edx
8010162c:	a1 58 32 11 80       	mov    0x80113258,%eax
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
80101692:	68 4a 9a 10 80       	push   $0x80109a4a
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
801016ef:	68 5d 9a 10 80       	push   $0x80109a5d
801016f4:	68 60 32 11 80       	push   $0x80113260
801016f9:	e8 60 4b 00 00       	call   8010625e <initlock>
801016fe:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101701:	83 ec 08             	sub    $0x8,%esp
80101704:	68 40 32 11 80       	push   $0x80113240
80101709:	ff 75 08             	pushl  0x8(%ebp)
8010170c:	e8 18 fd ff ff       	call   80101429 <readsb>
80101711:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101714:	a1 58 32 11 80       	mov    0x80113258,%eax
80101719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010171c:	8b 3d 54 32 11 80    	mov    0x80113254,%edi
80101722:	8b 35 50 32 11 80    	mov    0x80113250,%esi
80101728:	8b 1d 4c 32 11 80    	mov    0x8011324c,%ebx
8010172e:	8b 0d 48 32 11 80    	mov    0x80113248,%ecx
80101734:	8b 15 44 32 11 80    	mov    0x80113244,%edx
8010173a:	a1 40 32 11 80       	mov    0x80113240,%eax
8010173f:	ff 75 e4             	pushl  -0x1c(%ebp)
80101742:	57                   	push   %edi
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	51                   	push   %ecx
80101746:	52                   	push   %edx
80101747:	50                   	push   %eax
80101748:	68 64 9a 10 80       	push   $0x80109a64
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
8010177f:	a1 54 32 11 80       	mov    0x80113254,%eax
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
801017c1:	e8 1d 4d 00 00       	call   801064e3 <memset>
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
80101815:	8b 15 48 32 11 80    	mov    0x80113248,%edx
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
80101829:	68 b7 9a 10 80       	push   $0x80109ab7
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
80101846:	a1 54 32 11 80       	mov    0x80113254,%eax
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
801018cf:	e8 ce 4c 00 00       	call   801065a2 <memmove>
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
801018ff:	68 60 32 11 80       	push   $0x80113260
80101904:	e8 77 49 00 00       	call   80106280 <acquire>
80101909:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010190c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101913:	c7 45 f4 94 32 11 80 	movl   $0x80113294,-0xc(%ebp)
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
8010194d:	68 60 32 11 80       	push   $0x80113260
80101952:	e8 90 49 00 00       	call   801062e7 <release>
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
80101979:	81 7d f4 34 42 11 80 	cmpl   $0x80114234,-0xc(%ebp)
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
8010198b:	68 c9 9a 10 80       	push   $0x80109ac9
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
801019c3:	68 60 32 11 80       	push   $0x80113260
801019c8:	e8 1a 49 00 00       	call   801062e7 <release>
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
801019de:	68 60 32 11 80       	push   $0x80113260
801019e3:	e8 98 48 00 00       	call   80106280 <acquire>
801019e8:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019eb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ee:	8b 40 08             	mov    0x8(%eax),%eax
801019f1:	8d 50 01             	lea    0x1(%eax),%edx
801019f4:	8b 45 08             	mov    0x8(%ebp),%eax
801019f7:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019fa:	83 ec 0c             	sub    $0xc,%esp
801019fd:	68 60 32 11 80       	push   $0x80113260
80101a02:	e8 e0 48 00 00       	call   801062e7 <release>
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
80101a28:	68 d9 9a 10 80       	push   $0x80109ad9
80101a2d:	e8 34 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a32:	83 ec 0c             	sub    $0xc,%esp
80101a35:	68 60 32 11 80       	push   $0x80113260
80101a3a:	e8 41 48 00 00       	call   80106280 <acquire>
80101a3f:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a42:	eb 13                	jmp    80101a57 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a44:	83 ec 08             	sub    $0x8,%esp
80101a47:	68 60 32 11 80       	push   $0x80113260
80101a4c:	ff 75 08             	pushl  0x8(%ebp)
80101a4f:	e8 5a 39 00 00       	call   801053ae <sleep>
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
80101a78:	68 60 32 11 80       	push   $0x80113260
80101a7d:	e8 65 48 00 00       	call   801062e7 <release>
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
80101aa1:	a1 54 32 11 80       	mov    0x80113254,%eax
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
80101b2a:	e8 73 4a 00 00       	call   801065a2 <memmove>
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
80101b60:	68 df 9a 10 80       	push   $0x80109adf
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
80101b93:	68 ee 9a 10 80       	push   $0x80109aee
80101b98:	e8 c9 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b9d:	83 ec 0c             	sub    $0xc,%esp
80101ba0:	68 60 32 11 80       	push   $0x80113260
80101ba5:	e8 d6 46 00 00       	call   80106280 <acquire>
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
80101bc4:	e8 16 3a 00 00       	call   801055df <wakeup>
80101bc9:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bcc:	83 ec 0c             	sub    $0xc,%esp
80101bcf:	68 60 32 11 80       	push   $0x80113260
80101bd4:	e8 0e 47 00 00       	call   801062e7 <release>
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
80101be8:	68 60 32 11 80       	push   $0x80113260
80101bed:	e8 8e 46 00 00       	call   80106280 <acquire>
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
80101c35:	68 f6 9a 10 80       	push   $0x80109af6
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
80101c53:	68 60 32 11 80       	push   $0x80113260
80101c58:	e8 8a 46 00 00       	call   801062e7 <release>
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
80101c88:	68 60 32 11 80       	push   $0x80113260
80101c8d:	e8 ee 45 00 00       	call   80106280 <acquire>
80101c92:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c95:	8b 45 08             	mov    0x8(%ebp),%eax
80101c98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	ff 75 08             	pushl  0x8(%ebp)
80101ca5:	e8 35 39 00 00       	call   801055df <wakeup>
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
80101cbf:	68 60 32 11 80       	push   $0x80113260
80101cc4:	e8 1e 46 00 00       	call   801062e7 <release>
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
80101e04:	68 00 9b 10 80       	push   $0x80109b00
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
80101fb1:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fb8:	85 c0                	test   %eax,%eax
80101fba:	75 0a                	jne    80101fc6 <readi+0x49>
      return -1;
80101fbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc1:	e9 0c 01 00 00       	jmp    801020d2 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fcd:	98                   	cwtl   
80101fce:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
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
8010209b:	e8 02 45 00 00       	call   801065a2 <memmove>
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
80102108:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
8010210f:	85 c0                	test   %eax,%eax
80102111:	75 0a                	jne    8010211d <writei+0x49>
      return -1;
80102113:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102118:	e9 3d 01 00 00       	jmp    8010225a <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010211d:	8b 45 08             	mov    0x8(%ebp),%eax
80102120:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102124:	98                   	cwtl   
80102125:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
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
801021ed:	e8 b0 43 00 00       	call   801065a2 <memmove>
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
8010226d:	e8 c6 43 00 00       	call   80106638 <strncmp>
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
8010228d:	68 13 9b 10 80       	push   $0x80109b13
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
801022bc:	68 25 9b 10 80       	push   $0x80109b25
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
80102391:	68 25 9b 10 80       	push   $0x80109b25
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
801023cc:	e8 bd 42 00 00       	call   8010668e <strncpy>
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
801023f8:	68 32 9b 10 80       	push   $0x80109b32
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
8010246e:	e8 2f 41 00 00       	call   801065a2 <memmove>
80102473:	83 c4 10             	add    $0x10,%esp
80102476:	eb 26                	jmp    8010249e <skipelem+0x95>
  else {
    memmove(name, s, len);
80102478:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010247b:	83 ec 04             	sub    $0x4,%esp
8010247e:	50                   	push   %eax
8010247f:	ff 75 f4             	pushl  -0xc(%ebp)
80102482:	ff 75 0c             	pushl  0xc(%ebp)
80102485:	e8 18 41 00 00       	call   801065a2 <memmove>
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
801026da:	68 3a 9b 10 80       	push   $0x80109b3a
801026df:	68 20 d6 10 80       	push   $0x8010d620
801026e4:	e8 75 3b 00 00       	call   8010625e <initlock>
801026e9:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026ec:	83 ec 0c             	sub    $0xc,%esp
801026ef:	6a 0e                	push   $0xe
801026f1:	e8 da 18 00 00       	call   80103fd0 <picenable>
801026f6:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026f9:	a1 60 49 11 80       	mov    0x80114960,%eax
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
8010274e:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
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
8010278e:	68 3e 9b 10 80       	push   $0x80109b3e
80102793:	e8 ce dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102798:	8b 45 08             	mov    0x8(%ebp),%eax
8010279b:	8b 40 08             	mov    0x8(%eax),%eax
8010279e:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027a3:	76 0d                	jbe    801027b2 <idestart+0x33>
    panic("incorrect blockno");
801027a5:	83 ec 0c             	sub    $0xc,%esp
801027a8:	68 47 9b 10 80       	push   $0x80109b47
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
801027d1:	68 3e 9b 10 80       	push   $0x80109b3e
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
801028e6:	68 20 d6 10 80       	push   $0x8010d620
801028eb:	e8 90 39 00 00       	call   80106280 <acquire>
801028f0:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028f3:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028ff:	75 15                	jne    80102916 <ideintr+0x39>
    release(&idelock);
80102901:	83 ec 0c             	sub    $0xc,%esp
80102904:	68 20 d6 10 80       	push   $0x8010d620
80102909:	e8 d9 39 00 00       	call   801062e7 <release>
8010290e:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102911:	e9 9a 00 00 00       	jmp    801029b0 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102919:	8b 40 14             	mov    0x14(%eax),%eax
8010291c:	a3 54 d6 10 80       	mov    %eax,0x8010d654

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
8010297e:	e8 5c 2c 00 00       	call   801055df <wakeup>
80102983:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102986:	a1 54 d6 10 80       	mov    0x8010d654,%eax
8010298b:	85 c0                	test   %eax,%eax
8010298d:	74 11                	je     801029a0 <ideintr+0xc3>
    idestart(idequeue);
8010298f:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102994:	83 ec 0c             	sub    $0xc,%esp
80102997:	50                   	push   %eax
80102998:	e8 e2 fd ff ff       	call   8010277f <idestart>
8010299d:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	68 20 d6 10 80       	push   $0x8010d620
801029a8:	e8 3a 39 00 00       	call   801062e7 <release>
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
801029c7:	68 59 9b 10 80       	push   $0x80109b59
801029cc:	e8 95 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d1:	8b 45 08             	mov    0x8(%ebp),%eax
801029d4:	8b 00                	mov    (%eax),%eax
801029d6:	83 e0 06             	and    $0x6,%eax
801029d9:	83 f8 02             	cmp    $0x2,%eax
801029dc:	75 0d                	jne    801029eb <iderw+0x39>
    panic("iderw: nothing to do");
801029de:	83 ec 0c             	sub    $0xc,%esp
801029e1:	68 6d 9b 10 80       	push   $0x80109b6d
801029e6:	e8 7b db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029eb:	8b 45 08             	mov    0x8(%ebp),%eax
801029ee:	8b 40 04             	mov    0x4(%eax),%eax
801029f1:	85 c0                	test   %eax,%eax
801029f3:	74 16                	je     80102a0b <iderw+0x59>
801029f5:	a1 58 d6 10 80       	mov    0x8010d658,%eax
801029fa:	85 c0                	test   %eax,%eax
801029fc:	75 0d                	jne    80102a0b <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029fe:	83 ec 0c             	sub    $0xc,%esp
80102a01:	68 82 9b 10 80       	push   $0x80109b82
80102a06:	e8 5b db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a0b:	83 ec 0c             	sub    $0xc,%esp
80102a0e:	68 20 d6 10 80       	push   $0x8010d620
80102a13:	e8 68 38 00 00       	call   80106280 <acquire>
80102a18:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a25:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
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
80102a4a:	a1 54 d6 10 80       	mov    0x8010d654,%eax
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
80102a67:	68 20 d6 10 80       	push   $0x8010d620
80102a6c:	ff 75 08             	pushl  0x8(%ebp)
80102a6f:	e8 3a 29 00 00       	call   801053ae <sleep>
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
80102a87:	68 20 d6 10 80       	push   $0x8010d620
80102a8c:	e8 56 38 00 00       	call   801062e7 <release>
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
80102a9a:	a1 34 42 11 80       	mov    0x80114234,%eax
80102a9f:	8b 55 08             	mov    0x8(%ebp),%edx
80102aa2:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102aa4:	a1 34 42 11 80       	mov    0x80114234,%eax
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
80102ab1:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ab6:	8b 55 08             	mov    0x8(%ebp),%edx
80102ab9:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102abb:	a1 34 42 11 80       	mov    0x80114234,%eax
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
80102acf:	a1 64 43 11 80       	mov    0x80114364,%eax
80102ad4:	85 c0                	test   %eax,%eax
80102ad6:	0f 84 a0 00 00 00    	je     80102b7c <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102adc:	c7 05 34 42 11 80 00 	movl   $0xfec00000,0x80114234
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
80102b0b:	0f b6 05 60 43 11 80 	movzbl 0x80114360,%eax
80102b12:	0f b6 c0             	movzbl %al,%eax
80102b15:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b18:	74 10                	je     80102b2a <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b1a:	83 ec 0c             	sub    $0xc,%esp
80102b1d:	68 a0 9b 10 80       	push   $0x80109ba0
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
80102b82:	a1 64 43 11 80       	mov    0x80114364,%eax
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
80102bdd:	68 d2 9b 10 80       	push   $0x80109bd2
80102be2:	68 40 42 11 80       	push   $0x80114240
80102be7:	e8 72 36 00 00       	call   8010625e <initlock>
80102bec:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bef:	c7 05 74 42 11 80 00 	movl   $0x0,0x80114274
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
80102c24:	c7 05 74 42 11 80 01 	movl   $0x1,0x80114274
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
80102c80:	81 7d 08 5c 79 11 80 	cmpl   $0x8011795c,0x8(%ebp)
80102c87:	72 12                	jb     80102c9b <kfree+0x2d>
80102c89:	ff 75 08             	pushl  0x8(%ebp)
80102c8c:	e8 36 ff ff ff       	call   80102bc7 <v2p>
80102c91:	83 c4 04             	add    $0x4,%esp
80102c94:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c99:	76 0d                	jbe    80102ca8 <kfree+0x3a>
    panic("kfree");
80102c9b:	83 ec 0c             	sub    $0xc,%esp
80102c9e:	68 d7 9b 10 80       	push   $0x80109bd7
80102ca3:	e8 be d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca8:	83 ec 04             	sub    $0x4,%esp
80102cab:	68 00 10 00 00       	push   $0x1000
80102cb0:	6a 01                	push   $0x1
80102cb2:	ff 75 08             	pushl  0x8(%ebp)
80102cb5:	e8 29 38 00 00       	call   801064e3 <memset>
80102cba:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cbd:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cc2:	85 c0                	test   %eax,%eax
80102cc4:	74 10                	je     80102cd6 <kfree+0x68>
    acquire(&kmem.lock);
80102cc6:	83 ec 0c             	sub    $0xc,%esp
80102cc9:	68 40 42 11 80       	push   $0x80114240
80102cce:	e8 ad 35 00 00       	call   80106280 <acquire>
80102cd3:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cdc:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce5:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cea:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102cef:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cf4:	85 c0                	test   %eax,%eax
80102cf6:	74 10                	je     80102d08 <kfree+0x9a>
    release(&kmem.lock);
80102cf8:	83 ec 0c             	sub    $0xc,%esp
80102cfb:	68 40 42 11 80       	push   $0x80114240
80102d00:	e8 e2 35 00 00       	call   801062e7 <release>
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
80102d11:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d16:	85 c0                	test   %eax,%eax
80102d18:	74 10                	je     80102d2a <kalloc+0x1f>
    acquire(&kmem.lock);
80102d1a:	83 ec 0c             	sub    $0xc,%esp
80102d1d:	68 40 42 11 80       	push   $0x80114240
80102d22:	e8 59 35 00 00       	call   80106280 <acquire>
80102d27:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d2a:	a1 78 42 11 80       	mov    0x80114278,%eax
80102d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d36:	74 0a                	je     80102d42 <kalloc+0x37>
    kmem.freelist = r->next;
80102d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d3b:	8b 00                	mov    (%eax),%eax
80102d3d:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102d42:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d47:	85 c0                	test   %eax,%eax
80102d49:	74 10                	je     80102d5b <kalloc+0x50>
    release(&kmem.lock);
80102d4b:	83 ec 0c             	sub    $0xc,%esp
80102d4e:	68 40 42 11 80       	push   $0x80114240
80102d53:	e8 8f 35 00 00       	call   801062e7 <release>
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
80102dc0:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102dc5:	83 c8 40             	or     $0x40,%eax
80102dc8:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
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
80102de3:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
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
80102e00:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e05:	0f b6 00             	movzbl (%eax),%eax
80102e08:	83 c8 40             	or     $0x40,%eax
80102e0b:	0f b6 c0             	movzbl %al,%eax
80102e0e:	f7 d0                	not    %eax
80102e10:	89 c2                	mov    %eax,%edx
80102e12:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e17:	21 d0                	and    %edx,%eax
80102e19:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102e1e:	b8 00 00 00 00       	mov    $0x0,%eax
80102e23:	e9 a2 00 00 00       	jmp    80102eca <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e28:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e2d:	83 e0 40             	and    $0x40,%eax
80102e30:	85 c0                	test   %eax,%eax
80102e32:	74 14                	je     80102e48 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e34:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e3b:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e40:	83 e0 bf             	and    $0xffffffbf,%eax
80102e43:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102e48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e4b:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e50:	0f b6 00             	movzbl (%eax),%eax
80102e53:	0f b6 d0             	movzbl %al,%edx
80102e56:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e5b:	09 d0                	or     %edx,%eax
80102e5d:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e65:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102e6a:	0f b6 00             	movzbl (%eax),%eax
80102e6d:	0f b6 d0             	movzbl %al,%edx
80102e70:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e75:	31 d0                	xor    %edx,%eax
80102e77:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e7c:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e81:	83 e0 03             	and    $0x3,%eax
80102e84:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e8e:	01 d0                	add    %edx,%eax
80102e90:	0f b6 00             	movzbl (%eax),%eax
80102e93:	0f b6 c0             	movzbl %al,%eax
80102e96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e99:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
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
80102f34:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f39:	8b 55 08             	mov    0x8(%ebp),%edx
80102f3c:	c1 e2 02             	shl    $0x2,%edx
80102f3f:	01 c2                	add    %eax,%edx
80102f41:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f44:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f46:	a1 7c 42 11 80       	mov    0x8011427c,%eax
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
80102f56:	a1 7c 42 11 80       	mov    0x8011427c,%eax
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
80102fc9:	a1 7c 42 11 80       	mov    0x8011427c,%eax
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
8010304b:	a1 7c 42 11 80       	mov    0x8011427c,%eax
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
80103085:	a1 60 d6 10 80       	mov    0x8010d660,%eax
8010308a:	8d 50 01             	lea    0x1(%eax),%edx
8010308d:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
80103093:	85 c0                	test   %eax,%eax
80103095:	75 14                	jne    801030ab <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103097:	8b 45 04             	mov    0x4(%ebp),%eax
8010309a:	83 ec 08             	sub    $0x8,%esp
8010309d:	50                   	push   %eax
8010309e:	68 e0 9b 10 80       	push   $0x80109be0
801030a3:	e8 1e d3 ff ff       	call   801003c6 <cprintf>
801030a8:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030ab:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030b0:	85 c0                	test   %eax,%eax
801030b2:	74 0f                	je     801030c3 <cpunum+0x52>
    return lapic[ID]>>24;
801030b4:	a1 7c 42 11 80       	mov    0x8011427c,%eax
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
801030cd:	a1 7c 42 11 80       	mov    0x8011427c,%eax
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
801032c9:	e8 7c 32 00 00       	call   8010654a <memcmp>
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
801033dd:	68 0c 9c 10 80       	push   $0x80109c0c
801033e2:	68 80 42 11 80       	push   $0x80114280
801033e7:	e8 72 2e 00 00       	call   8010625e <initlock>
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
80103404:	a3 b4 42 11 80       	mov    %eax,0x801142b4
  log.size = sb.nlog;
80103409:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010340c:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  log.dev = dev;
80103411:	8b 45 08             	mov    0x8(%ebp),%eax
80103414:	a3 c4 42 11 80       	mov    %eax,0x801142c4
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
80103433:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
80103439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010343c:	01 d0                	add    %edx,%eax
8010343e:	83 c0 01             	add    $0x1,%eax
80103441:	89 c2                	mov    %eax,%edx
80103443:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103448:	83 ec 08             	sub    $0x8,%esp
8010344b:	52                   	push   %edx
8010344c:	50                   	push   %eax
8010344d:	e8 64 cd ff ff       	call   801001b6 <bread>
80103452:	83 c4 10             	add    $0x10,%esp
80103455:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103458:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010345b:	83 c0 10             	add    $0x10,%eax
8010345e:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103465:	89 c2                	mov    %eax,%edx
80103467:	a1 c4 42 11 80       	mov    0x801142c4,%eax
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
80103492:	e8 0b 31 00 00       	call   801065a2 <memmove>
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
801034c8:	a1 c8 42 11 80       	mov    0x801142c8,%eax
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
801034df:	a1 b4 42 11 80       	mov    0x801142b4,%eax
801034e4:	89 c2                	mov    %eax,%edx
801034e6:	a1 c4 42 11 80       	mov    0x801142c4,%eax
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
80103509:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  for (i = 0; i < log.lh.n; i++) {
8010350e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103515:	eb 1b                	jmp    80103532 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103517:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010351a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010351d:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103521:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103524:	83 c2 10             	add    $0x10,%edx
80103527:	89 04 95 8c 42 11 80 	mov    %eax,-0x7feebd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010352e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103532:	a1 c8 42 11 80       	mov    0x801142c8,%eax
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
80103553:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80103558:	89 c2                	mov    %eax,%edx
8010355a:	a1 c4 42 11 80       	mov    0x801142c4,%eax
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
80103578:	8b 15 c8 42 11 80    	mov    0x801142c8,%edx
8010357e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103581:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010358a:	eb 1b                	jmp    801035a7 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
8010358c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010358f:	83 c0 10             	add    $0x10,%eax
80103592:	8b 0c 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%ecx
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
801035a7:	a1 c8 42 11 80       	mov    0x801142c8,%eax
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
801035e0:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
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
801035fb:	68 80 42 11 80       	push   $0x80114280
80103600:	e8 7b 2c 00 00       	call   80106280 <acquire>
80103605:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103608:	a1 c0 42 11 80       	mov    0x801142c0,%eax
8010360d:	85 c0                	test   %eax,%eax
8010360f:	74 17                	je     80103628 <begin_op+0x36>
      sleep(&log, &log.lock);
80103611:	83 ec 08             	sub    $0x8,%esp
80103614:	68 80 42 11 80       	push   $0x80114280
80103619:	68 80 42 11 80       	push   $0x80114280
8010361e:	e8 8b 1d 00 00       	call   801053ae <sleep>
80103623:	83 c4 10             	add    $0x10,%esp
80103626:	eb e0                	jmp    80103608 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103628:	8b 0d c8 42 11 80    	mov    0x801142c8,%ecx
8010362e:	a1 bc 42 11 80       	mov    0x801142bc,%eax
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
80103649:	68 80 42 11 80       	push   $0x80114280
8010364e:	68 80 42 11 80       	push   $0x80114280
80103653:	e8 56 1d 00 00       	call   801053ae <sleep>
80103658:	83 c4 10             	add    $0x10,%esp
8010365b:	eb ab                	jmp    80103608 <begin_op+0x16>
    } else {
      log.outstanding += 1;
8010365d:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103662:	83 c0 01             	add    $0x1,%eax
80103665:	a3 bc 42 11 80       	mov    %eax,0x801142bc
      release(&log.lock);
8010366a:	83 ec 0c             	sub    $0xc,%esp
8010366d:	68 80 42 11 80       	push   $0x80114280
80103672:	e8 70 2c 00 00       	call   801062e7 <release>
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
8010368e:	68 80 42 11 80       	push   $0x80114280
80103693:	e8 e8 2b 00 00       	call   80106280 <acquire>
80103698:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010369b:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036a0:	83 e8 01             	sub    $0x1,%eax
801036a3:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  if(log.committing)
801036a8:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801036ad:	85 c0                	test   %eax,%eax
801036af:	74 0d                	je     801036be <end_op+0x40>
    panic("log.committing");
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	68 10 9c 10 80       	push   $0x80109c10
801036b9:	e8 a8 ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036be:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036c3:	85 c0                	test   %eax,%eax
801036c5:	75 13                	jne    801036da <end_op+0x5c>
    do_commit = 1;
801036c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036ce:	c7 05 c0 42 11 80 01 	movl   $0x1,0x801142c0
801036d5:	00 00 00 
801036d8:	eb 10                	jmp    801036ea <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	68 80 42 11 80       	push   $0x80114280
801036e2:	e8 f8 1e 00 00       	call   801055df <wakeup>
801036e7:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036ea:	83 ec 0c             	sub    $0xc,%esp
801036ed:	68 80 42 11 80       	push   $0x80114280
801036f2:	e8 f0 2b 00 00       	call   801062e7 <release>
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
80103708:	68 80 42 11 80       	push   $0x80114280
8010370d:	e8 6e 2b 00 00       	call   80106280 <acquire>
80103712:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103715:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
8010371c:	00 00 00 
    wakeup(&log);
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	68 80 42 11 80       	push   $0x80114280
80103727:	e8 b3 1e 00 00       	call   801055df <wakeup>
8010372c:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010372f:	83 ec 0c             	sub    $0xc,%esp
80103732:	68 80 42 11 80       	push   $0x80114280
80103737:	e8 ab 2b 00 00       	call   801062e7 <release>
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
80103754:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
8010375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375d:	01 d0                	add    %edx,%eax
8010375f:	83 c0 01             	add    $0x1,%eax
80103762:	89 c2                	mov    %eax,%edx
80103764:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103769:	83 ec 08             	sub    $0x8,%esp
8010376c:	52                   	push   %edx
8010376d:	50                   	push   %eax
8010376e:	e8 43 ca ff ff       	call   801001b6 <bread>
80103773:	83 c4 10             	add    $0x10,%esp
80103776:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010377c:	83 c0 10             	add    $0x10,%eax
8010377f:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103786:	89 c2                	mov    %eax,%edx
80103788:	a1 c4 42 11 80       	mov    0x801142c4,%eax
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
801037b3:	e8 ea 2d 00 00       	call   801065a2 <memmove>
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
801037e9:	a1 c8 42 11 80       	mov    0x801142c8,%eax
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
80103800:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103805:	85 c0                	test   %eax,%eax
80103807:	7e 1e                	jle    80103827 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103809:	e8 34 ff ff ff       	call   80103742 <write_log>
    write_head();    // Write header to disk -- the real commit
8010380e:	e8 3a fd ff ff       	call   8010354d <write_head>
    install_trans(); // Now install writes to home locations
80103813:	e8 09 fc ff ff       	call   80103421 <install_trans>
    log.lh.n = 0; 
80103818:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
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
80103830:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103835:	83 f8 1d             	cmp    $0x1d,%eax
80103838:	7f 12                	jg     8010384c <log_write+0x22>
8010383a:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010383f:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
80103845:	83 ea 01             	sub    $0x1,%edx
80103848:	39 d0                	cmp    %edx,%eax
8010384a:	7c 0d                	jl     80103859 <log_write+0x2f>
    panic("too big a transaction");
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	68 1f 9c 10 80       	push   $0x80109c1f
80103854:	e8 0d cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103859:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010385e:	85 c0                	test   %eax,%eax
80103860:	7f 0d                	jg     8010386f <log_write+0x45>
    panic("log_write outside of trans");
80103862:	83 ec 0c             	sub    $0xc,%esp
80103865:	68 35 9c 10 80       	push   $0x80109c35
8010386a:	e8 f7 cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010386f:	83 ec 0c             	sub    $0xc,%esp
80103872:	68 80 42 11 80       	push   $0x80114280
80103877:	e8 04 2a 00 00       	call   80106280 <acquire>
8010387c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010387f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103886:	eb 1d                	jmp    801038a5 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010388b:	83 c0 10             	add    $0x10,%eax
8010388e:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
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
801038a5:	a1 c8 42 11 80       	mov    0x801142c8,%eax
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
801038c0:	89 14 85 8c 42 11 80 	mov    %edx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801038c7:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038cf:	75 0d                	jne    801038de <log_write+0xb4>
    log.lh.n++;
801038d1:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038d6:	83 c0 01             	add    $0x1,%eax
801038d9:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  b->flags |= B_DIRTY; // prevent eviction
801038de:	8b 45 08             	mov    0x8(%ebp),%eax
801038e1:	8b 00                	mov    (%eax),%eax
801038e3:	83 c8 04             	or     $0x4,%eax
801038e6:	89 c2                	mov    %eax,%edx
801038e8:	8b 45 08             	mov    0x8(%ebp),%eax
801038eb:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 80 42 11 80       	push   $0x80114280
801038f5:	e8 ed 29 00 00       	call   801062e7 <release>
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
8010394d:	68 5c 79 11 80       	push   $0x8011795c
80103952:	e8 7d f2 ff ff       	call   80102bd4 <kinit1>
80103957:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
8010395a:	e8 be 58 00 00       	call   8010921d <kvmalloc>
  mpinit();        // collect info about this machine
8010395f:	e8 43 04 00 00       	call   80103da7 <mpinit>
  lapicinit();
80103964:	e8 ea f5 ff ff       	call   80102f53 <lapicinit>
  seginit();       // set up segments
80103969:	e8 58 52 00 00       	call   80108bc6 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010396e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103974:	0f b6 00             	movzbl (%eax),%eax
80103977:	0f b6 c0             	movzbl %al,%eax
8010397a:	83 ec 08             	sub    $0x8,%esp
8010397d:	50                   	push   %eax
8010397e:	68 50 9c 10 80       	push   $0x80109c50
80103983:	e8 3e ca ff ff       	call   801003c6 <cprintf>
80103988:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
8010398b:	e8 6d 06 00 00       	call   80103ffd <picinit>
  ioapicinit();    // another interrupt controller
80103990:	e8 34 f1 ff ff       	call   80102ac9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103995:	e8 24 d2 ff ff       	call   80100bbe <consoleinit>
  uartinit();      // serial port
8010399a:	e8 83 45 00 00       	call   80107f22 <uartinit>
  pinit();         // process table
8010399f:	e8 5d 0b 00 00       	call   80104501 <pinit>
  tvinit();        // trap vectors
801039a4:	e8 52 41 00 00       	call   80107afb <tvinit>
  binit();         // buffer cache
801039a9:	e8 86 c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039ae:	e8 67 d6 ff ff       	call   8010101a <fileinit>
  ideinit();       // disk
801039b3:	e8 19 ed ff ff       	call   801026d1 <ideinit>
  if(!ismp)
801039b8:	a1 64 43 11 80       	mov    0x80114364,%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	75 05                	jne    801039c6 <main+0x92>
    timerinit();   // uniprocessor timer
801039c1:	e8 86 40 00 00       	call   80107a4c <timerinit>
  startothers();   // start other processors
801039c6:	e8 7f 00 00 00       	call   80103a4a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039cb:	83 ec 08             	sub    $0x8,%esp
801039ce:	68 00 00 00 8e       	push   $0x8e000000
801039d3:	68 00 00 40 80       	push   $0x80400000
801039d8:	e8 30 f2 ff ff       	call   80102c0d <kinit2>
801039dd:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039e0:	e8 fd 0c 00 00       	call   801046e2 <userinit>
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
801039f0:	e8 40 58 00 00       	call   80109235 <switchkvm>
  seginit();
801039f5:	e8 cc 51 00 00       	call   80108bc6 <seginit>
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
80103a1a:	68 67 9c 10 80       	push   $0x80109c67
80103a1f:	e8 a2 c9 ff ff       	call   801003c6 <cprintf>
80103a24:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a27:	e8 30 42 00 00       	call   80107c5c <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a2c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a32:	05 a8 00 00 00       	add    $0xa8,%eax
80103a37:	83 ec 08             	sub    $0x8,%esp
80103a3a:	6a 01                	push   $0x1
80103a3c:	50                   	push   %eax
80103a3d:	e8 d8 fe ff ff       	call   8010391a <xchg>
80103a42:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a45:	e8 65 15 00 00       	call   80104faf <scheduler>

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
80103a6a:	68 2c d5 10 80       	push   $0x8010d52c
80103a6f:	ff 75 f0             	pushl  -0x10(%ebp)
80103a72:	e8 2b 2b 00 00       	call   801065a2 <memmove>
80103a77:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a7a:	c7 45 f4 80 43 11 80 	movl   $0x80114380,-0xc(%ebp)
80103a81:	e9 90 00 00 00       	jmp    80103b16 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a86:	e8 e6 f5 ff ff       	call   80103071 <cpunum>
80103a8b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a91:	05 80 43 11 80       	add    $0x80114380,%eax
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
80103ac9:	68 00 c0 10 80       	push   $0x8010c000
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
80103b16:	a1 60 49 11 80       	mov    0x80114960,%eax
80103b1b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b21:	05 80 43 11 80       	add    $0x80114380,%eax
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
80103b81:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80103b86:	89 c2                	mov    %eax,%edx
80103b88:	b8 80 43 11 80       	mov    $0x80114380,%eax
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
80103c00:	68 78 9c 10 80       	push   $0x80109c78
80103c05:	ff 75 f4             	pushl  -0xc(%ebp)
80103c08:	e8 3d 29 00 00       	call   8010654a <memcmp>
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
80103d3e:	68 7d 9c 10 80       	push   $0x80109c7d
80103d43:	ff 75 f0             	pushl  -0x10(%ebp)
80103d46:	e8 ff 27 00 00       	call   8010654a <memcmp>
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
80103dad:	c7 05 64 d6 10 80 80 	movl   $0x80114380,0x8010d664
80103db4:	43 11 80 
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
80103dd3:	c7 05 64 43 11 80 01 	movl   $0x1,0x80114364
80103dda:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de0:	8b 40 24             	mov    0x24(%eax),%eax
80103de3:	a3 7c 42 11 80       	mov    %eax,0x8011427c
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
80103e1a:	8b 04 85 c0 9c 10 80 	mov    -0x7fef6340(,%eax,4),%eax
80103e21:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e26:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e2c:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e30:	0f b6 d0             	movzbl %al,%edx
80103e33:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e38:	39 c2                	cmp    %eax,%edx
80103e3a:	74 2b                	je     80103e67 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e3f:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e43:	0f b6 d0             	movzbl %al,%edx
80103e46:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e4b:	83 ec 04             	sub    $0x4,%esp
80103e4e:	52                   	push   %edx
80103e4f:	50                   	push   %eax
80103e50:	68 82 9c 10 80       	push   $0x80109c82
80103e55:	e8 6c c5 ff ff       	call   801003c6 <cprintf>
80103e5a:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e5d:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
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
80103e78:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e7d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e83:	05 80 43 11 80       	add    $0x80114380,%eax
80103e88:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      cpus[ncpu].id = ncpu;
80103e8d:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e92:	8b 15 60 49 11 80    	mov    0x80114960,%edx
80103e98:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e9e:	05 80 43 11 80       	add    $0x80114380,%eax
80103ea3:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103ea5:	a1 60 49 11 80       	mov    0x80114960,%eax
80103eaa:	83 c0 01             	add    $0x1,%eax
80103ead:	a3 60 49 11 80       	mov    %eax,0x80114960
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
80103ec5:	a2 60 43 11 80       	mov    %al,0x80114360
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
80103ee3:	68 a0 9c 10 80       	push   $0x80109ca0
80103ee8:	e8 d9 c4 ff ff       	call   801003c6 <cprintf>
80103eed:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ef0:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
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
80103f06:	a1 64 43 11 80       	mov    0x80114364,%eax
80103f0b:	85 c0                	test   %eax,%eax
80103f0d:	75 1d                	jne    80103f2c <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f0f:	c7 05 60 49 11 80 01 	movl   $0x1,0x80114960
80103f16:	00 00 00 
    lapic = 0;
80103f19:	c7 05 7c 42 11 80 00 	movl   $0x0,0x8011427c
80103f20:	00 00 00 
    ioapicid = 0;
80103f23:	c6 05 60 43 11 80 00 	movb   $0x0,0x80114360
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
80103f9c:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
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
80103fe5:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
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
801040c3:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040ca:	66 83 f8 ff          	cmp    $0xffff,%ax
801040ce:	74 13                	je     801040e3 <picinit+0xe6>
    picsetmask(irqmask);
801040d0:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
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
80104184:	68 d4 9c 10 80       	push   $0x80109cd4
80104189:	50                   	push   %eax
8010418a:	e8 cf 20 00 00       	call   8010625e <initlock>
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
80104246:	e8 35 20 00 00       	call   80106280 <acquire>
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
8010426d:	e8 6d 13 00 00       	call   801055df <wakeup>
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
80104290:	e8 4a 13 00 00       	call   801055df <wakeup>
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
801042b9:	e8 29 20 00 00       	call   801062e7 <release>
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
801042d8:	e8 0a 20 00 00       	call   801062e7 <release>
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
801042f0:	e8 8b 1f 00 00       	call   80106280 <acquire>
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
80104325:	e8 bd 1f 00 00       	call   801062e7 <release>
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
80104343:	e8 97 12 00 00       	call   801055df <wakeup>
80104348:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	8b 55 08             	mov    0x8(%ebp),%edx
80104351:	81 c2 38 02 00 00    	add    $0x238,%edx
80104357:	83 ec 08             	sub    $0x8,%esp
8010435a:	50                   	push   %eax
8010435b:	52                   	push   %edx
8010435c:	e8 4d 10 00 00       	call   801053ae <sleep>
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
801043c5:	e8 15 12 00 00       	call   801055df <wakeup>
801043ca:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043cd:	8b 45 08             	mov    0x8(%ebp),%eax
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	50                   	push   %eax
801043d4:	e8 0e 1f 00 00       	call   801062e7 <release>
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
801043ef:	e8 8c 1e 00 00       	call   80106280 <acquire>
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
8010440d:	e8 d5 1e 00 00       	call   801062e7 <release>
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
80104430:	e8 79 0f 00 00       	call   801053ae <sleep>
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
801044c4:	e8 16 11 00 00       	call   801055df <wakeup>
801044c9:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044cc:	8b 45 08             	mov    0x8(%ebp),%eax
801044cf:	83 ec 0c             	sub    $0xc,%esp
801044d2:	50                   	push   %eax
801044d3:	e8 0f 1e 00 00       	call   801062e7 <release>
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
8010450a:	68 dc 9c 10 80       	push   $0x80109cdc
8010450f:	68 80 49 11 80       	push   $0x80114980
80104514:	e8 45 1d 00 00       	call   8010625e <initlock>
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
80104528:	68 80 49 11 80       	push   $0x80114980
8010452d:	e8 4e 1d 00 00       	call   80106280 <acquire>
80104532:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
    p = removeFront(&ptable.pLists.free);
80104535:	83 ec 0c             	sub    $0xc,%esp
80104538:	68 d0 70 11 80       	push   $0x801170d0
8010453d:	e8 a1 17 00 00       	call   80105ce3 <removeFront>
80104542:	83 c4 10             	add    $0x10,%esp
80104545:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p != 0){
80104548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454c:	74 71                	je     801045bf <allocproc+0xa0>
      assertState(p, UNUSED);
8010454e:	83 ec 08             	sub    $0x8,%esp
80104551:	6a 00                	push   $0x0
80104553:	ff 75 f4             	pushl  -0xc(%ebp)
80104556:	e8 6d 15 00 00       	call   80105ac8 <assertState>
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
8010456f:	68 e0 70 11 80       	push   $0x801170e0
80104574:	e8 e5 18 00 00       	call   80105e5e <insertAtHead>
80104579:	83 c4 10             	add    $0x10,%esp
   
  #else
   p->state = EMBRYO;              // check this
  #endif

  p->pid = nextpid++;
8010457c:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104581:	8d 50 01             	lea    0x1(%eax),%edx
80104584:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
8010458a:	89 c2                	mov    %eax,%edx
8010458c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458f:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 80 49 11 80       	push   $0x80114980
8010459a:	e8 48 1d 00 00       	call   801062e7 <release>
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
801045c2:	68 80 49 11 80       	push   $0x80114980
801045c7:	e8 1b 1d 00 00       	call   801062e7 <release>
801045cc:	83 c4 10             	add    $0x10,%esp
  return 0;
801045cf:	b8 00 00 00 00       	mov    $0x0,%eax
801045d4:	e9 07 01 00 00       	jmp    801046e0 <allocproc+0x1c1>
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4                       //******* check this logic IMPORTant
    acquire(&ptable.lock);
801045d9:	83 ec 0c             	sub    $0xc,%esp
801045dc:	68 80 49 11 80       	push   $0x80114980
801045e1:	e8 9a 1c 00 00       	call   80106280 <acquire>
801045e6:	83 c4 10             	add    $0x10,%esp
    assertState(p, EMBRYO);
801045e9:	83 ec 08             	sub    $0x8,%esp
801045ec:	6a 01                	push   $0x1
801045ee:	ff 75 f4             	pushl  -0xc(%ebp)
801045f1:	e8 d2 14 00 00       	call   80105ac8 <assertState>
801045f6:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, p);
801045f9:	83 ec 08             	sub    $0x8,%esp
801045fc:	ff 75 f4             	pushl  -0xc(%ebp)
801045ff:	68 e0 70 11 80       	push   $0x801170e0
80104604:	e8 09 15 00 00       	call   80105b12 <removeFromStateList>
80104609:	83 c4 10             	add    $0x10,%esp
    p->state = UNUSED;                // should I put it in the else block
8010460c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, p);
80104616:	83 ec 08             	sub    $0x8,%esp
80104619:	ff 75 f4             	pushl  -0xc(%ebp)
8010461c:	68 d0 70 11 80       	push   $0x801170d0
80104621:	e8 38 18 00 00       	call   80105e5e <insertAtHead>
80104626:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104629:	83 ec 0c             	sub    $0xc,%esp
8010462c:	68 80 49 11 80       	push   $0x80114980
80104631:	e8 b1 1c 00 00       	call   801062e7 <release>
80104636:	83 c4 10             	add    $0x10,%esp
    
    #else
    p->state = UNUSED;               
    #endif

    return 0;
80104639:	b8 00 00 00 00       	mov    $0x0,%eax
8010463e:	e9 9d 00 00 00       	jmp    801046e0 <allocproc+0x1c1>
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
80104662:	ba a9 7a 10 80       	mov    $0x80107aa9,%edx
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
80104687:	e8 57 1e 00 00       	call   801064e3 <memset>
8010468c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010468f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104692:	8b 40 1c             	mov    0x1c(%eax),%eax
80104695:	ba 68 53 10 80       	mov    $0x80105368,%edx
8010469a:	89 50 10             	mov    %edx,0x10(%eax)
  p->start_ticks = ticks;
8010469d:	8b 15 00 79 11 80    	mov    0x80117900,%edx
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

  p->priority = 0;
801046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c6:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801046cd:	00 00 00 
  p->budget = BUDGET;
801046d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d3:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
801046da:	13 00 00 

  return p;
801046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
801046e0:	c9                   	leave  
801046e1:	c3                   	ret    

801046e2 <userinit>:

// Set up first user process.
void
userinit(void)
{
801046e2:	55                   	push   %ebp
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	68 80 49 11 80       	push   $0x80114980
801046f0:	e8 8b 1b 00 00       	call   80106280 <acquire>
801046f5:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
801046f8:	c7 05 d0 70 11 80 00 	movl   $0x0,0x801170d0
801046ff:	00 00 00 
  for(int i =0; i <= MAX; i++){                  //P4 initialize array list
80104702:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104709:	eb 17                	jmp    80104722 <userinit+0x40>
    ptable.pLists.ready[i] = 0;
8010470b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010470e:	05 cc 09 00 00       	add    $0x9cc,%eax
80104713:	c7 04 85 84 49 11 80 	movl   $0x0,-0x7feeb67c(,%eax,4)
8010471a:	00 00 00 00 
  extern char _binary_initcode_start[], _binary_initcode_size[];

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
  ptable.pLists.free = 0;
  for(int i =0; i <= MAX; i++){                  //P4 initialize array list
8010471e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104722:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
80104726:	7e e3                	jle    8010470b <userinit+0x29>
    ptable.pLists.ready[i] = 0;
  }
  ptable.pLists.sleep = 0;
80104728:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
8010472f:	00 00 00 
  ptable.pLists.embryo = 0;
80104732:	c7 05 e0 70 11 80 00 	movl   $0x0,0x801170e0
80104739:	00 00 00 
  ptable.pLists.running = 0;
8010473c:	c7 05 dc 70 11 80 00 	movl   $0x0,0x801170dc
80104743:	00 00 00 
  ptable.pLists.zombie = 0;
80104746:	c7 05 d8 70 11 80 00 	movl   $0x0,0x801170d8
8010474d:	00 00 00 

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;   //P4 initilize ticksToPromote
80104750:	a1 00 79 11 80       	mov    0x80117900,%eax
80104755:	05 b8 0b 00 00       	add    $0xbb8,%eax
8010475a:	a3 e4 70 11 80       	mov    %eax,0x801170e4

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010475f:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104766:	eb 24                	jmp    8010478c <userinit+0xaa>
    p -> state = UNUSED;
80104768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, p);
80104772:	83 ec 08             	sub    $0x8,%esp
80104775:	ff 75 f4             	pushl  -0xc(%ebp)
80104778:	68 d0 70 11 80       	push   $0x801170d0
8010477d:	e8 dc 16 00 00       	call   80105e5e <insertAtHead>
80104782:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.running = 0;
  ptable.pLists.zombie = 0;

  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;   //P4 initilize ticksToPromote

 for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104785:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
8010478c:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104793:	72 d3                	jb     80104768 <userinit+0x86>
    p -> state = UNUSED;
    insertAtHead(&ptable.pLists.free, p);
 }
  release(&ptable.lock);
80104795:	83 ec 0c             	sub    $0xc,%esp
80104798:	68 80 49 11 80       	push   $0x80114980
8010479d:	e8 45 1b 00 00       	call   801062e7 <release>
801047a2:	83 c4 10             	add    $0x10,%esp
  #endif

  p = allocproc();
801047a5:	e8 75 fd ff ff       	call   8010451f <allocproc>
801047aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801047ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b0:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
801047b5:	e8 b1 49 00 00       	call   8010916b <setupkvm>
801047ba:	89 c2                	mov    %eax,%edx
801047bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bf:	89 50 04             	mov    %edx,0x4(%eax)
801047c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c5:	8b 40 04             	mov    0x4(%eax),%eax
801047c8:	85 c0                	test   %eax,%eax
801047ca:	75 0d                	jne    801047d9 <userinit+0xf7>
    panic("userinit: out of memory?");
801047cc:	83 ec 0c             	sub    $0xc,%esp
801047cf:	68 e3 9c 10 80       	push   $0x80109ce3
801047d4:	e8 8d bd ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047d9:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e1:	8b 40 04             	mov    0x4(%eax),%eax
801047e4:	83 ec 04             	sub    $0x4,%esp
801047e7:	52                   	push   %edx
801047e8:	68 00 d5 10 80       	push   $0x8010d500
801047ed:	50                   	push   %eax
801047ee:	e8 d2 4b 00 00       	call   801093c5 <inituvm>
801047f3:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801047f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f9:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104802:	8b 40 18             	mov    0x18(%eax),%eax
80104805:	83 ec 04             	sub    $0x4,%esp
80104808:	6a 4c                	push   $0x4c
8010480a:	6a 00                	push   $0x0
8010480c:	50                   	push   %eax
8010480d:	e8 d1 1c 00 00       	call   801064e3 <memset>
80104812:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104818:	8b 40 18             	mov    0x18(%eax),%eax
8010481b:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104824:	8b 40 18             	mov    0x18(%eax),%eax
80104827:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010482d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104830:	8b 40 18             	mov    0x18(%eax),%eax
80104833:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104836:	8b 52 18             	mov    0x18(%edx),%edx
80104839:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010483d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104844:	8b 40 18             	mov    0x18(%eax),%eax
80104847:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010484a:	8b 52 18             	mov    0x18(%edx),%edx
8010484d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104851:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104858:	8b 40 18             	mov    0x18(%eax),%eax
8010485b:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104865:	8b 40 18             	mov    0x18(%eax),%eax
80104868:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104872:	8b 40 18             	mov    0x18(%eax),%eax
80104875:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010487c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487f:	83 c0 6c             	add    $0x6c,%eax
80104882:	83 ec 04             	sub    $0x4,%esp
80104885:	6a 10                	push   $0x10
80104887:	68 fc 9c 10 80       	push   $0x80109cfc
8010488c:	50                   	push   %eax
8010488d:	e8 54 1e 00 00       	call   801066e6 <safestrcpy>
80104892:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104895:	83 ec 0c             	sub    $0xc,%esp
80104898:	68 05 9d 10 80       	push   $0x80109d05
8010489d:	e8 2b dd ff ff       	call   801025cd <namei>
801048a2:	83 c4 10             	add    $0x10,%esp
801048a5:	89 c2                	mov    %eax,%edx
801048a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048aa:	89 50 68             	mov    %edx,0x68(%eax)
  p->parent = p;            // set up parent  -- change it later to zero
801048ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048b3:	89 50 14             	mov    %edx,0x14(%eax)
  // change the state
  // assert new state
  // insert into ready 

  #ifdef CS333_P3P4                             
    acquire(&ptable.lock);
801048b6:	83 ec 0c             	sub    $0xc,%esp
801048b9:	68 80 49 11 80       	push   $0x80114980
801048be:	e8 bd 19 00 00       	call   80106280 <acquire>
801048c3:	83 c4 10             	add    $0x10,%esp
    assertState(p, EMBRYO);
801048c6:	83 ec 08             	sub    $0x8,%esp
801048c9:	6a 01                	push   $0x1
801048cb:	ff 75 f4             	pushl  -0xc(%ebp)
801048ce:	e8 f5 11 00 00       	call   80105ac8 <assertState>
801048d3:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, p);
801048d6:	83 ec 08             	sub    $0x8,%esp
801048d9:	ff 75 f4             	pushl  -0xc(%ebp)
801048dc:	68 e0 70 11 80       	push   $0x801170e0
801048e1:	e8 2c 12 00 00       	call   80105b12 <removeFromStateList>
801048e6:	83 c4 10             	add    $0x10,%esp
    p->state = RUNNABLE;                        //P4 insert the first process at ready[0]
801048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready[0], p);
801048f3:	83 ec 08             	sub    $0x8,%esp
801048f6:	ff 75 f4             	pushl  -0xc(%ebp)
801048f9:	68 b4 70 11 80       	push   $0x801170b4
801048fe:	e8 f4 14 00 00       	call   80105df7 <insertTail>
80104903:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104906:	83 ec 0c             	sub    $0xc,%esp
80104909:	68 80 49 11 80       	push   $0x80114980
8010490e:	e8 d4 19 00 00       	call   801062e7 <release>
80104913:	83 c4 10             	add    $0x10,%esp
  #else
    p->state = RUNNABLE;                        
  #endif  
  p->uid = UID;
80104916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104919:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104920:	00 00 00 
  p->gid = GID;                                 
80104923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104926:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010492d:	00 00 00 
}
80104930:	90                   	nop
80104931:	c9                   	leave  
80104932:	c3                   	ret    

80104933 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104933:	55                   	push   %ebp
80104934:	89 e5                	mov    %esp,%ebp
80104936:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104939:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493f:	8b 00                	mov    (%eax),%eax
80104941:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104944:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104948:	7e 31                	jle    8010497b <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010494a:	8b 55 08             	mov    0x8(%ebp),%edx
8010494d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104950:	01 c2                	add    %eax,%edx
80104952:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104958:	8b 40 04             	mov    0x4(%eax),%eax
8010495b:	83 ec 04             	sub    $0x4,%esp
8010495e:	52                   	push   %edx
8010495f:	ff 75 f4             	pushl  -0xc(%ebp)
80104962:	50                   	push   %eax
80104963:	e8 aa 4b 00 00       	call   80109512 <allocuvm>
80104968:	83 c4 10             	add    $0x10,%esp
8010496b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010496e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104972:	75 3e                	jne    801049b2 <growproc+0x7f>
      return -1;
80104974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104979:	eb 59                	jmp    801049d4 <growproc+0xa1>
  } else if(n < 0){
8010497b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010497f:	79 31                	jns    801049b2 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104981:	8b 55 08             	mov    0x8(%ebp),%edx
80104984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104987:	01 c2                	add    %eax,%edx
80104989:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498f:	8b 40 04             	mov    0x4(%eax),%eax
80104992:	83 ec 04             	sub    $0x4,%esp
80104995:	52                   	push   %edx
80104996:	ff 75 f4             	pushl  -0xc(%ebp)
80104999:	50                   	push   %eax
8010499a:	e8 3c 4c 00 00       	call   801095db <deallocuvm>
8010499f:	83 c4 10             	add    $0x10,%esp
801049a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049a9:	75 07                	jne    801049b2 <growproc+0x7f>
      return -1;
801049ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b0:	eb 22                	jmp    801049d4 <growproc+0xa1>
  }
  proc->sz = sz;
801049b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049bb:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801049bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c3:	83 ec 0c             	sub    $0xc,%esp
801049c6:	50                   	push   %eax
801049c7:	e8 86 48 00 00       	call   80109252 <switchuvm>
801049cc:	83 c4 10             	add    $0x10,%esp
  return 0;
801049cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049d4:	c9                   	leave  
801049d5:	c3                   	ret    

801049d6 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801049d6:	55                   	push   %ebp
801049d7:	89 e5                	mov    %esp,%ebp
801049d9:	57                   	push   %edi
801049da:	56                   	push   %esi
801049db:	53                   	push   %ebx
801049dc:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801049df:	e8 3b fb ff ff       	call   8010451f <allocproc>
801049e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049eb:	75 0a                	jne    801049f7 <fork+0x21>
    return -1;
801049ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049f2:	e9 37 02 00 00       	jmp    80104c2e <fork+0x258>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049fd:	8b 10                	mov    (%eax),%edx
801049ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a05:	8b 40 04             	mov    0x4(%eax),%eax
80104a08:	83 ec 08             	sub    $0x8,%esp
80104a0b:	52                   	push   %edx
80104a0c:	50                   	push   %eax
80104a0d:	e8 67 4d 00 00       	call   80109779 <copyuvm>
80104a12:	83 c4 10             	add    $0x10,%esp
80104a15:	89 c2                	mov    %eax,%edx
80104a17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a1a:	89 50 04             	mov    %edx,0x4(%eax)
80104a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a20:	8b 40 04             	mov    0x4(%eax),%eax
80104a23:	85 c0                	test   %eax,%eax
80104a25:	0f 85 86 00 00 00    	jne    80104ab1 <fork+0xdb>
    kfree(np->kstack);
80104a2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a2e:	8b 40 08             	mov    0x8(%eax),%eax
80104a31:	83 ec 0c             	sub    $0xc,%esp
80104a34:	50                   	push   %eax
80104a35:	e8 34 e2 ff ff       	call   80102c6e <kfree>
80104a3a:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

  #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104a47:	83 ec 0c             	sub    $0xc,%esp
80104a4a:	68 80 49 11 80       	push   $0x80114980
80104a4f:	e8 2c 18 00 00       	call   80106280 <acquire>
80104a54:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104a57:	83 ec 08             	sub    $0x8,%esp
80104a5a:	6a 01                	push   $0x1
80104a5c:	ff 75 e0             	pushl  -0x20(%ebp)
80104a5f:	e8 64 10 00 00       	call   80105ac8 <assertState>
80104a64:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, np);
80104a67:	83 ec 08             	sub    $0x8,%esp
80104a6a:	ff 75 e0             	pushl  -0x20(%ebp)
80104a6d:	68 e0 70 11 80       	push   $0x801170e0
80104a72:	e8 9b 10 00 00       	call   80105b12 <removeFromStateList>
80104a77:	83 c4 10             	add    $0x10,%esp

    np->state = UNUSED;                         // *** assert and add it back to free list
80104a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a7d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    insertAtHead(&ptable.pLists.free, np);
80104a84:	83 ec 08             	sub    $0x8,%esp
80104a87:	ff 75 e0             	pushl  -0x20(%ebp)
80104a8a:	68 d0 70 11 80       	push   $0x801170d0
80104a8f:	e8 ca 13 00 00       	call   80105e5e <insertAtHead>
80104a94:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104a97:	83 ec 0c             	sub    $0xc,%esp
80104a9a:	68 80 49 11 80       	push   $0x80114980
80104a9f:	e8 43 18 00 00       	call   801062e7 <release>
80104aa4:	83 c4 10             	add    $0x10,%esp
  #else
    np->state = UNUSED;                         // *** assert and add it back to free list
  #endif

  return -1;
80104aa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aac:	e9 7d 01 00 00       	jmp    80104c2e <fork+0x258>
  }
  np->sz = proc->sz;
80104ab1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab7:	8b 10                	mov    (%eax),%edx
80104ab9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104abc:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104abe:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ac8:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ace:	8b 50 18             	mov    0x18(%eax),%edx
80104ad1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad7:	8b 40 18             	mov    0x18(%eax),%eax
80104ada:	89 c3                	mov    %eax,%ebx
80104adc:	b8 13 00 00 00       	mov    $0x13,%eax
80104ae1:	89 d7                	mov    %edx,%edi
80104ae3:	89 de                	mov    %ebx,%esi
80104ae5:	89 c1                	mov    %eax,%ecx
80104ae7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->uid = proc->uid;
80104ae9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aef:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af8:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;                          
80104afe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b04:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b0d:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b13:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b16:	8b 40 18             	mov    0x18(%eax),%eax
80104b19:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b27:	eb 43                	jmp    80104b6c <fork+0x196>
    if(proc->ofile[i])
80104b29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b32:	83 c2 08             	add    $0x8,%edx
80104b35:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b39:	85 c0                	test   %eax,%eax
80104b3b:	74 2b                	je     80104b68 <fork+0x192>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b3d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b46:	83 c2 08             	add    $0x8,%edx
80104b49:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b4d:	83 ec 0c             	sub    $0xc,%esp
80104b50:	50                   	push   %eax
80104b51:	e8 4f c5 ff ff       	call   801010a5 <filedup>
80104b56:	83 c4 10             	add    $0x10,%esp
80104b59:	89 c1                	mov    %eax,%ecx
80104b5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b61:	83 c2 08             	add    $0x8,%edx
80104b64:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np->gid = proc->gid;                          

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b68:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b6c:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b70:	7e b7                	jle    80104b29 <fork+0x153>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104b72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b78:	8b 40 68             	mov    0x68(%eax),%eax
80104b7b:	83 ec 0c             	sub    $0xc,%esp
80104b7e:	50                   	push   %eax
80104b7f:	e8 51 ce ff ff       	call   801019d5 <idup>
80104b84:	83 c4 10             	add    $0x10,%esp
80104b87:	89 c2                	mov    %eax,%edx
80104b89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b8c:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b95:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b9b:	83 c0 6c             	add    $0x6c,%eax
80104b9e:	83 ec 04             	sub    $0x4,%esp
80104ba1:	6a 10                	push   $0x10
80104ba3:	52                   	push   %edx
80104ba4:	50                   	push   %eax
80104ba5:	e8 3c 1b 00 00       	call   801066e6 <safestrcpy>
80104baa:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104bad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bb0:	8b 40 10             	mov    0x10(%eax),%eax
80104bb3:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.

 #ifdef CS333_P3P4                          // ****** check this block
    acquire(&ptable.lock);
80104bb6:	83 ec 0c             	sub    $0xc,%esp
80104bb9:	68 80 49 11 80       	push   $0x80114980
80104bbe:	e8 bd 16 00 00       	call   80106280 <acquire>
80104bc3:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104bc6:	83 ec 08             	sub    $0x8,%esp
80104bc9:	6a 01                	push   $0x1
80104bcb:	ff 75 e0             	pushl  -0x20(%ebp)
80104bce:	e8 f5 0e 00 00       	call   80105ac8 <assertState>
80104bd3:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.embryo, np);
80104bd6:	83 ec 08             	sub    $0x8,%esp
80104bd9:	ff 75 e0             	pushl  -0x20(%ebp)
80104bdc:	68 e0 70 11 80       	push   $0x801170e0
80104be1:	e8 2c 0f 00 00       	call   80105b12 <removeFromStateList>
80104be6:	83 c4 10             	add    $0x10,%esp
    np->state = RUNNABLE;
80104be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    insertTail(&ptable.pLists.ready[np -> priority], np);                 //P4 inserting at the priority index
80104bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bf6:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104bfc:	05 cc 09 00 00       	add    $0x9cc,%eax
80104c01:	c1 e0 02             	shl    $0x2,%eax
80104c04:	05 80 49 11 80       	add    $0x80114980,%eax
80104c09:	83 c0 04             	add    $0x4,%eax
80104c0c:	83 ec 08             	sub    $0x8,%esp
80104c0f:	ff 75 e0             	pushl  -0x20(%ebp)
80104c12:	50                   	push   %eax
80104c13:	e8 df 11 00 00       	call   80105df7 <insertTail>
80104c18:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104c1b:	83 ec 0c             	sub    $0xc,%esp
80104c1e:	68 80 49 11 80       	push   $0x80114980
80104c23:	e8 bf 16 00 00       	call   801062e7 <release>
80104c28:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
    np->state = RUNNABLE;                   // *** repeat same logic as above  coming from Embryo to runnable
    release(&ptable.lock);
  #endif
  
  return pid;
80104c2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5f                   	pop    %edi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    

80104c36 <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104c36:	55                   	push   %ebp
80104c37:	89 e5                	mov    %esp,%ebp
80104c39:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104c3c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c43:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c48:	39 c2                	cmp    %eax,%edx
80104c4a:	75 0d                	jne    80104c59 <exit+0x23>
    panic("init exiting");
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	68 07 9d 10 80       	push   $0x80109d07
80104c54:	e8 0d b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c60:	eb 48                	jmp    80104caa <exit+0x74>
    if(proc->ofile[fd]){
80104c62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c68:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c6b:	83 c2 08             	add    $0x8,%edx
80104c6e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c72:	85 c0                	test   %eax,%eax
80104c74:	74 30                	je     80104ca6 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104c76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c7f:	83 c2 08             	add    $0x8,%edx
80104c82:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c86:	83 ec 0c             	sub    $0xc,%esp
80104c89:	50                   	push   %eax
80104c8a:	e8 67 c4 ff ff       	call   801010f6 <fileclose>
80104c8f:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104c92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c98:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c9b:	83 c2 08             	add    $0x8,%edx
80104c9e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104ca5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104ca6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104caa:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104cae:	7e b2                	jle    80104c62 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104cb0:	e8 3d e9 ff ff       	call   801035f2 <begin_op>
  iput(proc->cwd);
80104cb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cbb:	8b 40 68             	mov    0x68(%eax),%eax
80104cbe:	83 ec 0c             	sub    $0xc,%esp
80104cc1:	50                   	push   %eax
80104cc2:	e8 18 cf ff ff       	call   80101bdf <iput>
80104cc7:	83 c4 10             	add    $0x10,%esp
  end_op();
80104cca:	e8 af e9 ff ff       	call   8010367e <end_op>
  proc->cwd = 0;
80104ccf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd5:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104cdc:	83 ec 0c             	sub    $0xc,%esp
80104cdf:	68 80 49 11 80       	push   $0x80114980
80104ce4:	e8 97 15 00 00       	call   80106280 <acquire>
80104ce9:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104cec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf2:	8b 40 14             	mov    0x14(%eax),%eax
80104cf5:	83 ec 0c             	sub    $0xc,%esp
80104cf8:	50                   	push   %eax
80104cf9:	e8 1c 08 00 00       	call   8010551a <wakeup1>
80104cfe:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d01:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104d08:	eb 3f                	jmp    80104d49 <exit+0x113>
    if(p->parent == proc){
80104d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0d:	8b 50 14             	mov    0x14(%eax),%edx
80104d10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d16:	39 c2                	cmp    %eax,%edx
80104d18:	75 28                	jne    80104d42 <exit+0x10c>
      p->parent = initproc;
80104d1a:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d23:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)                 
80104d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d29:	8b 40 0c             	mov    0xc(%eax),%eax
80104d2c:	83 f8 05             	cmp    $0x5,%eax
80104d2f:	75 11                	jne    80104d42 <exit+0x10c>
        wakeup1(initproc);
80104d31:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104d36:	83 ec 0c             	sub    $0xc,%esp
80104d39:	50                   	push   %eax
80104d3a:	e8 db 07 00 00       	call   8010551a <wakeup1>
80104d3f:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d42:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104d49:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
80104d50:	72 b8                	jb     80104d0a <exit+0xd4>
      if(p->state == ZOMBIE)                 
        wakeup1(initproc);
    }
  }

  if(removeFromStateList(&ptable.pLists.running, proc)){
80104d52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d58:	83 ec 08             	sub    $0x8,%esp
80104d5b:	50                   	push   %eax
80104d5c:	68 dc 70 11 80       	push   $0x801170dc
80104d61:	e8 ac 0d 00 00       	call   80105b12 <removeFromStateList>
80104d66:	83 c4 10             	add    $0x10,%esp
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	74 4a                	je     80104db7 <exit+0x181>
  assertState(proc, RUNNING);
80104d6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d73:	83 ec 08             	sub    $0x8,%esp
80104d76:	6a 04                	push   $0x4
80104d78:	50                   	push   %eax
80104d79:	e8 4a 0d 00 00       	call   80105ac8 <assertState>
80104d7e:	83 c4 10             	add    $0x10,%esp
  proc -> state = ZOMBIE;
80104d81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d87:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  insertAtHead(&ptable.pLists.zombie, proc);
80104d8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d94:	83 ec 08             	sub    $0x8,%esp
80104d97:	50                   	push   %eax
80104d98:	68 d8 70 11 80       	push   $0x801170d8
80104d9d:	e8 bc 10 00 00       	call   80105e5e <insertAtHead>
80104da2:	83 c4 10             	add    $0x10,%esp
  }else{
    panic("Removing from the Exit call");
  }
  sched();
80104da5:	e8 af 03 00 00       	call   80105159 <sched>
  panic("zombie exit");
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	68 30 9d 10 80       	push   $0x80109d30
80104db2:	e8 af b7 ff ff       	call   80100566 <panic>
  if(removeFromStateList(&ptable.pLists.running, proc)){
  assertState(proc, RUNNING);
  proc -> state = ZOMBIE;
  insertAtHead(&ptable.pLists.zombie, proc);
  }else{
    panic("Removing from the Exit call");
80104db7:	83 ec 0c             	sub    $0xc,%esp
80104dba:	68 14 9d 10 80       	push   $0x80109d14
80104dbf:	e8 a2 b7 ff ff       	call   80100566 <panic>

80104dc4 <wait>:
  }
}
#else
int
wait(void)
{
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	68 80 49 11 80       	push   $0x80114980
80104dd2:	e8 a9 14 00 00       	call   80106280 <acquire>
80104dd7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104dda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
80104de1:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80104de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      while(p){
80104de9:	e9 db 00 00 00       	jmp    80104ec9 <wait+0x105>
        if(p -> parent == proc){
80104dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df1:	8b 50 14             	mov    0x14(%eax),%edx
80104df4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dfa:	39 c2                	cmp    %eax,%edx
80104dfc:	0f 85 bb 00 00 00    	jne    80104ebd <wait+0xf9>
          havekids = 1;
80104e02:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
          pid = p->pid;
80104e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0c:	8b 40 10             	mov    0x10(%eax),%eax
80104e0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
          kfree(p->kstack);
80104e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e15:	8b 40 08             	mov    0x8(%eax),%eax
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	50                   	push   %eax
80104e1c:	e8 4d de ff ff       	call   80102c6e <kfree>
80104e21:	83 c4 10             	add    $0x10,%esp
          p->kstack = 0;
80104e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          freevm(p->pgdir);
80104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e31:	8b 40 04             	mov    0x4(%eax),%eax
80104e34:	83 ec 0c             	sub    $0xc,%esp
80104e37:	50                   	push   %eax
80104e38:	e8 5b 48 00 00       	call   80109698 <freevm>
80104e3d:	83 c4 10             	add    $0x10,%esp

          assertState(p, ZOMBIE);
80104e40:	83 ec 08             	sub    $0x8,%esp
80104e43:	6a 05                	push   $0x5
80104e45:	ff 75 f4             	pushl  -0xc(%ebp)
80104e48:	e8 7b 0c 00 00       	call   80105ac8 <assertState>
80104e4d:	83 c4 10             	add    $0x10,%esp
          removeFromStateList(&ptable.pLists.zombie, p);  
80104e50:	83 ec 08             	sub    $0x8,%esp
80104e53:	ff 75 f4             	pushl  -0xc(%ebp)
80104e56:	68 d8 70 11 80       	push   $0x801170d8
80104e5b:	e8 b2 0c 00 00       	call   80105b12 <removeFromStateList>
80104e60:	83 c4 10             	add    $0x10,%esp
          p->state = UNUSED;
80104e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
          insertAtHead(&ptable.pLists.free, p);
80104e6d:	83 ec 08             	sub    $0x8,%esp
80104e70:	ff 75 f4             	pushl  -0xc(%ebp)
80104e73:	68 d0 70 11 80       	push   $0x801170d0
80104e78:	e8 e1 0f 00 00       	call   80105e5e <insertAtHead>
80104e7d:	83 c4 10             	add    $0x10,%esp
          p->pid = 0;
80104e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e83:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
          p->parent = 0;
80104e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
          p->name[0] = 0;
80104e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e97:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
          p->killed = 0;
80104e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e9e:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
          release(&ptable.lock);
80104ea5:	83 ec 0c             	sub    $0xc,%esp
80104ea8:	68 80 49 11 80       	push   $0x80114980
80104ead:	e8 35 14 00 00       	call   801062e7 <release>
80104eb2:	83 c4 10             	add    $0x10,%esp
          return pid; 
80104eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104eb8:	e9 f0 00 00 00       	jmp    80104fad <wait+0x1e9>
        }else{
          p = p -> next;                         // ****** not sure about this one
80104ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;

    p = ptable.pLists.zombie;                   // ***** check out this one IMportant
      while(p){
80104ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ecd:	0f 85 1b ff ff ff    	jne    80104dee <wait+0x2a>
        }else{
          p = p -> next;                         // ****** not sure about this one
      }     
  }

  for(int i =0; i <= MAX; i++){                    //P4 make the call traversing the array list of ready
80104ed3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104eda:	eb 30                	jmp    80104f0c <wait+0x148>
    if(traverseList(&ptable.pLists.ready[i])){
80104edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104edf:	05 cc 09 00 00       	add    $0x9cc,%eax
80104ee4:	c1 e0 02             	shl    $0x2,%eax
80104ee7:	05 80 49 11 80       	add    $0x80114980,%eax
80104eec:	83 c0 04             	add    $0x4,%eax
80104eef:	83 ec 0c             	sub    $0xc,%esp
80104ef2:	50                   	push   %eax
80104ef3:	e8 d0 0c 00 00       	call   80105bc8 <traverseList>
80104ef8:	83 c4 10             	add    $0x10,%esp
80104efb:	85 c0                	test   %eax,%eax
80104efd:	74 09                	je     80104f08 <wait+0x144>
      havekids = 1;
80104eff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;                                         
80104f06:	eb 0a                	jmp    80104f12 <wait+0x14e>
        }else{
          p = p -> next;                         // ****** not sure about this one
      }     
  }

  for(int i =0; i <= MAX; i++){                    //P4 make the call traversing the array list of ready
80104f08:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104f0c:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
80104f10:	7e ca                	jle    80104edc <wait+0x118>
    if(traverseList(&ptable.pLists.ready[i])){
      havekids = 1;
      break;                                         
    }
  }
  if(traverseList(&ptable.pLists.running)){
80104f12:	83 ec 0c             	sub    $0xc,%esp
80104f15:	68 dc 70 11 80       	push   $0x801170dc
80104f1a:	e8 a9 0c 00 00       	call   80105bc8 <traverseList>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	85 c0                	test   %eax,%eax
80104f24:	74 09                	je     80104f2f <wait+0x16b>
    havekids = 1;
80104f26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104f2d:	eb 38                	jmp    80104f67 <wait+0x1a3>
  }else if(traverseList(&ptable.pLists.sleep)){
80104f2f:	83 ec 0c             	sub    $0xc,%esp
80104f32:	68 d4 70 11 80       	push   $0x801170d4
80104f37:	e8 8c 0c 00 00       	call   80105bc8 <traverseList>
80104f3c:	83 c4 10             	add    $0x10,%esp
80104f3f:	85 c0                	test   %eax,%eax
80104f41:	74 09                	je     80104f4c <wait+0x188>
    havekids = 1;
80104f43:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104f4a:	eb 1b                	jmp    80104f67 <wait+0x1a3>
  }else if(traverseList(&ptable.pLists.embryo)){
80104f4c:	83 ec 0c             	sub    $0xc,%esp
80104f4f:	68 e0 70 11 80       	push   $0x801170e0
80104f54:	e8 6f 0c 00 00       	call   80105bc8 <traverseList>
80104f59:	83 c4 10             	add    $0x10,%esp
80104f5c:	85 c0                	test   %eax,%eax
80104f5e:	74 07                	je     80104f67 <wait+0x1a3>
    havekids =1;
80104f60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  }  

  // traverse through all the lists except free and zombie and check p -> parent == proc
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104f67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f6b:	74 0d                	je     80104f7a <wait+0x1b6>
80104f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f73:	8b 40 24             	mov    0x24(%eax),%eax
80104f76:	85 c0                	test   %eax,%eax
80104f78:	74 17                	je     80104f91 <wait+0x1cd>
      release(&ptable.lock);
80104f7a:	83 ec 0c             	sub    $0xc,%esp
80104f7d:	68 80 49 11 80       	push   $0x80114980
80104f82:	e8 60 13 00 00       	call   801062e7 <release>
80104f87:	83 c4 10             	add    $0x10,%esp
      return -1;
80104f8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8f:	eb 1c                	jmp    80104fad <wait+0x1e9>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104f91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f97:	83 ec 08             	sub    $0x8,%esp
80104f9a:	68 80 49 11 80       	push   $0x80114980
80104f9f:	50                   	push   %eax
80104fa0:	e8 09 04 00 00       	call   801053ae <sleep>
80104fa5:	83 c4 10             	add    $0x10,%esp
  }
80104fa8:	e9 2d fe ff ff       	jmp    80104dda <wait+0x16>
  return 0;  // placeholder
}
80104fad:	c9                   	leave  
80104fae:	c3                   	ret    

80104faf <scheduler>:
}

#else
void
scheduler(void)
{
80104faf:	55                   	push   %ebp
80104fb0:	89 e5                	mov    %esp,%ebp
80104fb2:	83 ec 18             	sub    $0x18,%esp
struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104fb5:	e8 40 f5 ff ff       	call   801044fa <sti>

    idle = 1;  // assume idle unless we schedule a process
80104fba:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104fc1:	83 ec 0c             	sub    $0xc,%esp
80104fc4:	68 80 49 11 80       	push   $0x80114980
80104fc9:	e8 b2 12 00 00       	call   80106280 <acquire>
80104fce:	83 c4 10             	add    $0x10,%esp

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.

      if(ticks >= ptable.PromoteAtTime){                          //P4 preparing for promotion
80104fd1:	8b 15 e4 70 11 80    	mov    0x801170e4,%edx
80104fd7:	a1 00 79 11 80       	mov    0x80117900,%eax
80104fdc:	39 c2                	cmp    %eax,%edx
80104fde:	77 61                	ja     80105041 <scheduler+0x92>
        ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
80104fe0:	a1 00 79 11 80       	mov    0x80117900,%eax
80104fe5:	05 b8 0b 00 00       	add    $0xbb8,%eax
80104fea:	a3 e4 70 11 80       	mov    %eax,0x801170e4
        for(int i =1; i <= MAX; i++){                  
80104fef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104ff6:	eb 23                	jmp    8010501b <scheduler+0x6c>
          promoteOneLevelUp(&ptable.pLists.ready[i]);
80104ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ffb:	05 cc 09 00 00       	add    $0x9cc,%eax
80105000:	c1 e0 02             	shl    $0x2,%eax
80105003:	05 80 49 11 80       	add    $0x80114980,%eax
80105008:	83 c0 04             	add    $0x4,%eax
8010500b:	83 ec 0c             	sub    $0xc,%esp
8010500e:	50                   	push   %eax
8010500f:	e8 fd 0c 00 00       	call   80105d11 <promoteOneLevelUp>
80105014:	83 c4 10             	add    $0x10,%esp
      // to release ptable.lock and then reacquire it
      // before jumping back to us.

      if(ticks >= ptable.PromoteAtTime){                          //P4 preparing for promotion
        ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
        for(int i =1; i <= MAX; i++){                  
80105017:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010501b:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
8010501f:	7e d7                	jle    80104ff8 <scheduler+0x49>
          promoteOneLevelUp(&ptable.pLists.ready[i]);
        }
        promoteOneLevelUpRunSleep(&ptable.pLists.sleep);
80105021:	83 ec 0c             	sub    $0xc,%esp
80105024:	68 d4 70 11 80       	push   $0x801170d4
80105029:	e8 73 0d 00 00       	call   80105da1 <promoteOneLevelUpRunSleep>
8010502e:	83 c4 10             	add    $0x10,%esp
        promoteOneLevelUpRunSleep(&ptable.pLists.running);
80105031:	83 ec 0c             	sub    $0xc,%esp
80105034:	68 dc 70 11 80       	push   $0x801170dc
80105039:	e8 63 0d 00 00       	call   80105da1 <promoteOneLevelUpRunSleep>
8010503e:	83 c4 10             	add    $0x10,%esp
      }
      // call with sleep and running list
      for(int i = 0; i <= MAX; i++){
80105041:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105048:	e9 d9 00 00 00       	jmp    80105126 <scheduler+0x177>
      if(ptable.pLists.ready[i]){
8010504d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105050:	05 cc 09 00 00       	add    $0x9cc,%eax
80105055:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010505c:	85 c0                	test   %eax,%eax
8010505e:	0f 84 be 00 00 00    	je     80105122 <scheduler+0x173>
        p = removeFront(&ptable.pLists.ready[i]);                            //P4 *** pending -- removes from the highest priority
80105064:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105067:	05 cc 09 00 00       	add    $0x9cc,%eax
8010506c:	c1 e0 02             	shl    $0x2,%eax
8010506f:	05 80 49 11 80       	add    $0x80114980,%eax
80105074:	83 c0 04             	add    $0x4,%eax
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	50                   	push   %eax
8010507b:	e8 63 0c 00 00       	call   80105ce3 <removeFront>
80105080:	83 c4 10             	add    $0x10,%esp
80105083:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assertState(p, RUNNABLE);
80105086:	83 ec 08             	sub    $0x8,%esp
80105089:	6a 03                	push   $0x3
8010508b:	ff 75 e8             	pushl  -0x18(%ebp)
8010508e:	e8 35 0a 00 00       	call   80105ac8 <assertState>
80105093:	83 c4 10             	add    $0x10,%esp

      idle = 0;  // not idle this timeslice
80105096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      proc = p;
8010509d:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050a0:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801050a6:	83 ec 0c             	sub    $0xc,%esp
801050a9:	ff 75 e8             	pushl  -0x18(%ebp)
801050ac:	e8 a1 41 00 00       	call   80109252 <switchuvm>
801050b1:	83 c4 10             	add    $0x10,%esp
      p->cpu_ticks_in = ticks;
801050b4:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801050ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050bd:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

      p->state = RUNNING;
801050c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050c6:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      assertState(p, RUNNING);
801050cd:	83 ec 08             	sub    $0x8,%esp
801050d0:	6a 04                	push   $0x4
801050d2:	ff 75 e8             	pushl  -0x18(%ebp)
801050d5:	e8 ee 09 00 00       	call   80105ac8 <assertState>
801050da:	83 c4 10             	add    $0x10,%esp
      insertAtHead(&ptable.pLists.running, p);
801050dd:	83 ec 08             	sub    $0x8,%esp
801050e0:	ff 75 e8             	pushl  -0x18(%ebp)
801050e3:	68 dc 70 11 80       	push   $0x801170dc
801050e8:	e8 71 0d 00 00       	call   80105e5e <insertAtHead>
801050ed:	83 c4 10             	add    $0x10,%esp

      swtch(&cpu->scheduler, proc->context);
801050f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f6:	8b 40 1c             	mov    0x1c(%eax),%eax
801050f9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105100:	83 c2 04             	add    $0x4,%edx
80105103:	83 ec 08             	sub    $0x8,%esp
80105106:	50                   	push   %eax
80105107:	52                   	push   %edx
80105108:	e8 4a 16 00 00       	call   80106757 <swtch>
8010510d:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80105110:	e8 20 41 00 00       	call   80109235 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80105115:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010511c:	00 00 00 00 
      break;
80105120:	eb 0e                	jmp    80105130 <scheduler+0x181>
        }
        promoteOneLevelUpRunSleep(&ptable.pLists.sleep);
        promoteOneLevelUpRunSleep(&ptable.pLists.running);
      }
      // call with sleep and running list
      for(int i = 0; i <= MAX; i++){
80105122:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80105126:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
8010512a:	0f 8e 1d ff ff ff    	jle    8010504d <scheduler+0x9e>
      proc = 0;
      break;
    }
  }
  
    release(&ptable.lock);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	68 80 49 11 80       	push   $0x80114980
80105138:	e8 aa 11 00 00       	call   801062e7 <release>
8010513d:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80105140:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105144:	0f 84 6b fe ff ff    	je     80104fb5 <scheduler+0x6>
      sti();
8010514a:	e8 ab f3 ff ff       	call   801044fa <sti>
      hlt();
8010514f:	e8 8f f3 ff ff       	call   801044e3 <hlt>
    }
  }
80105154:	e9 5c fe ff ff       	jmp    80104fb5 <scheduler+0x6>

80105159 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80105159:	55                   	push   %ebp
8010515a:	89 e5                	mov    %esp,%ebp
8010515c:	53                   	push   %ebx
8010515d:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	68 80 49 11 80       	push   $0x80114980
80105168:	e8 46 12 00 00       	call   801063b3 <holding>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	75 0d                	jne    80105181 <sched+0x28>
    panic("sched ptable.lock");
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	68 3c 9d 10 80       	push   $0x80109d3c
8010517c:	e8 e5 b3 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105181:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105187:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010518d:	83 f8 01             	cmp    $0x1,%eax
80105190:	74 0d                	je     8010519f <sched+0x46>
    panic("sched locks");
80105192:	83 ec 0c             	sub    $0xc,%esp
80105195:	68 4e 9d 10 80       	push   $0x80109d4e
8010519a:	e8 c7 b3 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
8010519f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051a5:	8b 40 0c             	mov    0xc(%eax),%eax
801051a8:	83 f8 04             	cmp    $0x4,%eax
801051ab:	75 0d                	jne    801051ba <sched+0x61>
    panic("sched running");
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	68 5a 9d 10 80       	push   $0x80109d5a
801051b5:	e8 ac b3 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
801051ba:	e8 2b f3 ff ff       	call   801044ea <readeflags>
801051bf:	25 00 02 00 00       	and    $0x200,%eax
801051c4:	85 c0                	test   %eax,%eax
801051c6:	74 0d                	je     801051d5 <sched+0x7c>
    panic("sched interruptible");
801051c8:	83 ec 0c             	sub    $0xc,%esp
801051cb:	68 68 9d 10 80       	push   $0x80109d68
801051d0:	e8 91 b3 ff ff       	call   80100566 <panic>
  intena = cpu->intena;                                       //P4 check budget and reset it
801051d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801051db:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801051e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;        // updaates the cpu ticks total
801051e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051ea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051f1:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801051f7:	8b 1d 00 79 11 80    	mov    0x80117900,%ebx
801051fd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105204:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
8010520a:	29 d3                	sub    %edx,%ebx
8010520c:	89 da                	mov    %ebx,%edx
8010520e:	01 ca                	add    %ecx,%edx
80105210:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
80105216:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010521c:	8b 40 04             	mov    0x4(%eax),%eax
8010521f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105226:	83 c2 1c             	add    $0x1c,%edx
80105229:	83 ec 08             	sub    $0x8,%esp
8010522c:	50                   	push   %eax
8010522d:	52                   	push   %edx
8010522e:	e8 24 15 00 00       	call   80106757 <swtch>
80105233:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80105236:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010523c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010523f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105245:	90                   	nop
80105246:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105249:	c9                   	leave  
8010524a:	c3                   	ret    

8010524b <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010524b:	55                   	push   %ebp
8010524c:	89 e5                	mov    %esp,%ebp
8010524e:	53                   	push   %ebx
8010524f:	83 ec 04             	sub    $0x4,%esp
  #ifdef CS333_P3P4                             // ******* check out this one
    acquire(&ptable.lock);
80105252:	83 ec 0c             	sub    $0xc,%esp
80105255:	68 80 49 11 80       	push   $0x80114980
8010525a:	e8 21 10 00 00       	call   80106280 <acquire>
8010525f:	83 c4 10             	add    $0x10,%esp
    assertState(proc, RUNNING);
80105262:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105268:	83 ec 08             	sub    $0x8,%esp
8010526b:	6a 04                	push   $0x4
8010526d:	50                   	push   %eax
8010526e:	e8 55 08 00 00       	call   80105ac8 <assertState>
80105273:	83 c4 10             	add    $0x10,%esp
    removeFromStateList(&ptable.pLists.running, proc);
80105276:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010527c:	83 ec 08             	sub    $0x8,%esp
8010527f:	50                   	push   %eax
80105280:	68 dc 70 11 80       	push   $0x801170dc
80105285:	e8 88 08 00 00       	call   80105b12 <removeFromStateList>
8010528a:	83 c4 10             	add    $0x10,%esp
    proc -> state = RUNNABLE;
8010528d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105293:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    //P4 do logic budget -- either reset it or update
    proc -> budget -= (ticks - proc -> cpu_ticks_in);
8010529a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052a7:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
801052ad:	89 d3                	mov    %edx,%ebx
801052af:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052b6:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
801052bc:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801052c2:	29 d1                	sub    %edx,%ecx
801052c4:	89 ca                	mov    %ecx,%edx
801052c6:	01 da                	add    %ebx,%edx
801052c8:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if(proc -> budget <= 0){
801052ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d4:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801052da:	85 c0                	test   %eax,%eax
801052dc:	7f 3d                	jg     8010531b <yield+0xd0>
      proc -> budget = BUDGET;
801052de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e4:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
801052eb:	13 00 00 
      if(proc -> priority < MAX){
801052ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801052fa:	83 f8 05             	cmp    $0x5,%eax
801052fd:	7f 1c                	jg     8010531b <yield+0xd0>
        proc -> priority = proc -> priority + 1;
801052ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105305:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010530c:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105312:	83 c2 01             	add    $0x1,%edx
80105315:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      }
    }
    insertTail(&ptable.pLists.ready[proc -> priority], proc);
8010531b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105321:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105328:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
8010532e:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105334:	c1 e2 02             	shl    $0x2,%edx
80105337:	81 c2 80 49 11 80    	add    $0x80114980,%edx
8010533d:	83 c2 04             	add    $0x4,%edx
80105340:	83 ec 08             	sub    $0x8,%esp
80105343:	50                   	push   %eax
80105344:	52                   	push   %edx
80105345:	e8 ad 0a 00 00       	call   80105df7 <insertTail>
8010534a:	83 c4 10             	add    $0x10,%esp
    sched();
8010534d:	e8 07 fe ff ff       	call   80105159 <sched>
    release(&ptable.lock);
80105352:	83 ec 0c             	sub    $0xc,%esp
80105355:	68 80 49 11 80       	push   $0x80114980
8010535a:	e8 88 0f 00 00       	call   801062e7 <release>
8010535f:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
    proc->state = RUNNABLE;     // insert at tail remove from runnig and add to runnable:
    sched();
    release(&ptable.lock);
  #endif
}
80105362:	90                   	nop
80105363:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105366:	c9                   	leave  
80105367:	c3                   	ret    

80105368 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105368:	55                   	push   %ebp
80105369:	89 e5                	mov    %esp,%ebp
8010536b:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010536e:	83 ec 0c             	sub    $0xc,%esp
80105371:	68 80 49 11 80       	push   $0x80114980
80105376:	e8 6c 0f 00 00       	call   801062e7 <release>
8010537b:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010537e:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105383:	85 c0                	test   %eax,%eax
80105385:	74 24                	je     801053ab <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105387:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
8010538e:	00 00 00 
    iinit(ROOTDEV);
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	6a 01                	push   $0x1
80105396:	e8 48 c3 ff ff       	call   801016e3 <iinit>
8010539b:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
8010539e:	83 ec 0c             	sub    $0xc,%esp
801053a1:	6a 01                	push   $0x1
801053a3:	e8 2c e0 ff ff       	call   801033d4 <initlog>
801053a8:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801053ab:	90                   	nop
801053ac:	c9                   	leave  
801053ad:	c3                   	ret    

801053ae <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801053ae:	55                   	push   %ebp
801053af:	89 e5                	mov    %esp,%ebp
801053b1:	53                   	push   %ebx
801053b2:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
801053b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053bb:	85 c0                	test   %eax,%eax
801053bd:	75 0d                	jne    801053cc <sleep+0x1e>
    panic("sleep");
801053bf:	83 ec 0c             	sub    $0xc,%esp
801053c2:	68 7c 9d 10 80       	push   $0x80109d7c
801053c7:	e8 9a b1 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
801053cc:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801053d3:	74 24                	je     801053f9 <sleep+0x4b>
    acquire(&ptable.lock);
801053d5:	83 ec 0c             	sub    $0xc,%esp
801053d8:	68 80 49 11 80       	push   $0x80114980
801053dd:	e8 9e 0e 00 00       	call   80106280 <acquire>
801053e2:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
801053e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801053e9:	74 0e                	je     801053f9 <sleep+0x4b>
801053eb:	83 ec 0c             	sub    $0xc,%esp
801053ee:	ff 75 0c             	pushl  0xc(%ebp)
801053f1:	e8 f1 0e 00 00       	call   801062e7 <release>
801053f6:	83 c4 10             	add    $0x10,%esp
  }

  #ifdef CS333_P3P4                         // ******check it out 
    //acquire(&ptable.lock);
    assertState(proc, RUNNING);
801053f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ff:	83 ec 08             	sub    $0x8,%esp
80105402:	6a 04                	push   $0x4
80105404:	50                   	push   %eax
80105405:	e8 be 06 00 00       	call   80105ac8 <assertState>
8010540a:	83 c4 10             	add    $0x10,%esp
    proc -> chan = chan;
8010540d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105413:	8b 55 08             	mov    0x8(%ebp),%edx
80105416:	89 50 20             	mov    %edx,0x20(%eax)
    removeFromStateList(&ptable.pLists.running, proc);
80105419:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010541f:	83 ec 08             	sub    $0x8,%esp
80105422:	50                   	push   %eax
80105423:	68 dc 70 11 80       	push   $0x801170dc
80105428:	e8 e5 06 00 00       	call   80105b12 <removeFromStateList>
8010542d:	83 c4 10             	add    $0x10,%esp
    proc->state = SLEEPING;
80105430:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105436:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    proc -> budget -= (ticks - proc -> cpu_ticks_in);             //P4 demoting 
8010543d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105443:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010544a:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105450:	89 d3                	mov    %edx,%ebx
80105452:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105459:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010545f:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80105465:	29 d1                	sub    %edx,%ecx
80105467:	89 ca                	mov    %ecx,%edx
80105469:	01 da                	add    %ebx,%edx
8010546b:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if(proc -> budget <= 0){
80105471:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105477:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010547d:	85 c0                	test   %eax,%eax
8010547f:	7f 3d                	jg     801054be <sleep+0x110>
      proc -> budget = BUDGET;
80105481:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105487:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
8010548e:	13 00 00 
      if(proc -> priority < MAX){
80105491:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105497:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010549d:	83 f8 05             	cmp    $0x5,%eax
801054a0:	7f 1c                	jg     801054be <sleep+0x110>
        proc -> priority = proc -> priority + 1;
801054a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054af:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
801054b5:	83 c2 01             	add    $0x1,%edx
801054b8:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      }
    }
    insertAtHead(&ptable.pLists.sleep, proc);
801054be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c4:	83 ec 08             	sub    $0x8,%esp
801054c7:	50                   	push   %eax
801054c8:	68 d4 70 11 80       	push   $0x801170d4
801054cd:	e8 8c 09 00 00       	call   80105e5e <insertAtHead>
801054d2:	83 c4 10             	add    $0x10,%esp
  // Go to sleep.
  proc->chan = chan;      // remove it from running list and add it to the sleeping ....add flag first locally
  proc->state = SLEEPING;
  #endif

  sched();
801054d5:	e8 7f fc ff ff       	call   80105159 <sched>

  // Tidy up.
  proc->chan = 0;
801054da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e0:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
801054e7:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801054ee:	74 24                	je     80105514 <sleep+0x166>
    release(&ptable.lock);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	68 80 49 11 80       	push   $0x80114980
801054f8:	e8 ea 0d 00 00       	call   801062e7 <release>
801054fd:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105500:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105504:	74 0e                	je     80105514 <sleep+0x166>
80105506:	83 ec 0c             	sub    $0xc,%esp
80105509:	ff 75 0c             	pushl  0xc(%ebp)
8010550c:	e8 6f 0d 00 00       	call   80106280 <acquire>
80105511:	83 c4 10             	add    $0x10,%esp
  }
}
80105514:	90                   	nop
80105515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105518:	c9                   	leave  
80105519:	c3                   	ret    

8010551a <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)                   // ****** check it out --- should I hold the lock
{
8010551a:	55                   	push   %ebp
8010551b:	89 e5                	mov    %esp,%ebp
8010551d:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;
80105520:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105525:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(current){
80105528:	e9 a5 00 00 00       	jmp    801055d2 <wakeup1+0xb8>
    if(current -> chan == chan){
8010552d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105530:	8b 40 20             	mov    0x20(%eax),%eax
80105533:	3b 45 08             	cmp    0x8(%ebp),%eax
80105536:	0f 85 8a 00 00 00    	jne    801055c6 <wakeup1+0xac>
      temp = current -> next;
8010553c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010553f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105545:	89 45 f0             	mov    %eax,-0x10(%ebp)
      assertState(current, SLEEPING);
80105548:	83 ec 08             	sub    $0x8,%esp
8010554b:	6a 02                	push   $0x2
8010554d:	ff 75 f4             	pushl  -0xc(%ebp)
80105550:	e8 73 05 00 00       	call   80105ac8 <assertState>
80105555:	83 c4 10             	add    $0x10,%esp
      if(removeFromStateList(&ptable.pLists.sleep, current)){
80105558:	83 ec 08             	sub    $0x8,%esp
8010555b:	ff 75 f4             	pushl  -0xc(%ebp)
8010555e:	68 d4 70 11 80       	push   $0x801170d4
80105563:	e8 aa 05 00 00       	call   80105b12 <removeFromStateList>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	74 4a                	je     801055b9 <wakeup1+0x9f>
      current -> state = RUNNABLE;
8010556f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105572:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      assertState(current, RUNNABLE);
80105579:	83 ec 08             	sub    $0x8,%esp
8010557c:	6a 03                	push   $0x3
8010557e:	ff 75 f4             	pushl  -0xc(%ebp)
80105581:	e8 42 05 00 00       	call   80105ac8 <assertState>
80105586:	83 c4 10             	add    $0x10,%esp
      insertTail(&ptable.pLists.ready[current -> priority], current);            //P4 insert proper list
80105589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010558c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105592:	05 cc 09 00 00       	add    $0x9cc,%eax
80105597:	c1 e0 02             	shl    $0x2,%eax
8010559a:	05 80 49 11 80       	add    $0x80114980,%eax
8010559f:	83 c0 04             	add    $0x4,%eax
801055a2:	83 ec 08             	sub    $0x8,%esp
801055a5:	ff 75 f4             	pushl  -0xc(%ebp)
801055a8:	50                   	push   %eax
801055a9:	e8 49 08 00 00       	call   80105df7 <insertTail>
801055ae:	83 c4 10             	add    $0x10,%esp
      }else{
        panic("wakeup1 not doing the job");
      }
      current = temp;    
801055b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055b7:	eb 19                	jmp    801055d2 <wakeup1+0xb8>
      if(removeFromStateList(&ptable.pLists.sleep, current)){
      current -> state = RUNNABLE;
      assertState(current, RUNNABLE);
      insertTail(&ptable.pLists.ready[current -> priority], current);            //P4 insert proper list
      }else{
        panic("wakeup1 not doing the job");
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	68 82 9d 10 80       	push   $0x80109d82
801055c1:	e8 a0 af ff ff       	call   80100566 <panic>
      }
      current = temp;    
    }else{
      current = current -> next;
801055c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801055cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc * current;
  struct proc * temp;
  current = ptable.pLists.sleep;

  while(current){
801055d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055d6:	0f 85 51 ff ff ff    	jne    8010552d <wakeup1+0x13>
      current = temp;    
    }else{
      current = current -> next;
    }
  }  
}
801055dc:	90                   	nop
801055dd:	c9                   	leave  
801055de:	c3                   	ret    

801055df <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801055df:	55                   	push   %ebp
801055e0:	89 e5                	mov    %esp,%ebp
801055e2:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	68 80 49 11 80       	push   $0x80114980
801055ed:	e8 8e 0c 00 00       	call   80106280 <acquire>
801055f2:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801055f5:	83 ec 0c             	sub    $0xc,%esp
801055f8:	ff 75 08             	pushl  0x8(%ebp)
801055fb:	e8 1a ff ff ff       	call   8010551a <wakeup1>
80105600:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105603:	83 ec 0c             	sub    $0xc,%esp
80105606:	68 80 49 11 80       	push   $0x80114980
8010560b:	e8 d7 0c 00 00       	call   801062e7 <release>
80105610:	83 c4 10             	add    $0x10,%esp
}
80105613:	90                   	nop
80105614:	c9                   	leave  
80105615:	c3                   	ret    

80105616 <kill>:
  return -1;
}
#else
int
kill(int pid)                 //******* move the logic from the helper function here
{
80105616:	55                   	push   %ebp
80105617:	89 e5                	mov    %esp,%ebp
80105619:	83 ec 18             	sub    $0x18,%esp
  if(traverseToKill(&ptable.pLists.sleep, pid) == 0)
8010561c:	83 ec 08             	sub    $0x8,%esp
8010561f:	ff 75 08             	pushl  0x8(%ebp)
80105622:	68 d4 70 11 80       	push   $0x801170d4
80105627:	e8 dc 05 00 00       	call   80105c08 <traverseToKill>
8010562c:	83 c4 10             	add    $0x10,%esp
8010562f:	85 c0                	test   %eax,%eax
80105631:	75 0a                	jne    8010563d <kill+0x27>
  return 1;
80105633:	b8 01 00 00 00       	mov    $0x1,%eax
80105638:	e9 a2 00 00 00       	jmp    801056df <kill+0xc9>
  if(traverseToKill(&ptable.pLists.zombie, pid) == 0)
8010563d:	83 ec 08             	sub    $0x8,%esp
80105640:	ff 75 08             	pushl  0x8(%ebp)
80105643:	68 d8 70 11 80       	push   $0x801170d8
80105648:	e8 bb 05 00 00       	call   80105c08 <traverseToKill>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	75 0a                	jne    8010565e <kill+0x48>
  return 1; 
80105654:	b8 01 00 00 00       	mov    $0x1,%eax
80105659:	e9 81 00 00 00       	jmp    801056df <kill+0xc9>
  if(traverseToKill(&ptable.pLists.running, pid) == 0)
8010565e:	83 ec 08             	sub    $0x8,%esp
80105661:	ff 75 08             	pushl  0x8(%ebp)
80105664:	68 dc 70 11 80       	push   $0x801170dc
80105669:	e8 9a 05 00 00       	call   80105c08 <traverseToKill>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	75 07                	jne    8010567c <kill+0x66>
  return 1;
80105675:	b8 01 00 00 00       	mov    $0x1,%eax
8010567a:	eb 63                	jmp    801056df <kill+0xc9>
  if(traverseToKill(&ptable.pLists.embryo, pid) == 0)
8010567c:	83 ec 08             	sub    $0x8,%esp
8010567f:	ff 75 08             	pushl  0x8(%ebp)
80105682:	68 e0 70 11 80       	push   $0x801170e0
80105687:	e8 7c 05 00 00       	call   80105c08 <traverseToKill>
8010568c:	83 c4 10             	add    $0x10,%esp
8010568f:	85 c0                	test   %eax,%eax
80105691:	75 07                	jne    8010569a <kill+0x84>
  return 1;
80105693:	b8 01 00 00 00       	mov    $0x1,%eax
80105698:	eb 45                	jmp    801056df <kill+0xc9>
  for(int i =0; i <= MAX; i++){                            //P4 iterate through the array
8010569a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801056a1:	eb 31                	jmp    801056d4 <kill+0xbe>
    if(traverseToKill(&ptable.pLists.ready[i],pid) ==0)
801056a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a6:	05 cc 09 00 00       	add    $0x9cc,%eax
801056ab:	c1 e0 02             	shl    $0x2,%eax
801056ae:	05 80 49 11 80       	add    $0x80114980,%eax
801056b3:	83 c0 04             	add    $0x4,%eax
801056b6:	83 ec 08             	sub    $0x8,%esp
801056b9:	ff 75 08             	pushl  0x8(%ebp)
801056bc:	50                   	push   %eax
801056bd:	e8 46 05 00 00       	call   80105c08 <traverseToKill>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	75 07                	jne    801056d0 <kill+0xba>
      return 1;
801056c9:	b8 01 00 00 00       	mov    $0x1,%eax
801056ce:	eb 0f                	jmp    801056df <kill+0xc9>
  return 1; 
  if(traverseToKill(&ptable.pLists.running, pid) == 0)
  return 1;
  if(traverseToKill(&ptable.pLists.embryo, pid) == 0)
  return 1;
  for(int i =0; i <= MAX; i++){                            //P4 iterate through the array
801056d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801056d4:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
801056d8:	7e c9                	jle    801056a3 <kill+0x8d>
    if(traverseToKill(&ptable.pLists.ready[i],pid) ==0)
      return 1;
  }

  return -1;  // placeholder
801056da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056df:	c9                   	leave  
801056e0:	c3                   	ret    

801056e1 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801056e1:	55                   	push   %ebp
801056e2:	89 e5                	mov    %esp,%ebp
801056e4:	57                   	push   %edi
801056e5:	56                   	push   %esi
801056e6:	53                   	push   %ebx
801056e7:	83 ec 6c             	sub    $0x6c,%esp
  int time_difference; 
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
801056ea:	83 ec 0c             	sub    $0xc,%esp
801056ed:	68 c4 9d 10 80       	push   $0x80109dc4
801056f2:	e8 cf ac ff ff       	call   801003c6 <cprintf>
801056f7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801056fa:	c7 45 e0 b4 49 11 80 	movl   $0x801149b4,-0x20(%ebp)
80105701:	e9 ad 01 00 00       	jmp    801058b3 <procdump+0x1d2>
    if(p->state == UNUSED)
80105706:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105709:	8b 40 0c             	mov    0xc(%eax),%eax
8010570c:	85 c0                	test   %eax,%eax
8010570e:	0f 84 97 01 00 00    	je     801058ab <procdump+0x1ca>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state]){
80105714:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105717:	8b 40 0c             	mov    0xc(%eax),%eax
8010571a:	83 f8 05             	cmp    $0x5,%eax
8010571d:	77 23                	ja     80105742 <procdump+0x61>
8010571f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105722:	8b 40 0c             	mov    0xc(%eax),%eax
80105725:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010572c:	85 c0                	test   %eax,%eax
8010572e:	74 12                	je     80105742 <procdump+0x61>
      state = states[p->state];
80105730:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105733:	8b 40 0c             	mov    0xc(%eax),%eax
80105736:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010573d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105740:	eb 07                	jmp    80105749 <procdump+0x68>
    }	
    else
      state = "???";
80105742:	c7 45 dc f9 9d 10 80 	movl   $0x80109df9,-0x24(%ebp)
      time_difference = ticks - p->start_ticks;
80105749:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010574f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105752:	8b 40 7c             	mov    0x7c(%eax),%eax
80105755:	29 c2                	sub    %eax,%edx
80105757:	89 d0                	mov    %edx,%eax
80105759:	89 45 d8             	mov    %eax,-0x28(%ebp)
      seconds = (time_difference)/1000;
8010575c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010575f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105764:	89 c8                	mov    %ecx,%eax
80105766:	f7 ea                	imul   %edx
80105768:	c1 fa 06             	sar    $0x6,%edx
8010576b:	89 c8                	mov    %ecx,%eax
8010576d:	c1 f8 1f             	sar    $0x1f,%eax
80105770:	29 c2                	sub    %eax,%edx
80105772:	89 d0                	mov    %edx,%eax
80105774:	89 45 d4             	mov    %eax,-0x2c(%ebp)
      time_difference -= seconds * 1000;
80105777:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010577a:	69 c0 18 fc ff ff    	imul   $0xfffffc18,%eax,%eax
80105780:	01 45 d8             	add    %eax,-0x28(%ebp)
      milliseconds = time_difference/100;
80105783:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105786:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010578b:	89 c8                	mov    %ecx,%eax
8010578d:	f7 ea                	imul   %edx
8010578f:	c1 fa 05             	sar    $0x5,%edx
80105792:	89 c8                	mov    %ecx,%eax
80105794:	c1 f8 1f             	sar    $0x1f,%eax
80105797:	29 c2                	sub    %eax,%edx
80105799:	89 d0                	mov    %edx,%eax
8010579b:	89 45 d0             	mov    %eax,-0x30(%ebp)
      time_difference -= milliseconds *100;
8010579e:	8b 45 d0             	mov    -0x30(%ebp),%eax
801057a1:	6b c0 9c             	imul   $0xffffff9c,%eax,%eax
801057a4:	01 45 d8             	add    %eax,-0x28(%ebp)
      temp = (time_difference)/10;
801057a7:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801057aa:	ba 67 66 66 66       	mov    $0x66666667,%edx
801057af:	89 c8                	mov    %ecx,%eax
801057b1:	f7 ea                	imul   %edx
801057b3:	c1 fa 02             	sar    $0x2,%edx
801057b6:	89 c8                	mov    %ecx,%eax
801057b8:	c1 f8 1f             	sar    $0x1f,%eax
801057bb:	29 c2                	sub    %eax,%edx
801057bd:	89 d0                	mov    %edx,%eax
801057bf:	89 45 cc             	mov    %eax,-0x34(%ebp)
      time_difference -= temp * 10; 
801057c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801057c5:	6b c0 f6             	imul   $0xfffffff6,%eax,%eax
801057c8:	01 45 d8             	add    %eax,-0x28(%ebp)
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->priority,p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
801057cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057ce:	8b 10                	mov    (%eax),%edx
801057d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057d3:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801057d9:	89 45 94             	mov    %eax,-0x6c(%ebp)
801057dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057df:	8b b8 94 00 00 00    	mov    0x94(%eax),%edi
801057e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057e8:	8b 40 14             	mov    0x14(%eax),%eax
801057eb:	8b 70 10             	mov    0x10(%eax),%esi
801057ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057f1:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
801057f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057fa:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80105800:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105803:	83 c0 6c             	add    $0x6c,%eax
80105806:	89 45 90             	mov    %eax,-0x70(%ebp)
80105809:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010580c:	8b 40 10             	mov    0x10(%eax),%eax
8010580f:	83 ec 08             	sub    $0x8,%esp
80105812:	ff 75 d8             	pushl  -0x28(%ebp)
80105815:	ff 75 cc             	pushl  -0x34(%ebp)
80105818:	ff 75 d0             	pushl  -0x30(%ebp)
8010581b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010581e:	52                   	push   %edx
8010581f:	ff 75 94             	pushl  -0x6c(%ebp)
80105822:	57                   	push   %edi
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	51                   	push   %ecx
80105826:	ff 75 90             	pushl  -0x70(%ebp)
80105829:	ff 75 dc             	pushl  -0x24(%ebp)
8010582c:	50                   	push   %eax
8010582d:	68 00 9e 10 80       	push   $0x80109e00
80105832:	e8 8f ab ff ff       	call   801003c6 <cprintf>
80105837:	83 c4 40             	add    $0x40,%esp
    if(p->state == SLEEPING){
8010583a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010583d:	8b 40 0c             	mov    0xc(%eax),%eax
80105840:	83 f8 02             	cmp    $0x2,%eax
80105843:	75 54                	jne    80105899 <procdump+0x1b8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105845:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105848:	8b 40 1c             	mov    0x1c(%eax),%eax
8010584b:	8b 40 0c             	mov    0xc(%eax),%eax
8010584e:	83 c0 08             	add    $0x8,%eax
80105851:	89 c2                	mov    %eax,%edx
80105853:	83 ec 08             	sub    $0x8,%esp
80105856:	8d 45 a4             	lea    -0x5c(%ebp),%eax
80105859:	50                   	push   %eax
8010585a:	52                   	push   %edx
8010585b:	e8 d9 0a 00 00       	call   80106339 <getcallerpcs>
80105860:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105863:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010586a:	eb 1c                	jmp    80105888 <procdump+0x1a7>
        cprintf(" %p", pc[i]);
8010586c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010586f:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
80105873:	83 ec 08             	sub    $0x8,%esp
80105876:	50                   	push   %eax
80105877:	68 26 9e 10 80       	push   $0x80109e26
8010587c:	e8 45 ab ff ff       	call   801003c6 <cprintf>
80105881:	83 c4 10             	add    $0x10,%esp
      time_difference -= temp * 10; 
      	 
    cprintf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d.%d%d%d\t", p->pid, state, p->name, p-> uid, p->gid, p->parent->pid, p->priority,p->cpu_ticks_total, p->sz, seconds, milliseconds,temp,time_difference);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105884:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105888:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
8010588c:	7f 0b                	jg     80105899 <procdump+0x1b8>
8010588e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105891:	8b 44 85 a4          	mov    -0x5c(%ebp,%eax,4),%eax
80105895:	85 c0                	test   %eax,%eax
80105897:	75 d3                	jne    8010586c <procdump+0x18b>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	68 2a 9e 10 80       	push   $0x80109e2a
801058a1:	e8 20 ab ff ff       	call   801003c6 <cprintf>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	eb 01                	jmp    801058ac <procdump+0x1cb>
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801058ab:	90                   	nop
  int seconds;
  int milliseconds;
  int temp;
   
  cprintf("PID\tSta\tName\tUID\tGID\tPPID\tPri\tCPU\tSIZE\tElapsed\t PCs\n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058ac:	81 45 e0 9c 00 00 00 	addl   $0x9c,-0x20(%ebp)
801058b3:	81 7d e0 b4 70 11 80 	cmpl   $0x801170b4,-0x20(%ebp)
801058ba:	0f 82 46 fe ff ff    	jb     80105706 <procdump+0x25>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801058c0:	90                   	nop
801058c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c4:	5b                   	pop    %ebx
801058c5:	5e                   	pop    %esi
801058c6:	5f                   	pop    %edi
801058c7:	5d                   	pop    %ebp
801058c8:	c3                   	ret    

801058c9 <getprocs>:

int
getprocs(uint max, struct uproc* table){
801058c9:	55                   	push   %ebp
801058ca:	89 e5                	mov    %esp,%ebp
801058cc:	83 ec 18             	sub    $0x18,%esp
  int index = 0;      // which is my count of processes at the same time
801058cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *p;
  
    acquire(&ptable.lock);
801058d6:	83 ec 0c             	sub    $0xc,%esp
801058d9:	68 80 49 11 80       	push   $0x80114980
801058de:	e8 9d 09 00 00       	call   80106280 <acquire>
801058e3:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
801058e6:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
801058ed:	e9 ac 01 00 00       	jmp    80105a9e <getprocs+0x1d5>
      if(p->state == RUNNABLE || p->state == SLEEPING || p->state == RUNNING){
801058f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058f5:	8b 40 0c             	mov    0xc(%eax),%eax
801058f8:	83 f8 03             	cmp    $0x3,%eax
801058fb:	74 1a                	je     80105917 <getprocs+0x4e>
801058fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105900:	8b 40 0c             	mov    0xc(%eax),%eax
80105903:	83 f8 02             	cmp    $0x2,%eax
80105906:	74 0f                	je     80105917 <getprocs+0x4e>
80105908:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010590b:	8b 40 0c             	mov    0xc(%eax),%eax
8010590e:	83 f8 04             	cmp    $0x4,%eax
80105911:	0f 85 80 01 00 00    	jne    80105a97 <getprocs+0x1ce>
        table[index].pid = p -> pid;
80105917:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010591a:	89 d0                	mov    %edx,%eax
8010591c:	01 c0                	add    %eax,%eax
8010591e:	01 d0                	add    %edx,%eax
80105920:	c1 e0 05             	shl    $0x5,%eax
80105923:	89 c2                	mov    %eax,%edx
80105925:	8b 45 0c             	mov    0xc(%ebp),%eax
80105928:	01 c2                	add    %eax,%edx
8010592a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010592d:	8b 40 10             	mov    0x10(%eax),%eax
80105930:	89 02                	mov    %eax,(%edx)
        table[index].uid = p -> uid;
80105932:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105935:	89 d0                	mov    %edx,%eax
80105937:	01 c0                	add    %eax,%eax
80105939:	01 d0                	add    %edx,%eax
8010593b:	c1 e0 05             	shl    $0x5,%eax
8010593e:	89 c2                	mov    %eax,%edx
80105940:	8b 45 0c             	mov    0xc(%ebp),%eax
80105943:	01 c2                	add    %eax,%edx
80105945:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105948:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010594e:	89 42 04             	mov    %eax,0x4(%edx)
        table[index].gid = p -> gid;
80105951:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105954:	89 d0                	mov    %edx,%eax
80105956:	01 c0                	add    %eax,%eax
80105958:	01 d0                	add    %edx,%eax
8010595a:	c1 e0 05             	shl    $0x5,%eax
8010595d:	89 c2                	mov    %eax,%edx
8010595f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105962:	01 c2                	add    %eax,%edx
80105964:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105967:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010596d:	89 42 08             	mov    %eax,0x8(%edx)
        if(p -> parent == 0)
80105970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105973:	8b 40 14             	mov    0x14(%eax),%eax
80105976:	85 c0                	test   %eax,%eax
80105978:	75 1e                	jne    80105998 <getprocs+0xcf>
		      table[index].ppid = p->pid;
8010597a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010597d:	89 d0                	mov    %edx,%eax
8010597f:	01 c0                	add    %eax,%eax
80105981:	01 d0                	add    %edx,%eax
80105983:	c1 e0 05             	shl    $0x5,%eax
80105986:	89 c2                	mov    %eax,%edx
80105988:	8b 45 0c             	mov    0xc(%ebp),%eax
8010598b:	01 c2                	add    %eax,%edx
8010598d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105990:	8b 40 10             	mov    0x10(%eax),%eax
80105993:	89 42 0c             	mov    %eax,0xc(%edx)
80105996:	eb 1f                	jmp    801059b7 <getprocs+0xee>
	      else 	
        	table[index].ppid = p -> parent -> pid;
80105998:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010599b:	89 d0                	mov    %edx,%eax
8010599d:	01 c0                	add    %eax,%eax
8010599f:	01 d0                	add    %edx,%eax
801059a1:	c1 e0 05             	shl    $0x5,%eax
801059a4:	89 c2                	mov    %eax,%edx
801059a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801059a9:	01 c2                	add    %eax,%edx
801059ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059ae:	8b 40 14             	mov    0x14(%eax),%eax
801059b1:	8b 40 10             	mov    0x10(%eax),%eax
801059b4:	89 42 0c             	mov    %eax,0xc(%edx)
        table[index].priority = p -> priority;                  //P4
801059b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ba:	89 d0                	mov    %edx,%eax
801059bc:	01 c0                	add    %eax,%eax
801059be:	01 d0                	add    %edx,%eax
801059c0:	c1 e0 05             	shl    $0x5,%eax
801059c3:	89 c2                	mov    %eax,%edx
801059c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801059c8:	01 c2                	add    %eax,%edx
801059ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059cd:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801059d3:	89 42 5c             	mov    %eax,0x5c(%edx)
        table[index].elapsed_ticks = ticks - p -> start_ticks;
801059d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059d9:	89 d0                	mov    %edx,%eax
801059db:	01 c0                	add    %eax,%eax
801059dd:	01 d0                	add    %edx,%eax
801059df:	c1 e0 05             	shl    $0x5,%eax
801059e2:	89 c2                	mov    %eax,%edx
801059e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801059e7:	01 c2                	add    %eax,%edx
801059e9:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
801059ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f2:	8b 40 7c             	mov    0x7c(%eax),%eax
801059f5:	29 c1                	sub    %eax,%ecx
801059f7:	89 c8                	mov    %ecx,%eax
801059f9:	89 42 10             	mov    %eax,0x10(%edx)
        table[index].CPU_total_ticks = p -> cpu_ticks_total;
801059fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ff:	89 d0                	mov    %edx,%eax
80105a01:	01 c0                	add    %eax,%eax
80105a03:	01 d0                	add    %edx,%eax
80105a05:	c1 e0 05             	shl    $0x5,%eax
80105a08:	89 c2                	mov    %eax,%edx
80105a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a0d:	01 c2                	add    %eax,%edx
80105a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a12:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105a18:	89 42 14             	mov    %eax,0x14(%edx)
        safestrcpy(table[index].state, states[p-> state], STRMAX);      
80105a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a1e:	8b 40 0c             	mov    0xc(%eax),%eax
80105a21:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a2b:	89 d0                	mov    %edx,%eax
80105a2d:	01 c0                	add    %eax,%eax
80105a2f:	01 d0                	add    %edx,%eax
80105a31:	c1 e0 05             	shl    $0x5,%eax
80105a34:	89 c2                	mov    %eax,%edx
80105a36:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a39:	01 d0                	add    %edx,%eax
80105a3b:	83 c0 18             	add    $0x18,%eax
80105a3e:	83 ec 04             	sub    $0x4,%esp
80105a41:	6a 20                	push   $0x20
80105a43:	51                   	push   %ecx
80105a44:	50                   	push   %eax
80105a45:	e8 9c 0c 00 00       	call   801066e6 <safestrcpy>
80105a4a:	83 c4 10             	add    $0x10,%esp
        table[index].size = p -> sz;
80105a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a50:	89 d0                	mov    %edx,%eax
80105a52:	01 c0                	add    %eax,%eax
80105a54:	01 d0                	add    %edx,%eax
80105a56:	c1 e0 05             	shl    $0x5,%eax
80105a59:	89 c2                	mov    %eax,%edx
80105a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a5e:	01 c2                	add    %eax,%edx
80105a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a63:	8b 00                	mov    (%eax),%eax
80105a65:	89 42 38             	mov    %eax,0x38(%edx)
        safestrcpy(table[index].name, p-> name, STRMAX);          
80105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6b:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a71:	89 d0                	mov    %edx,%eax
80105a73:	01 c0                	add    %eax,%eax
80105a75:	01 d0                	add    %edx,%eax
80105a77:	c1 e0 05             	shl    $0x5,%eax
80105a7a:	89 c2                	mov    %eax,%edx
80105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a7f:	01 d0                	add    %edx,%eax
80105a81:	83 c0 3c             	add    $0x3c,%eax
80105a84:	83 ec 04             	sub    $0x4,%esp
80105a87:	6a 20                	push   $0x20
80105a89:	51                   	push   %ecx
80105a8a:	50                   	push   %eax
80105a8b:	e8 56 0c 00 00       	call   801066e6 <safestrcpy>
80105a90:	83 c4 10             	add    $0x10,%esp
        index++; // after 
80105a93:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc* table){
  int index = 0;      // which is my count of processes at the same time
  struct proc *p;
  
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && index < max ; p++){
80105a97:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105a9e:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105aa5:	73 0c                	jae    80105ab3 <getprocs+0x1ea>
80105aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
80105aad:	0f 82 3f fe ff ff    	jb     801058f2 <getprocs+0x29>
        table[index].size = p -> sz;
        safestrcpy(table[index].name, p-> name, STRMAX);          
        index++; // after 
      }
    }
    release(&ptable.lock);
80105ab3:	83 ec 0c             	sub    $0xc,%esp
80105ab6:	68 80 49 11 80       	push   $0x80114980
80105abb:	e8 27 08 00 00       	call   801062e7 <release>
80105ac0:	83 c4 10             	add    $0x10,%esp
    return index;    
80105ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105ac6:	c9                   	leave  
80105ac7:	c3                   	ret    

80105ac8 <assertState>:

// Project #3 helper functions 

#ifdef CS333_P3P4
static void
assertState(struct proc * p, enum procstate state){
80105ac8:	55                   	push   %ebp
80105ac9:	89 e5                	mov    %esp,%ebp
80105acb:	83 ec 08             	sub    $0x8,%esp
  if( p -> state != state){
80105ace:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad1:	8b 40 0c             	mov    0xc(%eax),%eax
80105ad4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105ad7:	74 36                	je     80105b0f <assertState+0x47>
    cprintf("Different states: current %s and expected %s\n", states[p-> state], states[state]);
80105ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105adc:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae6:	8b 40 0c             	mov    0xc(%eax),%eax
80105ae9:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105af0:	83 ec 04             	sub    $0x4,%esp
80105af3:	52                   	push   %edx
80105af4:	50                   	push   %eax
80105af5:	68 2c 9e 10 80       	push   $0x80109e2c
80105afa:	e8 c7 a8 ff ff       	call   801003c6 <cprintf>
80105aff:	83 c4 10             	add    $0x10,%esp
    panic("Panic different states");
80105b02:	83 ec 0c             	sub    $0xc,%esp
80105b05:	68 5a 9e 10 80       	push   $0x80109e5a
80105b0a:	e8 57 aa ff ff       	call   80100566 <panic>
  }
}
80105b0f:	90                   	nop
80105b10:	c9                   	leave  
80105b11:	c3                   	ret    

80105b12 <removeFromStateList>:

static int
removeFromStateList(struct proc** sList, struct proc * p){
80105b12:	55                   	push   %ebp
80105b13:	89 e5                	mov    %esp,%ebp
80105b15:	83 ec 18             	sub    $0x18,%esp
  struct proc * current; 
  struct proc * previous;
  current = *sList;
80105b18:	8b 45 08             	mov    0x8(%ebp),%eax
80105b1b:	8b 00                	mov    (%eax),%eax
80105b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(current == 0)
80105b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b24:	75 0d                	jne    80105b33 <removeFromStateList+0x21>
    panic("Nothing in sList");
80105b26:	83 ec 0c             	sub    $0xc,%esp
80105b29:	68 71 9e 10 80       	push   $0x80109e71
80105b2e:	e8 33 aa ff ff       	call   80100566 <panic>

  if(current == p){
80105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b36:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105b39:	75 22                	jne    80105b5d <removeFromStateList+0x4b>
    *sList = p -> next;
80105b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b3e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105b44:	8b 45 08             	mov    0x8(%ebp),%eax
80105b47:	89 10                	mov    %edx,(%eax)
    p -> next = 0;
80105b49:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b4c:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105b53:	00 00 00 
    return 1;
80105b56:	b8 01 00 00 00       	mov    $0x1,%eax
80105b5b:	eb 69                	jmp    80105bc6 <removeFromStateList+0xb4>
  }

  previous = *sList;
80105b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80105b60:	8b 00                	mov    (%eax),%eax
80105b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  current = current -> next;
80105b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b68:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  while(current){
80105b71:	eb 40                	jmp    80105bb3 <removeFromStateList+0xa1>
    if(current == p){
80105b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105b79:	75 26                	jne    80105ba1 <removeFromStateList+0x8f>
      previous -> next = current -> next;
80105b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b87:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      current -> next = 0;
80105b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b90:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105b97:	00 00 00 
      return 1 ;
80105b9a:	b8 01 00 00 00       	mov    $0x1,%eax
80105b9f:	eb 25                	jmp    80105bc6 <removeFromStateList+0xb4>
    }
    previous = current;
80105ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    current = current -> next;
80105ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baa:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  previous = *sList;
  current = current -> next;
 
  while(current){
80105bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bb7:	75 ba                	jne    80105b73 <removeFromStateList+0x61>
      return 1 ;
    }
    previous = current;
    current = current -> next;
  }
  panic("I'm not in the list -- removeFromStateList call");
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	68 84 9e 10 80       	push   $0x80109e84
80105bc1:	e8 a0 a9 ff ff       	call   80100566 <panic>
  return 0;
}
80105bc6:	c9                   	leave  
80105bc7:	c3                   	ret    

80105bc8 <traverseList>:


static int
traverseList(struct proc **sList){
80105bc8:	55                   	push   %ebp
80105bc9:	89 e5                	mov    %esp,%ebp
80105bcb:	83 ec 10             	sub    $0x10,%esp
    struct proc * current;
    current = *sList;
80105bce:	8b 45 08             	mov    0x8(%ebp),%eax
80105bd1:	8b 00                	mov    (%eax),%eax
80105bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    //int count = 0;
    while(current){
80105bd6:	eb 23                	jmp    80105bfb <traverseList+0x33>
      if(current -> parent == proc){
80105bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bdb:	8b 50 14             	mov    0x14(%eax),%edx
80105bde:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105be4:	39 c2                	cmp    %eax,%edx
80105be6:	75 07                	jne    80105bef <traverseList+0x27>
        return 1;
80105be8:	b8 01 00 00 00       	mov    $0x1,%eax
80105bed:	eb 17                	jmp    80105c06 <traverseList+0x3e>
      }
      current = current -> next;
80105bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bf2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
static int
traverseList(struct proc **sList){
    struct proc * current;
    current = *sList;
    //int count = 0;
    while(current){
80105bfb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105bff:	75 d7                	jne    80105bd8 <traverseList+0x10>
      if(current -> parent == proc){
        return 1;
      }
      current = current -> next;
    }
    return 0;
80105c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c06:	c9                   	leave  
80105c07:	c3                   	ret    

80105c08 <traverseToKill>:

static int 
traverseToKill(struct proc **sList, int pid){
80105c08:	55                   	push   %ebp
80105c09:	89 e5                	mov    %esp,%ebp
80105c0b:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
80105c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80105c11:	8b 00                	mov    (%eax),%eax
80105c13:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);     // *****move the lock before the function call outside
80105c16:	83 ec 0c             	sub    $0xc,%esp
80105c19:	68 80 49 11 80       	push   $0x80114980
80105c1e:	e8 5d 06 00 00       	call   80106280 <acquire>
80105c23:	83 c4 10             	add    $0x10,%esp

  while(current){
80105c26:	e9 97 00 00 00       	jmp    80105cc2 <traverseToKill+0xba>
    if(current -> pid == pid){
80105c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c2e:	8b 50 10             	mov    0x10(%eax),%edx
80105c31:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c34:	39 c2                	cmp    %eax,%edx
80105c36:	75 7e                	jne    80105cb6 <traverseToKill+0xae>
      current -> killed = 1;
80105c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(current -> state == SLEEPING){ // assert state sleeping
80105c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c45:	8b 40 0c             	mov    0xc(%eax),%eax
80105c48:	83 f8 02             	cmp    $0x2,%eax
80105c4b:	75 52                	jne    80105c9f <traverseToKill+0x97>
        removeFromStateList(&ptable.pLists.sleep, current);
80105c4d:	83 ec 08             	sub    $0x8,%esp
80105c50:	ff 75 f4             	pushl  -0xc(%ebp)
80105c53:	68 d4 70 11 80       	push   $0x801170d4
80105c58:	e8 b5 fe ff ff       	call   80105b12 <removeFromStateList>
80105c5d:	83 c4 10             	add    $0x10,%esp
        current -> state = RUNNABLE;
80105c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c63:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        current -> priority = 0;                  //P4 put it to the first priority queue -- it gets out of the system sooner 
80105c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c6d:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80105c74:	00 00 00 
        insertTail(&ptable.pLists.ready[current -> priority], current);                  //P4 put it at the same priority level
80105c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7a:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c80:	05 cc 09 00 00       	add    $0x9cc,%eax
80105c85:	c1 e0 02             	shl    $0x2,%eax
80105c88:	05 80 49 11 80       	add    $0x80114980,%eax
80105c8d:	83 c0 04             	add    $0x4,%eax
80105c90:	83 ec 08             	sub    $0x8,%esp
80105c93:	ff 75 f4             	pushl  -0xc(%ebp)
80105c96:	50                   	push   %eax
80105c97:	e8 5b 01 00 00       	call   80105df7 <insertTail>
80105c9c:	83 c4 10             	add    $0x10,%esp
      }
      release(&ptable.lock);
80105c9f:	83 ec 0c             	sub    $0xc,%esp
80105ca2:	68 80 49 11 80       	push   $0x80114980
80105ca7:	e8 3b 06 00 00       	call   801062e7 <release>
80105cac:	83 c4 10             	add    $0x10,%esp
      return 1;
80105caf:	b8 01 00 00 00       	mov    $0x1,%eax
80105cb4:	eb 2b                	jmp    80105ce1 <traverseToKill+0xd9>
    }else{
      current = current -> next;
80105cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc * current;
  current = *sList;

  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
80105cc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cc6:	0f 85 5f ff ff ff    	jne    80105c2b <traverseToKill+0x23>
      return 1;
    }else{
      current = current -> next;
    }
  }
  release(&ptable.lock);
80105ccc:	83 ec 0c             	sub    $0xc,%esp
80105ccf:	68 80 49 11 80       	push   $0x80114980
80105cd4:	e8 0e 06 00 00       	call   801062e7 <release>
80105cd9:	83 c4 10             	add    $0x10,%esp
  return -1;
80105cdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ce1:	c9                   	leave  
80105ce2:	c3                   	ret    

80105ce3 <removeFront>:

static struct proc *
removeFront(struct proc** sList){
80105ce3:	55                   	push   %ebp
80105ce4:	89 e5                	mov    %esp,%ebp
80105ce6:	83 ec 10             	sub    $0x10,%esp
  struct proc * temp;
  temp = *sList;
80105ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80105cec:	8b 00                	mov    (%eax),%eax
80105cee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(temp == 0)
80105cf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105cf5:	75 05                	jne    80105cfc <removeFront+0x19>
    return temp;
80105cf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cfa:	eb 13                	jmp    80105d0f <removeFront+0x2c>

  *sList = (* sList) -> next;
80105cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80105cff:	8b 00                	mov    (%eax),%eax
80105d01:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105d07:	8b 45 08             	mov    0x8(%ebp),%eax
80105d0a:	89 10                	mov    %edx,(%eax)

  return temp;
80105d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105d0f:	c9                   	leave  
80105d10:	c3                   	ret    

80105d11 <promoteOneLevelUp>:

static int                                        //P4 helper function promote up
promoteOneLevelUp(struct proc** sList){
80105d11:	55                   	push   %ebp
80105d12:	89 e5                	mov    %esp,%ebp
80105d14:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
80105d17:	8b 45 08             	mov    0x8(%ebp),%eax
80105d1a:	8b 00                	mov    (%eax),%eax
80105d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(current == 0){
80105d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d23:	75 07                	jne    80105d2c <promoteOneLevelUp+0x1b>
    return 0;
80105d25:	b8 00 00 00 00       	mov    $0x0,%eax
80105d2a:	eb 73                	jmp    80105d9f <promoteOneLevelUp+0x8e>
  }
  if(current -> priority == 0){
80105d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d35:	85 c0                	test   %eax,%eax
80105d37:	75 58                	jne    80105d91 <promoteOneLevelUp+0x80>
    return 1;
80105d39:	b8 01 00 00 00       	mov    $0x1,%eax
80105d3e:	eb 5f                	jmp    80105d9f <promoteOneLevelUp+0x8e>
  }
  while(*sList){
    current = removeFront(sList);
80105d40:	ff 75 08             	pushl  0x8(%ebp)
80105d43:	e8 9b ff ff ff       	call   80105ce3 <removeFront>
80105d48:	83 c4 04             	add    $0x4,%esp
80105d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(current){
80105d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d52:	74 3d                	je     80105d91 <promoteOneLevelUp+0x80>
      current -> priority = current -> priority - 1;
80105d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d57:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d5d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d63:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      insertTail(&ptable.pLists.ready[current -> priority], current);
80105d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d72:	05 cc 09 00 00       	add    $0x9cc,%eax
80105d77:	c1 e0 02             	shl    $0x2,%eax
80105d7a:	05 80 49 11 80       	add    $0x80114980,%eax
80105d7f:	83 c0 04             	add    $0x4,%eax
80105d82:	83 ec 08             	sub    $0x8,%esp
80105d85:	ff 75 f4             	pushl  -0xc(%ebp)
80105d88:	50                   	push   %eax
80105d89:	e8 69 00 00 00       	call   80105df7 <insertTail>
80105d8e:	83 c4 10             	add    $0x10,%esp
    return 0;
  }
  if(current -> priority == 0){
    return 1;
  }
  while(*sList){
80105d91:	8b 45 08             	mov    0x8(%ebp),%eax
80105d94:	8b 00                	mov    (%eax),%eax
80105d96:	85 c0                	test   %eax,%eax
80105d98:	75 a6                	jne    80105d40 <promoteOneLevelUp+0x2f>
    if(current){
      current -> priority = current -> priority - 1;
      insertTail(&ptable.pLists.ready[current -> priority], current);
    }
  }
  return 1;
80105d9a:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d9f:	c9                   	leave  
80105da0:	c3                   	ret    

80105da1 <promoteOneLevelUpRunSleep>:

static int                                        //P4 helper function promote up
promoteOneLevelUpRunSleep(struct proc** sList){
80105da1:	55                   	push   %ebp
80105da2:	89 e5                	mov    %esp,%ebp
80105da4:	83 ec 10             	sub    $0x10,%esp
  struct proc * current;
  current = *sList;
80105da7:	8b 45 08             	mov    0x8(%ebp),%eax
80105daa:	8b 00                	mov    (%eax),%eax
80105dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(current == 0){
80105daf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105db3:	75 35                	jne    80105dea <promoteOneLevelUpRunSleep+0x49>
    return 0;
80105db5:	b8 00 00 00 00       	mov    $0x0,%eax
80105dba:	eb 39                	jmp    80105df5 <promoteOneLevelUpRunSleep+0x54>
  }
  while(current){
    if(current -> priority > 0){
80105dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105dbf:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	7e 15                	jle    80105dde <promoteOneLevelUpRunSleep+0x3d>
      current -> priority = current -> priority - 1;
80105dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105dcc:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105dd2:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105dd8:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    }
    current = current -> next;
80105dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105de1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105de7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc * current;
  current = *sList;
  if(current == 0){
    return 0;
  }
  while(current){
80105dea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105dee:	75 cc                	jne    80105dbc <promoteOneLevelUpRunSleep+0x1b>
    if(current -> priority > 0){
      current -> priority = current -> priority - 1;
    }
    current = current -> next;
  }
  return 1;
80105df0:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105df5:	c9                   	leave  
80105df6:	c3                   	ret    

80105df7 <insertTail>:

static void
insertTail(struct proc** sList, struct proc * p){
80105df7:	55                   	push   %ebp
80105df8:	89 e5                	mov    %esp,%ebp
80105dfa:	83 ec 10             	sub    $0x10,%esp
  if(*sList == 0){
80105dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105e00:	8b 00                	mov    (%eax),%eax
80105e02:	85 c0                	test   %eax,%eax
80105e04:	75 19                	jne    80105e1f <insertTail+0x28>
    *sList = p;
80105e06:	8b 45 08             	mov    0x8(%ebp),%eax
80105e09:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e0c:	89 10                	mov    %edx,(%eax)
    (*sList) -> next = 0;
80105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80105e11:	8b 00                	mov    (%eax),%eax
80105e13:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e1a:	00 00 00 
    return;
80105e1d:	eb 3d                	jmp    80105e5c <insertTail+0x65>
  }

  struct proc * current;
  current = *sList;
80105e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e22:	8b 00                	mov    (%eax),%eax
80105e24:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(current -> next != 0){
80105e27:	eb 0c                	jmp    80105e35 <insertTail+0x3e>
    current = current -> next;
80105e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e2c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
  }

  struct proc * current;
  current = *sList;

  while(current -> next != 0){
80105e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e38:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	75 e7                	jne    80105e29 <insertTail+0x32>
    current = current -> next;
  }
  current -> next = p;
80105e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e45:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e48:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  p -> next = 0;
80105e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e51:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e58:	00 00 00 
  return;
80105e5b:	90                   	nop
}
80105e5c:	c9                   	leave  
80105e5d:	c3                   	ret    

80105e5e <insertAtHead>:

static void
insertAtHead(struct proc** sList, struct proc * p){
80105e5e:	55                   	push   %ebp
80105e5f:	89 e5                	mov    %esp,%ebp
  p->next = *sList;
80105e61:	8b 45 08             	mov    0x8(%ebp),%eax
80105e64:	8b 10                	mov    (%eax),%edx
80105e66:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e69:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
80105e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e72:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e75:	89 10                	mov    %edx,(%eax)
}
80105e77:	90                   	nop
80105e78:	5d                   	pop    %ebp
80105e79:	c3                   	ret    

80105e7a <printPidReadyList>:

#endif

void
printPidReadyList(void){
80105e7a:	55                   	push   %ebp
80105e7b:	89 e5                	mov    %esp,%ebp
80105e7d:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	68 80 49 11 80       	push   $0x80114980
80105e88:	e8 f3 03 00 00       	call   80106280 <acquire>
80105e8d:	83 c4 10             	add    $0x10,%esp
   cprintf("Ready List processes: \n");
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 b4 9e 10 80       	push   $0x80109eb4
80105e98:	e8 29 a5 ff ff       	call   801003c6 <cprintf>
80105e9d:	83 c4 10             	add    $0x10,%esp
   for(int i = 0; i <= MAX; i++){
80105ea0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105ea7:	eb 6e                	jmp    80105f17 <printPidReadyList+0x9d>
    cprintf("%d: ", i);
80105ea9:	83 ec 08             	sub    $0x8,%esp
80105eac:	ff 75 f0             	pushl  -0x10(%ebp)
80105eaf:	68 cc 9e 10 80       	push   $0x80109ecc
80105eb4:	e8 0d a5 ff ff       	call   801003c6 <cprintf>
80105eb9:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.ready[i];
80105ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebf:	05 cc 09 00 00       	add    $0x9cc,%eax
80105ec4:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(current){
80105ece:	eb 2d                	jmp    80105efd <printPidReadyList+0x83>
      cprintf("(%d, %d) ->", current -> pid, current -> budget);
80105ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed3:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edc:	8b 40 10             	mov    0x10(%eax),%eax
80105edf:	83 ec 04             	sub    $0x4,%esp
80105ee2:	52                   	push   %edx
80105ee3:	50                   	push   %eax
80105ee4:	68 d1 9e 10 80       	push   $0x80109ed1
80105ee9:	e8 d8 a4 ff ff       	call   801003c6 <cprintf>
80105eee:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80105ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
   acquire(&ptable.lock);
   cprintf("Ready List processes: \n");
   for(int i = 0; i <= MAX; i++){
    cprintf("%d: ", i);
    current = ptable.pLists.ready[i];
    while(current){
80105efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f01:	75 cd                	jne    80105ed0 <printPidReadyList+0x56>
      cprintf("(%d, %d) ->", current -> pid, current -> budget);
      current = current -> next;
    }
    cprintf("\n");
80105f03:	83 ec 0c             	sub    $0xc,%esp
80105f06:	68 2a 9e 10 80       	push   $0x80109e2a
80105f0b:	e8 b6 a4 ff ff       	call   801003c6 <cprintf>
80105f10:	83 c4 10             	add    $0x10,%esp
void
printPidReadyList(void){
   struct proc * current;
   acquire(&ptable.lock);
   cprintf("Ready List processes: \n");
   for(int i = 0; i <= MAX; i++){
80105f13:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105f17:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
80105f1b:	7e 8c                	jle    80105ea9 <printPidReadyList+0x2f>
      current = current -> next;
    }
    cprintf("\n");
  }

    release(&ptable.lock);
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	68 80 49 11 80       	push   $0x80114980
80105f25:	e8 bd 03 00 00       	call   801062e7 <release>
80105f2a:	83 c4 10             	add    $0x10,%esp
}
80105f2d:	90                   	nop
80105f2e:	c9                   	leave  
80105f2f:	c3                   	ret    

80105f30 <countFreeList>:

void
countFreeList(void){
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105f36:	83 ec 0c             	sub    $0xc,%esp
80105f39:	68 80 49 11 80       	push   $0x80114980
80105f3e:	e8 3d 03 00 00       	call   80106280 <acquire>
80105f43:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.free;
80105f46:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80105f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int count = 0;
80105f4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(current){
80105f55:	eb 10                	jmp    80105f67 <countFreeList+0x37>
      count++;
80105f57:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      current = current -> next;
80105f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
countFreeList(void){
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.free;
    int count = 0;
    while(current){
80105f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f6b:	75 ea                	jne    80105f57 <countFreeList+0x27>
      count++;
      current = current -> next;
    }
    cprintf("Free List size: %d\n", count);
80105f6d:	83 ec 08             	sub    $0x8,%esp
80105f70:	ff 75 f0             	pushl  -0x10(%ebp)
80105f73:	68 dd 9e 10 80       	push   $0x80109edd
80105f78:	e8 49 a4 ff ff       	call   801003c6 <cprintf>
80105f7d:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	68 80 49 11 80       	push   $0x80114980
80105f88:	e8 5a 03 00 00       	call   801062e7 <release>
80105f8d:	83 c4 10             	add    $0x10,%esp
}
80105f90:	90                   	nop
80105f91:	c9                   	leave  
80105f92:	c3                   	ret    

80105f93 <printPidSleepList>:

void
printPidSleepList(void){
80105f93:	55                   	push   %ebp
80105f94:	89 e5                	mov    %esp,%ebp
80105f96:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80105f99:	83 ec 0c             	sub    $0xc,%esp
80105f9c:	68 80 49 11 80       	push   $0x80114980
80105fa1:	e8 da 02 00 00       	call   80106280 <acquire>
80105fa6:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.sleep;
80105fa9:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Sleep List processes: \n");
80105fb1:	83 ec 0c             	sub    $0xc,%esp
80105fb4:	68 f1 9e 10 80       	push   $0x80109ef1
80105fb9:	e8 08 a4 ff ff       	call   801003c6 <cprintf>
80105fbe:	83 c4 10             	add    $0x10,%esp
    while(current){
80105fc1:	eb 23                	jmp    80105fe6 <printPidSleepList+0x53>
      cprintf("%d ->", current -> pid);
80105fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc6:	8b 40 10             	mov    0x10(%eax),%eax
80105fc9:	83 ec 08             	sub    $0x8,%esp
80105fcc:	50                   	push   %eax
80105fcd:	68 09 9f 10 80       	push   $0x80109f09
80105fd2:	e8 ef a3 ff ff       	call   801003c6 <cprintf>
80105fd7:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80105fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fdd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.sleep;
    //int count = 0;
    cprintf("Sleep List processes: \n");
    while(current){
80105fe6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fea:	75 d7                	jne    80105fc3 <printPidSleepList+0x30>
      cprintf("%d ->", current -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
80105fec:	83 ec 0c             	sub    $0xc,%esp
80105fef:	68 80 49 11 80       	push   $0x80114980
80105ff4:	e8 ee 02 00 00       	call   801062e7 <release>
80105ff9:	83 c4 10             	add    $0x10,%esp
}
80105ffc:	90                   	nop
80105ffd:	c9                   	leave  
80105ffe:	c3                   	ret    

80105fff <printZombieList>:

void
printZombieList(void){
80105fff:	55                   	push   %ebp
80106000:	89 e5                	mov    %esp,%ebp
80106002:	83 ec 18             	sub    $0x18,%esp
   struct proc * current;
   acquire(&ptable.lock);
80106005:	83 ec 0c             	sub    $0xc,%esp
80106008:	68 80 49 11 80       	push   $0x80114980
8010600d:	e8 6e 02 00 00       	call   80106280 <acquire>
80106012:	83 c4 10             	add    $0x10,%esp
    current = ptable.pLists.zombie;
80106015:	a1 d8 70 11 80       	mov    0x801170d8,%eax
8010601a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //int count = 0;
    cprintf("Zombie List processes: \n");
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	68 0f 9f 10 80       	push   $0x80109f0f
80106025:	e8 9c a3 ff ff       	call   801003c6 <cprintf>
8010602a:	83 c4 10             	add    $0x10,%esp
    while(current){
8010602d:	eb 2d                	jmp    8010605c <printZombieList+0x5d>
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
8010602f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106032:	8b 40 14             	mov    0x14(%eax),%eax
80106035:	8b 50 10             	mov    0x10(%eax),%edx
80106038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603b:	8b 40 10             	mov    0x10(%eax),%eax
8010603e:	83 ec 04             	sub    $0x4,%esp
80106041:	52                   	push   %edx
80106042:	50                   	push   %eax
80106043:	68 28 9f 10 80       	push   $0x80109f28
80106048:	e8 79 a3 ff ff       	call   801003c6 <cprintf>
8010604d:	83 c4 10             	add    $0x10,%esp
      current = current -> next;
80106050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106053:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106059:	89 45 f4             	mov    %eax,-0xc(%ebp)
   struct proc * current;
   acquire(&ptable.lock);
    current = ptable.pLists.zombie;
    //int count = 0;
    cprintf("Zombie List processes: \n");
    while(current){
8010605c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106060:	75 cd                	jne    8010602f <printZombieList+0x30>
      cprintf("(%d,%d) ->", current -> pid, current -> parent -> pid);
      current = current -> next;
    }
    release(&ptable.lock);
80106062:	83 ec 0c             	sub    $0xc,%esp
80106065:	68 80 49 11 80       	push   $0x80114980
8010606a:	e8 78 02 00 00       	call   801062e7 <release>
8010606f:	83 c4 10             	add    $0x10,%esp
}
80106072:	90                   	nop
80106073:	c9                   	leave  
80106074:	c3                   	ret    

80106075 <setpriority>:

#ifdef CS333_P3P4

int
setpriority(int pid, int priority){
80106075:	55                   	push   %ebp
80106076:	89 e5                	mov    %esp,%ebp
80106078:	83 ec 18             	sub    $0x18,%esp
  if(priority < 0 || priority > MAX){
8010607b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010607f:	78 06                	js     80106087 <setpriority+0x12>
80106081:	83 7d 0c 06          	cmpl   $0x6,0xc(%ebp)
80106085:	7e 0a                	jle    80106091 <setpriority+0x1c>
    return -1;
80106087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608c:	e9 8d 00 00 00       	jmp    8010611e <setpriority+0xa9>
  }
  if(updatePriority(&ptable.pLists.sleep, pid, priority) == 1)
80106091:	83 ec 04             	sub    $0x4,%esp
80106094:	ff 75 0c             	pushl  0xc(%ebp)
80106097:	ff 75 08             	pushl  0x8(%ebp)
8010609a:	68 d4 70 11 80       	push   $0x801170d4
8010609f:	e8 7c 00 00 00       	call   80106120 <updatePriority>
801060a4:	83 c4 10             	add    $0x10,%esp
801060a7:	83 f8 01             	cmp    $0x1,%eax
801060aa:	75 07                	jne    801060b3 <setpriority+0x3e>
    return 0;
801060ac:	b8 00 00 00 00       	mov    $0x0,%eax
801060b1:	eb 6b                	jmp    8010611e <setpriority+0xa9>
  if(updatePriority(&ptable.pLists.running, pid, priority) == 1)
801060b3:	83 ec 04             	sub    $0x4,%esp
801060b6:	ff 75 0c             	pushl  0xc(%ebp)
801060b9:	ff 75 08             	pushl  0x8(%ebp)
801060bc:	68 dc 70 11 80       	push   $0x801170dc
801060c1:	e8 5a 00 00 00       	call   80106120 <updatePriority>
801060c6:	83 c4 10             	add    $0x10,%esp
801060c9:	83 f8 01             	cmp    $0x1,%eax
801060cc:	75 07                	jne    801060d5 <setpriority+0x60>
    return 0;
801060ce:	b8 00 00 00 00       	mov    $0x0,%eax
801060d3:	eb 49                	jmp    8010611e <setpriority+0xa9>
  for(int i = 0; i <=MAX; i++){
801060d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801060dc:	eb 35                	jmp    80106113 <setpriority+0x9e>
    if(updatePriority(&ptable.pLists.ready[i], pid, priority)== 1)
801060de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e1:	05 cc 09 00 00       	add    $0x9cc,%eax
801060e6:	c1 e0 02             	shl    $0x2,%eax
801060e9:	05 80 49 11 80       	add    $0x80114980,%eax
801060ee:	83 c0 04             	add    $0x4,%eax
801060f1:	83 ec 04             	sub    $0x4,%esp
801060f4:	ff 75 0c             	pushl  0xc(%ebp)
801060f7:	ff 75 08             	pushl  0x8(%ebp)
801060fa:	50                   	push   %eax
801060fb:	e8 20 00 00 00       	call   80106120 <updatePriority>
80106100:	83 c4 10             	add    $0x10,%esp
80106103:	83 f8 01             	cmp    $0x1,%eax
80106106:	75 07                	jne    8010610f <setpriority+0x9a>
      return 0;
80106108:	b8 00 00 00 00       	mov    $0x0,%eax
8010610d:	eb 0f                	jmp    8010611e <setpriority+0xa9>
  }
  if(updatePriority(&ptable.pLists.sleep, pid, priority) == 1)
    return 0;
  if(updatePriority(&ptable.pLists.running, pid, priority) == 1)
    return 0;
  for(int i = 0; i <=MAX; i++){
8010610f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106113:	83 7d f4 06          	cmpl   $0x6,-0xc(%ebp)
80106117:	7e c5                	jle    801060de <setpriority+0x69>
    if(updatePriority(&ptable.pLists.ready[i], pid, priority)== 1)
      return 0;
  }

  return -1;
80106119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010611e:	c9                   	leave  
8010611f:	c3                   	ret    

80106120 <updatePriority>:

static int
updatePriority(struct proc** sList, int pid, int priority){
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 18             	sub    $0x18,%esp
  struct proc * current;
  current = *sList;
80106126:	8b 45 08             	mov    0x8(%ebp),%eax
80106129:	8b 00                	mov    (%eax),%eax
8010612b:	89 45 f4             	mov    %eax,-0xc(%ebp)


  acquire(&ptable.lock);     // *****move the lock before the function call outside
8010612e:	83 ec 0c             	sub    $0xc,%esp
80106131:	68 80 49 11 80       	push   $0x80114980
80106136:	e8 45 01 00 00       	call   80106280 <acquire>
8010613b:	83 c4 10             	add    $0x10,%esp

  while(current){
8010613e:	e9 c2 00 00 00       	jmp    80106205 <updatePriority+0xe5>
    if(current -> pid == pid){
80106143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106146:	8b 50 10             	mov    0x10(%eax),%edx
80106149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010614c:	39 c2                	cmp    %eax,%edx
8010614e:	0f 85 a5 00 00 00    	jne    801061f9 <updatePriority+0xd9>
      if(current -> priority != priority && current -> state == RUNNABLE){
80106154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106157:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010615d:	3b 45 10             	cmp    0x10(%ebp),%eax
80106160:	74 67                	je     801061c9 <updatePriority+0xa9>
80106162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106165:	8b 40 0c             	mov    0xc(%eax),%eax
80106168:	83 f8 03             	cmp    $0x3,%eax
8010616b:	75 5c                	jne    801061c9 <updatePriority+0xa9>
        removeFromStateList(&ptable.pLists.ready[current -> priority], current);
8010616d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106170:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106176:	05 cc 09 00 00       	add    $0x9cc,%eax
8010617b:	c1 e0 02             	shl    $0x2,%eax
8010617e:	05 80 49 11 80       	add    $0x80114980,%eax
80106183:	83 c0 04             	add    $0x4,%eax
80106186:	83 ec 08             	sub    $0x8,%esp
80106189:	ff 75 f4             	pushl  -0xc(%ebp)
8010618c:	50                   	push   %eax
8010618d:	e8 80 f9 ff ff       	call   80105b12 <removeFromStateList>
80106192:	83 c4 10             	add    $0x10,%esp
        current -> priority = priority;
80106195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106198:	8b 55 10             	mov    0x10(%ebp),%edx
8010619b:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        insertTail(&ptable.pLists.ready[current -> priority], current);                           //P4 put it at the same priority level
801061a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801061aa:	05 cc 09 00 00       	add    $0x9cc,%eax
801061af:	c1 e0 02             	shl    $0x2,%eax
801061b2:	05 80 49 11 80       	add    $0x80114980,%eax
801061b7:	83 c0 04             	add    $0x4,%eax
801061ba:	83 ec 08             	sub    $0x8,%esp
801061bd:	ff 75 f4             	pushl  -0xc(%ebp)
801061c0:	50                   	push   %eax
801061c1:	e8 31 fc ff ff       	call   80105df7 <insertTail>
801061c6:	83 c4 10             	add    $0x10,%esp
      }
      current -> priority = priority;
801061c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061cc:	8b 55 10             	mov    0x10(%ebp),%edx
801061cf:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      current -> budget = BUDGET;
801061d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d8:	c7 80 98 00 00 00 88 	movl   $0x1388,0x98(%eax)
801061df:	13 00 00 
      release(&ptable.lock);
801061e2:	83 ec 0c             	sub    $0xc,%esp
801061e5:	68 80 49 11 80       	push   $0x80114980
801061ea:	e8 f8 00 00 00       	call   801062e7 <release>
801061ef:	83 c4 10             	add    $0x10,%esp
      return 1; 
801061f2:	b8 01 00 00 00       	mov    $0x1,%eax
801061f7:	eb 2b                	jmp    80106224 <updatePriority+0x104>
    }
    current = current -> next;
801061f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061fc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  current = *sList;


  acquire(&ptable.lock);     // *****move the lock before the function call outside

  while(current){
80106205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106209:	0f 85 34 ff ff ff    	jne    80106143 <updatePriority+0x23>
      release(&ptable.lock);
      return 1; 
    }
    current = current -> next;
  }
  release(&ptable.lock);
8010620f:	83 ec 0c             	sub    $0xc,%esp
80106212:	68 80 49 11 80       	push   $0x80114980
80106217:	e8 cb 00 00 00       	call   801062e7 <release>
8010621c:	83 c4 10             	add    $0x10,%esp
  return -1;  
8010621f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106224:	c9                   	leave  
80106225:	c3                   	ret    

80106226 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80106226:	55                   	push   %ebp
80106227:	89 e5                	mov    %esp,%ebp
80106229:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010622c:	9c                   	pushf  
8010622d:	58                   	pop    %eax
8010622e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80106231:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106234:	c9                   	leave  
80106235:	c3                   	ret    

80106236 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106236:	55                   	push   %ebp
80106237:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106239:	fa                   	cli    
}
8010623a:	90                   	nop
8010623b:	5d                   	pop    %ebp
8010623c:	c3                   	ret    

8010623d <sti>:

static inline void
sti(void)
{
8010623d:	55                   	push   %ebp
8010623e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106240:	fb                   	sti    
}
80106241:	90                   	nop
80106242:	5d                   	pop    %ebp
80106243:	c3                   	ret    

80106244 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106244:	55                   	push   %ebp
80106245:	89 e5                	mov    %esp,%ebp
80106247:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010624a:	8b 55 08             	mov    0x8(%ebp),%edx
8010624d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106250:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106253:	f0 87 02             	lock xchg %eax,(%edx)
80106256:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106259:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010625c:	c9                   	leave  
8010625d:	c3                   	ret    

8010625e <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010625e:	55                   	push   %ebp
8010625f:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106261:	8b 45 08             	mov    0x8(%ebp),%eax
80106264:	8b 55 0c             	mov    0xc(%ebp),%edx
80106267:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010626a:	8b 45 08             	mov    0x8(%ebp),%eax
8010626d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106273:	8b 45 08             	mov    0x8(%ebp),%eax
80106276:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010627d:	90                   	nop
8010627e:	5d                   	pop    %ebp
8010627f:	c3                   	ret    

80106280 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106286:	e8 52 01 00 00       	call   801063dd <pushcli>
  if(holding(lk))
8010628b:	8b 45 08             	mov    0x8(%ebp),%eax
8010628e:	83 ec 0c             	sub    $0xc,%esp
80106291:	50                   	push   %eax
80106292:	e8 1c 01 00 00       	call   801063b3 <holding>
80106297:	83 c4 10             	add    $0x10,%esp
8010629a:	85 c0                	test   %eax,%eax
8010629c:	74 0d                	je     801062ab <acquire+0x2b>
    panic("acquire");
8010629e:	83 ec 0c             	sub    $0xc,%esp
801062a1:	68 33 9f 10 80       	push   $0x80109f33
801062a6:	e8 bb a2 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801062ab:	90                   	nop
801062ac:	8b 45 08             	mov    0x8(%ebp),%eax
801062af:	83 ec 08             	sub    $0x8,%esp
801062b2:	6a 01                	push   $0x1
801062b4:	50                   	push   %eax
801062b5:	e8 8a ff ff ff       	call   80106244 <xchg>
801062ba:	83 c4 10             	add    $0x10,%esp
801062bd:	85 c0                	test   %eax,%eax
801062bf:	75 eb                	jne    801062ac <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801062c1:	8b 45 08             	mov    0x8(%ebp),%eax
801062c4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801062cb:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801062ce:	8b 45 08             	mov    0x8(%ebp),%eax
801062d1:	83 c0 0c             	add    $0xc,%eax
801062d4:	83 ec 08             	sub    $0x8,%esp
801062d7:	50                   	push   %eax
801062d8:	8d 45 08             	lea    0x8(%ebp),%eax
801062db:	50                   	push   %eax
801062dc:	e8 58 00 00 00       	call   80106339 <getcallerpcs>
801062e1:	83 c4 10             	add    $0x10,%esp
}
801062e4:	90                   	nop
801062e5:	c9                   	leave  
801062e6:	c3                   	ret    

801062e7 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801062e7:	55                   	push   %ebp
801062e8:	89 e5                	mov    %esp,%ebp
801062ea:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801062ed:	83 ec 0c             	sub    $0xc,%esp
801062f0:	ff 75 08             	pushl  0x8(%ebp)
801062f3:	e8 bb 00 00 00       	call   801063b3 <holding>
801062f8:	83 c4 10             	add    $0x10,%esp
801062fb:	85 c0                	test   %eax,%eax
801062fd:	75 0d                	jne    8010630c <release+0x25>
    panic("release");
801062ff:	83 ec 0c             	sub    $0xc,%esp
80106302:	68 3b 9f 10 80       	push   $0x80109f3b
80106307:	e8 5a a2 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
8010630c:	8b 45 08             	mov    0x8(%ebp),%eax
8010630f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106316:	8b 45 08             	mov    0x8(%ebp),%eax
80106319:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106320:	8b 45 08             	mov    0x8(%ebp),%eax
80106323:	83 ec 08             	sub    $0x8,%esp
80106326:	6a 00                	push   $0x0
80106328:	50                   	push   %eax
80106329:	e8 16 ff ff ff       	call   80106244 <xchg>
8010632e:	83 c4 10             	add    $0x10,%esp

  popcli();
80106331:	e8 ec 00 00 00       	call   80106422 <popcli>
}
80106336:	90                   	nop
80106337:	c9                   	leave  
80106338:	c3                   	ret    

80106339 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106339:	55                   	push   %ebp
8010633a:	89 e5                	mov    %esp,%ebp
8010633c:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010633f:	8b 45 08             	mov    0x8(%ebp),%eax
80106342:	83 e8 08             	sub    $0x8,%eax
80106345:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106348:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010634f:	eb 38                	jmp    80106389 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106355:	74 53                	je     801063aa <getcallerpcs+0x71>
80106357:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010635e:	76 4a                	jbe    801063aa <getcallerpcs+0x71>
80106360:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106364:	74 44                	je     801063aa <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106366:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106369:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106370:	8b 45 0c             	mov    0xc(%ebp),%eax
80106373:	01 c2                	add    %eax,%edx
80106375:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106378:	8b 40 04             	mov    0x4(%eax),%eax
8010637b:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010637d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106380:	8b 00                	mov    (%eax),%eax
80106382:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106385:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106389:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010638d:	7e c2                	jle    80106351 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010638f:	eb 19                	jmp    801063aa <getcallerpcs+0x71>
    pcs[i] = 0;
80106391:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106394:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010639b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010639e:	01 d0                	add    %edx,%eax
801063a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801063a6:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801063aa:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801063ae:	7e e1                	jle    80106391 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801063b0:	90                   	nop
801063b1:	c9                   	leave  
801063b2:	c3                   	ret    

801063b3 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801063b3:	55                   	push   %ebp
801063b4:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801063b6:	8b 45 08             	mov    0x8(%ebp),%eax
801063b9:	8b 00                	mov    (%eax),%eax
801063bb:	85 c0                	test   %eax,%eax
801063bd:	74 17                	je     801063d6 <holding+0x23>
801063bf:	8b 45 08             	mov    0x8(%ebp),%eax
801063c2:	8b 50 08             	mov    0x8(%eax),%edx
801063c5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063cb:	39 c2                	cmp    %eax,%edx
801063cd:	75 07                	jne    801063d6 <holding+0x23>
801063cf:	b8 01 00 00 00       	mov    $0x1,%eax
801063d4:	eb 05                	jmp    801063db <holding+0x28>
801063d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063db:	5d                   	pop    %ebp
801063dc:	c3                   	ret    

801063dd <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801063dd:	55                   	push   %ebp
801063de:	89 e5                	mov    %esp,%ebp
801063e0:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801063e3:	e8 3e fe ff ff       	call   80106226 <readeflags>
801063e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801063eb:	e8 46 fe ff ff       	call   80106236 <cli>
  if(cpu->ncli++ == 0)
801063f0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801063f7:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801063fd:	8d 48 01             	lea    0x1(%eax),%ecx
80106400:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106406:	85 c0                	test   %eax,%eax
80106408:	75 15                	jne    8010641f <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010640a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106410:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106413:	81 e2 00 02 00 00    	and    $0x200,%edx
80106419:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010641f:	90                   	nop
80106420:	c9                   	leave  
80106421:	c3                   	ret    

80106422 <popcli>:

void
popcli(void)
{
80106422:	55                   	push   %ebp
80106423:	89 e5                	mov    %esp,%ebp
80106425:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106428:	e8 f9 fd ff ff       	call   80106226 <readeflags>
8010642d:	25 00 02 00 00       	and    $0x200,%eax
80106432:	85 c0                	test   %eax,%eax
80106434:	74 0d                	je     80106443 <popcli+0x21>
    panic("popcli - interruptible");
80106436:	83 ec 0c             	sub    $0xc,%esp
80106439:	68 43 9f 10 80       	push   $0x80109f43
8010643e:	e8 23 a1 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106443:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106449:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010644f:	83 ea 01             	sub    $0x1,%edx
80106452:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106458:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010645e:	85 c0                	test   %eax,%eax
80106460:	79 0d                	jns    8010646f <popcli+0x4d>
    panic("popcli");
80106462:	83 ec 0c             	sub    $0xc,%esp
80106465:	68 5a 9f 10 80       	push   $0x80109f5a
8010646a:	e8 f7 a0 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010646f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106475:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010647b:	85 c0                	test   %eax,%eax
8010647d:	75 15                	jne    80106494 <popcli+0x72>
8010647f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106485:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010648b:	85 c0                	test   %eax,%eax
8010648d:	74 05                	je     80106494 <popcli+0x72>
    sti();
8010648f:	e8 a9 fd ff ff       	call   8010623d <sti>
}
80106494:	90                   	nop
80106495:	c9                   	leave  
80106496:	c3                   	ret    

80106497 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106497:	55                   	push   %ebp
80106498:	89 e5                	mov    %esp,%ebp
8010649a:	57                   	push   %edi
8010649b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010649c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010649f:	8b 55 10             	mov    0x10(%ebp),%edx
801064a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801064a5:	89 cb                	mov    %ecx,%ebx
801064a7:	89 df                	mov    %ebx,%edi
801064a9:	89 d1                	mov    %edx,%ecx
801064ab:	fc                   	cld    
801064ac:	f3 aa                	rep stos %al,%es:(%edi)
801064ae:	89 ca                	mov    %ecx,%edx
801064b0:	89 fb                	mov    %edi,%ebx
801064b2:	89 5d 08             	mov    %ebx,0x8(%ebp)
801064b5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801064b8:	90                   	nop
801064b9:	5b                   	pop    %ebx
801064ba:	5f                   	pop    %edi
801064bb:	5d                   	pop    %ebp
801064bc:	c3                   	ret    

801064bd <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801064bd:	55                   	push   %ebp
801064be:	89 e5                	mov    %esp,%ebp
801064c0:	57                   	push   %edi
801064c1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801064c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801064c5:	8b 55 10             	mov    0x10(%ebp),%edx
801064c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801064cb:	89 cb                	mov    %ecx,%ebx
801064cd:	89 df                	mov    %ebx,%edi
801064cf:	89 d1                	mov    %edx,%ecx
801064d1:	fc                   	cld    
801064d2:	f3 ab                	rep stos %eax,%es:(%edi)
801064d4:	89 ca                	mov    %ecx,%edx
801064d6:	89 fb                	mov    %edi,%ebx
801064d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801064db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801064de:	90                   	nop
801064df:	5b                   	pop    %ebx
801064e0:	5f                   	pop    %edi
801064e1:	5d                   	pop    %ebp
801064e2:	c3                   	ret    

801064e3 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801064e3:	55                   	push   %ebp
801064e4:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801064e6:	8b 45 08             	mov    0x8(%ebp),%eax
801064e9:	83 e0 03             	and    $0x3,%eax
801064ec:	85 c0                	test   %eax,%eax
801064ee:	75 43                	jne    80106533 <memset+0x50>
801064f0:	8b 45 10             	mov    0x10(%ebp),%eax
801064f3:	83 e0 03             	and    $0x3,%eax
801064f6:	85 c0                	test   %eax,%eax
801064f8:	75 39                	jne    80106533 <memset+0x50>
    c &= 0xFF;
801064fa:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106501:	8b 45 10             	mov    0x10(%ebp),%eax
80106504:	c1 e8 02             	shr    $0x2,%eax
80106507:	89 c1                	mov    %eax,%ecx
80106509:	8b 45 0c             	mov    0xc(%ebp),%eax
8010650c:	c1 e0 18             	shl    $0x18,%eax
8010650f:	89 c2                	mov    %eax,%edx
80106511:	8b 45 0c             	mov    0xc(%ebp),%eax
80106514:	c1 e0 10             	shl    $0x10,%eax
80106517:	09 c2                	or     %eax,%edx
80106519:	8b 45 0c             	mov    0xc(%ebp),%eax
8010651c:	c1 e0 08             	shl    $0x8,%eax
8010651f:	09 d0                	or     %edx,%eax
80106521:	0b 45 0c             	or     0xc(%ebp),%eax
80106524:	51                   	push   %ecx
80106525:	50                   	push   %eax
80106526:	ff 75 08             	pushl  0x8(%ebp)
80106529:	e8 8f ff ff ff       	call   801064bd <stosl>
8010652e:	83 c4 0c             	add    $0xc,%esp
80106531:	eb 12                	jmp    80106545 <memset+0x62>
  } else
    stosb(dst, c, n);
80106533:	8b 45 10             	mov    0x10(%ebp),%eax
80106536:	50                   	push   %eax
80106537:	ff 75 0c             	pushl  0xc(%ebp)
8010653a:	ff 75 08             	pushl  0x8(%ebp)
8010653d:	e8 55 ff ff ff       	call   80106497 <stosb>
80106542:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106545:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106548:	c9                   	leave  
80106549:	c3                   	ret    

8010654a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010654a:	55                   	push   %ebp
8010654b:	89 e5                	mov    %esp,%ebp
8010654d:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106550:	8b 45 08             	mov    0x8(%ebp),%eax
80106553:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106556:	8b 45 0c             	mov    0xc(%ebp),%eax
80106559:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010655c:	eb 30                	jmp    8010658e <memcmp+0x44>
    if(*s1 != *s2)
8010655e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106561:	0f b6 10             	movzbl (%eax),%edx
80106564:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106567:	0f b6 00             	movzbl (%eax),%eax
8010656a:	38 c2                	cmp    %al,%dl
8010656c:	74 18                	je     80106586 <memcmp+0x3c>
      return *s1 - *s2;
8010656e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106571:	0f b6 00             	movzbl (%eax),%eax
80106574:	0f b6 d0             	movzbl %al,%edx
80106577:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010657a:	0f b6 00             	movzbl (%eax),%eax
8010657d:	0f b6 c0             	movzbl %al,%eax
80106580:	29 c2                	sub    %eax,%edx
80106582:	89 d0                	mov    %edx,%eax
80106584:	eb 1a                	jmp    801065a0 <memcmp+0x56>
    s1++, s2++;
80106586:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010658a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010658e:	8b 45 10             	mov    0x10(%ebp),%eax
80106591:	8d 50 ff             	lea    -0x1(%eax),%edx
80106594:	89 55 10             	mov    %edx,0x10(%ebp)
80106597:	85 c0                	test   %eax,%eax
80106599:	75 c3                	jne    8010655e <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010659b:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065a0:	c9                   	leave  
801065a1:	c3                   	ret    

801065a2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801065a2:	55                   	push   %ebp
801065a3:	89 e5                	mov    %esp,%ebp
801065a5:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801065a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801065ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801065ae:	8b 45 08             	mov    0x8(%ebp),%eax
801065b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801065b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801065ba:	73 54                	jae    80106610 <memmove+0x6e>
801065bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065bf:	8b 45 10             	mov    0x10(%ebp),%eax
801065c2:	01 d0                	add    %edx,%eax
801065c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801065c7:	76 47                	jbe    80106610 <memmove+0x6e>
    s += n;
801065c9:	8b 45 10             	mov    0x10(%ebp),%eax
801065cc:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801065cf:	8b 45 10             	mov    0x10(%ebp),%eax
801065d2:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801065d5:	eb 13                	jmp    801065ea <memmove+0x48>
      *--d = *--s;
801065d7:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801065db:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801065df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065e2:	0f b6 10             	movzbl (%eax),%edx
801065e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065e8:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801065ea:	8b 45 10             	mov    0x10(%ebp),%eax
801065ed:	8d 50 ff             	lea    -0x1(%eax),%edx
801065f0:	89 55 10             	mov    %edx,0x10(%ebp)
801065f3:	85 c0                	test   %eax,%eax
801065f5:	75 e0                	jne    801065d7 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801065f7:	eb 24                	jmp    8010661d <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801065f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065fc:	8d 50 01             	lea    0x1(%eax),%edx
801065ff:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106602:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106605:	8d 4a 01             	lea    0x1(%edx),%ecx
80106608:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010660b:	0f b6 12             	movzbl (%edx),%edx
8010660e:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106610:	8b 45 10             	mov    0x10(%ebp),%eax
80106613:	8d 50 ff             	lea    -0x1(%eax),%edx
80106616:	89 55 10             	mov    %edx,0x10(%ebp)
80106619:	85 c0                	test   %eax,%eax
8010661b:	75 dc                	jne    801065f9 <memmove+0x57>
      *d++ = *s++;

  return dst;
8010661d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106620:	c9                   	leave  
80106621:	c3                   	ret    

80106622 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106622:	55                   	push   %ebp
80106623:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106625:	ff 75 10             	pushl  0x10(%ebp)
80106628:	ff 75 0c             	pushl  0xc(%ebp)
8010662b:	ff 75 08             	pushl  0x8(%ebp)
8010662e:	e8 6f ff ff ff       	call   801065a2 <memmove>
80106633:	83 c4 0c             	add    $0xc,%esp
}
80106636:	c9                   	leave  
80106637:	c3                   	ret    

80106638 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106638:	55                   	push   %ebp
80106639:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010663b:	eb 0c                	jmp    80106649 <strncmp+0x11>
    n--, p++, q++;
8010663d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106641:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106645:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106649:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010664d:	74 1a                	je     80106669 <strncmp+0x31>
8010664f:	8b 45 08             	mov    0x8(%ebp),%eax
80106652:	0f b6 00             	movzbl (%eax),%eax
80106655:	84 c0                	test   %al,%al
80106657:	74 10                	je     80106669 <strncmp+0x31>
80106659:	8b 45 08             	mov    0x8(%ebp),%eax
8010665c:	0f b6 10             	movzbl (%eax),%edx
8010665f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106662:	0f b6 00             	movzbl (%eax),%eax
80106665:	38 c2                	cmp    %al,%dl
80106667:	74 d4                	je     8010663d <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106669:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010666d:	75 07                	jne    80106676 <strncmp+0x3e>
    return 0;
8010666f:	b8 00 00 00 00       	mov    $0x0,%eax
80106674:	eb 16                	jmp    8010668c <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106676:	8b 45 08             	mov    0x8(%ebp),%eax
80106679:	0f b6 00             	movzbl (%eax),%eax
8010667c:	0f b6 d0             	movzbl %al,%edx
8010667f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106682:	0f b6 00             	movzbl (%eax),%eax
80106685:	0f b6 c0             	movzbl %al,%eax
80106688:	29 c2                	sub    %eax,%edx
8010668a:	89 d0                	mov    %edx,%eax
}
8010668c:	5d                   	pop    %ebp
8010668d:	c3                   	ret    

8010668e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010668e:	55                   	push   %ebp
8010668f:	89 e5                	mov    %esp,%ebp
80106691:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106694:	8b 45 08             	mov    0x8(%ebp),%eax
80106697:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010669a:	90                   	nop
8010669b:	8b 45 10             	mov    0x10(%ebp),%eax
8010669e:	8d 50 ff             	lea    -0x1(%eax),%edx
801066a1:	89 55 10             	mov    %edx,0x10(%ebp)
801066a4:	85 c0                	test   %eax,%eax
801066a6:	7e 2c                	jle    801066d4 <strncpy+0x46>
801066a8:	8b 45 08             	mov    0x8(%ebp),%eax
801066ab:	8d 50 01             	lea    0x1(%eax),%edx
801066ae:	89 55 08             	mov    %edx,0x8(%ebp)
801066b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801066b4:	8d 4a 01             	lea    0x1(%edx),%ecx
801066b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801066ba:	0f b6 12             	movzbl (%edx),%edx
801066bd:	88 10                	mov    %dl,(%eax)
801066bf:	0f b6 00             	movzbl (%eax),%eax
801066c2:	84 c0                	test   %al,%al
801066c4:	75 d5                	jne    8010669b <strncpy+0xd>
    ;
  while(n-- > 0)
801066c6:	eb 0c                	jmp    801066d4 <strncpy+0x46>
    *s++ = 0;
801066c8:	8b 45 08             	mov    0x8(%ebp),%eax
801066cb:	8d 50 01             	lea    0x1(%eax),%edx
801066ce:	89 55 08             	mov    %edx,0x8(%ebp)
801066d1:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801066d4:	8b 45 10             	mov    0x10(%ebp),%eax
801066d7:	8d 50 ff             	lea    -0x1(%eax),%edx
801066da:	89 55 10             	mov    %edx,0x10(%ebp)
801066dd:	85 c0                	test   %eax,%eax
801066df:	7f e7                	jg     801066c8 <strncpy+0x3a>
    *s++ = 0;
  return os;
801066e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066e4:	c9                   	leave  
801066e5:	c3                   	ret    

801066e6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801066e6:	55                   	push   %ebp
801066e7:	89 e5                	mov    %esp,%ebp
801066e9:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801066ec:	8b 45 08             	mov    0x8(%ebp),%eax
801066ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801066f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066f6:	7f 05                	jg     801066fd <safestrcpy+0x17>
    return os;
801066f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066fb:	eb 31                	jmp    8010672e <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801066fd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106701:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106705:	7e 1e                	jle    80106725 <safestrcpy+0x3f>
80106707:	8b 45 08             	mov    0x8(%ebp),%eax
8010670a:	8d 50 01             	lea    0x1(%eax),%edx
8010670d:	89 55 08             	mov    %edx,0x8(%ebp)
80106710:	8b 55 0c             	mov    0xc(%ebp),%edx
80106713:	8d 4a 01             	lea    0x1(%edx),%ecx
80106716:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106719:	0f b6 12             	movzbl (%edx),%edx
8010671c:	88 10                	mov    %dl,(%eax)
8010671e:	0f b6 00             	movzbl (%eax),%eax
80106721:	84 c0                	test   %al,%al
80106723:	75 d8                	jne    801066fd <safestrcpy+0x17>
    ;
  *s = 0;
80106725:	8b 45 08             	mov    0x8(%ebp),%eax
80106728:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010672b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010672e:	c9                   	leave  
8010672f:	c3                   	ret    

80106730 <strlen>:

int
strlen(const char *s)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106736:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010673d:	eb 04                	jmp    80106743 <strlen+0x13>
8010673f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106743:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106746:	8b 45 08             	mov    0x8(%ebp),%eax
80106749:	01 d0                	add    %edx,%eax
8010674b:	0f b6 00             	movzbl (%eax),%eax
8010674e:	84 c0                	test   %al,%al
80106750:	75 ed                	jne    8010673f <strlen+0xf>
    ;
  return n;
80106752:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106755:	c9                   	leave  
80106756:	c3                   	ret    

80106757 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106757:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010675b:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010675f:	55                   	push   %ebp
  pushl %ebx
80106760:	53                   	push   %ebx
  pushl %esi
80106761:	56                   	push   %esi
  pushl %edi
80106762:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106763:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106765:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106767:	5f                   	pop    %edi
  popl %esi
80106768:	5e                   	pop    %esi
  popl %ebx
80106769:	5b                   	pop    %ebx
  popl %ebp
8010676a:	5d                   	pop    %ebp
  ret
8010676b:	c3                   	ret    

8010676c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010676c:	55                   	push   %ebp
8010676d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010676f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106775:	8b 00                	mov    (%eax),%eax
80106777:	3b 45 08             	cmp    0x8(%ebp),%eax
8010677a:	76 12                	jbe    8010678e <fetchint+0x22>
8010677c:	8b 45 08             	mov    0x8(%ebp),%eax
8010677f:	8d 50 04             	lea    0x4(%eax),%edx
80106782:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106788:	8b 00                	mov    (%eax),%eax
8010678a:	39 c2                	cmp    %eax,%edx
8010678c:	76 07                	jbe    80106795 <fetchint+0x29>
    return -1;
8010678e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106793:	eb 0f                	jmp    801067a4 <fetchint+0x38>
  *ip = *(int*)(addr);
80106795:	8b 45 08             	mov    0x8(%ebp),%eax
80106798:	8b 10                	mov    (%eax),%edx
8010679a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010679d:	89 10                	mov    %edx,(%eax)
  return 0;
8010679f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067a4:	5d                   	pop    %ebp
801067a5:	c3                   	ret    

801067a6 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801067a6:	55                   	push   %ebp
801067a7:	89 e5                	mov    %esp,%ebp
801067a9:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801067ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b2:	8b 00                	mov    (%eax),%eax
801067b4:	3b 45 08             	cmp    0x8(%ebp),%eax
801067b7:	77 07                	ja     801067c0 <fetchstr+0x1a>
    return -1;
801067b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067be:	eb 46                	jmp    80106806 <fetchstr+0x60>
  *pp = (char*)addr;
801067c0:	8b 55 08             	mov    0x8(%ebp),%edx
801067c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801067c6:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801067c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067ce:	8b 00                	mov    (%eax),%eax
801067d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801067d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d6:	8b 00                	mov    (%eax),%eax
801067d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801067db:	eb 1c                	jmp    801067f9 <fetchstr+0x53>
    if(*s == 0)
801067dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801067e0:	0f b6 00             	movzbl (%eax),%eax
801067e3:	84 c0                	test   %al,%al
801067e5:	75 0e                	jne    801067f5 <fetchstr+0x4f>
      return s - *pp;
801067e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801067ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801067ed:	8b 00                	mov    (%eax),%eax
801067ef:	29 c2                	sub    %eax,%edx
801067f1:	89 d0                	mov    %edx,%eax
801067f3:	eb 11                	jmp    80106806 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801067f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801067fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801067ff:	72 dc                	jb     801067dd <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106801:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106806:	c9                   	leave  
80106807:	c3                   	ret    

80106808 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106808:	55                   	push   %ebp
80106809:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010680b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106811:	8b 40 18             	mov    0x18(%eax),%eax
80106814:	8b 40 44             	mov    0x44(%eax),%eax
80106817:	8b 55 08             	mov    0x8(%ebp),%edx
8010681a:	c1 e2 02             	shl    $0x2,%edx
8010681d:	01 d0                	add    %edx,%eax
8010681f:	83 c0 04             	add    $0x4,%eax
80106822:	ff 75 0c             	pushl  0xc(%ebp)
80106825:	50                   	push   %eax
80106826:	e8 41 ff ff ff       	call   8010676c <fetchint>
8010682b:	83 c4 08             	add    $0x8,%esp
}
8010682e:	c9                   	leave  
8010682f:	c3                   	ret    

80106830 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106836:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106839:	50                   	push   %eax
8010683a:	ff 75 08             	pushl  0x8(%ebp)
8010683d:	e8 c6 ff ff ff       	call   80106808 <argint>
80106842:	83 c4 08             	add    $0x8,%esp
80106845:	85 c0                	test   %eax,%eax
80106847:	79 07                	jns    80106850 <argptr+0x20>
    return -1;
80106849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010684e:	eb 3b                	jmp    8010688b <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106850:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106856:	8b 00                	mov    (%eax),%eax
80106858:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010685b:	39 d0                	cmp    %edx,%eax
8010685d:	76 16                	jbe    80106875 <argptr+0x45>
8010685f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106862:	89 c2                	mov    %eax,%edx
80106864:	8b 45 10             	mov    0x10(%ebp),%eax
80106867:	01 c2                	add    %eax,%edx
80106869:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010686f:	8b 00                	mov    (%eax),%eax
80106871:	39 c2                	cmp    %eax,%edx
80106873:	76 07                	jbe    8010687c <argptr+0x4c>
    return -1;
80106875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010687a:	eb 0f                	jmp    8010688b <argptr+0x5b>
  *pp = (char*)i;
8010687c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010687f:	89 c2                	mov    %eax,%edx
80106881:	8b 45 0c             	mov    0xc(%ebp),%eax
80106884:	89 10                	mov    %edx,(%eax)
  return 0;
80106886:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010688b:	c9                   	leave  
8010688c:	c3                   	ret    

8010688d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010688d:	55                   	push   %ebp
8010688e:	89 e5                	mov    %esp,%ebp
80106890:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106893:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106896:	50                   	push   %eax
80106897:	ff 75 08             	pushl  0x8(%ebp)
8010689a:	e8 69 ff ff ff       	call   80106808 <argint>
8010689f:	83 c4 08             	add    $0x8,%esp
801068a2:	85 c0                	test   %eax,%eax
801068a4:	79 07                	jns    801068ad <argstr+0x20>
    return -1;
801068a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ab:	eb 0f                	jmp    801068bc <argstr+0x2f>
  return fetchstr(addr, pp);
801068ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068b0:	ff 75 0c             	pushl  0xc(%ebp)
801068b3:	50                   	push   %eax
801068b4:	e8 ed fe ff ff       	call   801067a6 <fetchstr>
801068b9:	83 c4 08             	add    $0x8,%esp
}
801068bc:	c9                   	leave  
801068bd:	c3                   	ret    

801068be <syscall>:
"setpriority",
};
#endif 
void
syscall(void)
{
801068be:	55                   	push   %ebp
801068bf:	89 e5                	mov    %esp,%ebp
801068c1:	53                   	push   %ebx
801068c2:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801068c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068cb:	8b 40 18             	mov    0x18(%eax),%eax
801068ce:	8b 40 1c             	mov    0x1c(%eax),%eax
801068d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801068d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068d8:	7e 30                	jle    8010690a <syscall+0x4c>
801068da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068dd:	83 f8 1e             	cmp    $0x1e,%eax
801068e0:	77 28                	ja     8010690a <syscall+0x4c>
801068e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e5:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801068ec:	85 c0                	test   %eax,%eax
801068ee:	74 1a                	je     8010690a <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801068f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f6:	8b 58 18             	mov    0x18(%eax),%ebx
801068f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068fc:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106903:	ff d0                	call   *%eax
80106905:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106908:	eb 34                	jmp    8010693e <syscall+0x80>
    #ifdef PRINT_SYSCALLS
      cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif 
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010690a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106910:	8d 50 6c             	lea    0x6c(%eax),%edx
80106913:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    proc->tf->eax = syscalls[num]();
    #ifdef PRINT_SYSCALLS
      cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif 
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106919:	8b 40 10             	mov    0x10(%eax),%eax
8010691c:	ff 75 f4             	pushl  -0xc(%ebp)
8010691f:	52                   	push   %edx
80106920:	50                   	push   %eax
80106921:	68 61 9f 10 80       	push   $0x80109f61
80106926:	e8 9b 9a ff ff       	call   801003c6 <cprintf>
8010692b:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010692e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106934:	8b 40 18             	mov    0x18(%eax),%eax
80106937:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010693e:	90                   	nop
8010693f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106942:	c9                   	leave  
80106943:	c3                   	ret    

80106944 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106944:	55                   	push   %ebp
80106945:	89 e5                	mov    %esp,%ebp
80106947:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010694a:	83 ec 08             	sub    $0x8,%esp
8010694d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106950:	50                   	push   %eax
80106951:	ff 75 08             	pushl  0x8(%ebp)
80106954:	e8 af fe ff ff       	call   80106808 <argint>
80106959:	83 c4 10             	add    $0x10,%esp
8010695c:	85 c0                	test   %eax,%eax
8010695e:	79 07                	jns    80106967 <argfd+0x23>
    return -1;
80106960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106965:	eb 50                	jmp    801069b7 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106967:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010696a:	85 c0                	test   %eax,%eax
8010696c:	78 21                	js     8010698f <argfd+0x4b>
8010696e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106971:	83 f8 0f             	cmp    $0xf,%eax
80106974:	7f 19                	jg     8010698f <argfd+0x4b>
80106976:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010697f:	83 c2 08             	add    $0x8,%edx
80106982:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106986:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010698d:	75 07                	jne    80106996 <argfd+0x52>
    return -1;
8010698f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106994:	eb 21                	jmp    801069b7 <argfd+0x73>
  if(pfd)
80106996:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010699a:	74 08                	je     801069a4 <argfd+0x60>
    *pfd = fd;
8010699c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010699f:	8b 45 0c             	mov    0xc(%ebp),%eax
801069a2:	89 10                	mov    %edx,(%eax)
  if(pf)
801069a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801069a8:	74 08                	je     801069b2 <argfd+0x6e>
    *pf = f;
801069aa:	8b 45 10             	mov    0x10(%ebp),%eax
801069ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069b0:	89 10                	mov    %edx,(%eax)
  return 0;
801069b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069b7:	c9                   	leave  
801069b8:	c3                   	ret    

801069b9 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801069b9:	55                   	push   %ebp
801069ba:	89 e5                	mov    %esp,%ebp
801069bc:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801069bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801069c6:	eb 30                	jmp    801069f8 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801069c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069d1:	83 c2 08             	add    $0x8,%edx
801069d4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801069d8:	85 c0                	test   %eax,%eax
801069da:	75 18                	jne    801069f4 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801069dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069e5:	8d 4a 08             	lea    0x8(%edx),%ecx
801069e8:	8b 55 08             	mov    0x8(%ebp),%edx
801069eb:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801069ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069f2:	eb 0f                	jmp    80106a03 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801069f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801069f8:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801069fc:	7e ca                	jle    801069c8 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801069fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a03:	c9                   	leave  
80106a04:	c3                   	ret    

80106a05 <sys_dup>:

int
sys_dup(void)
{
80106a05:	55                   	push   %ebp
80106a06:	89 e5                	mov    %esp,%ebp
80106a08:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106a0b:	83 ec 04             	sub    $0x4,%esp
80106a0e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a11:	50                   	push   %eax
80106a12:	6a 00                	push   $0x0
80106a14:	6a 00                	push   $0x0
80106a16:	e8 29 ff ff ff       	call   80106944 <argfd>
80106a1b:	83 c4 10             	add    $0x10,%esp
80106a1e:	85 c0                	test   %eax,%eax
80106a20:	79 07                	jns    80106a29 <sys_dup+0x24>
    return -1;
80106a22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a27:	eb 31                	jmp    80106a5a <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a2c:	83 ec 0c             	sub    $0xc,%esp
80106a2f:	50                   	push   %eax
80106a30:	e8 84 ff ff ff       	call   801069b9 <fdalloc>
80106a35:	83 c4 10             	add    $0x10,%esp
80106a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a3f:	79 07                	jns    80106a48 <sys_dup+0x43>
    return -1;
80106a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a46:	eb 12                	jmp    80106a5a <sys_dup+0x55>
  filedup(f);
80106a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a4b:	83 ec 0c             	sub    $0xc,%esp
80106a4e:	50                   	push   %eax
80106a4f:	e8 51 a6 ff ff       	call   801010a5 <filedup>
80106a54:	83 c4 10             	add    $0x10,%esp
  return fd;
80106a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a5a:	c9                   	leave  
80106a5b:	c3                   	ret    

80106a5c <sys_read>:

int
sys_read(void)
{
80106a5c:	55                   	push   %ebp
80106a5d:	89 e5                	mov    %esp,%ebp
80106a5f:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a62:	83 ec 04             	sub    $0x4,%esp
80106a65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a68:	50                   	push   %eax
80106a69:	6a 00                	push   $0x0
80106a6b:	6a 00                	push   $0x0
80106a6d:	e8 d2 fe ff ff       	call   80106944 <argfd>
80106a72:	83 c4 10             	add    $0x10,%esp
80106a75:	85 c0                	test   %eax,%eax
80106a77:	78 2e                	js     80106aa7 <sys_read+0x4b>
80106a79:	83 ec 08             	sub    $0x8,%esp
80106a7c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a7f:	50                   	push   %eax
80106a80:	6a 02                	push   $0x2
80106a82:	e8 81 fd ff ff       	call   80106808 <argint>
80106a87:	83 c4 10             	add    $0x10,%esp
80106a8a:	85 c0                	test   %eax,%eax
80106a8c:	78 19                	js     80106aa7 <sys_read+0x4b>
80106a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a91:	83 ec 04             	sub    $0x4,%esp
80106a94:	50                   	push   %eax
80106a95:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a98:	50                   	push   %eax
80106a99:	6a 01                	push   $0x1
80106a9b:	e8 90 fd ff ff       	call   80106830 <argptr>
80106aa0:	83 c4 10             	add    $0x10,%esp
80106aa3:	85 c0                	test   %eax,%eax
80106aa5:	79 07                	jns    80106aae <sys_read+0x52>
    return -1;
80106aa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aac:	eb 17                	jmp    80106ac5 <sys_read+0x69>
  return fileread(f, p, n);
80106aae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106ab1:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ab7:	83 ec 04             	sub    $0x4,%esp
80106aba:	51                   	push   %ecx
80106abb:	52                   	push   %edx
80106abc:	50                   	push   %eax
80106abd:	e8 73 a7 ff ff       	call   80101235 <fileread>
80106ac2:	83 c4 10             	add    $0x10,%esp
}
80106ac5:	c9                   	leave  
80106ac6:	c3                   	ret    

80106ac7 <sys_write>:

int
sys_write(void)
{
80106ac7:	55                   	push   %ebp
80106ac8:	89 e5                	mov    %esp,%ebp
80106aca:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106acd:	83 ec 04             	sub    $0x4,%esp
80106ad0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ad3:	50                   	push   %eax
80106ad4:	6a 00                	push   $0x0
80106ad6:	6a 00                	push   $0x0
80106ad8:	e8 67 fe ff ff       	call   80106944 <argfd>
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	85 c0                	test   %eax,%eax
80106ae2:	78 2e                	js     80106b12 <sys_write+0x4b>
80106ae4:	83 ec 08             	sub    $0x8,%esp
80106ae7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106aea:	50                   	push   %eax
80106aeb:	6a 02                	push   $0x2
80106aed:	e8 16 fd ff ff       	call   80106808 <argint>
80106af2:	83 c4 10             	add    $0x10,%esp
80106af5:	85 c0                	test   %eax,%eax
80106af7:	78 19                	js     80106b12 <sys_write+0x4b>
80106af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106afc:	83 ec 04             	sub    $0x4,%esp
80106aff:	50                   	push   %eax
80106b00:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b03:	50                   	push   %eax
80106b04:	6a 01                	push   $0x1
80106b06:	e8 25 fd ff ff       	call   80106830 <argptr>
80106b0b:	83 c4 10             	add    $0x10,%esp
80106b0e:	85 c0                	test   %eax,%eax
80106b10:	79 07                	jns    80106b19 <sys_write+0x52>
    return -1;
80106b12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b17:	eb 17                	jmp    80106b30 <sys_write+0x69>
  return filewrite(f, p, n);
80106b19:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b22:	83 ec 04             	sub    $0x4,%esp
80106b25:	51                   	push   %ecx
80106b26:	52                   	push   %edx
80106b27:	50                   	push   %eax
80106b28:	e8 c0 a7 ff ff       	call   801012ed <filewrite>
80106b2d:	83 c4 10             	add    $0x10,%esp
}
80106b30:	c9                   	leave  
80106b31:	c3                   	ret    

80106b32 <sys_close>:

int
sys_close(void)
{
80106b32:	55                   	push   %ebp
80106b33:	89 e5                	mov    %esp,%ebp
80106b35:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106b38:	83 ec 04             	sub    $0x4,%esp
80106b3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b3e:	50                   	push   %eax
80106b3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b42:	50                   	push   %eax
80106b43:	6a 00                	push   $0x0
80106b45:	e8 fa fd ff ff       	call   80106944 <argfd>
80106b4a:	83 c4 10             	add    $0x10,%esp
80106b4d:	85 c0                	test   %eax,%eax
80106b4f:	79 07                	jns    80106b58 <sys_close+0x26>
    return -1;
80106b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b56:	eb 28                	jmp    80106b80 <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106b58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b61:	83 c2 08             	add    $0x8,%edx
80106b64:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b6b:	00 
  fileclose(f);
80106b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b6f:	83 ec 0c             	sub    $0xc,%esp
80106b72:	50                   	push   %eax
80106b73:	e8 7e a5 ff ff       	call   801010f6 <fileclose>
80106b78:	83 c4 10             	add    $0x10,%esp
  return 0;
80106b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b80:	c9                   	leave  
80106b81:	c3                   	ret    

80106b82 <sys_fstat>:

int
sys_fstat(void)
{
80106b82:	55                   	push   %ebp
80106b83:	89 e5                	mov    %esp,%ebp
80106b85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106b88:	83 ec 04             	sub    $0x4,%esp
80106b8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b8e:	50                   	push   %eax
80106b8f:	6a 00                	push   $0x0
80106b91:	6a 00                	push   $0x0
80106b93:	e8 ac fd ff ff       	call   80106944 <argfd>
80106b98:	83 c4 10             	add    $0x10,%esp
80106b9b:	85 c0                	test   %eax,%eax
80106b9d:	78 17                	js     80106bb6 <sys_fstat+0x34>
80106b9f:	83 ec 04             	sub    $0x4,%esp
80106ba2:	6a 14                	push   $0x14
80106ba4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ba7:	50                   	push   %eax
80106ba8:	6a 01                	push   $0x1
80106baa:	e8 81 fc ff ff       	call   80106830 <argptr>
80106baf:	83 c4 10             	add    $0x10,%esp
80106bb2:	85 c0                	test   %eax,%eax
80106bb4:	79 07                	jns    80106bbd <sys_fstat+0x3b>
    return -1;
80106bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bbb:	eb 13                	jmp    80106bd0 <sys_fstat+0x4e>
  return filestat(f, st);
80106bbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc3:	83 ec 08             	sub    $0x8,%esp
80106bc6:	52                   	push   %edx
80106bc7:	50                   	push   %eax
80106bc8:	e8 11 a6 ff ff       	call   801011de <filestat>
80106bcd:	83 c4 10             	add    $0x10,%esp
}
80106bd0:	c9                   	leave  
80106bd1:	c3                   	ret    

80106bd2 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106bd2:	55                   	push   %ebp
80106bd3:	89 e5                	mov    %esp,%ebp
80106bd5:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106bd8:	83 ec 08             	sub    $0x8,%esp
80106bdb:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106bde:	50                   	push   %eax
80106bdf:	6a 00                	push   $0x0
80106be1:	e8 a7 fc ff ff       	call   8010688d <argstr>
80106be6:	83 c4 10             	add    $0x10,%esp
80106be9:	85 c0                	test   %eax,%eax
80106beb:	78 15                	js     80106c02 <sys_link+0x30>
80106bed:	83 ec 08             	sub    $0x8,%esp
80106bf0:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106bf3:	50                   	push   %eax
80106bf4:	6a 01                	push   $0x1
80106bf6:	e8 92 fc ff ff       	call   8010688d <argstr>
80106bfb:	83 c4 10             	add    $0x10,%esp
80106bfe:	85 c0                	test   %eax,%eax
80106c00:	79 0a                	jns    80106c0c <sys_link+0x3a>
    return -1;
80106c02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c07:	e9 68 01 00 00       	jmp    80106d74 <sys_link+0x1a2>

  begin_op();
80106c0c:	e8 e1 c9 ff ff       	call   801035f2 <begin_op>
  if((ip = namei(old)) == 0){
80106c11:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106c14:	83 ec 0c             	sub    $0xc,%esp
80106c17:	50                   	push   %eax
80106c18:	e8 b0 b9 ff ff       	call   801025cd <namei>
80106c1d:	83 c4 10             	add    $0x10,%esp
80106c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c27:	75 0f                	jne    80106c38 <sys_link+0x66>
    end_op();
80106c29:	e8 50 ca ff ff       	call   8010367e <end_op>
    return -1;
80106c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c33:	e9 3c 01 00 00       	jmp    80106d74 <sys_link+0x1a2>
  }

  ilock(ip);
80106c38:	83 ec 0c             	sub    $0xc,%esp
80106c3b:	ff 75 f4             	pushl  -0xc(%ebp)
80106c3e:	e8 cc ad ff ff       	call   80101a0f <ilock>
80106c43:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c49:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106c4d:	66 83 f8 01          	cmp    $0x1,%ax
80106c51:	75 1d                	jne    80106c70 <sys_link+0x9e>
    iunlockput(ip);
80106c53:	83 ec 0c             	sub    $0xc,%esp
80106c56:	ff 75 f4             	pushl  -0xc(%ebp)
80106c59:	e8 71 b0 ff ff       	call   80101ccf <iunlockput>
80106c5e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106c61:	e8 18 ca ff ff       	call   8010367e <end_op>
    return -1;
80106c66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c6b:	e9 04 01 00 00       	jmp    80106d74 <sys_link+0x1a2>
  }

  ip->nlink++;
80106c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c73:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106c77:	83 c0 01             	add    $0x1,%eax
80106c7a:	89 c2                	mov    %eax,%edx
80106c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c7f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106c83:	83 ec 0c             	sub    $0xc,%esp
80106c86:	ff 75 f4             	pushl  -0xc(%ebp)
80106c89:	e8 a7 ab ff ff       	call   80101835 <iupdate>
80106c8e:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106c91:	83 ec 0c             	sub    $0xc,%esp
80106c94:	ff 75 f4             	pushl  -0xc(%ebp)
80106c97:	e8 d1 ae ff ff       	call   80101b6d <iunlock>
80106c9c:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106ca2:	83 ec 08             	sub    $0x8,%esp
80106ca5:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106ca8:	52                   	push   %edx
80106ca9:	50                   	push   %eax
80106caa:	e8 3a b9 ff ff       	call   801025e9 <nameiparent>
80106caf:	83 c4 10             	add    $0x10,%esp
80106cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106cb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106cb9:	74 71                	je     80106d2c <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106cbb:	83 ec 0c             	sub    $0xc,%esp
80106cbe:	ff 75 f0             	pushl  -0x10(%ebp)
80106cc1:	e8 49 ad ff ff       	call   80101a0f <ilock>
80106cc6:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ccc:	8b 10                	mov    (%eax),%edx
80106cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd1:	8b 00                	mov    (%eax),%eax
80106cd3:	39 c2                	cmp    %eax,%edx
80106cd5:	75 1d                	jne    80106cf4 <sys_link+0x122>
80106cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cda:	8b 40 04             	mov    0x4(%eax),%eax
80106cdd:	83 ec 04             	sub    $0x4,%esp
80106ce0:	50                   	push   %eax
80106ce1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106ce4:	50                   	push   %eax
80106ce5:	ff 75 f0             	pushl  -0x10(%ebp)
80106ce8:	e8 44 b6 ff ff       	call   80102331 <dirlink>
80106ced:	83 c4 10             	add    $0x10,%esp
80106cf0:	85 c0                	test   %eax,%eax
80106cf2:	79 10                	jns    80106d04 <sys_link+0x132>
    iunlockput(dp);
80106cf4:	83 ec 0c             	sub    $0xc,%esp
80106cf7:	ff 75 f0             	pushl  -0x10(%ebp)
80106cfa:	e8 d0 af ff ff       	call   80101ccf <iunlockput>
80106cff:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106d02:	eb 29                	jmp    80106d2d <sys_link+0x15b>
  }
  iunlockput(dp);
80106d04:	83 ec 0c             	sub    $0xc,%esp
80106d07:	ff 75 f0             	pushl  -0x10(%ebp)
80106d0a:	e8 c0 af ff ff       	call   80101ccf <iunlockput>
80106d0f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106d12:	83 ec 0c             	sub    $0xc,%esp
80106d15:	ff 75 f4             	pushl  -0xc(%ebp)
80106d18:	e8 c2 ae ff ff       	call   80101bdf <iput>
80106d1d:	83 c4 10             	add    $0x10,%esp

  end_op();
80106d20:	e8 59 c9 ff ff       	call   8010367e <end_op>

  return 0;
80106d25:	b8 00 00 00 00       	mov    $0x0,%eax
80106d2a:	eb 48                	jmp    80106d74 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106d2c:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106d2d:	83 ec 0c             	sub    $0xc,%esp
80106d30:	ff 75 f4             	pushl  -0xc(%ebp)
80106d33:	e8 d7 ac ff ff       	call   80101a0f <ilock>
80106d38:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d3e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d42:	83 e8 01             	sub    $0x1,%eax
80106d45:	89 c2                	mov    %eax,%edx
80106d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d4a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106d4e:	83 ec 0c             	sub    $0xc,%esp
80106d51:	ff 75 f4             	pushl  -0xc(%ebp)
80106d54:	e8 dc aa ff ff       	call   80101835 <iupdate>
80106d59:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106d5c:	83 ec 0c             	sub    $0xc,%esp
80106d5f:	ff 75 f4             	pushl  -0xc(%ebp)
80106d62:	e8 68 af ff ff       	call   80101ccf <iunlockput>
80106d67:	83 c4 10             	add    $0x10,%esp
  end_op();
80106d6a:	e8 0f c9 ff ff       	call   8010367e <end_op>
  return -1;
80106d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d74:	c9                   	leave  
80106d75:	c3                   	ret    

80106d76 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106d76:	55                   	push   %ebp
80106d77:	89 e5                	mov    %esp,%ebp
80106d79:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106d7c:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106d83:	eb 40                	jmp    80106dc5 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d88:	6a 10                	push   $0x10
80106d8a:	50                   	push   %eax
80106d8b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106d8e:	50                   	push   %eax
80106d8f:	ff 75 08             	pushl  0x8(%ebp)
80106d92:	e8 e6 b1 ff ff       	call   80101f7d <readi>
80106d97:	83 c4 10             	add    $0x10,%esp
80106d9a:	83 f8 10             	cmp    $0x10,%eax
80106d9d:	74 0d                	je     80106dac <isdirempty+0x36>
      panic("isdirempty: readi");
80106d9f:	83 ec 0c             	sub    $0xc,%esp
80106da2:	68 7d 9f 10 80       	push   $0x80109f7d
80106da7:	e8 ba 97 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106dac:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106db0:	66 85 c0             	test   %ax,%ax
80106db3:	74 07                	je     80106dbc <isdirempty+0x46>
      return 0;
80106db5:	b8 00 00 00 00       	mov    $0x0,%eax
80106dba:	eb 1b                	jmp    80106dd7 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dbf:	83 c0 10             	add    $0x10,%eax
80106dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc8:	8b 50 18             	mov    0x18(%eax),%edx
80106dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dce:	39 c2                	cmp    %eax,%edx
80106dd0:	77 b3                	ja     80106d85 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106dd2:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106dd7:	c9                   	leave  
80106dd8:	c3                   	ret    

80106dd9 <sys_unlink>:

int
sys_unlink(void)
{
80106dd9:	55                   	push   %ebp
80106dda:	89 e5                	mov    %esp,%ebp
80106ddc:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106ddf:	83 ec 08             	sub    $0x8,%esp
80106de2:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106de5:	50                   	push   %eax
80106de6:	6a 00                	push   $0x0
80106de8:	e8 a0 fa ff ff       	call   8010688d <argstr>
80106ded:	83 c4 10             	add    $0x10,%esp
80106df0:	85 c0                	test   %eax,%eax
80106df2:	79 0a                	jns    80106dfe <sys_unlink+0x25>
    return -1;
80106df4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106df9:	e9 bc 01 00 00       	jmp    80106fba <sys_unlink+0x1e1>

  begin_op();
80106dfe:	e8 ef c7 ff ff       	call   801035f2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106e03:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106e06:	83 ec 08             	sub    $0x8,%esp
80106e09:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106e0c:	52                   	push   %edx
80106e0d:	50                   	push   %eax
80106e0e:	e8 d6 b7 ff ff       	call   801025e9 <nameiparent>
80106e13:	83 c4 10             	add    $0x10,%esp
80106e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e1d:	75 0f                	jne    80106e2e <sys_unlink+0x55>
    end_op();
80106e1f:	e8 5a c8 ff ff       	call   8010367e <end_op>
    return -1;
80106e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e29:	e9 8c 01 00 00       	jmp    80106fba <sys_unlink+0x1e1>
  }

  ilock(dp);
80106e2e:	83 ec 0c             	sub    $0xc,%esp
80106e31:	ff 75 f4             	pushl  -0xc(%ebp)
80106e34:	e8 d6 ab ff ff       	call   80101a0f <ilock>
80106e39:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106e3c:	83 ec 08             	sub    $0x8,%esp
80106e3f:	68 8f 9f 10 80       	push   $0x80109f8f
80106e44:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e47:	50                   	push   %eax
80106e48:	e8 0f b4 ff ff       	call   8010225c <namecmp>
80106e4d:	83 c4 10             	add    $0x10,%esp
80106e50:	85 c0                	test   %eax,%eax
80106e52:	0f 84 4a 01 00 00    	je     80106fa2 <sys_unlink+0x1c9>
80106e58:	83 ec 08             	sub    $0x8,%esp
80106e5b:	68 91 9f 10 80       	push   $0x80109f91
80106e60:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e63:	50                   	push   %eax
80106e64:	e8 f3 b3 ff ff       	call   8010225c <namecmp>
80106e69:	83 c4 10             	add    $0x10,%esp
80106e6c:	85 c0                	test   %eax,%eax
80106e6e:	0f 84 2e 01 00 00    	je     80106fa2 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106e74:	83 ec 04             	sub    $0x4,%esp
80106e77:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106e7a:	50                   	push   %eax
80106e7b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e7e:	50                   	push   %eax
80106e7f:	ff 75 f4             	pushl  -0xc(%ebp)
80106e82:	e8 f0 b3 ff ff       	call   80102277 <dirlookup>
80106e87:	83 c4 10             	add    $0x10,%esp
80106e8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106e8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e91:	0f 84 0a 01 00 00    	je     80106fa1 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106e97:	83 ec 0c             	sub    $0xc,%esp
80106e9a:	ff 75 f0             	pushl  -0x10(%ebp)
80106e9d:	e8 6d ab ff ff       	call   80101a0f <ilock>
80106ea2:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ea8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106eac:	66 85 c0             	test   %ax,%ax
80106eaf:	7f 0d                	jg     80106ebe <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106eb1:	83 ec 0c             	sub    $0xc,%esp
80106eb4:	68 94 9f 10 80       	push   $0x80109f94
80106eb9:	e8 a8 96 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ec1:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106ec5:	66 83 f8 01          	cmp    $0x1,%ax
80106ec9:	75 25                	jne    80106ef0 <sys_unlink+0x117>
80106ecb:	83 ec 0c             	sub    $0xc,%esp
80106ece:	ff 75 f0             	pushl  -0x10(%ebp)
80106ed1:	e8 a0 fe ff ff       	call   80106d76 <isdirempty>
80106ed6:	83 c4 10             	add    $0x10,%esp
80106ed9:	85 c0                	test   %eax,%eax
80106edb:	75 13                	jne    80106ef0 <sys_unlink+0x117>
    iunlockput(ip);
80106edd:	83 ec 0c             	sub    $0xc,%esp
80106ee0:	ff 75 f0             	pushl  -0x10(%ebp)
80106ee3:	e8 e7 ad ff ff       	call   80101ccf <iunlockput>
80106ee8:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106eeb:	e9 b2 00 00 00       	jmp    80106fa2 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106ef0:	83 ec 04             	sub    $0x4,%esp
80106ef3:	6a 10                	push   $0x10
80106ef5:	6a 00                	push   $0x0
80106ef7:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106efa:	50                   	push   %eax
80106efb:	e8 e3 f5 ff ff       	call   801064e3 <memset>
80106f00:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106f03:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106f06:	6a 10                	push   $0x10
80106f08:	50                   	push   %eax
80106f09:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106f0c:	50                   	push   %eax
80106f0d:	ff 75 f4             	pushl  -0xc(%ebp)
80106f10:	e8 bf b1 ff ff       	call   801020d4 <writei>
80106f15:	83 c4 10             	add    $0x10,%esp
80106f18:	83 f8 10             	cmp    $0x10,%eax
80106f1b:	74 0d                	je     80106f2a <sys_unlink+0x151>
    panic("unlink: writei");
80106f1d:	83 ec 0c             	sub    $0xc,%esp
80106f20:	68 a6 9f 10 80       	push   $0x80109fa6
80106f25:	e8 3c 96 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f2d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f31:	66 83 f8 01          	cmp    $0x1,%ax
80106f35:	75 21                	jne    80106f58 <sys_unlink+0x17f>
    dp->nlink--;
80106f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106f3e:	83 e8 01             	sub    $0x1,%eax
80106f41:	89 c2                	mov    %eax,%edx
80106f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f46:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106f4a:	83 ec 0c             	sub    $0xc,%esp
80106f4d:	ff 75 f4             	pushl  -0xc(%ebp)
80106f50:	e8 e0 a8 ff ff       	call   80101835 <iupdate>
80106f55:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106f58:	83 ec 0c             	sub    $0xc,%esp
80106f5b:	ff 75 f4             	pushl  -0xc(%ebp)
80106f5e:	e8 6c ad ff ff       	call   80101ccf <iunlockput>
80106f63:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f69:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106f6d:	83 e8 01             	sub    $0x1,%eax
80106f70:	89 c2                	mov    %eax,%edx
80106f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f75:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106f79:	83 ec 0c             	sub    $0xc,%esp
80106f7c:	ff 75 f0             	pushl  -0x10(%ebp)
80106f7f:	e8 b1 a8 ff ff       	call   80101835 <iupdate>
80106f84:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106f87:	83 ec 0c             	sub    $0xc,%esp
80106f8a:	ff 75 f0             	pushl  -0x10(%ebp)
80106f8d:	e8 3d ad ff ff       	call   80101ccf <iunlockput>
80106f92:	83 c4 10             	add    $0x10,%esp

  end_op();
80106f95:	e8 e4 c6 ff ff       	call   8010367e <end_op>

  return 0;
80106f9a:	b8 00 00 00 00       	mov    $0x0,%eax
80106f9f:	eb 19                	jmp    80106fba <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106fa1:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106fa2:	83 ec 0c             	sub    $0xc,%esp
80106fa5:	ff 75 f4             	pushl  -0xc(%ebp)
80106fa8:	e8 22 ad ff ff       	call   80101ccf <iunlockput>
80106fad:	83 c4 10             	add    $0x10,%esp
  end_op();
80106fb0:	e8 c9 c6 ff ff       	call   8010367e <end_op>
  return -1;
80106fb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fba:	c9                   	leave  
80106fbb:	c3                   	ret    

80106fbc <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106fbc:	55                   	push   %ebp
80106fbd:	89 e5                	mov    %esp,%ebp
80106fbf:	83 ec 38             	sub    $0x38,%esp
80106fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fc5:	8b 55 10             	mov    0x10(%ebp),%edx
80106fc8:	8b 45 14             	mov    0x14(%ebp),%eax
80106fcb:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106fcf:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106fd3:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106fd7:	83 ec 08             	sub    $0x8,%esp
80106fda:	8d 45 de             	lea    -0x22(%ebp),%eax
80106fdd:	50                   	push   %eax
80106fde:	ff 75 08             	pushl  0x8(%ebp)
80106fe1:	e8 03 b6 ff ff       	call   801025e9 <nameiparent>
80106fe6:	83 c4 10             	add    $0x10,%esp
80106fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ff0:	75 0a                	jne    80106ffc <create+0x40>
    return 0;
80106ff2:	b8 00 00 00 00       	mov    $0x0,%eax
80106ff7:	e9 90 01 00 00       	jmp    8010718c <create+0x1d0>
  ilock(dp);
80106ffc:	83 ec 0c             	sub    $0xc,%esp
80106fff:	ff 75 f4             	pushl  -0xc(%ebp)
80107002:	e8 08 aa ff ff       	call   80101a0f <ilock>
80107007:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010700a:	83 ec 04             	sub    $0x4,%esp
8010700d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107010:	50                   	push   %eax
80107011:	8d 45 de             	lea    -0x22(%ebp),%eax
80107014:	50                   	push   %eax
80107015:	ff 75 f4             	pushl  -0xc(%ebp)
80107018:	e8 5a b2 ff ff       	call   80102277 <dirlookup>
8010701d:	83 c4 10             	add    $0x10,%esp
80107020:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107023:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107027:	74 50                	je     80107079 <create+0xbd>
    iunlockput(dp);
80107029:	83 ec 0c             	sub    $0xc,%esp
8010702c:	ff 75 f4             	pushl  -0xc(%ebp)
8010702f:	e8 9b ac ff ff       	call   80101ccf <iunlockput>
80107034:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107037:	83 ec 0c             	sub    $0xc,%esp
8010703a:	ff 75 f0             	pushl  -0x10(%ebp)
8010703d:	e8 cd a9 ff ff       	call   80101a0f <ilock>
80107042:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80107045:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010704a:	75 15                	jne    80107061 <create+0xa5>
8010704c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010704f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107053:	66 83 f8 02          	cmp    $0x2,%ax
80107057:	75 08                	jne    80107061 <create+0xa5>
      return ip;
80107059:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010705c:	e9 2b 01 00 00       	jmp    8010718c <create+0x1d0>
    iunlockput(ip);
80107061:	83 ec 0c             	sub    $0xc,%esp
80107064:	ff 75 f0             	pushl  -0x10(%ebp)
80107067:	e8 63 ac ff ff       	call   80101ccf <iunlockput>
8010706c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010706f:	b8 00 00 00 00       	mov    $0x0,%eax
80107074:	e9 13 01 00 00       	jmp    8010718c <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107079:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010707d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107080:	8b 00                	mov    (%eax),%eax
80107082:	83 ec 08             	sub    $0x8,%esp
80107085:	52                   	push   %edx
80107086:	50                   	push   %eax
80107087:	e8 d2 a6 ff ff       	call   8010175e <ialloc>
8010708c:	83 c4 10             	add    $0x10,%esp
8010708f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107092:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107096:	75 0d                	jne    801070a5 <create+0xe9>
    panic("create: ialloc");
80107098:	83 ec 0c             	sub    $0xc,%esp
8010709b:	68 b5 9f 10 80       	push   $0x80109fb5
801070a0:	e8 c1 94 ff ff       	call   80100566 <panic>

  ilock(ip);
801070a5:	83 ec 0c             	sub    $0xc,%esp
801070a8:	ff 75 f0             	pushl  -0x10(%ebp)
801070ab:	e8 5f a9 ff ff       	call   80101a0f <ilock>
801070b0:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801070b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070b6:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801070ba:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801070be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070c1:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801070c5:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801070c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070cc:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801070d2:	83 ec 0c             	sub    $0xc,%esp
801070d5:	ff 75 f0             	pushl  -0x10(%ebp)
801070d8:	e8 58 a7 ff ff       	call   80101835 <iupdate>
801070dd:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801070e0:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801070e5:	75 6a                	jne    80107151 <create+0x195>
    dp->nlink++;  // for ".."
801070e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ea:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801070ee:	83 c0 01             	add    $0x1,%eax
801070f1:	89 c2                	mov    %eax,%edx
801070f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f6:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801070fa:	83 ec 0c             	sub    $0xc,%esp
801070fd:	ff 75 f4             	pushl  -0xc(%ebp)
80107100:	e8 30 a7 ff ff       	call   80101835 <iupdate>
80107105:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010710b:	8b 40 04             	mov    0x4(%eax),%eax
8010710e:	83 ec 04             	sub    $0x4,%esp
80107111:	50                   	push   %eax
80107112:	68 8f 9f 10 80       	push   $0x80109f8f
80107117:	ff 75 f0             	pushl  -0x10(%ebp)
8010711a:	e8 12 b2 ff ff       	call   80102331 <dirlink>
8010711f:	83 c4 10             	add    $0x10,%esp
80107122:	85 c0                	test   %eax,%eax
80107124:	78 1e                	js     80107144 <create+0x188>
80107126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107129:	8b 40 04             	mov    0x4(%eax),%eax
8010712c:	83 ec 04             	sub    $0x4,%esp
8010712f:	50                   	push   %eax
80107130:	68 91 9f 10 80       	push   $0x80109f91
80107135:	ff 75 f0             	pushl  -0x10(%ebp)
80107138:	e8 f4 b1 ff ff       	call   80102331 <dirlink>
8010713d:	83 c4 10             	add    $0x10,%esp
80107140:	85 c0                	test   %eax,%eax
80107142:	79 0d                	jns    80107151 <create+0x195>
      panic("create dots");
80107144:	83 ec 0c             	sub    $0xc,%esp
80107147:	68 c4 9f 10 80       	push   $0x80109fc4
8010714c:	e8 15 94 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107151:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107154:	8b 40 04             	mov    0x4(%eax),%eax
80107157:	83 ec 04             	sub    $0x4,%esp
8010715a:	50                   	push   %eax
8010715b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010715e:	50                   	push   %eax
8010715f:	ff 75 f4             	pushl  -0xc(%ebp)
80107162:	e8 ca b1 ff ff       	call   80102331 <dirlink>
80107167:	83 c4 10             	add    $0x10,%esp
8010716a:	85 c0                	test   %eax,%eax
8010716c:	79 0d                	jns    8010717b <create+0x1bf>
    panic("create: dirlink");
8010716e:	83 ec 0c             	sub    $0xc,%esp
80107171:	68 d0 9f 10 80       	push   $0x80109fd0
80107176:	e8 eb 93 ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010717b:	83 ec 0c             	sub    $0xc,%esp
8010717e:	ff 75 f4             	pushl  -0xc(%ebp)
80107181:	e8 49 ab ff ff       	call   80101ccf <iunlockput>
80107186:	83 c4 10             	add    $0x10,%esp

  return ip;
80107189:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010718c:	c9                   	leave  
8010718d:	c3                   	ret    

8010718e <sys_open>:

int
sys_open(void)
{
8010718e:	55                   	push   %ebp
8010718f:	89 e5                	mov    %esp,%ebp
80107191:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107194:	83 ec 08             	sub    $0x8,%esp
80107197:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010719a:	50                   	push   %eax
8010719b:	6a 00                	push   $0x0
8010719d:	e8 eb f6 ff ff       	call   8010688d <argstr>
801071a2:	83 c4 10             	add    $0x10,%esp
801071a5:	85 c0                	test   %eax,%eax
801071a7:	78 15                	js     801071be <sys_open+0x30>
801071a9:	83 ec 08             	sub    $0x8,%esp
801071ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801071af:	50                   	push   %eax
801071b0:	6a 01                	push   $0x1
801071b2:	e8 51 f6 ff ff       	call   80106808 <argint>
801071b7:	83 c4 10             	add    $0x10,%esp
801071ba:	85 c0                	test   %eax,%eax
801071bc:	79 0a                	jns    801071c8 <sys_open+0x3a>
    return -1;
801071be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071c3:	e9 61 01 00 00       	jmp    80107329 <sys_open+0x19b>

  begin_op();
801071c8:	e8 25 c4 ff ff       	call   801035f2 <begin_op>

  if(omode & O_CREATE){
801071cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d0:	25 00 02 00 00       	and    $0x200,%eax
801071d5:	85 c0                	test   %eax,%eax
801071d7:	74 2a                	je     80107203 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801071d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801071dc:	6a 00                	push   $0x0
801071de:	6a 00                	push   $0x0
801071e0:	6a 02                	push   $0x2
801071e2:	50                   	push   %eax
801071e3:	e8 d4 fd ff ff       	call   80106fbc <create>
801071e8:	83 c4 10             	add    $0x10,%esp
801071eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801071ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071f2:	75 75                	jne    80107269 <sys_open+0xdb>
      end_op();
801071f4:	e8 85 c4 ff ff       	call   8010367e <end_op>
      return -1;
801071f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071fe:	e9 26 01 00 00       	jmp    80107329 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107203:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	50                   	push   %eax
8010720a:	e8 be b3 ff ff       	call   801025cd <namei>
8010720f:	83 c4 10             	add    $0x10,%esp
80107212:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107219:	75 0f                	jne    8010722a <sys_open+0x9c>
      end_op();
8010721b:	e8 5e c4 ff ff       	call   8010367e <end_op>
      return -1;
80107220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107225:	e9 ff 00 00 00       	jmp    80107329 <sys_open+0x19b>
    }
    ilock(ip);
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	ff 75 f4             	pushl  -0xc(%ebp)
80107230:	e8 da a7 ff ff       	call   80101a0f <ilock>
80107235:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010723f:	66 83 f8 01          	cmp    $0x1,%ax
80107243:	75 24                	jne    80107269 <sys_open+0xdb>
80107245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107248:	85 c0                	test   %eax,%eax
8010724a:	74 1d                	je     80107269 <sys_open+0xdb>
      iunlockput(ip);
8010724c:	83 ec 0c             	sub    $0xc,%esp
8010724f:	ff 75 f4             	pushl  -0xc(%ebp)
80107252:	e8 78 aa ff ff       	call   80101ccf <iunlockput>
80107257:	83 c4 10             	add    $0x10,%esp
      end_op();
8010725a:	e8 1f c4 ff ff       	call   8010367e <end_op>
      return -1;
8010725f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107264:	e9 c0 00 00 00       	jmp    80107329 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107269:	e8 ca 9d ff ff       	call   80101038 <filealloc>
8010726e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107271:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107275:	74 17                	je     8010728e <sys_open+0x100>
80107277:	83 ec 0c             	sub    $0xc,%esp
8010727a:	ff 75 f0             	pushl  -0x10(%ebp)
8010727d:	e8 37 f7 ff ff       	call   801069b9 <fdalloc>
80107282:	83 c4 10             	add    $0x10,%esp
80107285:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107288:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010728c:	79 2e                	jns    801072bc <sys_open+0x12e>
    if(f)
8010728e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107292:	74 0e                	je     801072a2 <sys_open+0x114>
      fileclose(f);
80107294:	83 ec 0c             	sub    $0xc,%esp
80107297:	ff 75 f0             	pushl  -0x10(%ebp)
8010729a:	e8 57 9e ff ff       	call   801010f6 <fileclose>
8010729f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801072a2:	83 ec 0c             	sub    $0xc,%esp
801072a5:	ff 75 f4             	pushl  -0xc(%ebp)
801072a8:	e8 22 aa ff ff       	call   80101ccf <iunlockput>
801072ad:	83 c4 10             	add    $0x10,%esp
    end_op();
801072b0:	e8 c9 c3 ff ff       	call   8010367e <end_op>
    return -1;
801072b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072ba:	eb 6d                	jmp    80107329 <sys_open+0x19b>
  }
  iunlock(ip);
801072bc:	83 ec 0c             	sub    $0xc,%esp
801072bf:	ff 75 f4             	pushl  -0xc(%ebp)
801072c2:	e8 a6 a8 ff ff       	call   80101b6d <iunlock>
801072c7:	83 c4 10             	add    $0x10,%esp
  end_op();
801072ca:	e8 af c3 ff ff       	call   8010367e <end_op>

  f->type = FD_INODE;
801072cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072d2:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801072d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072de:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801072e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072e4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801072eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ee:	83 e0 01             	and    $0x1,%eax
801072f1:	85 c0                	test   %eax,%eax
801072f3:	0f 94 c0             	sete   %al
801072f6:	89 c2                	mov    %eax,%edx
801072f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072fb:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801072fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107301:	83 e0 01             	and    $0x1,%eax
80107304:	85 c0                	test   %eax,%eax
80107306:	75 0a                	jne    80107312 <sys_open+0x184>
80107308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010730b:	83 e0 02             	and    $0x2,%eax
8010730e:	85 c0                	test   %eax,%eax
80107310:	74 07                	je     80107319 <sys_open+0x18b>
80107312:	b8 01 00 00 00       	mov    $0x1,%eax
80107317:	eb 05                	jmp    8010731e <sys_open+0x190>
80107319:	b8 00 00 00 00       	mov    $0x0,%eax
8010731e:	89 c2                	mov    %eax,%edx
80107320:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107323:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80107326:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107329:	c9                   	leave  
8010732a:	c3                   	ret    

8010732b <sys_mkdir>:

int
sys_mkdir(void)
{
8010732b:	55                   	push   %ebp
8010732c:	89 e5                	mov    %esp,%ebp
8010732e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107331:	e8 bc c2 ff ff       	call   801035f2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107336:	83 ec 08             	sub    $0x8,%esp
80107339:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010733c:	50                   	push   %eax
8010733d:	6a 00                	push   $0x0
8010733f:	e8 49 f5 ff ff       	call   8010688d <argstr>
80107344:	83 c4 10             	add    $0x10,%esp
80107347:	85 c0                	test   %eax,%eax
80107349:	78 1b                	js     80107366 <sys_mkdir+0x3b>
8010734b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010734e:	6a 00                	push   $0x0
80107350:	6a 00                	push   $0x0
80107352:	6a 01                	push   $0x1
80107354:	50                   	push   %eax
80107355:	e8 62 fc ff ff       	call   80106fbc <create>
8010735a:	83 c4 10             	add    $0x10,%esp
8010735d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107364:	75 0c                	jne    80107372 <sys_mkdir+0x47>
    end_op();
80107366:	e8 13 c3 ff ff       	call   8010367e <end_op>
    return -1;
8010736b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107370:	eb 18                	jmp    8010738a <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107372:	83 ec 0c             	sub    $0xc,%esp
80107375:	ff 75 f4             	pushl  -0xc(%ebp)
80107378:	e8 52 a9 ff ff       	call   80101ccf <iunlockput>
8010737d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107380:	e8 f9 c2 ff ff       	call   8010367e <end_op>
  return 0;
80107385:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010738a:	c9                   	leave  
8010738b:	c3                   	ret    

8010738c <sys_mknod>:

int
sys_mknod(void)
{
8010738c:	55                   	push   %ebp
8010738d:	89 e5                	mov    %esp,%ebp
8010738f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107392:	e8 5b c2 ff ff       	call   801035f2 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107397:	83 ec 08             	sub    $0x8,%esp
8010739a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010739d:	50                   	push   %eax
8010739e:	6a 00                	push   $0x0
801073a0:	e8 e8 f4 ff ff       	call   8010688d <argstr>
801073a5:	83 c4 10             	add    $0x10,%esp
801073a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073af:	78 4f                	js     80107400 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801073b1:	83 ec 08             	sub    $0x8,%esp
801073b4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801073b7:	50                   	push   %eax
801073b8:	6a 01                	push   $0x1
801073ba:	e8 49 f4 ff ff       	call   80106808 <argint>
801073bf:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801073c2:	85 c0                	test   %eax,%eax
801073c4:	78 3a                	js     80107400 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801073c6:	83 ec 08             	sub    $0x8,%esp
801073c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801073cc:	50                   	push   %eax
801073cd:	6a 02                	push   $0x2
801073cf:	e8 34 f4 ff ff       	call   80106808 <argint>
801073d4:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801073d7:	85 c0                	test   %eax,%eax
801073d9:	78 25                	js     80107400 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801073db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073de:	0f bf c8             	movswl %ax,%ecx
801073e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801073e4:	0f bf d0             	movswl %ax,%edx
801073e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801073ea:	51                   	push   %ecx
801073eb:	52                   	push   %edx
801073ec:	6a 03                	push   $0x3
801073ee:	50                   	push   %eax
801073ef:	e8 c8 fb ff ff       	call   80106fbc <create>
801073f4:	83 c4 10             	add    $0x10,%esp
801073f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801073fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801073fe:	75 0c                	jne    8010740c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107400:	e8 79 c2 ff ff       	call   8010367e <end_op>
    return -1;
80107405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010740a:	eb 18                	jmp    80107424 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010740c:	83 ec 0c             	sub    $0xc,%esp
8010740f:	ff 75 f0             	pushl  -0x10(%ebp)
80107412:	e8 b8 a8 ff ff       	call   80101ccf <iunlockput>
80107417:	83 c4 10             	add    $0x10,%esp
  end_op();
8010741a:	e8 5f c2 ff ff       	call   8010367e <end_op>
  return 0;
8010741f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107424:	c9                   	leave  
80107425:	c3                   	ret    

80107426 <sys_chdir>:

int
sys_chdir(void)
{
80107426:	55                   	push   %ebp
80107427:	89 e5                	mov    %esp,%ebp
80107429:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010742c:	e8 c1 c1 ff ff       	call   801035f2 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107431:	83 ec 08             	sub    $0x8,%esp
80107434:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107437:	50                   	push   %eax
80107438:	6a 00                	push   $0x0
8010743a:	e8 4e f4 ff ff       	call   8010688d <argstr>
8010743f:	83 c4 10             	add    $0x10,%esp
80107442:	85 c0                	test   %eax,%eax
80107444:	78 18                	js     8010745e <sys_chdir+0x38>
80107446:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107449:	83 ec 0c             	sub    $0xc,%esp
8010744c:	50                   	push   %eax
8010744d:	e8 7b b1 ff ff       	call   801025cd <namei>
80107452:	83 c4 10             	add    $0x10,%esp
80107455:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010745c:	75 0c                	jne    8010746a <sys_chdir+0x44>
    end_op();
8010745e:	e8 1b c2 ff ff       	call   8010367e <end_op>
    return -1;
80107463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107468:	eb 6e                	jmp    801074d8 <sys_chdir+0xb2>
  }
  ilock(ip);
8010746a:	83 ec 0c             	sub    $0xc,%esp
8010746d:	ff 75 f4             	pushl  -0xc(%ebp)
80107470:	e8 9a a5 ff ff       	call   80101a0f <ilock>
80107475:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107478:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010747f:	66 83 f8 01          	cmp    $0x1,%ax
80107483:	74 1a                	je     8010749f <sys_chdir+0x79>
    iunlockput(ip);
80107485:	83 ec 0c             	sub    $0xc,%esp
80107488:	ff 75 f4             	pushl  -0xc(%ebp)
8010748b:	e8 3f a8 ff ff       	call   80101ccf <iunlockput>
80107490:	83 c4 10             	add    $0x10,%esp
    end_op();
80107493:	e8 e6 c1 ff ff       	call   8010367e <end_op>
    return -1;
80107498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010749d:	eb 39                	jmp    801074d8 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010749f:	83 ec 0c             	sub    $0xc,%esp
801074a2:	ff 75 f4             	pushl  -0xc(%ebp)
801074a5:	e8 c3 a6 ff ff       	call   80101b6d <iunlock>
801074aa:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801074ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074b3:	8b 40 68             	mov    0x68(%eax),%eax
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	50                   	push   %eax
801074ba:	e8 20 a7 ff ff       	call   80101bdf <iput>
801074bf:	83 c4 10             	add    $0x10,%esp
  end_op();
801074c2:	e8 b7 c1 ff ff       	call   8010367e <end_op>
  proc->cwd = ip;
801074c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801074d0:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801074d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074d8:	c9                   	leave  
801074d9:	c3                   	ret    

801074da <sys_exec>:

int
sys_exec(void)
{
801074da:	55                   	push   %ebp
801074db:	89 e5                	mov    %esp,%ebp
801074dd:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801074e3:	83 ec 08             	sub    $0x8,%esp
801074e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074e9:	50                   	push   %eax
801074ea:	6a 00                	push   $0x0
801074ec:	e8 9c f3 ff ff       	call   8010688d <argstr>
801074f1:	83 c4 10             	add    $0x10,%esp
801074f4:	85 c0                	test   %eax,%eax
801074f6:	78 18                	js     80107510 <sys_exec+0x36>
801074f8:	83 ec 08             	sub    $0x8,%esp
801074fb:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107501:	50                   	push   %eax
80107502:	6a 01                	push   $0x1
80107504:	e8 ff f2 ff ff       	call   80106808 <argint>
80107509:	83 c4 10             	add    $0x10,%esp
8010750c:	85 c0                	test   %eax,%eax
8010750e:	79 0a                	jns    8010751a <sys_exec+0x40>
    return -1;
80107510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107515:	e9 c6 00 00 00       	jmp    801075e0 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010751a:	83 ec 04             	sub    $0x4,%esp
8010751d:	68 80 00 00 00       	push   $0x80
80107522:	6a 00                	push   $0x0
80107524:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010752a:	50                   	push   %eax
8010752b:	e8 b3 ef ff ff       	call   801064e3 <memset>
80107530:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010753a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753d:	83 f8 1f             	cmp    $0x1f,%eax
80107540:	76 0a                	jbe    8010754c <sys_exec+0x72>
      return -1;
80107542:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107547:	e9 94 00 00 00       	jmp    801075e0 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010754c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754f:	c1 e0 02             	shl    $0x2,%eax
80107552:	89 c2                	mov    %eax,%edx
80107554:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010755a:	01 c2                	add    %eax,%edx
8010755c:	83 ec 08             	sub    $0x8,%esp
8010755f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107565:	50                   	push   %eax
80107566:	52                   	push   %edx
80107567:	e8 00 f2 ff ff       	call   8010676c <fetchint>
8010756c:	83 c4 10             	add    $0x10,%esp
8010756f:	85 c0                	test   %eax,%eax
80107571:	79 07                	jns    8010757a <sys_exec+0xa0>
      return -1;
80107573:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107578:	eb 66                	jmp    801075e0 <sys_exec+0x106>
    if(uarg == 0){
8010757a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107580:	85 c0                	test   %eax,%eax
80107582:	75 27                	jne    801075ab <sys_exec+0xd1>
      argv[i] = 0;
80107584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107587:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010758e:	00 00 00 00 
      break;
80107592:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107593:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107596:	83 ec 08             	sub    $0x8,%esp
80107599:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010759f:	52                   	push   %edx
801075a0:	50                   	push   %eax
801075a1:	e8 70 96 ff ff       	call   80100c16 <exec>
801075a6:	83 c4 10             	add    $0x10,%esp
801075a9:	eb 35                	jmp    801075e0 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801075ab:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801075b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801075b4:	c1 e2 02             	shl    $0x2,%edx
801075b7:	01 c2                	add    %eax,%edx
801075b9:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801075bf:	83 ec 08             	sub    $0x8,%esp
801075c2:	52                   	push   %edx
801075c3:	50                   	push   %eax
801075c4:	e8 dd f1 ff ff       	call   801067a6 <fetchstr>
801075c9:	83 c4 10             	add    $0x10,%esp
801075cc:	85 c0                	test   %eax,%eax
801075ce:	79 07                	jns    801075d7 <sys_exec+0xfd>
      return -1;
801075d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075d5:	eb 09                	jmp    801075e0 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801075d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801075db:	e9 5a ff ff ff       	jmp    8010753a <sys_exec+0x60>
  return exec(path, argv);
}
801075e0:	c9                   	leave  
801075e1:	c3                   	ret    

801075e2 <sys_pipe>:

int
sys_pipe(void)
{
801075e2:	55                   	push   %ebp
801075e3:	89 e5                	mov    %esp,%ebp
801075e5:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801075e8:	83 ec 04             	sub    $0x4,%esp
801075eb:	6a 08                	push   $0x8
801075ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
801075f0:	50                   	push   %eax
801075f1:	6a 00                	push   $0x0
801075f3:	e8 38 f2 ff ff       	call   80106830 <argptr>
801075f8:	83 c4 10             	add    $0x10,%esp
801075fb:	85 c0                	test   %eax,%eax
801075fd:	79 0a                	jns    80107609 <sys_pipe+0x27>
    return -1;
801075ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107604:	e9 af 00 00 00       	jmp    801076b8 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107609:	83 ec 08             	sub    $0x8,%esp
8010760c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010760f:	50                   	push   %eax
80107610:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107613:	50                   	push   %eax
80107614:	e8 cd ca ff ff       	call   801040e6 <pipealloc>
80107619:	83 c4 10             	add    $0x10,%esp
8010761c:	85 c0                	test   %eax,%eax
8010761e:	79 0a                	jns    8010762a <sys_pipe+0x48>
    return -1;
80107620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107625:	e9 8e 00 00 00       	jmp    801076b8 <sys_pipe+0xd6>
  fd0 = -1;
8010762a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107631:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107634:	83 ec 0c             	sub    $0xc,%esp
80107637:	50                   	push   %eax
80107638:	e8 7c f3 ff ff       	call   801069b9 <fdalloc>
8010763d:	83 c4 10             	add    $0x10,%esp
80107640:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107643:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107647:	78 18                	js     80107661 <sys_pipe+0x7f>
80107649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010764c:	83 ec 0c             	sub    $0xc,%esp
8010764f:	50                   	push   %eax
80107650:	e8 64 f3 ff ff       	call   801069b9 <fdalloc>
80107655:	83 c4 10             	add    $0x10,%esp
80107658:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010765b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010765f:	79 3f                	jns    801076a0 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107665:	78 14                	js     8010767b <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107667:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010766d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107670:	83 c2 08             	add    $0x8,%edx
80107673:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010767a:	00 
    fileclose(rf);
8010767b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010767e:	83 ec 0c             	sub    $0xc,%esp
80107681:	50                   	push   %eax
80107682:	e8 6f 9a ff ff       	call   801010f6 <fileclose>
80107687:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010768a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768d:	83 ec 0c             	sub    $0xc,%esp
80107690:	50                   	push   %eax
80107691:	e8 60 9a ff ff       	call   801010f6 <fileclose>
80107696:	83 c4 10             	add    $0x10,%esp
    return -1;
80107699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010769e:	eb 18                	jmp    801076b8 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801076a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801076a6:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801076a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801076ab:	8d 50 04             	lea    0x4(%eax),%edx
801076ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076b1:	89 02                	mov    %eax,(%edx)
  return 0;
801076b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076b8:	c9                   	leave  
801076b9:	c3                   	ret    

801076ba <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801076ba:	55                   	push   %ebp
801076bb:	89 e5                	mov    %esp,%ebp
801076bd:	83 ec 08             	sub    $0x8,%esp
801076c0:	8b 55 08             	mov    0x8(%ebp),%edx
801076c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801076c6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801076ca:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801076ce:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801076d2:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801076d6:	66 ef                	out    %ax,(%dx)
}
801076d8:	90                   	nop
801076d9:	c9                   	leave  
801076da:	c3                   	ret    

801076db <sys_fork>:
#include "mmu.h"
#include "proc.h"
#include "uproc.h"
int
sys_fork(void)
{
801076db:	55                   	push   %ebp
801076dc:	89 e5                	mov    %esp,%ebp
801076de:	83 ec 08             	sub    $0x8,%esp
  return fork();
801076e1:	e8 f0 d2 ff ff       	call   801049d6 <fork>
}
801076e6:	c9                   	leave  
801076e7:	c3                   	ret    

801076e8 <sys_exit>:

int
sys_exit(void)
{
801076e8:	55                   	push   %ebp
801076e9:	89 e5                	mov    %esp,%ebp
801076eb:	83 ec 08             	sub    $0x8,%esp
  exit();
801076ee:	e8 43 d5 ff ff       	call   80104c36 <exit>
  return 0;  // not reached
801076f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076f8:	c9                   	leave  
801076f9:	c3                   	ret    

801076fa <sys_wait>:

int
sys_wait(void)
{
801076fa:	55                   	push   %ebp
801076fb:	89 e5                	mov    %esp,%ebp
801076fd:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107700:	e8 bf d6 ff ff       	call   80104dc4 <wait>
}
80107705:	c9                   	leave  
80107706:	c3                   	ret    

80107707 <sys_kill>:

int
sys_kill(void)
{
80107707:	55                   	push   %ebp
80107708:	89 e5                	mov    %esp,%ebp
8010770a:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010770d:	83 ec 08             	sub    $0x8,%esp
80107710:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107713:	50                   	push   %eax
80107714:	6a 00                	push   $0x0
80107716:	e8 ed f0 ff ff       	call   80106808 <argint>
8010771b:	83 c4 10             	add    $0x10,%esp
8010771e:	85 c0                	test   %eax,%eax
80107720:	79 07                	jns    80107729 <sys_kill+0x22>
    return -1;
80107722:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107727:	eb 0f                	jmp    80107738 <sys_kill+0x31>
  return kill(pid);
80107729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772c:	83 ec 0c             	sub    $0xc,%esp
8010772f:	50                   	push   %eax
80107730:	e8 e1 de ff ff       	call   80105616 <kill>
80107735:	83 c4 10             	add    $0x10,%esp
}
80107738:	c9                   	leave  
80107739:	c3                   	ret    

8010773a <sys_getpid>:

int
sys_getpid(void)
{
8010773a:	55                   	push   %ebp
8010773b:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010773d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107743:	8b 40 10             	mov    0x10(%eax),%eax
}
80107746:	5d                   	pop    %ebp
80107747:	c3                   	ret    

80107748 <sys_sbrk>:

int
sys_sbrk(void)
{
80107748:	55                   	push   %ebp
80107749:	89 e5                	mov    %esp,%ebp
8010774b:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)// remove this stub once you implement the date() system call.
8010774e:	83 ec 08             	sub    $0x8,%esp
80107751:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107754:	50                   	push   %eax
80107755:	6a 00                	push   $0x0
80107757:	e8 ac f0 ff ff       	call   80106808 <argint>
8010775c:	83 c4 10             	add    $0x10,%esp
8010775f:	85 c0                	test   %eax,%eax
80107761:	79 07                	jns    8010776a <sys_sbrk+0x22>
   return -1;
80107763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107768:	eb 28                	jmp    80107792 <sys_sbrk+0x4a>
  addr = proc->sz;
8010776a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107770:	8b 00                	mov    (%eax),%eax
80107772:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107775:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107778:	83 ec 0c             	sub    $0xc,%esp
8010777b:	50                   	push   %eax
8010777c:	e8 b2 d1 ff ff       	call   80104933 <growproc>
80107781:	83 c4 10             	add    $0x10,%esp
80107784:	85 c0                	test   %eax,%eax
80107786:	79 07                	jns    8010778f <sys_sbrk+0x47>
    return -1;
80107788:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010778d:	eb 03                	jmp    80107792 <sys_sbrk+0x4a>
  return addr;
8010778f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107792:	c9                   	leave  
80107793:	c3                   	ret    

80107794 <sys_sleep>:

int
sys_sleep(void)
{
80107794:	55                   	push   %ebp
80107795:	89 e5                	mov    %esp,%ebp
80107797:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010779a:	83 ec 08             	sub    $0x8,%esp
8010779d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077a0:	50                   	push   %eax
801077a1:	6a 00                	push   $0x0
801077a3:	e8 60 f0 ff ff       	call   80106808 <argint>
801077a8:	83 c4 10             	add    $0x10,%esp
801077ab:	85 c0                	test   %eax,%eax
801077ad:	79 07                	jns    801077b6 <sys_sleep+0x22>
    return -1;
801077af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077b4:	eb 44                	jmp    801077fa <sys_sleep+0x66>
  ticks0 = ticks;
801077b6:	a1 00 79 11 80       	mov    0x80117900,%eax
801077bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801077be:	eb 26                	jmp    801077e6 <sys_sleep+0x52>
    if(proc->killed){
801077c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077c6:	8b 40 24             	mov    0x24(%eax),%eax
801077c9:	85 c0                	test   %eax,%eax
801077cb:	74 07                	je     801077d4 <sys_sleep+0x40>
      return -1;
801077cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077d2:	eb 26                	jmp    801077fa <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
801077d4:	83 ec 08             	sub    $0x8,%esp
801077d7:	6a 00                	push   $0x0
801077d9:	68 00 79 11 80       	push   $0x80117900
801077de:	e8 cb db ff ff       	call   801053ae <sleep>
801077e3:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801077e6:	a1 00 79 11 80       	mov    0x80117900,%eax
801077eb:	2b 45 f4             	sub    -0xc(%ebp),%eax
801077ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
801077f1:	39 d0                	cmp    %edx,%eax
801077f3:	72 cb                	jb     801077c0 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
801077f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077fa:	c9                   	leave  
801077fb:	c3                   	ret    

801077fc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801077fc:	55                   	push   %ebp
801077fd:	89 e5                	mov    %esp,%ebp
801077ff:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107802:	a1 00 79 11 80       	mov    0x80117900,%eax
80107807:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
8010780a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010780d:	c9                   	leave  
8010780e:	c3                   	ret    

8010780f <sys_halt>:

//Turn of the computer
int 
sys_halt(void){
8010780f:	55                   	push   %ebp
80107810:	89 e5                	mov    %esp,%ebp
80107812:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107815:	83 ec 0c             	sub    $0xc,%esp
80107818:	68 e0 9f 10 80       	push   $0x80109fe0
8010781d:	e8 a4 8b ff ff       	call   801003c6 <cprintf>
80107822:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107825:	83 ec 08             	sub    $0x8,%esp
80107828:	68 00 20 00 00       	push   $0x2000
8010782d:	68 04 06 00 00       	push   $0x604
80107832:	e8 83 fe ff ff       	call   801076ba <outw>
80107837:	83 c4 10             	add    $0x10,%esp
  return 0;
8010783a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010783f:	c9                   	leave  
80107840:	c3                   	ret    

80107841 <sys_date>:

// return the date
int 
sys_date(void){
80107841:	55                   	push   %ebp
80107842:	89 e5                	mov    %esp,%ebp
80107844:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;
  if(argptr(0,(void*)&d, sizeof(struct rtcdate)) < 0)
80107847:	83 ec 04             	sub    $0x4,%esp
8010784a:	6a 18                	push   $0x18
8010784c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010784f:	50                   	push   %eax
80107850:	6a 00                	push   $0x0
80107852:	e8 d9 ef ff ff       	call   80106830 <argptr>
80107857:	83 c4 10             	add    $0x10,%esp
8010785a:	85 c0                	test   %eax,%eax
8010785c:	79 07                	jns    80107865 <sys_date+0x24>
    return -1;
8010785e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107863:	eb 14                	jmp    80107879 <sys_date+0x38>
  
  cmostime(d); //d updated
80107865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107868:	83 ec 0c             	sub    $0xc,%esp
8010786b:	50                   	push   %eax
8010786c:	e8 fc b9 ff ff       	call   8010326d <cmostime>
80107871:	83 c4 10             	add    $0x10,%esp
  
  return 0;
80107874:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107879:	c9                   	leave  
8010787a:	c3                   	ret    

8010787b <sys_getuid>:

uint 
sys_getuid(void){
8010787b:	55                   	push   %ebp
8010787c:	89 e5                	mov    %esp,%ebp
  return proc->uid;
8010787e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107884:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}       
8010788a:	5d                   	pop    %ebp
8010788b:	c3                   	ret    

8010788c <sys_getgid>:

uint 
sys_getgid(void){
8010788c:	55                   	push   %ebp
8010788d:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010788f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107895:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
8010789b:	5d                   	pop    %ebp
8010789c:	c3                   	ret    

8010789d <sys_getppid>:

uint
sys_getppid(void){
8010789d:	55                   	push   %ebp
8010789e:	89 e5                	mov    %esp,%ebp
801078a0:	83 ec 10             	sub    $0x10,%esp
  if(proc->parent)
801078a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078a9:	8b 40 14             	mov    0x14(%eax),%eax
801078ac:	85 c0                	test   %eax,%eax
801078ae:	74 0b                	je     801078bb <sys_getppid+0x1e>
  return proc->pid;
801078b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078b6:	8b 40 10             	mov    0x10(%eax),%eax
801078b9:	eb 12                	jmp    801078cd <sys_getppid+0x30>
  int parent_id = proc->parent->pid;
801078bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078c1:	8b 40 14             	mov    0x14(%eax),%eax
801078c4:	8b 40 10             	mov    0x10(%eax),%eax
801078c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return parent_id;
801078ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801078cd:	c9                   	leave  
801078ce:	c3                   	ret    

801078cf <sys_setuid>:

int 
sys_setuid(void){     
801078cf:	55                   	push   %ebp
801078d0:	89 e5                	mov    %esp,%ebp
801078d2:	83 ec 18             	sub    $0x18,%esp
int uid;
if(argint(0, &uid) < 0)
801078d5:	83 ec 08             	sub    $0x8,%esp
801078d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078db:	50                   	push   %eax
801078dc:	6a 00                	push   $0x0
801078de:	e8 25 ef ff ff       	call   80106808 <argint>
801078e3:	83 c4 10             	add    $0x10,%esp
801078e6:	85 c0                	test   %eax,%eax
801078e8:	79 07                	jns    801078f1 <sys_setuid+0x22>
    return -1;
801078ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078ef:	eb 2c                	jmp    8010791d <sys_setuid+0x4e>

  if(uid <0 || uid > 32767){
801078f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f4:	85 c0                	test   %eax,%eax
801078f6:	78 0a                	js     80107902 <sys_setuid+0x33>
801078f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fb:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107900:	7e 07                	jle    80107909 <sys_setuid+0x3a>
    return -1;
80107902:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107907:	eb 14                	jmp    8010791d <sys_setuid+0x4e>
  }
  proc->uid = uid;
80107909:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010790f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107912:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)

  return 0;
80107918:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010791d:	c9                   	leave  
8010791e:	c3                   	ret    

8010791f <sys_setgid>:

int 
sys_setgid(void){
8010791f:	55                   	push   %ebp
80107920:	89 e5                	mov    %esp,%ebp
80107922:	83 ec 18             	sub    $0x18,%esp
int gid;
 if(argint(0, &gid) < 0)
80107925:	83 ec 08             	sub    $0x8,%esp
80107928:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010792b:	50                   	push   %eax
8010792c:	6a 00                	push   $0x0
8010792e:	e8 d5 ee ff ff       	call   80106808 <argint>
80107933:	83 c4 10             	add    $0x10,%esp
80107936:	85 c0                	test   %eax,%eax
80107938:	79 07                	jns    80107941 <sys_setgid+0x22>
    return -1;
8010793a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010793f:	eb 2c                	jmp    8010796d <sys_setgid+0x4e>


  if(gid <0 || gid > 32767){
80107941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107944:	85 c0                	test   %eax,%eax
80107946:	78 0a                	js     80107952 <sys_setgid+0x33>
80107948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794b:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107950:	7e 07                	jle    80107959 <sys_setgid+0x3a>
    return -1;
80107952:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107957:	eb 14                	jmp    8010796d <sys_setgid+0x4e>
  }

  proc->gid = gid;
80107959:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010795f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107962:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  return 0;
80107968:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010796d:	c9                   	leave  
8010796e:	c3                   	ret    

8010796f <sys_getprocs>:

int 
sys_getprocs(void){
8010796f:	55                   	push   %ebp
80107970:	89 e5                	mov    %esp,%ebp
80107972:	83 ec 18             	sub    $0x18,%esp
  struct uproc *d;
  int n;
  
  if(argint(0, &n) < 0)
80107975:	83 ec 08             	sub    $0x8,%esp
80107978:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010797b:	50                   	push   %eax
8010797c:	6a 00                	push   $0x0
8010797e:	e8 85 ee ff ff       	call   80106808 <argint>
80107983:	83 c4 10             	add    $0x10,%esp
80107986:	85 c0                	test   %eax,%eax
80107988:	79 07                	jns    80107991 <sys_getprocs+0x22>
    return -1;
8010798a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010798f:	eb 31                	jmp    801079c2 <sys_getprocs+0x53>

  if(argptr(1,(void*)&d, sizeof(struct uproc)) < 0)
80107991:	83 ec 04             	sub    $0x4,%esp
80107994:	6a 60                	push   $0x60
80107996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107999:	50                   	push   %eax
8010799a:	6a 01                	push   $0x1
8010799c:	e8 8f ee ff ff       	call   80106830 <argptr>
801079a1:	83 c4 10             	add    $0x10,%esp
801079a4:	85 c0                	test   %eax,%eax
801079a6:	79 07                	jns    801079af <sys_getprocs+0x40>
    return -1;
801079a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079ad:	eb 13                	jmp    801079c2 <sys_getprocs+0x53>
  return getprocs(n, d);
801079af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801079b5:	83 ec 08             	sub    $0x8,%esp
801079b8:	50                   	push   %eax
801079b9:	52                   	push   %edx
801079ba:	e8 0a df ff ff       	call   801058c9 <getprocs>
801079bf:	83 c4 10             	add    $0x10,%esp
}
801079c2:	c9                   	leave  
801079c3:	c3                   	ret    

801079c4 <sys_setpriority>:

#ifdef CS333_P3P4

int
sys_setpriority(void){
801079c4:	55                   	push   %ebp
801079c5:	89 e5                	mov    %esp,%ebp
801079c7:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int priority;
  
  if(argint(0, &pid) < 0)
801079ca:	83 ec 08             	sub    $0x8,%esp
801079cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079d0:	50                   	push   %eax
801079d1:	6a 00                	push   $0x0
801079d3:	e8 30 ee ff ff       	call   80106808 <argint>
801079d8:	83 c4 10             	add    $0x10,%esp
801079db:	85 c0                	test   %eax,%eax
801079dd:	79 07                	jns    801079e6 <sys_setpriority+0x22>
    return -1;
801079df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079e4:	eb 45                	jmp    80107a2b <sys_setpriority+0x67>
   if(argint(1, &priority) < 0)
801079e6:	83 ec 08             	sub    $0x8,%esp
801079e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801079ec:	50                   	push   %eax
801079ed:	6a 01                	push   $0x1
801079ef:	e8 14 ee ff ff       	call   80106808 <argint>
801079f4:	83 c4 10             	add    $0x10,%esp
801079f7:	85 c0                	test   %eax,%eax
801079f9:	79 07                	jns    80107a02 <sys_setpriority+0x3e>
    return -1;
801079fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a00:	eb 29                	jmp    80107a2b <sys_setpriority+0x67>

  if(priority < 0 || priority > MAX){
80107a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a05:	85 c0                	test   %eax,%eax
80107a07:	78 08                	js     80107a11 <sys_setpriority+0x4d>
80107a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a0c:	83 f8 06             	cmp    $0x6,%eax
80107a0f:	7e 07                	jle    80107a18 <sys_setpriority+0x54>
    return -1;
80107a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a16:	eb 13                	jmp    80107a2b <sys_setpriority+0x67>
  }


  return setpriority(pid, priority);
80107a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1e:	83 ec 08             	sub    $0x8,%esp
80107a21:	52                   	push   %edx
80107a22:	50                   	push   %eax
80107a23:	e8 4d e6 ff ff       	call   80106075 <setpriority>
80107a28:	83 c4 10             	add    $0x10,%esp
}
80107a2b:	c9                   	leave  
80107a2c:	c3                   	ret    

80107a2d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107a2d:	55                   	push   %ebp
80107a2e:	89 e5                	mov    %esp,%ebp
80107a30:	83 ec 08             	sub    $0x8,%esp
80107a33:	8b 55 08             	mov    0x8(%ebp),%edx
80107a36:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a39:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107a3d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107a40:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107a44:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107a48:	ee                   	out    %al,(%dx)
}
80107a49:	90                   	nop
80107a4a:	c9                   	leave  
80107a4b:	c3                   	ret    

80107a4c <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80107a4c:	55                   	push   %ebp
80107a4d:	89 e5                	mov    %esp,%ebp
80107a4f:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107a52:	6a 34                	push   $0x34
80107a54:	6a 43                	push   $0x43
80107a56:	e8 d2 ff ff ff       	call   80107a2d <outb>
80107a5b:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
80107a5e:	68 a9 00 00 00       	push   $0xa9
80107a63:	6a 40                	push   $0x40
80107a65:	e8 c3 ff ff ff       	call   80107a2d <outb>
80107a6a:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
80107a6d:	6a 04                	push   $0x4
80107a6f:	6a 40                	push   $0x40
80107a71:	e8 b7 ff ff ff       	call   80107a2d <outb>
80107a76:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80107a79:	83 ec 0c             	sub    $0xc,%esp
80107a7c:	6a 00                	push   $0x0
80107a7e:	e8 4d c5 ff ff       	call   80103fd0 <picenable>
80107a83:	83 c4 10             	add    $0x10,%esp
}
80107a86:	90                   	nop
80107a87:	c9                   	leave  
80107a88:	c3                   	ret    

80107a89 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107a89:	1e                   	push   %ds
  pushl %es
80107a8a:	06                   	push   %es
  pushl %fs
80107a8b:	0f a0                	push   %fs
  pushl %gs
80107a8d:	0f a8                	push   %gs
  pushal
80107a8f:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107a90:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107a94:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107a96:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107a98:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107a9c:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107a9e:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107aa0:	54                   	push   %esp
  call trap
80107aa1:	e8 ce 01 00 00       	call   80107c74 <trap>
  addl $4, %esp
80107aa6:	83 c4 04             	add    $0x4,%esp

80107aa9 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107aa9:	61                   	popa   
  popl %gs
80107aaa:	0f a9                	pop    %gs
  popl %fs
80107aac:	0f a1                	pop    %fs
  popl %es
80107aae:	07                   	pop    %es
  popl %ds
80107aaf:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107ab0:	83 c4 08             	add    $0x8,%esp
  iret
80107ab3:	cf                   	iret   

80107ab4 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107ab4:	55                   	push   %ebp
80107ab5:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80107aba:	f0 ff 00             	lock incl (%eax)
}
80107abd:	90                   	nop
80107abe:	5d                   	pop    %ebp
80107abf:	c3                   	ret    

80107ac0 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ac9:	83 e8 01             	sub    $0x1,%eax
80107acc:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80107ada:	c1 e8 10             	shr    $0x10,%eax
80107add:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107ae1:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ae4:	0f 01 18             	lidtl  (%eax)
}
80107ae7:	90                   	nop
80107ae8:	c9                   	leave  
80107ae9:	c3                   	ret    

80107aea <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107aea:	55                   	push   %ebp
80107aeb:	89 e5                	mov    %esp,%ebp
80107aed:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107af0:	0f 20 d0             	mov    %cr2,%eax
80107af3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107af6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107af9:	c9                   	leave  
80107afa:	c3                   	ret    

80107afb <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107afb:	55                   	push   %ebp
80107afc:	89 e5                	mov    %esp,%ebp
80107afe:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107b01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107b08:	e9 c3 00 00 00       	jmp    80107bd0 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b10:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107b17:	89 c2                	mov    %eax,%edx
80107b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b1c:	66 89 14 c5 00 71 11 	mov    %dx,-0x7fee8f00(,%eax,8)
80107b23:	80 
80107b24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b27:	66 c7 04 c5 02 71 11 	movw   $0x8,-0x7fee8efe(,%eax,8)
80107b2e:	80 08 00 
80107b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b34:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
80107b3b:	80 
80107b3c:	83 e2 e0             	and    $0xffffffe0,%edx
80107b3f:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
80107b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b49:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
80107b50:	80 
80107b51:	83 e2 1f             	and    $0x1f,%edx
80107b54:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
80107b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b5e:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107b65:	80 
80107b66:	83 e2 f0             	and    $0xfffffff0,%edx
80107b69:	83 ca 0e             	or     $0xe,%edx
80107b6c:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b76:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107b7d:	80 
80107b7e:	83 e2 ef             	and    $0xffffffef,%edx
80107b81:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107b8b:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107b92:	80 
80107b93:	83 e2 9f             	and    $0xffffff9f,%edx
80107b96:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107ba0:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107ba7:	80 
80107ba8:	83 ca 80             	or     $0xffffff80,%edx
80107bab:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107bb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bb5:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107bbc:	c1 e8 10             	shr    $0x10,%eax
80107bbf:	89 c2                	mov    %eax,%edx
80107bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107bc4:	66 89 14 c5 06 71 11 	mov    %dx,-0x7fee8efa(,%eax,8)
80107bcb:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107bcc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107bd0:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107bd7:	0f 8e 30 ff ff ff    	jle    80107b0d <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107bdd:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107be2:	66 a3 00 73 11 80    	mov    %ax,0x80117300
80107be8:	66 c7 05 02 73 11 80 	movw   $0x8,0x80117302
80107bef:	08 00 
80107bf1:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80107bf8:	83 e0 e0             	and    $0xffffffe0,%eax
80107bfb:	a2 04 73 11 80       	mov    %al,0x80117304
80107c00:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80107c07:	83 e0 1f             	and    $0x1f,%eax
80107c0a:	a2 04 73 11 80       	mov    %al,0x80117304
80107c0f:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107c16:	83 c8 0f             	or     $0xf,%eax
80107c19:	a2 05 73 11 80       	mov    %al,0x80117305
80107c1e:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107c25:	83 e0 ef             	and    $0xffffffef,%eax
80107c28:	a2 05 73 11 80       	mov    %al,0x80117305
80107c2d:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107c34:	83 c8 60             	or     $0x60,%eax
80107c37:	a2 05 73 11 80       	mov    %al,0x80117305
80107c3c:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107c43:	83 c8 80             	or     $0xffffff80,%eax
80107c46:	a2 05 73 11 80       	mov    %al,0x80117305
80107c4b:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107c50:	c1 e8 10             	shr    $0x10,%eax
80107c53:	66 a3 06 73 11 80    	mov    %ax,0x80117306
  
}
80107c59:	90                   	nop
80107c5a:	c9                   	leave  
80107c5b:	c3                   	ret    

80107c5c <idtinit>:

void
idtinit(void)
{
80107c5c:	55                   	push   %ebp
80107c5d:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107c5f:	68 00 08 00 00       	push   $0x800
80107c64:	68 00 71 11 80       	push   $0x80117100
80107c69:	e8 52 fe ff ff       	call   80107ac0 <lidt>
80107c6e:	83 c4 08             	add    $0x8,%esp
}
80107c71:	90                   	nop
80107c72:	c9                   	leave  
80107c73:	c3                   	ret    

80107c74 <trap>:

void
trap(struct trapframe *tf)
{
80107c74:	55                   	push   %ebp
80107c75:	89 e5                	mov    %esp,%ebp
80107c77:	57                   	push   %edi
80107c78:	56                   	push   %esi
80107c79:	53                   	push   %ebx
80107c7a:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80107c80:	8b 40 30             	mov    0x30(%eax),%eax
80107c83:	83 f8 40             	cmp    $0x40,%eax
80107c86:	75 3e                	jne    80107cc6 <trap+0x52>
    if(proc->killed)
80107c88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c8e:	8b 40 24             	mov    0x24(%eax),%eax
80107c91:	85 c0                	test   %eax,%eax
80107c93:	74 05                	je     80107c9a <trap+0x26>
      exit();
80107c95:	e8 9c cf ff ff       	call   80104c36 <exit>
    proc->tf = tf;
80107c9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ca0:	8b 55 08             	mov    0x8(%ebp),%edx
80107ca3:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107ca6:	e8 13 ec ff ff       	call   801068be <syscall>
    if(proc->killed)
80107cab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cb1:	8b 40 24             	mov    0x24(%eax),%eax
80107cb4:	85 c0                	test   %eax,%eax
80107cb6:	0f 84 21 02 00 00    	je     80107edd <trap+0x269>
      exit();
80107cbc:	e8 75 cf ff ff       	call   80104c36 <exit>
    return;
80107cc1:	e9 17 02 00 00       	jmp    80107edd <trap+0x269>
  }

  switch(tf->trapno){
80107cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80107cc9:	8b 40 30             	mov    0x30(%eax),%eax
80107ccc:	83 e8 20             	sub    $0x20,%eax
80107ccf:	83 f8 1f             	cmp    $0x1f,%eax
80107cd2:	0f 87 a3 00 00 00    	ja     80107d7b <trap+0x107>
80107cd8:	8b 04 85 94 a0 10 80 	mov    -0x7fef5f6c(,%eax,4),%eax
80107cdf:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107ce1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107ce7:	0f b6 00             	movzbl (%eax),%eax
80107cea:	84 c0                	test   %al,%al
80107cec:	75 20                	jne    80107d0e <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107cee:	83 ec 0c             	sub    $0xc,%esp
80107cf1:	68 00 79 11 80       	push   $0x80117900
80107cf6:	e8 b9 fd ff ff       	call   80107ab4 <atom_inc>
80107cfb:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107cfe:	83 ec 0c             	sub    $0xc,%esp
80107d01:	68 00 79 11 80       	push   $0x80117900
80107d06:	e8 d4 d8 ff ff       	call   801055df <wakeup>
80107d0b:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107d0e:	e8 b7 b3 ff ff       	call   801030ca <lapiceoi>
    break;
80107d13:	e9 1c 01 00 00       	jmp    80107e34 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107d18:	e8 c0 ab ff ff       	call   801028dd <ideintr>
    lapiceoi();
80107d1d:	e8 a8 b3 ff ff       	call   801030ca <lapiceoi>
    break;
80107d22:	e9 0d 01 00 00       	jmp    80107e34 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107d27:	e8 a0 b1 ff ff       	call   80102ecc <kbdintr>
    lapiceoi();
80107d2c:	e8 99 b3 ff ff       	call   801030ca <lapiceoi>
    break;
80107d31:	e9 fe 00 00 00       	jmp    80107e34 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107d36:	e8 83 03 00 00       	call   801080be <uartintr>
    lapiceoi();
80107d3b:	e8 8a b3 ff ff       	call   801030ca <lapiceoi>
    break;
80107d40:	e9 ef 00 00 00       	jmp    80107e34 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107d45:	8b 45 08             	mov    0x8(%ebp),%eax
80107d48:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107d52:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107d55:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d5b:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107d5e:	0f b6 c0             	movzbl %al,%eax
80107d61:	51                   	push   %ecx
80107d62:	52                   	push   %edx
80107d63:	50                   	push   %eax
80107d64:	68 f4 9f 10 80       	push   $0x80109ff4
80107d69:	e8 58 86 ff ff       	call   801003c6 <cprintf>
80107d6e:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107d71:	e8 54 b3 ff ff       	call   801030ca <lapiceoi>
    break;
80107d76:	e9 b9 00 00 00       	jmp    80107e34 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107d7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d81:	85 c0                	test   %eax,%eax
80107d83:	74 11                	je     80107d96 <trap+0x122>
80107d85:	8b 45 08             	mov    0x8(%ebp),%eax
80107d88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107d8c:	0f b7 c0             	movzwl %ax,%eax
80107d8f:	83 e0 03             	and    $0x3,%eax
80107d92:	85 c0                	test   %eax,%eax
80107d94:	75 40                	jne    80107dd6 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107d96:	e8 4f fd ff ff       	call   80107aea <rcr2>
80107d9b:	89 c3                	mov    %eax,%ebx
80107d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80107da0:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107da3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107da9:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107dac:	0f b6 d0             	movzbl %al,%edx
80107daf:	8b 45 08             	mov    0x8(%ebp),%eax
80107db2:	8b 40 30             	mov    0x30(%eax),%eax
80107db5:	83 ec 0c             	sub    $0xc,%esp
80107db8:	53                   	push   %ebx
80107db9:	51                   	push   %ecx
80107dba:	52                   	push   %edx
80107dbb:	50                   	push   %eax
80107dbc:	68 18 a0 10 80       	push   $0x8010a018
80107dc1:	e8 00 86 ff ff       	call   801003c6 <cprintf>
80107dc6:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107dc9:	83 ec 0c             	sub    $0xc,%esp
80107dcc:	68 4a a0 10 80       	push   $0x8010a04a
80107dd1:	e8 90 87 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107dd6:	e8 0f fd ff ff       	call   80107aea <rcr2>
80107ddb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107dde:	8b 45 08             	mov    0x8(%ebp),%eax
80107de1:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107de4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dea:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107ded:	0f b6 d8             	movzbl %al,%ebx
80107df0:	8b 45 08             	mov    0x8(%ebp),%eax
80107df3:	8b 48 34             	mov    0x34(%eax),%ecx
80107df6:	8b 45 08             	mov    0x8(%ebp),%eax
80107df9:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107dfc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e02:	8d 78 6c             	lea    0x6c(%eax),%edi
80107e05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e0b:	8b 40 10             	mov    0x10(%eax),%eax
80107e0e:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e11:	56                   	push   %esi
80107e12:	53                   	push   %ebx
80107e13:	51                   	push   %ecx
80107e14:	52                   	push   %edx
80107e15:	57                   	push   %edi
80107e16:	50                   	push   %eax
80107e17:	68 50 a0 10 80       	push   $0x8010a050
80107e1c:	e8 a5 85 ff ff       	call   801003c6 <cprintf>
80107e21:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107e24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e2a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107e31:	eb 01                	jmp    80107e34 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107e33:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107e34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e3a:	85 c0                	test   %eax,%eax
80107e3c:	74 24                	je     80107e62 <trap+0x1ee>
80107e3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e44:	8b 40 24             	mov    0x24(%eax),%eax
80107e47:	85 c0                	test   %eax,%eax
80107e49:	74 17                	je     80107e62 <trap+0x1ee>
80107e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e4e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107e52:	0f b7 c0             	movzwl %ax,%eax
80107e55:	83 e0 03             	and    $0x3,%eax
80107e58:	83 f8 03             	cmp    $0x3,%eax
80107e5b:	75 05                	jne    80107e62 <trap+0x1ee>
    exit();
80107e5d:	e8 d4 cd ff ff       	call   80104c36 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107e62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e68:	85 c0                	test   %eax,%eax
80107e6a:	74 41                	je     80107ead <trap+0x239>
80107e6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e72:	8b 40 0c             	mov    0xc(%eax),%eax
80107e75:	83 f8 04             	cmp    $0x4,%eax
80107e78:	75 33                	jne    80107ead <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80107e7d:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107e80:	83 f8 20             	cmp    $0x20,%eax
80107e83:	75 28                	jne    80107ead <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107e85:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
80107e8b:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107e90:	89 c8                	mov    %ecx,%eax
80107e92:	f7 e2                	mul    %edx
80107e94:	c1 ea 03             	shr    $0x3,%edx
80107e97:	89 d0                	mov    %edx,%eax
80107e99:	c1 e0 02             	shl    $0x2,%eax
80107e9c:	01 d0                	add    %edx,%eax
80107e9e:	01 c0                	add    %eax,%eax
80107ea0:	29 c1                	sub    %eax,%ecx
80107ea2:	89 ca                	mov    %ecx,%edx
80107ea4:	85 d2                	test   %edx,%edx
80107ea6:	75 05                	jne    80107ead <trap+0x239>
    yield();
80107ea8:	e8 9e d3 ff ff       	call   8010524b <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107ead:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eb3:	85 c0                	test   %eax,%eax
80107eb5:	74 27                	je     80107ede <trap+0x26a>
80107eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ebd:	8b 40 24             	mov    0x24(%eax),%eax
80107ec0:	85 c0                	test   %eax,%eax
80107ec2:	74 1a                	je     80107ede <trap+0x26a>
80107ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ec7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107ecb:	0f b7 c0             	movzwl %ax,%eax
80107ece:	83 e0 03             	and    $0x3,%eax
80107ed1:	83 f8 03             	cmp    $0x3,%eax
80107ed4:	75 08                	jne    80107ede <trap+0x26a>
    exit();
80107ed6:	e8 5b cd ff ff       	call   80104c36 <exit>
80107edb:	eb 01                	jmp    80107ede <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107edd:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ee1:	5b                   	pop    %ebx
80107ee2:	5e                   	pop    %esi
80107ee3:	5f                   	pop    %edi
80107ee4:	5d                   	pop    %ebp
80107ee5:	c3                   	ret    

80107ee6 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107ee6:	55                   	push   %ebp
80107ee7:	89 e5                	mov    %esp,%ebp
80107ee9:	83 ec 14             	sub    $0x14,%esp
80107eec:	8b 45 08             	mov    0x8(%ebp),%eax
80107eef:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107ef3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107ef7:	89 c2                	mov    %eax,%edx
80107ef9:	ec                   	in     (%dx),%al
80107efa:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107efd:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107f01:	c9                   	leave  
80107f02:	c3                   	ret    

80107f03 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107f03:	55                   	push   %ebp
80107f04:	89 e5                	mov    %esp,%ebp
80107f06:	83 ec 08             	sub    $0x8,%esp
80107f09:	8b 55 08             	mov    0x8(%ebp),%edx
80107f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f0f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107f13:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107f16:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107f1a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107f1e:	ee                   	out    %al,(%dx)
}
80107f1f:	90                   	nop
80107f20:	c9                   	leave  
80107f21:	c3                   	ret    

80107f22 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107f22:	55                   	push   %ebp
80107f23:	89 e5                	mov    %esp,%ebp
80107f25:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107f28:	6a 00                	push   $0x0
80107f2a:	68 fa 03 00 00       	push   $0x3fa
80107f2f:	e8 cf ff ff ff       	call   80107f03 <outb>
80107f34:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107f37:	68 80 00 00 00       	push   $0x80
80107f3c:	68 fb 03 00 00       	push   $0x3fb
80107f41:	e8 bd ff ff ff       	call   80107f03 <outb>
80107f46:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107f49:	6a 0c                	push   $0xc
80107f4b:	68 f8 03 00 00       	push   $0x3f8
80107f50:	e8 ae ff ff ff       	call   80107f03 <outb>
80107f55:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107f58:	6a 00                	push   $0x0
80107f5a:	68 f9 03 00 00       	push   $0x3f9
80107f5f:	e8 9f ff ff ff       	call   80107f03 <outb>
80107f64:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107f67:	6a 03                	push   $0x3
80107f69:	68 fb 03 00 00       	push   $0x3fb
80107f6e:	e8 90 ff ff ff       	call   80107f03 <outb>
80107f73:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107f76:	6a 00                	push   $0x0
80107f78:	68 fc 03 00 00       	push   $0x3fc
80107f7d:	e8 81 ff ff ff       	call   80107f03 <outb>
80107f82:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107f85:	6a 01                	push   $0x1
80107f87:	68 f9 03 00 00       	push   $0x3f9
80107f8c:	e8 72 ff ff ff       	call   80107f03 <outb>
80107f91:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107f94:	68 fd 03 00 00       	push   $0x3fd
80107f99:	e8 48 ff ff ff       	call   80107ee6 <inb>
80107f9e:	83 c4 04             	add    $0x4,%esp
80107fa1:	3c ff                	cmp    $0xff,%al
80107fa3:	74 6e                	je     80108013 <uartinit+0xf1>
    return;
  uart = 1;
80107fa5:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80107fac:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107faf:	68 fa 03 00 00       	push   $0x3fa
80107fb4:	e8 2d ff ff ff       	call   80107ee6 <inb>
80107fb9:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107fbc:	68 f8 03 00 00       	push   $0x3f8
80107fc1:	e8 20 ff ff ff       	call   80107ee6 <inb>
80107fc6:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107fc9:	83 ec 0c             	sub    $0xc,%esp
80107fcc:	6a 04                	push   $0x4
80107fce:	e8 fd bf ff ff       	call   80103fd0 <picenable>
80107fd3:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107fd6:	83 ec 08             	sub    $0x8,%esp
80107fd9:	6a 00                	push   $0x0
80107fdb:	6a 04                	push   $0x4
80107fdd:	e8 9d ab ff ff       	call   80102b7f <ioapicenable>
80107fe2:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107fe5:	c7 45 f4 14 a1 10 80 	movl   $0x8010a114,-0xc(%ebp)
80107fec:	eb 19                	jmp    80108007 <uartinit+0xe5>
    uartputc(*p);
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	0f b6 00             	movzbl (%eax),%eax
80107ff4:	0f be c0             	movsbl %al,%eax
80107ff7:	83 ec 0c             	sub    $0xc,%esp
80107ffa:	50                   	push   %eax
80107ffb:	e8 16 00 00 00       	call   80108016 <uartputc>
80108000:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108003:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108007:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800a:	0f b6 00             	movzbl (%eax),%eax
8010800d:	84 c0                	test   %al,%al
8010800f:	75 dd                	jne    80107fee <uartinit+0xcc>
80108011:	eb 01                	jmp    80108014 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108013:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108014:	c9                   	leave  
80108015:	c3                   	ret    

80108016 <uartputc>:

void
uartputc(int c)
{
80108016:	55                   	push   %ebp
80108017:	89 e5                	mov    %esp,%ebp
80108019:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010801c:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108021:	85 c0                	test   %eax,%eax
80108023:	74 53                	je     80108078 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010802c:	eb 11                	jmp    8010803f <uartputc+0x29>
    microdelay(10);
8010802e:	83 ec 0c             	sub    $0xc,%esp
80108031:	6a 0a                	push   $0xa
80108033:	e8 ad b0 ff ff       	call   801030e5 <microdelay>
80108038:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010803b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010803f:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108043:	7f 1a                	jg     8010805f <uartputc+0x49>
80108045:	83 ec 0c             	sub    $0xc,%esp
80108048:	68 fd 03 00 00       	push   $0x3fd
8010804d:	e8 94 fe ff ff       	call   80107ee6 <inb>
80108052:	83 c4 10             	add    $0x10,%esp
80108055:	0f b6 c0             	movzbl %al,%eax
80108058:	83 e0 20             	and    $0x20,%eax
8010805b:	85 c0                	test   %eax,%eax
8010805d:	74 cf                	je     8010802e <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010805f:	8b 45 08             	mov    0x8(%ebp),%eax
80108062:	0f b6 c0             	movzbl %al,%eax
80108065:	83 ec 08             	sub    $0x8,%esp
80108068:	50                   	push   %eax
80108069:	68 f8 03 00 00       	push   $0x3f8
8010806e:	e8 90 fe ff ff       	call   80107f03 <outb>
80108073:	83 c4 10             	add    $0x10,%esp
80108076:	eb 01                	jmp    80108079 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108078:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108079:	c9                   	leave  
8010807a:	c3                   	ret    

8010807b <uartgetc>:

static int
uartgetc(void)
{
8010807b:	55                   	push   %ebp
8010807c:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010807e:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108083:	85 c0                	test   %eax,%eax
80108085:	75 07                	jne    8010808e <uartgetc+0x13>
    return -1;
80108087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010808c:	eb 2e                	jmp    801080bc <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010808e:	68 fd 03 00 00       	push   $0x3fd
80108093:	e8 4e fe ff ff       	call   80107ee6 <inb>
80108098:	83 c4 04             	add    $0x4,%esp
8010809b:	0f b6 c0             	movzbl %al,%eax
8010809e:	83 e0 01             	and    $0x1,%eax
801080a1:	85 c0                	test   %eax,%eax
801080a3:	75 07                	jne    801080ac <uartgetc+0x31>
    return -1;
801080a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080aa:	eb 10                	jmp    801080bc <uartgetc+0x41>
  return inb(COM1+0);
801080ac:	68 f8 03 00 00       	push   $0x3f8
801080b1:	e8 30 fe ff ff       	call   80107ee6 <inb>
801080b6:	83 c4 04             	add    $0x4,%esp
801080b9:	0f b6 c0             	movzbl %al,%eax
}
801080bc:	c9                   	leave  
801080bd:	c3                   	ret    

801080be <uartintr>:

void
uartintr(void)
{
801080be:	55                   	push   %ebp
801080bf:	89 e5                	mov    %esp,%ebp
801080c1:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801080c4:	83 ec 0c             	sub    $0xc,%esp
801080c7:	68 7b 80 10 80       	push   $0x8010807b
801080cc:	e8 28 87 ff ff       	call   801007f9 <consoleintr>
801080d1:	83 c4 10             	add    $0x10,%esp
}
801080d4:	90                   	nop
801080d5:	c9                   	leave  
801080d6:	c3                   	ret    

801080d7 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801080d7:	6a 00                	push   $0x0
  pushl $0
801080d9:	6a 00                	push   $0x0
  jmp alltraps
801080db:	e9 a9 f9 ff ff       	jmp    80107a89 <alltraps>

801080e0 <vector1>:
.globl vector1
vector1:
  pushl $0
801080e0:	6a 00                	push   $0x0
  pushl $1
801080e2:	6a 01                	push   $0x1
  jmp alltraps
801080e4:	e9 a0 f9 ff ff       	jmp    80107a89 <alltraps>

801080e9 <vector2>:
.globl vector2
vector2:
  pushl $0
801080e9:	6a 00                	push   $0x0
  pushl $2
801080eb:	6a 02                	push   $0x2
  jmp alltraps
801080ed:	e9 97 f9 ff ff       	jmp    80107a89 <alltraps>

801080f2 <vector3>:
.globl vector3
vector3:
  pushl $0
801080f2:	6a 00                	push   $0x0
  pushl $3
801080f4:	6a 03                	push   $0x3
  jmp alltraps
801080f6:	e9 8e f9 ff ff       	jmp    80107a89 <alltraps>

801080fb <vector4>:
.globl vector4
vector4:
  pushl $0
801080fb:	6a 00                	push   $0x0
  pushl $4
801080fd:	6a 04                	push   $0x4
  jmp alltraps
801080ff:	e9 85 f9 ff ff       	jmp    80107a89 <alltraps>

80108104 <vector5>:
.globl vector5
vector5:
  pushl $0
80108104:	6a 00                	push   $0x0
  pushl $5
80108106:	6a 05                	push   $0x5
  jmp alltraps
80108108:	e9 7c f9 ff ff       	jmp    80107a89 <alltraps>

8010810d <vector6>:
.globl vector6
vector6:
  pushl $0
8010810d:	6a 00                	push   $0x0
  pushl $6
8010810f:	6a 06                	push   $0x6
  jmp alltraps
80108111:	e9 73 f9 ff ff       	jmp    80107a89 <alltraps>

80108116 <vector7>:
.globl vector7
vector7:
  pushl $0
80108116:	6a 00                	push   $0x0
  pushl $7
80108118:	6a 07                	push   $0x7
  jmp alltraps
8010811a:	e9 6a f9 ff ff       	jmp    80107a89 <alltraps>

8010811f <vector8>:
.globl vector8
vector8:
  pushl $8
8010811f:	6a 08                	push   $0x8
  jmp alltraps
80108121:	e9 63 f9 ff ff       	jmp    80107a89 <alltraps>

80108126 <vector9>:
.globl vector9
vector9:
  pushl $0
80108126:	6a 00                	push   $0x0
  pushl $9
80108128:	6a 09                	push   $0x9
  jmp alltraps
8010812a:	e9 5a f9 ff ff       	jmp    80107a89 <alltraps>

8010812f <vector10>:
.globl vector10
vector10:
  pushl $10
8010812f:	6a 0a                	push   $0xa
  jmp alltraps
80108131:	e9 53 f9 ff ff       	jmp    80107a89 <alltraps>

80108136 <vector11>:
.globl vector11
vector11:
  pushl $11
80108136:	6a 0b                	push   $0xb
  jmp alltraps
80108138:	e9 4c f9 ff ff       	jmp    80107a89 <alltraps>

8010813d <vector12>:
.globl vector12
vector12:
  pushl $12
8010813d:	6a 0c                	push   $0xc
  jmp alltraps
8010813f:	e9 45 f9 ff ff       	jmp    80107a89 <alltraps>

80108144 <vector13>:
.globl vector13
vector13:
  pushl $13
80108144:	6a 0d                	push   $0xd
  jmp alltraps
80108146:	e9 3e f9 ff ff       	jmp    80107a89 <alltraps>

8010814b <vector14>:
.globl vector14
vector14:
  pushl $14
8010814b:	6a 0e                	push   $0xe
  jmp alltraps
8010814d:	e9 37 f9 ff ff       	jmp    80107a89 <alltraps>

80108152 <vector15>:
.globl vector15
vector15:
  pushl $0
80108152:	6a 00                	push   $0x0
  pushl $15
80108154:	6a 0f                	push   $0xf
  jmp alltraps
80108156:	e9 2e f9 ff ff       	jmp    80107a89 <alltraps>

8010815b <vector16>:
.globl vector16
vector16:
  pushl $0
8010815b:	6a 00                	push   $0x0
  pushl $16
8010815d:	6a 10                	push   $0x10
  jmp alltraps
8010815f:	e9 25 f9 ff ff       	jmp    80107a89 <alltraps>

80108164 <vector17>:
.globl vector17
vector17:
  pushl $17
80108164:	6a 11                	push   $0x11
  jmp alltraps
80108166:	e9 1e f9 ff ff       	jmp    80107a89 <alltraps>

8010816b <vector18>:
.globl vector18
vector18:
  pushl $0
8010816b:	6a 00                	push   $0x0
  pushl $18
8010816d:	6a 12                	push   $0x12
  jmp alltraps
8010816f:	e9 15 f9 ff ff       	jmp    80107a89 <alltraps>

80108174 <vector19>:
.globl vector19
vector19:
  pushl $0
80108174:	6a 00                	push   $0x0
  pushl $19
80108176:	6a 13                	push   $0x13
  jmp alltraps
80108178:	e9 0c f9 ff ff       	jmp    80107a89 <alltraps>

8010817d <vector20>:
.globl vector20
vector20:
  pushl $0
8010817d:	6a 00                	push   $0x0
  pushl $20
8010817f:	6a 14                	push   $0x14
  jmp alltraps
80108181:	e9 03 f9 ff ff       	jmp    80107a89 <alltraps>

80108186 <vector21>:
.globl vector21
vector21:
  pushl $0
80108186:	6a 00                	push   $0x0
  pushl $21
80108188:	6a 15                	push   $0x15
  jmp alltraps
8010818a:	e9 fa f8 ff ff       	jmp    80107a89 <alltraps>

8010818f <vector22>:
.globl vector22
vector22:
  pushl $0
8010818f:	6a 00                	push   $0x0
  pushl $22
80108191:	6a 16                	push   $0x16
  jmp alltraps
80108193:	e9 f1 f8 ff ff       	jmp    80107a89 <alltraps>

80108198 <vector23>:
.globl vector23
vector23:
  pushl $0
80108198:	6a 00                	push   $0x0
  pushl $23
8010819a:	6a 17                	push   $0x17
  jmp alltraps
8010819c:	e9 e8 f8 ff ff       	jmp    80107a89 <alltraps>

801081a1 <vector24>:
.globl vector24
vector24:
  pushl $0
801081a1:	6a 00                	push   $0x0
  pushl $24
801081a3:	6a 18                	push   $0x18
  jmp alltraps
801081a5:	e9 df f8 ff ff       	jmp    80107a89 <alltraps>

801081aa <vector25>:
.globl vector25
vector25:
  pushl $0
801081aa:	6a 00                	push   $0x0
  pushl $25
801081ac:	6a 19                	push   $0x19
  jmp alltraps
801081ae:	e9 d6 f8 ff ff       	jmp    80107a89 <alltraps>

801081b3 <vector26>:
.globl vector26
vector26:
  pushl $0
801081b3:	6a 00                	push   $0x0
  pushl $26
801081b5:	6a 1a                	push   $0x1a
  jmp alltraps
801081b7:	e9 cd f8 ff ff       	jmp    80107a89 <alltraps>

801081bc <vector27>:
.globl vector27
vector27:
  pushl $0
801081bc:	6a 00                	push   $0x0
  pushl $27
801081be:	6a 1b                	push   $0x1b
  jmp alltraps
801081c0:	e9 c4 f8 ff ff       	jmp    80107a89 <alltraps>

801081c5 <vector28>:
.globl vector28
vector28:
  pushl $0
801081c5:	6a 00                	push   $0x0
  pushl $28
801081c7:	6a 1c                	push   $0x1c
  jmp alltraps
801081c9:	e9 bb f8 ff ff       	jmp    80107a89 <alltraps>

801081ce <vector29>:
.globl vector29
vector29:
  pushl $0
801081ce:	6a 00                	push   $0x0
  pushl $29
801081d0:	6a 1d                	push   $0x1d
  jmp alltraps
801081d2:	e9 b2 f8 ff ff       	jmp    80107a89 <alltraps>

801081d7 <vector30>:
.globl vector30
vector30:
  pushl $0
801081d7:	6a 00                	push   $0x0
  pushl $30
801081d9:	6a 1e                	push   $0x1e
  jmp alltraps
801081db:	e9 a9 f8 ff ff       	jmp    80107a89 <alltraps>

801081e0 <vector31>:
.globl vector31
vector31:
  pushl $0
801081e0:	6a 00                	push   $0x0
  pushl $31
801081e2:	6a 1f                	push   $0x1f
  jmp alltraps
801081e4:	e9 a0 f8 ff ff       	jmp    80107a89 <alltraps>

801081e9 <vector32>:
.globl vector32
vector32:
  pushl $0
801081e9:	6a 00                	push   $0x0
  pushl $32
801081eb:	6a 20                	push   $0x20
  jmp alltraps
801081ed:	e9 97 f8 ff ff       	jmp    80107a89 <alltraps>

801081f2 <vector33>:
.globl vector33
vector33:
  pushl $0
801081f2:	6a 00                	push   $0x0
  pushl $33
801081f4:	6a 21                	push   $0x21
  jmp alltraps
801081f6:	e9 8e f8 ff ff       	jmp    80107a89 <alltraps>

801081fb <vector34>:
.globl vector34
vector34:
  pushl $0
801081fb:	6a 00                	push   $0x0
  pushl $34
801081fd:	6a 22                	push   $0x22
  jmp alltraps
801081ff:	e9 85 f8 ff ff       	jmp    80107a89 <alltraps>

80108204 <vector35>:
.globl vector35
vector35:
  pushl $0
80108204:	6a 00                	push   $0x0
  pushl $35
80108206:	6a 23                	push   $0x23
  jmp alltraps
80108208:	e9 7c f8 ff ff       	jmp    80107a89 <alltraps>

8010820d <vector36>:
.globl vector36
vector36:
  pushl $0
8010820d:	6a 00                	push   $0x0
  pushl $36
8010820f:	6a 24                	push   $0x24
  jmp alltraps
80108211:	e9 73 f8 ff ff       	jmp    80107a89 <alltraps>

80108216 <vector37>:
.globl vector37
vector37:
  pushl $0
80108216:	6a 00                	push   $0x0
  pushl $37
80108218:	6a 25                	push   $0x25
  jmp alltraps
8010821a:	e9 6a f8 ff ff       	jmp    80107a89 <alltraps>

8010821f <vector38>:
.globl vector38
vector38:
  pushl $0
8010821f:	6a 00                	push   $0x0
  pushl $38
80108221:	6a 26                	push   $0x26
  jmp alltraps
80108223:	e9 61 f8 ff ff       	jmp    80107a89 <alltraps>

80108228 <vector39>:
.globl vector39
vector39:
  pushl $0
80108228:	6a 00                	push   $0x0
  pushl $39
8010822a:	6a 27                	push   $0x27
  jmp alltraps
8010822c:	e9 58 f8 ff ff       	jmp    80107a89 <alltraps>

80108231 <vector40>:
.globl vector40
vector40:
  pushl $0
80108231:	6a 00                	push   $0x0
  pushl $40
80108233:	6a 28                	push   $0x28
  jmp alltraps
80108235:	e9 4f f8 ff ff       	jmp    80107a89 <alltraps>

8010823a <vector41>:
.globl vector41
vector41:
  pushl $0
8010823a:	6a 00                	push   $0x0
  pushl $41
8010823c:	6a 29                	push   $0x29
  jmp alltraps
8010823e:	e9 46 f8 ff ff       	jmp    80107a89 <alltraps>

80108243 <vector42>:
.globl vector42
vector42:
  pushl $0
80108243:	6a 00                	push   $0x0
  pushl $42
80108245:	6a 2a                	push   $0x2a
  jmp alltraps
80108247:	e9 3d f8 ff ff       	jmp    80107a89 <alltraps>

8010824c <vector43>:
.globl vector43
vector43:
  pushl $0
8010824c:	6a 00                	push   $0x0
  pushl $43
8010824e:	6a 2b                	push   $0x2b
  jmp alltraps
80108250:	e9 34 f8 ff ff       	jmp    80107a89 <alltraps>

80108255 <vector44>:
.globl vector44
vector44:
  pushl $0
80108255:	6a 00                	push   $0x0
  pushl $44
80108257:	6a 2c                	push   $0x2c
  jmp alltraps
80108259:	e9 2b f8 ff ff       	jmp    80107a89 <alltraps>

8010825e <vector45>:
.globl vector45
vector45:
  pushl $0
8010825e:	6a 00                	push   $0x0
  pushl $45
80108260:	6a 2d                	push   $0x2d
  jmp alltraps
80108262:	e9 22 f8 ff ff       	jmp    80107a89 <alltraps>

80108267 <vector46>:
.globl vector46
vector46:
  pushl $0
80108267:	6a 00                	push   $0x0
  pushl $46
80108269:	6a 2e                	push   $0x2e
  jmp alltraps
8010826b:	e9 19 f8 ff ff       	jmp    80107a89 <alltraps>

80108270 <vector47>:
.globl vector47
vector47:
  pushl $0
80108270:	6a 00                	push   $0x0
  pushl $47
80108272:	6a 2f                	push   $0x2f
  jmp alltraps
80108274:	e9 10 f8 ff ff       	jmp    80107a89 <alltraps>

80108279 <vector48>:
.globl vector48
vector48:
  pushl $0
80108279:	6a 00                	push   $0x0
  pushl $48
8010827b:	6a 30                	push   $0x30
  jmp alltraps
8010827d:	e9 07 f8 ff ff       	jmp    80107a89 <alltraps>

80108282 <vector49>:
.globl vector49
vector49:
  pushl $0
80108282:	6a 00                	push   $0x0
  pushl $49
80108284:	6a 31                	push   $0x31
  jmp alltraps
80108286:	e9 fe f7 ff ff       	jmp    80107a89 <alltraps>

8010828b <vector50>:
.globl vector50
vector50:
  pushl $0
8010828b:	6a 00                	push   $0x0
  pushl $50
8010828d:	6a 32                	push   $0x32
  jmp alltraps
8010828f:	e9 f5 f7 ff ff       	jmp    80107a89 <alltraps>

80108294 <vector51>:
.globl vector51
vector51:
  pushl $0
80108294:	6a 00                	push   $0x0
  pushl $51
80108296:	6a 33                	push   $0x33
  jmp alltraps
80108298:	e9 ec f7 ff ff       	jmp    80107a89 <alltraps>

8010829d <vector52>:
.globl vector52
vector52:
  pushl $0
8010829d:	6a 00                	push   $0x0
  pushl $52
8010829f:	6a 34                	push   $0x34
  jmp alltraps
801082a1:	e9 e3 f7 ff ff       	jmp    80107a89 <alltraps>

801082a6 <vector53>:
.globl vector53
vector53:
  pushl $0
801082a6:	6a 00                	push   $0x0
  pushl $53
801082a8:	6a 35                	push   $0x35
  jmp alltraps
801082aa:	e9 da f7 ff ff       	jmp    80107a89 <alltraps>

801082af <vector54>:
.globl vector54
vector54:
  pushl $0
801082af:	6a 00                	push   $0x0
  pushl $54
801082b1:	6a 36                	push   $0x36
  jmp alltraps
801082b3:	e9 d1 f7 ff ff       	jmp    80107a89 <alltraps>

801082b8 <vector55>:
.globl vector55
vector55:
  pushl $0
801082b8:	6a 00                	push   $0x0
  pushl $55
801082ba:	6a 37                	push   $0x37
  jmp alltraps
801082bc:	e9 c8 f7 ff ff       	jmp    80107a89 <alltraps>

801082c1 <vector56>:
.globl vector56
vector56:
  pushl $0
801082c1:	6a 00                	push   $0x0
  pushl $56
801082c3:	6a 38                	push   $0x38
  jmp alltraps
801082c5:	e9 bf f7 ff ff       	jmp    80107a89 <alltraps>

801082ca <vector57>:
.globl vector57
vector57:
  pushl $0
801082ca:	6a 00                	push   $0x0
  pushl $57
801082cc:	6a 39                	push   $0x39
  jmp alltraps
801082ce:	e9 b6 f7 ff ff       	jmp    80107a89 <alltraps>

801082d3 <vector58>:
.globl vector58
vector58:
  pushl $0
801082d3:	6a 00                	push   $0x0
  pushl $58
801082d5:	6a 3a                	push   $0x3a
  jmp alltraps
801082d7:	e9 ad f7 ff ff       	jmp    80107a89 <alltraps>

801082dc <vector59>:
.globl vector59
vector59:
  pushl $0
801082dc:	6a 00                	push   $0x0
  pushl $59
801082de:	6a 3b                	push   $0x3b
  jmp alltraps
801082e0:	e9 a4 f7 ff ff       	jmp    80107a89 <alltraps>

801082e5 <vector60>:
.globl vector60
vector60:
  pushl $0
801082e5:	6a 00                	push   $0x0
  pushl $60
801082e7:	6a 3c                	push   $0x3c
  jmp alltraps
801082e9:	e9 9b f7 ff ff       	jmp    80107a89 <alltraps>

801082ee <vector61>:
.globl vector61
vector61:
  pushl $0
801082ee:	6a 00                	push   $0x0
  pushl $61
801082f0:	6a 3d                	push   $0x3d
  jmp alltraps
801082f2:	e9 92 f7 ff ff       	jmp    80107a89 <alltraps>

801082f7 <vector62>:
.globl vector62
vector62:
  pushl $0
801082f7:	6a 00                	push   $0x0
  pushl $62
801082f9:	6a 3e                	push   $0x3e
  jmp alltraps
801082fb:	e9 89 f7 ff ff       	jmp    80107a89 <alltraps>

80108300 <vector63>:
.globl vector63
vector63:
  pushl $0
80108300:	6a 00                	push   $0x0
  pushl $63
80108302:	6a 3f                	push   $0x3f
  jmp alltraps
80108304:	e9 80 f7 ff ff       	jmp    80107a89 <alltraps>

80108309 <vector64>:
.globl vector64
vector64:
  pushl $0
80108309:	6a 00                	push   $0x0
  pushl $64
8010830b:	6a 40                	push   $0x40
  jmp alltraps
8010830d:	e9 77 f7 ff ff       	jmp    80107a89 <alltraps>

80108312 <vector65>:
.globl vector65
vector65:
  pushl $0
80108312:	6a 00                	push   $0x0
  pushl $65
80108314:	6a 41                	push   $0x41
  jmp alltraps
80108316:	e9 6e f7 ff ff       	jmp    80107a89 <alltraps>

8010831b <vector66>:
.globl vector66
vector66:
  pushl $0
8010831b:	6a 00                	push   $0x0
  pushl $66
8010831d:	6a 42                	push   $0x42
  jmp alltraps
8010831f:	e9 65 f7 ff ff       	jmp    80107a89 <alltraps>

80108324 <vector67>:
.globl vector67
vector67:
  pushl $0
80108324:	6a 00                	push   $0x0
  pushl $67
80108326:	6a 43                	push   $0x43
  jmp alltraps
80108328:	e9 5c f7 ff ff       	jmp    80107a89 <alltraps>

8010832d <vector68>:
.globl vector68
vector68:
  pushl $0
8010832d:	6a 00                	push   $0x0
  pushl $68
8010832f:	6a 44                	push   $0x44
  jmp alltraps
80108331:	e9 53 f7 ff ff       	jmp    80107a89 <alltraps>

80108336 <vector69>:
.globl vector69
vector69:
  pushl $0
80108336:	6a 00                	push   $0x0
  pushl $69
80108338:	6a 45                	push   $0x45
  jmp alltraps
8010833a:	e9 4a f7 ff ff       	jmp    80107a89 <alltraps>

8010833f <vector70>:
.globl vector70
vector70:
  pushl $0
8010833f:	6a 00                	push   $0x0
  pushl $70
80108341:	6a 46                	push   $0x46
  jmp alltraps
80108343:	e9 41 f7 ff ff       	jmp    80107a89 <alltraps>

80108348 <vector71>:
.globl vector71
vector71:
  pushl $0
80108348:	6a 00                	push   $0x0
  pushl $71
8010834a:	6a 47                	push   $0x47
  jmp alltraps
8010834c:	e9 38 f7 ff ff       	jmp    80107a89 <alltraps>

80108351 <vector72>:
.globl vector72
vector72:
  pushl $0
80108351:	6a 00                	push   $0x0
  pushl $72
80108353:	6a 48                	push   $0x48
  jmp alltraps
80108355:	e9 2f f7 ff ff       	jmp    80107a89 <alltraps>

8010835a <vector73>:
.globl vector73
vector73:
  pushl $0
8010835a:	6a 00                	push   $0x0
  pushl $73
8010835c:	6a 49                	push   $0x49
  jmp alltraps
8010835e:	e9 26 f7 ff ff       	jmp    80107a89 <alltraps>

80108363 <vector74>:
.globl vector74
vector74:
  pushl $0
80108363:	6a 00                	push   $0x0
  pushl $74
80108365:	6a 4a                	push   $0x4a
  jmp alltraps
80108367:	e9 1d f7 ff ff       	jmp    80107a89 <alltraps>

8010836c <vector75>:
.globl vector75
vector75:
  pushl $0
8010836c:	6a 00                	push   $0x0
  pushl $75
8010836e:	6a 4b                	push   $0x4b
  jmp alltraps
80108370:	e9 14 f7 ff ff       	jmp    80107a89 <alltraps>

80108375 <vector76>:
.globl vector76
vector76:
  pushl $0
80108375:	6a 00                	push   $0x0
  pushl $76
80108377:	6a 4c                	push   $0x4c
  jmp alltraps
80108379:	e9 0b f7 ff ff       	jmp    80107a89 <alltraps>

8010837e <vector77>:
.globl vector77
vector77:
  pushl $0
8010837e:	6a 00                	push   $0x0
  pushl $77
80108380:	6a 4d                	push   $0x4d
  jmp alltraps
80108382:	e9 02 f7 ff ff       	jmp    80107a89 <alltraps>

80108387 <vector78>:
.globl vector78
vector78:
  pushl $0
80108387:	6a 00                	push   $0x0
  pushl $78
80108389:	6a 4e                	push   $0x4e
  jmp alltraps
8010838b:	e9 f9 f6 ff ff       	jmp    80107a89 <alltraps>

80108390 <vector79>:
.globl vector79
vector79:
  pushl $0
80108390:	6a 00                	push   $0x0
  pushl $79
80108392:	6a 4f                	push   $0x4f
  jmp alltraps
80108394:	e9 f0 f6 ff ff       	jmp    80107a89 <alltraps>

80108399 <vector80>:
.globl vector80
vector80:
  pushl $0
80108399:	6a 00                	push   $0x0
  pushl $80
8010839b:	6a 50                	push   $0x50
  jmp alltraps
8010839d:	e9 e7 f6 ff ff       	jmp    80107a89 <alltraps>

801083a2 <vector81>:
.globl vector81
vector81:
  pushl $0
801083a2:	6a 00                	push   $0x0
  pushl $81
801083a4:	6a 51                	push   $0x51
  jmp alltraps
801083a6:	e9 de f6 ff ff       	jmp    80107a89 <alltraps>

801083ab <vector82>:
.globl vector82
vector82:
  pushl $0
801083ab:	6a 00                	push   $0x0
  pushl $82
801083ad:	6a 52                	push   $0x52
  jmp alltraps
801083af:	e9 d5 f6 ff ff       	jmp    80107a89 <alltraps>

801083b4 <vector83>:
.globl vector83
vector83:
  pushl $0
801083b4:	6a 00                	push   $0x0
  pushl $83
801083b6:	6a 53                	push   $0x53
  jmp alltraps
801083b8:	e9 cc f6 ff ff       	jmp    80107a89 <alltraps>

801083bd <vector84>:
.globl vector84
vector84:
  pushl $0
801083bd:	6a 00                	push   $0x0
  pushl $84
801083bf:	6a 54                	push   $0x54
  jmp alltraps
801083c1:	e9 c3 f6 ff ff       	jmp    80107a89 <alltraps>

801083c6 <vector85>:
.globl vector85
vector85:
  pushl $0
801083c6:	6a 00                	push   $0x0
  pushl $85
801083c8:	6a 55                	push   $0x55
  jmp alltraps
801083ca:	e9 ba f6 ff ff       	jmp    80107a89 <alltraps>

801083cf <vector86>:
.globl vector86
vector86:
  pushl $0
801083cf:	6a 00                	push   $0x0
  pushl $86
801083d1:	6a 56                	push   $0x56
  jmp alltraps
801083d3:	e9 b1 f6 ff ff       	jmp    80107a89 <alltraps>

801083d8 <vector87>:
.globl vector87
vector87:
  pushl $0
801083d8:	6a 00                	push   $0x0
  pushl $87
801083da:	6a 57                	push   $0x57
  jmp alltraps
801083dc:	e9 a8 f6 ff ff       	jmp    80107a89 <alltraps>

801083e1 <vector88>:
.globl vector88
vector88:
  pushl $0
801083e1:	6a 00                	push   $0x0
  pushl $88
801083e3:	6a 58                	push   $0x58
  jmp alltraps
801083e5:	e9 9f f6 ff ff       	jmp    80107a89 <alltraps>

801083ea <vector89>:
.globl vector89
vector89:
  pushl $0
801083ea:	6a 00                	push   $0x0
  pushl $89
801083ec:	6a 59                	push   $0x59
  jmp alltraps
801083ee:	e9 96 f6 ff ff       	jmp    80107a89 <alltraps>

801083f3 <vector90>:
.globl vector90
vector90:
  pushl $0
801083f3:	6a 00                	push   $0x0
  pushl $90
801083f5:	6a 5a                	push   $0x5a
  jmp alltraps
801083f7:	e9 8d f6 ff ff       	jmp    80107a89 <alltraps>

801083fc <vector91>:
.globl vector91
vector91:
  pushl $0
801083fc:	6a 00                	push   $0x0
  pushl $91
801083fe:	6a 5b                	push   $0x5b
  jmp alltraps
80108400:	e9 84 f6 ff ff       	jmp    80107a89 <alltraps>

80108405 <vector92>:
.globl vector92
vector92:
  pushl $0
80108405:	6a 00                	push   $0x0
  pushl $92
80108407:	6a 5c                	push   $0x5c
  jmp alltraps
80108409:	e9 7b f6 ff ff       	jmp    80107a89 <alltraps>

8010840e <vector93>:
.globl vector93
vector93:
  pushl $0
8010840e:	6a 00                	push   $0x0
  pushl $93
80108410:	6a 5d                	push   $0x5d
  jmp alltraps
80108412:	e9 72 f6 ff ff       	jmp    80107a89 <alltraps>

80108417 <vector94>:
.globl vector94
vector94:
  pushl $0
80108417:	6a 00                	push   $0x0
  pushl $94
80108419:	6a 5e                	push   $0x5e
  jmp alltraps
8010841b:	e9 69 f6 ff ff       	jmp    80107a89 <alltraps>

80108420 <vector95>:
.globl vector95
vector95:
  pushl $0
80108420:	6a 00                	push   $0x0
  pushl $95
80108422:	6a 5f                	push   $0x5f
  jmp alltraps
80108424:	e9 60 f6 ff ff       	jmp    80107a89 <alltraps>

80108429 <vector96>:
.globl vector96
vector96:
  pushl $0
80108429:	6a 00                	push   $0x0
  pushl $96
8010842b:	6a 60                	push   $0x60
  jmp alltraps
8010842d:	e9 57 f6 ff ff       	jmp    80107a89 <alltraps>

80108432 <vector97>:
.globl vector97
vector97:
  pushl $0
80108432:	6a 00                	push   $0x0
  pushl $97
80108434:	6a 61                	push   $0x61
  jmp alltraps
80108436:	e9 4e f6 ff ff       	jmp    80107a89 <alltraps>

8010843b <vector98>:
.globl vector98
vector98:
  pushl $0
8010843b:	6a 00                	push   $0x0
  pushl $98
8010843d:	6a 62                	push   $0x62
  jmp alltraps
8010843f:	e9 45 f6 ff ff       	jmp    80107a89 <alltraps>

80108444 <vector99>:
.globl vector99
vector99:
  pushl $0
80108444:	6a 00                	push   $0x0
  pushl $99
80108446:	6a 63                	push   $0x63
  jmp alltraps
80108448:	e9 3c f6 ff ff       	jmp    80107a89 <alltraps>

8010844d <vector100>:
.globl vector100
vector100:
  pushl $0
8010844d:	6a 00                	push   $0x0
  pushl $100
8010844f:	6a 64                	push   $0x64
  jmp alltraps
80108451:	e9 33 f6 ff ff       	jmp    80107a89 <alltraps>

80108456 <vector101>:
.globl vector101
vector101:
  pushl $0
80108456:	6a 00                	push   $0x0
  pushl $101
80108458:	6a 65                	push   $0x65
  jmp alltraps
8010845a:	e9 2a f6 ff ff       	jmp    80107a89 <alltraps>

8010845f <vector102>:
.globl vector102
vector102:
  pushl $0
8010845f:	6a 00                	push   $0x0
  pushl $102
80108461:	6a 66                	push   $0x66
  jmp alltraps
80108463:	e9 21 f6 ff ff       	jmp    80107a89 <alltraps>

80108468 <vector103>:
.globl vector103
vector103:
  pushl $0
80108468:	6a 00                	push   $0x0
  pushl $103
8010846a:	6a 67                	push   $0x67
  jmp alltraps
8010846c:	e9 18 f6 ff ff       	jmp    80107a89 <alltraps>

80108471 <vector104>:
.globl vector104
vector104:
  pushl $0
80108471:	6a 00                	push   $0x0
  pushl $104
80108473:	6a 68                	push   $0x68
  jmp alltraps
80108475:	e9 0f f6 ff ff       	jmp    80107a89 <alltraps>

8010847a <vector105>:
.globl vector105
vector105:
  pushl $0
8010847a:	6a 00                	push   $0x0
  pushl $105
8010847c:	6a 69                	push   $0x69
  jmp alltraps
8010847e:	e9 06 f6 ff ff       	jmp    80107a89 <alltraps>

80108483 <vector106>:
.globl vector106
vector106:
  pushl $0
80108483:	6a 00                	push   $0x0
  pushl $106
80108485:	6a 6a                	push   $0x6a
  jmp alltraps
80108487:	e9 fd f5 ff ff       	jmp    80107a89 <alltraps>

8010848c <vector107>:
.globl vector107
vector107:
  pushl $0
8010848c:	6a 00                	push   $0x0
  pushl $107
8010848e:	6a 6b                	push   $0x6b
  jmp alltraps
80108490:	e9 f4 f5 ff ff       	jmp    80107a89 <alltraps>

80108495 <vector108>:
.globl vector108
vector108:
  pushl $0
80108495:	6a 00                	push   $0x0
  pushl $108
80108497:	6a 6c                	push   $0x6c
  jmp alltraps
80108499:	e9 eb f5 ff ff       	jmp    80107a89 <alltraps>

8010849e <vector109>:
.globl vector109
vector109:
  pushl $0
8010849e:	6a 00                	push   $0x0
  pushl $109
801084a0:	6a 6d                	push   $0x6d
  jmp alltraps
801084a2:	e9 e2 f5 ff ff       	jmp    80107a89 <alltraps>

801084a7 <vector110>:
.globl vector110
vector110:
  pushl $0
801084a7:	6a 00                	push   $0x0
  pushl $110
801084a9:	6a 6e                	push   $0x6e
  jmp alltraps
801084ab:	e9 d9 f5 ff ff       	jmp    80107a89 <alltraps>

801084b0 <vector111>:
.globl vector111
vector111:
  pushl $0
801084b0:	6a 00                	push   $0x0
  pushl $111
801084b2:	6a 6f                	push   $0x6f
  jmp alltraps
801084b4:	e9 d0 f5 ff ff       	jmp    80107a89 <alltraps>

801084b9 <vector112>:
.globl vector112
vector112:
  pushl $0
801084b9:	6a 00                	push   $0x0
  pushl $112
801084bb:	6a 70                	push   $0x70
  jmp alltraps
801084bd:	e9 c7 f5 ff ff       	jmp    80107a89 <alltraps>

801084c2 <vector113>:
.globl vector113
vector113:
  pushl $0
801084c2:	6a 00                	push   $0x0
  pushl $113
801084c4:	6a 71                	push   $0x71
  jmp alltraps
801084c6:	e9 be f5 ff ff       	jmp    80107a89 <alltraps>

801084cb <vector114>:
.globl vector114
vector114:
  pushl $0
801084cb:	6a 00                	push   $0x0
  pushl $114
801084cd:	6a 72                	push   $0x72
  jmp alltraps
801084cf:	e9 b5 f5 ff ff       	jmp    80107a89 <alltraps>

801084d4 <vector115>:
.globl vector115
vector115:
  pushl $0
801084d4:	6a 00                	push   $0x0
  pushl $115
801084d6:	6a 73                	push   $0x73
  jmp alltraps
801084d8:	e9 ac f5 ff ff       	jmp    80107a89 <alltraps>

801084dd <vector116>:
.globl vector116
vector116:
  pushl $0
801084dd:	6a 00                	push   $0x0
  pushl $116
801084df:	6a 74                	push   $0x74
  jmp alltraps
801084e1:	e9 a3 f5 ff ff       	jmp    80107a89 <alltraps>

801084e6 <vector117>:
.globl vector117
vector117:
  pushl $0
801084e6:	6a 00                	push   $0x0
  pushl $117
801084e8:	6a 75                	push   $0x75
  jmp alltraps
801084ea:	e9 9a f5 ff ff       	jmp    80107a89 <alltraps>

801084ef <vector118>:
.globl vector118
vector118:
  pushl $0
801084ef:	6a 00                	push   $0x0
  pushl $118
801084f1:	6a 76                	push   $0x76
  jmp alltraps
801084f3:	e9 91 f5 ff ff       	jmp    80107a89 <alltraps>

801084f8 <vector119>:
.globl vector119
vector119:
  pushl $0
801084f8:	6a 00                	push   $0x0
  pushl $119
801084fa:	6a 77                	push   $0x77
  jmp alltraps
801084fc:	e9 88 f5 ff ff       	jmp    80107a89 <alltraps>

80108501 <vector120>:
.globl vector120
vector120:
  pushl $0
80108501:	6a 00                	push   $0x0
  pushl $120
80108503:	6a 78                	push   $0x78
  jmp alltraps
80108505:	e9 7f f5 ff ff       	jmp    80107a89 <alltraps>

8010850a <vector121>:
.globl vector121
vector121:
  pushl $0
8010850a:	6a 00                	push   $0x0
  pushl $121
8010850c:	6a 79                	push   $0x79
  jmp alltraps
8010850e:	e9 76 f5 ff ff       	jmp    80107a89 <alltraps>

80108513 <vector122>:
.globl vector122
vector122:
  pushl $0
80108513:	6a 00                	push   $0x0
  pushl $122
80108515:	6a 7a                	push   $0x7a
  jmp alltraps
80108517:	e9 6d f5 ff ff       	jmp    80107a89 <alltraps>

8010851c <vector123>:
.globl vector123
vector123:
  pushl $0
8010851c:	6a 00                	push   $0x0
  pushl $123
8010851e:	6a 7b                	push   $0x7b
  jmp alltraps
80108520:	e9 64 f5 ff ff       	jmp    80107a89 <alltraps>

80108525 <vector124>:
.globl vector124
vector124:
  pushl $0
80108525:	6a 00                	push   $0x0
  pushl $124
80108527:	6a 7c                	push   $0x7c
  jmp alltraps
80108529:	e9 5b f5 ff ff       	jmp    80107a89 <alltraps>

8010852e <vector125>:
.globl vector125
vector125:
  pushl $0
8010852e:	6a 00                	push   $0x0
  pushl $125
80108530:	6a 7d                	push   $0x7d
  jmp alltraps
80108532:	e9 52 f5 ff ff       	jmp    80107a89 <alltraps>

80108537 <vector126>:
.globl vector126
vector126:
  pushl $0
80108537:	6a 00                	push   $0x0
  pushl $126
80108539:	6a 7e                	push   $0x7e
  jmp alltraps
8010853b:	e9 49 f5 ff ff       	jmp    80107a89 <alltraps>

80108540 <vector127>:
.globl vector127
vector127:
  pushl $0
80108540:	6a 00                	push   $0x0
  pushl $127
80108542:	6a 7f                	push   $0x7f
  jmp alltraps
80108544:	e9 40 f5 ff ff       	jmp    80107a89 <alltraps>

80108549 <vector128>:
.globl vector128
vector128:
  pushl $0
80108549:	6a 00                	push   $0x0
  pushl $128
8010854b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108550:	e9 34 f5 ff ff       	jmp    80107a89 <alltraps>

80108555 <vector129>:
.globl vector129
vector129:
  pushl $0
80108555:	6a 00                	push   $0x0
  pushl $129
80108557:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010855c:	e9 28 f5 ff ff       	jmp    80107a89 <alltraps>

80108561 <vector130>:
.globl vector130
vector130:
  pushl $0
80108561:	6a 00                	push   $0x0
  pushl $130
80108563:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108568:	e9 1c f5 ff ff       	jmp    80107a89 <alltraps>

8010856d <vector131>:
.globl vector131
vector131:
  pushl $0
8010856d:	6a 00                	push   $0x0
  pushl $131
8010856f:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108574:	e9 10 f5 ff ff       	jmp    80107a89 <alltraps>

80108579 <vector132>:
.globl vector132
vector132:
  pushl $0
80108579:	6a 00                	push   $0x0
  pushl $132
8010857b:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108580:	e9 04 f5 ff ff       	jmp    80107a89 <alltraps>

80108585 <vector133>:
.globl vector133
vector133:
  pushl $0
80108585:	6a 00                	push   $0x0
  pushl $133
80108587:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010858c:	e9 f8 f4 ff ff       	jmp    80107a89 <alltraps>

80108591 <vector134>:
.globl vector134
vector134:
  pushl $0
80108591:	6a 00                	push   $0x0
  pushl $134
80108593:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108598:	e9 ec f4 ff ff       	jmp    80107a89 <alltraps>

8010859d <vector135>:
.globl vector135
vector135:
  pushl $0
8010859d:	6a 00                	push   $0x0
  pushl $135
8010859f:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801085a4:	e9 e0 f4 ff ff       	jmp    80107a89 <alltraps>

801085a9 <vector136>:
.globl vector136
vector136:
  pushl $0
801085a9:	6a 00                	push   $0x0
  pushl $136
801085ab:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801085b0:	e9 d4 f4 ff ff       	jmp    80107a89 <alltraps>

801085b5 <vector137>:
.globl vector137
vector137:
  pushl $0
801085b5:	6a 00                	push   $0x0
  pushl $137
801085b7:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801085bc:	e9 c8 f4 ff ff       	jmp    80107a89 <alltraps>

801085c1 <vector138>:
.globl vector138
vector138:
  pushl $0
801085c1:	6a 00                	push   $0x0
  pushl $138
801085c3:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801085c8:	e9 bc f4 ff ff       	jmp    80107a89 <alltraps>

801085cd <vector139>:
.globl vector139
vector139:
  pushl $0
801085cd:	6a 00                	push   $0x0
  pushl $139
801085cf:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801085d4:	e9 b0 f4 ff ff       	jmp    80107a89 <alltraps>

801085d9 <vector140>:
.globl vector140
vector140:
  pushl $0
801085d9:	6a 00                	push   $0x0
  pushl $140
801085db:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801085e0:	e9 a4 f4 ff ff       	jmp    80107a89 <alltraps>

801085e5 <vector141>:
.globl vector141
vector141:
  pushl $0
801085e5:	6a 00                	push   $0x0
  pushl $141
801085e7:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801085ec:	e9 98 f4 ff ff       	jmp    80107a89 <alltraps>

801085f1 <vector142>:
.globl vector142
vector142:
  pushl $0
801085f1:	6a 00                	push   $0x0
  pushl $142
801085f3:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801085f8:	e9 8c f4 ff ff       	jmp    80107a89 <alltraps>

801085fd <vector143>:
.globl vector143
vector143:
  pushl $0
801085fd:	6a 00                	push   $0x0
  pushl $143
801085ff:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108604:	e9 80 f4 ff ff       	jmp    80107a89 <alltraps>

80108609 <vector144>:
.globl vector144
vector144:
  pushl $0
80108609:	6a 00                	push   $0x0
  pushl $144
8010860b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108610:	e9 74 f4 ff ff       	jmp    80107a89 <alltraps>

80108615 <vector145>:
.globl vector145
vector145:
  pushl $0
80108615:	6a 00                	push   $0x0
  pushl $145
80108617:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010861c:	e9 68 f4 ff ff       	jmp    80107a89 <alltraps>

80108621 <vector146>:
.globl vector146
vector146:
  pushl $0
80108621:	6a 00                	push   $0x0
  pushl $146
80108623:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108628:	e9 5c f4 ff ff       	jmp    80107a89 <alltraps>

8010862d <vector147>:
.globl vector147
vector147:
  pushl $0
8010862d:	6a 00                	push   $0x0
  pushl $147
8010862f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108634:	e9 50 f4 ff ff       	jmp    80107a89 <alltraps>

80108639 <vector148>:
.globl vector148
vector148:
  pushl $0
80108639:	6a 00                	push   $0x0
  pushl $148
8010863b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108640:	e9 44 f4 ff ff       	jmp    80107a89 <alltraps>

80108645 <vector149>:
.globl vector149
vector149:
  pushl $0
80108645:	6a 00                	push   $0x0
  pushl $149
80108647:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010864c:	e9 38 f4 ff ff       	jmp    80107a89 <alltraps>

80108651 <vector150>:
.globl vector150
vector150:
  pushl $0
80108651:	6a 00                	push   $0x0
  pushl $150
80108653:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108658:	e9 2c f4 ff ff       	jmp    80107a89 <alltraps>

8010865d <vector151>:
.globl vector151
vector151:
  pushl $0
8010865d:	6a 00                	push   $0x0
  pushl $151
8010865f:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108664:	e9 20 f4 ff ff       	jmp    80107a89 <alltraps>

80108669 <vector152>:
.globl vector152
vector152:
  pushl $0
80108669:	6a 00                	push   $0x0
  pushl $152
8010866b:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108670:	e9 14 f4 ff ff       	jmp    80107a89 <alltraps>

80108675 <vector153>:
.globl vector153
vector153:
  pushl $0
80108675:	6a 00                	push   $0x0
  pushl $153
80108677:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010867c:	e9 08 f4 ff ff       	jmp    80107a89 <alltraps>

80108681 <vector154>:
.globl vector154
vector154:
  pushl $0
80108681:	6a 00                	push   $0x0
  pushl $154
80108683:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108688:	e9 fc f3 ff ff       	jmp    80107a89 <alltraps>

8010868d <vector155>:
.globl vector155
vector155:
  pushl $0
8010868d:	6a 00                	push   $0x0
  pushl $155
8010868f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108694:	e9 f0 f3 ff ff       	jmp    80107a89 <alltraps>

80108699 <vector156>:
.globl vector156
vector156:
  pushl $0
80108699:	6a 00                	push   $0x0
  pushl $156
8010869b:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801086a0:	e9 e4 f3 ff ff       	jmp    80107a89 <alltraps>

801086a5 <vector157>:
.globl vector157
vector157:
  pushl $0
801086a5:	6a 00                	push   $0x0
  pushl $157
801086a7:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801086ac:	e9 d8 f3 ff ff       	jmp    80107a89 <alltraps>

801086b1 <vector158>:
.globl vector158
vector158:
  pushl $0
801086b1:	6a 00                	push   $0x0
  pushl $158
801086b3:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801086b8:	e9 cc f3 ff ff       	jmp    80107a89 <alltraps>

801086bd <vector159>:
.globl vector159
vector159:
  pushl $0
801086bd:	6a 00                	push   $0x0
  pushl $159
801086bf:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801086c4:	e9 c0 f3 ff ff       	jmp    80107a89 <alltraps>

801086c9 <vector160>:
.globl vector160
vector160:
  pushl $0
801086c9:	6a 00                	push   $0x0
  pushl $160
801086cb:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801086d0:	e9 b4 f3 ff ff       	jmp    80107a89 <alltraps>

801086d5 <vector161>:
.globl vector161
vector161:
  pushl $0
801086d5:	6a 00                	push   $0x0
  pushl $161
801086d7:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801086dc:	e9 a8 f3 ff ff       	jmp    80107a89 <alltraps>

801086e1 <vector162>:
.globl vector162
vector162:
  pushl $0
801086e1:	6a 00                	push   $0x0
  pushl $162
801086e3:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801086e8:	e9 9c f3 ff ff       	jmp    80107a89 <alltraps>

801086ed <vector163>:
.globl vector163
vector163:
  pushl $0
801086ed:	6a 00                	push   $0x0
  pushl $163
801086ef:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801086f4:	e9 90 f3 ff ff       	jmp    80107a89 <alltraps>

801086f9 <vector164>:
.globl vector164
vector164:
  pushl $0
801086f9:	6a 00                	push   $0x0
  pushl $164
801086fb:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108700:	e9 84 f3 ff ff       	jmp    80107a89 <alltraps>

80108705 <vector165>:
.globl vector165
vector165:
  pushl $0
80108705:	6a 00                	push   $0x0
  pushl $165
80108707:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010870c:	e9 78 f3 ff ff       	jmp    80107a89 <alltraps>

80108711 <vector166>:
.globl vector166
vector166:
  pushl $0
80108711:	6a 00                	push   $0x0
  pushl $166
80108713:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108718:	e9 6c f3 ff ff       	jmp    80107a89 <alltraps>

8010871d <vector167>:
.globl vector167
vector167:
  pushl $0
8010871d:	6a 00                	push   $0x0
  pushl $167
8010871f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108724:	e9 60 f3 ff ff       	jmp    80107a89 <alltraps>

80108729 <vector168>:
.globl vector168
vector168:
  pushl $0
80108729:	6a 00                	push   $0x0
  pushl $168
8010872b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108730:	e9 54 f3 ff ff       	jmp    80107a89 <alltraps>

80108735 <vector169>:
.globl vector169
vector169:
  pushl $0
80108735:	6a 00                	push   $0x0
  pushl $169
80108737:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010873c:	e9 48 f3 ff ff       	jmp    80107a89 <alltraps>

80108741 <vector170>:
.globl vector170
vector170:
  pushl $0
80108741:	6a 00                	push   $0x0
  pushl $170
80108743:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108748:	e9 3c f3 ff ff       	jmp    80107a89 <alltraps>

8010874d <vector171>:
.globl vector171
vector171:
  pushl $0
8010874d:	6a 00                	push   $0x0
  pushl $171
8010874f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108754:	e9 30 f3 ff ff       	jmp    80107a89 <alltraps>

80108759 <vector172>:
.globl vector172
vector172:
  pushl $0
80108759:	6a 00                	push   $0x0
  pushl $172
8010875b:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108760:	e9 24 f3 ff ff       	jmp    80107a89 <alltraps>

80108765 <vector173>:
.globl vector173
vector173:
  pushl $0
80108765:	6a 00                	push   $0x0
  pushl $173
80108767:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010876c:	e9 18 f3 ff ff       	jmp    80107a89 <alltraps>

80108771 <vector174>:
.globl vector174
vector174:
  pushl $0
80108771:	6a 00                	push   $0x0
  pushl $174
80108773:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108778:	e9 0c f3 ff ff       	jmp    80107a89 <alltraps>

8010877d <vector175>:
.globl vector175
vector175:
  pushl $0
8010877d:	6a 00                	push   $0x0
  pushl $175
8010877f:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108784:	e9 00 f3 ff ff       	jmp    80107a89 <alltraps>

80108789 <vector176>:
.globl vector176
vector176:
  pushl $0
80108789:	6a 00                	push   $0x0
  pushl $176
8010878b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108790:	e9 f4 f2 ff ff       	jmp    80107a89 <alltraps>

80108795 <vector177>:
.globl vector177
vector177:
  pushl $0
80108795:	6a 00                	push   $0x0
  pushl $177
80108797:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010879c:	e9 e8 f2 ff ff       	jmp    80107a89 <alltraps>

801087a1 <vector178>:
.globl vector178
vector178:
  pushl $0
801087a1:	6a 00                	push   $0x0
  pushl $178
801087a3:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801087a8:	e9 dc f2 ff ff       	jmp    80107a89 <alltraps>

801087ad <vector179>:
.globl vector179
vector179:
  pushl $0
801087ad:	6a 00                	push   $0x0
  pushl $179
801087af:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801087b4:	e9 d0 f2 ff ff       	jmp    80107a89 <alltraps>

801087b9 <vector180>:
.globl vector180
vector180:
  pushl $0
801087b9:	6a 00                	push   $0x0
  pushl $180
801087bb:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801087c0:	e9 c4 f2 ff ff       	jmp    80107a89 <alltraps>

801087c5 <vector181>:
.globl vector181
vector181:
  pushl $0
801087c5:	6a 00                	push   $0x0
  pushl $181
801087c7:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801087cc:	e9 b8 f2 ff ff       	jmp    80107a89 <alltraps>

801087d1 <vector182>:
.globl vector182
vector182:
  pushl $0
801087d1:	6a 00                	push   $0x0
  pushl $182
801087d3:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801087d8:	e9 ac f2 ff ff       	jmp    80107a89 <alltraps>

801087dd <vector183>:
.globl vector183
vector183:
  pushl $0
801087dd:	6a 00                	push   $0x0
  pushl $183
801087df:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801087e4:	e9 a0 f2 ff ff       	jmp    80107a89 <alltraps>

801087e9 <vector184>:
.globl vector184
vector184:
  pushl $0
801087e9:	6a 00                	push   $0x0
  pushl $184
801087eb:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801087f0:	e9 94 f2 ff ff       	jmp    80107a89 <alltraps>

801087f5 <vector185>:
.globl vector185
vector185:
  pushl $0
801087f5:	6a 00                	push   $0x0
  pushl $185
801087f7:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801087fc:	e9 88 f2 ff ff       	jmp    80107a89 <alltraps>

80108801 <vector186>:
.globl vector186
vector186:
  pushl $0
80108801:	6a 00                	push   $0x0
  pushl $186
80108803:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108808:	e9 7c f2 ff ff       	jmp    80107a89 <alltraps>

8010880d <vector187>:
.globl vector187
vector187:
  pushl $0
8010880d:	6a 00                	push   $0x0
  pushl $187
8010880f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108814:	e9 70 f2 ff ff       	jmp    80107a89 <alltraps>

80108819 <vector188>:
.globl vector188
vector188:
  pushl $0
80108819:	6a 00                	push   $0x0
  pushl $188
8010881b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108820:	e9 64 f2 ff ff       	jmp    80107a89 <alltraps>

80108825 <vector189>:
.globl vector189
vector189:
  pushl $0
80108825:	6a 00                	push   $0x0
  pushl $189
80108827:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010882c:	e9 58 f2 ff ff       	jmp    80107a89 <alltraps>

80108831 <vector190>:
.globl vector190
vector190:
  pushl $0
80108831:	6a 00                	push   $0x0
  pushl $190
80108833:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108838:	e9 4c f2 ff ff       	jmp    80107a89 <alltraps>

8010883d <vector191>:
.globl vector191
vector191:
  pushl $0
8010883d:	6a 00                	push   $0x0
  pushl $191
8010883f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108844:	e9 40 f2 ff ff       	jmp    80107a89 <alltraps>

80108849 <vector192>:
.globl vector192
vector192:
  pushl $0
80108849:	6a 00                	push   $0x0
  pushl $192
8010884b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108850:	e9 34 f2 ff ff       	jmp    80107a89 <alltraps>

80108855 <vector193>:
.globl vector193
vector193:
  pushl $0
80108855:	6a 00                	push   $0x0
  pushl $193
80108857:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010885c:	e9 28 f2 ff ff       	jmp    80107a89 <alltraps>

80108861 <vector194>:
.globl vector194
vector194:
  pushl $0
80108861:	6a 00                	push   $0x0
  pushl $194
80108863:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108868:	e9 1c f2 ff ff       	jmp    80107a89 <alltraps>

8010886d <vector195>:
.globl vector195
vector195:
  pushl $0
8010886d:	6a 00                	push   $0x0
  pushl $195
8010886f:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108874:	e9 10 f2 ff ff       	jmp    80107a89 <alltraps>

80108879 <vector196>:
.globl vector196
vector196:
  pushl $0
80108879:	6a 00                	push   $0x0
  pushl $196
8010887b:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108880:	e9 04 f2 ff ff       	jmp    80107a89 <alltraps>

80108885 <vector197>:
.globl vector197
vector197:
  pushl $0
80108885:	6a 00                	push   $0x0
  pushl $197
80108887:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010888c:	e9 f8 f1 ff ff       	jmp    80107a89 <alltraps>

80108891 <vector198>:
.globl vector198
vector198:
  pushl $0
80108891:	6a 00                	push   $0x0
  pushl $198
80108893:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108898:	e9 ec f1 ff ff       	jmp    80107a89 <alltraps>

8010889d <vector199>:
.globl vector199
vector199:
  pushl $0
8010889d:	6a 00                	push   $0x0
  pushl $199
8010889f:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801088a4:	e9 e0 f1 ff ff       	jmp    80107a89 <alltraps>

801088a9 <vector200>:
.globl vector200
vector200:
  pushl $0
801088a9:	6a 00                	push   $0x0
  pushl $200
801088ab:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801088b0:	e9 d4 f1 ff ff       	jmp    80107a89 <alltraps>

801088b5 <vector201>:
.globl vector201
vector201:
  pushl $0
801088b5:	6a 00                	push   $0x0
  pushl $201
801088b7:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801088bc:	e9 c8 f1 ff ff       	jmp    80107a89 <alltraps>

801088c1 <vector202>:
.globl vector202
vector202:
  pushl $0
801088c1:	6a 00                	push   $0x0
  pushl $202
801088c3:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801088c8:	e9 bc f1 ff ff       	jmp    80107a89 <alltraps>

801088cd <vector203>:
.globl vector203
vector203:
  pushl $0
801088cd:	6a 00                	push   $0x0
  pushl $203
801088cf:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801088d4:	e9 b0 f1 ff ff       	jmp    80107a89 <alltraps>

801088d9 <vector204>:
.globl vector204
vector204:
  pushl $0
801088d9:	6a 00                	push   $0x0
  pushl $204
801088db:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801088e0:	e9 a4 f1 ff ff       	jmp    80107a89 <alltraps>

801088e5 <vector205>:
.globl vector205
vector205:
  pushl $0
801088e5:	6a 00                	push   $0x0
  pushl $205
801088e7:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801088ec:	e9 98 f1 ff ff       	jmp    80107a89 <alltraps>

801088f1 <vector206>:
.globl vector206
vector206:
  pushl $0
801088f1:	6a 00                	push   $0x0
  pushl $206
801088f3:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801088f8:	e9 8c f1 ff ff       	jmp    80107a89 <alltraps>

801088fd <vector207>:
.globl vector207
vector207:
  pushl $0
801088fd:	6a 00                	push   $0x0
  pushl $207
801088ff:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108904:	e9 80 f1 ff ff       	jmp    80107a89 <alltraps>

80108909 <vector208>:
.globl vector208
vector208:
  pushl $0
80108909:	6a 00                	push   $0x0
  pushl $208
8010890b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108910:	e9 74 f1 ff ff       	jmp    80107a89 <alltraps>

80108915 <vector209>:
.globl vector209
vector209:
  pushl $0
80108915:	6a 00                	push   $0x0
  pushl $209
80108917:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010891c:	e9 68 f1 ff ff       	jmp    80107a89 <alltraps>

80108921 <vector210>:
.globl vector210
vector210:
  pushl $0
80108921:	6a 00                	push   $0x0
  pushl $210
80108923:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108928:	e9 5c f1 ff ff       	jmp    80107a89 <alltraps>

8010892d <vector211>:
.globl vector211
vector211:
  pushl $0
8010892d:	6a 00                	push   $0x0
  pushl $211
8010892f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108934:	e9 50 f1 ff ff       	jmp    80107a89 <alltraps>

80108939 <vector212>:
.globl vector212
vector212:
  pushl $0
80108939:	6a 00                	push   $0x0
  pushl $212
8010893b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108940:	e9 44 f1 ff ff       	jmp    80107a89 <alltraps>

80108945 <vector213>:
.globl vector213
vector213:
  pushl $0
80108945:	6a 00                	push   $0x0
  pushl $213
80108947:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010894c:	e9 38 f1 ff ff       	jmp    80107a89 <alltraps>

80108951 <vector214>:
.globl vector214
vector214:
  pushl $0
80108951:	6a 00                	push   $0x0
  pushl $214
80108953:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108958:	e9 2c f1 ff ff       	jmp    80107a89 <alltraps>

8010895d <vector215>:
.globl vector215
vector215:
  pushl $0
8010895d:	6a 00                	push   $0x0
  pushl $215
8010895f:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108964:	e9 20 f1 ff ff       	jmp    80107a89 <alltraps>

80108969 <vector216>:
.globl vector216
vector216:
  pushl $0
80108969:	6a 00                	push   $0x0
  pushl $216
8010896b:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108970:	e9 14 f1 ff ff       	jmp    80107a89 <alltraps>

80108975 <vector217>:
.globl vector217
vector217:
  pushl $0
80108975:	6a 00                	push   $0x0
  pushl $217
80108977:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010897c:	e9 08 f1 ff ff       	jmp    80107a89 <alltraps>

80108981 <vector218>:
.globl vector218
vector218:
  pushl $0
80108981:	6a 00                	push   $0x0
  pushl $218
80108983:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108988:	e9 fc f0 ff ff       	jmp    80107a89 <alltraps>

8010898d <vector219>:
.globl vector219
vector219:
  pushl $0
8010898d:	6a 00                	push   $0x0
  pushl $219
8010898f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108994:	e9 f0 f0 ff ff       	jmp    80107a89 <alltraps>

80108999 <vector220>:
.globl vector220
vector220:
  pushl $0
80108999:	6a 00                	push   $0x0
  pushl $220
8010899b:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801089a0:	e9 e4 f0 ff ff       	jmp    80107a89 <alltraps>

801089a5 <vector221>:
.globl vector221
vector221:
  pushl $0
801089a5:	6a 00                	push   $0x0
  pushl $221
801089a7:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801089ac:	e9 d8 f0 ff ff       	jmp    80107a89 <alltraps>

801089b1 <vector222>:
.globl vector222
vector222:
  pushl $0
801089b1:	6a 00                	push   $0x0
  pushl $222
801089b3:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801089b8:	e9 cc f0 ff ff       	jmp    80107a89 <alltraps>

801089bd <vector223>:
.globl vector223
vector223:
  pushl $0
801089bd:	6a 00                	push   $0x0
  pushl $223
801089bf:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801089c4:	e9 c0 f0 ff ff       	jmp    80107a89 <alltraps>

801089c9 <vector224>:
.globl vector224
vector224:
  pushl $0
801089c9:	6a 00                	push   $0x0
  pushl $224
801089cb:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801089d0:	e9 b4 f0 ff ff       	jmp    80107a89 <alltraps>

801089d5 <vector225>:
.globl vector225
vector225:
  pushl $0
801089d5:	6a 00                	push   $0x0
  pushl $225
801089d7:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801089dc:	e9 a8 f0 ff ff       	jmp    80107a89 <alltraps>

801089e1 <vector226>:
.globl vector226
vector226:
  pushl $0
801089e1:	6a 00                	push   $0x0
  pushl $226
801089e3:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801089e8:	e9 9c f0 ff ff       	jmp    80107a89 <alltraps>

801089ed <vector227>:
.globl vector227
vector227:
  pushl $0
801089ed:	6a 00                	push   $0x0
  pushl $227
801089ef:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801089f4:	e9 90 f0 ff ff       	jmp    80107a89 <alltraps>

801089f9 <vector228>:
.globl vector228
vector228:
  pushl $0
801089f9:	6a 00                	push   $0x0
  pushl $228
801089fb:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108a00:	e9 84 f0 ff ff       	jmp    80107a89 <alltraps>

80108a05 <vector229>:
.globl vector229
vector229:
  pushl $0
80108a05:	6a 00                	push   $0x0
  pushl $229
80108a07:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108a0c:	e9 78 f0 ff ff       	jmp    80107a89 <alltraps>

80108a11 <vector230>:
.globl vector230
vector230:
  pushl $0
80108a11:	6a 00                	push   $0x0
  pushl $230
80108a13:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108a18:	e9 6c f0 ff ff       	jmp    80107a89 <alltraps>

80108a1d <vector231>:
.globl vector231
vector231:
  pushl $0
80108a1d:	6a 00                	push   $0x0
  pushl $231
80108a1f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108a24:	e9 60 f0 ff ff       	jmp    80107a89 <alltraps>

80108a29 <vector232>:
.globl vector232
vector232:
  pushl $0
80108a29:	6a 00                	push   $0x0
  pushl $232
80108a2b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108a30:	e9 54 f0 ff ff       	jmp    80107a89 <alltraps>

80108a35 <vector233>:
.globl vector233
vector233:
  pushl $0
80108a35:	6a 00                	push   $0x0
  pushl $233
80108a37:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108a3c:	e9 48 f0 ff ff       	jmp    80107a89 <alltraps>

80108a41 <vector234>:
.globl vector234
vector234:
  pushl $0
80108a41:	6a 00                	push   $0x0
  pushl $234
80108a43:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108a48:	e9 3c f0 ff ff       	jmp    80107a89 <alltraps>

80108a4d <vector235>:
.globl vector235
vector235:
  pushl $0
80108a4d:	6a 00                	push   $0x0
  pushl $235
80108a4f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108a54:	e9 30 f0 ff ff       	jmp    80107a89 <alltraps>

80108a59 <vector236>:
.globl vector236
vector236:
  pushl $0
80108a59:	6a 00                	push   $0x0
  pushl $236
80108a5b:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108a60:	e9 24 f0 ff ff       	jmp    80107a89 <alltraps>

80108a65 <vector237>:
.globl vector237
vector237:
  pushl $0
80108a65:	6a 00                	push   $0x0
  pushl $237
80108a67:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108a6c:	e9 18 f0 ff ff       	jmp    80107a89 <alltraps>

80108a71 <vector238>:
.globl vector238
vector238:
  pushl $0
80108a71:	6a 00                	push   $0x0
  pushl $238
80108a73:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108a78:	e9 0c f0 ff ff       	jmp    80107a89 <alltraps>

80108a7d <vector239>:
.globl vector239
vector239:
  pushl $0
80108a7d:	6a 00                	push   $0x0
  pushl $239
80108a7f:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108a84:	e9 00 f0 ff ff       	jmp    80107a89 <alltraps>

80108a89 <vector240>:
.globl vector240
vector240:
  pushl $0
80108a89:	6a 00                	push   $0x0
  pushl $240
80108a8b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108a90:	e9 f4 ef ff ff       	jmp    80107a89 <alltraps>

80108a95 <vector241>:
.globl vector241
vector241:
  pushl $0
80108a95:	6a 00                	push   $0x0
  pushl $241
80108a97:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108a9c:	e9 e8 ef ff ff       	jmp    80107a89 <alltraps>

80108aa1 <vector242>:
.globl vector242
vector242:
  pushl $0
80108aa1:	6a 00                	push   $0x0
  pushl $242
80108aa3:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108aa8:	e9 dc ef ff ff       	jmp    80107a89 <alltraps>

80108aad <vector243>:
.globl vector243
vector243:
  pushl $0
80108aad:	6a 00                	push   $0x0
  pushl $243
80108aaf:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108ab4:	e9 d0 ef ff ff       	jmp    80107a89 <alltraps>

80108ab9 <vector244>:
.globl vector244
vector244:
  pushl $0
80108ab9:	6a 00                	push   $0x0
  pushl $244
80108abb:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108ac0:	e9 c4 ef ff ff       	jmp    80107a89 <alltraps>

80108ac5 <vector245>:
.globl vector245
vector245:
  pushl $0
80108ac5:	6a 00                	push   $0x0
  pushl $245
80108ac7:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108acc:	e9 b8 ef ff ff       	jmp    80107a89 <alltraps>

80108ad1 <vector246>:
.globl vector246
vector246:
  pushl $0
80108ad1:	6a 00                	push   $0x0
  pushl $246
80108ad3:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108ad8:	e9 ac ef ff ff       	jmp    80107a89 <alltraps>

80108add <vector247>:
.globl vector247
vector247:
  pushl $0
80108add:	6a 00                	push   $0x0
  pushl $247
80108adf:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108ae4:	e9 a0 ef ff ff       	jmp    80107a89 <alltraps>

80108ae9 <vector248>:
.globl vector248
vector248:
  pushl $0
80108ae9:	6a 00                	push   $0x0
  pushl $248
80108aeb:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108af0:	e9 94 ef ff ff       	jmp    80107a89 <alltraps>

80108af5 <vector249>:
.globl vector249
vector249:
  pushl $0
80108af5:	6a 00                	push   $0x0
  pushl $249
80108af7:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108afc:	e9 88 ef ff ff       	jmp    80107a89 <alltraps>

80108b01 <vector250>:
.globl vector250
vector250:
  pushl $0
80108b01:	6a 00                	push   $0x0
  pushl $250
80108b03:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108b08:	e9 7c ef ff ff       	jmp    80107a89 <alltraps>

80108b0d <vector251>:
.globl vector251
vector251:
  pushl $0
80108b0d:	6a 00                	push   $0x0
  pushl $251
80108b0f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108b14:	e9 70 ef ff ff       	jmp    80107a89 <alltraps>

80108b19 <vector252>:
.globl vector252
vector252:
  pushl $0
80108b19:	6a 00                	push   $0x0
  pushl $252
80108b1b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108b20:	e9 64 ef ff ff       	jmp    80107a89 <alltraps>

80108b25 <vector253>:
.globl vector253
vector253:
  pushl $0
80108b25:	6a 00                	push   $0x0
  pushl $253
80108b27:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108b2c:	e9 58 ef ff ff       	jmp    80107a89 <alltraps>

80108b31 <vector254>:
.globl vector254
vector254:
  pushl $0
80108b31:	6a 00                	push   $0x0
  pushl $254
80108b33:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108b38:	e9 4c ef ff ff       	jmp    80107a89 <alltraps>

80108b3d <vector255>:
.globl vector255
vector255:
  pushl $0
80108b3d:	6a 00                	push   $0x0
  pushl $255
80108b3f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108b44:	e9 40 ef ff ff       	jmp    80107a89 <alltraps>

80108b49 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108b49:	55                   	push   %ebp
80108b4a:	89 e5                	mov    %esp,%ebp
80108b4c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b52:	83 e8 01             	sub    $0x1,%eax
80108b55:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108b59:	8b 45 08             	mov    0x8(%ebp),%eax
80108b5c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108b60:	8b 45 08             	mov    0x8(%ebp),%eax
80108b63:	c1 e8 10             	shr    $0x10,%eax
80108b66:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108b6a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108b6d:	0f 01 10             	lgdtl  (%eax)
}
80108b70:	90                   	nop
80108b71:	c9                   	leave  
80108b72:	c3                   	ret    

80108b73 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108b73:	55                   	push   %ebp
80108b74:	89 e5                	mov    %esp,%ebp
80108b76:	83 ec 04             	sub    $0x4,%esp
80108b79:	8b 45 08             	mov    0x8(%ebp),%eax
80108b7c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108b80:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108b84:	0f 00 d8             	ltr    %ax
}
80108b87:	90                   	nop
80108b88:	c9                   	leave  
80108b89:	c3                   	ret    

80108b8a <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108b8a:	55                   	push   %ebp
80108b8b:	89 e5                	mov    %esp,%ebp
80108b8d:	83 ec 04             	sub    $0x4,%esp
80108b90:	8b 45 08             	mov    0x8(%ebp),%eax
80108b93:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108b97:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108b9b:	8e e8                	mov    %eax,%gs
}
80108b9d:	90                   	nop
80108b9e:	c9                   	leave  
80108b9f:	c3                   	ret    

80108ba0 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108ba0:	55                   	push   %ebp
80108ba1:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80108ba6:	0f 22 d8             	mov    %eax,%cr3
}
80108ba9:	90                   	nop
80108baa:	5d                   	pop    %ebp
80108bab:	c3                   	ret    

80108bac <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108bac:	55                   	push   %ebp
80108bad:	89 e5                	mov    %esp,%ebp
80108baf:	8b 45 08             	mov    0x8(%ebp),%eax
80108bb2:	05 00 00 00 80       	add    $0x80000000,%eax
80108bb7:	5d                   	pop    %ebp
80108bb8:	c3                   	ret    

80108bb9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108bb9:	55                   	push   %ebp
80108bba:	89 e5                	mov    %esp,%ebp
80108bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80108bbf:	05 00 00 00 80       	add    $0x80000000,%eax
80108bc4:	5d                   	pop    %ebp
80108bc5:	c3                   	ret    

80108bc6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108bc6:	55                   	push   %ebp
80108bc7:	89 e5                	mov    %esp,%ebp
80108bc9:	53                   	push   %ebx
80108bca:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108bcd:	e8 9f a4 ff ff       	call   80103071 <cpunum>
80108bd2:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108bd8:	05 80 43 11 80       	add    $0x80114380,%eax
80108bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be3:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bec:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf5:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bfc:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c00:	83 e2 f0             	and    $0xfffffff0,%edx
80108c03:	83 ca 0a             	or     $0xa,%edx
80108c06:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c0c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c10:	83 ca 10             	or     $0x10,%edx
80108c13:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c19:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c1d:	83 e2 9f             	and    $0xffffff9f,%edx
80108c20:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c26:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c2a:	83 ca 80             	or     $0xffffff80,%edx
80108c2d:	88 50 7d             	mov    %dl,0x7d(%eax)
80108c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c33:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c37:	83 ca 0f             	or     $0xf,%edx
80108c3a:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c40:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c44:	83 e2 ef             	and    $0xffffffef,%edx
80108c47:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c51:	83 e2 df             	and    $0xffffffdf,%edx
80108c54:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c5e:	83 ca 40             	or     $0x40,%edx
80108c61:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c67:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108c6b:	83 ca 80             	or     $0xffffff80,%edx
80108c6e:	88 50 7e             	mov    %dl,0x7e(%eax)
80108c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c74:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c7b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108c82:	ff ff 
80108c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c87:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108c8e:	00 00 
80108c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c93:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ca4:	83 e2 f0             	and    $0xfffffff0,%edx
80108ca7:	83 ca 02             	or     $0x2,%edx
80108caa:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108cba:	83 ca 10             	or     $0x10,%edx
80108cbd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc6:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ccd:	83 e2 9f             	and    $0xffffff9f,%edx
80108cd0:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd9:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108ce0:	83 ca 80             	or     $0xffffff80,%edx
80108ce3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cec:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108cf3:	83 ca 0f             	or     $0xf,%edx
80108cf6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cff:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d06:	83 e2 ef             	and    $0xffffffef,%edx
80108d09:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d12:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d19:	83 e2 df             	and    $0xffffffdf,%edx
80108d1c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d25:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d2c:	83 ca 40             	or     $0x40,%edx
80108d2f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d38:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d3f:	83 ca 80             	or     $0xffffff80,%edx
80108d42:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4b:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d55:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108d5c:	ff ff 
80108d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d61:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108d68:	00 00 
80108d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d6d:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d77:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108d7e:	83 e2 f0             	and    $0xfffffff0,%edx
80108d81:	83 ca 0a             	or     $0xa,%edx
80108d84:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108d94:	83 ca 10             	or     $0x10,%edx
80108d97:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108da0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108da7:	83 ca 60             	or     $0x60,%edx
80108daa:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108dba:	83 ca 80             	or     $0xffffff80,%edx
80108dbd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108dcd:	83 ca 0f             	or     $0xf,%edx
80108dd0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108de0:	83 e2 ef             	and    $0xffffffef,%edx
80108de3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dec:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108df3:	83 e2 df             	and    $0xffffffdf,%edx
80108df6:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dff:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e06:	83 ca 40             	or     $0x40,%edx
80108e09:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e12:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e19:	83 ca 80             	or     $0xffffff80,%edx
80108e1c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e25:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2f:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108e36:	ff ff 
80108e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3b:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108e42:	00 00 
80108e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e47:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e51:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e58:	83 e2 f0             	and    $0xfffffff0,%edx
80108e5b:	83 ca 02             	or     $0x2,%edx
80108e5e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e67:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e6e:	83 ca 10             	or     $0x10,%edx
80108e71:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e7a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e81:	83 ca 60             	or     $0x60,%edx
80108e84:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e8d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108e94:	83 ca 80             	or     $0xffffff80,%edx
80108e97:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ea7:	83 ca 0f             	or     $0xf,%edx
80108eaa:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108eba:	83 e2 ef             	and    $0xffffffef,%edx
80108ebd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec6:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ecd:	83 e2 df             	and    $0xffffffdf,%edx
80108ed0:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed9:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ee0:	83 ca 40             	or     $0x40,%edx
80108ee3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eec:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108ef3:	83 ca 80             	or     $0xffffff80,%edx
80108ef6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eff:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f09:	05 b4 00 00 00       	add    $0xb4,%eax
80108f0e:	89 c3                	mov    %eax,%ebx
80108f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f13:	05 b4 00 00 00       	add    $0xb4,%eax
80108f18:	c1 e8 10             	shr    $0x10,%eax
80108f1b:	89 c2                	mov    %eax,%edx
80108f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f20:	05 b4 00 00 00       	add    $0xb4,%eax
80108f25:	c1 e8 18             	shr    $0x18,%eax
80108f28:	89 c1                	mov    %eax,%ecx
80108f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2d:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108f34:	00 00 
80108f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f39:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f43:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f53:	83 e2 f0             	and    $0xfffffff0,%edx
80108f56:	83 ca 02             	or     $0x2,%edx
80108f59:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f62:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f69:	83 ca 10             	or     $0x10,%edx
80108f6c:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f75:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f7c:	83 e2 9f             	and    $0xffffff9f,%edx
80108f7f:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f88:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108f8f:	83 ca 80             	or     $0xffffff80,%edx
80108f92:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fa2:	83 e2 f0             	and    $0xfffffff0,%edx
80108fa5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fae:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fb5:	83 e2 ef             	and    $0xffffffef,%edx
80108fb8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc1:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fc8:	83 e2 df             	and    $0xffffffdf,%edx
80108fcb:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd4:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fdb:	83 ca 40             	or     $0x40,%edx
80108fde:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108fee:	83 ca 80             	or     $0xffffff80,%edx
80108ff1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ffa:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109000:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109003:	83 c0 70             	add    $0x70,%eax
80109006:	83 ec 08             	sub    $0x8,%esp
80109009:	6a 38                	push   $0x38
8010900b:	50                   	push   %eax
8010900c:	e8 38 fb ff ff       	call   80108b49 <lgdt>
80109011:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109014:	83 ec 0c             	sub    $0xc,%esp
80109017:	6a 18                	push   $0x18
80109019:	e8 6c fb ff ff       	call   80108b8a <loadgs>
8010901e:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109024:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010902a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109031:	00 00 00 00 
}
80109035:	90                   	nop
80109036:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109039:	c9                   	leave  
8010903a:	c3                   	ret    

8010903b <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010903b:	55                   	push   %ebp
8010903c:	89 e5                	mov    %esp,%ebp
8010903e:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109041:	8b 45 0c             	mov    0xc(%ebp),%eax
80109044:	c1 e8 16             	shr    $0x16,%eax
80109047:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010904e:	8b 45 08             	mov    0x8(%ebp),%eax
80109051:	01 d0                	add    %edx,%eax
80109053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109056:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109059:	8b 00                	mov    (%eax),%eax
8010905b:	83 e0 01             	and    $0x1,%eax
8010905e:	85 c0                	test   %eax,%eax
80109060:	74 18                	je     8010907a <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109065:	8b 00                	mov    (%eax),%eax
80109067:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010906c:	50                   	push   %eax
8010906d:	e8 47 fb ff ff       	call   80108bb9 <p2v>
80109072:	83 c4 04             	add    $0x4,%esp
80109075:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109078:	eb 48                	jmp    801090c2 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010907a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010907e:	74 0e                	je     8010908e <walkpgdir+0x53>
80109080:	e8 86 9c ff ff       	call   80102d0b <kalloc>
80109085:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010908c:	75 07                	jne    80109095 <walkpgdir+0x5a>
      return 0;
8010908e:	b8 00 00 00 00       	mov    $0x0,%eax
80109093:	eb 44                	jmp    801090d9 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109095:	83 ec 04             	sub    $0x4,%esp
80109098:	68 00 10 00 00       	push   $0x1000
8010909d:	6a 00                	push   $0x0
8010909f:	ff 75 f4             	pushl  -0xc(%ebp)
801090a2:	e8 3c d4 ff ff       	call   801064e3 <memset>
801090a7:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801090aa:	83 ec 0c             	sub    $0xc,%esp
801090ad:	ff 75 f4             	pushl  -0xc(%ebp)
801090b0:	e8 f7 fa ff ff       	call   80108bac <v2p>
801090b5:	83 c4 10             	add    $0x10,%esp
801090b8:	83 c8 07             	or     $0x7,%eax
801090bb:	89 c2                	mov    %eax,%edx
801090bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090c0:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801090c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801090c5:	c1 e8 0c             	shr    $0xc,%eax
801090c8:	25 ff 03 00 00       	and    $0x3ff,%eax
801090cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801090d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090d7:	01 d0                	add    %edx,%eax
}
801090d9:	c9                   	leave  
801090da:	c3                   	ret    

801090db <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801090db:	55                   	push   %ebp
801090dc:	89 e5                	mov    %esp,%ebp
801090de:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801090e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801090e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801090ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801090ef:	8b 45 10             	mov    0x10(%ebp),%eax
801090f2:	01 d0                	add    %edx,%eax
801090f4:	83 e8 01             	sub    $0x1,%eax
801090f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801090ff:	83 ec 04             	sub    $0x4,%esp
80109102:	6a 01                	push   $0x1
80109104:	ff 75 f4             	pushl  -0xc(%ebp)
80109107:	ff 75 08             	pushl  0x8(%ebp)
8010910a:	e8 2c ff ff ff       	call   8010903b <walkpgdir>
8010910f:	83 c4 10             	add    $0x10,%esp
80109112:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109115:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109119:	75 07                	jne    80109122 <mappages+0x47>
      return -1;
8010911b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109120:	eb 47                	jmp    80109169 <mappages+0x8e>
    if(*pte & PTE_P)
80109122:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109125:	8b 00                	mov    (%eax),%eax
80109127:	83 e0 01             	and    $0x1,%eax
8010912a:	85 c0                	test   %eax,%eax
8010912c:	74 0d                	je     8010913b <mappages+0x60>
      panic("remap");
8010912e:	83 ec 0c             	sub    $0xc,%esp
80109131:	68 1c a1 10 80       	push   $0x8010a11c
80109136:	e8 2b 74 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010913b:	8b 45 18             	mov    0x18(%ebp),%eax
8010913e:	0b 45 14             	or     0x14(%ebp),%eax
80109141:	83 c8 01             	or     $0x1,%eax
80109144:	89 c2                	mov    %eax,%edx
80109146:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109149:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010914b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010914e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109151:	74 10                	je     80109163 <mappages+0x88>
      break;
    a += PGSIZE;
80109153:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010915a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109161:	eb 9c                	jmp    801090ff <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109163:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109164:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109169:	c9                   	leave  
8010916a:	c3                   	ret    

8010916b <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010916b:	55                   	push   %ebp
8010916c:	89 e5                	mov    %esp,%ebp
8010916e:	53                   	push   %ebx
8010916f:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109172:	e8 94 9b ff ff       	call   80102d0b <kalloc>
80109177:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010917a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010917e:	75 0a                	jne    8010918a <setupkvm+0x1f>
    return 0;
80109180:	b8 00 00 00 00       	mov    $0x0,%eax
80109185:	e9 8e 00 00 00       	jmp    80109218 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010918a:	83 ec 04             	sub    $0x4,%esp
8010918d:	68 00 10 00 00       	push   $0x1000
80109192:	6a 00                	push   $0x0
80109194:	ff 75 f0             	pushl  -0x10(%ebp)
80109197:	e8 47 d3 ff ff       	call   801064e3 <memset>
8010919c:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010919f:	83 ec 0c             	sub    $0xc,%esp
801091a2:	68 00 00 00 0e       	push   $0xe000000
801091a7:	e8 0d fa ff ff       	call   80108bb9 <p2v>
801091ac:	83 c4 10             	add    $0x10,%esp
801091af:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801091b4:	76 0d                	jbe    801091c3 <setupkvm+0x58>
    panic("PHYSTOP too high");
801091b6:	83 ec 0c             	sub    $0xc,%esp
801091b9:	68 22 a1 10 80       	push   $0x8010a122
801091be:	e8 a3 73 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801091c3:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
801091ca:	eb 40                	jmp    8010920c <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801091cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cf:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801091d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091d5:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801091d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091db:	8b 58 08             	mov    0x8(%eax),%ebx
801091de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e1:	8b 40 04             	mov    0x4(%eax),%eax
801091e4:	29 c3                	sub    %eax,%ebx
801091e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e9:	8b 00                	mov    (%eax),%eax
801091eb:	83 ec 0c             	sub    $0xc,%esp
801091ee:	51                   	push   %ecx
801091ef:	52                   	push   %edx
801091f0:	53                   	push   %ebx
801091f1:	50                   	push   %eax
801091f2:	ff 75 f0             	pushl  -0x10(%ebp)
801091f5:	e8 e1 fe ff ff       	call   801090db <mappages>
801091fa:	83 c4 20             	add    $0x20,%esp
801091fd:	85 c0                	test   %eax,%eax
801091ff:	79 07                	jns    80109208 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109201:	b8 00 00 00 00       	mov    $0x0,%eax
80109206:	eb 10                	jmp    80109218 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109208:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010920c:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
80109213:	72 b7                	jb     801091cc <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109215:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010921b:	c9                   	leave  
8010921c:	c3                   	ret    

8010921d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010921d:	55                   	push   %ebp
8010921e:	89 e5                	mov    %esp,%ebp
80109220:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109223:	e8 43 ff ff ff       	call   8010916b <setupkvm>
80109228:	a3 58 79 11 80       	mov    %eax,0x80117958
  switchkvm();
8010922d:	e8 03 00 00 00       	call   80109235 <switchkvm>
}
80109232:	90                   	nop
80109233:	c9                   	leave  
80109234:	c3                   	ret    

80109235 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109235:	55                   	push   %ebp
80109236:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109238:	a1 58 79 11 80       	mov    0x80117958,%eax
8010923d:	50                   	push   %eax
8010923e:	e8 69 f9 ff ff       	call   80108bac <v2p>
80109243:	83 c4 04             	add    $0x4,%esp
80109246:	50                   	push   %eax
80109247:	e8 54 f9 ff ff       	call   80108ba0 <lcr3>
8010924c:	83 c4 04             	add    $0x4,%esp
}
8010924f:	90                   	nop
80109250:	c9                   	leave  
80109251:	c3                   	ret    

80109252 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109252:	55                   	push   %ebp
80109253:	89 e5                	mov    %esp,%ebp
80109255:	56                   	push   %esi
80109256:	53                   	push   %ebx
  pushcli();
80109257:	e8 81 d1 ff ff       	call   801063dd <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010925c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109262:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109269:	83 c2 08             	add    $0x8,%edx
8010926c:	89 d6                	mov    %edx,%esi
8010926e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109275:	83 c2 08             	add    $0x8,%edx
80109278:	c1 ea 10             	shr    $0x10,%edx
8010927b:	89 d3                	mov    %edx,%ebx
8010927d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109284:	83 c2 08             	add    $0x8,%edx
80109287:	c1 ea 18             	shr    $0x18,%edx
8010928a:	89 d1                	mov    %edx,%ecx
8010928c:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109293:	67 00 
80109295:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010929c:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801092a2:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092a9:	83 e2 f0             	and    $0xfffffff0,%edx
801092ac:	83 ca 09             	or     $0x9,%edx
801092af:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092b5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092bc:	83 ca 10             	or     $0x10,%edx
801092bf:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092c5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092cc:	83 e2 9f             	and    $0xffffff9f,%edx
801092cf:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092d5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092dc:	83 ca 80             	or     $0xffffff80,%edx
801092df:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801092e5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801092ec:	83 e2 f0             	and    $0xfffffff0,%edx
801092ef:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801092f5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801092fc:	83 e2 ef             	and    $0xffffffef,%edx
801092ff:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109305:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010930c:	83 e2 df             	and    $0xffffffdf,%edx
8010930f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109315:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010931c:	83 ca 40             	or     $0x40,%edx
8010931f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109325:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010932c:	83 e2 7f             	and    $0x7f,%edx
8010932f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109335:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010933b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109341:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109348:	83 e2 ef             	and    $0xffffffef,%edx
8010934b:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109351:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109357:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010935d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109363:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010936a:	8b 52 08             	mov    0x8(%edx),%edx
8010936d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109373:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109376:	83 ec 0c             	sub    $0xc,%esp
80109379:	6a 30                	push   $0x30
8010937b:	e8 f3 f7 ff ff       	call   80108b73 <ltr>
80109380:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109383:	8b 45 08             	mov    0x8(%ebp),%eax
80109386:	8b 40 04             	mov    0x4(%eax),%eax
80109389:	85 c0                	test   %eax,%eax
8010938b:	75 0d                	jne    8010939a <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010938d:	83 ec 0c             	sub    $0xc,%esp
80109390:	68 33 a1 10 80       	push   $0x8010a133
80109395:	e8 cc 71 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010939a:	8b 45 08             	mov    0x8(%ebp),%eax
8010939d:	8b 40 04             	mov    0x4(%eax),%eax
801093a0:	83 ec 0c             	sub    $0xc,%esp
801093a3:	50                   	push   %eax
801093a4:	e8 03 f8 ff ff       	call   80108bac <v2p>
801093a9:	83 c4 10             	add    $0x10,%esp
801093ac:	83 ec 0c             	sub    $0xc,%esp
801093af:	50                   	push   %eax
801093b0:	e8 eb f7 ff ff       	call   80108ba0 <lcr3>
801093b5:	83 c4 10             	add    $0x10,%esp
  popcli();
801093b8:	e8 65 d0 ff ff       	call   80106422 <popcli>
}
801093bd:	90                   	nop
801093be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801093c1:	5b                   	pop    %ebx
801093c2:	5e                   	pop    %esi
801093c3:	5d                   	pop    %ebp
801093c4:	c3                   	ret    

801093c5 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801093c5:	55                   	push   %ebp
801093c6:	89 e5                	mov    %esp,%ebp
801093c8:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801093cb:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801093d2:	76 0d                	jbe    801093e1 <inituvm+0x1c>
    panic("inituvm: more than a page");
801093d4:	83 ec 0c             	sub    $0xc,%esp
801093d7:	68 47 a1 10 80       	push   $0x8010a147
801093dc:	e8 85 71 ff ff       	call   80100566 <panic>
  mem = kalloc();
801093e1:	e8 25 99 ff ff       	call   80102d0b <kalloc>
801093e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801093e9:	83 ec 04             	sub    $0x4,%esp
801093ec:	68 00 10 00 00       	push   $0x1000
801093f1:	6a 00                	push   $0x0
801093f3:	ff 75 f4             	pushl  -0xc(%ebp)
801093f6:	e8 e8 d0 ff ff       	call   801064e3 <memset>
801093fb:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801093fe:	83 ec 0c             	sub    $0xc,%esp
80109401:	ff 75 f4             	pushl  -0xc(%ebp)
80109404:	e8 a3 f7 ff ff       	call   80108bac <v2p>
80109409:	83 c4 10             	add    $0x10,%esp
8010940c:	83 ec 0c             	sub    $0xc,%esp
8010940f:	6a 06                	push   $0x6
80109411:	50                   	push   %eax
80109412:	68 00 10 00 00       	push   $0x1000
80109417:	6a 00                	push   $0x0
80109419:	ff 75 08             	pushl  0x8(%ebp)
8010941c:	e8 ba fc ff ff       	call   801090db <mappages>
80109421:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109424:	83 ec 04             	sub    $0x4,%esp
80109427:	ff 75 10             	pushl  0x10(%ebp)
8010942a:	ff 75 0c             	pushl  0xc(%ebp)
8010942d:	ff 75 f4             	pushl  -0xc(%ebp)
80109430:	e8 6d d1 ff ff       	call   801065a2 <memmove>
80109435:	83 c4 10             	add    $0x10,%esp
}
80109438:	90                   	nop
80109439:	c9                   	leave  
8010943a:	c3                   	ret    

8010943b <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010943b:	55                   	push   %ebp
8010943c:	89 e5                	mov    %esp,%ebp
8010943e:	53                   	push   %ebx
8010943f:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109442:	8b 45 0c             	mov    0xc(%ebp),%eax
80109445:	25 ff 0f 00 00       	and    $0xfff,%eax
8010944a:	85 c0                	test   %eax,%eax
8010944c:	74 0d                	je     8010945b <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
8010944e:	83 ec 0c             	sub    $0xc,%esp
80109451:	68 64 a1 10 80       	push   $0x8010a164
80109456:	e8 0b 71 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010945b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109462:	e9 95 00 00 00       	jmp    801094fc <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109467:	8b 55 0c             	mov    0xc(%ebp),%edx
8010946a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010946d:	01 d0                	add    %edx,%eax
8010946f:	83 ec 04             	sub    $0x4,%esp
80109472:	6a 00                	push   $0x0
80109474:	50                   	push   %eax
80109475:	ff 75 08             	pushl  0x8(%ebp)
80109478:	e8 be fb ff ff       	call   8010903b <walkpgdir>
8010947d:	83 c4 10             	add    $0x10,%esp
80109480:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109487:	75 0d                	jne    80109496 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109489:	83 ec 0c             	sub    $0xc,%esp
8010948c:	68 87 a1 10 80       	push   $0x8010a187
80109491:	e8 d0 70 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109496:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109499:	8b 00                	mov    (%eax),%eax
8010949b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801094a3:	8b 45 18             	mov    0x18(%ebp),%eax
801094a6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801094a9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801094ae:	77 0b                	ja     801094bb <loaduvm+0x80>
      n = sz - i;
801094b0:	8b 45 18             	mov    0x18(%ebp),%eax
801094b3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801094b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801094b9:	eb 07                	jmp    801094c2 <loaduvm+0x87>
    else
      n = PGSIZE;
801094bb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801094c2:	8b 55 14             	mov    0x14(%ebp),%edx
801094c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094c8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801094cb:	83 ec 0c             	sub    $0xc,%esp
801094ce:	ff 75 e8             	pushl  -0x18(%ebp)
801094d1:	e8 e3 f6 ff ff       	call   80108bb9 <p2v>
801094d6:	83 c4 10             	add    $0x10,%esp
801094d9:	ff 75 f0             	pushl  -0x10(%ebp)
801094dc:	53                   	push   %ebx
801094dd:	50                   	push   %eax
801094de:	ff 75 10             	pushl  0x10(%ebp)
801094e1:	e8 97 8a ff ff       	call   80101f7d <readi>
801094e6:	83 c4 10             	add    $0x10,%esp
801094e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801094ec:	74 07                	je     801094f5 <loaduvm+0xba>
      return -1;
801094ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801094f3:	eb 18                	jmp    8010950d <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801094f5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801094fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ff:	3b 45 18             	cmp    0x18(%ebp),%eax
80109502:	0f 82 5f ff ff ff    	jb     80109467 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109508:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010950d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109510:	c9                   	leave  
80109511:	c3                   	ret    

80109512 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109512:	55                   	push   %ebp
80109513:	89 e5                	mov    %esp,%ebp
80109515:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109518:	8b 45 10             	mov    0x10(%ebp),%eax
8010951b:	85 c0                	test   %eax,%eax
8010951d:	79 0a                	jns    80109529 <allocuvm+0x17>
    return 0;
8010951f:	b8 00 00 00 00       	mov    $0x0,%eax
80109524:	e9 b0 00 00 00       	jmp    801095d9 <allocuvm+0xc7>
  if(newsz < oldsz)
80109529:	8b 45 10             	mov    0x10(%ebp),%eax
8010952c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010952f:	73 08                	jae    80109539 <allocuvm+0x27>
    return oldsz;
80109531:	8b 45 0c             	mov    0xc(%ebp),%eax
80109534:	e9 a0 00 00 00       	jmp    801095d9 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109539:	8b 45 0c             	mov    0xc(%ebp),%eax
8010953c:	05 ff 0f 00 00       	add    $0xfff,%eax
80109541:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109546:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109549:	eb 7f                	jmp    801095ca <allocuvm+0xb8>
    mem = kalloc();
8010954b:	e8 bb 97 ff ff       	call   80102d0b <kalloc>
80109550:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109553:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109557:	75 2b                	jne    80109584 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109559:	83 ec 0c             	sub    $0xc,%esp
8010955c:	68 a5 a1 10 80       	push   $0x8010a1a5
80109561:	e8 60 6e ff ff       	call   801003c6 <cprintf>
80109566:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109569:	83 ec 04             	sub    $0x4,%esp
8010956c:	ff 75 0c             	pushl  0xc(%ebp)
8010956f:	ff 75 10             	pushl  0x10(%ebp)
80109572:	ff 75 08             	pushl  0x8(%ebp)
80109575:	e8 61 00 00 00       	call   801095db <deallocuvm>
8010957a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010957d:	b8 00 00 00 00       	mov    $0x0,%eax
80109582:	eb 55                	jmp    801095d9 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109584:	83 ec 04             	sub    $0x4,%esp
80109587:	68 00 10 00 00       	push   $0x1000
8010958c:	6a 00                	push   $0x0
8010958e:	ff 75 f0             	pushl  -0x10(%ebp)
80109591:	e8 4d cf ff ff       	call   801064e3 <memset>
80109596:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109599:	83 ec 0c             	sub    $0xc,%esp
8010959c:	ff 75 f0             	pushl  -0x10(%ebp)
8010959f:	e8 08 f6 ff ff       	call   80108bac <v2p>
801095a4:	83 c4 10             	add    $0x10,%esp
801095a7:	89 c2                	mov    %eax,%edx
801095a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ac:	83 ec 0c             	sub    $0xc,%esp
801095af:	6a 06                	push   $0x6
801095b1:	52                   	push   %edx
801095b2:	68 00 10 00 00       	push   $0x1000
801095b7:	50                   	push   %eax
801095b8:	ff 75 08             	pushl  0x8(%ebp)
801095bb:	e8 1b fb ff ff       	call   801090db <mappages>
801095c0:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801095c3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801095ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095cd:	3b 45 10             	cmp    0x10(%ebp),%eax
801095d0:	0f 82 75 ff ff ff    	jb     8010954b <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801095d6:	8b 45 10             	mov    0x10(%ebp),%eax
}
801095d9:	c9                   	leave  
801095da:	c3                   	ret    

801095db <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801095db:	55                   	push   %ebp
801095dc:	89 e5                	mov    %esp,%ebp
801095de:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801095e1:	8b 45 10             	mov    0x10(%ebp),%eax
801095e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801095e7:	72 08                	jb     801095f1 <deallocuvm+0x16>
    return oldsz;
801095e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801095ec:	e9 a5 00 00 00       	jmp    80109696 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801095f1:	8b 45 10             	mov    0x10(%ebp),%eax
801095f4:	05 ff 0f 00 00       	add    $0xfff,%eax
801095f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109601:	e9 81 00 00 00       	jmp    80109687 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109606:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109609:	83 ec 04             	sub    $0x4,%esp
8010960c:	6a 00                	push   $0x0
8010960e:	50                   	push   %eax
8010960f:	ff 75 08             	pushl  0x8(%ebp)
80109612:	e8 24 fa ff ff       	call   8010903b <walkpgdir>
80109617:	83 c4 10             	add    $0x10,%esp
8010961a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010961d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109621:	75 09                	jne    8010962c <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109623:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010962a:	eb 54                	jmp    80109680 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010962c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010962f:	8b 00                	mov    (%eax),%eax
80109631:	83 e0 01             	and    $0x1,%eax
80109634:	85 c0                	test   %eax,%eax
80109636:	74 48                	je     80109680 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109638:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010963b:	8b 00                	mov    (%eax),%eax
8010963d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109642:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109649:	75 0d                	jne    80109658 <deallocuvm+0x7d>
        panic("kfree");
8010964b:	83 ec 0c             	sub    $0xc,%esp
8010964e:	68 bd a1 10 80       	push   $0x8010a1bd
80109653:	e8 0e 6f ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109658:	83 ec 0c             	sub    $0xc,%esp
8010965b:	ff 75 ec             	pushl  -0x14(%ebp)
8010965e:	e8 56 f5 ff ff       	call   80108bb9 <p2v>
80109663:	83 c4 10             	add    $0x10,%esp
80109666:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109669:	83 ec 0c             	sub    $0xc,%esp
8010966c:	ff 75 e8             	pushl  -0x18(%ebp)
8010966f:	e8 fa 95 ff ff       	call   80102c6e <kfree>
80109674:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109677:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010967a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109680:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109687:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010968a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010968d:	0f 82 73 ff ff ff    	jb     80109606 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109693:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109696:	c9                   	leave  
80109697:	c3                   	ret    

80109698 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109698:	55                   	push   %ebp
80109699:	89 e5                	mov    %esp,%ebp
8010969b:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010969e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801096a2:	75 0d                	jne    801096b1 <freevm+0x19>
    panic("freevm: no pgdir");
801096a4:	83 ec 0c             	sub    $0xc,%esp
801096a7:	68 c3 a1 10 80       	push   $0x8010a1c3
801096ac:	e8 b5 6e ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801096b1:	83 ec 04             	sub    $0x4,%esp
801096b4:	6a 00                	push   $0x0
801096b6:	68 00 00 00 80       	push   $0x80000000
801096bb:	ff 75 08             	pushl  0x8(%ebp)
801096be:	e8 18 ff ff ff       	call   801095db <deallocuvm>
801096c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801096c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801096cd:	eb 4f                	jmp    8010971e <freevm+0x86>
    if(pgdir[i] & PTE_P){
801096cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096d9:	8b 45 08             	mov    0x8(%ebp),%eax
801096dc:	01 d0                	add    %edx,%eax
801096de:	8b 00                	mov    (%eax),%eax
801096e0:	83 e0 01             	and    $0x1,%eax
801096e3:	85 c0                	test   %eax,%eax
801096e5:	74 33                	je     8010971a <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801096e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096f1:	8b 45 08             	mov    0x8(%ebp),%eax
801096f4:	01 d0                	add    %edx,%eax
801096f6:	8b 00                	mov    (%eax),%eax
801096f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096fd:	83 ec 0c             	sub    $0xc,%esp
80109700:	50                   	push   %eax
80109701:	e8 b3 f4 ff ff       	call   80108bb9 <p2v>
80109706:	83 c4 10             	add    $0x10,%esp
80109709:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010970c:	83 ec 0c             	sub    $0xc,%esp
8010970f:	ff 75 f0             	pushl  -0x10(%ebp)
80109712:	e8 57 95 ff ff       	call   80102c6e <kfree>
80109717:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010971a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010971e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109725:	76 a8                	jbe    801096cf <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109727:	83 ec 0c             	sub    $0xc,%esp
8010972a:	ff 75 08             	pushl  0x8(%ebp)
8010972d:	e8 3c 95 ff ff       	call   80102c6e <kfree>
80109732:	83 c4 10             	add    $0x10,%esp
}
80109735:	90                   	nop
80109736:	c9                   	leave  
80109737:	c3                   	ret    

80109738 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109738:	55                   	push   %ebp
80109739:	89 e5                	mov    %esp,%ebp
8010973b:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010973e:	83 ec 04             	sub    $0x4,%esp
80109741:	6a 00                	push   $0x0
80109743:	ff 75 0c             	pushl  0xc(%ebp)
80109746:	ff 75 08             	pushl  0x8(%ebp)
80109749:	e8 ed f8 ff ff       	call   8010903b <walkpgdir>
8010974e:	83 c4 10             	add    $0x10,%esp
80109751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109758:	75 0d                	jne    80109767 <clearpteu+0x2f>
    panic("clearpteu");
8010975a:	83 ec 0c             	sub    $0xc,%esp
8010975d:	68 d4 a1 10 80       	push   $0x8010a1d4
80109762:	e8 ff 6d ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010976a:	8b 00                	mov    (%eax),%eax
8010976c:	83 e0 fb             	and    $0xfffffffb,%eax
8010976f:	89 c2                	mov    %eax,%edx
80109771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109774:	89 10                	mov    %edx,(%eax)
}
80109776:	90                   	nop
80109777:	c9                   	leave  
80109778:	c3                   	ret    

80109779 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109779:	55                   	push   %ebp
8010977a:	89 e5                	mov    %esp,%ebp
8010977c:	53                   	push   %ebx
8010977d:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109780:	e8 e6 f9 ff ff       	call   8010916b <setupkvm>
80109785:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109788:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010978c:	75 0a                	jne    80109798 <copyuvm+0x1f>
    return 0;
8010978e:	b8 00 00 00 00       	mov    $0x0,%eax
80109793:	e9 f8 00 00 00       	jmp    80109890 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109798:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010979f:	e9 c4 00 00 00       	jmp    80109868 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801097a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a7:	83 ec 04             	sub    $0x4,%esp
801097aa:	6a 00                	push   $0x0
801097ac:	50                   	push   %eax
801097ad:	ff 75 08             	pushl  0x8(%ebp)
801097b0:	e8 86 f8 ff ff       	call   8010903b <walkpgdir>
801097b5:	83 c4 10             	add    $0x10,%esp
801097b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
801097bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801097bf:	75 0d                	jne    801097ce <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801097c1:	83 ec 0c             	sub    $0xc,%esp
801097c4:	68 de a1 10 80       	push   $0x8010a1de
801097c9:	e8 98 6d ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
801097ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097d1:	8b 00                	mov    (%eax),%eax
801097d3:	83 e0 01             	and    $0x1,%eax
801097d6:	85 c0                	test   %eax,%eax
801097d8:	75 0d                	jne    801097e7 <copyuvm+0x6e>
      panic("copyuvm: page not present");
801097da:	83 ec 0c             	sub    $0xc,%esp
801097dd:	68 f8 a1 10 80       	push   $0x8010a1f8
801097e2:	e8 7f 6d ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801097e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097ea:	8b 00                	mov    (%eax),%eax
801097ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801097f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097f7:	8b 00                	mov    (%eax),%eax
801097f9:	25 ff 0f 00 00       	and    $0xfff,%eax
801097fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109801:	e8 05 95 ff ff       	call   80102d0b <kalloc>
80109806:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109809:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010980d:	74 6a                	je     80109879 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010980f:	83 ec 0c             	sub    $0xc,%esp
80109812:	ff 75 e8             	pushl  -0x18(%ebp)
80109815:	e8 9f f3 ff ff       	call   80108bb9 <p2v>
8010981a:	83 c4 10             	add    $0x10,%esp
8010981d:	83 ec 04             	sub    $0x4,%esp
80109820:	68 00 10 00 00       	push   $0x1000
80109825:	50                   	push   %eax
80109826:	ff 75 e0             	pushl  -0x20(%ebp)
80109829:	e8 74 cd ff ff       	call   801065a2 <memmove>
8010982e:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109831:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109834:	83 ec 0c             	sub    $0xc,%esp
80109837:	ff 75 e0             	pushl  -0x20(%ebp)
8010983a:	e8 6d f3 ff ff       	call   80108bac <v2p>
8010983f:	83 c4 10             	add    $0x10,%esp
80109842:	89 c2                	mov    %eax,%edx
80109844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109847:	83 ec 0c             	sub    $0xc,%esp
8010984a:	53                   	push   %ebx
8010984b:	52                   	push   %edx
8010984c:	68 00 10 00 00       	push   $0x1000
80109851:	50                   	push   %eax
80109852:	ff 75 f0             	pushl  -0x10(%ebp)
80109855:	e8 81 f8 ff ff       	call   801090db <mappages>
8010985a:	83 c4 20             	add    $0x20,%esp
8010985d:	85 c0                	test   %eax,%eax
8010985f:	78 1b                	js     8010987c <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109861:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010986b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010986e:	0f 82 30 ff ff ff    	jb     801097a4 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109874:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109877:	eb 17                	jmp    80109890 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109879:	90                   	nop
8010987a:	eb 01                	jmp    8010987d <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010987c:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010987d:	83 ec 0c             	sub    $0xc,%esp
80109880:	ff 75 f0             	pushl  -0x10(%ebp)
80109883:	e8 10 fe ff ff       	call   80109698 <freevm>
80109888:	83 c4 10             	add    $0x10,%esp
  return 0;
8010988b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109893:	c9                   	leave  
80109894:	c3                   	ret    

80109895 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109895:	55                   	push   %ebp
80109896:	89 e5                	mov    %esp,%ebp
80109898:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010989b:	83 ec 04             	sub    $0x4,%esp
8010989e:	6a 00                	push   $0x0
801098a0:	ff 75 0c             	pushl  0xc(%ebp)
801098a3:	ff 75 08             	pushl  0x8(%ebp)
801098a6:	e8 90 f7 ff ff       	call   8010903b <walkpgdir>
801098ab:	83 c4 10             	add    $0x10,%esp
801098ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801098b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098b4:	8b 00                	mov    (%eax),%eax
801098b6:	83 e0 01             	and    $0x1,%eax
801098b9:	85 c0                	test   %eax,%eax
801098bb:	75 07                	jne    801098c4 <uva2ka+0x2f>
    return 0;
801098bd:	b8 00 00 00 00       	mov    $0x0,%eax
801098c2:	eb 29                	jmp    801098ed <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801098c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098c7:	8b 00                	mov    (%eax),%eax
801098c9:	83 e0 04             	and    $0x4,%eax
801098cc:	85 c0                	test   %eax,%eax
801098ce:	75 07                	jne    801098d7 <uva2ka+0x42>
    return 0;
801098d0:	b8 00 00 00 00       	mov    $0x0,%eax
801098d5:	eb 16                	jmp    801098ed <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801098d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098da:	8b 00                	mov    (%eax),%eax
801098dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801098e1:	83 ec 0c             	sub    $0xc,%esp
801098e4:	50                   	push   %eax
801098e5:	e8 cf f2 ff ff       	call   80108bb9 <p2v>
801098ea:	83 c4 10             	add    $0x10,%esp
}
801098ed:	c9                   	leave  
801098ee:	c3                   	ret    

801098ef <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801098ef:	55                   	push   %ebp
801098f0:	89 e5                	mov    %esp,%ebp
801098f2:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801098f5:	8b 45 10             	mov    0x10(%ebp),%eax
801098f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801098fb:	eb 7f                	jmp    8010997c <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801098fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80109900:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109905:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109908:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010990b:	83 ec 08             	sub    $0x8,%esp
8010990e:	50                   	push   %eax
8010990f:	ff 75 08             	pushl  0x8(%ebp)
80109912:	e8 7e ff ff ff       	call   80109895 <uva2ka>
80109917:	83 c4 10             	add    $0x10,%esp
8010991a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010991d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109921:	75 07                	jne    8010992a <copyout+0x3b>
      return -1;
80109923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109928:	eb 61                	jmp    8010998b <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010992a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010992d:	2b 45 0c             	sub    0xc(%ebp),%eax
80109930:	05 00 10 00 00       	add    $0x1000,%eax
80109935:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010993b:	3b 45 14             	cmp    0x14(%ebp),%eax
8010993e:	76 06                	jbe    80109946 <copyout+0x57>
      n = len;
80109940:	8b 45 14             	mov    0x14(%ebp),%eax
80109943:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109946:	8b 45 0c             	mov    0xc(%ebp),%eax
80109949:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010994c:	89 c2                	mov    %eax,%edx
8010994e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109951:	01 d0                	add    %edx,%eax
80109953:	83 ec 04             	sub    $0x4,%esp
80109956:	ff 75 f0             	pushl  -0x10(%ebp)
80109959:	ff 75 f4             	pushl  -0xc(%ebp)
8010995c:	50                   	push   %eax
8010995d:	e8 40 cc ff ff       	call   801065a2 <memmove>
80109962:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109968:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010996b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010996e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109971:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109974:	05 00 10 00 00       	add    $0x1000,%eax
80109979:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010997c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109980:	0f 85 77 ff ff ff    	jne    801098fd <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109986:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010998b:	c9                   	leave  
8010998c:	c3                   	ret    
