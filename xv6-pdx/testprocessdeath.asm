
_testprocessdeath:     file format elf32-i386


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
   e:	83 ec 14             	sub    $0x14,%esp
	printf(1,"Testing process death");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 5e 08 00 00       	push   $0x85e
  19:	6a 01                	push   $0x1
  1b:	e8 88 04 00 00       	call   4a8 <printf>
  20:	83 c4 10             	add    $0x10,%esp
	int pid = fork();
  23:	e8 c1 02 00 00       	call   2e9 <fork>
  28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	printf(1,"%d\n", pid);
  2b:	83 ec 04             	sub    $0x4,%esp
  2e:	ff 75 f4             	pushl  -0xc(%ebp)
  31:	68 74 08 00 00       	push   $0x874
  36:	6a 01                	push   $0x1
  38:	e8 6b 04 00 00       	call   4a8 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
	sleep(10000);
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	68 10 27 00 00       	push   $0x2710
  48:	e8 34 03 00 00       	call   381 <sleep>
  4d:	83 c4 10             	add    $0x10,%esp
  	exit();
  50:	e8 9c 02 00 00       	call   2f1 <exit>

00000055 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  55:	55                   	push   %ebp
  56:	89 e5                	mov    %esp,%ebp
  58:	57                   	push   %edi
  59:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5d:	8b 55 10             	mov    0x10(%ebp),%edx
  60:	8b 45 0c             	mov    0xc(%ebp),%eax
  63:	89 cb                	mov    %ecx,%ebx
  65:	89 df                	mov    %ebx,%edi
  67:	89 d1                	mov    %edx,%ecx
  69:	fc                   	cld    
  6a:	f3 aa                	rep stos %al,%es:(%edi)
  6c:	89 ca                	mov    %ecx,%edx
  6e:	89 fb                	mov    %edi,%ebx
  70:	89 5d 08             	mov    %ebx,0x8(%ebp)
  73:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  76:	90                   	nop
  77:	5b                   	pop    %ebx
  78:	5f                   	pop    %edi
  79:	5d                   	pop    %ebp
  7a:	c3                   	ret    

0000007b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  7b:	55                   	push   %ebp
  7c:	89 e5                	mov    %esp,%ebp
  7e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  81:	8b 45 08             	mov    0x8(%ebp),%eax
  84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  87:	90                   	nop
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	8d 50 01             	lea    0x1(%eax),%edx
  8e:	89 55 08             	mov    %edx,0x8(%ebp)
  91:	8b 55 0c             	mov    0xc(%ebp),%edx
  94:	8d 4a 01             	lea    0x1(%edx),%ecx
  97:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  9a:	0f b6 12             	movzbl (%edx),%edx
  9d:	88 10                	mov    %dl,(%eax)
  9f:	0f b6 00             	movzbl (%eax),%eax
  a2:	84 c0                	test   %al,%al
  a4:	75 e2                	jne    88 <strcpy+0xd>
    ;
  return os;
  a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  a9:	c9                   	leave  
  aa:	c3                   	ret    

000000ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ae:	eb 08                	jmp    b8 <strcmp+0xd>
    p++, q++;
  b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	74 10                	je     d2 <strcmp+0x27>
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	0f b6 10             	movzbl (%eax),%edx
  c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	38 c2                	cmp    %al,%dl
  d0:	74 de                	je     b0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 00             	movzbl (%eax),%eax
  d8:	0f b6 d0             	movzbl %al,%edx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	0f b6 00             	movzbl (%eax),%eax
  e1:	0f b6 c0             	movzbl %al,%eax
  e4:	29 c2                	sub    %eax,%edx
  e6:	89 d0                	mov    %edx,%eax
}
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strlen>:

uint
strlen(char *s)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  f7:	eb 04                	jmp    fd <strlen+0x13>
  f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	01 d0                	add    %edx,%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	84 c0                	test   %al,%al
 10a:	75 ed                	jne    f9 <strlen+0xf>
    ;
  return n;
 10c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10f:	c9                   	leave  
 110:	c3                   	ret    

00000111 <memset>:

