
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
  int i;
  for(i = 0; i < 10 && ret != 0; ++i) 
   d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  14:	eb 0c                	jmp    22 <testSched+0x22>
  ret = fork();
  16:	e8 0f 03 00 00       	call   32a <fork>
  1b:	89 45 f4             	mov    %eax,-0xc(%ebp)

void
testSched(){
  int ret = 1;
  int i;
  for(i = 0; i < 10 && ret != 0; ++i) 
  1e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  22:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  26:	7f 06                	jg     2e <testSched+0x2e>
  28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2c:	75 e8                	jne    16 <testSched+0x16>
  ret = fork();

  if(ret == 0){
  2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  32:	75 02                	jne    36 <testSched+0x36>
      //sleep(100000);
    for(;;);
  34:	eb fe                	jmp    34 <testSched+0x34>
  }
  exit();
  36:	e8 f7 02 00 00       	call   332 <exit>

0000003b <testList>:
}
//creates a process
void
testList(){
  3b:	55                   	push   %ebp
  3c:	89 e5                	mov    %esp,%ebp
  3e:	83 ec 18             	sub    $0x18,%esp
  int process = fork();
  41:	e8 e4 02 00 00       	call   32a <fork>
  46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(process == 0)
  49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4d:	75 10                	jne    5f <testList+0x24>
    sleep(50000);
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	68 50 c3 00 00       	push   $0xc350
  57:	e8 66 03 00 00       	call   3c2 <sleep>
  5c:	83 c4 10             	add    $0x10,%esp
  printf(1,"Finished sleeping for 5 seconds \n ");
  5f:	83 ec 08             	sub    $0x8,%esp
  62:	68 a8 08 00 00       	push   $0x8a8
  67:	6a 01                	push   $0x1
  69:	e8 83 04 00 00       	call   4f1 <printf>
  6e:	83 c4 10             	add    $0x10,%esp
  exit();
  71:	e8 bc 02 00 00       	call   332 <exit>

00000076 <main>:
}

