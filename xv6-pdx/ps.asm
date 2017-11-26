
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"
#define max 72    //number of processes
int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
  // allocate my table

  struct uproc* table = malloc(max * sizeof(struct uproc));
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 1b 00 00       	push   $0x1b00
  1c:	e8 9f 08 00 00       	call   8c0 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int result = getprocs(max, table);              // system call
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 48                	push   $0x48
  2f:	e8 ba 04 00 00       	call   4ee <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)

  printf(1,"ID\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tName\n");
  3a:	83 ec 08             	sub    $0x8,%esp
  3d:	68 a4 09 00 00       	push   $0x9a4
  42:	6a 01                	push   $0x1
  44:	e8 a4 05 00 00       	call   5ed <printf>
  49:	83 c4 10             	add    $0x10,%esp
  for(int i =0; i<result; i++){
  4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  53:	e9 11 01 00 00       	jmp    169 <main+0x169>
    printf(1,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%s\t\n", table[i].pid, table[i].uid,table[i].gid, table[i].ppid, table[i].priority, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].state, table[i].size, table[i].name );
  58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  5b:	89 d0                	mov    %edx,%eax
  5d:	01 c0                	add    %eax,%eax
  5f:	01 d0                	add    %edx,%eax
  61:	c1 e0 05             	shl    $0x5,%eax
  64:	89 c2                	mov    %eax,%edx
  66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  69:	01 d0                	add    %edx,%eax
  6b:	83 c0 3c             	add    $0x3c,%eax
  6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  74:	89 d0                	mov    %edx,%eax
  76:	01 c0                	add    %eax,%eax
  78:	01 d0                	add    %edx,%eax
  7a:	c1 e0 05             	shl    $0x5,%eax
  7d:	89 c2                	mov    %eax,%edx
  7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  82:	01 d0                	add    %edx,%eax
  84:	8b 48 38             	mov    0x38(%eax),%ecx
  87:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8d:	89 d0                	mov    %edx,%eax
  8f:	01 c0                	add    %eax,%eax
  91:	01 d0                	add    %edx,%eax
  93:	c1 e0 05             	shl    $0x5,%eax
  96:	89 c2                	mov    %eax,%edx
  98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  9b:	01 d0                	add    %edx,%eax
  9d:	8d 58 18             	lea    0x18(%eax),%ebx
  a0:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  a6:	89 d0                	mov    %edx,%eax
  a8:	01 c0                	add    %eax,%eax
  aa:	01 d0                	add    %edx,%eax
  ac:	c1 e0 05             	shl    $0x5,%eax
  af:	89 c2                	mov    %eax,%edx
  b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b4:	01 d0                	add    %edx,%eax
  b6:	8b 70 14             	mov    0x14(%eax),%esi
  b9:	89 75 c8             	mov    %esi,-0x38(%ebp)
  bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  bf:	89 d0                	mov    %edx,%eax
  c1:	01 c0                	add    %eax,%eax
  c3:	01 d0                	add    %edx,%eax
  c5:	c1 e0 05             	shl    $0x5,%eax
  c8:	89 c2                	mov    %eax,%edx
  ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 78 10             	mov    0x10(%eax),%edi
  d2:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  d8:	89 d0                	mov    %edx,%eax
  da:	01 c0                	add    %eax,%eax
  dc:	01 d0                	add    %edx,%eax
  de:	c1 e0 05             	shl    $0x5,%eax
  e1:	89 c2                	mov    %eax,%edx
  e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e6:	01 d0                	add    %edx,%eax
  e8:	8b 78 5c             	mov    0x5c(%eax),%edi
  eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ee:	89 d0                	mov    %edx,%eax
  f0:	01 c0                	add    %eax,%eax
  f2:	01 d0                	add    %edx,%eax
  f4:	c1 e0 05             	shl    $0x5,%eax
  f7:	89 c2                	mov    %eax,%edx
  f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  fc:	01 d0                	add    %edx,%eax
  fe:	8b 70 0c             	mov    0xc(%eax),%esi
 101:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 104:	89 d0                	mov    %edx,%eax
 106:	01 c0                	add    %eax,%eax
 108:	01 d0                	add    %edx,%eax
 10a:	c1 e0 05             	shl    $0x5,%eax
 10d:	89 c2                	mov    %eax,%edx
 10f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 112:	01 d0                	add    %edx,%eax
 114:	8b 58 08             	mov    0x8(%eax),%ebx
 117:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 11a:	89 d0                	mov    %edx,%eax
 11c:	01 c0                	add    %eax,%eax
 11e:	01 d0                	add    %edx,%eax
 120:	c1 e0 05             	shl    $0x5,%eax
 123:	89 c2                	mov    %eax,%edx
 125:	8b 45 e0             	mov    -0x20(%ebp),%eax
 128:	01 d0                	add    %edx,%eax
 12a:	8b 48 04             	mov    0x4(%eax),%ecx
 12d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 130:	89 d0                	mov    %edx,%eax
 132:	01 c0                	add    %eax,%eax
 134:	01 d0                	add    %edx,%eax
 136:	c1 e0 05             	shl    $0x5,%eax
 139:	89 c2                	mov    %eax,%edx
 13b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	8b 00                	mov    (%eax),%eax
 142:	ff 75 d4             	pushl  -0x2c(%ebp)
 145:	ff 75 d0             	pushl  -0x30(%ebp)
 148:	ff 75 cc             	pushl  -0x34(%ebp)
 14b:	ff 75 c8             	pushl  -0x38(%ebp)
 14e:	ff 75 c4             	pushl  -0x3c(%ebp)
 151:	57                   	push   %edi
 152:	56                   	push   %esi
 153:	53                   	push   %ebx
 154:	51                   	push   %ecx
 155:	50                   	push   %eax
 156:	68 d8 09 00 00       	push   $0x9d8
 15b:	6a 01                	push   $0x1
 15d:	e8 8b 04 00 00       	call   5ed <printf>
 162:	83 c4 30             	add    $0x30,%esp

  struct uproc* table = malloc(max * sizeof(struct uproc));
  int result = getprocs(max, table);              // system call

  printf(1,"ID\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i =0; i<result; i++){
 165:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 16c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 16f:	0f 8c e3 fe ff ff    	jl     58 <main+0x58>
    printf(1,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%s\t\n", table[i].pid, table[i].uid,table[i].gid, table[i].ppid, table[i].priority, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].state, table[i].size, table[i].name );
  }

  exit();
 175:	e8 9c 02 00 00       	call   416 <exit>

0000017a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	57                   	push   %edi
 17e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 17f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 182:	8b 55 10             	mov    0x10(%ebp),%edx
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	89 cb                	mov    %ecx,%ebx
 18a:	89 df                	mov    %ebx,%edi
 18c:	89 d1                	mov    %edx,%ecx
 18e:	fc                   	cld    
 18f:	f3 aa                	rep stos %al,%es:(%edi)
 191:	89 ca                	mov    %ecx,%edx
 193:	89 fb                	mov    %edi,%ebx
 195:	89 5d 08             	mov    %ebx,0x8(%ebp)
 198:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 19b:	90                   	nop
 19c:	5b                   	pop    %ebx
 19d:	5f                   	pop    %edi
 19e:	5d                   	pop    %ebp
 19f:	c3                   	ret    

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ac:	90                   	nop
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	8d 50 01             	lea    0x1(%eax),%edx
 1b3:	89 55 08             	mov    %edx,0x8(%ebp)
 1b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 1b9:	8d 4a 01             	lea    0x1(%edx),%ecx
 1bc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1bf:	0f b6 12             	movzbl (%edx),%edx
 1c2:	88 10                	mov    %dl,(%eax)
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	84 c0                	test   %al,%al
 1c9:	75 e2                	jne    1ad <strcpy+0xd>
    ;
  return os;
 1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d3:	eb 08                	jmp    1dd <strcmp+0xd>
    p++, q++;
 1d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	84 c0                	test   %al,%al
 1e5:	74 10                	je     1f7 <strcmp+0x27>
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f0:	0f b6 00             	movzbl (%eax),%eax
 1f3:	38 c2                	cmp    %al,%dl
 1f5:	74 de                	je     1d5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	0f b6 d0             	movzbl %al,%edx
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	0f b6 c0             	movzbl %al,%eax
 209:	29 c2                	sub    %eax,%edx
 20b:	89 d0                	mov    %edx,%eax
}
 20d:	5d                   	pop    %ebp
 20e:	c3                   	ret    

0000020f <strlen>:

uint
strlen(char *s)
{
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
 212:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 215:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 21c:	eb 04                	jmp    222 <strlen+0x13>
 21e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 222:	8b 55 fc             	mov    -0x4(%ebp),%edx
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	01 d0                	add    %edx,%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	84 c0                	test   %al,%al
 22f:	75 ed                	jne    21e <strlen+0xf>
    ;
  return n;
 231:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <memset>:

void*
memset(void *dst, int c, uint n)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 239:	8b 45 10             	mov    0x10(%ebp),%eax
 23c:	50                   	push   %eax
 23d:	ff 75 0c             	pushl  0xc(%ebp)
 240:	ff 75 08             	pushl  0x8(%ebp)
 243:	e8 32 ff ff ff       	call   17a <stosb>
 248:	83 c4 0c             	add    $0xc,%esp
  return dst;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <strchr>:

char*
strchr(const char *s, char c)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 04             	sub    $0x4,%esp
 256:	8b 45 0c             	mov    0xc(%ebp),%eax
 259:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 25c:	eb 14                	jmp    272 <strchr+0x22>
    if(*s == c)
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3a 45 fc             	cmp    -0x4(%ebp),%al
 267:	75 05                	jne    26e <strchr+0x1e>
      return (char*)s;
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	eb 13                	jmp    281 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 26e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	84 c0                	test   %al,%al
 27a:	75 e2                	jne    25e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 27c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <gets>:

char*
gets(char *buf, int max)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 290:	eb 42                	jmp    2d4 <gets+0x51>
    cc = read(0, &c, 1);
 292:	83 ec 04             	sub    $0x4,%esp
 295:	6a 01                	push   $0x1
 297:	8d 45 ef             	lea    -0x11(%ebp),%eax
 29a:	50                   	push   %eax
 29b:	6a 00                	push   $0x0
 29d:	e8 8c 01 00 00       	call   42e <read>
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ac:	7e 33                	jle    2e1 <gets+0x5e>
      break;
    buf[i++] = c;
 2ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b1:	8d 50 01             	lea    0x1(%eax),%edx
 2b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2b7:	89 c2                	mov    %eax,%edx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	01 c2                	add    %eax,%edx
 2be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c8:	3c 0a                	cmp    $0xa,%al
 2ca:	74 16                	je     2e2 <gets+0x5f>
 2cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d0:	3c 0d                	cmp    $0xd,%al
 2d2:	74 0e                	je     2e2 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d7:	83 c0 01             	add    $0x1,%eax
 2da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2dd:	7c b3                	jl     292 <gets+0xf>
 2df:	eb 01                	jmp    2e2 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2e1:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	01 d0                	add    %edx,%eax
 2ea:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <stat>:

int
stat(char *n, struct stat *st)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f8:	83 ec 08             	sub    $0x8,%esp
 2fb:	6a 00                	push   $0x0
 2fd:	ff 75 08             	pushl  0x8(%ebp)
 300:	e8 51 01 00 00       	call   456 <open>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 30b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30f:	79 07                	jns    318 <stat+0x26>
    return -1;
 311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 316:	eb 25                	jmp    33d <stat+0x4b>
  r = fstat(fd, st);
 318:	83 ec 08             	sub    $0x8,%esp
 31b:	ff 75 0c             	pushl  0xc(%ebp)
 31e:	ff 75 f4             	pushl  -0xc(%ebp)
 321:	e8 48 01 00 00       	call   46e <fstat>
 326:	83 c4 10             	add    $0x10,%esp
 329:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 32c:	83 ec 0c             	sub    $0xc,%esp
 32f:	ff 75 f4             	pushl  -0xc(%ebp)
 332:	e8 07 01 00 00       	call   43e <close>
 337:	83 c4 10             	add    $0x10,%esp
  return r;
 33a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 33d:	c9                   	leave  
 33e:	c3                   	ret    

0000033f <atoi>:

int
atoi(const char *s)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 34c:	eb 04                	jmp    352 <atoi+0x13>
 34e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	3c 20                	cmp    $0x20,%al
 35a:	74 f2                	je     34e <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	0f b6 00             	movzbl (%eax),%eax
 362:	3c 2d                	cmp    $0x2d,%al
 364:	75 07                	jne    36d <atoi+0x2e>
 366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36b:	eb 05                	jmp    372 <atoi+0x33>
 36d:	b8 01 00 00 00       	mov    $0x1,%eax
 372:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	3c 2b                	cmp    $0x2b,%al
 37d:	74 0a                	je     389 <atoi+0x4a>
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	0f b6 00             	movzbl (%eax),%eax
 385:	3c 2d                	cmp    $0x2d,%al
 387:	75 2b                	jne    3b4 <atoi+0x75>
    s++;
 389:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 38d:	eb 25                	jmp    3b4 <atoi+0x75>
    n = n*10 + *s++ - '0';
 38f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 392:	89 d0                	mov    %edx,%eax
 394:	c1 e0 02             	shl    $0x2,%eax
 397:	01 d0                	add    %edx,%eax
 399:	01 c0                	add    %eax,%eax
 39b:	89 c1                	mov    %eax,%ecx
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	8d 50 01             	lea    0x1(%eax),%edx
 3a3:	89 55 08             	mov    %edx,0x8(%ebp)
 3a6:	0f b6 00             	movzbl (%eax),%eax
 3a9:	0f be c0             	movsbl %al,%eax
 3ac:	01 c8                	add    %ecx,%eax
 3ae:	83 e8 30             	sub    $0x30,%eax
 3b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	3c 2f                	cmp    $0x2f,%al
 3bc:	7e 0a                	jle    3c8 <atoi+0x89>
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	3c 39                	cmp    $0x39,%al
 3c6:	7e c7                	jle    38f <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3cb:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    

000003d1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
 3d4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e3:	eb 17                	jmp    3fc <memmove+0x2b>
    *dst++ = *src++;
 3e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e8:	8d 50 01             	lea    0x1(%eax),%edx
 3eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f7:	0f b6 12             	movzbl (%edx),%edx
 3fa:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fc:	8b 45 10             	mov    0x10(%ebp),%eax
 3ff:	8d 50 ff             	lea    -0x1(%eax),%edx
 402:	89 55 10             	mov    %edx,0x10(%ebp)
 405:	85 c0                	test   %eax,%eax
 407:	7f dc                	jg     3e5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 409:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40e:	b8 01 00 00 00       	mov    $0x1,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <exit>:
SYSCALL(exit)
 416:	b8 02 00 00 00       	mov    $0x2,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <wait>:
SYSCALL(wait)
 41e:	b8 03 00 00 00       	mov    $0x3,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <pipe>:
SYSCALL(pipe)
 426:	b8 04 00 00 00       	mov    $0x4,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <read>:
SYSCALL(read)
 42e:	b8 05 00 00 00       	mov    $0x5,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <write>:
SYSCALL(write)
 436:	b8 10 00 00 00       	mov    $0x10,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <close>:
SYSCALL(close)
 43e:	b8 15 00 00 00       	mov    $0x15,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <kill>:
SYSCALL(kill)
 446:	b8 06 00 00 00       	mov    $0x6,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <exec>:
SYSCALL(exec)
 44e:	b8 07 00 00 00       	mov    $0x7,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <open>:
SYSCALL(open)
 456:	b8 0f 00 00 00       	mov    $0xf,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <mknod>:
SYSCALL(mknod)
 45e:	b8 11 00 00 00       	mov    $0x11,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <unlink>:
SYSCALL(unlink)
 466:	b8 12 00 00 00       	mov    $0x12,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <fstat>:
SYSCALL(fstat)
 46e:	b8 08 00 00 00       	mov    $0x8,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <link>:
SYSCALL(link)
 476:	b8 13 00 00 00       	mov    $0x13,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <mkdir>:
SYSCALL(mkdir)
 47e:	b8 14 00 00 00       	mov    $0x14,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <chdir>:
SYSCALL(chdir)
 486:	b8 09 00 00 00       	mov    $0x9,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <dup>:
SYSCALL(dup)
 48e:	b8 0a 00 00 00       	mov    $0xa,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <getpid>:
SYSCALL(getpid)
 496:	b8 0b 00 00 00       	mov    $0xb,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <sbrk>:
SYSCALL(sbrk)
 49e:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <sleep>:
SYSCALL(sleep)
 4a6:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <uptime>:
SYSCALL(uptime)
 4ae:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <halt>:
SYSCALL(halt)
 4b6:	b8 16 00 00 00       	mov    $0x16,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <date>:
SYSCALL(date)
 4be:	b8 17 00 00 00       	mov    $0x17,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <getuid>:
SYSCALL(getuid)
 4c6:	b8 18 00 00 00       	mov    $0x18,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <getgid>:
SYSCALL(getgid)
 4ce:	b8 19 00 00 00       	mov    $0x19,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <getppid>:
SYSCALL(getppid)
 4d6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <setuid>:
SYSCALL(setuid)
 4de:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <setgid>:
SYSCALL(setgid)
 4e6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <getprocs>:
SYSCALL(getprocs)
 4ee:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <setpriority>:
SYSCALL(setpriority)
 4f6:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <chmod>:
SYSCALL(chmod)
 4fe:	b8 1f 00 00 00       	mov    $0x1f,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <chown>:
SYSCALL(chown)
 506:	b8 20 00 00 00       	mov    $0x20,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <chgrp>:
SYSCALL(chgrp)
 50e:	b8 21 00 00 00       	mov    $0x21,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	83 ec 18             	sub    $0x18,%esp
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 522:	83 ec 04             	sub    $0x4,%esp
 525:	6a 01                	push   $0x1
 527:	8d 45 f4             	lea    -0xc(%ebp),%eax
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 03 ff ff ff       	call   436 <write>
 533:	83 c4 10             	add    $0x10,%esp
}
 536:	90                   	nop
 537:	c9                   	leave  
 538:	c3                   	ret    

00000539 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 539:	55                   	push   %ebp
 53a:	89 e5                	mov    %esp,%ebp
 53c:	53                   	push   %ebx
 53d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 540:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 547:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 54b:	74 17                	je     564 <printint+0x2b>
 54d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 551:	79 11                	jns    564 <printint+0x2b>
    neg = 1;
 553:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 55a:	8b 45 0c             	mov    0xc(%ebp),%eax
 55d:	f7 d8                	neg    %eax
 55f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 562:	eb 06                	jmp    56a <printint+0x31>
  } else {
    x = xx;
 564:	8b 45 0c             	mov    0xc(%ebp),%eax
 567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 56a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 571:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 574:	8d 41 01             	lea    0x1(%ecx),%eax
 577:	89 45 f4             	mov    %eax,-0xc(%ebp)
 57a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 57d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 580:	ba 00 00 00 00       	mov    $0x0,%edx
 585:	f7 f3                	div    %ebx
 587:	89 d0                	mov    %edx,%eax
 589:	0f b6 80 54 0c 00 00 	movzbl 0xc54(%eax),%eax
 590:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 594:	8b 5d 10             	mov    0x10(%ebp),%ebx
 597:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59a:	ba 00 00 00 00       	mov    $0x0,%edx
 59f:	f7 f3                	div    %ebx
 5a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a8:	75 c7                	jne    571 <printint+0x38>
  if(neg)
 5aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ae:	74 2d                	je     5dd <printint+0xa4>
    buf[i++] = '-';
 5b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b3:	8d 50 01             	lea    0x1(%eax),%edx
 5b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5be:	eb 1d                	jmp    5dd <printint+0xa4>
    putc(fd, buf[i]);
 5c0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c6:	01 d0                	add    %edx,%eax
 5c8:	0f b6 00             	movzbl (%eax),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	83 ec 08             	sub    $0x8,%esp
 5d1:	50                   	push   %eax
 5d2:	ff 75 08             	pushl  0x8(%ebp)
 5d5:	e8 3c ff ff ff       	call   516 <putc>
 5da:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e5:	79 d9                	jns    5c0 <printint+0x87>
    putc(fd, buf[i]);
}
 5e7:	90                   	nop
 5e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5eb:	c9                   	leave  
 5ec:	c3                   	ret    

000005ed <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ed:	55                   	push   %ebp
 5ee:	89 e5                	mov    %esp,%ebp
 5f0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5fa:	8d 45 0c             	lea    0xc(%ebp),%eax
 5fd:	83 c0 04             	add    $0x4,%eax
 600:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 603:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 60a:	e9 59 01 00 00       	jmp    768 <printf+0x17b>
    c = fmt[i] & 0xff;
 60f:	8b 55 0c             	mov    0xc(%ebp),%edx
 612:	8b 45 f0             	mov    -0x10(%ebp),%eax
 615:	01 d0                	add    %edx,%eax
 617:	0f b6 00             	movzbl (%eax),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	25 ff 00 00 00       	and    $0xff,%eax
 622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 625:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 629:	75 2c                	jne    657 <printf+0x6a>
      if(c == '%'){
 62b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62f:	75 0c                	jne    63d <printf+0x50>
        state = '%';
 631:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 638:	e9 27 01 00 00       	jmp    764 <printf+0x177>
      } else {
        putc(fd, c);
 63d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 640:	0f be c0             	movsbl %al,%eax
 643:	83 ec 08             	sub    $0x8,%esp
 646:	50                   	push   %eax
 647:	ff 75 08             	pushl  0x8(%ebp)
 64a:	e8 c7 fe ff ff       	call   516 <putc>
 64f:	83 c4 10             	add    $0x10,%esp
 652:	e9 0d 01 00 00       	jmp    764 <printf+0x177>
      }
    } else if(state == '%'){
 657:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 65b:	0f 85 03 01 00 00    	jne    764 <printf+0x177>
      if(c == 'd'){
 661:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 665:	75 1e                	jne    685 <printf+0x98>
        printint(fd, *ap, 10, 1);
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	6a 01                	push   $0x1
 66e:	6a 0a                	push   $0xa
 670:	50                   	push   %eax
 671:	ff 75 08             	pushl  0x8(%ebp)
 674:	e8 c0 fe ff ff       	call   539 <printint>
 679:	83 c4 10             	add    $0x10,%esp
        ap++;
 67c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 680:	e9 d8 00 00 00       	jmp    75d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 685:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 689:	74 06                	je     691 <printf+0xa4>
 68b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 68f:	75 1e                	jne    6af <printf+0xc2>
        printint(fd, *ap, 16, 0);
 691:	8b 45 e8             	mov    -0x18(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	6a 00                	push   $0x0
 698:	6a 10                	push   $0x10
 69a:	50                   	push   %eax
 69b:	ff 75 08             	pushl  0x8(%ebp)
 69e:	e8 96 fe ff ff       	call   539 <printint>
 6a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6aa:	e9 ae 00 00 00       	jmp    75d <printf+0x170>
      } else if(c == 's'){
 6af:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6b3:	75 43                	jne    6f8 <printf+0x10b>
        s = (char*)*ap;
 6b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c5:	75 25                	jne    6ec <printf+0xff>
          s = "(null)";
 6c7:	c7 45 f4 f8 09 00 00 	movl   $0x9f8,-0xc(%ebp)
        while(*s != 0){
 6ce:	eb 1c                	jmp    6ec <printf+0xff>
          putc(fd, *s);
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	0f b6 00             	movzbl (%eax),%eax
 6d6:	0f be c0             	movsbl %al,%eax
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	50                   	push   %eax
 6dd:	ff 75 08             	pushl  0x8(%ebp)
 6e0:	e8 31 fe ff ff       	call   516 <putc>
 6e5:	83 c4 10             	add    $0x10,%esp
          s++;
 6e8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	84 c0                	test   %al,%al
 6f4:	75 da                	jne    6d0 <printf+0xe3>
 6f6:	eb 65                	jmp    75d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6f8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6fc:	75 1d                	jne    71b <printf+0x12e>
        putc(fd, *ap);
 6fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 701:	8b 00                	mov    (%eax),%eax
 703:	0f be c0             	movsbl %al,%eax
 706:	83 ec 08             	sub    $0x8,%esp
 709:	50                   	push   %eax
 70a:	ff 75 08             	pushl  0x8(%ebp)
 70d:	e8 04 fe ff ff       	call   516 <putc>
 712:	83 c4 10             	add    $0x10,%esp
        ap++;
 715:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 719:	eb 42                	jmp    75d <printf+0x170>
      } else if(c == '%'){
 71b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71f:	75 17                	jne    738 <printf+0x14b>
        putc(fd, c);
 721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	83 ec 08             	sub    $0x8,%esp
 72a:	50                   	push   %eax
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 e3 fd ff ff       	call   516 <putc>
 733:	83 c4 10             	add    $0x10,%esp
 736:	eb 25                	jmp    75d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 738:	83 ec 08             	sub    $0x8,%esp
 73b:	6a 25                	push   $0x25
 73d:	ff 75 08             	pushl  0x8(%ebp)
 740:	e8 d1 fd ff ff       	call   516 <putc>
 745:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74b:	0f be c0             	movsbl %al,%eax
 74e:	83 ec 08             	sub    $0x8,%esp
 751:	50                   	push   %eax
 752:	ff 75 08             	pushl  0x8(%ebp)
 755:	e8 bc fd ff ff       	call   516 <putc>
 75a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 75d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 764:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 768:	8b 55 0c             	mov    0xc(%ebp),%edx
 76b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76e:	01 d0                	add    %edx,%eax
 770:	0f b6 00             	movzbl (%eax),%eax
 773:	84 c0                	test   %al,%al
 775:	0f 85 94 fe ff ff    	jne    60f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 77b:	90                   	nop
 77c:	c9                   	leave  
 77d:	c3                   	ret    

0000077e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77e:	55                   	push   %ebp
 77f:	89 e5                	mov    %esp,%ebp
 781:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	83 e8 08             	sub    $0x8,%eax
 78a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	a1 70 0c 00 00       	mov    0xc70,%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	eb 24                	jmp    7bb <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79f:	77 12                	ja     7b3 <free+0x35>
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a7:	77 24                	ja     7cd <free+0x4f>
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b1:	77 1a                	ja     7cd <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c1:	76 d4                	jbe    797 <free+0x19>
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cb:	76 ca                	jbe    797 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	01 c2                	add    %eax,%edx
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	39 c2                	cmp    %eax,%edx
 7e6:	75 24                	jne    80c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	8b 50 04             	mov    0x4(%eax),%edx
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	01 c2                	add    %eax,%edx
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	8b 10                	mov    (%eax),%edx
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	89 10                	mov    %edx,(%eax)
 80a:	eb 0a                	jmp    816 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	01 d0                	add    %edx,%eax
 828:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 82b:	75 20                	jne    84d <free+0xcf>
    p->s.size += bp->s.size;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 50 04             	mov    0x4(%eax),%edx
 833:	8b 45 f8             	mov    -0x8(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	01 c2                	add    %eax,%edx
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	8b 10                	mov    (%eax),%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	89 10                	mov    %edx,(%eax)
 84b:	eb 08                	jmp    855 <free+0xd7>
  } else
    p->s.ptr = bp;
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 55 f8             	mov    -0x8(%ebp),%edx
 853:	89 10                	mov    %edx,(%eax)
  freep = p;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	a3 70 0c 00 00       	mov    %eax,0xc70
}
 85d:	90                   	nop
 85e:	c9                   	leave  
 85f:	c3                   	ret    

00000860 <morecore>:

static Header*
morecore(uint nu)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 866:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 86d:	77 07                	ja     876 <morecore+0x16>
    nu = 4096;
 86f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	c1 e0 03             	shl    $0x3,%eax
 87c:	83 ec 0c             	sub    $0xc,%esp
 87f:	50                   	push   %eax
 880:	e8 19 fc ff ff       	call   49e <sbrk>
 885:	83 c4 10             	add    $0x10,%esp
 888:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 88b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 88f:	75 07                	jne    898 <morecore+0x38>
    return 0;
 891:	b8 00 00 00 00       	mov    $0x0,%eax
 896:	eb 26                	jmp    8be <morecore+0x5e>
  hp = (Header*)p;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 89e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a1:	8b 55 08             	mov    0x8(%ebp),%edx
 8a4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	83 c0 08             	add    $0x8,%eax
 8ad:	83 ec 0c             	sub    $0xc,%esp
 8b0:	50                   	push   %eax
 8b1:	e8 c8 fe ff ff       	call   77e <free>
 8b6:	83 c4 10             	add    $0x10,%esp
  return freep;
 8b9:	a1 70 0c 00 00       	mov    0xc70,%eax
}
 8be:	c9                   	leave  
 8bf:	c3                   	ret    

000008c0 <malloc>:

void*
malloc(uint nbytes)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	83 c0 07             	add    $0x7,%eax
 8cc:	c1 e8 03             	shr    $0x3,%eax
 8cf:	83 c0 01             	add    $0x1,%eax
 8d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d5:	a1 70 0c 00 00       	mov    0xc70,%eax
 8da:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e1:	75 23                	jne    906 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8e3:	c7 45 f0 68 0c 00 00 	movl   $0xc68,-0x10(%ebp)
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	a3 70 0c 00 00       	mov    %eax,0xc70
 8f2:	a1 70 0c 00 00       	mov    0xc70,%eax
 8f7:	a3 68 0c 00 00       	mov    %eax,0xc68
    base.s.size = 0;
 8fc:	c7 05 6c 0c 00 00 00 	movl   $0x0,0xc6c
 903:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	8b 45 f0             	mov    -0x10(%ebp),%eax
 909:	8b 00                	mov    (%eax),%eax
 90b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 917:	72 4d                	jb     966 <malloc+0xa6>
      if(p->s.size == nunits)
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	8b 40 04             	mov    0x4(%eax),%eax
 91f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 922:	75 0c                	jne    930 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 927:	8b 10                	mov    (%eax),%edx
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	89 10                	mov    %edx,(%eax)
 92e:	eb 26                	jmp    956 <malloc+0x96>
      else {
        p->s.size -= nunits;
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	2b 45 ec             	sub    -0x14(%ebp),%eax
 939:	89 c2                	mov    %eax,%edx
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	c1 e0 03             	shl    $0x3,%eax
 94a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	8b 55 ec             	mov    -0x14(%ebp),%edx
 953:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	a3 70 0c 00 00       	mov    %eax,0xc70
      return (void*)(p + 1);
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	83 c0 08             	add    $0x8,%eax
 964:	eb 3b                	jmp    9a1 <malloc+0xe1>
    }
    if(p == freep)
 966:	a1 70 0c 00 00       	mov    0xc70,%eax
 96b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96e:	75 1e                	jne    98e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 970:	83 ec 0c             	sub    $0xc,%esp
 973:	ff 75 ec             	pushl  -0x14(%ebp)
 976:	e8 e5 fe ff ff       	call   860 <morecore>
 97b:	83 c4 10             	add    $0x10,%esp
 97e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 985:	75 07                	jne    98e <malloc+0xce>
        return 0;
 987:	b8 00 00 00 00       	mov    $0x0,%eax
 98c:	eb 13                	jmp    9a1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 991:	89 45 f0             	mov    %eax,-0x10(%ebp)
 994:	8b 45 f4             	mov    -0xc(%ebp),%eax
 997:	8b 00                	mov    (%eax),%eax
 999:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 99c:	e9 6d ff ff ff       	jmp    90e <malloc+0x4e>
}
 9a1:	c9                   	leave  
 9a2:	c3                   	ret    
