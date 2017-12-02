
_chmod:     file format elf32-i386


Disassembly of section .text:

00000000 <convert>:
#include "types.h"
#include "user.h"

static int
convert(const char *s)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
   6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
   d:	eb 04                	jmp    13 <convert+0x13>
   f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  13:	8b 45 08             	mov    0x8(%ebp),%eax
  16:	0f b6 00             	movzbl (%eax),%eax
  19:	3c 20                	cmp    $0x20,%al
  1b:	74 f2                	je     f <convert+0xf>
  sign = (*s == '-') ? -1 : 1;
  1d:	8b 45 08             	mov    0x8(%ebp),%eax
  20:	0f b6 00             	movzbl (%eax),%eax
  23:	3c 2d                	cmp    $0x2d,%al
  25:	75 07                	jne    2e <convert+0x2e>
  27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  2c:	eb 05                	jmp    33 <convert+0x33>
  2e:	b8 01 00 00 00       	mov    $0x1,%eax
  33:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
  36:	8b 45 08             	mov    0x8(%ebp),%eax
  39:	0f b6 00             	movzbl (%eax),%eax
  3c:	3c 2b                	cmp    $0x2b,%al
  3e:	74 0a                	je     4a <convert+0x4a>
  40:	8b 45 08             	mov    0x8(%ebp),%eax
  43:	0f b6 00             	movzbl (%eax),%eax
  46:	3c 2d                	cmp    $0x2d,%al
  48:	75 27                	jne    71 <convert+0x71>
    s++;
  4a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
  4e:	eb 21                	jmp    71 <convert+0x71>
    n = n*8 + *s++ - '0';
  50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  53:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  5a:	8b 45 08             	mov    0x8(%ebp),%eax
  5d:	8d 50 01             	lea    0x1(%eax),%edx
  60:	89 55 08             	mov    %edx,0x8(%ebp)
  63:	0f b6 00             	movzbl (%eax),%eax
  66:	0f be c0             	movsbl %al,%eax
  69:	01 c8                	add    %ecx,%eax
  6b:	83 e8 30             	sub    $0x30,%eax
  6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
  71:	8b 45 08             	mov    0x8(%ebp),%eax
  74:	0f b6 00             	movzbl (%eax),%eax
  77:	3c 2f                	cmp    $0x2f,%al
  79:	7e 0a                	jle    85 <convert+0x85>
  7b:	8b 45 08             	mov    0x8(%ebp),%eax
  7e:	0f b6 00             	movzbl (%eax),%eax
  81:	3c 39                	cmp    $0x39,%al
  83:	7e cb                	jle    50 <convert+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
  85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  88:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
  8c:	c9                   	leave  
  8d:	c3                   	ret    