int
main(int argc, char *argv[])
{
  76:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  7a:	83 e4 f0             	and    $0xfffffff0,%esp
  7d:	ff 71 fc             	pushl  -0x4(%ecx)
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	51                   	push   %ecx
  84:	83 ec 04             	sub    $0x4,%esp
  testSched();            // test round - robin
  87:	e8 74 ff ff ff       	call   0 <testSched>
  testList();             // test free list
  8c:	e8 aa ff ff ff       	call   3b <testList>
  exit();
  91:	e8 9c 02 00 00       	call   332 <exit>

00000096 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	57                   	push   %edi
  9a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9e:	8b 55 10             	mov    0x10(%ebp),%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	89 cb                	mov    %ecx,%ebx
  a6:	89 df                	mov    %ebx,%edi
  a8:	89 d1                	mov    %edx,%ecx
  aa:	fc                   	cld    
  ab:	f3 aa                	rep stos %al,%es:(%edi)
  ad:	89 ca                	mov    %ecx,%edx
  af:	89 fb                	mov    %edi,%ebx
  b1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b7:	90                   	nop
  b8:	5b                   	pop    %ebx
  b9:	5f                   	pop    %edi
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    

000000bc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c8:	90                   	nop
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	8d 50 01             	lea    0x1(%eax),%edx
  cf:	89 55 08             	mov    %edx,0x8(%ebp)
  d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  d5:	8d 4a 01             	lea    0x1(%edx),%ecx
  d8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  db:	0f b6 12             	movzbl (%edx),%edx
  de:	88 10                	mov    %dl,(%eax)
  e0:	0f b6 00             	movzbl (%eax),%eax
  e3:	84 c0                	test   %al,%al
  e5:	75 e2                	jne    c9 <strcpy+0xd>
    ;
  return os;
  e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ea:	c9                   	leave  
  eb:	c3                   	ret    

000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ef:	eb 08                	jmp    f9 <strcmp+0xd>
    p++, q++;
  f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	84 c0                	test   %al,%al
 101:	74 10                	je     113 <strcmp+0x27>
 103:	8b 45 08             	mov    0x8(%ebp),%eax
 106:	0f b6 10             	movzbl (%eax),%edx
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	38 c2                	cmp    %al,%dl
 111:	74 de                	je     f1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	0f b6 00             	movzbl (%eax),%eax
 119:	0f b6 d0             	movzbl %al,%edx
 11c:	8b 45 0c             	mov    0xc(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	0f b6 c0             	movzbl %al,%eax
 125:	29 c2                	sub    %eax,%edx
 127:	89 d0                	mov    %edx,%eax
}
 129:	5d                   	pop    %ebp
 12a:	c3                   	ret    

0000012b <strlen>:

uint
strlen(char *s)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 138:	eb 04                	jmp    13e <strlen+0x13>
 13a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	01 d0                	add    %edx,%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	84 c0                	test   %al,%al
 14b:	75 ed                	jne    13a <strlen+0xf>
    ;
  return n;
 14d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 150:	c9                   	leave  
 151:	c3                   	ret    

00000152 <memset>:

void*
memset(void *dst, int c, uint n)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 155:	8b 45 10             	mov    0x10(%ebp),%eax
 158:	50                   	push   %eax
 159:	ff 75 0c             	pushl  0xc(%ebp)
 15c:	ff 75 08             	pushl  0x8(%ebp)
 15f:	e8 32 ff ff ff       	call   96 <stosb>
 164:	83 c4 0c             	add    $0xc,%esp
  return dst;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <strchr>:

char*
strchr(const char *s, char c)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	83 ec 04             	sub    $0x4,%esp
 172:	8b 45 0c             	mov    0xc(%ebp),%eax
 175:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 178:	eb 14                	jmp    18e <strchr+0x22>
    if(*s == c)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	3a 45 fc             	cmp    -0x4(%ebp),%al
 183:	75 05                	jne    18a <strchr+0x1e>
      return (char*)s;
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	eb 13                	jmp    19d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 18a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	84 c0                	test   %al,%al
 196:	75 e2                	jne    17a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 198:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19d:	c9                   	leave  
 19e:	c3                   	ret    

0000019f <gets>:

char*
gets(char *buf, int max)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ac:	eb 42                	jmp    1f0 <gets+0x51>
    cc = read(0, &c, 1);
 1ae:	83 ec 04             	sub    $0x4,%esp
 1b1:	6a 01                	push   $0x1
 1b3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b6:	50                   	push   %eax
 1b7:	6a 00                	push   $0x0
 1b9:	e8 8c 01 00 00       	call   34a <read>
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c8:	7e 33                	jle    1fd <gets+0x5e>
      break;
    buf[i++] = c;
 1ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cd:	8d 50 01             	lea    0x1(%eax),%edx
 1d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d3:	89 c2                	mov    %eax,%edx
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	01 c2                	add    %eax,%edx
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e4:	3c 0a                	cmp    $0xa,%al
 1e6:	74 16                	je     1fe <gets+0x5f>
 1e8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ec:	3c 0d                	cmp    $0xd,%al
 1ee:	74 0e                	je     1fe <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f3:	83 c0 01             	add    $0x1,%eax
 1f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f9:	7c b3                	jl     1ae <gets+0xf>
 1fb:	eb 01                	jmp    1fe <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1fd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	01 d0                	add    %edx,%eax
 206:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 209:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <stat>:

int
stat(char *n, struct stat *st)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 214:	83 ec 08             	sub    $0x8,%esp
 217:	6a 00                	push   $0x0
 219:	ff 75 08             	pushl  0x8(%ebp)
 21c:	e8 51 01 00 00       	call   372 <open>
 221:	83 c4 10             	add    $0x10,%esp
 224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 22b:	79 07                	jns    234 <stat+0x26>
    return -1;
 22d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 232:	eb 25                	jmp    259 <stat+0x4b>
  r = fstat(fd, st);
 234:	83 ec 08             	sub    $0x8,%esp
 237:	ff 75 0c             	pushl  0xc(%ebp)
 23a:	ff 75 f4             	pushl  -0xc(%ebp)
 23d:	e8 48 01 00 00       	call   38a <fstat>
 242:	83 c4 10             	add    $0x10,%esp
 245:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 248:	83 ec 0c             	sub    $0xc,%esp
 24b:	ff 75 f4             	pushl  -0xc(%ebp)
 24e:	e8 07 01 00 00       	call   35a <close>
 253:	83 c4 10             	add    $0x10,%esp
  return r;
 256:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <atoi>:

int
atoi(const char *s)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 261:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 268:	eb 04                	jmp    26e <atoi+0x13>
 26a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	3c 20                	cmp    $0x20,%al
 276:	74 f2                	je     26a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	3c 2d                	cmp    $0x2d,%al
 280:	75 07                	jne    289 <atoi+0x2e>
 282:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 287:	eb 05                	jmp    28e <atoi+0x33>
 289:	b8 01 00 00 00       	mov    $0x1,%eax
 28e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 2b                	cmp    $0x2b,%al
 299:	74 0a                	je     2a5 <atoi+0x4a>
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	3c 2d                	cmp    $0x2d,%al
 2a3:	75 2b                	jne    2d0 <atoi+0x75>
    s++;
 2a5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2a9:	eb 25                	jmp    2d0 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ae:	89 d0                	mov    %edx,%eax
 2b0:	c1 e0 02             	shl    $0x2,%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	01 c0                	add    %eax,%eax
 2b7:	89 c1                	mov    %eax,%ecx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	8d 50 01             	lea    0x1(%eax),%edx
 2bf:	89 55 08             	mov    %edx,0x8(%ebp)
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	0f be c0             	movsbl %al,%eax
 2c8:	01 c8                	add    %ecx,%eax
 2ca:	83 e8 30             	sub    $0x30,%eax
 2cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 00             	movzbl (%eax),%eax
 2d6:	3c 2f                	cmp    $0x2f,%al
 2d8:	7e 0a                	jle    2e4 <atoi+0x89>
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 00             	movzbl (%eax),%eax
 2e0:	3c 39                	cmp    $0x39,%al
 2e2:	7e c7                	jle    2ab <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ff:	eb 17                	jmp    318 <memmove+0x2b>
    *dst++ = *src++;
 301:	8b 45 fc             	mov    -0x4(%ebp),%eax
 304:	8d 50 01             	lea    0x1(%eax),%edx
 307:	89 55 fc             	mov    %edx,-0x4(%ebp)
 30a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30d:	8d 4a 01             	lea    0x1(%edx),%ecx
 310:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 313:	0f b6 12             	movzbl (%edx),%edx
 316:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	8d 50 ff             	lea    -0x1(%eax),%edx
 31e:	89 55 10             	mov    %edx,0x10(%ebp)
 321:	85 c0                	test   %eax,%eax
 323:	7f dc                	jg     301 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 325:	8b 45 08             	mov    0x8(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 32a:	b8 01 00 00 00       	mov    $0x1,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <exit>:
SYSCALL(exit)
 332:	b8 02 00 00 00       	mov    $0x2,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <wait>:
SYSCALL(wait)
 33a:	b8 03 00 00 00       	mov    $0x3,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <pipe>:
SYSCALL(pipe)
 342:	b8 04 00 00 00       	mov    $0x4,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <read>:
SYSCALL(read)
 34a:	b8 05 00 00 00       	mov    $0x5,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <write>:
SYSCALL(write)
 352:	b8 10 00 00 00       	mov    $0x10,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <close>:
SYSCALL(close)
 35a:	b8 15 00 00 00       	mov    $0x15,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <kill>:
SYSCALL(kill)
 362:	b8 06 00 00 00       	mov    $0x6,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <exec>:
SYSCALL(exec)
 36a:	b8 07 00 00 00       	mov    $0x7,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <open>:
SYSCALL(open)
 372:	b8 0f 00 00 00       	mov    $0xf,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mknod>:
SYSCALL(mknod)
 37a:	b8 11 00 00 00       	mov    $0x11,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <unlink>:
SYSCALL(unlink)
 382:	b8 12 00 00 00       	mov    $0x12,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <fstat>:
SYSCALL(fstat)
 38a:	b8 08 00 00 00       	mov    $0x8,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <link>:
SYSCALL(link)
 392:	b8 13 00 00 00       	mov    $0x13,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mkdir>:
SYSCALL(mkdir)
 39a:	b8 14 00 00 00       	mov    $0x14,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <chdir>:
SYSCALL(chdir)
 3a2:	b8 09 00 00 00       	mov    $0x9,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <dup>:
SYSCALL(dup)
 3aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <getpid>:
SYSCALL(getpid)
 3b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <sbrk>:
SYSCALL(sbrk)
 3ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <sleep>:
SYSCALL(sleep)
 3c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <uptime>:
SYSCALL(uptime)
 3ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <halt>:
SYSCALL(halt)
 3d2:	b8 16 00 00 00       	mov    $0x16,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <date>:
SYSCALL(date)
 3da:	b8 17 00 00 00       	mov    $0x17,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <getuid>:
SYSCALL(getuid)
 3e2:	b8 18 00 00 00       	mov    $0x18,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <getgid>:
SYSCALL(getgid)
 3ea:	b8 19 00 00 00       	mov    $0x19,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getppid>:
SYSCALL(getppid)
 3f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <setuid>:
SYSCALL(setuid)
 3fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <setgid>:
SYSCALL(setgid)
 402:	b8 1c 00 00 00       	mov    $0x1c,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <getprocs>:
SYSCALL(getprocs)
 40a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <setpriority>:
SYSCALL(setpriority)
 412:	b8 1e 00 00 00       	mov    $0x1e,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 41a:	55                   	push   %ebp
 41b:	89 e5                	mov    %esp,%ebp
 41d:	83 ec 18             	sub    $0x18,%esp
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 426:	83 ec 04             	sub    $0x4,%esp
 429:	6a 01                	push   $0x1
 42b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42e:	50                   	push   %eax
 42f:	ff 75 08             	pushl  0x8(%ebp)
 432:	e8 1b ff ff ff       	call   352 <write>
 437:	83 c4 10             	add    $0x10,%esp
}
 43a:	90                   	nop
 43b:	c9                   	leave  
 43c:	c3                   	ret    

0000043d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43d:	55                   	push   %ebp
 43e:	89 e5                	mov    %esp,%ebp
 440:	53                   	push   %ebx
 441:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 444:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 44f:	74 17                	je     468 <printint+0x2b>
 451:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 455:	79 11                	jns    468 <printint+0x2b>
    neg = 1;
 457:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 45e:	8b 45 0c             	mov    0xc(%ebp),%eax
 461:	f7 d8                	neg    %eax
 463:	89 45 ec             	mov    %eax,-0x14(%ebp)
 466:	eb 06                	jmp    46e <printint+0x31>
  } else {
    x = xx;
 468:	8b 45 0c             	mov    0xc(%ebp),%eax
 46b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 46e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 475:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 478:	8d 41 01             	lea    0x1(%ecx),%eax
 47b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 47e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 481:	8b 45 ec             	mov    -0x14(%ebp),%eax
 484:	ba 00 00 00 00       	mov    $0x0,%edx
 489:	f7 f3                	div    %ebx
 48b:	89 d0                	mov    %edx,%eax
 48d:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 494:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 498:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49e:	ba 00 00 00 00       	mov    $0x0,%edx
 4a3:	f7 f3                	div    %ebx
 4a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ac:	75 c7                	jne    475 <printint+0x38>
  if(neg)
 4ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b2:	74 2d                	je     4e1 <printint+0xa4>
    buf[i++] = '-';
 4b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b7:	8d 50 01             	lea    0x1(%eax),%edx
 4ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4bd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c2:	eb 1d                	jmp    4e1 <printint+0xa4>
    putc(fd, buf[i]);
 4c4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ca:	01 d0                	add    %edx,%eax
 4cc:	0f b6 00             	movzbl (%eax),%eax
 4cf:	0f be c0             	movsbl %al,%eax
 4d2:	83 ec 08             	sub    $0x8,%esp
 4d5:	50                   	push   %eax
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 3c ff ff ff       	call   41a <putc>
 4de:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e9:	79 d9                	jns    4c4 <printint+0x87>
    putc(fd, buf[i]);
}
 4eb:	90                   	nop
 4ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ef:	c9                   	leave  
 4f0:	c3                   	ret    

