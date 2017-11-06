
_testsleeplist:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  sleep(10000);
  11:	83 ec 0c             	sub    $0xc,%esp
  14:	68 10 27 00 00       	push   $0x2710
  19:	e8 34 03 00 00       	call   352 <sleep>
  1e:	83 c4 10             	add    $0x10,%esp
  exit();
  21:	e8 9c 02 00 00       	call   2c2 <exit>

00000026 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  26:	55                   	push   %ebp
  27:	89 e5                	mov    %esp,%ebp
  29:	57                   	push   %edi
  2a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2e:	8b 55 10             	mov    0x10(%ebp),%edx
  31:	8b 45 0c             	mov    0xc(%ebp),%eax
  34:	89 cb                	mov    %ecx,%ebx
  36:	89 df                	mov    %ebx,%edi
  38:	89 d1                	mov    %edx,%ecx
  3a:	fc                   	cld    
  3b:	f3 aa                	rep stos %al,%es:(%edi)
  3d:	89 ca                	mov    %ecx,%edx
  3f:	89 fb                	mov    %edi,%ebx
  41:	89 5d 08             	mov    %ebx,0x8(%ebp)
  44:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  47:	90                   	nop
  48:	5b                   	pop    %ebx
  49:	5f                   	pop    %edi
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  52:	8b 45 08             	mov    0x8(%ebp),%eax
  55:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  58:	90                   	nop
  59:	8b 45 08             	mov    0x8(%ebp),%eax
  5c:	8d 50 01             	lea    0x1(%eax),%edx
  5f:	89 55 08             	mov    %edx,0x8(%ebp)
  62:	8b 55 0c             	mov    0xc(%ebp),%edx
  65:	8d 4a 01             	lea    0x1(%edx),%ecx
  68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6b:	0f b6 12             	movzbl (%edx),%edx
  6e:	88 10                	mov    %dl,(%eax)
  70:	0f b6 00             	movzbl (%eax),%eax
  73:	84 c0                	test   %al,%al
  75:	75 e2                	jne    59 <strcpy+0xd>
    ;
  return os;
  77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7a:	c9                   	leave  
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7f:	eb 08                	jmp    89 <strcmp+0xd>
    p++, q++;
  81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  85:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 10                	je     a3 <strcmp+0x27>
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	0f b6 10             	movzbl (%eax),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	0f b6 00             	movzbl (%eax),%eax
  9f:	38 c2                	cmp    %al,%dl
  a1:	74 de                	je     81 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	0f b6 d0             	movzbl %al,%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	0f b6 c0             	movzbl %al,%eax
  b5:	29 c2                	sub    %eax,%edx
  b7:	89 d0                	mov    %edx,%eax
}
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    

000000bb <strlen>:

uint
strlen(char *s)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c8:	eb 04                	jmp    ce <strlen+0x13>
  ca:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	01 d0                	add    %edx,%eax
  d6:	0f b6 00             	movzbl (%eax),%eax
  d9:	84 c0                	test   %al,%al
  db:	75 ed                	jne    ca <strlen+0xf>
    ;
  return n;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e5:	8b 45 10             	mov    0x10(%ebp),%eax
  e8:	50                   	push   %eax
  e9:	ff 75 0c             	pushl  0xc(%ebp)
  ec:	ff 75 08             	pushl  0x8(%ebp)
  ef:	e8 32 ff ff ff       	call   26 <stosb>
  f4:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 108:	eb 14                	jmp    11e <strchr+0x22>
    if(*s == c)
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	0f b6 00             	movzbl (%eax),%eax
 110:	3a 45 fc             	cmp    -0x4(%ebp),%al
 113:	75 05                	jne    11a <strchr+0x1e>
      return (char*)s;
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	eb 13                	jmp    12d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	84 c0                	test   %al,%al
 126:	75 e2                	jne    10a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 128:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <gets>:

