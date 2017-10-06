
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// halt the system.
#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 4a 03 00 00       	call   360 <halt>
  return 0;
  16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1b:	83 c4 04             	add    $0x4,%esp
  1e:	59                   	pop    %ecx
  1f:	5d                   	pop    %ebp
  20:	8d 61 fc             	lea    -0x4(%ecx),%esp
  23:	c3                   	ret    

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	90                   	nop
  46:	5b                   	pop    %ebx
  47:	5f                   	pop    %edi
  48:	5d                   	pop    %ebp
  49:	c3                   	ret    

0000004a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4a:	55                   	push   %ebp
  4b:	89 e5                	mov    %esp,%ebp
  4d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  50:	8b 45 08             	mov    0x8(%ebp),%eax
  53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  56:	90                   	nop
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	8d 50 01             	lea    0x1(%eax),%edx
  5d:	89 55 08             	mov    %edx,0x8(%ebp)
  60:	8b 55 0c             	mov    0xc(%ebp),%edx
  63:	8d 4a 01             	lea    0x1(%edx),%ecx
  66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  69:	0f b6 12             	movzbl (%edx),%edx
  6c:	88 10                	mov    %dl,(%eax)
  6e:	0f b6 00             	movzbl (%eax),%eax
  71:	84 c0                	test   %al,%al
  73:	75 e2                	jne    57 <strcpy+0xd>
    ;
  return os;
  75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7d:	eb 08                	jmp    87 <strcmp+0xd>
    p++, q++;
  7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	0f b6 00             	movzbl (%eax),%eax
  8d:	84 c0                	test   %al,%al
  8f:	74 10                	je     a1 <strcmp+0x27>
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	0f b6 10             	movzbl (%eax),%edx
  97:	8b 45 0c             	mov    0xc(%ebp),%eax
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	38 c2                	cmp    %al,%dl
  9f:	74 de                	je     7f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	0f b6 d0             	movzbl %al,%edx
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	0f b6 00             	movzbl (%eax),%eax
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	29 c2                	sub    %eax,%edx
  b5:	89 d0                	mov    %edx,%eax
}
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    

000000b9 <strlen>:

