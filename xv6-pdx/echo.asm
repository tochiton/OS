
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
  27:	ba 3e 08 00 00       	mov    $0x83e,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba 40 08 00 00       	mov    $0x840,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 42 08 00 00       	push   $0x842
  4b:	6a 01                	push   $0x1
  4d:	e8 36 04 00 00       	call   488 <printf>
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

000003b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b1:	55                   	push   %ebp
 3b2:	89 e5                	mov    %esp,%ebp
 3b4:	83 ec 18             	sub    $0x18,%esp
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3bd:	83 ec 04             	sub    $0x4,%esp
 3c0:	6a 01                	push   $0x1
 3c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3c5:	50                   	push   %eax
 3c6:	ff 75 08             	pushl  0x8(%ebp)
 3c9:	e8 53 ff ff ff       	call   321 <write>
 3ce:	83 c4 10             	add    $0x10,%esp
}
 3d1:	90                   	nop
 3d2:	c9                   	leave  
 3d3:	c3                   	ret    

000003d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	53                   	push   %ebx
 3d8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3e2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e6:	74 17                	je     3ff <printint+0x2b>
 3e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ec:	79 11                	jns    3ff <printint+0x2b>
    neg = 1;
 3ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f8:	f7 d8                	neg    %eax
 3fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3fd:	eb 06                	jmp    405 <printint+0x31>
  } else {
    x = xx;
 3ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 402:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 40c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 40f:	8d 41 01             	lea    0x1(%ecx),%eax
 412:	89 45 f4             	mov    %eax,-0xc(%ebp)
 415:	8b 5d 10             	mov    0x10(%ebp),%ebx
 418:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41b:	ba 00 00 00 00       	mov    $0x0,%edx
 420:	f7 f3                	div    %ebx
 422:	89 d0                	mov    %edx,%eax
 424:	0f b6 80 9c 0a 00 00 	movzbl 0xa9c(%eax),%eax
 42b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 42f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 432:	8b 45 ec             	mov    -0x14(%ebp),%eax
 435:	ba 00 00 00 00       	mov    $0x0,%edx
 43a:	f7 f3                	div    %ebx
 43c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 443:	75 c7                	jne    40c <printint+0x38>
  if(neg)
 445:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 449:	74 2d                	je     478 <printint+0xa4>
    buf[i++] = '-';
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	8d 50 01             	lea    0x1(%eax),%edx
 451:	89 55 f4             	mov    %edx,-0xc(%ebp)
 454:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 459:	eb 1d                	jmp    478 <printint+0xa4>
    putc(fd, buf[i]);
 45b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 461:	01 d0                	add    %edx,%eax
 463:	0f b6 00             	movzbl (%eax),%eax
 466:	0f be c0             	movsbl %al,%eax
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	50                   	push   %eax
 46d:	ff 75 08             	pushl  0x8(%ebp)
 470:	e8 3c ff ff ff       	call   3b1 <putc>
 475:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 478:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 47c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 480:	79 d9                	jns    45b <printint+0x87>
    putc(fd, buf[i]);
}
 482:	90                   	nop
 483:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 486:	c9                   	leave  
 487:	c3                   	ret    

