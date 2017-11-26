
_chgrp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P5
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
  11:	89 c8                	mov    %ecx,%eax
  //printf(1, "Not imlpemented yet.\n");
  if(argc < 3) exit();
  13:	83 38 02             	cmpl   $0x2,(%eax)
  16:	7f 05                	jg     1d <main+0x1d>
  18:	e8 f8 02 00 00       	call   315 <exit>

  char * path = argv[2];
  1d:	8b 50 04             	mov    0x4(%eax),%edx
  20:	8b 52 08             	mov    0x8(%edx),%edx
  23:	89 55 f4             	mov    %edx,-0xc(%ebp)
  int group = atoi(argv[1]);
  26:	8b 40 04             	mov    0x4(%eax),%eax
  29:	83 c0 04             	add    $0x4,%eax
  2c:	8b 00                	mov    (%eax),%eax
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	50                   	push   %eax
  32:	e8 07 02 00 00       	call   23e <atoi>
  37:	83 c4 10             	add    $0x10,%esp
  3a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(group < 0 || group > 32767){
  3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  41:	78 09                	js     4c <main+0x4c>
  43:	81 7d f0 ff 7f 00 00 	cmpl   $0x7fff,-0x10(%ebp)
  4a:	7e 17                	jle    63 <main+0x63>
    printf(1,"Invalid argument");
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	68 a2 08 00 00       	push   $0x8a2
  54:	6a 01                	push   $0x1
  56:	e8 91 04 00 00       	call   4ec <printf>
  5b:	83 c4 10             	add    $0x10,%esp
    exit();
  5e:	e8 b2 02 00 00       	call   315 <exit>
  }
  chgrp(path, group);
  63:	83 ec 08             	sub    $0x8,%esp
  66:	ff 75 f0             	pushl  -0x10(%ebp)
  69:	ff 75 f4             	pushl  -0xc(%ebp)
  6c:	e8 9c 03 00 00       	call   40d <chgrp>
  71:	83 c4 10             	add    $0x10,%esp

  exit();
  74:	e8 9c 02 00 00       	call   315 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	90                   	nop
  9b:	5b                   	pop    %ebx
  9c:	5f                   	pop    %edi
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ab:	90                   	nop
  ac:	8b 45 08             	mov    0x8(%ebp),%eax
  af:	8d 50 01             	lea    0x1(%eax),%edx
  b2:	89 55 08             	mov    %edx,0x8(%ebp)
  b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	88 10                	mov    %dl,(%eax)
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	84 c0                	test   %al,%al
  c8:	75 e2                	jne    ac <strcpy+0xd>
    ;
  return os;
  ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cd:	c9                   	leave  
  ce:	c3                   	ret    

000000cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d2:	eb 08                	jmp    dc <strcmp+0xd>
    p++, q++;
  d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 00             	movzbl (%eax),%eax
  e2:	84 c0                	test   %al,%al
  e4:	74 10                	je     f6 <strcmp+0x27>
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	0f b6 10             	movzbl (%eax),%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	38 c2                	cmp    %al,%dl
  f4:	74 de                	je     d4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	0f b6 d0             	movzbl %al,%edx
  ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	0f b6 c0             	movzbl %al,%eax
 108:	29 c2                	sub    %eax,%edx
 10a:	89 d0                	mov    %edx,%eax
}
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    

0000010e <strlen>:

uint
strlen(char *s)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 114:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11b:	eb 04                	jmp    121 <strlen+0x13>
 11d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 121:	8b 55 fc             	mov    -0x4(%ebp),%edx
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	01 d0                	add    %edx,%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	84 c0                	test   %al,%al
 12e:	75 ed                	jne    11d <strlen+0xf>
    ;
  return n;
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <memset>:

void*
memset(void *dst, int c, uint n)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 138:	8b 45 10             	mov    0x10(%ebp),%eax
 13b:	50                   	push   %eax
 13c:	ff 75 0c             	pushl  0xc(%ebp)
 13f:	ff 75 08             	pushl  0x8(%ebp)
 142:	e8 32 ff ff ff       	call   79 <stosb>
 147:	83 c4 0c             	add    $0xc,%esp
  return dst;
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strchr>:

char*
strchr(const char *s, char c)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 04             	sub    $0x4,%esp
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15b:	eb 14                	jmp    171 <strchr+0x22>
    if(*s == c)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	3a 45 fc             	cmp    -0x4(%ebp),%al
 166:	75 05                	jne    16d <strchr+0x1e>
      return (char*)s;
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	eb 13                	jmp    180 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 16d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	75 e2                	jne    15d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 17b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <gets>:

char*
gets(char *buf, int max)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18f:	eb 42                	jmp    1d3 <gets+0x51>
    cc = read(0, &c, 1);
 191:	83 ec 04             	sub    $0x4,%esp
 194:	6a 01                	push   $0x1
 196:	8d 45 ef             	lea    -0x11(%ebp),%eax
 199:	50                   	push   %eax
 19a:	6a 00                	push   $0x0
 19c:	e8 8c 01 00 00       	call   32d <read>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ab:	7e 33                	jle    1e0 <gets+0x5e>
      break;
    buf[i++] = c;
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	8d 50 01             	lea    0x1(%eax),%edx
 1b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b6:	89 c2                	mov    %eax,%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 c2                	add    %eax,%edx
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	3c 0a                	cmp    $0xa,%al
 1c9:	74 16                	je     1e1 <gets+0x5f>
 1cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cf:	3c 0d                	cmp    $0xd,%al
 1d1:	74 0e                	je     1e1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	83 c0 01             	add    $0x1,%eax
 1d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1dc:	7c b3                	jl     191 <gets+0xf>
 1de:	eb 01                	jmp    1e1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
 1e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <stat>:

int
stat(char *n, struct stat *st)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f7:	83 ec 08             	sub    $0x8,%esp
 1fa:	6a 00                	push   $0x0
 1fc:	ff 75 08             	pushl  0x8(%ebp)
 1ff:	e8 51 01 00 00       	call   355 <open>
 204:	83 c4 10             	add    $0x10,%esp
 207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20e:	79 07                	jns    217 <stat+0x26>
    return -1;
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb 25                	jmp    23c <stat+0x4b>
  r = fstat(fd, st);
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	ff 75 0c             	pushl  0xc(%ebp)
 21d:	ff 75 f4             	pushl  -0xc(%ebp)
 220:	e8 48 01 00 00       	call   36d <fstat>
 225:	83 c4 10             	add    $0x10,%esp
 228:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22b:	83 ec 0c             	sub    $0xc,%esp
 22e:	ff 75 f4             	pushl  -0xc(%ebp)
 231:	e8 07 01 00 00       	call   33d <close>
 236:	83 c4 10             	add    $0x10,%esp
  return r;
 239:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <atoi>:

int
atoi(const char *s)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 24b:	eb 04                	jmp    251 <atoi+0x13>
 24d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 20                	cmp    $0x20,%al
 259:	74 f2                	je     24d <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	3c 2d                	cmp    $0x2d,%al
 263:	75 07                	jne    26c <atoi+0x2e>
 265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26a:	eb 05                	jmp    271 <atoi+0x33>
 26c:	b8 01 00 00 00       	mov    $0x1,%eax
 271:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	0f b6 00             	movzbl (%eax),%eax
 27a:	3c 2b                	cmp    $0x2b,%al
 27c:	74 0a                	je     288 <atoi+0x4a>
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	3c 2d                	cmp    $0x2d,%al
 286:	75 2b                	jne    2b3 <atoi+0x75>
    s++;
 288:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 28c:	eb 25                	jmp    2b3 <atoi+0x75>
    n = n*10 + *s++ - '0';
 28e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 291:	89 d0                	mov    %edx,%eax
 293:	c1 e0 02             	shl    $0x2,%eax
 296:	01 d0                	add    %edx,%eax
 298:	01 c0                	add    %eax,%eax
 29a:	89 c1                	mov    %eax,%ecx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	8d 50 01             	lea    0x1(%eax),%edx
 2a2:	89 55 08             	mov    %edx,0x8(%ebp)
 2a5:	0f b6 00             	movzbl (%eax),%eax
 2a8:	0f be c0             	movsbl %al,%eax
 2ab:	01 c8                	add    %ecx,%eax
 2ad:	83 e8 30             	sub    $0x30,%eax
 2b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	3c 2f                	cmp    $0x2f,%al
 2bb:	7e 0a                	jle    2c7 <atoi+0x89>
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	3c 39                	cmp    $0x39,%al
 2c5:	7e c7                	jle    28e <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ca:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2ce:	c9                   	leave  
 2cf:	c3                   	ret    