uint
strlen(char *s)
{
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c6:	eb 04                	jmp    cc <strlen+0x13>
  c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	84 c0                	test   %al,%al
  d9:	75 ed                	jne    c8 <strlen+0xf>
    ;
  return n;
  db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  de:	c9                   	leave  
  df:	c3                   	ret    

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e3:	8b 45 10             	mov    0x10(%ebp),%eax
  e6:	50                   	push   %eax
  e7:	ff 75 0c             	pushl  0xc(%ebp)
  ea:	ff 75 08             	pushl  0x8(%ebp)
  ed:	e8 32 ff ff ff       	call   24 <stosb>
  f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 04             	sub    $0x4,%esp
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 106:	eb 14                	jmp    11c <strchr+0x22>
    if(*s == c)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 111:	75 05                	jne    118 <strchr+0x1e>
      return (char*)s;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	eb 13                	jmp    12b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 118:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	75 e2                	jne    108 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 126:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <gets>:

char*
gets(char *buf, int max)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13a:	eb 42                	jmp    17e <gets+0x51>
    cc = read(0, &c, 1);
 13c:	83 ec 04             	sub    $0x4,%esp
 13f:	6a 01                	push   $0x1
 141:	8d 45 ef             	lea    -0x11(%ebp),%eax
 144:	50                   	push   %eax
 145:	6a 00                	push   $0x0
 147:	e8 8c 01 00 00       	call   2d8 <read>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 156:	7e 33                	jle    18b <gets+0x5e>
      break;
    buf[i++] = c;
 158:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15b:	8d 50 01             	lea    0x1(%eax),%edx
 15e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 161:	89 c2                	mov    %eax,%edx
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	01 c2                	add    %eax,%edx
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 172:	3c 0a                	cmp    $0xa,%al
 174:	74 16                	je     18c <gets+0x5f>
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0d                	cmp    $0xd,%al
 17c:	74 0e                	je     18c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 181:	83 c0 01             	add    $0x1,%eax
 184:	3b 45 0c             	cmp    0xc(%ebp),%eax
 187:	7c b3                	jl     13c <gets+0xf>
 189:	eb 01                	jmp    18c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	01 d0                	add    %edx,%eax
 194:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <stat>:

int
stat(char *n, struct stat *st)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	6a 00                	push   $0x0
 1a7:	ff 75 08             	pushl  0x8(%ebp)
 1aa:	e8 51 01 00 00       	call   300 <open>
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x26>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 25                	jmp    1e7 <stat+0x4b>
  r = fstat(fd, st);
 1c2:	83 ec 08             	sub    $0x8,%esp
 1c5:	ff 75 0c             	pushl  0xc(%ebp)
 1c8:	ff 75 f4             	pushl  -0xc(%ebp)
 1cb:	e8 48 01 00 00       	call   318 <fstat>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	ff 75 f4             	pushl  -0xc(%ebp)
 1dc:	e8 07 01 00 00       	call   2e8 <close>
 1e1:	83 c4 10             	add    $0x10,%esp
  return r;
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <atoi>:

int
atoi(const char *s)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1f6:	eb 04                	jmp    1fc <atoi+0x13>
 1f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	3c 20                	cmp    $0x20,%al
 204:	74 f2                	je     1f8 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	3c 2d                	cmp    $0x2d,%al
 20e:	75 07                	jne    217 <atoi+0x2e>
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb 05                	jmp    21c <atoi+0x33>
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3c 2b                	cmp    $0x2b,%al
 227:	74 0a                	je     233 <atoi+0x4a>
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 2d                	cmp    $0x2d,%al
 231:	75 2b                	jne    25e <atoi+0x75>
    s++;
 233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x75>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x89>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 272:	8b 45 f8             	mov    -0x8(%ebp),%eax
 275:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp
 27e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 287:	8b 45 0c             	mov    0xc(%ebp),%eax
 28a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 28d:	eb 17                	jmp    2a6 <memmove+0x2b>
    *dst++ = *src++;
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 292:	8d 50 01             	lea    0x1(%eax),%edx
 295:	89 55 fc             	mov    %edx,-0x4(%ebp)
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 4a 01             	lea    0x1(%edx),%ecx
 29e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a1:	0f b6 12             	movzbl (%edx),%edx
 2a4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a6:	8b 45 10             	mov    0x10(%ebp),%eax
 2a9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ac:	89 55 10             	mov    %edx,0x10(%ebp)
 2af:	85 c0                	test   %eax,%eax
 2b1:	7f dc                	jg     28f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b8:	b8 01 00 00 00       	mov    $0x1,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <exit>:
SYSCALL(exit)
 2c0:	b8 02 00 00 00       	mov    $0x2,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <wait>:
SYSCALL(wait)
 2c8:	b8 03 00 00 00       	mov    $0x3,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <pipe>:
SYSCALL(pipe)
 2d0:	b8 04 00 00 00       	mov    $0x4,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <read>:
SYSCALL(read)
 2d8:	b8 05 00 00 00       	mov    $0x5,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <write>:
SYSCALL(write)
 2e0:	b8 10 00 00 00       	mov    $0x10,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <close>:
SYSCALL(close)
 2e8:	b8 15 00 00 00       	mov    $0x15,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <kill>:
SYSCALL(kill)
 2f0:	b8 06 00 00 00       	mov    $0x6,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <exec>:
SYSCALL(exec)
 2f8:	b8 07 00 00 00       	mov    $0x7,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <open>:
SYSCALL(open)
 300:	b8 0f 00 00 00       	mov    $0xf,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <mknod>:
SYSCALL(mknod)
 308:	b8 11 00 00 00       	mov    $0x11,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <unlink>:
SYSCALL(unlink)
 310:	b8 12 00 00 00       	mov    $0x12,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <fstat>:
SYSCALL(fstat)
 318:	b8 08 00 00 00       	mov    $0x8,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <link>:
SYSCALL(link)
 320:	b8 13 00 00 00       	mov    $0x13,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mkdir>:
SYSCALL(mkdir)
 328:	b8 14 00 00 00       	mov    $0x14,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <chdir>:
SYSCALL(chdir)
 330:	b8 09 00 00 00       	mov    $0x9,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <dup>:
SYSCALL(dup)
 338:	b8 0a 00 00 00       	mov    $0xa,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <getpid>:
SYSCALL(getpid)
 340:	b8 0b 00 00 00       	mov    $0xb,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sbrk>:
SYSCALL(sbrk)
 348:	b8 0c 00 00 00       	mov    $0xc,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sleep>:
SYSCALL(sleep)
 350:	b8 0d 00 00 00       	mov    $0xd,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <uptime>:
SYSCALL(uptime)
 358:	b8 0e 00 00 00       	mov    $0xe,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <halt>:
SYSCALL(halt)
 360:	b8 16 00 00 00       	mov    $0x16,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <date>:
SYSCALL(date)
 368:	b8 17 00 00 00       	mov    $0x17,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <getuid>:
SYSCALL(getuid)
 370:	b8 18 00 00 00       	mov    $0x18,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getgid>:
SYSCALL(getgid)
 378:	b8 19 00 00 00       	mov    $0x19,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <getppid>:
SYSCALL(getppid)
 380:	b8 1a 00 00 00       	mov    $0x1a,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <setuid>:
SYSCALL(setuid)
 388:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <setgid>:
SYSCALL(setgid)
 390:	b8 1c 00 00 00       	mov    $0x1c,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	83 ec 18             	sub    $0x18,%esp
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a4:	83 ec 04             	sub    $0x4,%esp
 3a7:	6a 01                	push   $0x1
 3a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ac:	50                   	push   %eax
 3ad:	ff 75 08             	pushl  0x8(%ebp)
 3b0:	e8 2b ff ff ff       	call   2e0 <write>
 3b5:	83 c4 10             	add    $0x10,%esp
}
 3b8:	90                   	nop
 3b9:	c9                   	leave  
 3ba:	c3                   	ret    