00000488 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
 48b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 48e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 495:	8d 45 0c             	lea    0xc(%ebp),%eax
 498:	83 c0 04             	add    $0x4,%eax
 49b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 49e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4a5:	e9 59 01 00 00       	jmp    603 <printf+0x17b>
    c = fmt[i] & 0xff;
 4aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b0:	01 d0                	add    %edx,%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	25 ff 00 00 00       	and    $0xff,%eax
 4bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c4:	75 2c                	jne    4f2 <printf+0x6a>
      if(c == '%'){
 4c6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ca:	75 0c                	jne    4d8 <printf+0x50>
        state = '%';
 4cc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d3:	e9 27 01 00 00       	jmp    5ff <printf+0x177>
      } else {
        putc(fd, c);
 4d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4db:	0f be c0             	movsbl %al,%eax
 4de:	83 ec 08             	sub    $0x8,%esp
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 c7 fe ff ff       	call   3b1 <putc>
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	e9 0d 01 00 00       	jmp    5ff <printf+0x177>
      }
    } else if(state == '%'){
 4f2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4f6:	0f 85 03 01 00 00    	jne    5ff <printf+0x177>
      if(c == 'd'){
 4fc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 500:	75 1e                	jne    520 <printf+0x98>
        printint(fd, *ap, 10, 1);
 502:	8b 45 e8             	mov    -0x18(%ebp),%eax
 505:	8b 00                	mov    (%eax),%eax
 507:	6a 01                	push   $0x1
 509:	6a 0a                	push   $0xa
 50b:	50                   	push   %eax
 50c:	ff 75 08             	pushl  0x8(%ebp)
 50f:	e8 c0 fe ff ff       	call   3d4 <printint>
 514:	83 c4 10             	add    $0x10,%esp
        ap++;
 517:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51b:	e9 d8 00 00 00       	jmp    5f8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 520:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 524:	74 06                	je     52c <printf+0xa4>
 526:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52a:	75 1e                	jne    54a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	6a 00                	push   $0x0
 533:	6a 10                	push   $0x10
 535:	50                   	push   %eax
 536:	ff 75 08             	pushl  0x8(%ebp)
 539:	e8 96 fe ff ff       	call   3d4 <printint>
 53e:	83 c4 10             	add    $0x10,%esp
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 545:	e9 ae 00 00 00       	jmp    5f8 <printf+0x170>
      } else if(c == 's'){
 54a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54e:	75 43                	jne    593 <printf+0x10b>
        s = (char*)*ap;
 550:	8b 45 e8             	mov    -0x18(%ebp),%eax
 553:	8b 00                	mov    (%eax),%eax
 555:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 560:	75 25                	jne    587 <printf+0xff>
          s = "(null)";
 562:	c7 45 f4 47 08 00 00 	movl   $0x847,-0xc(%ebp)
        while(*s != 0){
 569:	eb 1c                	jmp    587 <printf+0xff>
          putc(fd, *s);
 56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	83 ec 08             	sub    $0x8,%esp
 577:	50                   	push   %eax
 578:	ff 75 08             	pushl  0x8(%ebp)
 57b:	e8 31 fe ff ff       	call   3b1 <putc>
 580:	83 c4 10             	add    $0x10,%esp
          s++;
 583:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	84 c0                	test   %al,%al
 58f:	75 da                	jne    56b <printf+0xe3>
 591:	eb 65                	jmp    5f8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 593:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 597:	75 1d                	jne    5b6 <printf+0x12e>
        putc(fd, *ap);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	83 ec 08             	sub    $0x8,%esp
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 04 fe ff ff       	call   3b1 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b4:	eb 42                	jmp    5f8 <printf+0x170>
      } else if(c == '%'){
 5b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ba:	75 17                	jne    5d3 <printf+0x14b>
        putc(fd, c);
 5bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	83 ec 08             	sub    $0x8,%esp
 5c5:	50                   	push   %eax
 5c6:	ff 75 08             	pushl  0x8(%ebp)
 5c9:	e8 e3 fd ff ff       	call   3b1 <putc>
 5ce:	83 c4 10             	add    $0x10,%esp
 5d1:	eb 25                	jmp    5f8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	6a 25                	push   $0x25
 5d8:	ff 75 08             	pushl  0x8(%ebp)
 5db:	e8 d1 fd ff ff       	call   3b1 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 bc fd ff ff       	call   3b1 <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ff:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 603:	8b 55 0c             	mov    0xc(%ebp),%edx
 606:	8b 45 f0             	mov    -0x10(%ebp),%eax
 609:	01 d0                	add    %edx,%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	84 c0                	test   %al,%al
 610:	0f 85 94 fe ff ff    	jne    4aa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 616:	90                   	nop
 617:	c9                   	leave  
 618:	c3                   	ret    

00000619 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	83 e8 08             	sub    $0x8,%eax
 625:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	a1 b8 0a 00 00       	mov    0xab8,%eax
 62d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 630:	eb 24                	jmp    656 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	77 12                	ja     64e <free+0x35>
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 642:	77 24                	ja     668 <free+0x4f>
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64c:	77 1a                	ja     668 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	89 45 fc             	mov    %eax,-0x4(%ebp)
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65c:	76 d4                	jbe    632 <free+0x19>
 65e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 661:	8b 00                	mov    (%eax),%eax
 663:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 666:	76 ca                	jbe    632 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	8b 40 04             	mov    0x4(%eax),%eax
 66e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	01 c2                	add    %eax,%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	39 c2                	cmp    %eax,%edx
 681:	75 24                	jne    6a7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 50 04             	mov    0x4(%eax),%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	8b 40 04             	mov    0x4(%eax),%eax
 691:	01 c2                	add    %eax,%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	8b 10                	mov    (%eax),%edx
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	89 10                	mov    %edx,(%eax)
 6a5:	eb 0a                	jmp    6b1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	01 d0                	add    %edx,%eax
 6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c6:	75 20                	jne    6e8 <free+0xcf>
    p->s.size += bp->s.size;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 50 04             	mov    0x4(%eax),%edx
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 40 04             	mov    0x4(%eax),%eax
 6d4:	01 c2                	add    %eax,%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	8b 10                	mov    (%eax),%edx
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	89 10                	mov    %edx,(%eax)
 6e6:	eb 08                	jmp    6f0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ee:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 6f8:	90                   	nop
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <morecore>:

static Header*
morecore(uint nu)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 701:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 708:	77 07                	ja     711 <morecore+0x16>
    nu = 4096;
 70a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 711:	8b 45 08             	mov    0x8(%ebp),%eax
 714:	c1 e0 03             	shl    $0x3,%eax
 717:	83 ec 0c             	sub    $0xc,%esp
 71a:	50                   	push   %eax
 71b:	e8 69 fc ff ff       	call   389 <sbrk>
 720:	83 c4 10             	add    $0x10,%esp
 723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 726:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72a:	75 07                	jne    733 <morecore+0x38>
    return 0;
 72c:	b8 00 00 00 00       	mov    $0x0,%eax
 731:	eb 26                	jmp    759 <morecore+0x5e>
  hp = (Header*)p;
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	8b 55 08             	mov    0x8(%ebp),%edx
 73f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	83 c0 08             	add    $0x8,%eax
 748:	83 ec 0c             	sub    $0xc,%esp
 74b:	50                   	push   %eax
 74c:	e8 c8 fe ff ff       	call   619 <free>
 751:	83 c4 10             	add    $0x10,%esp
  return freep;
 754:	a1 b8 0a 00 00       	mov    0xab8,%eax
}
 759:	c9                   	leave  
 75a:	c3                   	ret    

0000075b <malloc>:

void*
malloc(uint nbytes)
{
 75b:	55                   	push   %ebp
 75c:	89 e5                	mov    %esp,%ebp
 75e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	83 c0 07             	add    $0x7,%eax
 767:	c1 e8 03             	shr    $0x3,%eax
 76a:	83 c0 01             	add    $0x1,%eax
 76d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 770:	a1 b8 0a 00 00       	mov    0xab8,%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
 778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77c:	75 23                	jne    7a1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77e:	c7 45 f0 b0 0a 00 00 	movl   $0xab0,-0x10(%ebp)
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	a3 b8 0a 00 00       	mov    %eax,0xab8
 78d:	a1 b8 0a 00 00       	mov    0xab8,%eax
 792:	a3 b0 0a 00 00       	mov    %eax,0xab0
    base.s.size = 0;
 797:	c7 05 b4 0a 00 00 00 	movl   $0x0,0xab4
 79e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8b 40 04             	mov    0x4(%eax),%eax
 7af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b2:	72 4d                	jb     801 <malloc+0xa6>
      if(p->s.size == nunits)
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bd:	75 0c                	jne    7cb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 10                	mov    (%eax),%edx
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	89 10                	mov    %edx,(%eax)
 7c9:	eb 26                	jmp    7f1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d4:	89 c2                	mov    %eax,%edx
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	c1 e0 03             	shl    $0x3,%eax
 7e5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	a3 b8 0a 00 00       	mov    %eax,0xab8
      return (void*)(p + 1);
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	83 c0 08             	add    $0x8,%eax
 7ff:	eb 3b                	jmp    83c <malloc+0xe1>
    }
    if(p == freep)
 801:	a1 b8 0a 00 00       	mov    0xab8,%eax
 806:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 809:	75 1e                	jne    829 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	ff 75 ec             	pushl  -0x14(%ebp)
 811:	e8 e5 fe ff ff       	call   6fb <morecore>
 816:	83 c4 10             	add    $0x10,%esp
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 820:	75 07                	jne    829 <malloc+0xce>
        return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 13                	jmp    83c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 837:	e9 6d ff ff ff       	jmp    7a9 <malloc+0x4e>
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    
