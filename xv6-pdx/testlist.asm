
_testlist:     file format elf32-i386


Disassembly of section .text:

00000000 <testSched>:
#include "types.h"
#include "user.h"


void
testSched(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int ret = 1;
   6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  for(int i = 0; i < 10 && ret != 0; ++i) 
   d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  14:	eb 0c                	jmp    22 <testSched+0x22>
  ret = fork();
  16:	e8 fc 02 00 00       	call   317 <fork>
  1b:	89 45 f4             	mov    %eax,-0xc(%ebp)


void
testSched(){
  int ret = 1;
  for(int i = 0; i < 10 && ret != 0; ++i) 
  1e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  22:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  26:	7f 06                	jg     2e <testSched+0x2e>
  28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2c:	75 e8                	jne    16 <testSched+0x16>
  ret = fork();

  if(ret == 0)
  2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  32:	75 02                	jne    36 <testSched+0x36>
    for(;;);
  34:	eb fe                	jmp    34 <testSched+0x34>
  exit();
  36:	e8 e4 02 00 00       	call   31f <exit>

0000003b <testList>:
}
//creates a process
void
testList(){
  3b:	55                   	push   %ebp
  3c:	89 e5                	mov    %esp,%ebp
  3e:	83 ec 08             	sub    $0x8,%esp
  sleep(5000);
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	68 88 13 00 00       	push   $0x1388
  49:	e8 61 03 00 00       	call   3af <sleep>
  4e:	83 c4 10             	add    $0x10,%esp
  printf(1,"Finished sleeping for 5 seconds \n ");
  51:	83 ec 08             	sub    $0x8,%esp
  54:	68 8c 08 00 00       	push   $0x88c
  59:	6a 01                	push   $0x1
  5b:	e8 76 04 00 00       	call   4d6 <printf>
  60:	83 c4 10             	add    $0x10,%esp
  exit();
  63:	e8 b7 02 00 00       	call   31f <exit>

00000068 <main>:
}

int
main(int argc, char *argv[])
{
  68:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  6c:	83 e4 f0             	and    $0xfffffff0,%esp
  6f:	ff 71 fc             	pushl  -0x4(%ecx)
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	51                   	push   %ecx
  76:	83 ec 04             	sub    $0x4,%esp
  //testSched();
  testList();
  79:	e8 bd ff ff ff       	call   3b <testList>
  exit();
  7e:	e8 9c 02 00 00       	call   31f <exit>

00000083 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  83:	55                   	push   %ebp
  84:	89 e5                	mov    %esp,%ebp
  86:	57                   	push   %edi
  87:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8b:	8b 55 10             	mov    0x10(%ebp),%edx
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	89 cb                	mov    %ecx,%ebx
  93:	89 df                	mov    %ebx,%edi
  95:	89 d1                	mov    %edx,%ecx
  97:	fc                   	cld    
  98:	f3 aa                	rep stos %al,%es:(%edi)
  9a:	89 ca                	mov    %ecx,%edx
  9c:	89 fb                	mov    %edi,%ebx
  9e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  a4:	90                   	nop
  a5:	5b                   	pop    %ebx
  a6:	5f                   	pop    %edi
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  b5:	90                   	nop
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	8d 50 01             	lea    0x1(%eax),%edx
  bc:	89 55 08             	mov    %edx,0x8(%ebp)
  bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  c2:	8d 4a 01             	lea    0x1(%edx),%ecx
  c5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c8:	0f b6 12             	movzbl (%edx),%edx
  cb:	88 10                	mov    %dl,(%eax)
  cd:	0f b6 00             	movzbl (%eax),%eax
  d0:	84 c0                	test   %al,%al
  d2:	75 e2                	jne    b6 <strcpy+0xd>
    ;
  return os;
  d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d7:	c9                   	leave  
  d8:	c3                   	ret    

000000d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  dc:	eb 08                	jmp    e6 <strcmp+0xd>
    p++, q++;
  de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	84 c0                	test   %al,%al
  ee:	74 10                	je     100 <strcmp+0x27>
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	0f b6 10             	movzbl (%eax),%edx
  f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	38 c2                	cmp    %al,%dl
  fe:	74 de                	je     de <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	0f b6 00             	movzbl (%eax),%eax
 106:	0f b6 d0             	movzbl %al,%edx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	0f b6 c0             	movzbl %al,%eax
 112:	29 c2                	sub    %eax,%edx
 114:	89 d0                	mov    %edx,%eax
}
 116:	5d                   	pop    %ebp
 117:	c3                   	ret    

00000118 <strlen>:

uint
strlen(char *s)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 125:	eb 04                	jmp    12b <strlen+0x13>
 127:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 12b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	01 d0                	add    %edx,%eax
 133:	0f b6 00             	movzbl (%eax),%eax
 136:	84 c0                	test   %al,%al
 138:	75 ed                	jne    127 <strlen+0xf>
    ;
  return n;
 13a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13d:	c9                   	leave  
 13e:	c3                   	ret    

0000013f <memset>:

void*
memset(void *dst, int c, uint n)
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 142:	8b 45 10             	mov    0x10(%ebp),%eax
 145:	50                   	push   %eax
 146:	ff 75 0c             	pushl  0xc(%ebp)
 149:	ff 75 08             	pushl  0x8(%ebp)
 14c:	e8 32 ff ff ff       	call   83 <stosb>
 151:	83 c4 0c             	add    $0xc,%esp
  return dst;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
}
 157:	c9                   	leave  
 158:	c3                   	ret    

