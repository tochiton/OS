
_echo:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba 66 08 00 00       	mov    $0x866,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 68 08 00 00       	mov    $0x868,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 6a 08 00 00       	push   $0x86a
  4b:	6a 01                	push   $0x1
  4d:	e8 5e 04 00 00       	call   4b0 <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 9c 02 00 00       	call   301 <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 8c 01 00 00       	call   319 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 51 01 00 00       	call   341 <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 48 01 00 00       	call   359 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 07 01 00 00       	call   329 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 237:	eb 04                	jmp    23d <atoi+0x13>
 239:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3c 20                	cmp    $0x20,%al
 245:	74 f2                	je     239 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	3c 2d                	cmp    $0x2d,%al
 24f:	75 07                	jne    258 <atoi+0x2e>
 251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 256:	eb 05                	jmp    25d <atoi+0x33>
 258:	b8 01 00 00 00       	mov    $0x1,%eax
 25d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	3c 2b                	cmp    $0x2b,%al
 268:	74 0a                	je     274 <atoi+0x4a>
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	3c 2d                	cmp    $0x2d,%al
 272:	75 2b                	jne    29f <atoi+0x75>
    s++;
 274:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 278:	eb 25                	jmp    29f <atoi+0x75>
    n = n*10 + *s++ - '0';
 27a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27d:	89 d0                	mov    %edx,%eax
 27f:	c1 e0 02             	shl    $0x2,%eax
 282:	01 d0                	add    %edx,%eax
 284:	01 c0                	add    %eax,%eax
 286:	89 c1                	mov    %eax,%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 08             	mov    %edx,0x8(%ebp)
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	0f be c0             	movsbl %al,%eax
 297:	01 c8                	add    %ecx,%eax
 299:	83 e8 30             	sub    $0x30,%eax
 29c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 2f                	cmp    $0x2f,%al
 2a7:	7e 0a                	jle    2b3 <atoi+0x89>
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 39                	cmp    $0x39,%al
 2b1:	7e c7                	jle    27a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ce:	eb 17                	jmp    2e7 <memmove+0x2b>
    *dst++ = *src++;
 2d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d3:	8d 50 01             	lea    0x1(%eax),%edx
 2d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2dc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2df:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2e2:	0f b6 12             	movzbl (%edx),%edx
 2e5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e7:	8b 45 10             	mov    0x10(%ebp),%eax
 2ea:	8d 50 ff             	lea    -0x1(%eax),%edx
 2ed:	89 55 10             	mov    %edx,0x10(%ebp)
 2f0:	85 c0                	test   %eax,%eax
 2f2:	7f dc                	jg     2d0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exit>:
SYSCALL(exit)
 301:	b8 02 00 00 00       	mov    $0x2,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <wait>:
SYSCALL(wait)
 309:	b8 03 00 00 00       	mov    $0x3,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <pipe>:
SYSCALL(pipe)
 311:	b8 04 00 00 00       	mov    $0x4,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <read>:
SYSCALL(read)
 319:	b8 05 00 00 00       	mov    $0x5,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <write>:
SYSCALL(write)
 321:	b8 10 00 00 00       	mov    $0x10,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <close>:
SYSCALL(close)
 329:	b8 15 00 00 00       	mov    $0x15,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <kill>:
SYSCALL(kill)
 331:	b8 06 00 00 00       	mov    $0x6,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <exec>:
SYSCALL(exec)
 339:	b8 07 00 00 00       	mov    $0x7,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <open>:
SYSCALL(open)
 341:	b8 0f 00 00 00       	mov    $0xf,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <mknod>:
SYSCALL(mknod)
 349:	b8 11 00 00 00       	mov    $0x11,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <unlink>:
SYSCALL(unlink)
 351:	b8 12 00 00 00       	mov    $0x12,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <fstat>:
SYSCALL(fstat)
 359:	b8 08 00 00 00       	mov    $0x8,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <link>:
SYSCALL(link)
 361:	b8 13 00 00 00       	mov    $0x13,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <mkdir>:
SYSCALL(mkdir)
 369:	b8 14 00 00 00       	mov    $0x14,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <chdir>:
SYSCALL(chdir)
 371:	b8 09 00 00 00       	mov    $0x9,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <dup>:
SYSCALL(dup)
 379:	b8 0a 00 00 00       	mov    $0xa,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <getpid>:
SYSCALL(getpid)
 381:	b8 0b 00 00 00       	mov    $0xb,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sbrk>:
SYSCALL(sbrk)
 389:	b8 0c 00 00 00       	mov    $0xc,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <sleep>:
SYSCALL(sleep)
 391:	b8 0d 00 00 00       	mov    $0xd,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <uptime>:
