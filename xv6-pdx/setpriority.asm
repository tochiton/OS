
_setpriority:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int pid = atoi(argv[1]);	
  14:	8b 43 04             	mov    0x4(%ebx),%eax
  17:	83 c0 04             	add    $0x4,%eax
  1a:	8b 00                	mov    (%eax),%eax
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	50                   	push   %eax
  20:	e8 25 02 00 00       	call   24a <atoi>
  25:	83 c4 10             	add    $0x10,%esp
  28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int priority = atoi(argv[2]);	
  2b:	8b 43 04             	mov    0x4(%ebx),%eax
  2e:	83 c0 08             	add    $0x8,%eax
  31:	8b 00                	mov    (%eax),%eax
  33:	83 ec 0c             	sub    $0xc,%esp
  36:	50                   	push   %eax
  37:	e8 0e 02 00 00       	call   24a <atoi>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"testing setting priority %d...%d\n", pid, priority);
  42:	ff 75 f0             	pushl  -0x10(%ebp)
  45:	ff 75 f4             	pushl  -0xc(%ebp)
  48:	68 98 08 00 00       	push   $0x898
  4d:	6a 01                	push   $0x1
  4f:	e8 8c 04 00 00       	call   4e0 <printf>
  54:	83 c4 10             	add    $0x10,%esp
  int rc = setpriority(pid, priority);
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	ff 75 f0             	pushl  -0x10(%ebp)
  5d:	ff 75 f4             	pushl  -0xc(%ebp)
  60:	e8 9c 03 00 00       	call   401 <setpriority>
  65:	83 c4 10             	add    $0x10,%esp
  68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(1,"The RC values is: %d\n", rc);		
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	ff 75 ec             	pushl  -0x14(%ebp)
  71:	68 ba 08 00 00       	push   $0x8ba
  76:	6a 01                	push   $0x1
  78:	e8 63 04 00 00       	call   4e0 <printf>
  7d:	83 c4 10             	add    $0x10,%esp
  //printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  exit();
  80:	e8 9c 02 00 00       	call   321 <exit>

00000085 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  88:	57                   	push   %edi
  89:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8d:	8b 55 10             	mov    0x10(%ebp),%edx
  90:	8b 45 0c             	mov    0xc(%ebp),%eax
  93:	89 cb                	mov    %ecx,%ebx
  95:	89 df                	mov    %ebx,%edi
  97:	89 d1                	mov    %edx,%ecx
  99:	fc                   	cld    
  9a:	f3 aa                	rep stos %al,%es:(%edi)
  9c:	89 ca                	mov    %ecx,%edx
  9e:	89 fb                	mov    %edi,%ebx
  a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a6:	90                   	nop
  a7:	5b                   	pop    %ebx
  a8:	5f                   	pop    %edi
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b1:	8b 45 08             	mov    0x8(%ebp),%eax
  b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b7:	90                   	nop
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	8d 50 01             	lea    0x1(%eax),%edx
  be:	89 55 08             	mov    %edx,0x8(%ebp)
  c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ca:	0f b6 12             	movzbl (%edx),%edx
  cd:	88 10                	mov    %dl,(%eax)
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	84 c0                	test   %al,%al
  d4:	75 e2                	jne    b8 <strcpy+0xd>
    ;
  return os;
  d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d9:	c9                   	leave  
  da:	c3                   	ret    

000000db <strcmp>:

int
strcmp(const char *p, const char *q)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  de:	eb 08                	jmp    e8 <strcmp+0xd>
    p++, q++;
  e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	84 c0                	test   %al,%al
  f0:	74 10                	je     102 <strcmp+0x27>
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 10             	movzbl (%eax),%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	38 c2                	cmp    %al,%dl
 100:	74 de                	je     e0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	0f b6 d0             	movzbl %al,%edx
 10b:	8b 45 0c             	mov    0xc(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	0f b6 c0             	movzbl %al,%eax
 114:	29 c2                	sub    %eax,%edx
 116:	89 d0                	mov    %edx,%eax
}
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    

0000011a <strlen>:

uint
strlen(char *s)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 127:	eb 04                	jmp    12d <strlen+0x13>
 129:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	01 d0                	add    %edx,%eax
 135:	0f b6 00             	movzbl (%eax),%eax
 138:	84 c0                	test   %al,%al
 13a:	75 ed                	jne    129 <strlen+0xf>
    ;
  return n;
 13c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13f:	c9                   	leave  
 140:	c3                   	ret    

