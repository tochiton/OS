
_ps:     file format elf32-i386


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
  14:	68 01 08 00 00       	push   $0x801
  19:	6a 01                	push   $0x1
  1b:	e8 2b 04 00 00       	call   44b <printf>
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

00000374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 18             	sub    $0x18,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	6a 01                	push   $0x1
 385:	8d 45 f4             	lea    -0xc(%ebp),%eax
 388:	50                   	push   %eax
 389:	ff 75 08             	pushl  0x8(%ebp)
 38c:	e8 53 ff ff ff       	call   2e4 <write>
 391:	83 c4 10             	add    $0x10,%esp
}
 394:	90                   	nop
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	53                   	push   %ebx
 39b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a9:	74 17                	je     3c2 <printint+0x2b>
 3ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3af:	79 11                	jns    3c2 <printint+0x2b>
    neg = 1;
 3b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bb:	f7 d8                	neg    %eax
 3bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c0:	eb 06                	jmp    3c8 <printint+0x31>
  } else {
    x = xx;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3cf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3d2:	8d 41 01             	lea    0x1(%ecx),%eax
 3d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 f3                	div    %ebx
 3e5:	89 d0                	mov    %edx,%eax
 3e7:	0f b6 80 68 0a 00 00 	movzbl 0xa68(%eax),%eax
 3ee:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f8:	ba 00 00 00 00       	mov    $0x0,%edx
 3fd:	f7 f3                	div    %ebx
 3ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
 402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 406:	75 c7                	jne    3cf <printint+0x38>
  if(neg)
 408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40c:	74 2d                	je     43b <printint+0xa4>
    buf[i++] = '-';
 40e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 411:	8d 50 01             	lea    0x1(%eax),%edx
 414:	89 55 f4             	mov    %edx,-0xc(%ebp)
 417:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 41c:	eb 1d                	jmp    43b <printint+0xa4>
    putc(fd, buf[i]);
 41e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 421:	8b 45 f4             	mov    -0xc(%ebp),%eax
 424:	01 d0                	add    %edx,%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	0f be c0             	movsbl %al,%eax
 42c:	83 ec 08             	sub    $0x8,%esp
 42f:	50                   	push   %eax
 430:	ff 75 08             	pushl  0x8(%ebp)
 433:	e8 3c ff ff ff       	call   374 <putc>
 438:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 43f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 443:	79 d9                	jns    41e <printint+0x87>
    putc(fd, buf[i]);
}
 445:	90                   	nop
 446:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 449:	c9                   	leave  
 44a:	c3                   	ret    

