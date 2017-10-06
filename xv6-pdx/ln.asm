
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
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
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 75 08 00 00       	push   $0x875
  1e:	6a 02                	push   $0x2
  20:	e8 9a 04 00 00       	call   4bf <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 e3 02 00 00       	call   310 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 29 03 00 00       	call   370 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 88 08 00 00       	push   $0x888
  65:	6a 02                	push   $0x2
  67:	e8 53 04 00 00       	call   4bf <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 9c 02 00 00       	call   310 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 8c 01 00 00       	call   328 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 51 01 00 00       	call   350 <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 48 01 00 00       	call   368 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 07 01 00 00       	call   338 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 246:	eb 04                	jmp    24c <atoi+0x13>
 248:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	3c 20                	cmp    $0x20,%al
 254:	74 f2                	je     248 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	3c 2d                	cmp    $0x2d,%al
 25e:	75 07                	jne    267 <atoi+0x2e>
 260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 265:	eb 05                	jmp    26c <atoi+0x33>
 267:	b8 01 00 00 00       	mov    $0x1,%eax
 26c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	3c 2b                	cmp    $0x2b,%al
 277:	74 0a                	je     283 <atoi+0x4a>
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	3c 2d                	cmp    $0x2d,%al
 281:	75 2b                	jne    2ae <atoi+0x75>
    s++;
 283:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 287:	eb 25                	jmp    2ae <atoi+0x75>
    n = n*10 + *s++ - '0';
 289:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28c:	89 d0                	mov    %edx,%eax
 28e:	c1 e0 02             	shl    $0x2,%eax
 291:	01 d0                	add    %edx,%eax
 293:	01 c0                	add    %eax,%eax
 295:	89 c1                	mov    %eax,%ecx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8d 50 01             	lea    0x1(%eax),%edx
 29d:	89 55 08             	mov    %edx,0x8(%ebp)
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	0f be c0             	movsbl %al,%eax
 2a6:	01 c8                	add    %ecx,%eax
 2a8:	83 e8 30             	sub    $0x30,%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3c 2f                	cmp    $0x2f,%al
 2b6:	7e 0a                	jle    2c2 <atoi+0x89>
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	3c 39                	cmp    $0x39,%al
 2c0:	7e c7                	jle    289 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c5:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2dd:	eb 17                	jmp    2f6 <memmove+0x2b>
    *dst++ = *src++;
 2df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2eb:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ee:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2f1:	0f b6 12             	movzbl (%edx),%edx
 2f4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f6:	8b 45 10             	mov    0x10(%ebp),%eax
 2f9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2fc:	89 55 10             	mov    %edx,0x10(%ebp)
 2ff:	85 c0                	test   %eax,%eax
 301:	7f dc                	jg     2df <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
}
 306:	c9                   	leave  
 307:	c3                   	ret    

00000308 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 308:	b8 01 00 00 00       	mov    $0x1,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <exit>:
SYSCALL(exit)
 310:	b8 02 00 00 00       	mov    $0x2,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <wait>:
SYSCALL(wait)
 318:	b8 03 00 00 00       	mov    $0x3,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <pipe>:
SYSCALL(pipe)
 320:	b8 04 00 00 00       	mov    $0x4,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <read>:
SYSCALL(read)
 328:	b8 05 00 00 00       	mov    $0x5,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <write>:
SYSCALL(write)
 330:	b8 10 00 00 00       	mov    $0x10,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <close>:
SYSCALL(close)
 338:	b8 15 00 00 00       	mov    $0x15,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <kill>:
SYSCALL(kill)
 340:	b8 06 00 00 00       	mov    $0x6,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <exec>:
SYSCALL(exec)
 348:	b8 07 00 00 00       	mov    $0x7,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <open>:
SYSCALL(open)
 350:	b8 0f 00 00 00       	mov    $0xf,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <mknod>:
SYSCALL(mknod)
 358:	b8 11 00 00 00       	mov    $0x11,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <unlink>:
SYSCALL(unlink)
 360:	b8 12 00 00 00       	mov    $0x12,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <fstat>:
SYSCALL(fstat)
 368:	b8 08 00 00 00       	mov    $0x8,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <link>:
SYSCALL(link)
 370:	b8 13 00 00 00       	mov    $0x13,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <mkdir>:
SYSCALL(mkdir)
 378:	b8 14 00 00 00       	mov    $0x14,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <chdir>:
SYSCALL(chdir)
 380:	b8 09 00 00 00       	mov    $0x9,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <dup>:
SYSCALL(dup)
 388:	b8 0a 00 00 00       	mov    $0xa,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <getpid>:
SYSCALL(getpid)
 390:	b8 0b 00 00 00       	mov    $0xb,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <sbrk>:
SYSCALL(sbrk)
 398:	b8 0c 00 00 00       	mov    $0xc,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <sleep>:
SYSCALL(sleep)
 3a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <uptime>:
SYSCALL(uptime)
 3a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <halt>:
SYSCALL(halt)
 3b0:	b8 16 00 00 00       	mov    $0x16,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <date>:
SYSCALL(date)
 3b8:	b8 17 00 00 00       	mov    $0x17,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <getuid>:
SYSCALL(getuid)
 3c0:	b8 18 00 00 00       	mov    $0x18,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <getgid>:
SYSCALL(getgid)
 3c8:	b8 19 00 00 00       	mov    $0x19,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <getppid>:
SYSCALL(getppid)
 3d0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <setuid>:
SYSCALL(setuid)
 3d8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <setgid>:
SYSCALL(setgid)
 3e0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 18             	sub    $0x18,%esp
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f4:	83 ec 04             	sub    $0x4,%esp
 3f7:	6a 01                	push   $0x1
 3f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fc:	50                   	push   %eax
 3fd:	ff 75 08             	pushl  0x8(%ebp)
 400:	e8 2b ff ff ff       	call   330 <write>
 405:	83 c4 10             	add    $0x10,%esp
}
 408:	90                   	nop
 409:	c9                   	leave  
 40a:	c3                   	ret    

0000040b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	53                   	push   %ebx
 40f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 419:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41d:	74 17                	je     436 <printint+0x2b>
 41f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 423:	79 11                	jns    436 <printint+0x2b>
    neg = 1;
 425:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42c:	8b 45 0c             	mov    0xc(%ebp),%eax
 42f:	f7 d8                	neg    %eax
 431:	89 45 ec             	mov    %eax,-0x14(%ebp)
 434:	eb 06                	jmp    43c <printint+0x31>
  } else {
    x = xx;
 436:	8b 45 0c             	mov    0xc(%ebp),%eax
 439:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 443:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 446:	8d 41 01             	lea    0x1(%ecx),%eax
 449:	89 45 f4             	mov    %eax,-0xc(%ebp)
 44c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 44f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 452:	ba 00 00 00 00       	mov    $0x0,%edx
 457:	f7 f3                	div    %ebx
 459:	89 d0                	mov    %edx,%eax
 45b:	0f b6 80 f0 0a 00 00 	movzbl 0xaf0(%eax),%eax
 462:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 466:	8b 5d 10             	mov    0x10(%ebp),%ebx
 469:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46c:	ba 00 00 00 00       	mov    $0x0,%edx
 471:	f7 f3                	div    %ebx
 473:	89 45 ec             	mov    %eax,-0x14(%ebp)
 476:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47a:	75 c7                	jne    443 <printint+0x38>
  if(neg)
 47c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 480:	74 2d                	je     4af <printint+0xa4>
    buf[i++] = '-';
 482:	8b 45 f4             	mov    -0xc(%ebp),%eax
 485:	8d 50 01             	lea    0x1(%eax),%edx
 488:	89 55 f4             	mov    %edx,-0xc(%ebp)
 48b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 490:	eb 1d                	jmp    4af <printint+0xa4>
    putc(fd, buf[i]);
 492:	8d 55 dc             	lea    -0x24(%ebp),%edx
 495:	8b 45 f4             	mov    -0xc(%ebp),%eax
 498:	01 d0                	add    %edx,%eax
 49a:	0f b6 00             	movzbl (%eax),%eax
 49d:	0f be c0             	movsbl %al,%eax
 4a0:	83 ec 08             	sub    $0x8,%esp
 4a3:	50                   	push   %eax
 4a4:	ff 75 08             	pushl  0x8(%ebp)
 4a7:	e8 3c ff ff ff       	call   3e8 <putc>
 4ac:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4af:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b7:	79 d9                	jns    492 <printint+0x87>
    putc(fd, buf[i]);
}
 4b9:	90                   	nop
 4ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4bd:	c9                   	leave  
 4be:	c3                   	ret    