00000159 <strchr>:

char*
strchr(const char *s, char c)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 04             	sub    $0x4,%esp
 15f:	8b 45 0c             	mov    0xc(%ebp),%eax
 162:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 165:	eb 14                	jmp    17b <strchr+0x22>
    if(*s == c)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 170:	75 05                	jne    177 <strchr+0x1e>
      return (char*)s;
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	eb 13                	jmp    18a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 177:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	84 c0                	test   %al,%al
 183:	75 e2                	jne    167 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 185:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18a:	c9                   	leave  
 18b:	c3                   	ret    

0000018c <gets>:

char*
gets(char *buf, int max)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 192:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 199:	eb 42                	jmp    1dd <gets+0x51>
    cc = read(0, &c, 1);
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	6a 01                	push   $0x1
 1a0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1a3:	50                   	push   %eax
 1a4:	6a 00                	push   $0x0
 1a6:	e8 8c 01 00 00       	call   337 <read>
 1ab:	83 c4 10             	add    $0x10,%esp
 1ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b5:	7e 33                	jle    1ea <gets+0x5e>
      break;
    buf[i++] = c;
 1b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ba:	8d 50 01             	lea    0x1(%eax),%edx
 1bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1c0:	89 c2                	mov    %eax,%edx
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	01 c2                	add    %eax,%edx
 1c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d1:	3c 0a                	cmp    $0xa,%al
 1d3:	74 16                	je     1eb <gets+0x5f>
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	3c 0d                	cmp    $0xd,%al
 1db:	74 0e                	je     1eb <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e0:	83 c0 01             	add    $0x1,%eax
 1e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e6:	7c b3                	jl     19b <gets+0xf>
 1e8:	eb 01                	jmp    1eb <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ea:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	01 d0                	add    %edx,%eax
 1f3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <stat>:

int
stat(char *n, struct stat *st)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	6a 00                	push   $0x0
 206:	ff 75 08             	pushl  0x8(%ebp)
 209:	e8 51 01 00 00       	call   35f <open>
 20e:	83 c4 10             	add    $0x10,%esp
 211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 218:	79 07                	jns    221 <stat+0x26>
    return -1;
 21a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21f:	eb 25                	jmp    246 <stat+0x4b>
  r = fstat(fd, st);
 221:	83 ec 08             	sub    $0x8,%esp
 224:	ff 75 0c             	pushl  0xc(%ebp)
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 48 01 00 00       	call   377 <fstat>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 235:	83 ec 0c             	sub    $0xc,%esp
 238:	ff 75 f4             	pushl  -0xc(%ebp)
 23b:	e8 07 01 00 00       	call   347 <close>
 240:	83 c4 10             	add    $0x10,%esp
  return r;
 243:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <atoi>:

int
atoi(const char *s)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 24e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 255:	eb 04                	jmp    25b <atoi+0x13>
 257:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	3c 20                	cmp    $0x20,%al
 263:	74 f2                	je     257 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	3c 2d                	cmp    $0x2d,%al
 26d:	75 07                	jne    276 <atoi+0x2e>
 26f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 274:	eb 05                	jmp    27b <atoi+0x33>
 276:	b8 01 00 00 00       	mov    $0x1,%eax
 27b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	3c 2b                	cmp    $0x2b,%al
 286:	74 0a                	je     292 <atoi+0x4a>
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	3c 2d                	cmp    $0x2d,%al
 290:	75 2b                	jne    2bd <atoi+0x75>
    s++;
 292:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 296:	eb 25                	jmp    2bd <atoi+0x75>
    n = n*10 + *s++ - '0';
 298:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29b:	89 d0                	mov    %edx,%eax
 29d:	c1 e0 02             	shl    $0x2,%eax
 2a0:	01 d0                	add    %edx,%eax
 2a2:	01 c0                	add    %eax,%eax
 2a4:	89 c1                	mov    %eax,%ecx
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	8d 50 01             	lea    0x1(%eax),%edx
 2ac:	89 55 08             	mov    %edx,0x8(%ebp)
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	0f be c0             	movsbl %al,%eax
 2b5:	01 c8                	add    %ecx,%eax
 2b7:	83 e8 30             	sub    $0x30,%eax
 2ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	3c 2f                	cmp    $0x2f,%al
 2c5:	7e 0a                	jle    2d1 <atoi+0x89>
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 00             	movzbl (%eax),%eax
 2cd:	3c 39                	cmp    $0x39,%al
 2cf:	7e c7                	jle    298 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2d4:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ec:	eb 17                	jmp    305 <memmove+0x2b>
    *dst++ = *src++;
 2ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2f1:	8d 50 01             	lea    0x1(%eax),%edx
 2f4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2fa:	8d 4a 01             	lea    0x1(%edx),%ecx
 2fd:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 300:	0f b6 12             	movzbl (%edx),%edx
 303:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 305:	8b 45 10             	mov    0x10(%ebp),%eax
 308:	8d 50 ff             	lea    -0x1(%eax),%edx
 30b:	89 55 10             	mov    %edx,0x10(%ebp)
 30e:	85 c0                	test   %eax,%eax
 310:	7f dc                	jg     2ee <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 312:	8b 45 08             	mov    0x8(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 317:	b8 01 00 00 00       	mov    $0x1,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <exit>:
SYSCALL(exit)
 31f:	b8 02 00 00 00       	mov    $0x2,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <wait>:
SYSCALL(wait)
 327:	b8 03 00 00 00       	mov    $0x3,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <pipe>:
SYSCALL(pipe)
 32f:	b8 04 00 00 00       	mov    $0x4,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <read>:
SYSCALL(read)
 337:	b8 05 00 00 00       	mov    $0x5,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <write>:
SYSCALL(write)
 33f:	b8 10 00 00 00       	mov    $0x10,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <close>:
SYSCALL(close)
 347:	b8 15 00 00 00       	mov    $0x15,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <kill>:
SYSCALL(kill)
 34f:	b8 06 00 00 00       	mov    $0x6,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <exec>:
SYSCALL(exec)
 357:	b8 07 00 00 00       	mov    $0x7,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <open>:
SYSCALL(open)
 35f:	b8 0f 00 00 00       	mov    $0xf,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <mknod>:
SYSCALL(mknod)
 367:	b8 11 00 00 00       	mov    $0x11,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <unlink>:
SYSCALL(unlink)
 36f:	b8 12 00 00 00       	mov    $0x12,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <fstat>:
SYSCALL(fstat)
 377:	b8 08 00 00 00       	mov    $0x8,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <link>:
SYSCALL(link)
 37f:	b8 13 00 00 00       	mov    $0x13,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <mkdir>:
SYSCALL(mkdir)
 387:	b8 14 00 00 00       	mov    $0x14,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <chdir>:
SYSCALL(chdir)
 38f:	b8 09 00 00 00       	mov    $0x9,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <dup>:
SYSCALL(dup)
 397:	b8 0a 00 00 00       	mov    $0xa,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <getpid>:
SYSCALL(getpid)
 39f:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <sbrk>:
SYSCALL(sbrk)
 3a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <sleep>:
SYSCALL(sleep)
 3af:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <uptime>:
SYSCALL(uptime)
 3b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <halt>:
SYSCALL(halt)
 3bf:	b8 16 00 00 00       	mov    $0x16,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <date>:
SYSCALL(date)
 3c7:	b8 17 00 00 00       	mov    $0x17,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <getuid>:
SYSCALL(getuid)
 3cf:	b8 18 00 00 00       	mov    $0x18,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <getgid>:
SYSCALL(getgid)
 3d7:	b8 19 00 00 00       	mov    $0x19,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <getppid>:
SYSCALL(getppid)
 3df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <setuid>:
SYSCALL(setuid)
 3e7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <setgid>:
SYSCALL(setgid)
 3ef:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <getprocs>:
SYSCALL(getprocs)
 3f7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	83 ec 18             	sub    $0x18,%esp
 405:	8b 45 0c             	mov    0xc(%ebp),%eax
 408:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40b:	83 ec 04             	sub    $0x4,%esp
 40e:	6a 01                	push   $0x1
 410:	8d 45 f4             	lea    -0xc(%ebp),%eax
 413:	50                   	push   %eax
 414:	ff 75 08             	pushl  0x8(%ebp)
 417:	e8 23 ff ff ff       	call   33f <write>
 41c:	83 c4 10             	add    $0x10,%esp
}
 41f:	90                   	nop
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	53                   	push   %ebx
 426:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 429:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 430:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 434:	74 17                	je     44d <printint+0x2b>
 436:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43a:	79 11                	jns    44d <printint+0x2b>
    neg = 1;
 43c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 443:	8b 45 0c             	mov    0xc(%ebp),%eax
 446:	f7 d8                	neg    %eax
 448:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44b:	eb 06                	jmp    453 <printint+0x31>
  } else {
    x = xx;
 44d:	8b 45 0c             	mov    0xc(%ebp),%eax
 450:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45d:	8d 41 01             	lea    0x1(%ecx),%eax
 460:	89 45 f4             	mov    %eax,-0xc(%ebp)
 463:	8b 5d 10             	mov    0x10(%ebp),%ebx
 466:	8b 45 ec             	mov    -0x14(%ebp),%eax
 469:	ba 00 00 00 00       	mov    $0x0,%edx
 46e:	f7 f3                	div    %ebx
 470:	89 d0                	mov    %edx,%eax
 472:	0f b6 80 38 0b 00 00 	movzbl 0xb38(%eax),%eax
 479:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 480:	8b 45 ec             	mov    -0x14(%ebp),%eax
 483:	ba 00 00 00 00       	mov    $0x0,%edx
 488:	f7 f3                	div    %ebx
 48a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 491:	75 c7                	jne    45a <printint+0x38>
  if(neg)
 493:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 497:	74 2d                	je     4c6 <printint+0xa4>
    buf[i++] = '-';
 499:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49c:	8d 50 01             	lea    0x1(%eax),%edx
 49f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a7:	eb 1d                	jmp    4c6 <printint+0xa4>
    putc(fd, buf[i]);
 4a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	0f b6 00             	movzbl (%eax),%eax
 4b4:	0f be c0             	movsbl %al,%eax
 4b7:	83 ec 08             	sub    $0x8,%esp
 4ba:	50                   	push   %eax
 4bb:	ff 75 08             	pushl  0x8(%ebp)
 4be:	e8 3c ff ff ff       	call   3ff <putc>
 4c3:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ce:	79 d9                	jns    4a9 <printint+0x87>
    putc(fd, buf[i]);
}
 4d0:	90                   	nop
 4d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d4:	c9                   	leave  
 4d5:	c3                   	ret    