000002d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2e2:	eb 17                	jmp    2fb <memmove+0x2b>
    *dst++ = *src++;
 2e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e7:	8d 50 01             	lea    0x1(%eax),%edx
 2ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2f0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2f3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2f6:	0f b6 12             	movzbl (%edx),%edx
 2f9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fb:	8b 45 10             	mov    0x10(%ebp),%eax
 2fe:	8d 50 ff             	lea    -0x1(%eax),%edx
 301:	89 55 10             	mov    %edx,0x10(%ebp)
 304:	85 c0                	test   %eax,%eax
 306:	7f dc                	jg     2e4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 308:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30b:	c9                   	leave  
 30c:	c3                   	ret    

0000030d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30d:	b8 01 00 00 00       	mov    $0x1,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <exit>:
SYSCALL(exit)
 315:	b8 02 00 00 00       	mov    $0x2,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <wait>:
SYSCALL(wait)
 31d:	b8 03 00 00 00       	mov    $0x3,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <pipe>:
SYSCALL(pipe)
 325:	b8 04 00 00 00       	mov    $0x4,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <read>:
SYSCALL(read)
 32d:	b8 05 00 00 00       	mov    $0x5,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <write>:
SYSCALL(write)
 335:	b8 10 00 00 00       	mov    $0x10,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <close>:
SYSCALL(close)
 33d:	b8 15 00 00 00       	mov    $0x15,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <kill>:
SYSCALL(kill)
 345:	b8 06 00 00 00       	mov    $0x6,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <exec>:
SYSCALL(exec)
 34d:	b8 07 00 00 00       	mov    $0x7,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <open>:
SYSCALL(open)
 355:	b8 0f 00 00 00       	mov    $0xf,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <mknod>:
SYSCALL(mknod)
 35d:	b8 11 00 00 00       	mov    $0x11,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <unlink>:
SYSCALL(unlink)
 365:	b8 12 00 00 00       	mov    $0x12,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <fstat>:
SYSCALL(fstat)
 36d:	b8 08 00 00 00       	mov    $0x8,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <link>:
SYSCALL(link)
 375:	b8 13 00 00 00       	mov    $0x13,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <mkdir>:
SYSCALL(mkdir)
 37d:	b8 14 00 00 00       	mov    $0x14,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <chdir>:
SYSCALL(chdir)
 385:	b8 09 00 00 00       	mov    $0x9,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <dup>:
SYSCALL(dup)
 38d:	b8 0a 00 00 00       	mov    $0xa,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <getpid>:
SYSCALL(getpid)
 395:	b8 0b 00 00 00       	mov    $0xb,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <sbrk>:
SYSCALL(sbrk)
 39d:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <sleep>:
SYSCALL(sleep)
 3a5:	b8 0d 00 00 00       	mov    $0xd,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <uptime>:
SYSCALL(uptime)
 3ad:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <halt>:
SYSCALL(halt)
 3b5:	b8 16 00 00 00       	mov    $0x16,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <date>:
SYSCALL(date)
 3bd:	b8 17 00 00 00       	mov    $0x17,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <getuid>:
SYSCALL(getuid)
 3c5:	b8 18 00 00 00       	mov    $0x18,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <getgid>:
SYSCALL(getgid)
 3cd:	b8 19 00 00 00       	mov    $0x19,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <getppid>:
SYSCALL(getppid)
 3d5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <setuid>:
SYSCALL(setuid)
 3dd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <setgid>:
SYSCALL(setgid)
 3e5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <getprocs>:
SYSCALL(getprocs)
 3ed:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <setpriority>:
SYSCALL(setpriority)
 3f5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <chmod>:
SYSCALL(chmod)
 3fd:	b8 1f 00 00 00       	mov    $0x1f,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <chown>:
SYSCALL(chown)
 405:	b8 20 00 00 00       	mov    $0x20,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <chgrp>:
SYSCALL(chgrp)
 40d:	b8 21 00 00 00       	mov    $0x21,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 18             	sub    $0x18,%esp
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 421:	83 ec 04             	sub    $0x4,%esp
 424:	6a 01                	push   $0x1
 426:	8d 45 f4             	lea    -0xc(%ebp),%eax
 429:	50                   	push   %eax
 42a:	ff 75 08             	pushl  0x8(%ebp)
 42d:	e8 03 ff ff ff       	call   335 <write>
 432:	83 c4 10             	add    $0x10,%esp
}
 435:	90                   	nop
 436:	c9                   	leave  
 437:	c3                   	ret    

00000438 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 438:	55                   	push   %ebp
 439:	89 e5                	mov    %esp,%ebp
 43b:	53                   	push   %ebx
 43c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 446:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 44a:	74 17                	je     463 <printint+0x2b>
 44c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 450:	79 11                	jns    463 <printint+0x2b>
    neg = 1;
 452:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 459:	8b 45 0c             	mov    0xc(%ebp),%eax
 45c:	f7 d8                	neg    %eax
 45e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 461:	eb 06                	jmp    469 <printint+0x31>
  } else {
    x = xx;
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 470:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 473:	8d 41 01             	lea    0x1(%ecx),%eax
 476:	89 45 f4             	mov    %eax,-0xc(%ebp)
 479:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47f:	ba 00 00 00 00       	mov    $0x0,%edx
 484:	f7 f3                	div    %ebx
 486:	89 d0                	mov    %edx,%eax
 488:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 48f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 493:	8b 5d 10             	mov    0x10(%ebp),%ebx
 496:	8b 45 ec             	mov    -0x14(%ebp),%eax
 499:	ba 00 00 00 00       	mov    $0x0,%edx
 49e:	f7 f3                	div    %ebx
 4a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a7:	75 c7                	jne    470 <printint+0x38>
  if(neg)
 4a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ad:	74 2d                	je     4dc <printint+0xa4>
    buf[i++] = '-';
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	8d 50 01             	lea    0x1(%eax),%edx
 4b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4bd:	eb 1d                	jmp    4dc <printint+0xa4>
    putc(fd, buf[i]);
 4bf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c5:	01 d0                	add    %edx,%eax
 4c7:	0f b6 00             	movzbl (%eax),%eax
 4ca:	0f be c0             	movsbl %al,%eax
 4cd:	83 ec 08             	sub    $0x8,%esp
 4d0:	50                   	push   %eax
 4d1:	ff 75 08             	pushl  0x8(%ebp)
 4d4:	e8 3c ff ff ff       	call   415 <putc>
 4d9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4dc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e4:	79 d9                	jns    4bf <printint+0x87>
    putc(fd, buf[i]);
}
 4e6:	90                   	nop
 4e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    