void*
memset(void *dst, int c, uint n)
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 114:	8b 45 10             	mov    0x10(%ebp),%eax
 117:	50                   	push   %eax
 118:	ff 75 0c             	pushl  0xc(%ebp)
 11b:	ff 75 08             	pushl  0x8(%ebp)
 11e:	e8 32 ff ff ff       	call   55 <stosb>
 123:	83 c4 0c             	add    $0xc,%esp
  return dst;
 126:	8b 45 08             	mov    0x8(%ebp),%eax
}
 129:	c9                   	leave  
 12a:	c3                   	ret    

0000012b <strchr>:

char*
strchr(const char *s, char c)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	8b 45 0c             	mov    0xc(%ebp),%eax
 134:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 137:	eb 14                	jmp    14d <strchr+0x22>
    if(*s == c)
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	0f b6 00             	movzbl (%eax),%eax
 13f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 142:	75 05                	jne    149 <strchr+0x1e>
      return (char*)s;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	eb 13                	jmp    15c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 149:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	84 c0                	test   %al,%al
 155:	75 e2                	jne    139 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 157:	b8 00 00 00 00       	mov    $0x0,%eax
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <gets>:

char*
gets(char *buf, int max)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 16b:	eb 42                	jmp    1af <gets+0x51>
    cc = read(0, &c, 1);
 16d:	83 ec 04             	sub    $0x4,%esp
 170:	6a 01                	push   $0x1
 172:	8d 45 ef             	lea    -0x11(%ebp),%eax
 175:	50                   	push   %eax
 176:	6a 00                	push   $0x0
 178:	e8 8c 01 00 00       	call   309 <read>
 17d:	83 c4 10             	add    $0x10,%esp
 180:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 187:	7e 33                	jle    1bc <gets+0x5e>
      break;
    buf[i++] = c;
 189:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18c:	8d 50 01             	lea    0x1(%eax),%edx
 18f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 192:	89 c2                	mov    %eax,%edx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	01 c2                	add    %eax,%edx
 199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 19f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a3:	3c 0a                	cmp    $0xa,%al
 1a5:	74 16                	je     1bd <gets+0x5f>
 1a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ab:	3c 0d                	cmp    $0xd,%al
 1ad:	74 0e                	je     1bd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	83 c0 01             	add    $0x1,%eax
 1b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b8:	7c b3                	jl     16d <gets+0xf>
 1ba:	eb 01                	jmp    1bd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1bc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <stat>:

int
stat(char *n, struct stat *st)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d3:	83 ec 08             	sub    $0x8,%esp
 1d6:	6a 00                	push   $0x0
 1d8:	ff 75 08             	pushl  0x8(%ebp)
 1db:	e8 51 01 00 00       	call   331 <open>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ea:	79 07                	jns    1f3 <stat+0x26>
    return -1;
 1ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f1:	eb 25                	jmp    218 <stat+0x4b>
  r = fstat(fd, st);
 1f3:	83 ec 08             	sub    $0x8,%esp
 1f6:	ff 75 0c             	pushl  0xc(%ebp)
 1f9:	ff 75 f4             	pushl  -0xc(%ebp)
 1fc:	e8 48 01 00 00       	call   349 <fstat>
 201:	83 c4 10             	add    $0x10,%esp
 204:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 207:	83 ec 0c             	sub    $0xc,%esp
 20a:	ff 75 f4             	pushl  -0xc(%ebp)
 20d:	e8 07 01 00 00       	call   319 <close>
 212:	83 c4 10             	add    $0x10,%esp
  return r;
 215:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <atoi>:

int
atoi(const char *s)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 220:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 227:	eb 04                	jmp    22d <atoi+0x13>
 229:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 20                	cmp    $0x20,%al
 235:	74 f2                	je     229 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 2d                	cmp    $0x2d,%al
 23f:	75 07                	jne    248 <atoi+0x2e>
 241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 246:	eb 05                	jmp    24d <atoi+0x33>
 248:	b8 01 00 00 00       	mov    $0x1,%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	0f b6 00             	movzbl (%eax),%eax
 256:	3c 2b                	cmp    $0x2b,%al
 258:	74 0a                	je     264 <atoi+0x4a>
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	3c 2d                	cmp    $0x2d,%al
 262:	75 2b                	jne    28f <atoi+0x75>
    s++;
 264:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 268:	eb 25                	jmp    28f <atoi+0x75>
    n = n*10 + *s++ - '0';
 26a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26d:	89 d0                	mov    %edx,%eax
 26f:	c1 e0 02             	shl    $0x2,%eax
 272:	01 d0                	add    %edx,%eax
 274:	01 c0                	add    %eax,%eax
 276:	89 c1                	mov    %eax,%ecx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	8d 50 01             	lea    0x1(%eax),%edx
 27e:	89 55 08             	mov    %edx,0x8(%ebp)
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	0f be c0             	movsbl %al,%eax
 287:	01 c8                	add    %ecx,%eax
 289:	83 e8 30             	sub    $0x30,%eax
 28c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	3c 2f                	cmp    $0x2f,%al
 297:	7e 0a                	jle    2a3 <atoi+0x89>
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 39                	cmp    $0x39,%al
 2a1:	7e c7                	jle    26a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2be:	eb 17                	jmp    2d7 <memmove+0x2b>
    *dst++ = *src++;
 2c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c3:	8d 50 01             	lea    0x1(%eax),%edx
 2c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2cc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2cf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d2:	0f b6 12             	movzbl (%edx),%edx
 2d5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d7:	8b 45 10             	mov    0x10(%ebp),%eax
 2da:	8d 50 ff             	lea    -0x1(%eax),%edx
 2dd:	89 55 10             	mov    %edx,0x10(%ebp)
 2e0:	85 c0                	test   %eax,%eax
 2e2:	7f dc                	jg     2c0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <exit>:
SYSCALL(exit)
 2f1:	b8 02 00 00 00       	mov    $0x2,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <wait>:
SYSCALL(wait)
 2f9:	b8 03 00 00 00       	mov    $0x3,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <pipe>:
SYSCALL(pipe)
 301:	b8 04 00 00 00       	mov    $0x4,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <read>:
SYSCALL(read)
 309:	b8 05 00 00 00       	mov    $0x5,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <write>:
SYSCALL(write)
 311:	b8 10 00 00 00       	mov    $0x10,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <close>:
SYSCALL(close)
 319:	b8 15 00 00 00       	mov    $0x15,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <kill>:
SYSCALL(kill)
 321:	b8 06 00 00 00       	mov    $0x6,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exec>:
SYSCALL(exec)
 329:	b8 07 00 00 00       	mov    $0x7,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <open>:
SYSCALL(open)
 331:	b8 0f 00 00 00       	mov    $0xf,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mknod>:
SYSCALL(mknod)
 339:	b8 11 00 00 00       	mov    $0x11,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <unlink>:
SYSCALL(unlink)
 341:	b8 12 00 00 00       	mov    $0x12,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <fstat>:
SYSCALL(fstat)
 349:	b8 08 00 00 00       	mov    $0x8,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <link>:
SYSCALL(link)
 351:	b8 13 00 00 00       	mov    $0x13,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <mkdir>:
SYSCALL(mkdir)
 359:	b8 14 00 00 00       	mov    $0x14,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <chdir>:
SYSCALL(chdir)
 361:	b8 09 00 00 00       	mov    $0x9,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <dup>:
SYSCALL(dup)
 369:	b8 0a 00 00 00       	mov    $0xa,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <getpid>:
SYSCALL(getpid)
 371:	b8 0b 00 00 00       	mov    $0xb,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <sbrk>:
SYSCALL(sbrk)
 379:	b8 0c 00 00 00       	mov    $0xc,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sleep>:
SYSCALL(sleep)
 381:	b8 0d 00 00 00       	mov    $0xd,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <uptime>:
SYSCALL(uptime)
 389:	b8 0e 00 00 00       	mov    $0xe,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <halt>:
SYSCALL(halt)
 391:	b8 16 00 00 00       	mov    $0x16,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <date>:
SYSCALL(date)
 399:	b8 17 00 00 00       	mov    $0x17,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <getuid>:
SYSCALL(getuid)
 3a1:	b8 18 00 00 00       	mov    $0x18,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <getgid>:
SYSCALL(getgid)
 3a9:	b8 19 00 00 00       	mov    $0x19,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <getppid>:
SYSCALL(getppid)
 3b1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <setuid>:
SYSCALL(setuid)
 3b9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <setgid>:
SYSCALL(setgid)
 3c1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <getprocs>:
SYSCALL(getprocs)
 3c9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
 3d4:	83 ec 18             	sub    $0x18,%esp
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3dd:	83 ec 04             	sub    $0x4,%esp
 3e0:	6a 01                	push   $0x1
 3e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e5:	50                   	push   %eax
 3e6:	ff 75 08             	pushl  0x8(%ebp)
 3e9:	e8 23 ff ff ff       	call   311 <write>
 3ee:	83 c4 10             	add    $0x10,%esp
}
 3f1:	90                   	nop
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	53                   	push   %ebx
 3f8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 402:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 406:	74 17                	je     41f <printint+0x2b>
 408:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 40c:	79 11                	jns    41f <printint+0x2b>
    neg = 1;
 40e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	f7 d8                	neg    %eax
 41a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41d:	eb 06                	jmp    425 <printint+0x31>
  } else {
    x = xx;
 41f:	8b 45 0c             	mov    0xc(%ebp),%eax
 422:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 425:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 42c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 42f:	8d 41 01             	lea    0x1(%ecx),%eax
 432:	89 45 f4             	mov    %eax,-0xc(%ebp)
 435:	8b 5d 10             	mov    0x10(%ebp),%ebx
 438:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43b:	ba 00 00 00 00       	mov    $0x0,%edx
 440:	f7 f3                	div    %ebx
 442:	89 d0                	mov    %edx,%eax
 444:	0f b6 80 c8 0a 00 00 	movzbl 0xac8(%eax),%eax
 44b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 44f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 452:	8b 45 ec             	mov    -0x14(%ebp),%eax
 455:	ba 00 00 00 00       	mov    $0x0,%edx
 45a:	f7 f3                	div    %ebx
 45c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 463:	75 c7                	jne    42c <printint+0x38>
  if(neg)
 465:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 469:	74 2d                	je     498 <printint+0xa4>
    buf[i++] = '-';
 46b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46e:	8d 50 01             	lea    0x1(%eax),%edx
 471:	89 55 f4             	mov    %edx,-0xc(%ebp)
 474:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 479:	eb 1d                	jmp    498 <printint+0xa4>
    putc(fd, buf[i]);
 47b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 481:	01 d0                	add    %edx,%eax
 483:	0f b6 00             	movzbl (%eax),%eax
 486:	0f be c0             	movsbl %al,%eax
 489:	83 ec 08             	sub    $0x8,%esp
 48c:	50                   	push   %eax
 48d:	ff 75 08             	pushl  0x8(%ebp)
 490:	e8 3c ff ff ff       	call   3d1 <putc>
 495:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 498:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 49c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a0:	79 d9                	jns    47b <printint+0x87>
    putc(fd, buf[i]);
}
 4a2:	90                   	nop
 4a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a6:	c9                   	leave  
 4a7:	c3                   	ret    