000003bb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bb:	55                   	push   %ebp
 3bc:	89 e5                	mov    %esp,%ebp
 3be:	53                   	push   %ebx
 3bf:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cd:	74 17                	je     3e6 <printint+0x2b>
 3cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d3:	79 11                	jns    3e6 <printint+0x2b>
    neg = 1;
 3d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	f7 d8                	neg    %eax
 3e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e4:	eb 06                	jmp    3ec <printint+0x31>
  } else {
    x = xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f6:	8d 41 01             	lea    0x1(%ecx),%eax
 3f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 f3                	div    %ebx
 409:	89 d0                	mov    %edx,%eax
 40b:	0f b6 80 7c 0a 00 00 	movzbl 0xa7c(%eax),%eax
 412:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 416:	8b 5d 10             	mov    0x10(%ebp),%ebx
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	ba 00 00 00 00       	mov    $0x0,%edx
 421:	f7 f3                	div    %ebx
 423:	89 45 ec             	mov    %eax,-0x14(%ebp)
 426:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42a:	75 c7                	jne    3f3 <printint+0x38>
  if(neg)
 42c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 430:	74 2d                	je     45f <printint+0xa4>
    buf[i++] = '-';
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	8d 50 01             	lea    0x1(%eax),%edx
 438:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 440:	eb 1d                	jmp    45f <printint+0xa4>
    putc(fd, buf[i]);
 442:	8d 55 dc             	lea    -0x24(%ebp),%edx
 445:	8b 45 f4             	mov    -0xc(%ebp),%eax
 448:	01 d0                	add    %edx,%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	0f be c0             	movsbl %al,%eax
 450:	83 ec 08             	sub    $0x8,%esp
 453:	50                   	push   %eax
 454:	ff 75 08             	pushl  0x8(%ebp)
 457:	e8 3c ff ff ff       	call   398 <putc>
 45c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 467:	79 d9                	jns    442 <printint+0x87>
    putc(fd, buf[i]);
}
 469:	90                   	nop
 46a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 46d:	c9                   	leave  
 46e:	c3                   	ret    