000004ec <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4fc:	83 c0 04             	add    $0x4,%eax
 4ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 509:	e9 59 01 00 00       	jmp    667 <printf+0x17b>
    c = fmt[i] & 0xff;
 50e:	8b 55 0c             	mov    0xc(%ebp),%edx
 511:	8b 45 f0             	mov    -0x10(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	25 ff 00 00 00       	and    $0xff,%eax
 521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 524:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 528:	75 2c                	jne    556 <printf+0x6a>
      if(c == '%'){
 52a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52e:	75 0c                	jne    53c <printf+0x50>
        state = '%';
 530:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 537:	e9 27 01 00 00       	jmp    663 <printf+0x177>
      } else {
        putc(fd, c);
 53c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53f:	0f be c0             	movsbl %al,%eax
 542:	83 ec 08             	sub    $0x8,%esp
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 c7 fe ff ff       	call   415 <putc>
 54e:	83 c4 10             	add    $0x10,%esp
 551:	e9 0d 01 00 00       	jmp    663 <printf+0x177>
      }
    } else if(state == '%'){
 556:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 55a:	0f 85 03 01 00 00    	jne    663 <printf+0x177>
      if(c == 'd'){
 560:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 564:	75 1e                	jne    584 <printf+0x98>
        printint(fd, *ap, 10, 1);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	6a 01                	push   $0x1
 56d:	6a 0a                	push   $0xa
 56f:	50                   	push   %eax
 570:	ff 75 08             	pushl  0x8(%ebp)
 573:	e8 c0 fe ff ff       	call   438 <printint>
 578:	83 c4 10             	add    $0x10,%esp
        ap++;
 57b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57f:	e9 d8 00 00 00       	jmp    65c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 584:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 588:	74 06                	je     590 <printf+0xa4>
 58a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 58e:	75 1e                	jne    5ae <printf+0xc2>
        printint(fd, *ap, 16, 0);
 590:	8b 45 e8             	mov    -0x18(%ebp),%eax
 593:	8b 00                	mov    (%eax),%eax
 595:	6a 00                	push   $0x0
 597:	6a 10                	push   $0x10
 599:	50                   	push   %eax
 59a:	ff 75 08             	pushl  0x8(%ebp)
 59d:	e8 96 fe ff ff       	call   438 <printint>
 5a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a9:	e9 ae 00 00 00       	jmp    65c <printf+0x170>
      } else if(c == 's'){
 5ae:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b2:	75 43                	jne    5f7 <printf+0x10b>
        s = (char*)*ap;
 5b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c4:	75 25                	jne    5eb <printf+0xff>
          s = "(null)";
 5c6:	c7 45 f4 b3 08 00 00 	movl   $0x8b3,-0xc(%ebp)
        while(*s != 0){
 5cd:	eb 1c                	jmp    5eb <printf+0xff>
          putc(fd, *s);
 5cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d2:	0f b6 00             	movzbl (%eax),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 31 fe ff ff       	call   415 <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
          s++;
 5e7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ee:	0f b6 00             	movzbl (%eax),%eax
 5f1:	84 c0                	test   %al,%al
 5f3:	75 da                	jne    5cf <printf+0xe3>
 5f5:	eb 65                	jmp    65c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5fb:	75 1d                	jne    61a <printf+0x12e>
        putc(fd, *ap);
 5fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	0f be c0             	movsbl %al,%eax
 605:	83 ec 08             	sub    $0x8,%esp
 608:	50                   	push   %eax
 609:	ff 75 08             	pushl  0x8(%ebp)
 60c:	e8 04 fe ff ff       	call   415 <putc>
 611:	83 c4 10             	add    $0x10,%esp
        ap++;
 614:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 618:	eb 42                	jmp    65c <printf+0x170>
      } else if(c == '%'){
 61a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 61e:	75 17                	jne    637 <printf+0x14b>
        putc(fd, c);
 620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	83 ec 08             	sub    $0x8,%esp
 629:	50                   	push   %eax
 62a:	ff 75 08             	pushl  0x8(%ebp)
 62d:	e8 e3 fd ff ff       	call   415 <putc>
 632:	83 c4 10             	add    $0x10,%esp
 635:	eb 25                	jmp    65c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 637:	83 ec 08             	sub    $0x8,%esp
 63a:	6a 25                	push   $0x25
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 d1 fd ff ff       	call   415 <putc>
 644:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64a:	0f be c0             	movsbl %al,%eax
 64d:	83 ec 08             	sub    $0x8,%esp
 650:	50                   	push   %eax
 651:	ff 75 08             	pushl  0x8(%ebp)
 654:	e8 bc fd ff ff       	call   415 <putc>
 659:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 65c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 663:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 667:	8b 55 0c             	mov    0xc(%ebp),%edx
 66a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 66d:	01 d0                	add    %edx,%eax
 66f:	0f b6 00             	movzbl (%eax),%eax
 672:	84 c0                	test   %al,%al
 674:	0f 85 94 fe ff ff    	jne    50e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 67a:	90                   	nop
 67b:	c9                   	leave  
 67c:	c3                   	ret    

0000067d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 67d:	55                   	push   %ebp
 67e:	89 e5                	mov    %esp,%ebp
 680:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	83 e8 08             	sub    $0x8,%eax
 689:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68c:	a1 20 0b 00 00       	mov    0xb20,%eax
 691:	89 45 fc             	mov    %eax,-0x4(%ebp)
 694:	eb 24                	jmp    6ba <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69e:	77 12                	ja     6b2 <free+0x35>
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a6:	77 24                	ja     6cc <free+0x4f>
 6a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b0:	77 1a                	ja     6cc <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c0:	76 d4                	jbe    696 <free+0x19>
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ca:	76 ca                	jbe    696 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cf:	8b 40 04             	mov    0x4(%eax),%eax
 6d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 00                	mov    (%eax),%eax
 6e3:	39 c2                	cmp    %eax,%edx
 6e5:	75 24                	jne    70b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	8b 50 04             	mov    0x4(%eax),%edx
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	8b 40 04             	mov    0x4(%eax),%eax
 6f5:	01 c2                	add    %eax,%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	8b 10                	mov    (%eax),%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	89 10                	mov    %edx,(%eax)
 709:	eb 0a                	jmp    715 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 10                	mov    (%eax),%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 40 04             	mov    0x4(%eax),%eax
 71b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	01 d0                	add    %edx,%eax
 727:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72a:	75 20                	jne    74c <free+0xcf>
    p->s.size += bp->s.size;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 50 04             	mov    0x4(%eax),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	8b 40 04             	mov    0x4(%eax),%eax
 738:	01 c2                	add    %eax,%edx
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	8b 10                	mov    (%eax),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	89 10                	mov    %edx,(%eax)
 74a:	eb 08                	jmp    754 <free+0xd7>
  } else
    p->s.ptr = bp;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 752:	89 10                	mov    %edx,(%eax)
  freep = p;
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 75c:	90                   	nop
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <morecore>:

static Header*
morecore(uint nu)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 765:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 76c:	77 07                	ja     775 <morecore+0x16>
    nu = 4096;
 76e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	c1 e0 03             	shl    $0x3,%eax
 77b:	83 ec 0c             	sub    $0xc,%esp
 77e:	50                   	push   %eax
 77f:	e8 19 fc ff ff       	call   39d <sbrk>
 784:	83 c4 10             	add    $0x10,%esp
 787:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 78e:	75 07                	jne    797 <morecore+0x38>
    return 0;
 790:	b8 00 00 00 00       	mov    $0x0,%eax
 795:	eb 26                	jmp    7bd <morecore+0x5e>
  hp = (Header*)p;
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a0:	8b 55 08             	mov    0x8(%ebp),%edx
 7a3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a9:	83 c0 08             	add    $0x8,%eax
 7ac:	83 ec 0c             	sub    $0xc,%esp
 7af:	50                   	push   %eax
 7b0:	e8 c8 fe ff ff       	call   67d <free>
 7b5:	83 c4 10             	add    $0x10,%esp
  return freep;
 7b8:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7bd:	c9                   	leave  
 7be:	c3                   	ret    

000007bf <malloc>:

void*
malloc(uint nbytes)
{
 7bf:	55                   	push   %ebp
 7c0:	89 e5                	mov    %esp,%ebp
 7c2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	83 c0 07             	add    $0x7,%eax
 7cb:	c1 e8 03             	shr    $0x3,%eax
 7ce:	83 c0 01             	add    $0x1,%eax
 7d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d4:	a1 20 0b 00 00       	mov    0xb20,%eax
 7d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e0:	75 23                	jne    805 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e2:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	a3 20 0b 00 00       	mov    %eax,0xb20
 7f1:	a1 20 0b 00 00       	mov    0xb20,%eax
 7f6:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7fb:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 802:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 816:	72 4d                	jb     865 <malloc+0xa6>
      if(p->s.size == nunits)
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 821:	75 0c                	jne    82f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 26                	jmp    855 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	2b 45 ec             	sub    -0x14(%ebp),%eax
 838:	89 c2                	mov    %eax,%edx
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	c1 e0 03             	shl    $0x3,%eax
 849:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 852:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	83 c0 08             	add    $0x8,%eax
 863:	eb 3b                	jmp    8a0 <malloc+0xe1>
    }
    if(p == freep)
 865:	a1 20 0b 00 00       	mov    0xb20,%eax
 86a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 86d:	75 1e                	jne    88d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 86f:	83 ec 0c             	sub    $0xc,%esp
 872:	ff 75 ec             	pushl  -0x14(%ebp)
 875:	e8 e5 fe ff ff       	call   75f <morecore>
 87a:	83 c4 10             	add    $0x10,%esp
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 884:	75 07                	jne    88d <malloc+0xce>
        return 0;
 886:	b8 00 00 00 00       	mov    $0x0,%eax
 88b:	eb 13                	jmp    8a0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 45 f0             	mov    %eax,-0x10(%ebp)
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	8b 00                	mov    (%eax),%eax
 898:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 89b:	e9 6d ff ff ff       	jmp    80d <malloc+0x4e>
}
 8a0:	c9                   	leave  
 8a1:	c3                   	ret    
