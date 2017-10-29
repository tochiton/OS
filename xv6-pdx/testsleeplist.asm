
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

000003a2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	83 ec 18             	sub    $0x18,%esp
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ae:	83 ec 04             	sub    $0x4,%esp
 3b1:	6a 01                	push   $0x1
 3b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b6:	50                   	push   %eax
 3b7:	ff 75 08             	pushl  0x8(%ebp)
 3ba:	e8 23 ff ff ff       	call   2e2 <write>
 3bf:	83 c4 10             	add    $0x10,%esp
}
 3c2:	90                   	nop
 3c3:	c9                   	leave  
 3c4:	c3                   	ret    

000003c5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c5:	55                   	push   %ebp
 3c6:	89 e5                	mov    %esp,%ebp
 3c8:	53                   	push   %ebx
 3c9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d7:	74 17                	je     3f0 <printint+0x2b>
 3d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3dd:	79 11                	jns    3f0 <printint+0x2b>
    neg = 1;
 3df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	f7 d8                	neg    %eax
 3eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ee:	eb 06                	jmp    3f6 <printint+0x31>
  } else {
    x = xx;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 400:	8d 41 01             	lea    0x1(%ecx),%eax
 403:	89 45 f4             	mov    %eax,-0xc(%ebp)
 406:	8b 5d 10             	mov    0x10(%ebp),%ebx
 409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
 411:	f7 f3                	div    %ebx
 413:	89 d0                	mov    %edx,%eax
 415:	0f b6 80 80 0a 00 00 	movzbl 0xa80(%eax),%eax
 41c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 420:	8b 5d 10             	mov    0x10(%ebp),%ebx
 423:	8b 45 ec             	mov    -0x14(%ebp),%eax
 426:	ba 00 00 00 00       	mov    $0x0,%edx
 42b:	f7 f3                	div    %ebx
 42d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 430:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 434:	75 c7                	jne    3fd <printint+0x38>
  if(neg)
 436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43a:	74 2d                	je     469 <printint+0xa4>
    buf[i++] = '-';
 43c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43f:	8d 50 01             	lea    0x1(%eax),%edx
 442:	89 55 f4             	mov    %edx,-0xc(%ebp)
 445:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 44a:	eb 1d                	jmp    469 <printint+0xa4>
    putc(fd, buf[i]);
 44c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	0f be c0             	movsbl %al,%eax
 45a:	83 ec 08             	sub    $0x8,%esp
 45d:	50                   	push   %eax
 45e:	ff 75 08             	pushl  0x8(%ebp)
 461:	e8 3c ff ff ff       	call   3a2 <putc>
 466:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 469:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 471:	79 d9                	jns    44c <printint+0x87>
    putc(fd, buf[i]);
}
 473:	90                   	nop
 474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 486:	8d 45 0c             	lea    0xc(%ebp),%eax
 489:	83 c0 04             	add    $0x4,%eax
 48c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 496:	e9 59 01 00 00       	jmp    5f4 <printf+0x17b>
    c = fmt[i] & 0xff;
 49b:	8b 55 0c             	mov    0xc(%ebp),%edx
 49e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a1:	01 d0                	add    %edx,%eax
 4a3:	0f b6 00             	movzbl (%eax),%eax
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	25 ff 00 00 00       	and    $0xff,%eax
 4ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b5:	75 2c                	jne    4e3 <printf+0x6a>
      if(c == '%'){
 4b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4bb:	75 0c                	jne    4c9 <printf+0x50>
        state = '%';
 4bd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c4:	e9 27 01 00 00       	jmp    5f0 <printf+0x177>
      } else {
        putc(fd, c);
 4c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4cc:	0f be c0             	movsbl %al,%eax
 4cf:	83 ec 08             	sub    $0x8,%esp
 4d2:	50                   	push   %eax
 4d3:	ff 75 08             	pushl  0x8(%ebp)
 4d6:	e8 c7 fe ff ff       	call   3a2 <putc>
 4db:	83 c4 10             	add    $0x10,%esp
 4de:	e9 0d 01 00 00       	jmp    5f0 <printf+0x177>
      }
    } else if(state == '%'){
 4e3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e7:	0f 85 03 01 00 00    	jne    5f0 <printf+0x177>
      if(c == 'd'){
 4ed:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f1:	75 1e                	jne    511 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f6:	8b 00                	mov    (%eax),%eax
 4f8:	6a 01                	push   $0x1
 4fa:	6a 0a                	push   $0xa
 4fc:	50                   	push   %eax
 4fd:	ff 75 08             	pushl  0x8(%ebp)
 500:	e8 c0 fe ff ff       	call   3c5 <printint>
 505:	83 c4 10             	add    $0x10,%esp
        ap++;
 508:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50c:	e9 d8 00 00 00       	jmp    5e9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 511:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 515:	74 06                	je     51d <printf+0xa4>
 517:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51b:	75 1e                	jne    53b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 51d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 520:	8b 00                	mov    (%eax),%eax
 522:	6a 00                	push   $0x0
 524:	6a 10                	push   $0x10
 526:	50                   	push   %eax
 527:	ff 75 08             	pushl  0x8(%ebp)
 52a:	e8 96 fe ff ff       	call   3c5 <printint>
 52f:	83 c4 10             	add    $0x10,%esp
        ap++;
 532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 536:	e9 ae 00 00 00       	jmp    5e9 <printf+0x170>
      } else if(c == 's'){
 53b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 53f:	75 43                	jne    584 <printf+0x10b>
        s = (char*)*ap;
 541:	8b 45 e8             	mov    -0x18(%ebp),%eax
 544:	8b 00                	mov    (%eax),%eax
 546:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 551:	75 25                	jne    578 <printf+0xff>
          s = "(null)";
 553:	c7 45 f4 2f 08 00 00 	movl   $0x82f,-0xc(%ebp)
        while(*s != 0){
 55a:	eb 1c                	jmp    578 <printf+0xff>
          putc(fd, *s);
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	0f be c0             	movsbl %al,%eax
 565:	83 ec 08             	sub    $0x8,%esp
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 31 fe ff ff       	call   3a2 <putc>
 571:	83 c4 10             	add    $0x10,%esp
          s++;
 574:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	0f b6 00             	movzbl (%eax),%eax
 57e:	84 c0                	test   %al,%al
 580:	75 da                	jne    55c <printf+0xe3>
 582:	eb 65                	jmp    5e9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 584:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 588:	75 1d                	jne    5a7 <printf+0x12e>
        putc(fd, *ap);
 58a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58d:	8b 00                	mov    (%eax),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	83 ec 08             	sub    $0x8,%esp
 595:	50                   	push   %eax
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 04 fe ff ff       	call   3a2 <putc>
 59e:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a5:	eb 42                	jmp    5e9 <printf+0x170>
      } else if(c == '%'){
 5a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ab:	75 17                	jne    5c4 <printf+0x14b>
        putc(fd, c);
 5ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 ec 08             	sub    $0x8,%esp
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 e3 fd ff ff       	call   3a2 <putc>
 5bf:	83 c4 10             	add    $0x10,%esp
 5c2:	eb 25                	jmp    5e9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c4:	83 ec 08             	sub    $0x8,%esp
 5c7:	6a 25                	push   $0x25
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 d1 fd ff ff       	call   3a2 <putc>
 5d1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d7:	0f be c0             	movsbl %al,%eax
 5da:	83 ec 08             	sub    $0x8,%esp
 5dd:	50                   	push   %eax
 5de:	ff 75 08             	pushl  0x8(%ebp)
 5e1:	e8 bc fd ff ff       	call   3a2 <putc>
 5e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fa:	01 d0                	add    %edx,%eax
 5fc:	0f b6 00             	movzbl (%eax),%eax
 5ff:	84 c0                	test   %al,%al
 601:	0f 85 94 fe ff ff    	jne    49b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 607:	90                   	nop
 608:	c9                   	leave  
 609:	c3                   	ret    

0000060a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 610:	8b 45 08             	mov    0x8(%ebp),%eax
 613:	83 e8 08             	sub    $0x8,%eax
 616:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 61e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 621:	eb 24                	jmp    647 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	77 12                	ja     63f <free+0x35>
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 633:	77 24                	ja     659 <free+0x4f>
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63d:	77 1a                	ja     659 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	89 45 fc             	mov    %eax,-0x4(%ebp)
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64d:	76 d4                	jbe    623 <free+0x19>
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 657:	76 ca                	jbe    623 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	8b 40 04             	mov    0x4(%eax),%eax
 65f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	01 c2                	add    %eax,%edx
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	39 c2                	cmp    %eax,%edx
 672:	75 24                	jne    698 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	8b 50 04             	mov    0x4(%eax),%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	01 c2                	add    %eax,%edx
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	8b 10                	mov    (%eax),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	89 10                	mov    %edx,(%eax)
 696:	eb 0a                	jmp    6a2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 10                	mov    (%eax),%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 40 04             	mov    0x4(%eax),%eax
 6a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	01 d0                	add    %edx,%eax
 6b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b7:	75 20                	jne    6d9 <free+0xcf>
    p->s.size += bp->s.size;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 50 04             	mov    0x4(%eax),%edx
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	8b 10                	mov    (%eax),%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	89 10                	mov    %edx,(%eax)
 6d7:	eb 08                	jmp    6e1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6df:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	a3 9c 0a 00 00       	mov    %eax,0xa9c
}
 6e9:	90                   	nop
 6ea:	c9                   	leave  
 6eb:	c3                   	ret    

000006ec <morecore>:

static Header*
morecore(uint nu)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f9:	77 07                	ja     702 <morecore+0x16>
    nu = 4096;
 6fb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	c1 e0 03             	shl    $0x3,%eax
 708:	83 ec 0c             	sub    $0xc,%esp
 70b:	50                   	push   %eax
 70c:	e8 39 fc ff ff       	call   34a <sbrk>
 711:	83 c4 10             	add    $0x10,%esp
 714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 717:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71b:	75 07                	jne    724 <morecore+0x38>
    return 0;
 71d:	b8 00 00 00 00       	mov    $0x0,%eax
 722:	eb 26                	jmp    74a <morecore+0x5e>
  hp = (Header*)p;
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	8b 55 08             	mov    0x8(%ebp),%edx
 730:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	83 c0 08             	add    $0x8,%eax
 739:	83 ec 0c             	sub    $0xc,%esp
 73c:	50                   	push   %eax
 73d:	e8 c8 fe ff ff       	call   60a <free>
 742:	83 c4 10             	add    $0x10,%esp
  return freep;
 745:	a1 9c 0a 00 00       	mov    0xa9c,%eax
}
 74a:	c9                   	leave  
 74b:	c3                   	ret    

0000074c <malloc>:

void*
malloc(uint nbytes)
{
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	83 c0 07             	add    $0x7,%eax
 758:	c1 e8 03             	shr    $0x3,%eax
 75b:	83 c0 01             	add    $0x1,%eax
 75e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 761:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 766:	89 45 f0             	mov    %eax,-0x10(%ebp)
 769:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76d:	75 23                	jne    792 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76f:	c7 45 f0 94 0a 00 00 	movl   $0xa94,-0x10(%ebp)
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	a3 9c 0a 00 00       	mov    %eax,0xa9c
 77e:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 783:	a3 94 0a 00 00       	mov    %eax,0xa94
    base.s.size = 0;
 788:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 78f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	8b 40 04             	mov    0x4(%eax),%eax
 7a0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a3:	72 4d                	jb     7f2 <malloc+0xa6>
      if(p->s.size == nunits)
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8b 40 04             	mov    0x4(%eax),%eax
 7ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ae:	75 0c                	jne    7bc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 10                	mov    (%eax),%edx
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	89 10                	mov    %edx,(%eax)
 7ba:	eb 26                	jmp    7e2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 40 04             	mov    0x4(%eax),%eax
 7c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c5:	89 c2                	mov    %eax,%edx
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	c1 e0 03             	shl    $0x3,%eax
 7d6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7df:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e5:	a3 9c 0a 00 00       	mov    %eax,0xa9c
      return (void*)(p + 1);
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	83 c0 08             	add    $0x8,%eax
 7f0:	eb 3b                	jmp    82d <malloc+0xe1>
    }
    if(p == freep)
 7f2:	a1 9c 0a 00 00       	mov    0xa9c,%eax
 7f7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7fa:	75 1e                	jne    81a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7fc:	83 ec 0c             	sub    $0xc,%esp
 7ff:	ff 75 ec             	pushl  -0x14(%ebp)
 802:	e8 e5 fe ff ff       	call   6ec <morecore>
 807:	83 c4 10             	add    $0x10,%esp
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 811:	75 07                	jne    81a <malloc+0xce>
        return 0;
 813:	b8 00 00 00 00       	mov    $0x0,%eax
 818:	eb 13                	jmp    82d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 00                	mov    (%eax),%eax
 825:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 828:	e9 6d ff ff ff       	jmp    79a <malloc+0x4e>
}
 82d:	c9                   	leave  
 82e:	c3                   	ret    