000004bf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bf:	55                   	push   %ebp
 4c0:	89 e5                	mov    %esp,%ebp
 4c2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4cc:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cf:	83 c0 04             	add    $0x4,%eax
 4d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4dc:	e9 59 01 00 00       	jmp    63a <printf+0x17b>
    c = fmt[i] & 0xff;
 4e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	0f b6 00             	movzbl (%eax),%eax
 4ec:	0f be c0             	movsbl %al,%eax
 4ef:	25 ff 00 00 00       	and    $0xff,%eax
 4f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4fb:	75 2c                	jne    529 <printf+0x6a>
      if(c == '%'){
 4fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 501:	75 0c                	jne    50f <printf+0x50>
        state = '%';
 503:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 50a:	e9 27 01 00 00       	jmp    636 <printf+0x177>
      } else {
        putc(fd, c);
 50f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	83 ec 08             	sub    $0x8,%esp
 518:	50                   	push   %eax
 519:	ff 75 08             	pushl  0x8(%ebp)
 51c:	e8 c7 fe ff ff       	call   3e8 <putc>
 521:	83 c4 10             	add    $0x10,%esp
 524:	e9 0d 01 00 00       	jmp    636 <printf+0x177>
      }
    } else if(state == '%'){
 529:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 52d:	0f 85 03 01 00 00    	jne    636 <printf+0x177>
      if(c == 'd'){
 533:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 537:	75 1e                	jne    557 <printf+0x98>
        printint(fd, *ap, 10, 1);
 539:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53c:	8b 00                	mov    (%eax),%eax
 53e:	6a 01                	push   $0x1
 540:	6a 0a                	push   $0xa
 542:	50                   	push   %eax
 543:	ff 75 08             	pushl  0x8(%ebp)
 546:	e8 c0 fe ff ff       	call   40b <printint>
 54b:	83 c4 10             	add    $0x10,%esp
        ap++;
 54e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 552:	e9 d8 00 00 00       	jmp    62f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 557:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55b:	74 06                	je     563 <printf+0xa4>
 55d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 561:	75 1e                	jne    581 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 563:	8b 45 e8             	mov    -0x18(%ebp),%eax
 566:	8b 00                	mov    (%eax),%eax
 568:	6a 00                	push   $0x0
 56a:	6a 10                	push   $0x10
 56c:	50                   	push   %eax
 56d:	ff 75 08             	pushl  0x8(%ebp)
 570:	e8 96 fe ff ff       	call   40b <printint>
 575:	83 c4 10             	add    $0x10,%esp
        ap++;
 578:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 57c:	e9 ae 00 00 00       	jmp    62f <printf+0x170>
      } else if(c == 's'){
 581:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 585:	75 43                	jne    5ca <printf+0x10b>
        s = (char*)*ap;
 587:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58a:	8b 00                	mov    (%eax),%eax
 58c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 58f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 593:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 597:	75 25                	jne    5be <printf+0xff>
          s = "(null)";
 599:	c7 45 f4 9c 08 00 00 	movl   $0x89c,-0xc(%ebp)
        while(*s != 0){
 5a0:	eb 1c                	jmp    5be <printf+0xff>
          putc(fd, *s);
 5a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	83 ec 08             	sub    $0x8,%esp
 5ae:	50                   	push   %eax
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 31 fe ff ff       	call   3e8 <putc>
 5b7:	83 c4 10             	add    $0x10,%esp
          s++;
 5ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c1:	0f b6 00             	movzbl (%eax),%eax
 5c4:	84 c0                	test   %al,%al
 5c6:	75 da                	jne    5a2 <printf+0xe3>
 5c8:	eb 65                	jmp    62f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5ca:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ce:	75 1d                	jne    5ed <printf+0x12e>
        putc(fd, *ap);
 5d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d3:	8b 00                	mov    (%eax),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	83 ec 08             	sub    $0x8,%esp
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 04 fe ff ff       	call   3e8 <putc>
 5e4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5eb:	eb 42                	jmp    62f <printf+0x170>
      } else if(c == '%'){
 5ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f1:	75 17                	jne    60a <printf+0x14b>
        putc(fd, c);
 5f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 e3 fd ff ff       	call   3e8 <putc>
 605:	83 c4 10             	add    $0x10,%esp
 608:	eb 25                	jmp    62f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60a:	83 ec 08             	sub    $0x8,%esp
 60d:	6a 25                	push   $0x25
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 d1 fd ff ff       	call   3e8 <putc>
 617:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 61a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61d:	0f be c0             	movsbl %al,%eax
 620:	83 ec 08             	sub    $0x8,%esp
 623:	50                   	push   %eax
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 bc fd ff ff       	call   3e8 <putc>
 62c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 636:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 63a:	8b 55 0c             	mov    0xc(%ebp),%edx
 63d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 640:	01 d0                	add    %edx,%eax
 642:	0f b6 00             	movzbl (%eax),%eax
 645:	84 c0                	test   %al,%al
 647:	0f 85 94 fe ff ff    	jne    4e1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 64d:	90                   	nop
 64e:	c9                   	leave  
 64f:	c3                   	ret    

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	83 e8 08             	sub    $0x8,%eax
 65c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65f:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 664:	89 45 fc             	mov    %eax,-0x4(%ebp)
 667:	eb 24                	jmp    68d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 671:	77 12                	ja     685 <free+0x35>
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 679:	77 24                	ja     69f <free+0x4f>
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 683:	77 1a                	ja     69f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 693:	76 d4                	jbe    669 <free+0x19>
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69d:	76 ca                	jbe    669 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	01 c2                	add    %eax,%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	39 c2                	cmp    %eax,%edx
 6b8:	75 24                	jne    6de <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	8b 50 04             	mov    0x4(%eax),%edx
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	8b 40 04             	mov    0x4(%eax),%eax
 6c8:	01 c2                	add    %eax,%edx
 6ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	8b 10                	mov    (%eax),%edx
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	89 10                	mov    %edx,(%eax)
 6dc:	eb 0a                	jmp    6e8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 10                	mov    (%eax),%edx
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 40 04             	mov    0x4(%eax),%eax
 6ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	01 d0                	add    %edx,%eax
 6fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fd:	75 20                	jne    71f <free+0xcf>
    p->s.size += bp->s.size;
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 50 04             	mov    0x4(%eax),%edx
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 40 04             	mov    0x4(%eax),%eax
 70b:	01 c2                	add    %eax,%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	8b 10                	mov    (%eax),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	89 10                	mov    %edx,(%eax)
 71d:	eb 08                	jmp    727 <free+0xd7>
  } else
    p->s.ptr = bp;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 55 f8             	mov    -0x8(%ebp),%edx
 725:	89 10                	mov    %edx,(%eax)
  freep = p;
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	a3 0c 0b 00 00       	mov    %eax,0xb0c
}
 72f:	90                   	nop
 730:	c9                   	leave  
 731:	c3                   	ret    

00000732 <morecore>:

static Header*
morecore(uint nu)
{
 732:	55                   	push   %ebp
 733:	89 e5                	mov    %esp,%ebp
 735:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 738:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 73f:	77 07                	ja     748 <morecore+0x16>
    nu = 4096;
 741:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	c1 e0 03             	shl    $0x3,%eax
 74e:	83 ec 0c             	sub    $0xc,%esp
 751:	50                   	push   %eax
 752:	e8 41 fc ff ff       	call   398 <sbrk>
 757:	83 c4 10             	add    $0x10,%esp
 75a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 75d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 761:	75 07                	jne    76a <morecore+0x38>
    return 0;
 763:	b8 00 00 00 00       	mov    $0x0,%eax
 768:	eb 26                	jmp    790 <morecore+0x5e>
  hp = (Header*)p;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	8b 55 08             	mov    0x8(%ebp),%edx
 776:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 779:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77c:	83 c0 08             	add    $0x8,%eax
 77f:	83 ec 0c             	sub    $0xc,%esp
 782:	50                   	push   %eax
 783:	e8 c8 fe ff ff       	call   650 <free>
 788:	83 c4 10             	add    $0x10,%esp
  return freep;
 78b:	a1 0c 0b 00 00       	mov    0xb0c,%eax
}
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <malloc>:

void*
malloc(uint nbytes)
{
 792:	55                   	push   %ebp
 793:	89 e5                	mov    %esp,%ebp
 795:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	83 c0 07             	add    $0x7,%eax
 79e:	c1 e8 03             	shr    $0x3,%eax
 7a1:	83 c0 01             	add    $0x1,%eax
 7a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a7:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b3:	75 23                	jne    7d8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b5:	c7 45 f0 04 0b 00 00 	movl   $0xb04,-0x10(%ebp)
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	a3 0c 0b 00 00       	mov    %eax,0xb0c
 7c4:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 7c9:	a3 04 0b 00 00       	mov    %eax,0xb04
    base.s.size = 0;
 7ce:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 7d5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e9:	72 4d                	jb     838 <malloc+0xa6>
      if(p->s.size == nunits)
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f4:	75 0c                	jne    802 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fe:	89 10                	mov    %edx,(%eax)
 800:	eb 26                	jmp    828 <malloc+0x96>
      else {
        p->s.size -= nunits;
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	2b 45 ec             	sub    -0x14(%ebp),%eax
 80b:	89 c2                	mov    %eax,%edx
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8b 40 04             	mov    0x4(%eax),%eax
 819:	c1 e0 03             	shl    $0x3,%eax
 81c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	8b 55 ec             	mov    -0x14(%ebp),%edx
 825:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	a3 0c 0b 00 00       	mov    %eax,0xb0c
      return (void*)(p + 1);
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	83 c0 08             	add    $0x8,%eax
 836:	eb 3b                	jmp    873 <malloc+0xe1>
    }
    if(p == freep)
 838:	a1 0c 0b 00 00       	mov    0xb0c,%eax
 83d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 840:	75 1e                	jne    860 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 842:	83 ec 0c             	sub    $0xc,%esp
 845:	ff 75 ec             	pushl  -0x14(%ebp)
 848:	e8 e5 fe ff ff       	call   732 <morecore>
 84d:	83 c4 10             	add    $0x10,%esp
 850:	89 45 f4             	mov    %eax,-0xc(%ebp)
 853:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 857:	75 07                	jne    860 <malloc+0xce>
        return 0;
 859:	b8 00 00 00 00       	mov    $0x0,%eax
 85e:	eb 13                	jmp    873 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	89 45 f0             	mov    %eax,-0x10(%ebp)
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 00                	mov    (%eax),%eax
 86b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 86e:	e9 6d ff ff ff       	jmp    7e0 <malloc+0x4e>
}
 873:	c9                   	leave  
 874:	c3                   	ret    