000004d6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d6:	55                   	push   %ebp
 4d7:	89 e5                	mov    %esp,%ebp
 4d9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e3:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e6:	83 c0 04             	add    $0x4,%eax
 4e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f3:	e9 59 01 00 00       	jmp    651 <printf+0x17b>
    c = fmt[i] & 0xff;
 4f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fe:	01 d0                	add    %edx,%eax
 500:	0f b6 00             	movzbl (%eax),%eax
 503:	0f be c0             	movsbl %al,%eax
 506:	25 ff 00 00 00       	and    $0xff,%eax
 50b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 512:	75 2c                	jne    540 <printf+0x6a>
      if(c == '%'){
 514:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 518:	75 0c                	jne    526 <printf+0x50>
        state = '%';
 51a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 521:	e9 27 01 00 00       	jmp    64d <printf+0x177>
      } else {
        putc(fd, c);
 526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 529:	0f be c0             	movsbl %al,%eax
 52c:	83 ec 08             	sub    $0x8,%esp
 52f:	50                   	push   %eax
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 c7 fe ff ff       	call   3ff <putc>
 538:	83 c4 10             	add    $0x10,%esp
 53b:	e9 0d 01 00 00       	jmp    64d <printf+0x177>
      }
    } else if(state == '%'){
 540:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 544:	0f 85 03 01 00 00    	jne    64d <printf+0x177>
      if(c == 'd'){
 54a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54e:	75 1e                	jne    56e <printf+0x98>
        printint(fd, *ap, 10, 1);
 550:	8b 45 e8             	mov    -0x18(%ebp),%eax
 553:	8b 00                	mov    (%eax),%eax
 555:	6a 01                	push   $0x1
 557:	6a 0a                	push   $0xa
 559:	50                   	push   %eax
 55a:	ff 75 08             	pushl  0x8(%ebp)
 55d:	e8 c0 fe ff ff       	call   422 <printint>
 562:	83 c4 10             	add    $0x10,%esp
        ap++;
 565:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 569:	e9 d8 00 00 00       	jmp    646 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 56e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 572:	74 06                	je     57a <printf+0xa4>
 574:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 578:	75 1e                	jne    598 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 57a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57d:	8b 00                	mov    (%eax),%eax
 57f:	6a 00                	push   $0x0
 581:	6a 10                	push   $0x10
 583:	50                   	push   %eax
 584:	ff 75 08             	pushl  0x8(%ebp)
 587:	e8 96 fe ff ff       	call   422 <printint>
 58c:	83 c4 10             	add    $0x10,%esp
        ap++;
 58f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 593:	e9 ae 00 00 00       	jmp    646 <printf+0x170>
      } else if(c == 's'){
 598:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59c:	75 43                	jne    5e1 <printf+0x10b>
        s = (char*)*ap;
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ae:	75 25                	jne    5d5 <printf+0xff>
          s = "(null)";
 5b0:	c7 45 f4 af 08 00 00 	movl   $0x8af,-0xc(%ebp)
        while(*s != 0){
 5b7:	eb 1c                	jmp    5d5 <printf+0xff>
          putc(fd, *s);
 5b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bc:	0f b6 00             	movzbl (%eax),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	83 ec 08             	sub    $0x8,%esp
 5c5:	50                   	push   %eax
 5c6:	ff 75 08             	pushl  0x8(%ebp)
 5c9:	e8 31 fe ff ff       	call   3ff <putc>
 5ce:	83 c4 10             	add    $0x10,%esp
          s++;
 5d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d8:	0f b6 00             	movzbl (%eax),%eax
 5db:	84 c0                	test   %al,%al
 5dd:	75 da                	jne    5b9 <printf+0xe3>
 5df:	eb 65                	jmp    646 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e5:	75 1d                	jne    604 <printf+0x12e>
        putc(fd, *ap);
 5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 04 fe ff ff       	call   3ff <putc>
 5fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	eb 42                	jmp    646 <printf+0x170>
      } else if(c == '%'){
 604:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 608:	75 17                	jne    621 <printf+0x14b>
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	83 ec 08             	sub    $0x8,%esp
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 e3 fd ff ff       	call   3ff <putc>
 61c:	83 c4 10             	add    $0x10,%esp
 61f:	eb 25                	jmp    646 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 621:	83 ec 08             	sub    $0x8,%esp
 624:	6a 25                	push   $0x25
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 d1 fd ff ff       	call   3ff <putc>
 62e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 634:	0f be c0             	movsbl %al,%eax
 637:	83 ec 08             	sub    $0x8,%esp
 63a:	50                   	push   %eax
 63b:	ff 75 08             	pushl  0x8(%ebp)
 63e:	e8 bc fd ff ff       	call   3ff <putc>
 643:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 646:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 651:	8b 55 0c             	mov    0xc(%ebp),%edx
 654:	8b 45 f0             	mov    -0x10(%ebp),%eax
 657:	01 d0                	add    %edx,%eax
 659:	0f b6 00             	movzbl (%eax),%eax
 65c:	84 c0                	test   %al,%al
 65e:	0f 85 94 fe ff ff    	jne    4f8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 664:	90                   	nop
 665:	c9                   	leave  
 666:	c3                   	ret    

00000667 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	83 e8 08             	sub    $0x8,%eax
 673:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	a1 54 0b 00 00       	mov    0xb54,%eax
 67b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67e:	eb 24                	jmp    6a4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 688:	77 12                	ja     69c <free+0x35>
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 690:	77 24                	ja     6b6 <free+0x4f>
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69a:	77 1a                	ja     6b6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6aa:	76 d4                	jbe    680 <free+0x19>
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b4:	76 ca                	jbe    680 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	8b 40 04             	mov    0x4(%eax),%eax
 6bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	01 c2                	add    %eax,%edx
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	39 c2                	cmp    %eax,%edx
 6cf:	75 24                	jne    6f5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 50 04             	mov    0x4(%eax),%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	8b 40 04             	mov    0x4(%eax),%eax
 6df:	01 c2                	add    %eax,%edx
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	8b 10                	mov    (%eax),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	89 10                	mov    %edx,(%eax)
 6f3:	eb 0a                	jmp    6ff <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 10                	mov    (%eax),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	01 d0                	add    %edx,%eax
 711:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 714:	75 20                	jne    736 <free+0xcf>
    p->s.size += bp->s.size;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 50 04             	mov    0x4(%eax),%edx
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	01 c2                	add    %eax,%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
 734:	eb 08                	jmp    73e <free+0xd7>
  } else
    p->s.ptr = bp;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73c:	89 10                	mov    %edx,(%eax)
  freep = p;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	a3 54 0b 00 00       	mov    %eax,0xb54
}
 746:	90                   	nop
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <morecore>:

static Header*
morecore(uint nu)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 756:	77 07                	ja     75f <morecore+0x16>
    nu = 4096;
 758:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	c1 e0 03             	shl    $0x3,%eax
 765:	83 ec 0c             	sub    $0xc,%esp
 768:	50                   	push   %eax
 769:	e8 39 fc ff ff       	call   3a7 <sbrk>
 76e:	83 c4 10             	add    $0x10,%esp
 771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 774:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 778:	75 07                	jne    781 <morecore+0x38>
    return 0;
 77a:	b8 00 00 00 00       	mov    $0x0,%eax
 77f:	eb 26                	jmp    7a7 <morecore+0x5e>
  hp = (Header*)p;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	8b 55 08             	mov    0x8(%ebp),%edx
 78d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	83 c0 08             	add    $0x8,%eax
 796:	83 ec 0c             	sub    $0xc,%esp
 799:	50                   	push   %eax
 79a:	e8 c8 fe ff ff       	call   667 <free>
 79f:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a2:	a1 54 0b 00 00       	mov    0xb54,%eax
}
 7a7:	c9                   	leave  
 7a8:	c3                   	ret    