char*
gets(char *buf, int max)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13c:	eb 42                	jmp    180 <gets+0x51>
    cc = read(0, &c, 1);
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	6a 01                	push   $0x1
 143:	8d 45 ef             	lea    -0x11(%ebp),%eax
 146:	50                   	push   %eax
 147:	6a 00                	push   $0x0
 149:	e8 8c 01 00 00       	call   2da <read>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 154:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 158:	7e 33                	jle    18d <gets+0x5e>
      break;
    buf[i++] = c;
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 50 01             	lea    0x1(%eax),%edx
 160:	89 55 f4             	mov    %edx,-0xc(%ebp)
 163:	89 c2                	mov    %eax,%edx
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	01 c2                	add    %eax,%edx
 16a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	3c 0a                	cmp    $0xa,%al
 176:	74 16                	je     18e <gets+0x5f>
 178:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17c:	3c 0d                	cmp    $0xd,%al
 17e:	74 0e                	je     18e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	8b 45 f4             	mov    -0xc(%ebp),%eax
 183:	83 c0 01             	add    $0x1,%eax
 186:	3b 45 0c             	cmp    0xc(%ebp),%eax
 189:	7c b3                	jl     13e <gets+0xf>
 18b:	eb 01                	jmp    18e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	01 d0                	add    %edx,%eax
 196:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <stat>:

int
stat(char *n, struct stat *st)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	6a 00                	push   $0x0
 1a9:	ff 75 08             	pushl  0x8(%ebp)
 1ac:	e8 51 01 00 00       	call   302 <open>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bb:	79 07                	jns    1c4 <stat+0x26>
    return -1;
 1bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c2:	eb 25                	jmp    1e9 <stat+0x4b>
  r = fstat(fd, st);
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	ff 75 0c             	pushl  0xc(%ebp)
 1ca:	ff 75 f4             	pushl  -0xc(%ebp)
 1cd:	e8 48 01 00 00       	call   31a <fstat>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	ff 75 f4             	pushl  -0xc(%ebp)
 1de:	e8 07 01 00 00       	call   2ea <close>
 1e3:	83 c4 10             	add    $0x10,%esp
  return r;
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <atoi>:

int
atoi(const char *s)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1f8:	eb 04                	jmp    1fe <atoi+0x13>
 1fa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	0f b6 00             	movzbl (%eax),%eax
 204:	3c 20                	cmp    $0x20,%al
 206:	74 f2                	je     1fa <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	3c 2d                	cmp    $0x2d,%al
 210:	75 07                	jne    219 <atoi+0x2e>
 212:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 217:	eb 05                	jmp    21e <atoi+0x33>
 219:	b8 01 00 00 00       	mov    $0x1,%eax
 21e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	3c 2b                	cmp    $0x2b,%al
 229:	74 0a                	je     235 <atoi+0x4a>
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 00             	movzbl (%eax),%eax
 231:	3c 2d                	cmp    $0x2d,%al
 233:	75 2b                	jne    260 <atoi+0x75>
    s++;
 235:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 239:	eb 25                	jmp    260 <atoi+0x75>
    n = n*10 + *s++ - '0';
 23b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23e:	89 d0                	mov    %edx,%eax
 240:	c1 e0 02             	shl    $0x2,%eax
 243:	01 d0                	add    %edx,%eax
 245:	01 c0                	add    %eax,%eax
 247:	89 c1                	mov    %eax,%ecx
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	8d 50 01             	lea    0x1(%eax),%edx
 24f:	89 55 08             	mov    %edx,0x8(%ebp)
 252:	0f b6 00             	movzbl (%eax),%eax
 255:	0f be c0             	movsbl %al,%eax
 258:	01 c8                	add    %ecx,%eax
 25a:	83 e8 30             	sub    $0x30,%eax
 25d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	3c 2f                	cmp    $0x2f,%al
 268:	7e 0a                	jle    274 <atoi+0x89>
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	3c 39                	cmp    $0x39,%al
 272:	7e c7                	jle    23b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 274:	8b 45 f8             	mov    -0x8(%ebp),%eax
 277:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 27b:	c9                   	leave  
 27c:	c3                   	ret    