00000141 <memset>:

void*
memset(void *dst, int c, uint n)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 144:	8b 45 10             	mov    0x10(%ebp),%eax
 147:	50                   	push   %eax
 148:	ff 75 0c             	pushl  0xc(%ebp)
 14b:	ff 75 08             	pushl  0x8(%ebp)
 14e:	e8 32 ff ff ff       	call   85 <stosb>
 153:	83 c4 0c             	add    $0xc,%esp
  return dst;
 156:	8b 45 08             	mov    0x8(%ebp),%eax
}
 159:	c9                   	leave  
 15a:	c3                   	ret    

0000015b <strchr>:

char*
strchr(const char *s, char c)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
 15e:	83 ec 04             	sub    $0x4,%esp
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 167:	eb 14                	jmp    17d <strchr+0x22>
    if(*s == c)
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	0f b6 00             	movzbl (%eax),%eax
 16f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 172:	75 05                	jne    179 <strchr+0x1e>
      return (char*)s;
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	eb 13                	jmp    18c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 179:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	75 e2                	jne    169 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 187:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <gets>:

char*
gets(char *buf, int max)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19b:	eb 42                	jmp    1df <gets+0x51>
    cc = read(0, &c, 1);
 19d:	83 ec 04             	sub    $0x4,%esp
 1a0:	6a 01                	push   $0x1
 1a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a5:	50                   	push   %eax
 1a6:	6a 00                	push   $0x0
 1a8:	e8 8c 01 00 00       	call   339 <read>
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b7:	7e 33                	jle    1ec <gets+0x5e>
      break;
    buf[i++] = c;
 1b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bc:	8d 50 01             	lea    0x1(%eax),%edx
 1bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c2:	89 c2                	mov    %eax,%edx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	01 c2                	add    %eax,%edx
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d3:	3c 0a                	cmp    $0xa,%al
 1d5:	74 16                	je     1ed <gets+0x5f>
 1d7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1db:	3c 0d                	cmp    $0xd,%al
 1dd:	74 0e                	je     1ed <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e2:	83 c0 01             	add    $0x1,%eax
 1e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e8:	7c b3                	jl     19d <gets+0xf>
 1ea:	eb 01                	jmp    1ed <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ec:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	01 d0                	add    %edx,%eax
 1f5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <stat>:

int
stat(char *n, struct stat *st)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	6a 00                	push   $0x0
 208:	ff 75 08             	pushl  0x8(%ebp)
 20b:	e8 51 01 00 00       	call   361 <open>
 210:	83 c4 10             	add    $0x10,%esp
 213:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 21a:	79 07                	jns    223 <stat+0x26>
    return -1;
 21c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 221:	eb 25                	jmp    248 <stat+0x4b>
  r = fstat(fd, st);
 223:	83 ec 08             	sub    $0x8,%esp
 226:	ff 75 0c             	pushl  0xc(%ebp)
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 48 01 00 00       	call   379 <fstat>
 231:	83 c4 10             	add    $0x10,%esp
 234:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 237:	83 ec 0c             	sub    $0xc,%esp
 23a:	ff 75 f4             	pushl  -0xc(%ebp)
 23d:	e8 07 01 00 00       	call   349 <close>
 242:	83 c4 10             	add    $0x10,%esp
  return r;
 245:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 248:	c9                   	leave  
 249:	c3                   	ret    

0000024a <atoi>:

int
atoi(const char *s)
{
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 257:	eb 04                	jmp    25d <atoi+0x13>
 259:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	0f b6 00             	movzbl (%eax),%eax
 263:	3c 20                	cmp    $0x20,%al
 265:	74 f2                	je     259 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	3c 2d                	cmp    $0x2d,%al
 26f:	75 07                	jne    278 <atoi+0x2e>
 271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 276:	eb 05                	jmp    27d <atoi+0x33>
 278:	b8 01 00 00 00       	mov    $0x1,%eax
 27d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 2b                	cmp    $0x2b,%al
 288:	74 0a                	je     294 <atoi+0x4a>
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	3c 2d                	cmp    $0x2d,%al
 292:	75 2b                	jne    2bf <atoi+0x75>
    s++;
 294:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 298:	eb 25                	jmp    2bf <atoi+0x75>
    n = n*10 + *s++ - '0';
 29a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29d:	89 d0                	mov    %edx,%eax
 29f:	c1 e0 02             	shl    $0x2,%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	01 c0                	add    %eax,%eax
 2a6:	89 c1                	mov    %eax,%ecx
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8d 50 01             	lea    0x1(%eax),%edx
 2ae:	89 55 08             	mov    %edx,0x8(%ebp)
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	0f be c0             	movsbl %al,%eax
 2b7:	01 c8                	add    %ecx,%eax
 2b9:	83 e8 30             	sub    $0x30,%eax
 2bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2f                	cmp    $0x2f,%al
 2c7:	7e 0a                	jle    2d3 <atoi+0x89>
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 39                	cmp    $0x39,%al
 2d1:	7e c7                	jle    29a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2d6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2da:	c9                   	leave  
 2db:	c3                   	ret    

000002dc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ee:	eb 17                	jmp    307 <memmove+0x2b>
    *dst++ = *src++;
 2f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f3:	8d 50 01             	lea    0x1(%eax),%edx
 2f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ff:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 302:	0f b6 12             	movzbl (%edx),%edx
 305:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 307:	8b 45 10             	mov    0x10(%ebp),%eax
 30a:	8d 50 ff             	lea    -0x1(%eax),%edx
 30d:	89 55 10             	mov    %edx,0x10(%ebp)
 310:	85 c0                	test   %eax,%eax
 312:	7f dc                	jg     2f0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 314:	8b 45 08             	mov    0x8(%ebp),%eax
}
 317:	c9                   	leave  
 318:	c3                   	ret    

00000319 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 319:	b8 01 00 00 00       	mov    $0x1,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <exit>:
SYSCALL(exit)
 321:	b8 02 00 00 00       	mov    $0x2,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <wait>:
SYSCALL(wait)
 329:	b8 03 00 00 00       	mov    $0x3,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <pipe>:
SYSCALL(pipe)
 331:	b8 04 00 00 00       	mov    $0x4,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <read>:
SYSCALL(read)
 339:	b8 05 00 00 00       	mov    $0x5,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <write>:
SYSCALL(write)
 341:	b8 10 00 00 00       	mov    $0x10,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <close>:
SYSCALL(close)
 349:	b8 15 00 00 00       	mov    $0x15,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <kill>:
SYSCALL(kill)
 351:	b8 06 00 00 00       	mov    $0x6,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <exec>:
SYSCALL(exec)
 359:	b8 07 00 00 00       	mov    $0x7,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <open>:
SYSCALL(open)
 361:	b8 0f 00 00 00       	mov    $0xf,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <mknod>:
SYSCALL(mknod)
 369:	b8 11 00 00 00       	mov    $0x11,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <unlink>:
SYSCALL(unlink)
 371:	b8 12 00 00 00       	mov    $0x12,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <fstat>:
SYSCALL(fstat)
 379:	b8 08 00 00 00       	mov    $0x8,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <link>:
SYSCALL(link)
 381:	b8 13 00 00 00       	mov    $0x13,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <mkdir>:
SYSCALL(mkdir)
 389:	b8 14 00 00 00       	mov    $0x14,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <chdir>:
SYSCALL(chdir)
 391:	b8 09 00 00 00       	mov    $0x9,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <dup>:
SYSCALL(dup)
 399:	b8 0a 00 00 00       	mov    $0xa,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <getpid>:
SYSCALL(getpid)
 3a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <sbrk>:
SYSCALL(sbrk)
 3a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <sleep>:
SYSCALL(sleep)
 3b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <uptime>:
SYSCALL(uptime)
 3b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <halt>:
SYSCALL(halt)
 3c1:	b8 16 00 00 00       	mov    $0x16,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <date>:
SYSCALL(date)
 3c9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <getuid>:
SYSCALL(getuid)
 3d1:	b8 18 00 00 00       	mov    $0x18,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <getgid>:
SYSCALL(getgid)
 3d9:	b8 19 00 00 00       	mov    $0x19,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <getppid>:
SYSCALL(getppid)
 3e1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <setuid>:
SYSCALL(setuid)
 3e9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <setgid>:
SYSCALL(setgid)
 3f1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <getprocs>:
SYSCALL(getprocs)
 3f9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <setpriority>:
SYSCALL(setpriority)
 401:	b8 1e 00 00 00       	mov    $0x1e,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 18             	sub    $0x18,%esp
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 415:	83 ec 04             	sub    $0x4,%esp
 418:	6a 01                	push   $0x1
 41a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 41d:	50                   	push   %eax
 41e:	ff 75 08             	pushl  0x8(%ebp)
 421:	e8 1b ff ff ff       	call   341 <write>
 426:	83 c4 10             	add    $0x10,%esp
}
 429:	90                   	nop
 42a:	c9                   	leave  
 42b:	c3                   	ret    

