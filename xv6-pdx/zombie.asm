
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 aa 02 00 00       	call   2c0 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 34 03 00 00       	call   358 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 9c 02 00 00       	call   2c8 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 8c 01 00 00       	call   2e0 <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 51 01 00 00       	call   308 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 48 01 00 00       	call   320 <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 07 01 00 00       	call   2f0 <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1fe:	eb 04                	jmp    204 <atoi+0x13>
 200:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	3c 20                	cmp    $0x20,%al
 20c:	74 f2                	je     200 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	3c 2d                	cmp    $0x2d,%al
 216:	75 07                	jne    21f <atoi+0x2e>
 218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21d:	eb 05                	jmp    224 <atoi+0x33>
 21f:	b8 01 00 00 00       	mov    $0x1,%eax
 224:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	3c 2b                	cmp    $0x2b,%al
 22f:	74 0a                	je     23b <atoi+0x4a>
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	0f b6 00             	movzbl (%eax),%eax
 237:	3c 2d                	cmp    $0x2d,%al
 239:	75 2b                	jne    266 <atoi+0x75>
    s++;
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23f:	eb 25                	jmp    266 <atoi+0x75>
    n = n*10 + *s++ - '0';
 241:	8b 55 fc             	mov    -0x4(%ebp),%edx
 244:	89 d0                	mov    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	01 d0                	add    %edx,%eax
 24b:	01 c0                	add    %eax,%eax
 24d:	89 c1                	mov    %eax,%ecx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8d 50 01             	lea    0x1(%eax),%edx
 255:	89 55 08             	mov    %edx,0x8(%ebp)
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f be c0             	movsbl %al,%eax
 25e:	01 c8                	add    %ecx,%eax
 260:	83 e8 30             	sub    $0x30,%eax
 263:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 2f                	cmp    $0x2f,%al
 26e:	7e 0a                	jle    27a <atoi+0x89>
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	3c 39                	cmp    $0x39,%al
 278:	7e c7                	jle    241 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 27a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 27d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 295:	eb 17                	jmp    2ae <memmove+0x2b>
    *dst++ = *src++;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29a:	8d 50 01             	lea    0x1(%eax),%edx
 29d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a9:	0f b6 12             	movzbl (%edx),%edx
 2ac:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ae:	8b 45 10             	mov    0x10(%ebp),%eax
 2b1:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b4:	89 55 10             	mov    %edx,0x10(%ebp)
 2b7:	85 c0                	test   %eax,%eax
 2b9:	7f dc                	jg     297 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
SYSCALL(getpid)
 348:	b8 0b 00 00 00       	mov    $0xb,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
SYSCALL(sbrk)
 350:	b8 0c 00 00 00       	mov    $0xc,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
SYSCALL(sleep)
 358:	b8 0d 00 00 00       	mov    $0xd,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <uptime>:
SYSCALL(uptime)
 360:	b8 0e 00 00 00       	mov    $0xe,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <halt>:
SYSCALL(halt)
 368:	b8 16 00 00 00       	mov    $0x16,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <date>:
SYSCALL(date)
 370:	b8 17 00 00 00       	mov    $0x17,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getuid>:
SYSCALL(getuid)
 378:	b8 18 00 00 00       	mov    $0x18,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <getgid>:
SYSCALL(getgid)
 380:	b8 19 00 00 00       	mov    $0x19,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <getppid>:
SYSCALL(getppid)
 388:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <setuid>:
SYSCALL(setuid)
 390:	b8 1b 00 00 00       	mov    $0x1b,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <setgid>:
SYSCALL(setgid)
 398:	b8 1c 00 00 00       	mov    $0x1c,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 18             	sub    $0x18,%esp
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ac:	83 ec 04             	sub    $0x4,%esp
 3af:	6a 01                	push   $0x1
 3b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b4:	50                   	push   %eax
 3b5:	ff 75 08             	pushl  0x8(%ebp)
 3b8:	e8 2b ff ff ff       	call   2e8 <write>
 3bd:	83 c4 10             	add    $0x10,%esp
}
 3c0:	90                   	nop
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	53                   	push   %ebx
 3c7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d5:	74 17                	je     3ee <printint+0x2b>
 3d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3db:	79 11                	jns    3ee <printint+0x2b>
    neg = 1;
 3dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	f7 d8                	neg    %eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ec:	eb 06                	jmp    3f4 <printint+0x31>
  } else {
    x = xx;
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3fe:	8d 41 01             	lea    0x1(%ecx),%eax
 401:	89 45 f4             	mov    %eax,-0xc(%ebp)
 404:	8b 5d 10             	mov    0x10(%ebp),%ebx
 407:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40a:	ba 00 00 00 00       	mov    $0x0,%edx
 40f:	f7 f3                	div    %ebx
 411:	89 d0                	mov    %edx,%eax
 413:	0f b6 80 7c 0a 00 00 	movzbl 0xa7c(%eax),%eax
 41a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 41e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 421:	8b 45 ec             	mov    -0x14(%ebp),%eax
 424:	ba 00 00 00 00       	mov    $0x0,%edx
 429:	f7 f3                	div    %ebx
 42b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 432:	75 c7                	jne    3fb <printint+0x38>
  if(neg)
 434:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 438:	74 2d                	je     467 <printint+0xa4>
    buf[i++] = '-';
 43a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43d:	8d 50 01             	lea    0x1(%eax),%edx
 440:	89 55 f4             	mov    %edx,-0xc(%ebp)
 443:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 448:	eb 1d                	jmp    467 <printint+0xa4>
    putc(fd, buf[i]);
 44a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 450:	01 d0                	add    %edx,%eax
 452:	0f b6 00             	movzbl (%eax),%eax
 455:	0f be c0             	movsbl %al,%eax
 458:	83 ec 08             	sub    $0x8,%esp
 45b:	50                   	push   %eax
 45c:	ff 75 08             	pushl  0x8(%ebp)
 45f:	e8 3c ff ff ff       	call   3a0 <putc>
 464:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 467:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 46b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46f:	79 d9                	jns    44a <printint+0x87>
    putc(fd, buf[i]);
}
 471:	90                   	nop
 472:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 475:	c9                   	leave  
 476:	c3                   	ret    