0000027d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 28f:	eb 17                	jmp    2a8 <memmove+0x2b>
    *dst++ = *src++;
 291:	8b 45 fc             	mov    -0x4(%ebp),%eax
 294:	8d 50 01             	lea    0x1(%eax),%edx
 297:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a3:	0f b6 12             	movzbl (%edx),%edx
 2a6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a8:	8b 45 10             	mov    0x10(%ebp),%eax
 2ab:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ae:	89 55 10             	mov    %edx,0x10(%ebp)
 2b1:	85 c0                	test   %eax,%eax
 2b3:	7f dc                	jg     291 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ba:	b8 01 00 00 00       	mov    $0x1,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <exit>:
SYSCALL(exit)
 2c2:	b8 02 00 00 00       	mov    $0x2,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <wait>:
SYSCALL(wait)
 2ca:	b8 03 00 00 00       	mov    $0x3,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <pipe>:
SYSCALL(pipe)
 2d2:	b8 04 00 00 00       	mov    $0x4,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <read>:
SYSCALL(read)
 2da:	b8 05 00 00 00       	mov    $0x5,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <write>:
SYSCALL(write)
 2e2:	b8 10 00 00 00       	mov    $0x10,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <close>:
SYSCALL(close)
 2ea:	b8 15 00 00 00       	mov    $0x15,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <kill>:
SYSCALL(kill)
 2f2:	b8 06 00 00 00       	mov    $0x6,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <exec>:
SYSCALL(exec)
 2fa:	b8 07 00 00 00       	mov    $0x7,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <open>:
SYSCALL(open)
 302:	b8 0f 00 00 00       	mov    $0xf,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mknod>:
SYSCALL(mknod)
 30a:	b8 11 00 00 00       	mov    $0x11,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <unlink>:
SYSCALL(unlink)
 312:	b8 12 00 00 00       	mov    $0x12,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <fstat>:
SYSCALL(fstat)
 31a:	b8 08 00 00 00       	mov    $0x8,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <link>:
SYSCALL(link)
 322:	b8 13 00 00 00       	mov    $0x13,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mkdir>:
SYSCALL(mkdir)
 32a:	b8 14 00 00 00       	mov    $0x14,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <chdir>:
SYSCALL(chdir)
 332:	b8 09 00 00 00       	mov    $0x9,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <dup>:
SYSCALL(dup)
 33a:	b8 0a 00 00 00       	mov    $0xa,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <getpid>:
SYSCALL(getpid)
 342:	b8 0b 00 00 00       	mov    $0xb,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sbrk>:
SYSCALL(sbrk)
 34a:	b8 0c 00 00 00       	mov    $0xc,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <sleep>:
SYSCALL(sleep)
 352:	b8 0d 00 00 00       	mov    $0xd,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <uptime>:
SYSCALL(uptime)
 35a:	b8 0e 00 00 00       	mov    $0xe,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <halt>:
SYSCALL(halt)
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <date>:
SYSCALL(date)
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getuid>:
SYSCALL(getuid)
 372:	b8 18 00 00 00       	mov    $0x18,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <getgid>:
SYSCALL(getgid)
 37a:	b8 19 00 00 00       	mov    $0x19,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getppid>:
SYSCALL(getppid)
 382:	b8 1a 00 00 00       	mov    $0x1a,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <setuid>:
SYSCALL(setuid)
 38a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <setgid>:
SYSCALL(setgid)
 392:	b8 1c 00 00 00       	mov    $0x1c,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <getprocs>:
SYSCALL(getprocs)
 39a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <setpriority>:
SYSCALL(setpriority)
 3a2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3aa:	55                   	push   %ebp
 3ab:	89 e5                	mov    %esp,%ebp
 3ad:	83 ec 18             	sub    $0x18,%esp
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b6:	83 ec 04             	sub    $0x4,%esp
 3b9:	6a 01                	push   $0x1
 3bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3be:	50                   	push   %eax
 3bf:	ff 75 08             	pushl  0x8(%ebp)
 3c2:	e8 1b ff ff ff       	call   2e2 <write>
 3c7:	83 c4 10             	add    $0x10,%esp
}
 3ca:	90                   	nop
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    