0000042c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42c:	55                   	push   %ebp
 42d:	89 e5                	mov    %esp,%ebp
 42f:	53                   	push   %ebx
 430:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 433:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 43a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 43e:	74 17                	je     457 <printint+0x2b>
 440:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 444:	79 11                	jns    457 <printint+0x2b>
    neg = 1;
 446:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	f7 d8                	neg    %eax
 452:	89 45 ec             	mov    %eax,-0x14(%ebp)
 455:	eb 06                	jmp    45d <printint+0x31>
  } else {
    x = xx;
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 45d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 464:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 467:	8d 41 01             	lea    0x1(%ecx),%eax
 46a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 46d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 470:	8b 45 ec             	mov    -0x14(%ebp),%eax
 473:	ba 00 00 00 00       	mov    $0x0,%edx
 478:	f7 f3                	div    %ebx
 47a:	89 d0                	mov    %edx,%eax
 47c:	0f b6 80 24 0b 00 00 	movzbl 0xb24(%eax),%eax
 483:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 487:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48d:	ba 00 00 00 00       	mov    $0x0,%edx
 492:	f7 f3                	div    %ebx
 494:	89 45 ec             	mov    %eax,-0x14(%ebp)
 497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49b:	75 c7                	jne    464 <printint+0x38>
  if(neg)
 49d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a1:	74 2d                	je     4d0 <printint+0xa4>
    buf[i++] = '-';
 4a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a6:	8d 50 01             	lea    0x1(%eax),%edx
 4a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4b1:	eb 1d                	jmp    4d0 <printint+0xa4>
    putc(fd, buf[i]);
 4b3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b9:	01 d0                	add    %edx,%eax
 4bb:	0f b6 00             	movzbl (%eax),%eax
 4be:	0f be c0             	movsbl %al,%eax
 4c1:	83 ec 08             	sub    $0x8,%esp
 4c4:	50                   	push   %eax
 4c5:	ff 75 08             	pushl  0x8(%ebp)
 4c8:	e8 3c ff ff ff       	call   409 <putc>
 4cd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d8:	79 d9                	jns    4b3 <printint+0x87>
    putc(fd, buf[i]);
}
 4da:	90                   	nop
 4db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4ed:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f0:	83 c0 04             	add    $0x4,%eax
 4f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4fd:	e9 59 01 00 00       	jmp    65b <printf+0x17b>
    c = fmt[i] & 0xff;
 502:	8b 55 0c             	mov    0xc(%ebp),%edx
 505:	8b 45 f0             	mov    -0x10(%ebp),%eax
 508:	01 d0                	add    %edx,%eax
 50a:	0f b6 00             	movzbl (%eax),%eax
 50d:	0f be c0             	movsbl %al,%eax
 510:	25 ff 00 00 00       	and    $0xff,%eax
 515:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 518:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51c:	75 2c                	jne    54a <printf+0x6a>
      if(c == '%'){
 51e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 522:	75 0c                	jne    530 <printf+0x50>
        state = '%';
 524:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52b:	e9 27 01 00 00       	jmp    657 <printf+0x177>
      } else {
        putc(fd, c);
 530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	83 ec 08             	sub    $0x8,%esp
 539:	50                   	push   %eax
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 c7 fe ff ff       	call   409 <putc>
 542:	83 c4 10             	add    $0x10,%esp
 545:	e9 0d 01 00 00       	jmp    657 <printf+0x177>
      }
    } else if(state == '%'){
 54a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 54e:	0f 85 03 01 00 00    	jne    657 <printf+0x177>
      if(c == 'd'){
 554:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 558:	75 1e                	jne    578 <printf+0x98>
        printint(fd, *ap, 10, 1);
 55a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55d:	8b 00                	mov    (%eax),%eax
 55f:	6a 01                	push   $0x1
 561:	6a 0a                	push   $0xa
 563:	50                   	push   %eax
 564:	ff 75 08             	pushl  0x8(%ebp)
 567:	e8 c0 fe ff ff       	call   42c <printint>
 56c:	83 c4 10             	add    $0x10,%esp
        ap++;
 56f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 573:	e9 d8 00 00 00       	jmp    650 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 578:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 57c:	74 06                	je     584 <printf+0xa4>
 57e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 582:	75 1e                	jne    5a2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 584:	8b 45 e8             	mov    -0x18(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	6a 00                	push   $0x0
 58b:	6a 10                	push   $0x10
 58d:	50                   	push   %eax
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 96 fe ff ff       	call   42c <printint>
 596:	83 c4 10             	add    $0x10,%esp
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59d:	e9 ae 00 00 00       	jmp    650 <printf+0x170>
      } else if(c == 's'){
 5a2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5a6:	75 43                	jne    5eb <printf+0x10b>
        s = (char*)*ap;
 5a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ab:	8b 00                	mov    (%eax),%eax
 5ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b8:	75 25                	jne    5df <printf+0xff>
          s = "(null)";
 5ba:	c7 45 f4 d0 08 00 00 	movl   $0x8d0,-0xc(%ebp)
        while(*s != 0){
 5c1:	eb 1c                	jmp    5df <printf+0xff>
          putc(fd, *s);
 5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	83 ec 08             	sub    $0x8,%esp
 5cf:	50                   	push   %eax
 5d0:	ff 75 08             	pushl  0x8(%ebp)
 5d3:	e8 31 fe ff ff       	call   409 <putc>
 5d8:	83 c4 10             	add    $0x10,%esp
          s++;
 5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	84 c0                	test   %al,%al
 5e7:	75 da                	jne    5c3 <printf+0xe3>
 5e9:	eb 65                	jmp    650 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5eb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ef:	75 1d                	jne    60e <printf+0x12e>
        putc(fd, *ap);
 5f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 04 fe ff ff       	call   409 <putc>
 605:	83 c4 10             	add    $0x10,%esp
        ap++;
 608:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60c:	eb 42                	jmp    650 <printf+0x170>
      } else if(c == '%'){
 60e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 612:	75 17                	jne    62b <printf+0x14b>
        putc(fd, c);
 614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 617:	0f be c0             	movsbl %al,%eax
 61a:	83 ec 08             	sub    $0x8,%esp
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 e3 fd ff ff       	call   409 <putc>
 626:	83 c4 10             	add    $0x10,%esp
 629:	eb 25                	jmp    650 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	6a 25                	push   $0x25
 630:	ff 75 08             	pushl  0x8(%ebp)
 633:	e8 d1 fd ff ff       	call   409 <putc>
 638:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 63b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	83 ec 08             	sub    $0x8,%esp
 644:	50                   	push   %eax
 645:	ff 75 08             	pushl  0x8(%ebp)
 648:	e8 bc fd ff ff       	call   409 <putc>
 64d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 650:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 657:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 65b:	8b 55 0c             	mov    0xc(%ebp),%edx
 65e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 661:	01 d0                	add    %edx,%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	84 c0                	test   %al,%al
 668:	0f 85 94 fe ff ff    	jne    502 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66e:	90                   	nop
 66f:	c9                   	leave  
 670:	c3                   	ret    

00000671 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 671:	55                   	push   %ebp
 672:	89 e5                	mov    %esp,%ebp
 674:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	83 e8 08             	sub    $0x8,%eax
 67d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 680:	a1 40 0b 00 00       	mov    0xb40,%eax
 685:	89 45 fc             	mov    %eax,-0x4(%ebp)
 688:	eb 24                	jmp    6ae <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 692:	77 12                	ja     6a6 <free+0x35>
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69a:	77 24                	ja     6c0 <free+0x4f>
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a4:	77 1a                	ja     6c0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b4:	76 d4                	jbe    68a <free+0x19>
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6be:	76 ca                	jbe    68a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	8b 40 04             	mov    0x4(%eax),%eax
 6c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	01 c2                	add    %eax,%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	39 c2                	cmp    %eax,%edx
 6d9:	75 24                	jne    6ff <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 50 04             	mov    0x4(%eax),%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	8b 40 04             	mov    0x4(%eax),%eax
 6e9:	01 c2                	add    %eax,%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	8b 10                	mov    (%eax),%edx
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	89 10                	mov    %edx,(%eax)
 6fd:	eb 0a                	jmp    709 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 10                	mov    (%eax),%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 40 04             	mov    0x4(%eax),%eax
 70f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	01 d0                	add    %edx,%eax
 71b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71e:	75 20                	jne    740 <free+0xcf>
    p->s.size += bp->s.size;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 50 04             	mov    0x4(%eax),%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	01 c2                	add    %eax,%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	8b 10                	mov    (%eax),%edx
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	89 10                	mov    %edx,(%eax)
 73e:	eb 08                	jmp    748 <free+0xd7>
  } else
    p->s.ptr = bp;
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 55 f8             	mov    -0x8(%ebp),%edx
 746:	89 10                	mov    %edx,(%eax)
  freep = p;
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	a3 40 0b 00 00       	mov    %eax,0xb40
}
 750:	90                   	nop
 751:	c9                   	leave  
 752:	c3                   	ret    

00000753 <morecore>:

static Header*
morecore(uint nu)
{
 753:	55                   	push   %ebp
 754:	89 e5                	mov    %esp,%ebp
 756:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 759:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 760:	77 07                	ja     769 <morecore+0x16>
    nu = 4096;
 762:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	c1 e0 03             	shl    $0x3,%eax
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	50                   	push   %eax
 773:	e8 31 fc ff ff       	call   3a9 <sbrk>
 778:	83 c4 10             	add    $0x10,%esp
 77b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 77e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 782:	75 07                	jne    78b <morecore+0x38>
    return 0;
 784:	b8 00 00 00 00       	mov    $0x0,%eax
 789:	eb 26                	jmp    7b1 <morecore+0x5e>
  hp = (Header*)p;
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 791:	8b 45 f0             	mov    -0x10(%ebp),%eax
 794:	8b 55 08             	mov    0x8(%ebp),%edx
 797:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	83 c0 08             	add    $0x8,%eax
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	50                   	push   %eax
 7a4:	e8 c8 fe ff ff       	call   671 <free>
 7a9:	83 c4 10             	add    $0x10,%esp
  return freep;
 7ac:	a1 40 0b 00 00       	mov    0xb40,%eax
}
 7b1:	c9                   	leave  
 7b2:	c3                   	ret    

000007b3 <malloc>:

void*
malloc(uint nbytes)
{
 7b3:	55                   	push   %ebp
 7b4:	89 e5                	mov    %esp,%ebp
 7b6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
 7bc:	83 c0 07             	add    $0x7,%eax
 7bf:	c1 e8 03             	shr    $0x3,%eax
 7c2:	83 c0 01             	add    $0x1,%eax
 7c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7c8:	a1 40 0b 00 00       	mov    0xb40,%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d4:	75 23                	jne    7f9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7d6:	c7 45 f0 38 0b 00 00 	movl   $0xb38,-0x10(%ebp)
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	a3 40 0b 00 00       	mov    %eax,0xb40
 7e5:	a1 40 0b 00 00       	mov    0xb40,%eax
 7ea:	a3 38 0b 00 00       	mov    %eax,0xb38
    base.s.size = 0;
 7ef:	c7 05 3c 0b 00 00 00 	movl   $0x0,0xb3c
 7f6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80a:	72 4d                	jb     859 <malloc+0xa6>
      if(p->s.size == nunits)
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 815:	75 0c                	jne    823 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 10                	mov    (%eax),%edx
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	89 10                	mov    %edx,(%eax)
 821:	eb 26                	jmp    849 <malloc+0x96>
      else {
        p->s.size -= nunits;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	2b 45 ec             	sub    -0x14(%ebp),%eax
 82c:	89 c2                	mov    %eax,%edx
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	c1 e0 03             	shl    $0x3,%eax
 83d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 55 ec             	mov    -0x14(%ebp),%edx
 846:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	a3 40 0b 00 00       	mov    %eax,0xb40
      return (void*)(p + 1);
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	83 c0 08             	add    $0x8,%eax
 857:	eb 3b                	jmp    894 <malloc+0xe1>
    }
    if(p == freep)
 859:	a1 40 0b 00 00       	mov    0xb40,%eax
 85e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 861:	75 1e                	jne    881 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	ff 75 ec             	pushl  -0x14(%ebp)
 869:	e8 e5 fe ff ff       	call   753 <morecore>
 86e:	83 c4 10             	add    $0x10,%esp
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
 874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 878:	75 07                	jne    881 <malloc+0xce>
        return 0;
 87a:	b8 00 00 00 00       	mov    $0x0,%eax
 87f:	eb 13                	jmp    894 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	89 45 f0             	mov    %eax,-0x10(%ebp)
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	8b 00                	mov    (%eax),%eax
 88c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 88f:	e9 6d ff ff ff       	jmp    801 <malloc+0x4e>
}
 894:	c9                   	leave  
 895:	c3                   	ret    