000007a9 <malloc>:

void*
malloc(uint nbytes)
{
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	83 c0 07             	add    $0x7,%eax
 7b5:	c1 e8 03             	shr    $0x3,%eax
 7b8:	83 c0 01             	add    $0x1,%eax
 7bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7be:	a1 54 0b 00 00       	mov    0xb54,%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ca:	75 23                	jne    7ef <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cc:	c7 45 f0 4c 0b 00 00 	movl   $0xb4c,-0x10(%ebp)
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 54 0b 00 00       	mov    %eax,0xb54
 7db:	a1 54 0b 00 00       	mov    0xb54,%eax
 7e0:	a3 4c 0b 00 00       	mov    %eax,0xb4c
    base.s.size = 0;
 7e5:	c7 05 50 0b 00 00 00 	movl   $0x0,0xb50
 7ec:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 800:	72 4d                	jb     84f <malloc+0xa6>
      if(p->s.size == nunits)
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80b:	75 0c                	jne    819 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 10                	mov    (%eax),%edx
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	89 10                	mov    %edx,(%eax)
 817:	eb 26                	jmp    83f <malloc+0x96>
      else {
        p->s.size -= nunits;
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8b 40 04             	mov    0x4(%eax),%eax
 81f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 822:	89 c2                	mov    %eax,%edx
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	c1 e0 03             	shl    $0x3,%eax
 833:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	a3 54 0b 00 00       	mov    %eax,0xb54
      return (void*)(p + 1);
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	eb 3b                	jmp    88a <malloc+0xe1>
    }
    if(p == freep)
 84f:	a1 54 0b 00 00       	mov    0xb54,%eax
 854:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 857:	75 1e                	jne    877 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 859:	83 ec 0c             	sub    $0xc,%esp
 85c:	ff 75 ec             	pushl  -0x14(%ebp)
 85f:	e8 e5 fe ff ff       	call   749 <morecore>
 864:	83 c4 10             	add    $0x10,%esp
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86e:	75 07                	jne    877 <malloc+0xce>
        return 0;
 870:	b8 00 00 00 00       	mov    $0x0,%eax
 875:	eb 13                	jmp    88a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 885:	e9 6d ff ff ff       	jmp    7f7 <malloc+0x4e>
}
 88a:	c9                   	leave  
 88b:	c3                   	ret    