000003cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	53                   	push   %ebx
 3d1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3db:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3df:	74 17                	je     3f8 <printint+0x2b>
 3e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e5:	79 11                	jns    3f8 <printint+0x2b>
    neg = 1;
 3e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	f7 d8                	neg    %eax
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f6:	eb 06                	jmp    3fe <printint+0x31>
  } else {
    x = xx;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 405:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 408:	8d 41 01             	lea    0x1(%ecx),%eax
 40b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 40e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 411:	8b 45 ec             	mov    -0x14(%ebp),%eax
 414:	ba 00 00 00 00       	mov    $0x0,%edx
 419:	f7 f3                	div    %ebx
 41b:	89 d0                	mov    %edx,%eax
 41d:	0f b6 80 88 0a 00 00 	movzbl 0xa88(%eax),%eax
 424:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 428:	8b 5d 10             	mov    0x10(%ebp),%ebx
 42b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42e:	ba 00 00 00 00       	mov    $0x0,%edx
 433:	f7 f3                	div    %ebx
 435:	89 45 ec             	mov    %eax,-0x14(%ebp)
 438:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43c:	75 c7                	jne    405 <printint+0x38>
  if(neg)
 43e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 442:	74 2d                	je     471 <printint+0xa4>
    buf[i++] = '-';
 444:	8b 45 f4             	mov    -0xc(%ebp),%eax
 447:	8d 50 01             	lea    0x1(%eax),%edx
 44a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 44d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 452:	eb 1d                	jmp    471 <printint+0xa4>
    putc(fd, buf[i]);
 454:	8d 55 dc             	lea    -0x24(%ebp),%edx
 457:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45a:	01 d0                	add    %edx,%eax
 45c:	0f b6 00             	movzbl (%eax),%eax
 45f:	0f be c0             	movsbl %al,%eax
 462:	83 ec 08             	sub    $0x8,%esp
 465:	50                   	push   %eax
 466:	ff 75 08             	pushl  0x8(%ebp)
 469:	e8 3c ff ff ff       	call   3aa <putc>
 46e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 471:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 479:	79 d9                	jns    454 <printint+0x87>
    putc(fd, buf[i]);
}
 47b:	90                   	nop
 47c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 47f:	c9                   	leave  
 480:	c3                   	ret    