0000008e <main>:
int
main(int argc, char *argv[])
{
  8e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  92:	83 e4 f0             	and    $0xfffffff0,%esp
  95:	ff 71 fc             	pushl  -0x4(%ecx)
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	51                   	push   %ecx
  9c:	83 ec 14             	sub    $0x14,%esp
  9f:	89 c8                	mov    %ecx,%eax
  if(argc < 3) exit();
  a1:	83 38 02             	cmpl   $0x2,(%eax)
  a4:	7f 05                	jg     ab <main+0x1d>
  a6:	e8 f3 02 00 00       	call   39e <exit>

  char * path = argv[2];
  ab:	8b 50 04             	mov    0x4(%eax),%edx
  ae:	8b 52 08             	mov    0x8(%edx),%edx
  b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  int mode = convert(argv[1]);
  b4:	8b 40 04             	mov    0x4(%eax),%eax
  b7:	83 c0 04             	add    $0x4,%eax
  ba:	8b 00                	mov    (%eax),%eax
  bc:	83 ec 0c             	sub    $0xc,%esp
  bf:	50                   	push   %eax
  c0:	e8 3b ff ff ff       	call   0 <convert>
  c5:	83 c4 10             	add    $0x10,%esp
  c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  //printf(1,"%d\n", mode);
  // convert char to int
  // four digits at a time
  // the first one is zero
  
  if(00000 > mode || mode > 01777){
  cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  cf:	78 09                	js     da <main+0x4c>
  d1:	81 7d f0 ff 03 00 00 	cmpl   $0x3ff,-0x10(%ebp)
  d8:	7e 12                	jle    ec <main+0x5e>
  	printf(1,"Invalid argument");
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	68 2b 09 00 00       	push   $0x92b
  e2:	6a 01                	push   $0x1
  e4:	e8 8c 04 00 00       	call   575 <printf>
  e9:	83 c4 10             	add    $0x10,%esp
  }
  chmod(path, mode);
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	ff 75 f0             	pushl  -0x10(%ebp)
  f2:	ff 75 f4             	pushl  -0xc(%ebp)
  f5:	e8 8c 03 00 00       	call   486 <chmod>
  fa:	83 c4 10             	add    $0x10,%esp
  
  exit();
  fd:	e8 9c 02 00 00       	call   39e <exit>

00000102 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	57                   	push   %edi
 106:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10a:	8b 55 10             	mov    0x10(%ebp),%edx
 10d:	8b 45 0c             	mov    0xc(%ebp),%eax
 110:	89 cb                	mov    %ecx,%ebx
 112:	89 df                	mov    %ebx,%edi
 114:	89 d1                	mov    %edx,%ecx
 116:	fc                   	cld    
 117:	f3 aa                	rep stos %al,%es:(%edi)
 119:	89 ca                	mov    %ecx,%edx
 11b:	89 fb                	mov    %edi,%ebx
 11d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 120:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 123:	90                   	nop
 124:	5b                   	pop    %ebx
 125:	5f                   	pop    %edi
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 134:	90                   	nop
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	8d 50 01             	lea    0x1(%eax),%edx
 13b:	89 55 08             	mov    %edx,0x8(%ebp)
 13e:	8b 55 0c             	mov    0xc(%ebp),%edx
 141:	8d 4a 01             	lea    0x1(%edx),%ecx
 144:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 147:	0f b6 12             	movzbl (%edx),%edx
 14a:	88 10                	mov    %dl,(%eax)
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	84 c0                	test   %al,%al
 151:	75 e2                	jne    135 <strcpy+0xd>
    ;
  return os;
 153:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 156:	c9                   	leave  
 157:	c3                   	ret    

00000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15b:	eb 08                	jmp    165 <strcmp+0xd>
    p++, q++;
 15d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 161:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	84 c0                	test   %al,%al
 16d:	74 10                	je     17f <strcmp+0x27>
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	0f b6 10             	movzbl (%eax),%edx
 175:	8b 45 0c             	mov    0xc(%ebp),%eax
 178:	0f b6 00             	movzbl (%eax),%eax
 17b:	38 c2                	cmp    %al,%dl
 17d:	74 de                	je     15d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	0f b6 00             	movzbl (%eax),%eax
 185:	0f b6 d0             	movzbl %al,%edx
 188:	8b 45 0c             	mov    0xc(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	0f b6 c0             	movzbl %al,%eax
 191:	29 c2                	sub    %eax,%edx
 193:	89 d0                	mov    %edx,%eax
}
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    

00000197 <strlen>:

uint
strlen(char *s)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a4:	eb 04                	jmp    1aa <strlen+0x13>
 1a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	01 d0                	add    %edx,%eax
 1b2:	0f b6 00             	movzbl (%eax),%eax
 1b5:	84 c0                	test   %al,%al
 1b7:	75 ed                	jne    1a6 <strlen+0xf>
    ;
  return n;
 1b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bc:	c9                   	leave  
 1bd:	c3                   	ret    

000001be <memset>:

void*
memset(void *dst, int c, uint n)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c1:	8b 45 10             	mov    0x10(%ebp),%eax
 1c4:	50                   	push   %eax
 1c5:	ff 75 0c             	pushl  0xc(%ebp)
 1c8:	ff 75 08             	pushl  0x8(%ebp)
 1cb:	e8 32 ff ff ff       	call   102 <stosb>
 1d0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d6:	c9                   	leave  
 1d7:	c3                   	ret    

000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 04             	sub    $0x4,%esp
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e4:	eb 14                	jmp    1fa <strchr+0x22>
    if(*s == c)
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ef:	75 05                	jne    1f6 <strchr+0x1e>
      return (char*)s;
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	eb 13                	jmp    209 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	0f b6 00             	movzbl (%eax),%eax
 200:	84 c0                	test   %al,%al
 202:	75 e2                	jne    1e6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 204:	b8 00 00 00 00       	mov    $0x0,%eax
}
 209:	c9                   	leave  
 20a:	c3                   	ret    