0000046f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 475:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47c:	8d 45 0c             	lea    0xc(%ebp),%eax
 47f:	83 c0 04             	add    $0x4,%eax
 482:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48c:	e9 59 01 00 00       	jmp    5ea <printf+0x17b>
    c = fmt[i] & 0xff;
 491:	8b 55 0c             	mov    0xc(%ebp),%edx
 494:	8b 45 f0             	mov    -0x10(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	0f b6 00             	movzbl (%eax),%eax
 49c:	0f be c0             	movsbl %al,%eax
 49f:	25 ff 00 00 00       	and    $0xff,%eax
 4a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ab:	75 2c                	jne    4d9 <printf+0x6a>
      if(c == '%'){
 4ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b1:	75 0c                	jne    4bf <printf+0x50>
        state = '%';
 4b3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ba:	e9 27 01 00 00       	jmp    5e6 <printf+0x177>
      } else {
        putc(fd, c);
 4bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c2:	0f be c0             	movsbl %al,%eax
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	50                   	push   %eax
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 c7 fe ff ff       	call   398 <putc>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	e9 0d 01 00 00       	jmp    5e6 <printf+0x177>
      }
    } else if(state == '%'){
 4d9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4dd:	0f 85 03 01 00 00    	jne    5e6 <printf+0x177>
      if(c == 'd'){
 4e3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e7:	75 1e                	jne    507 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	6a 01                	push   $0x1
 4f0:	6a 0a                	push   $0xa
 4f2:	50                   	push   %eax
 4f3:	ff 75 08             	pushl  0x8(%ebp)
 4f6:	e8 c0 fe ff ff       	call   3bb <printint>
 4fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 502:	e9 d8 00 00 00       	jmp    5df <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 507:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50b:	74 06                	je     513 <printf+0xa4>
 50d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 511:	75 1e                	jne    531 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 513:	8b 45 e8             	mov    -0x18(%ebp),%eax
 516:	8b 00                	mov    (%eax),%eax
 518:	6a 00                	push   $0x0
 51a:	6a 10                	push   $0x10
 51c:	50                   	push   %eax
 51d:	ff 75 08             	pushl  0x8(%ebp)
 520:	e8 96 fe ff ff       	call   3bb <printint>
 525:	83 c4 10             	add    $0x10,%esp
        ap++;
 528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52c:	e9 ae 00 00 00       	jmp    5df <printf+0x170>
      } else if(c == 's'){
 531:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 535:	75 43                	jne    57a <printf+0x10b>
        s = (char*)*ap;
 537:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53a:	8b 00                	mov    (%eax),%eax
 53c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 53f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 547:	75 25                	jne    56e <printf+0xff>
          s = "(null)";
 549:	c7 45 f4 25 08 00 00 	movl   $0x825,-0xc(%ebp)
        while(*s != 0){
 550:	eb 1c                	jmp    56e <printf+0xff>
          putc(fd, *s);
 552:	8b 45 f4             	mov    -0xc(%ebp),%eax
 555:	0f b6 00             	movzbl (%eax),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	83 ec 08             	sub    $0x8,%esp
 55e:	50                   	push   %eax
 55f:	ff 75 08             	pushl  0x8(%ebp)
 562:	e8 31 fe ff ff       	call   398 <putc>
 567:	83 c4 10             	add    $0x10,%esp
          s++;
 56a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	0f b6 00             	movzbl (%eax),%eax
 574:	84 c0                	test   %al,%al
 576:	75 da                	jne    552 <printf+0xe3>
 578:	eb 65                	jmp    5df <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 57e:	75 1d                	jne    59d <printf+0x12e>
        putc(fd, *ap);
 580:	8b 45 e8             	mov    -0x18(%ebp),%eax
 583:	8b 00                	mov    (%eax),%eax
 585:	0f be c0             	movsbl %al,%eax
 588:	83 ec 08             	sub    $0x8,%esp
 58b:	50                   	push   %eax
 58c:	ff 75 08             	pushl  0x8(%ebp)
 58f:	e8 04 fe ff ff       	call   398 <putc>
 594:	83 c4 10             	add    $0x10,%esp
        ap++;
 597:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59b:	eb 42                	jmp    5df <printf+0x170>
      } else if(c == '%'){
 59d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a1:	75 17                	jne    5ba <printf+0x14b>
        putc(fd, c);
 5a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 e3 fd ff ff       	call   398 <putc>
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	eb 25                	jmp    5df <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ba:	83 ec 08             	sub    $0x8,%esp
 5bd:	6a 25                	push   $0x25
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 d1 fd ff ff       	call   398 <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	83 ec 08             	sub    $0x8,%esp
 5d3:	50                   	push   %eax
 5d4:	ff 75 08             	pushl  0x8(%ebp)
 5d7:	e8 bc fd ff ff       	call   398 <putc>
 5dc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f0:	01 d0                	add    %edx,%eax
 5f2:	0f b6 00             	movzbl (%eax),%eax
 5f5:	84 c0                	test   %al,%al
 5f7:	0f 85 94 fe ff ff    	jne    491 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5fd:	90                   	nop
 5fe:	c9                   	leave  
 5ff:	c3                   	ret    

00000600 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	83 e8 08             	sub    $0x8,%eax
 60c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60f:	a1 98 0a 00 00       	mov    0xa98,%eax
 614:	89 45 fc             	mov    %eax,-0x4(%ebp)
 617:	eb 24                	jmp    63d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 621:	77 12                	ja     635 <free+0x35>
 623:	8b 45 f8             	mov    -0x8(%ebp),%eax
 626:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 629:	77 24                	ja     64f <free+0x4f>
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 633:	77 1a                	ja     64f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 640:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 643:	76 d4                	jbe    619 <free+0x19>
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64d:	76 ca                	jbe    619 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	8b 40 04             	mov    0x4(%eax),%eax
 655:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	01 c2                	add    %eax,%edx
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	39 c2                	cmp    %eax,%edx
 668:	75 24                	jne    68e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	8b 40 04             	mov    0x4(%eax),%eax
 678:	01 c2                	add    %eax,%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	8b 10                	mov    (%eax),%edx
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	89 10                	mov    %edx,(%eax)
 68c:	eb 0a                	jmp    698 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 40 04             	mov    0x4(%eax),%eax
 69e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	01 d0                	add    %edx,%eax
 6aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ad:	75 20                	jne    6cf <free+0xcf>
    p->s.size += bp->s.size;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 50 04             	mov    0x4(%eax),%edx
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	01 c2                	add    %eax,%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	89 10                	mov    %edx,(%eax)
 6cd:	eb 08                	jmp    6d7 <free+0xd7>
  } else
    p->s.ptr = bp;
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 6df:	90                   	nop
 6e0:	c9                   	leave  
 6e1:	c3                   	ret    

000006e2 <morecore>:

static Header*
morecore(uint nu)
{
 6e2:	55                   	push   %ebp
 6e3:	89 e5                	mov    %esp,%ebp
 6e5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ef:	77 07                	ja     6f8 <morecore+0x16>
    nu = 4096;
 6f1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	c1 e0 03             	shl    $0x3,%eax
 6fe:	83 ec 0c             	sub    $0xc,%esp
 701:	50                   	push   %eax
 702:	e8 41 fc ff ff       	call   348 <sbrk>
 707:	83 c4 10             	add    $0x10,%esp
 70a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 711:	75 07                	jne    71a <morecore+0x38>
    return 0;
 713:	b8 00 00 00 00       	mov    $0x0,%eax
 718:	eb 26                	jmp    740 <morecore+0x5e>
  hp = (Header*)p;
 71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 720:	8b 45 f0             	mov    -0x10(%ebp),%eax
 723:	8b 55 08             	mov    0x8(%ebp),%edx
 726:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 729:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72c:	83 c0 08             	add    $0x8,%eax
 72f:	83 ec 0c             	sub    $0xc,%esp
 732:	50                   	push   %eax
 733:	e8 c8 fe ff ff       	call   600 <free>
 738:	83 c4 10             	add    $0x10,%esp
  return freep;
 73b:	a1 98 0a 00 00       	mov    0xa98,%eax
}
 740:	c9                   	leave  
 741:	c3                   	ret    

00000742 <malloc>:

void*
malloc(uint nbytes)
{
 742:	55                   	push   %ebp
 743:	89 e5                	mov    %esp,%ebp
 745:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	83 c0 07             	add    $0x7,%eax
 74e:	c1 e8 03             	shr    $0x3,%eax
 751:	83 c0 01             	add    $0x1,%eax
 754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 757:	a1 98 0a 00 00       	mov    0xa98,%eax
 75c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 75f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 763:	75 23                	jne    788 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 765:	c7 45 f0 90 0a 00 00 	movl   $0xa90,-0x10(%ebp)
 76c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76f:	a3 98 0a 00 00       	mov    %eax,0xa98
 774:	a1 98 0a 00 00       	mov    0xa98,%eax
 779:	a3 90 0a 00 00       	mov    %eax,0xa90
    base.s.size = 0;
 77e:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 785:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	8b 00                	mov    (%eax),%eax
 78d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 799:	72 4d                	jb     7e8 <malloc+0xa6>
      if(p->s.size == nunits)
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a4:	75 0c                	jne    7b2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 10                	mov    (%eax),%edx
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	89 10                	mov    %edx,(%eax)
 7b0:	eb 26                	jmp    7d8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7bb:	89 c2                	mov    %eax,%edx
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	c1 e0 03             	shl    $0x3,%eax
 7cc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7db:	a3 98 0a 00 00       	mov    %eax,0xa98
      return (void*)(p + 1);
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	83 c0 08             	add    $0x8,%eax
 7e6:	eb 3b                	jmp    823 <malloc+0xe1>
    }
    if(p == freep)
 7e8:	a1 98 0a 00 00       	mov    0xa98,%eax
 7ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f0:	75 1e                	jne    810 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7f2:	83 ec 0c             	sub    $0xc,%esp
 7f5:	ff 75 ec             	pushl  -0x14(%ebp)
 7f8:	e8 e5 fe ff ff       	call   6e2 <morecore>
 7fd:	83 c4 10             	add    $0x10,%esp
 800:	89 45 f4             	mov    %eax,-0xc(%ebp)
 803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 807:	75 07                	jne    810 <malloc+0xce>
        return 0;
 809:	b8 00 00 00 00       	mov    $0x0,%eax
 80e:	eb 13                	jmp    823 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	89 45 f0             	mov    %eax,-0x10(%ebp)
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 81e:	e9 6d ff ff ff       	jmp    790 <malloc+0x4e>
}
 823:	c9                   	leave  
 824:	c3                   	ret    