00000481 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
 484:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 487:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48e:	8d 45 0c             	lea    0xc(%ebp),%eax
 491:	83 c0 04             	add    $0x4,%eax
 494:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49e:	e9 59 01 00 00       	jmp    5fc <printf+0x17b>
    c = fmt[i] & 0xff;
 4a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a9:	01 d0                	add    %edx,%eax
 4ab:	0f b6 00             	movzbl (%eax),%eax
 4ae:	0f be c0             	movsbl %al,%eax
 4b1:	25 ff 00 00 00       	and    $0xff,%eax
 4b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bd:	75 2c                	jne    4eb <printf+0x6a>
      if(c == '%'){
 4bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c3:	75 0c                	jne    4d1 <printf+0x50>
        state = '%';
 4c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4cc:	e9 27 01 00 00       	jmp    5f8 <printf+0x177>
      } else {
        putc(fd, c);
 4d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d4:	0f be c0             	movsbl %al,%eax
 4d7:	83 ec 08             	sub    $0x8,%esp
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 c7 fe ff ff       	call   3aa <putc>
 4e3:	83 c4 10             	add    $0x10,%esp
 4e6:	e9 0d 01 00 00       	jmp    5f8 <printf+0x177>
      }
    } else if(state == '%'){
 4eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ef:	0f 85 03 01 00 00    	jne    5f8 <printf+0x177>
      if(c == 'd'){
 4f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f9:	75 1e                	jne    519 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	6a 01                	push   $0x1
 502:	6a 0a                	push   $0xa
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 c0 fe ff ff       	call   3cd <printint>
 50d:	83 c4 10             	add    $0x10,%esp
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 d8 00 00 00       	jmp    5f1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 519:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51d:	74 06                	je     525 <printf+0xa4>
 51f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 523:	75 1e                	jne    543 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	6a 00                	push   $0x0
 52c:	6a 10                	push   $0x10
 52e:	50                   	push   %eax
 52f:	ff 75 08             	pushl  0x8(%ebp)
 532:	e8 96 fe ff ff       	call   3cd <printint>
 537:	83 c4 10             	add    $0x10,%esp
        ap++;
 53a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53e:	e9 ae 00 00 00       	jmp    5f1 <printf+0x170>
      } else if(c == 's'){
 543:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 547:	75 43                	jne    58c <printf+0x10b>
        s = (char*)*ap;
 549:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54c:	8b 00                	mov    (%eax),%eax
 54e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 551:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 559:	75 25                	jne    580 <printf+0xff>
          s = "(null)";
 55b:	c7 45 f4 37 08 00 00 	movl   $0x837,-0xc(%ebp)
        while(*s != 0){
 562:	eb 1c                	jmp    580 <printf+0xff>
          putc(fd, *s);
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	0f b6 00             	movzbl (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 31 fe ff ff       	call   3aa <putc>
 579:	83 c4 10             	add    $0x10,%esp
          s++;
 57c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	84 c0                	test   %al,%al
 588:	75 da                	jne    564 <printf+0xe3>
 58a:	eb 65                	jmp    5f1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 58c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 590:	75 1d                	jne    5af <printf+0x12e>
        putc(fd, *ap);
 592:	8b 45 e8             	mov    -0x18(%ebp),%eax
 595:	8b 00                	mov    (%eax),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	83 ec 08             	sub    $0x8,%esp
 59d:	50                   	push   %eax
 59e:	ff 75 08             	pushl  0x8(%ebp)
 5a1:	e8 04 fe ff ff       	call   3aa <putc>
 5a6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ad:	eb 42                	jmp    5f1 <printf+0x170>
      } else if(c == '%'){
 5af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b3:	75 17                	jne    5cc <printf+0x14b>
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 e3 fd ff ff       	call   3aa <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
 5ca:	eb 25                	jmp    5f1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	6a 25                	push   $0x25
 5d1:	ff 75 08             	pushl  0x8(%ebp)
 5d4:	e8 d1 fd ff ff       	call   3aa <putc>
 5d9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 bc fd ff ff       	call   3aa <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5fc:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 602:	01 d0                	add    %edx,%eax
 604:	0f b6 00             	movzbl (%eax),%eax
 607:	84 c0                	test   %al,%al
 609:	0f 85 94 fe ff ff    	jne    4a3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 60f:	90                   	nop
 610:	c9                   	leave  
 611:	c3                   	ret    

00000612 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	83 e8 08             	sub    $0x8,%eax
 61e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 a4 0a 00 00       	mov    0xaa4,%eax
 626:	89 45 fc             	mov    %eax,-0x4(%ebp)
 629:	eb 24                	jmp    64f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 633:	77 12                	ja     647 <free+0x35>
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63b:	77 24                	ja     661 <free+0x4f>
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 645:	77 1a                	ja     661 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 655:	76 d4                	jbe    62b <free+0x19>
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	76 ca                	jbe    62b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	8b 40 04             	mov    0x4(%eax),%eax
 667:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	01 c2                	add    %eax,%edx
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	39 c2                	cmp    %eax,%edx
 67a:	75 24                	jne    6a0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	8b 50 04             	mov    0x4(%eax),%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	8b 40 04             	mov    0x4(%eax),%eax
 68a:	01 c2                	add    %eax,%edx
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	8b 10                	mov    (%eax),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	89 10                	mov    %edx,(%eax)
 69e:	eb 0a                	jmp    6aa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 10                	mov    (%eax),%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	01 d0                	add    %edx,%eax
 6bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bf:	75 20                	jne    6e1 <free+0xcf>
    p->s.size += bp->s.size;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 50 04             	mov    0x4(%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	01 c2                	add    %eax,%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 10                	mov    (%eax),%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 10                	mov    %edx,(%eax)
 6df:	eb 08                	jmp    6e9 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	a3 a4 0a 00 00       	mov    %eax,0xaa4
}
 6f1:	90                   	nop
 6f2:	c9                   	leave  
 6f3:	c3                   	ret    

000006f4 <morecore>:

static Header*
morecore(uint nu)
{
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
 6f7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6fa:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 701:	77 07                	ja     70a <morecore+0x16>
    nu = 4096;
 703:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	c1 e0 03             	shl    $0x3,%eax
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	50                   	push   %eax
 714:	e8 31 fc ff ff       	call   34a <sbrk>
 719:	83 c4 10             	add    $0x10,%esp
 71c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 71f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 723:	75 07                	jne    72c <morecore+0x38>
    return 0;
 725:	b8 00 00 00 00       	mov    $0x0,%eax
 72a:	eb 26                	jmp    752 <morecore+0x5e>
  hp = (Header*)p;
 72c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 732:	8b 45 f0             	mov    -0x10(%ebp),%eax
 735:	8b 55 08             	mov    0x8(%ebp),%edx
 738:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	83 c0 08             	add    $0x8,%eax
 741:	83 ec 0c             	sub    $0xc,%esp
 744:	50                   	push   %eax
 745:	e8 c8 fe ff ff       	call   612 <free>
 74a:	83 c4 10             	add    $0x10,%esp
  return freep;
 74d:	a1 a4 0a 00 00       	mov    0xaa4,%eax
}
 752:	c9                   	leave  
 753:	c3                   	ret    

00000754 <malloc>:

void*
malloc(uint nbytes)
{
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75a:	8b 45 08             	mov    0x8(%ebp),%eax
 75d:	83 c0 07             	add    $0x7,%eax
 760:	c1 e8 03             	shr    $0x3,%eax
 763:	83 c0 01             	add    $0x1,%eax
 766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 769:	a1 a4 0a 00 00       	mov    0xaa4,%eax
 76e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 771:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 775:	75 23                	jne    79a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 777:	c7 45 f0 9c 0a 00 00 	movl   $0xa9c,-0x10(%ebp)
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	a3 a4 0a 00 00       	mov    %eax,0xaa4
 786:	a1 a4 0a 00 00       	mov    0xaa4,%eax
 78b:	a3 9c 0a 00 00       	mov    %eax,0xa9c
    base.s.size = 0;
 790:	c7 05 a0 0a 00 00 00 	movl   $0x0,0xaa0
 797:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ab:	72 4d                	jb     7fa <malloc+0xa6>
      if(p->s.size == nunits)
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b6:	75 0c                	jne    7c4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	89 10                	mov    %edx,(%eax)
 7c2:	eb 26                	jmp    7ea <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7cd:	89 c2                	mov    %eax,%edx
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	c1 e0 03             	shl    $0x3,%eax
 7de:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	a3 a4 0a 00 00       	mov    %eax,0xaa4
      return (void*)(p + 1);
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	83 c0 08             	add    $0x8,%eax
 7f8:	eb 3b                	jmp    835 <malloc+0xe1>
    }
    if(p == freep)
 7fa:	a1 a4 0a 00 00       	mov    0xaa4,%eax
 7ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 802:	75 1e                	jne    822 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 804:	83 ec 0c             	sub    $0xc,%esp
 807:	ff 75 ec             	pushl  -0x14(%ebp)
 80a:	e8 e5 fe ff ff       	call   6f4 <morecore>
 80f:	83 c4 10             	add    $0x10,%esp
 812:	89 45 f4             	mov    %eax,-0xc(%ebp)
 815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 819:	75 07                	jne    822 <malloc+0xce>
        return 0;
 81b:	b8 00 00 00 00       	mov    $0x0,%eax
 820:	eb 13                	jmp    835 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	89 45 f0             	mov    %eax,-0x10(%ebp)
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 830:	e9 6d ff ff ff       	jmp    7a2 <malloc+0x4e>
}
 835:	c9                   	leave  
 836:	c3                   	ret    