000004f1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f1:	55                   	push   %ebp
 4f2:	89 e5                	mov    %esp,%ebp
 4f4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4fe:	8d 45 0c             	lea    0xc(%ebp),%eax
 501:	83 c0 04             	add    $0x4,%eax
 504:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 507:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 50e:	e9 59 01 00 00       	jmp    66c <printf+0x17b>
    c = fmt[i] & 0xff;
 513:	8b 55 0c             	mov    0xc(%ebp),%edx
 516:	8b 45 f0             	mov    -0x10(%ebp),%eax
 519:	01 d0                	add    %edx,%eax
 51b:	0f b6 00             	movzbl (%eax),%eax
 51e:	0f be c0             	movsbl %al,%eax
 521:	25 ff 00 00 00       	and    $0xff,%eax
 526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 529:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52d:	75 2c                	jne    55b <printf+0x6a>
      if(c == '%'){
 52f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 533:	75 0c                	jne    541 <printf+0x50>
        state = '%';
 535:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 53c:	e9 27 01 00 00       	jmp    668 <printf+0x177>
      } else {
        putc(fd, c);
 541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 544:	0f be c0             	movsbl %al,%eax
 547:	83 ec 08             	sub    $0x8,%esp
 54a:	50                   	push   %eax
 54b:	ff 75 08             	pushl  0x8(%ebp)
 54e:	e8 c7 fe ff ff       	call   41a <putc>
 553:	83 c4 10             	add    $0x10,%esp
 556:	e9 0d 01 00 00       	jmp    668 <printf+0x177>
      }
    } else if(state == '%'){
 55b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 55f:	0f 85 03 01 00 00    	jne    668 <printf+0x177>
      if(c == 'd'){
 565:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 569:	75 1e                	jne    589 <printf+0x98>
        printint(fd, *ap, 10, 1);
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	6a 01                	push   $0x1
 572:	6a 0a                	push   $0xa
 574:	50                   	push   %eax
 575:	ff 75 08             	pushl  0x8(%ebp)
 578:	e8 c0 fe ff ff       	call   43d <printint>
 57d:	83 c4 10             	add    $0x10,%esp
        ap++;
 580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 584:	e9 d8 00 00 00       	jmp    661 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 589:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58d:	74 06                	je     595 <printf+0xa4>
 58f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 593:	75 1e                	jne    5b3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 595:	8b 45 e8             	mov    -0x18(%ebp),%eax
 598:	8b 00                	mov    (%eax),%eax
 59a:	6a 00                	push   $0x0
 59c:	6a 10                	push   $0x10
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 96 fe ff ff       	call   43d <printint>
 5a7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ae:	e9 ae 00 00 00       	jmp    661 <printf+0x170>
      } else if(c == 's'){
 5b3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5b7:	75 43                	jne    5fc <printf+0x10b>
        s = (char*)*ap;
 5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bc:	8b 00                	mov    (%eax),%eax
 5be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c9:	75 25                	jne    5f0 <printf+0xff>
          s = "(null)";
 5cb:	c7 45 f4 cb 08 00 00 	movl   $0x8cb,-0xc(%ebp)
        while(*s != 0){
 5d2:	eb 1c                	jmp    5f0 <printf+0xff>
          putc(fd, *s);
 5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d7:	0f b6 00             	movzbl (%eax),%eax
 5da:	0f be c0             	movsbl %al,%eax
 5dd:	83 ec 08             	sub    $0x8,%esp
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 31 fe ff ff       	call   41a <putc>
 5e9:	83 c4 10             	add    $0x10,%esp
          s++;
 5ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f3:	0f b6 00             	movzbl (%eax),%eax
 5f6:	84 c0                	test   %al,%al
 5f8:	75 da                	jne    5d4 <printf+0xe3>
 5fa:	eb 65                	jmp    661 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 600:	75 1d                	jne    61f <printf+0x12e>
        putc(fd, *ap);
 602:	8b 45 e8             	mov    -0x18(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	0f be c0             	movsbl %al,%eax
 60a:	83 ec 08             	sub    $0x8,%esp
 60d:	50                   	push   %eax
 60e:	ff 75 08             	pushl  0x8(%ebp)
 611:	e8 04 fe ff ff       	call   41a <putc>
 616:	83 c4 10             	add    $0x10,%esp
        ap++;
 619:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61d:	eb 42                	jmp    661 <printf+0x170>
      } else if(c == '%'){
 61f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 623:	75 17                	jne    63c <printf+0x14b>
        putc(fd, c);
 625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	83 ec 08             	sub    $0x8,%esp
 62e:	50                   	push   %eax
 62f:	ff 75 08             	pushl  0x8(%ebp)
 632:	e8 e3 fd ff ff       	call   41a <putc>
 637:	83 c4 10             	add    $0x10,%esp
 63a:	eb 25                	jmp    661 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63c:	83 ec 08             	sub    $0x8,%esp
 63f:	6a 25                	push   $0x25
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 d1 fd ff ff       	call   41a <putc>
 649:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 64c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	83 ec 08             	sub    $0x8,%esp
 655:	50                   	push   %eax
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 bc fd ff ff       	call   41a <putc>
 65e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 661:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 668:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 66c:	8b 55 0c             	mov    0xc(%ebp),%edx
 66f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 672:	01 d0                	add    %edx,%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	84 c0                	test   %al,%al
 679:	0f 85 94 fe ff ff    	jne    513 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 67f:	90                   	nop
 680:	c9                   	leave  
 681:	c3                   	ret    

00000682 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 682:	55                   	push   %ebp
 683:	89 e5                	mov    %esp,%ebp
 685:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 688:	8b 45 08             	mov    0x8(%ebp),%eax
 68b:	83 e8 08             	sub    $0x8,%eax
 68e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	a1 70 0b 00 00       	mov    0xb70,%eax
 696:	89 45 fc             	mov    %eax,-0x4(%ebp)
 699:	eb 24                	jmp    6bf <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a3:	77 12                	ja     6b7 <free+0x35>
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ab:	77 24                	ja     6d1 <free+0x4f>
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b5:	77 1a                	ja     6d1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c5:	76 d4                	jbe    69b <free+0x19>
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cf:	76 ca                	jbe    69b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	01 c2                	add    %eax,%edx
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	39 c2                	cmp    %eax,%edx
 6ea:	75 24                	jne    710 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	8b 40 04             	mov    0x4(%eax),%eax
 6fa:	01 c2                	add    %eax,%edx
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	8b 10                	mov    (%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	89 10                	mov    %edx,(%eax)
 70e:	eb 0a                	jmp    71a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 10                	mov    (%eax),%edx
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 727:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72a:	01 d0                	add    %edx,%eax
 72c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72f:	75 20                	jne    751 <free+0xcf>
    p->s.size += bp->s.size;
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 50 04             	mov    0x4(%eax),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	01 c2                	add    %eax,%edx
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	8b 10                	mov    (%eax),%edx
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	89 10                	mov    %edx,(%eax)
 74f:	eb 08                	jmp    759 <free+0xd7>
  } else
    p->s.ptr = bp;
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 55 f8             	mov    -0x8(%ebp),%edx
 757:	89 10                	mov    %edx,(%eax)
  freep = p;
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 761:	90                   	nop
 762:	c9                   	leave  
 763:	c3                   	ret    

00000764 <morecore>:

static Header*
morecore(uint nu)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 771:	77 07                	ja     77a <morecore+0x16>
    nu = 4096;
 773:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77a:	8b 45 08             	mov    0x8(%ebp),%eax
 77d:	c1 e0 03             	shl    $0x3,%eax
 780:	83 ec 0c             	sub    $0xc,%esp
 783:	50                   	push   %eax
 784:	e8 31 fc ff ff       	call   3ba <sbrk>
 789:	83 c4 10             	add    $0x10,%esp
 78c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 78f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 793:	75 07                	jne    79c <morecore+0x38>
    return 0;
 795:	b8 00 00 00 00       	mov    $0x0,%eax
 79a:	eb 26                	jmp    7c2 <morecore+0x5e>
  hp = (Header*)p;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	8b 55 08             	mov    0x8(%ebp),%edx
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	83 c0 08             	add    $0x8,%eax
 7b1:	83 ec 0c             	sub    $0xc,%esp
 7b4:	50                   	push   %eax
 7b5:	e8 c8 fe ff ff       	call   682 <free>
 7ba:	83 c4 10             	add    $0x10,%esp
  return freep;
 7bd:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7c2:	c9                   	leave  
 7c3:	c3                   	ret    

000007c4 <malloc>:

void*
malloc(uint nbytes)
{
 7c4:	55                   	push   %ebp
 7c5:	89 e5                	mov    %esp,%ebp
 7c7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ca:	8b 45 08             	mov    0x8(%ebp),%eax
 7cd:	83 c0 07             	add    $0x7,%eax
 7d0:	c1 e8 03             	shr    $0x3,%eax
 7d3:	83 c0 01             	add    $0x1,%eax
 7d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7d9:	a1 70 0b 00 00       	mov    0xb70,%eax
 7de:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e5:	75 23                	jne    80a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e7:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	a3 70 0b 00 00       	mov    %eax,0xb70
 7f6:	a1 70 0b 00 00       	mov    0xb70,%eax
 7fb:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 800:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 807:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	8b 40 04             	mov    0x4(%eax),%eax
 818:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 81b:	72 4d                	jb     86a <malloc+0xa6>
      if(p->s.size == nunits)
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 40 04             	mov    0x4(%eax),%eax
 823:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 826:	75 0c                	jne    834 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 10                	mov    (%eax),%edx
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	89 10                	mov    %edx,(%eax)
 832:	eb 26                	jmp    85a <malloc+0x96>
      else {
        p->s.size -= nunits;
 834:	8b 45 f4             	mov    -0xc(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 83d:	89 c2                	mov    %eax,%edx
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 40 04             	mov    0x4(%eax),%eax
 84b:	c1 e0 03             	shl    $0x3,%eax
 84e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	8b 55 ec             	mov    -0x14(%ebp),%edx
 857:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	83 c0 08             	add    $0x8,%eax
 868:	eb 3b                	jmp    8a5 <malloc+0xe1>
    }
    if(p == freep)
 86a:	a1 70 0b 00 00       	mov    0xb70,%eax
 86f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 872:	75 1e                	jne    892 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 874:	83 ec 0c             	sub    $0xc,%esp
 877:	ff 75 ec             	pushl  -0x14(%ebp)
 87a:	e8 e5 fe ff ff       	call   764 <morecore>
 87f:	83 c4 10             	add    $0x10,%esp
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
 885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 889:	75 07                	jne    892 <malloc+0xce>
        return 0;
 88b:	b8 00 00 00 00       	mov    $0x0,%eax
 890:	eb 13                	jmp    8a5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	89 45 f0             	mov    %eax,-0x10(%ebp)
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8a0:	e9 6d ff ff ff       	jmp    812 <malloc+0x4e>
}
 8a5:	c9                   	leave  
 8a6:	c3                   	ret    