0000020b <gets>:

char*
gets(char *buf, int max)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 218:	eb 42                	jmp    25c <gets+0x51>
    cc = read(0, &c, 1);
 21a:	83 ec 04             	sub    $0x4,%esp
 21d:	6a 01                	push   $0x1
 21f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 222:	50                   	push   %eax
 223:	6a 00                	push   $0x0
 225:	e8 8c 01 00 00       	call   3b6 <read>
 22a:	83 c4 10             	add    $0x10,%esp
 22d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 230:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 234:	7e 33                	jle    269 <gets+0x5e>
      break;
    buf[i++] = c;
 236:	8b 45 f4             	mov    -0xc(%ebp),%eax
 239:	8d 50 01             	lea    0x1(%eax),%edx
 23c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23f:	89 c2                	mov    %eax,%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 c2                	add    %eax,%edx
 246:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 250:	3c 0a                	cmp    $0xa,%al
 252:	74 16                	je     26a <gets+0x5f>
 254:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 258:	3c 0d                	cmp    $0xd,%al
 25a:	74 0e                	je     26a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25f:	83 c0 01             	add    $0x1,%eax
 262:	3b 45 0c             	cmp    0xc(%ebp),%eax
 265:	7c b3                	jl     21a <gets+0xf>
 267:	eb 01                	jmp    26a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 269:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 26a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	01 d0                	add    %edx,%eax
 272:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 275:	8b 45 08             	mov    0x8(%ebp),%eax
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <stat>:

int
stat(char *n, struct stat *st)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 280:	83 ec 08             	sub    $0x8,%esp
 283:	6a 00                	push   $0x0
 285:	ff 75 08             	pushl  0x8(%ebp)
 288:	e8 51 01 00 00       	call   3de <open>
 28d:	83 c4 10             	add    $0x10,%esp
 290:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 293:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 297:	79 07                	jns    2a0 <stat+0x26>
    return -1;
 299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29e:	eb 25                	jmp    2c5 <stat+0x4b>
  r = fstat(fd, st);
 2a0:	83 ec 08             	sub    $0x8,%esp
 2a3:	ff 75 0c             	pushl  0xc(%ebp)
 2a6:	ff 75 f4             	pushl  -0xc(%ebp)
 2a9:	e8 48 01 00 00       	call   3f6 <fstat>
 2ae:	83 c4 10             	add    $0x10,%esp
 2b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b4:	83 ec 0c             	sub    $0xc,%esp
 2b7:	ff 75 f4             	pushl  -0xc(%ebp)
 2ba:	e8 07 01 00 00       	call   3c6 <close>
 2bf:	83 c4 10             	add    $0x10,%esp
  return r;
 2c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <atoi>:

int
atoi(const char *s)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d4:	eb 04                	jmp    2da <atoi+0x13>
 2d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 00             	movzbl (%eax),%eax
 2e0:	3c 20                	cmp    $0x20,%al
 2e2:	74 f2                	je     2d6 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	0f b6 00             	movzbl (%eax),%eax
 2ea:	3c 2d                	cmp    $0x2d,%al
 2ec:	75 07                	jne    2f5 <atoi+0x2e>
 2ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f3:	eb 05                	jmp    2fa <atoi+0x33>
 2f5:	b8 01 00 00 00       	mov    $0x1,%eax
 2fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	3c 2b                	cmp    $0x2b,%al
 305:	74 0a                	je     311 <atoi+0x4a>
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	3c 2d                	cmp    $0x2d,%al
 30f:	75 2b                	jne    33c <atoi+0x75>
    s++;
 311:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 315:	eb 25                	jmp    33c <atoi+0x75>
    n = n*10 + *s++ - '0';
 317:	8b 55 fc             	mov    -0x4(%ebp),%edx
 31a:	89 d0                	mov    %edx,%eax
 31c:	c1 e0 02             	shl    $0x2,%eax
 31f:	01 d0                	add    %edx,%eax
 321:	01 c0                	add    %eax,%eax
 323:	89 c1                	mov    %eax,%ecx
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	8d 50 01             	lea    0x1(%eax),%edx
 32b:	89 55 08             	mov    %edx,0x8(%ebp)
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	0f be c0             	movsbl %al,%eax
 334:	01 c8                	add    %ecx,%eax
 336:	83 e8 30             	sub    $0x30,%eax
 339:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	3c 2f                	cmp    $0x2f,%al
 344:	7e 0a                	jle    350 <atoi+0x89>
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	3c 39                	cmp    $0x39,%al
 34e:	7e c7                	jle    317 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 350:	8b 45 f8             	mov    -0x8(%ebp),%eax
 353:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 357:	c9                   	leave  
 358:	c3                   	ret    

00000359 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36b:	eb 17                	jmp    384 <memmove+0x2b>
    *dst++ = *src++;
 36d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 370:	8d 50 01             	lea    0x1(%eax),%edx
 373:	89 55 fc             	mov    %edx,-0x4(%ebp)
 376:	8b 55 f8             	mov    -0x8(%ebp),%edx
 379:	8d 4a 01             	lea    0x1(%edx),%ecx
 37c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 37f:	0f b6 12             	movzbl (%edx),%edx
 382:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 384:	8b 45 10             	mov    0x10(%ebp),%eax
 387:	8d 50 ff             	lea    -0x1(%eax),%edx
 38a:	89 55 10             	mov    %edx,0x10(%ebp)
 38d:	85 c0                	test   %eax,%eax
 38f:	7f dc                	jg     36d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 391:	8b 45 08             	mov    0x8(%ebp),%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 396:	b8 01 00 00 00       	mov    $0x1,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exit>:
SYSCALL(exit)
 39e:	b8 02 00 00 00       	mov    $0x2,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <wait>:
SYSCALL(wait)
 3a6:	b8 03 00 00 00       	mov    $0x3,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <pipe>:
SYSCALL(pipe)
 3ae:	b8 04 00 00 00       	mov    $0x4,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <read>:
SYSCALL(read)
 3b6:	b8 05 00 00 00       	mov    $0x5,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <write>:
SYSCALL(write)
 3be:	b8 10 00 00 00       	mov    $0x10,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <close>:
SYSCALL(close)
 3c6:	b8 15 00 00 00       	mov    $0x15,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <kill>:
SYSCALL(kill)
 3ce:	b8 06 00 00 00       	mov    $0x6,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <exec>:
SYSCALL(exec)
 3d6:	b8 07 00 00 00       	mov    $0x7,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <open>:
SYSCALL(open)
 3de:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <mknod>:
SYSCALL(mknod)
 3e6:	b8 11 00 00 00       	mov    $0x11,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <unlink>:
SYSCALL(unlink)
 3ee:	b8 12 00 00 00       	mov    $0x12,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <fstat>:
SYSCALL(fstat)
 3f6:	b8 08 00 00 00       	mov    $0x8,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <link>:
SYSCALL(link)
 3fe:	b8 13 00 00 00       	mov    $0x13,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <mkdir>:
SYSCALL(mkdir)
 406:	b8 14 00 00 00       	mov    $0x14,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <chdir>:
SYSCALL(chdir)
 40e:	b8 09 00 00 00       	mov    $0x9,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <dup>:
SYSCALL(dup)
 416:	b8 0a 00 00 00       	mov    $0xa,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <getpid>:
SYSCALL(getpid)
 41e:	b8 0b 00 00 00       	mov    $0xb,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sbrk>:
SYSCALL(sbrk)
 426:	b8 0c 00 00 00       	mov    $0xc,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <sleep>:
SYSCALL(sleep)
 42e:	b8 0d 00 00 00       	mov    $0xd,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <uptime>:
SYSCALL(uptime)
 436:	b8 0e 00 00 00       	mov    $0xe,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <halt>:
SYSCALL(halt)
 43e:	b8 16 00 00 00       	mov    $0x16,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <date>:
SYSCALL(date)
 446:	b8 17 00 00 00       	mov    $0x17,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <getuid>:
SYSCALL(getuid)
 44e:	b8 18 00 00 00       	mov    $0x18,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <getgid>:
SYSCALL(getgid)
 456:	b8 19 00 00 00       	mov    $0x19,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <getppid>:
SYSCALL(getppid)
 45e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <setuid>:
SYSCALL(setuid)
 466:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <setgid>:
SYSCALL(setgid)
 46e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <getprocs>:
SYSCALL(getprocs)
 476:	b8 1d 00 00 00       	mov    $0x1d,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <setpriority>:
SYSCALL(setpriority)
 47e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <chmod>:
SYSCALL(chmod)
 486:	b8 1f 00 00 00       	mov    $0x1f,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <chown>:
SYSCALL(chown)
 48e:	b8 20 00 00 00       	mov    $0x20,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <chgrp>:
SYSCALL(chgrp)
 496:	b8 21 00 00 00       	mov    $0x21,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	83 ec 18             	sub    $0x18,%esp
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4aa:	83 ec 04             	sub    $0x4,%esp
 4ad:	6a 01                	push   $0x1
 4af:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b2:	50                   	push   %eax
 4b3:	ff 75 08             	pushl  0x8(%ebp)
 4b6:	e8 03 ff ff ff       	call   3be <write>
 4bb:	83 c4 10             	add    $0x10,%esp
}
 4be:	90                   	nop
 4bf:	c9                   	leave  
 4c0:	c3                   	ret    

000004c1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	53                   	push   %ebx
 4c5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d3:	74 17                	je     4ec <printint+0x2b>
 4d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d9:	79 11                	jns    4ec <printint+0x2b>
    neg = 1;
 4db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e5:	f7 d8                	neg    %eax
 4e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ea:	eb 06                	jmp    4f2 <printint+0x31>
  } else {
    x = xx;
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4fc:	8d 41 01             	lea    0x1(%ecx),%eax
 4ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 502:	8b 5d 10             	mov    0x10(%ebp),%ebx
 505:	8b 45 ec             	mov    -0x14(%ebp),%eax
 508:	ba 00 00 00 00       	mov    $0x0,%edx
 50d:	f7 f3                	div    %ebx
 50f:	89 d0                	mov    %edx,%eax
 511:	0f b6 80 ac 0b 00 00 	movzbl 0xbac(%eax),%eax
 518:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 51f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 522:	ba 00 00 00 00       	mov    $0x0,%edx
 527:	f7 f3                	div    %ebx
 529:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 530:	75 c7                	jne    4f9 <printint+0x38>
  if(neg)
 532:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 536:	74 2d                	je     565 <printint+0xa4>
    buf[i++] = '-';
 538:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53b:	8d 50 01             	lea    0x1(%eax),%edx
 53e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 541:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 546:	eb 1d                	jmp    565 <printint+0xa4>
    putc(fd, buf[i]);
 548:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54e:	01 d0                	add    %edx,%eax
 550:	0f b6 00             	movzbl (%eax),%eax
 553:	0f be c0             	movsbl %al,%eax
 556:	83 ec 08             	sub    $0x8,%esp
 559:	50                   	push   %eax
 55a:	ff 75 08             	pushl  0x8(%ebp)
 55d:	e8 3c ff ff ff       	call   49e <putc>
 562:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 565:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56d:	79 d9                	jns    548 <printint+0x87>
    putc(fd, buf[i]);
}
 56f:	90                   	nop
 570:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 573:	c9                   	leave  
 574:	c3                   	ret    