SYSCALL(uptime)
 399:	b8 0e 00 00 00       	mov    $0xe,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <halt>:
SYSCALL(halt)
 3a1:	b8 16 00 00 00       	mov    $0x16,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <date>:
SYSCALL(date)
 3a9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <getuid>:
SYSCALL(getuid)
 3b1:	b8 18 00 00 00       	mov    $0x18,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <getgid>:
SYSCALL(getgid)
 3b9:	b8 19 00 00 00       	mov    $0x19,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <getppid>:
SYSCALL(getppid)
 3c1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <setuid>:
SYSCALL(setuid)
 3c9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <setgid>:
SYSCALL(setgid)
 3d1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d9:	55                   	push   %ebp
 3da:	89 e5                	mov    %esp,%ebp
 3dc:	83 ec 18             	sub    $0x18,%esp
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3e5:	83 ec 04             	sub    $0x4,%esp
 3e8:	6a 01                	push   $0x1
 3ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ed:	50                   	push   %eax
 3ee:	ff 75 08             	pushl  0x8(%ebp)
 3f1:	e8 2b ff ff ff       	call   321 <write>
 3f6:	83 c4 10             	add    $0x10,%esp
}
 3f9:	90                   	nop
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	53                   	push   %ebx
 400:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 40a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40e:	74 17                	je     427 <printint+0x2b>
 410:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 414:	79 11                	jns    427 <printint+0x2b>
    neg = 1;
 416:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 41d:	8b 45 0c             	mov    0xc(%ebp),%eax
 420:	f7 d8                	neg    %eax
 422:	89 45 ec             	mov    %eax,-0x14(%ebp)
 425:	eb 06                	jmp    42d <printint+0x31>
  } else {
    x = xx;
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 42d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 434:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 437:	8d 41 01             	lea    0x1(%ecx),%eax
 43a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 43d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 440:	8b 45 ec             	mov    -0x14(%ebp),%eax
 443:	ba 00 00 00 00       	mov    $0x0,%edx
 448:	f7 f3                	div    %ebx
 44a:	89 d0                	mov    %edx,%eax
 44c:	0f b6 80 c4 0a 00 00 	movzbl 0xac4(%eax),%eax
 453:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 457:	8b 5d 10             	mov    0x10(%ebp),%ebx
 45a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45d:	ba 00 00 00 00       	mov    $0x0,%edx
 462:	f7 f3                	div    %ebx
 464:	89 45 ec             	mov    %eax,-0x14(%ebp)
 467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46b:	75 c7                	jne    434 <printint+0x38>
  if(neg)
 46d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 471:	74 2d                	je     4a0 <printint+0xa4>
    buf[i++] = '-';
 473:	8b 45 f4             	mov    -0xc(%ebp),%eax
 476:	8d 50 01             	lea    0x1(%eax),%edx
 479:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 481:	eb 1d                	jmp    4a0 <printint+0xa4>
    putc(fd, buf[i]);
 483:	8d 55 dc             	lea    -0x24(%ebp),%edx
 486:	8b 45 f4             	mov    -0xc(%ebp),%eax
 489:	01 d0                	add    %edx,%eax
 48b:	0f b6 00             	movzbl (%eax),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	83 ec 08             	sub    $0x8,%esp
 494:	50                   	push   %eax
 495:	ff 75 08             	pushl  0x8(%ebp)
 498:	e8 3c ff ff ff       	call   3d9 <putc>
 49d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a8:	79 d9                	jns    483 <printint+0x87>
    putc(fd, buf[i]);
}
 4aa:	90                   	nop
 4ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ae:	c9                   	leave  
 4af:	c3                   	ret    

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4bd:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c0:	83 c0 04             	add    $0x4,%eax
 4c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4cd:	e9 59 01 00 00       	jmp    62b <printf+0x17b>
    c = fmt[i] & 0xff;
 4d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d8:	01 d0                	add    %edx,%eax
 4da:	0f b6 00             	movzbl (%eax),%eax
 4dd:	0f be c0             	movsbl %al,%eax
 4e0:	25 ff 00 00 00       	and    $0xff,%eax
 4e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ec:	75 2c                	jne    51a <printf+0x6a>
      if(c == '%'){
 4ee:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f2:	75 0c                	jne    500 <printf+0x50>
        state = '%';
 4f4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4fb:	e9 27 01 00 00       	jmp    627 <printf+0x177>
      } else {
        putc(fd, c);
 500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 503:	0f be c0             	movsbl %al,%eax
 506:	83 ec 08             	sub    $0x8,%esp
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 c7 fe ff ff       	call   3d9 <putc>
 512:	83 c4 10             	add    $0x10,%esp
 515:	e9 0d 01 00 00       	jmp    627 <printf+0x177>
      }
    } else if(state == '%'){
 51a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 51e:	0f 85 03 01 00 00    	jne    627 <printf+0x177>
      if(c == 'd'){
 524:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 528:	75 1e                	jne    548 <printf+0x98>
        printint(fd, *ap, 10, 1);
 52a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52d:	8b 00                	mov    (%eax),%eax
 52f:	6a 01                	push   $0x1
 531:	6a 0a                	push   $0xa
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 c0 fe ff ff       	call   3fc <printint>
 53c:	83 c4 10             	add    $0x10,%esp
        ap++;
 53f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 543:	e9 d8 00 00 00       	jmp    620 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 548:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 54c:	74 06                	je     554 <printf+0xa4>
 54e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 552:	75 1e                	jne    572 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	6a 00                	push   $0x0
 55b:	6a 10                	push   $0x10
 55d:	50                   	push   %eax
 55e:	ff 75 08             	pushl  0x8(%ebp)
 561:	e8 96 fe ff ff       	call   3fc <printint>
 566:	83 c4 10             	add    $0x10,%esp
        ap++;
 569:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56d:	e9 ae 00 00 00       	jmp    620 <printf+0x170>
      } else if(c == 's'){
 572:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 576:	75 43                	jne    5bb <printf+0x10b>
        s = (char*)*ap;
 578:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 588:	75 25                	jne    5af <printf+0xff>
          s = "(null)";
 58a:	c7 45 f4 6f 08 00 00 	movl   $0x86f,-0xc(%ebp)
        while(*s != 0){
 591:	eb 1c                	jmp    5af <printf+0xff>
          putc(fd, *s);
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	0f b6 00             	movzbl (%eax),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 ec 08             	sub    $0x8,%esp
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 31 fe ff ff       	call   3d9 <putc>
 5a8:	83 c4 10             	add    $0x10,%esp
          s++;
 5ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	84 c0                	test   %al,%al
 5b7:	75 da                	jne    593 <printf+0xe3>
 5b9:	eb 65                	jmp    620 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5bb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5bf:	75 1d                	jne    5de <printf+0x12e>
        putc(fd, *ap);
 5c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c4:	8b 00                	mov    (%eax),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	83 ec 08             	sub    $0x8,%esp
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	pushl  0x8(%ebp)
 5d0:	e8 04 fe ff ff       	call   3d9 <putc>
 5d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5dc:	eb 42                	jmp    620 <printf+0x170>
      } else if(c == '%'){
 5de:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e2:	75 17                	jne    5fb <printf+0x14b>
        putc(fd, c);
 5e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	83 ec 08             	sub    $0x8,%esp
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 e3 fd ff ff       	call   3d9 <putc>
 5f6:	83 c4 10             	add    $0x10,%esp
 5f9:	eb 25                	jmp    620 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fb:	83 ec 08             	sub    $0x8,%esp
 5fe:	6a 25                	push   $0x25
 600:	ff 75 08             	pushl  0x8(%ebp)
 603:	e8 d1 fd ff ff       	call   3d9 <putc>
 608:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 60b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	83 ec 08             	sub    $0x8,%esp
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 bc fd ff ff       	call   3d9 <putc>
 61d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 620:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 627:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 62b:	8b 55 0c             	mov    0xc(%ebp),%edx
 62e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 631:	01 d0                	add    %edx,%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	84 c0                	test   %al,%al
 638:	0f 85 94 fe ff ff    	jne    4d2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 63e:	90                   	nop
 63f:	c9                   	leave  
 640:	c3                   	ret    

00000641 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 641:	55                   	push   %ebp
 642:	89 e5                	mov    %esp,%ebp
 644:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 647:	8b 45 08             	mov    0x8(%ebp),%eax
 64a:	83 e8 08             	sub    $0x8,%eax
 64d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 650:	a1 e0 0a 00 00       	mov    0xae0,%eax
 655:	89 45 fc             	mov    %eax,-0x4(%ebp)
 658:	eb 24                	jmp    67e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 662:	77 12                	ja     676 <free+0x35>
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66a:	77 24                	ja     690 <free+0x4f>
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 674:	77 1a                	ja     690 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 00                	mov    (%eax),%eax
 67b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 684:	76 d4                	jbe    65a <free+0x19>
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68e:	76 ca                	jbe    65a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 690:	8b 45 f8             	mov    -0x8(%ebp),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	01 c2                	add    %eax,%edx
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	39 c2                	cmp    %eax,%edx
 6a9:	75 24                	jne    6cf <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	8b 50 04             	mov    0x4(%eax),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	8b 40 04             	mov    0x4(%eax),%eax
 6b9:	01 c2                	add    %eax,%edx
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	8b 10                	mov    (%eax),%edx
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	89 10                	mov    %edx,(%eax)
 6cd:	eb 0a                	jmp    6d9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 40 04             	mov    0x4(%eax),%eax
 6df:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	01 d0                	add    %edx,%eax
 6eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ee:	75 20                	jne    710 <free+0xcf>
    p->s.size += bp->s.size;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 50 04             	mov    0x4(%eax),%edx
 6f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f9:	8b 40 04             	mov    0x4(%eax),%eax
 6fc:	01 c2                	add    %eax,%edx
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	8b 10                	mov    (%eax),%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	89 10                	mov    %edx,(%eax)
 70e:	eb 08                	jmp    718 <free+0xd7>
  } else
    p->s.ptr = bp;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 55 f8             	mov    -0x8(%ebp),%edx
 716:	89 10                	mov    %edx,(%eax)
  freep = p;
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 720:	90                   	nop
 721:	c9                   	leave  
 722:	c3                   	ret    

00000723 <morecore>:

static Header*
morecore(uint nu)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 729:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 730:	77 07                	ja     739 <morecore+0x16>
    nu = 4096;
 732:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	c1 e0 03             	shl    $0x3,%eax
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	50                   	push   %eax
 743:	e8 41 fc ff ff       	call   389 <sbrk>
 748:	83 c4 10             	add    $0x10,%esp
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 752:	75 07                	jne    75b <morecore+0x38>
    return 0;
 754:	b8 00 00 00 00       	mov    $0x0,%eax
 759:	eb 26                	jmp    781 <morecore+0x5e>
  hp = (Header*)p;
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	8b 55 08             	mov    0x8(%ebp),%edx
 767:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 76a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76d:	83 c0 08             	add    $0x8,%eax
 770:	83 ec 0c             	sub    $0xc,%esp
 773:	50                   	push   %eax
 774:	e8 c8 fe ff ff       	call   641 <free>
 779:	83 c4 10             	add    $0x10,%esp
  return freep;
 77c:	a1 e0 0a 00 00       	mov    0xae0,%eax
}
 781:	c9                   	leave  
 782:	c3                   	ret    

00000783 <malloc>:

void*
malloc(uint nbytes)
{
 783:	55                   	push   %ebp
 784:	89 e5                	mov    %esp,%ebp
 786:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
 78c:	83 c0 07             	add    $0x7,%eax
 78f:	c1 e8 03             	shr    $0x3,%eax
 792:	83 c0 01             	add    $0x1,%eax
 795:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 798:	a1 e0 0a 00 00       	mov    0xae0,%eax
 79d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a4:	75 23                	jne    7c9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7a6:	c7 45 f0 d8 0a 00 00 	movl   $0xad8,-0x10(%ebp)
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	a3 e0 0a 00 00       	mov    %eax,0xae0
 7b5:	a1 e0 0a 00 00       	mov    0xae0,%eax
 7ba:	a3 d8 0a 00 00       	mov    %eax,0xad8
    base.s.size = 0;
 7bf:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 7c6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7da:	72 4d                	jb     829 <malloc+0xa6>
      if(p->s.size == nunits)
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e5:	75 0c                	jne    7f3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	89 10                	mov    %edx,(%eax)
 7f1:	eb 26                	jmp    819 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7fc:	89 c2                	mov    %eax,%edx
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 40 04             	mov    0x4(%eax),%eax
 80a:	c1 e0 03             	shl    $0x3,%eax
 80d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 55 ec             	mov    -0x14(%ebp),%edx
 816:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	a3 e0 0a 00 00       	mov    %eax,0xae0
      return (void*)(p + 1);
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	83 c0 08             	add    $0x8,%eax
 827:	eb 3b                	jmp    864 <malloc+0xe1>
    }
    if(p == freep)
 829:	a1 e0 0a 00 00       	mov    0xae0,%eax
 82e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 831:	75 1e                	jne    851 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	ff 75 ec             	pushl  -0x14(%ebp)
 839:	e8 e5 fe ff ff       	call   723 <morecore>
 83e:	83 c4 10             	add    $0x10,%esp
 841:	89 45 f4             	mov    %eax,-0xc(%ebp)
 844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 848:	75 07                	jne    851 <malloc+0xce>
        return 0;
 84a:	b8 00 00 00 00       	mov    $0x0,%eax
 84f:	eb 13                	jmp    864 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	89 45 f0             	mov    %eax,-0x10(%ebp)
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 85f:	e9 6d ff ff ff       	jmp    7d1 <malloc+0x4e>
}
 864:	c9                   	leave  
 865:	c3                   	ret    