000004a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b8:	83 c0 04             	add    $0x4,%eax
 4bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c5:	e9 59 01 00 00       	jmp    623 <printf+0x17b>
    c = fmt[i] & 0xff;
 4ca:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d0:	01 d0                	add    %edx,%eax
 4d2:	0f b6 00             	movzbl (%eax),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	25 ff 00 00 00       	and    $0xff,%eax
 4dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e4:	75 2c                	jne    512 <printf+0x6a>
      if(c == '%'){
 4e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ea:	75 0c                	jne    4f8 <printf+0x50>
        state = '%';
 4ec:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f3:	e9 27 01 00 00       	jmp    61f <printf+0x177>
      } else {
        putc(fd, c);
 4f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fb:	0f be c0             	movsbl %al,%eax
 4fe:	83 ec 08             	sub    $0x8,%esp
 501:	50                   	push   %eax
 502:	ff 75 08             	pushl  0x8(%ebp)
 505:	e8 c7 fe ff ff       	call   3d1 <putc>
 50a:	83 c4 10             	add    $0x10,%esp
 50d:	e9 0d 01 00 00       	jmp    61f <printf+0x177>
      }
    } else if(state == '%'){
 512:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 516:	0f 85 03 01 00 00    	jne    61f <printf+0x177>
      if(c == 'd'){
 51c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 520:	75 1e                	jne    540 <printf+0x98>
        printint(fd, *ap, 10, 1);
 522:	8b 45 e8             	mov    -0x18(%ebp),%eax
 525:	8b 00                	mov    (%eax),%eax
 527:	6a 01                	push   $0x1
 529:	6a 0a                	push   $0xa
 52b:	50                   	push   %eax
 52c:	ff 75 08             	pushl  0x8(%ebp)
 52f:	e8 c0 fe ff ff       	call   3f4 <printint>
 534:	83 c4 10             	add    $0x10,%esp
        ap++;
 537:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53b:	e9 d8 00 00 00       	jmp    618 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 540:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 544:	74 06                	je     54c <printf+0xa4>
 546:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 54a:	75 1e                	jne    56a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 54c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54f:	8b 00                	mov    (%eax),%eax
 551:	6a 00                	push   $0x0
 553:	6a 10                	push   $0x10
 555:	50                   	push   %eax
 556:	ff 75 08             	pushl  0x8(%ebp)
 559:	e8 96 fe ff ff       	call   3f4 <printint>
 55e:	83 c4 10             	add    $0x10,%esp
        ap++;
 561:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 565:	e9 ae 00 00 00       	jmp    618 <printf+0x170>
      } else if(c == 's'){
 56a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56e:	75 43                	jne    5b3 <printf+0x10b>
        s = (char*)*ap;
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 57c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 580:	75 25                	jne    5a7 <printf+0xff>
          s = "(null)";
 582:	c7 45 f4 78 08 00 00 	movl   $0x878,-0xc(%ebp)
        while(*s != 0){
 589:	eb 1c                	jmp    5a7 <printf+0xff>
          putc(fd, *s);
 58b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 31 fe ff ff       	call   3d1 <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
          s++;
 5a3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5aa:	0f b6 00             	movzbl (%eax),%eax
 5ad:	84 c0                	test   %al,%al
 5af:	75 da                	jne    58b <printf+0xe3>
 5b1:	eb 65                	jmp    618 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b7:	75 1d                	jne    5d6 <printf+0x12e>
        putc(fd, *ap);
 5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	83 ec 08             	sub    $0x8,%esp
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 04 fe ff ff       	call   3d1 <putc>
 5cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d4:	eb 42                	jmp    618 <printf+0x170>
      } else if(c == '%'){
 5d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5da:	75 17                	jne    5f3 <printf+0x14b>
        putc(fd, c);
 5dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 e3 fd ff ff       	call   3d1 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
 5f1:	eb 25                	jmp    618 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	6a 25                	push   $0x25
 5f8:	ff 75 08             	pushl  0x8(%ebp)
 5fb:	e8 d1 fd ff ff       	call   3d1 <putc>
 600:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 606:	0f be c0             	movsbl %al,%eax
 609:	83 ec 08             	sub    $0x8,%esp
 60c:	50                   	push   %eax
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 bc fd ff ff       	call   3d1 <putc>
 615:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 618:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 623:	8b 55 0c             	mov    0xc(%ebp),%edx
 626:	8b 45 f0             	mov    -0x10(%ebp),%eax
 629:	01 d0                	add    %edx,%eax
 62b:	0f b6 00             	movzbl (%eax),%eax
 62e:	84 c0                	test   %al,%al
 630:	0f 85 94 fe ff ff    	jne    4ca <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 636:	90                   	nop
 637:	c9                   	leave  
 638:	c3                   	ret    

00000639 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	83 e8 08             	sub    $0x8,%eax
 645:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 648:	a1 e4 0a 00 00       	mov    0xae4,%eax
 64d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 650:	eb 24                	jmp    676 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65a:	77 12                	ja     66e <free+0x35>
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 662:	77 24                	ja     688 <free+0x4f>
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66c:	77 1a                	ja     688 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	89 45 fc             	mov    %eax,-0x4(%ebp)
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67c:	76 d4                	jbe    652 <free+0x19>
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 686:	76 ca                	jbe    652 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	8b 40 04             	mov    0x4(%eax),%eax
 68e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 695:	8b 45 f8             	mov    -0x8(%ebp),%eax
 698:	01 c2                	add    %eax,%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	39 c2                	cmp    %eax,%edx
 6a1:	75 24                	jne    6c7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 50 04             	mov    0x4(%eax),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	8b 40 04             	mov    0x4(%eax),%eax
 6b1:	01 c2                	add    %eax,%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 00                	mov    (%eax),%eax
 6be:	8b 10                	mov    (%eax),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	89 10                	mov    %edx,(%eax)
 6c5:	eb 0a                	jmp    6d1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 10                	mov    (%eax),%edx
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	01 d0                	add    %edx,%eax
 6e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e6:	75 20                	jne    708 <free+0xcf>
    p->s.size += bp->s.size;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 50 04             	mov    0x4(%eax),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 40 04             	mov    0x4(%eax),%eax
 6f4:	01 c2                	add    %eax,%edx
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	8b 10                	mov    (%eax),%edx
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	89 10                	mov    %edx,(%eax)
 706:	eb 08                	jmp    710 <free+0xd7>
  } else
    p->s.ptr = bp;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70e:	89 10                	mov    %edx,(%eax)
  freep = p;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	a3 e4 0a 00 00       	mov    %eax,0xae4
}
 718:	90                   	nop
 719:	c9                   	leave  
 71a:	c3                   	ret    

0000071b <morecore>:

static Header*
morecore(uint nu)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 721:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 728:	77 07                	ja     731 <morecore+0x16>
    nu = 4096;
 72a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	c1 e0 03             	shl    $0x3,%eax
 737:	83 ec 0c             	sub    $0xc,%esp
 73a:	50                   	push   %eax
 73b:	e8 39 fc ff ff       	call   379 <sbrk>
 740:	83 c4 10             	add    $0x10,%esp
 743:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 746:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74a:	75 07                	jne    753 <morecore+0x38>
    return 0;
 74c:	b8 00 00 00 00       	mov    $0x0,%eax
 751:	eb 26                	jmp    779 <morecore+0x5e>
  hp = (Header*)p;
 753:	8b 45 f4             	mov    -0xc(%ebp),%eax
 756:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	8b 55 08             	mov    0x8(%ebp),%edx
 75f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 762:	8b 45 f0             	mov    -0x10(%ebp),%eax
 765:	83 c0 08             	add    $0x8,%eax
 768:	83 ec 0c             	sub    $0xc,%esp
 76b:	50                   	push   %eax
 76c:	e8 c8 fe ff ff       	call   639 <free>
 771:	83 c4 10             	add    $0x10,%esp
  return freep;
 774:	a1 e4 0a 00 00       	mov    0xae4,%eax
}
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <malloc>:

void*
malloc(uint nbytes)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	83 c0 07             	add    $0x7,%eax
 787:	c1 e8 03             	shr    $0x3,%eax
 78a:	83 c0 01             	add    $0x1,%eax
 78d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 790:	a1 e4 0a 00 00       	mov    0xae4,%eax
 795:	89 45 f0             	mov    %eax,-0x10(%ebp)
 798:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79c:	75 23                	jne    7c1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79e:	c7 45 f0 dc 0a 00 00 	movl   $0xadc,-0x10(%ebp)
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	a3 e4 0a 00 00       	mov    %eax,0xae4
 7ad:	a1 e4 0a 00 00       	mov    0xae4,%eax
 7b2:	a3 dc 0a 00 00       	mov    %eax,0xadc
    base.s.size = 0;
 7b7:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 7be:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d2:	72 4d                	jb     821 <malloc+0xa6>
      if(p->s.size == nunits)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7dd:	75 0c                	jne    7eb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 10                	mov    (%eax),%edx
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	89 10                	mov    %edx,(%eax)
 7e9:	eb 26                	jmp    811 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f4:	89 c2                	mov    %eax,%edx
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	c1 e0 03             	shl    $0x3,%eax
 805:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	a3 e4 0a 00 00       	mov    %eax,0xae4
      return (void*)(p + 1);
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	83 c0 08             	add    $0x8,%eax
 81f:	eb 3b                	jmp    85c <malloc+0xe1>
    }
    if(p == freep)
 821:	a1 e4 0a 00 00       	mov    0xae4,%eax
 826:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 829:	75 1e                	jne    849 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 82b:	83 ec 0c             	sub    $0xc,%esp
 82e:	ff 75 ec             	pushl  -0x14(%ebp)
 831:	e8 e5 fe ff ff       	call   71b <morecore>
 836:	83 c4 10             	add    $0x10,%esp
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
 83c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 840:	75 07                	jne    849 <malloc+0xce>
        return 0;
 842:	b8 00 00 00 00       	mov    $0x0,%eax
 847:	eb 13                	jmp    85c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 00                	mov    (%eax),%eax
 854:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 857:	e9 6d ff ff ff       	jmp    7c9 <malloc+0x4e>
}
 85c:	c9                   	leave  
 85d:	c3                   	ret    