00000575 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 575:	55                   	push   %ebp
 576:	89 e5                	mov    %esp,%ebp
 578:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 582:	8d 45 0c             	lea    0xc(%ebp),%eax
 585:	83 c0 04             	add    $0x4,%eax
 588:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 592:	e9 59 01 00 00       	jmp    6f0 <printf+0x17b>
    c = fmt[i] & 0xff;
 597:	8b 55 0c             	mov    0xc(%ebp),%edx
 59a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59d:	01 d0                	add    %edx,%eax
 59f:	0f b6 00             	movzbl (%eax),%eax
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	25 ff 00 00 00       	and    $0xff,%eax
 5aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b1:	75 2c                	jne    5df <printf+0x6a>
      if(c == '%'){
 5b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b7:	75 0c                	jne    5c5 <printf+0x50>
        state = '%';
 5b9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c0:	e9 27 01 00 00       	jmp    6ec <printf+0x177>
      } else {
        putc(fd, c);
 5c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 ec 08             	sub    $0x8,%esp
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	pushl  0x8(%ebp)
 5d2:	e8 c7 fe ff ff       	call   49e <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
 5da:	e9 0d 01 00 00       	jmp    6ec <printf+0x177>
      }
    } else if(state == '%'){
 5df:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e3:	0f 85 03 01 00 00    	jne    6ec <printf+0x177>
      if(c == 'd'){
 5e9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ed:	75 1e                	jne    60d <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f2:	8b 00                	mov    (%eax),%eax
 5f4:	6a 01                	push   $0x1
 5f6:	6a 0a                	push   $0xa
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	pushl  0x8(%ebp)
 5fc:	e8 c0 fe ff ff       	call   4c1 <printint>
 601:	83 c4 10             	add    $0x10,%esp
        ap++;
 604:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 608:	e9 d8 00 00 00       	jmp    6e5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 60d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 611:	74 06                	je     619 <printf+0xa4>
 613:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 617:	75 1e                	jne    637 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 619:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	6a 00                	push   $0x0
 620:	6a 10                	push   $0x10
 622:	50                   	push   %eax
 623:	ff 75 08             	pushl  0x8(%ebp)
 626:	e8 96 fe ff ff       	call   4c1 <printint>
 62b:	83 c4 10             	add    $0x10,%esp
        ap++;
 62e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 632:	e9 ae 00 00 00       	jmp    6e5 <printf+0x170>
      } else if(c == 's'){
 637:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63b:	75 43                	jne    680 <printf+0x10b>
        s = (char*)*ap;
 63d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 645:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64d:	75 25                	jne    674 <printf+0xff>
          s = "(null)";
 64f:	c7 45 f4 3c 09 00 00 	movl   $0x93c,-0xc(%ebp)
        while(*s != 0){
 656:	eb 1c                	jmp    674 <printf+0xff>
          putc(fd, *s);
 658:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65b:	0f b6 00             	movzbl (%eax),%eax
 65e:	0f be c0             	movsbl %al,%eax
 661:	83 ec 08             	sub    $0x8,%esp
 664:	50                   	push   %eax
 665:	ff 75 08             	pushl  0x8(%ebp)
 668:	e8 31 fe ff ff       	call   49e <putc>
 66d:	83 c4 10             	add    $0x10,%esp
          s++;
 670:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 674:	8b 45 f4             	mov    -0xc(%ebp),%eax
 677:	0f b6 00             	movzbl (%eax),%eax
 67a:	84 c0                	test   %al,%al
 67c:	75 da                	jne    658 <printf+0xe3>
 67e:	eb 65                	jmp    6e5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 680:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 684:	75 1d                	jne    6a3 <printf+0x12e>
        putc(fd, *ap);
 686:	8b 45 e8             	mov    -0x18(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	83 ec 08             	sub    $0x8,%esp
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 04 fe ff ff       	call   49e <putc>
 69a:	83 c4 10             	add    $0x10,%esp
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a1:	eb 42                	jmp    6e5 <printf+0x170>
      } else if(c == '%'){
 6a3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a7:	75 17                	jne    6c0 <printf+0x14b>
        putc(fd, c);
 6a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ac:	0f be c0             	movsbl %al,%eax
 6af:	83 ec 08             	sub    $0x8,%esp
 6b2:	50                   	push   %eax
 6b3:	ff 75 08             	pushl  0x8(%ebp)
 6b6:	e8 e3 fd ff ff       	call   49e <putc>
 6bb:	83 c4 10             	add    $0x10,%esp
 6be:	eb 25                	jmp    6e5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c0:	83 ec 08             	sub    $0x8,%esp
 6c3:	6a 25                	push   $0x25
 6c5:	ff 75 08             	pushl  0x8(%ebp)
 6c8:	e8 d1 fd ff ff       	call   49e <putc>
 6cd:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	83 ec 08             	sub    $0x8,%esp
 6d9:	50                   	push   %eax
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 bc fd ff ff       	call   49e <putc>
 6e2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f6:	01 d0                	add    %edx,%eax
 6f8:	0f b6 00             	movzbl (%eax),%eax
 6fb:	84 c0                	test   %al,%al
 6fd:	0f 85 94 fe ff ff    	jne    597 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 703:	90                   	nop
 704:	c9                   	leave  
 705:	c3                   	ret    

00000706 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 706:	55                   	push   %ebp
 707:	89 e5                	mov    %esp,%ebp
 709:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	83 e8 08             	sub    $0x8,%eax
 712:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 715:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 71a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71d:	eb 24                	jmp    743 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 727:	77 12                	ja     73b <free+0x35>
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72f:	77 24                	ja     755 <free+0x4f>
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 00                	mov    (%eax),%eax
 736:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 739:	77 1a                	ja     755 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	89 45 fc             	mov    %eax,-0x4(%ebp)
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 749:	76 d4                	jbe    71f <free+0x19>
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 753:	76 ca                	jbe    71f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	01 c2                	add    %eax,%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	39 c2                	cmp    %eax,%edx
 76e:	75 24                	jne    794 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	8b 50 04             	mov    0x4(%eax),%edx
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	8b 00                	mov    (%eax),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	01 c2                	add    %eax,%edx
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	8b 10                	mov    (%eax),%edx
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	89 10                	mov    %edx,(%eax)
 792:	eb 0a                	jmp    79e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 10                	mov    (%eax),%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 40 04             	mov    0x4(%eax),%eax
 7a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	01 d0                	add    %edx,%eax
 7b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b3:	75 20                	jne    7d5 <free+0xcf>
    p->s.size += bp->s.size;
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 50 04             	mov    0x4(%eax),%edx
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	8b 40 04             	mov    0x4(%eax),%eax
 7c1:	01 c2                	add    %eax,%edx
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	8b 10                	mov    (%eax),%edx
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	89 10                	mov    %edx,(%eax)
 7d3:	eb 08                	jmp    7dd <free+0xd7>
  } else
    p->s.ptr = bp;
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7db:	89 10                	mov    %edx,(%eax)
  freep = p;
 7dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e0:	a3 c8 0b 00 00       	mov    %eax,0xbc8
}
 7e5:	90                   	nop
 7e6:	c9                   	leave  
 7e7:	c3                   	ret    

000007e8 <morecore>:

static Header*
morecore(uint nu)
{
 7e8:	55                   	push   %ebp
 7e9:	89 e5                	mov    %esp,%ebp
 7eb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ee:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f5:	77 07                	ja     7fe <morecore+0x16>
    nu = 4096;
 7f7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	c1 e0 03             	shl    $0x3,%eax
 804:	83 ec 0c             	sub    $0xc,%esp
 807:	50                   	push   %eax
 808:	e8 19 fc ff ff       	call   426 <sbrk>
 80d:	83 c4 10             	add    $0x10,%esp
 810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 813:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 817:	75 07                	jne    820 <morecore+0x38>
    return 0;
 819:	b8 00 00 00 00       	mov    $0x0,%eax
 81e:	eb 26                	jmp    846 <morecore+0x5e>
  hp = (Header*)p;
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	8b 55 08             	mov    0x8(%ebp),%edx
 82c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	83 c0 08             	add    $0x8,%eax
 835:	83 ec 0c             	sub    $0xc,%esp
 838:	50                   	push   %eax
 839:	e8 c8 fe ff ff       	call   706 <free>
 83e:	83 c4 10             	add    $0x10,%esp
  return freep;
 841:	a1 c8 0b 00 00       	mov    0xbc8,%eax
}
 846:	c9                   	leave  
 847:	c3                   	ret    

00000848 <malloc>:

void*
malloc(uint nbytes)
{
 848:	55                   	push   %ebp
 849:	89 e5                	mov    %esp,%ebp
 84b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84e:	8b 45 08             	mov    0x8(%ebp),%eax
 851:	83 c0 07             	add    $0x7,%eax
 854:	c1 e8 03             	shr    $0x3,%eax
 857:	83 c0 01             	add    $0x1,%eax
 85a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85d:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 862:	89 45 f0             	mov    %eax,-0x10(%ebp)
 865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 869:	75 23                	jne    88e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86b:	c7 45 f0 c0 0b 00 00 	movl   $0xbc0,-0x10(%ebp)
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	a3 c8 0b 00 00       	mov    %eax,0xbc8
 87a:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 87f:	a3 c0 0b 00 00       	mov    %eax,0xbc0
    base.s.size = 0;
 884:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 88b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89f:	72 4d                	jb     8ee <malloc+0xa6>
      if(p->s.size == nunits)
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	8b 40 04             	mov    0x4(%eax),%eax
 8a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8aa:	75 0c                	jne    8b8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 10                	mov    (%eax),%edx
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	89 10                	mov    %edx,(%eax)
 8b6:	eb 26                	jmp    8de <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 40 04             	mov    0x4(%eax),%eax
 8be:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c1:	89 c2                	mov    %eax,%edx
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	8b 40 04             	mov    0x4(%eax),%eax
 8cf:	c1 e0 03             	shl    $0x3,%eax
 8d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e1:	a3 c8 0b 00 00       	mov    %eax,0xbc8
      return (void*)(p + 1);
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	83 c0 08             	add    $0x8,%eax
 8ec:	eb 3b                	jmp    929 <malloc+0xe1>
    }
    if(p == freep)
 8ee:	a1 c8 0b 00 00       	mov    0xbc8,%eax
 8f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f6:	75 1e                	jne    916 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8f8:	83 ec 0c             	sub    $0xc,%esp
 8fb:	ff 75 ec             	pushl  -0x14(%ebp)
 8fe:	e8 e5 fe ff ff       	call   7e8 <morecore>
 903:	83 c4 10             	add    $0x10,%esp
 906:	89 45 f4             	mov    %eax,-0xc(%ebp)
 909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90d:	75 07                	jne    916 <malloc+0xce>
        return 0;
 90f:	b8 00 00 00 00       	mov    $0x0,%eax
 914:	eb 13                	jmp    929 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91f:	8b 00                	mov    (%eax),%eax
 921:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 924:	e9 6d ff ff ff       	jmp    896 <malloc+0x4e>
}
 929:	c9                   	leave  
 92a:	c3                   	ret    