00000477 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 477:	55                   	push   %ebp
 478:	89 e5                	mov    %esp,%ebp
 47a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 47d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 484:	8d 45 0c             	lea    0xc(%ebp),%eax
 487:	83 c0 04             	add    $0x4,%eax
 48a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 48d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 494:	e9 59 01 00 00       	jmp    5f2 <printf+0x17b>
    c = fmt[i] & 0xff;
 499:	8b 55 0c             	mov    0xc(%ebp),%edx
 49c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49f:	01 d0                	add    %edx,%eax
 4a1:	0f b6 00             	movzbl (%eax),%eax
 4a4:	0f be c0             	movsbl %al,%eax
 4a7:	25 ff 00 00 00       	and    $0xff,%eax
 4ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b3:	75 2c                	jne    4e1 <printf+0x6a>
      if(c == '%'){
 4b5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b9:	75 0c                	jne    4c7 <printf+0x50>
        state = '%';
 4bb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c2:	e9 27 01 00 00       	jmp    5ee <printf+0x177>
      } else {
        putc(fd, c);
 4c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ca:	0f be c0             	movsbl %al,%eax
 4cd:	83 ec 08             	sub    $0x8,%esp
 4d0:	50                   	push   %eax
 4d1:	ff 75 08             	pushl  0x8(%ebp)
 4d4:	e8 c7 fe ff ff       	call   3a0 <putc>
 4d9:	83 c4 10             	add    $0x10,%esp
 4dc:	e9 0d 01 00 00       	jmp    5ee <printf+0x177>
      }
    } else if(state == '%'){
 4e1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e5:	0f 85 03 01 00 00    	jne    5ee <printf+0x177>
      if(c == 'd'){
 4eb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ef:	75 1e                	jne    50f <printf+0x98>
        printint(fd, *ap, 10, 1);
 4f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f4:	8b 00                	mov    (%eax),%eax
 4f6:	6a 01                	push   $0x1
 4f8:	6a 0a                	push   $0xa
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	pushl  0x8(%ebp)
 4fe:	e8 c0 fe ff ff       	call   3c3 <printint>
 503:	83 c4 10             	add    $0x10,%esp
        ap++;
 506:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50a:	e9 d8 00 00 00       	jmp    5e7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 50f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 513:	74 06                	je     51b <printf+0xa4>
 515:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 519:	75 1e                	jne    539 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 51b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	6a 00                	push   $0x0
 522:	6a 10                	push   $0x10
 524:	50                   	push   %eax
 525:	ff 75 08             	pushl  0x8(%ebp)
 528:	e8 96 fe ff ff       	call   3c3 <printint>
 52d:	83 c4 10             	add    $0x10,%esp
        ap++;
 530:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 534:	e9 ae 00 00 00       	jmp    5e7 <printf+0x170>
      } else if(c == 's'){
 539:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 53d:	75 43                	jne    582 <printf+0x10b>
        s = (char*)*ap;
 53f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 542:	8b 00                	mov    (%eax),%eax
 544:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 547:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54f:	75 25                	jne    576 <printf+0xff>
          s = "(null)";
 551:	c7 45 f4 2d 08 00 00 	movl   $0x82d,-0xc(%ebp)
        while(*s != 0){
 558:	eb 1c                	jmp    576 <printf+0xff>
          putc(fd, *s);
 55a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	83 ec 08             	sub    $0x8,%esp
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 31 fe ff ff       	call   3a0 <putc>
 56f:	83 c4 10             	add    $0x10,%esp
          s++;
 572:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 576:	8b 45 f4             	mov    -0xc(%ebp),%eax
 579:	0f b6 00             	movzbl (%eax),%eax
 57c:	84 c0                	test   %al,%al
 57e:	75 da                	jne    55a <printf+0xe3>
 580:	eb 65                	jmp    5e7 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 582:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 586:	75 1d                	jne    5a5 <printf+0x12e>
        putc(fd, *ap);
 588:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58b:	8b 00                	mov    (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 04 fe ff ff       	call   3a0 <putc>
 59c:	83 c4 10             	add    $0x10,%esp
        ap++;
 59f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a3:	eb 42                	jmp    5e7 <printf+0x170>
      } else if(c == '%'){
 5a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a9:	75 17                	jne    5c2 <printf+0x14b>
        putc(fd, c);
 5ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	83 ec 08             	sub    $0x8,%esp
 5b4:	50                   	push   %eax
 5b5:	ff 75 08             	pushl  0x8(%ebp)
 5b8:	e8 e3 fd ff ff       	call   3a0 <putc>
 5bd:	83 c4 10             	add    $0x10,%esp
 5c0:	eb 25                	jmp    5e7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c2:	83 ec 08             	sub    $0x8,%esp
 5c5:	6a 25                	push   $0x25
 5c7:	ff 75 08             	pushl  0x8(%ebp)
 5ca:	e8 d1 fd ff ff       	call   3a0 <putc>
 5cf:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 bc fd ff ff       	call   3a0 <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ee:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f8:	01 d0                	add    %edx,%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	0f 85 94 fe ff ff    	jne    499 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 605:	90                   	nop
 606:	c9                   	leave  
 607:	c3                   	ret    

00000608 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	83 e8 08             	sub    $0x8,%eax
 614:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 617:	a1 98 0a 00 00       	mov    0xa98,%eax
 61c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61f:	eb 24                	jmp    645 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 629:	77 12                	ja     63d <free+0x35>
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 631:	77 24                	ja     657 <free+0x4f>
 633:	8b 45 fc             	mov    -0x4(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63b:	77 1a                	ja     657 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	89 45 fc             	mov    %eax,-0x4(%ebp)
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64b:	76 d4                	jbe    621 <free+0x19>
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 655:	76 ca                	jbe    621 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	01 c2                	add    %eax,%edx
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	39 c2                	cmp    %eax,%edx
 670:	75 24                	jne    696 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	8b 50 04             	mov    0x4(%eax),%edx
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	8b 40 04             	mov    0x4(%eax),%eax
 680:	01 c2                	add    %eax,%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	8b 10                	mov    (%eax),%edx
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	89 10                	mov    %edx,(%eax)
 694:	eb 0a                	jmp    6a0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 10                	mov    (%eax),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 40 04             	mov    0x4(%eax),%eax
 6a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	01 d0                	add    %edx,%eax
 6b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b5:	75 20                	jne    6d7 <free+0xcf>
    p->s.size += bp->s.size;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 50 04             	mov    0x4(%eax),%edx
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	8b 40 04             	mov    0x4(%eax),%eax
 6c3:	01 c2                	add    %eax,%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
 6d5:	eb 08                	jmp    6df <free+0xd7>
  } else
    p->s.ptr = bp;
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6dd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e2:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 6e7:	90                   	nop
 6e8:	c9                   	leave  
 6e9:	c3                   	ret    

000006ea <morecore>:

static Header*
morecore(uint nu)
{
 6ea:	55                   	push   %ebp
 6eb:	89 e5                	mov    %esp,%ebp
 6ed:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f7:	77 07                	ja     700 <morecore+0x16>
    nu = 4096;
 6f9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 700:	8b 45 08             	mov    0x8(%ebp),%eax
 703:	c1 e0 03             	shl    $0x3,%eax
 706:	83 ec 0c             	sub    $0xc,%esp
 709:	50                   	push   %eax
 70a:	e8 41 fc ff ff       	call   350 <sbrk>
 70f:	83 c4 10             	add    $0x10,%esp
 712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 715:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 719:	75 07                	jne    722 <morecore+0x38>
    return 0;
 71b:	b8 00 00 00 00       	mov    $0x0,%eax
 720:	eb 26                	jmp    748 <morecore+0x5e>
  hp = (Header*)p;
 722:	8b 45 f4             	mov    -0xc(%ebp),%eax
 725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	8b 55 08             	mov    0x8(%ebp),%edx
 72e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 731:	8b 45 f0             	mov    -0x10(%ebp),%eax
 734:	83 c0 08             	add    $0x8,%eax
 737:	83 ec 0c             	sub    $0xc,%esp
 73a:	50                   	push   %eax
 73b:	e8 c8 fe ff ff       	call   608 <free>
 740:	83 c4 10             	add    $0x10,%esp
  return freep;
 743:	a1 98 0a 00 00       	mov    0xa98,%eax
}
 748:	c9                   	leave  
 749:	c3                   	ret    

0000074a <malloc>:

void*
malloc(uint nbytes)
{
 74a:	55                   	push   %ebp
 74b:	89 e5                	mov    %esp,%ebp
 74d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	83 c0 07             	add    $0x7,%eax
 756:	c1 e8 03             	shr    $0x3,%eax
 759:	83 c0 01             	add    $0x1,%eax
 75c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 75f:	a1 98 0a 00 00       	mov    0xa98,%eax
 764:	89 45 f0             	mov    %eax,-0x10(%ebp)
 767:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 76b:	75 23                	jne    790 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 76d:	c7 45 f0 90 0a 00 00 	movl   $0xa90,-0x10(%ebp)
 774:	8b 45 f0             	mov    -0x10(%ebp),%eax
 777:	a3 98 0a 00 00       	mov    %eax,0xa98
 77c:	a1 98 0a 00 00       	mov    0xa98,%eax
 781:	a3 90 0a 00 00       	mov    %eax,0xa90
    base.s.size = 0;
 786:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 78d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a1:	72 4d                	jb     7f0 <malloc+0xa6>
      if(p->s.size == nunits)
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ac:	75 0c                	jne    7ba <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 10                	mov    (%eax),%edx
 7b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b6:	89 10                	mov    %edx,(%eax)
 7b8:	eb 26                	jmp    7e0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7c3:	89 c2                	mov    %eax,%edx
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	c1 e0 03             	shl    $0x3,%eax
 7d4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	a3 98 0a 00 00       	mov    %eax,0xa98
      return (void*)(p + 1);
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	83 c0 08             	add    $0x8,%eax
 7ee:	eb 3b                	jmp    82b <malloc+0xe1>
    }
    if(p == freep)
 7f0:	a1 98 0a 00 00       	mov    0xa98,%eax
 7f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f8:	75 1e                	jne    818 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7fa:	83 ec 0c             	sub    $0xc,%esp
 7fd:	ff 75 ec             	pushl  -0x14(%ebp)
 800:	e8 e5 fe ff ff       	call   6ea <morecore>
 805:	83 c4 10             	add    $0x10,%esp
 808:	89 45 f4             	mov    %eax,-0xc(%ebp)
 80b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80f:	75 07                	jne    818 <malloc+0xce>
        return 0;
 811:	b8 00 00 00 00       	mov    $0x0,%eax
 816:	eb 13                	jmp    82b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 826:	e9 6d ff ff ff       	jmp    798 <malloc+0x4e>
}
 82b:	c9                   	leave  
 82c:	c3                   	ret    
