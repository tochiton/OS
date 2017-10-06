
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P2
#include "types.h"
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
  printf(1, "Not imlpemented yet.\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 29 08 00 00       	push   $0x829
  19:	6a 01                	push   $0x1
  1b:	e8 53 04 00 00       	call   473 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  exit();
  23:	e8 9c 02 00 00       	call   2c4 <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld    
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	90                   	nop
  4a:	5b                   	pop    %ebx
  4b:	5f                   	pop    %edi
  4c:	5d                   	pop    %ebp
  4d:	c3                   	ret    

0000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5a:	90                   	nop
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	8d 50 01             	lea    0x1(%eax),%edx
  61:	89 55 08             	mov    %edx,0x8(%ebp)
  64:	8b 55 0c             	mov    0xc(%ebp),%edx
  67:	8d 4a 01             	lea    0x1(%edx),%ecx
  6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6d:	0f b6 12             	movzbl (%edx),%edx
  70:	88 10                	mov    %dl,(%eax)
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	84 c0                	test   %al,%al
  77:	75 e2                	jne    5b <strcpy+0xd>
    ;
  return os;
  79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7c:	c9                   	leave  
  7d:	c3                   	ret    

0000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  81:	eb 08                	jmp    8b <strcmp+0xd>
    p++, q++;
  83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  87:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 00             	movzbl (%eax),%eax
  91:	84 c0                	test   %al,%al
  93:	74 10                	je     a5 <strcmp+0x27>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	38 c2                	cmp    %al,%dl
  a3:	74 de                	je     83 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	0f b6 d0             	movzbl %al,%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	01 d0                	add    %edx,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 ed                	jne    cc <strlen+0xf>
    ;
  return n;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e7:	8b 45 10             	mov    0x10(%ebp),%eax
  ea:	50                   	push   %eax
  eb:	ff 75 0c             	pushl  0xc(%ebp)
  ee:	ff 75 08             	pushl  0x8(%ebp)
  f1:	e8 32 ff ff ff       	call   28 <stosb>
  f6:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <strchr>:

char*
strchr(const char *s, char c)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 04             	sub    $0x4,%esp
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10a:	eb 14                	jmp    120 <strchr+0x22>
    if(*s == c)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	3a 45 fc             	cmp    -0x4(%ebp),%al
 115:	75 05                	jne    11c <strchr+0x1e>
      return (char*)s;
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	eb 13                	jmp    12f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 e2                	jne    10c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <gets>:

char*
gets(char *buf, int max)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13e:	eb 42                	jmp    182 <gets+0x51>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	8d 45 ef             	lea    -0x11(%ebp),%eax
 148:	50                   	push   %eax
 149:	6a 00                	push   $0x0
 14b:	e8 8c 01 00 00       	call   2dc <read>
 150:	83 c4 10             	add    $0x10,%esp
 153:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15a:	7e 33                	jle    18f <gets+0x5e>
      break;
    buf[i++] = c;
 15c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15f:	8d 50 01             	lea    0x1(%eax),%edx
 162:	89 55 f4             	mov    %edx,-0xc(%ebp)
 165:	89 c2                	mov    %eax,%edx
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	01 c2                	add    %eax,%edx
 16c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 170:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0a                	cmp    $0xa,%al
 178:	74 16                	je     190 <gets+0x5f>
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	3c 0d                	cmp    $0xd,%al
 180:	74 0e                	je     190 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	83 c0 01             	add    $0x1,%eax
 188:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18b:	7c b3                	jl     140 <gets+0xf>
 18d:	eb 01                	jmp    190 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 190:	8b 55 f4             	mov    -0xc(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <stat>:

int
stat(char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	83 ec 08             	sub    $0x8,%esp
 1a9:	6a 00                	push   $0x0
 1ab:	ff 75 08             	pushl  0x8(%ebp)
 1ae:	e8 51 01 00 00       	call   304 <open>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bd:	79 07                	jns    1c6 <stat+0x26>
    return -1;
 1bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c4:	eb 25                	jmp    1eb <stat+0x4b>
  r = fstat(fd, st);
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	ff 75 0c             	pushl  0xc(%ebp)
 1cc:	ff 75 f4             	pushl  -0xc(%ebp)
 1cf:	e8 48 01 00 00       	call   31c <fstat>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1da:	83 ec 0c             	sub    $0xc,%esp
 1dd:	ff 75 f4             	pushl  -0xc(%ebp)
 1e0:	e8 07 01 00 00       	call   2ec <close>
 1e5:	83 c4 10             	add    $0x10,%esp
  return r;
 1e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <atoi>:

int
atoi(const char *s)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1fa:	eb 04                	jmp    200 <atoi+0x13>
 1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3c 20                	cmp    $0x20,%al
 208:	74 f2                	je     1fc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3c 2d                	cmp    $0x2d,%al
 212:	75 07                	jne    21b <atoi+0x2e>
 214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 219:	eb 05                	jmp    220 <atoi+0x33>
 21b:	b8 01 00 00 00       	mov    $0x1,%eax
 220:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	3c 2b                	cmp    $0x2b,%al
 22b:	74 0a                	je     237 <atoi+0x4a>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2d                	cmp    $0x2d,%al
 235:	75 2b                	jne    262 <atoi+0x75>
    s++;
 237:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	eb 25                	jmp    262 <atoi+0x75>
    n = n*10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	01 c0                	add    %eax,%eax
 249:	89 c1                	mov    %eax,%ecx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8d 50 01             	lea    0x1(%eax),%edx
 251:	89 55 08             	mov    %edx,0x8(%ebp)
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	0f be c0             	movsbl %al,%eax
 25a:	01 c8                	add    %ecx,%eax
 25c:	83 e8 30             	sub    $0x30,%eax
 25f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	3c 2f                	cmp    $0x2f,%al
 26a:	7e 0a                	jle    276 <atoi+0x89>
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	3c 39                	cmp    $0x39,%al
 274:	7e c7                	jle    23d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 276:	8b 45 f8             	mov    -0x8(%ebp),%eax
 279:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 291:	eb 17                	jmp    2aa <memmove+0x2b>
    *dst++ = *src++;
 293:	8b 45 fc             	mov    -0x4(%ebp),%eax
 296:	8d 50 01             	lea    0x1(%eax),%edx
 299:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29f:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a5:	0f b6 12             	movzbl (%edx),%edx
 2a8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2aa:	8b 45 10             	mov    0x10(%ebp),%eax
 2ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b0:	89 55 10             	mov    %edx,0x10(%ebp)
 2b3:	85 c0                	test   %eax,%eax
 2b5:	7f dc                	jg     293 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bc:	b8 01 00 00 00       	mov    $0x1,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exit>:
SYSCALL(exit)
 2c4:	b8 02 00 00 00       	mov    $0x2,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <wait>:
SYSCALL(wait)
 2cc:	b8 03 00 00 00       	mov    $0x3,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <pipe>:
SYSCALL(pipe)
 2d4:	b8 04 00 00 00       	mov    $0x4,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <read>:
SYSCALL(read)
 2dc:	b8 05 00 00 00       	mov    $0x5,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <write>:
SYSCALL(write)
 2e4:	b8 10 00 00 00       	mov    $0x10,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <close>:
SYSCALL(close)
 2ec:	b8 15 00 00 00       	mov    $0x15,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <kill>:
SYSCALL(kill)
 2f4:	b8 06 00 00 00       	mov    $0x6,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exec>:
SYSCALL(exec)
 2fc:	b8 07 00 00 00       	mov    $0x7,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <open>:
SYSCALL(open)
 304:	b8 0f 00 00 00       	mov    $0xf,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <mknod>:
SYSCALL(mknod)
 30c:	b8 11 00 00 00       	mov    $0x11,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <unlink>:
SYSCALL(unlink)
 314:	b8 12 00 00 00       	mov    $0x12,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <fstat>:
SYSCALL(fstat)
 31c:	b8 08 00 00 00       	mov    $0x8,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <link>:
SYSCALL(link)
 324:	b8 13 00 00 00       	mov    $0x13,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mkdir>:
SYSCALL(mkdir)
 32c:	b8 14 00 00 00       	mov    $0x14,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <chdir>:
SYSCALL(chdir)
 334:	b8 09 00 00 00       	mov    $0x9,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup>:
SYSCALL(dup)
 33c:	b8 0a 00 00 00       	mov    $0xa,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <getpid>:
SYSCALL(getpid)
 344:	b8 0b 00 00 00       	mov    $0xb,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sbrk>:
SYSCALL(sbrk)
 34c:	b8 0c 00 00 00       	mov    $0xc,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sleep>:
SYSCALL(sleep)
 354:	b8 0d 00 00 00       	mov    $0xd,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <uptime>:
SYSCALL(uptime)
 35c:	b8 0e 00 00 00       	mov    $0xe,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <halt>:
SYSCALL(halt)
 364:	b8 16 00 00 00       	mov    $0x16,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <date>:
SYSCALL(date)
 36c:	b8 17 00 00 00       	mov    $0x17,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <getuid>:
SYSCALL(getuid)
 374:	b8 18 00 00 00       	mov    $0x18,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <getgid>:
SYSCALL(getgid)
 37c:	b8 19 00 00 00       	mov    $0x19,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <getppid>:
SYSCALL(getppid)
 384:	b8 1a 00 00 00       	mov    $0x1a,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <setuid>:
SYSCALL(setuid)
 38c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <setgid>:
SYSCALL(setgid)
 394:	b8 1c 00 00 00       	mov    $0x1c,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 18             	sub    $0x18,%esp
 3a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a8:	83 ec 04             	sub    $0x4,%esp
 3ab:	6a 01                	push   $0x1
 3ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b0:	50                   	push   %eax
 3b1:	ff 75 08             	pushl  0x8(%ebp)
 3b4:	e8 2b ff ff ff       	call   2e4 <write>
 3b9:	83 c4 10             	add    $0x10,%esp
}
 3bc:	90                   	nop
 3bd:	c9                   	leave  
 3be:	c3                   	ret    

000003bf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bf:	55                   	push   %ebp
 3c0:	89 e5                	mov    %esp,%ebp
 3c2:	53                   	push   %ebx
 3c3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d1:	74 17                	je     3ea <printint+0x2b>
 3d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d7:	79 11                	jns    3ea <printint+0x2b>
    neg = 1;
 3d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	f7 d8                	neg    %eax
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e8:	eb 06                	jmp    3f0 <printint+0x31>
  } else {
    x = xx;
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3fa:	8d 41 01             	lea    0x1(%ecx),%eax
 3fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 400:	8b 5d 10             	mov    0x10(%ebp),%ebx
 403:	8b 45 ec             	mov    -0x14(%ebp),%eax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	f7 f3                	div    %ebx
 40d:	89 d0                	mov    %edx,%eax
 40f:	0f b6 80 90 0a 00 00 	movzbl 0xa90(%eax),%eax
 416:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 41a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 41d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 420:	ba 00 00 00 00       	mov    $0x0,%edx
 425:	f7 f3                	div    %ebx
 427:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42e:	75 c7                	jne    3f7 <printint+0x38>
  if(neg)
 430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 434:	74 2d                	je     463 <printint+0xa4>
    buf[i++] = '-';
 436:	8b 45 f4             	mov    -0xc(%ebp),%eax
 439:	8d 50 01             	lea    0x1(%eax),%edx
 43c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 444:	eb 1d                	jmp    463 <printint+0xa4>
    putc(fd, buf[i]);
 446:	8d 55 dc             	lea    -0x24(%ebp),%edx
 449:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44c:	01 d0                	add    %edx,%eax
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	0f be c0             	movsbl %al,%eax
 454:	83 ec 08             	sub    $0x8,%esp
 457:	50                   	push   %eax
 458:	ff 75 08             	pushl  0x8(%ebp)
 45b:	e8 3c ff ff ff       	call   39c <putc>
 460:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 463:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46b:	79 d9                	jns    446 <printint+0x87>
    putc(fd, buf[i]);
}
 46d:	90                   	nop
 46e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 471:	c9                   	leave  
 472:	c3                   	ret    

00000473 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 473:	55                   	push   %ebp
 474:	89 e5                	mov    %esp,%ebp
 476:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 479:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 480:	8d 45 0c             	lea    0xc(%ebp),%eax
 483:	83 c0 04             	add    $0x4,%eax
 486:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 490:	e9 59 01 00 00       	jmp    5ee <printf+0x17b>
    c = fmt[i] & 0xff;
 495:	8b 55 0c             	mov    0xc(%ebp),%edx
 498:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49b:	01 d0                	add    %edx,%eax
 49d:	0f b6 00             	movzbl (%eax),%eax
 4a0:	0f be c0             	movsbl %al,%eax
 4a3:	25 ff 00 00 00       	and    $0xff,%eax
 4a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4af:	75 2c                	jne    4dd <printf+0x6a>
      if(c == '%'){
 4b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b5:	75 0c                	jne    4c3 <printf+0x50>
        state = '%';
 4b7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4be:	e9 27 01 00 00       	jmp    5ea <printf+0x177>
      } else {
        putc(fd, c);
 4c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c6:	0f be c0             	movsbl %al,%eax
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	50                   	push   %eax
 4cd:	ff 75 08             	pushl  0x8(%ebp)
 4d0:	e8 c7 fe ff ff       	call   39c <putc>
 4d5:	83 c4 10             	add    $0x10,%esp
 4d8:	e9 0d 01 00 00       	jmp    5ea <printf+0x177>
      }
    } else if(state == '%'){
 4dd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e1:	0f 85 03 01 00 00    	jne    5ea <printf+0x177>
      if(c == 'd'){
 4e7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4eb:	75 1e                	jne    50b <printf+0x98>
        printint(fd, *ap, 10, 1);
 4ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f0:	8b 00                	mov    (%eax),%eax
 4f2:	6a 01                	push   $0x1
 4f4:	6a 0a                	push   $0xa
 4f6:	50                   	push   %eax
 4f7:	ff 75 08             	pushl  0x8(%ebp)
 4fa:	e8 c0 fe ff ff       	call   3bf <printint>
 4ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 502:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 506:	e9 d8 00 00 00       	jmp    5e3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 50b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50f:	74 06                	je     517 <printf+0xa4>
 511:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 515:	75 1e                	jne    535 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 517:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51a:	8b 00                	mov    (%eax),%eax
 51c:	6a 00                	push   $0x0
 51e:	6a 10                	push   $0x10
 520:	50                   	push   %eax
 521:	ff 75 08             	pushl  0x8(%ebp)
 524:	e8 96 fe ff ff       	call   3bf <printint>
 529:	83 c4 10             	add    $0x10,%esp
        ap++;
 52c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 530:	e9 ae 00 00 00       	jmp    5e3 <printf+0x170>
      } else if(c == 's'){
 535:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 539:	75 43                	jne    57e <printf+0x10b>
        s = (char*)*ap;
 53b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53e:	8b 00                	mov    (%eax),%eax
 540:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 543:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54b:	75 25                	jne    572 <printf+0xff>
          s = "(null)";
 54d:	c7 45 f4 3f 08 00 00 	movl   $0x83f,-0xc(%ebp)
        while(*s != 0){
 554:	eb 1c                	jmp    572 <printf+0xff>
          putc(fd, *s);
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	83 ec 08             	sub    $0x8,%esp
 562:	50                   	push   %eax
 563:	ff 75 08             	pushl  0x8(%ebp)
 566:	e8 31 fe ff ff       	call   39c <putc>
 56b:	83 c4 10             	add    $0x10,%esp
          s++;
 56e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	84 c0                	test   %al,%al
 57a:	75 da                	jne    556 <printf+0xe3>
 57c:	eb 65                	jmp    5e3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 582:	75 1d                	jne    5a1 <printf+0x12e>
        putc(fd, *ap);
 584:	8b 45 e8             	mov    -0x18(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	0f be c0             	movsbl %al,%eax
 58c:	83 ec 08             	sub    $0x8,%esp
 58f:	50                   	push   %eax
 590:	ff 75 08             	pushl  0x8(%ebp)
 593:	e8 04 fe ff ff       	call   39c <putc>
 598:	83 c4 10             	add    $0x10,%esp
        ap++;
 59b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59f:	eb 42                	jmp    5e3 <printf+0x170>
      } else if(c == '%'){
 5a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a5:	75 17                	jne    5be <printf+0x14b>
        putc(fd, c);
 5a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	83 ec 08             	sub    $0x8,%esp
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	pushl  0x8(%ebp)
 5b4:	e8 e3 fd ff ff       	call   39c <putc>
 5b9:	83 c4 10             	add    $0x10,%esp
 5bc:	eb 25                	jmp    5e3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5be:	83 ec 08             	sub    $0x8,%esp
 5c1:	6a 25                	push   $0x25
 5c3:	ff 75 08             	pushl  0x8(%ebp)
 5c6:	e8 d1 fd ff ff       	call   39c <putc>
 5cb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 bc fd ff ff       	call   39c <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f4:	01 d0                	add    %edx,%eax
 5f6:	0f b6 00             	movzbl (%eax),%eax
 5f9:	84 c0                	test   %al,%al
 5fb:	0f 85 94 fe ff ff    	jne    495 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 601:	90                   	nop
 602:	c9                   	leave  
 603:	c3                   	ret    

00000604 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60a:	8b 45 08             	mov    0x8(%ebp),%eax
 60d:	83 e8 08             	sub    $0x8,%eax
 610:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 613:	a1 ac 0a 00 00       	mov    0xaac,%eax
 618:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61b:	eb 24                	jmp    641 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 625:	77 12                	ja     639 <free+0x35>
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 24                	ja     653 <free+0x4f>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	77 1a                	ja     653 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 647:	76 d4                	jbe    61d <free+0x19>
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	76 ca                	jbe    61d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 40 04             	mov    0x4(%eax),%eax
 659:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	01 c2                	add    %eax,%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	39 c2                	cmp    %eax,%edx
 66c:	75 24                	jne    692 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	8b 40 04             	mov    0x4(%eax),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
 690:	eb 0a                	jmp    69c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 10                	mov    (%eax),%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	01 d0                	add    %edx,%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	75 20                	jne    6d3 <free+0xcf>
    p->s.size += bp->s.size;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 50 04             	mov    0x4(%eax),%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	01 c2                	add    %eax,%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
 6d1:	eb 08                	jmp    6db <free+0xd7>
  } else
    p->s.ptr = bp;
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6d9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	a3 ac 0a 00 00       	mov    %eax,0xaac
}
 6e3:	90                   	nop
 6e4:	c9                   	leave  
 6e5:	c3                   	ret    

000006e6 <morecore>:

static Header*
morecore(uint nu)
{
 6e6:	55                   	push   %ebp
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f3:	77 07                	ja     6fc <morecore+0x16>
    nu = 4096;
 6f5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fc:	8b 45 08             	mov    0x8(%ebp),%eax
 6ff:	c1 e0 03             	shl    $0x3,%eax
 702:	83 ec 0c             	sub    $0xc,%esp
 705:	50                   	push   %eax
 706:	e8 41 fc ff ff       	call   34c <sbrk>
 70b:	83 c4 10             	add    $0x10,%esp
 70e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 711:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 715:	75 07                	jne    71e <morecore+0x38>
    return 0;
 717:	b8 00 00 00 00       	mov    $0x0,%eax
 71c:	eb 26                	jmp    744 <morecore+0x5e>
  hp = (Header*)p;
 71e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 721:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 724:	8b 45 f0             	mov    -0x10(%ebp),%eax
 727:	8b 55 08             	mov    0x8(%ebp),%edx
 72a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 72d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 730:	83 c0 08             	add    $0x8,%eax
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	50                   	push   %eax
 737:	e8 c8 fe ff ff       	call   604 <free>
 73c:	83 c4 10             	add    $0x10,%esp
  return freep;
 73f:	a1 ac 0a 00 00       	mov    0xaac,%eax
}
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <malloc>:

void*
malloc(uint nbytes)
{
 746:	55                   	push   %ebp
 747:	89 e5                	mov    %esp,%ebp
 749:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	83 c0 07             	add    $0x7,%eax
 752:	c1 e8 03             	shr    $0x3,%eax
 755:	83 c0 01             	add    $0x1,%eax
 758:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 75b:	a1 ac 0a 00 00       	mov    0xaac,%eax
 760:	89 45 f0             	mov    %eax,-0x10(%ebp)
 763:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 767:	75 23                	jne    78c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 769:	c7 45 f0 a4 0a 00 00 	movl   $0xaa4,-0x10(%ebp)
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	a3 ac 0a 00 00       	mov    %eax,0xaac
 778:	a1 ac 0a 00 00       	mov    0xaac,%eax
 77d:	a3 a4 0a 00 00       	mov    %eax,0xaa4
    base.s.size = 0;
 782:	c7 05 a8 0a 00 00 00 	movl   $0x0,0xaa8
 789:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79d:	72 4d                	jb     7ec <malloc+0xa6>
      if(p->s.size == nunits)
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a8:	75 0c                	jne    7b6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 10                	mov    (%eax),%edx
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	89 10                	mov    %edx,(%eax)
 7b4:	eb 26                	jmp    7dc <malloc+0x96>
      else {
        p->s.size -= nunits;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7bf:	89 c2                	mov    %eax,%edx
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	c1 e0 03             	shl    $0x3,%eax
 7d0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	a3 ac 0a 00 00       	mov    %eax,0xaac
      return (void*)(p + 1);
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	83 c0 08             	add    $0x8,%eax
 7ea:	eb 3b                	jmp    827 <malloc+0xe1>
    }
    if(p == freep)
 7ec:	a1 ac 0a 00 00       	mov    0xaac,%eax
 7f1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f4:	75 1e                	jne    814 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7f6:	83 ec 0c             	sub    $0xc,%esp
 7f9:	ff 75 ec             	pushl  -0x14(%ebp)
 7fc:	e8 e5 fe ff ff       	call   6e6 <morecore>
 801:	83 c4 10             	add    $0x10,%esp
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
 807:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80b:	75 07                	jne    814 <malloc+0xce>
        return 0;
 80d:	b8 00 00 00 00       	mov    $0x0,%eax
 812:	eb 13                	jmp    827 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 822:	e9 6d ff ff ff       	jmp    794 <malloc+0x4e>
}
 827:	c9                   	leave  
 828:	c3                   	ret    