0000044b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
 44e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 451:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 458:	8d 45 0c             	lea    0xc(%ebp),%eax
 45b:	83 c0 04             	add    $0x4,%eax
 45e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 468:	e9 59 01 00 00       	jmp    5c6 <printf+0x17b>
    c = fmt[i] & 0xff;
 46d:	8b 55 0c             	mov    0xc(%ebp),%edx
 470:	8b 45 f0             	mov    -0x10(%ebp),%eax
 473:	01 d0                	add    %edx,%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	0f be c0             	movsbl %al,%eax
 47b:	25 ff 00 00 00       	and    $0xff,%eax
 480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 487:	75 2c                	jne    4b5 <printf+0x6a>
      if(c == '%'){
 489:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48d:	75 0c                	jne    49b <printf+0x50>
        state = '%';
 48f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 496:	e9 27 01 00 00       	jmp    5c2 <printf+0x177>
      } else {
        putc(fd, c);
 49b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	83 ec 08             	sub    $0x8,%esp
 4a4:	50                   	push   %eax
 4a5:	ff 75 08             	pushl  0x8(%ebp)
 4a8:	e8 c7 fe ff ff       	call   374 <putc>
 4ad:	83 c4 10             	add    $0x10,%esp
 4b0:	e9 0d 01 00 00       	jmp    5c2 <printf+0x177>
      }
    } else if(state == '%'){
 4b5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b9:	0f 85 03 01 00 00    	jne    5c2 <printf+0x177>
      if(c == 'd'){
 4bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c3:	75 1e                	jne    4e3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c8:	8b 00                	mov    (%eax),%eax
 4ca:	6a 01                	push   $0x1
 4cc:	6a 0a                	push   $0xa
 4ce:	50                   	push   %eax
 4cf:	ff 75 08             	pushl  0x8(%ebp)
 4d2:	e8 c0 fe ff ff       	call   397 <printint>
 4d7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4de:	e9 d8 00 00 00       	jmp    5bb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4e3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e7:	74 06                	je     4ef <printf+0xa4>
 4e9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ed:	75 1e                	jne    50d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f2:	8b 00                	mov    (%eax),%eax
 4f4:	6a 00                	push   $0x0
 4f6:	6a 10                	push   $0x10
 4f8:	50                   	push   %eax
 4f9:	ff 75 08             	pushl  0x8(%ebp)
 4fc:	e8 96 fe ff ff       	call   397 <printint>
 501:	83 c4 10             	add    $0x10,%esp
        ap++;
 504:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 508:	e9 ae 00 00 00       	jmp    5bb <printf+0x170>
      } else if(c == 's'){
 50d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 511:	75 43                	jne    556 <printf+0x10b>
        s = (char*)*ap;
 513:	8b 45 e8             	mov    -0x18(%ebp),%eax
 516:	8b 00                	mov    (%eax),%eax
 518:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 51b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 51f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 523:	75 25                	jne    54a <printf+0xff>
          s = "(null)";
 525:	c7 45 f4 17 08 00 00 	movl   $0x817,-0xc(%ebp)
        while(*s != 0){
 52c:	eb 1c                	jmp    54a <printf+0xff>
          putc(fd, *s);
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	83 ec 08             	sub    $0x8,%esp
 53a:	50                   	push   %eax
 53b:	ff 75 08             	pushl  0x8(%ebp)
 53e:	e8 31 fe ff ff       	call   374 <putc>
 543:	83 c4 10             	add    $0x10,%esp
          s++;
 546:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	84 c0                	test   %al,%al
 552:	75 da                	jne    52e <printf+0xe3>
 554:	eb 65                	jmp    5bb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 556:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 55a:	75 1d                	jne    579 <printf+0x12e>
        putc(fd, *ap);
 55c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55f:	8b 00                	mov    (%eax),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	83 ec 08             	sub    $0x8,%esp
 567:	50                   	push   %eax
 568:	ff 75 08             	pushl  0x8(%ebp)
 56b:	e8 04 fe ff ff       	call   374 <putc>
 570:	83 c4 10             	add    $0x10,%esp
        ap++;
 573:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 577:	eb 42                	jmp    5bb <printf+0x170>
      } else if(c == '%'){
 579:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57d:	75 17                	jne    596 <printf+0x14b>
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	83 ec 08             	sub    $0x8,%esp
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 e3 fd ff ff       	call   374 <putc>
 591:	83 c4 10             	add    $0x10,%esp
 594:	eb 25                	jmp    5bb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 596:	83 ec 08             	sub    $0x8,%esp
 599:	6a 25                	push   $0x25
 59b:	ff 75 08             	pushl  0x8(%ebp)
 59e:	e8 d1 fd ff ff       	call   374 <putc>
 5a3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	83 ec 08             	sub    $0x8,%esp
 5af:	50                   	push   %eax
 5b0:	ff 75 08             	pushl  0x8(%ebp)
 5b3:	e8 bc fd ff ff       	call   374 <putc>
 5b8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cc:	01 d0                	add    %edx,%eax
 5ce:	0f b6 00             	movzbl (%eax),%eax
 5d1:	84 c0                	test   %al,%al
 5d3:	0f 85 94 fe ff ff    	jne    46d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d9:	90                   	nop
 5da:	c9                   	leave  
 5db:	c3                   	ret    

000005dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	83 e8 08             	sub    $0x8,%eax
 5e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5eb:	a1 84 0a 00 00       	mov    0xa84,%eax
 5f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5f3:	eb 24                	jmp    619 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	8b 00                	mov    (%eax),%eax
 5fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5fd:	77 12                	ja     611 <free+0x35>
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	77 24                	ja     62b <free+0x4f>
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60f:	77 1a                	ja     62b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	89 45 fc             	mov    %eax,-0x4(%ebp)
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61f:	76 d4                	jbe    5f5 <free+0x19>
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 629:	76 ca                	jbe    5f5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	8b 40 04             	mov    0x4(%eax),%eax
 631:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	01 c2                	add    %eax,%edx
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	39 c2                	cmp    %eax,%edx
 644:	75 24                	jne    66a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	8b 50 04             	mov    0x4(%eax),%edx
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	8b 40 04             	mov    0x4(%eax),%eax
 654:	01 c2                	add    %eax,%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	8b 10                	mov    (%eax),%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 10                	mov    %edx,(%eax)
 668:	eb 0a                	jmp    674 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	01 d0                	add    %edx,%eax
 686:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 689:	75 20                	jne    6ab <free+0xcf>
    p->s.size += bp->s.size;
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 50 04             	mov    0x4(%eax),%edx
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 40 04             	mov    0x4(%eax),%eax
 697:	01 c2                	add    %eax,%edx
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 08                	jmp    6b3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	a3 84 0a 00 00       	mov    %eax,0xa84
}
 6bb:	90                   	nop
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <morecore>:

static Header*
morecore(uint nu)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6cb:	77 07                	ja     6d4 <morecore+0x16>
    nu = 4096;
 6cd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	c1 e0 03             	shl    $0x3,%eax
 6da:	83 ec 0c             	sub    $0xc,%esp
 6dd:	50                   	push   %eax
 6de:	e8 69 fc ff ff       	call   34c <sbrk>
 6e3:	83 c4 10             	add    $0x10,%esp
 6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ed:	75 07                	jne    6f6 <morecore+0x38>
    return 0;
 6ef:	b8 00 00 00 00       	mov    $0x0,%eax
 6f4:	eb 26                	jmp    71c <morecore+0x5e>
  hp = (Header*)p;
 6f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	8b 55 08             	mov    0x8(%ebp),%edx
 702:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 705:	8b 45 f0             	mov    -0x10(%ebp),%eax
 708:	83 c0 08             	add    $0x8,%eax
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	50                   	push   %eax
 70f:	e8 c8 fe ff ff       	call   5dc <free>
 714:	83 c4 10             	add    $0x10,%esp
  return freep;
 717:	a1 84 0a 00 00       	mov    0xa84,%eax
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <malloc>:

void*
malloc(uint nbytes)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	83 c0 07             	add    $0x7,%eax
 72a:	c1 e8 03             	shr    $0x3,%eax
 72d:	83 c0 01             	add    $0x1,%eax
 730:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 733:	a1 84 0a 00 00       	mov    0xa84,%eax
 738:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73f:	75 23                	jne    764 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 741:	c7 45 f0 7c 0a 00 00 	movl   $0xa7c,-0x10(%ebp)
 748:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74b:	a3 84 0a 00 00       	mov    %eax,0xa84
 750:	a1 84 0a 00 00       	mov    0xa84,%eax
 755:	a3 7c 0a 00 00       	mov    %eax,0xa7c
    base.s.size = 0;
 75a:	c7 05 80 0a 00 00 00 	movl   $0x0,0xa80
 761:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 764:	8b 45 f0             	mov    -0x10(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	8b 40 04             	mov    0x4(%eax),%eax
 772:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 775:	72 4d                	jb     7c4 <malloc+0xa6>
      if(p->s.size == nunits)
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 780:	75 0c                	jne    78e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 782:	8b 45 f4             	mov    -0xc(%ebp),%eax
 785:	8b 10                	mov    (%eax),%edx
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	89 10                	mov    %edx,(%eax)
 78c:	eb 26                	jmp    7b4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	8b 40 04             	mov    0x4(%eax),%eax
 794:	2b 45 ec             	sub    -0x14(%ebp),%eax
 797:	89 c2                	mov    %eax,%edx
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	c1 e0 03             	shl    $0x3,%eax
 7a8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	a3 84 0a 00 00       	mov    %eax,0xa84
      return (void*)(p + 1);
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	83 c0 08             	add    $0x8,%eax
 7c2:	eb 3b                	jmp    7ff <malloc+0xe1>
    }
    if(p == freep)
 7c4:	a1 84 0a 00 00       	mov    0xa84,%eax
 7c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7cc:	75 1e                	jne    7ec <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7ce:	83 ec 0c             	sub    $0xc,%esp
 7d1:	ff 75 ec             	pushl  -0x14(%ebp)
 7d4:	e8 e5 fe ff ff       	call   6be <morecore>
 7d9:	83 c4 10             	add    $0x10,%esp
 7dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e3:	75 07                	jne    7ec <malloc+0xce>
        return 0;
 7e5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ea:	eb 13                	jmp    7ff <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7fa:	e9 6d ff ff ff       	jmp    76c <malloc+0x4e>
}
 7ff:	c9                   	leave  
 800:	c3                   	ret    
