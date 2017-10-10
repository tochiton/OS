
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P2
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
	// ++argv;
	int time_start = uptime();
  14:	e8 cf 03 00 00       	call   3e8 <uptime>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int pid = fork();
  1c:	e8 27 03 00 00       	call   348 <fork>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if(pid < 0){
  24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  28:	79 17                	jns    41 <main+0x41>
		printf(2, "time failed: invalid pid\n");
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	68 bd 08 00 00       	push   $0x8bd
  32:	6a 02                	push   $0x2
  34:	e8 ce 04 00 00       	call   507 <printf>
  39:	83 c4 10             	add    $0x10,%esp
		exit();	
  3c:	e8 0f 03 00 00       	call   350 <exit>
	}

	if(pid == 0){
  41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  45:	75 3d                	jne    84 <main+0x84>
		if(argc == 1)
  47:	83 3b 01             	cmpl   $0x1,(%ebx)
  4a:	75 05                	jne    51 <main+0x51>
			exit(); 
  4c:	e8 ff 02 00 00       	call   350 <exit>
		++argv; 
  51:	83 43 04 04          	addl   $0x4,0x4(%ebx)
		if(exec(argv[0], argv)){
  55:	8b 43 04             	mov    0x4(%ebx),%eax
  58:	8b 00                	mov    (%eax),%eax
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	ff 73 04             	pushl  0x4(%ebx)
  60:	50                   	push   %eax
  61:	e8 22 03 00 00       	call   388 <exec>
  66:	83 c4 10             	add    $0x10,%esp
  69:	85 c0                	test   %eax,%eax
  6b:	74 17                	je     84 <main+0x84>
			printf(2, "time failed: exec failed\n");
  6d:	83 ec 08             	sub    $0x8,%esp
  70:	68 d7 08 00 00       	push   $0x8d7
  75:	6a 02                	push   $0x2
  77:	e8 8b 04 00 00       	call   507 <printf>
  7c:	83 c4 10             	add    $0x10,%esp
			exit();	
  7f:	e8 cc 02 00 00       	call   350 <exit>
		}  
	}
	wait();
  84:	e8 cf 02 00 00       	call   358 <wait>
	int time_end = uptime();
  89:	e8 5a 03 00 00       	call   3e8 <uptime>
  8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int total_time = time_end - time_start;
  91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  94:	2b 45 f4             	sub    -0xc(%ebp),%eax
  97:	89 45 e8             	mov    %eax,-0x18(%ebp)
	printf(1, "%d\n",total_time);
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	ff 75 e8             	pushl  -0x18(%ebp)
  a0:	68 f1 08 00 00       	push   $0x8f1
  a5:	6a 01                	push   $0x1
  a7:	e8 5b 04 00 00       	call   507 <printf>
  ac:	83 c4 10             	add    $0x10,%esp
	exit();
  af:	e8 9c 02 00 00       	call   350 <exit>

000000b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	57                   	push   %edi
  b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bc:	8b 55 10             	mov    0x10(%ebp),%edx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	89 cb                	mov    %ecx,%ebx
  c4:	89 df                	mov    %ebx,%edi
  c6:	89 d1                	mov    %edx,%ecx
  c8:	fc                   	cld    
  c9:	f3 aa                	rep stos %al,%es:(%edi)
  cb:	89 ca                	mov    %ecx,%edx
  cd:	89 fb                	mov    %edi,%ebx
  cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d5:	90                   	nop
  d6:	5b                   	pop    %ebx
  d7:	5f                   	pop    %edi
  d8:	5d                   	pop    %ebp
  d9:	c3                   	ret    

000000da <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e6:	90                   	nop
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	8d 50 01             	lea    0x1(%eax),%edx
  ed:	89 55 08             	mov    %edx,0x8(%ebp)
  f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  f6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  f9:	0f b6 12             	movzbl (%edx),%edx
  fc:	88 10                	mov    %dl,(%eax)
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	84 c0                	test   %al,%al
 103:	75 e2                	jne    e7 <strcpy+0xd>
    ;
  return os;
 105:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 108:	c9                   	leave  
 109:	c3                   	ret    

0000010a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 10d:	eb 08                	jmp    117 <strcmp+0xd>
    p++, q++;
 10f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 113:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	84 c0                	test   %al,%al
 11f:	74 10                	je     131 <strcmp+0x27>
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	0f b6 10             	movzbl (%eax),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	38 c2                	cmp    %al,%dl
 12f:	74 de                	je     10f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 00             	movzbl (%eax),%eax
 137:	0f b6 d0             	movzbl %al,%edx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	0f b6 c0             	movzbl %al,%eax
 143:	29 c2                	sub    %eax,%edx
 145:	89 d0                	mov    %edx,%eax
}
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    

00000149 <strlen>:

uint
strlen(char *s)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 156:	eb 04                	jmp    15c <strlen+0x13>
 158:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 15c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	01 d0                	add    %edx,%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	75 ed                	jne    158 <strlen+0xf>
    ;
  return n;
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 173:	8b 45 10             	mov    0x10(%ebp),%eax
 176:	50                   	push   %eax
 177:	ff 75 0c             	pushl  0xc(%ebp)
 17a:	ff 75 08             	pushl  0x8(%ebp)
 17d:	e8 32 ff ff ff       	call   b4 <stosb>
 182:	83 c4 0c             	add    $0xc,%esp
  return dst;
 185:	8b 45 08             	mov    0x8(%ebp),%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 04             	sub    $0x4,%esp
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 196:	eb 14                	jmp    1ac <strchr+0x22>
    if(*s == c)
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a1:	75 05                	jne    1a8 <strchr+0x1e>
      return (char*)s;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	eb 13                	jmp    1bb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	84 c0                	test   %al,%al
 1b4:	75 e2                	jne    198 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <gets>:

char*
gets(char *buf, int max)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ca:	eb 42                	jmp    20e <gets+0x51>
    cc = read(0, &c, 1);
 1cc:	83 ec 04             	sub    $0x4,%esp
 1cf:	6a 01                	push   $0x1
 1d1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1d4:	50                   	push   %eax
 1d5:	6a 00                	push   $0x0
 1d7:	e8 8c 01 00 00       	call   368 <read>
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1e6:	7e 33                	jle    21b <gets+0x5e>
      break;
    buf[i++] = c;
 1e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1eb:	8d 50 01             	lea    0x1(%eax),%edx
 1ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f1:	89 c2                	mov    %eax,%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	01 c2                	add    %eax,%edx
 1f8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	3c 0a                	cmp    $0xa,%al
 204:	74 16                	je     21c <gets+0x5f>
 206:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20a:	3c 0d                	cmp    $0xd,%al
 20c:	74 0e                	je     21c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 211:	83 c0 01             	add    $0x1,%eax
 214:	3b 45 0c             	cmp    0xc(%ebp),%eax
 217:	7c b3                	jl     1cc <gets+0xf>
 219:	eb 01                	jmp    21c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 21b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 21c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	01 d0                	add    %edx,%eax
 224:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 227:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <stat>:

int
stat(char *n, struct stat *st)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	83 ec 08             	sub    $0x8,%esp
 235:	6a 00                	push   $0x0
 237:	ff 75 08             	pushl  0x8(%ebp)
 23a:	e8 51 01 00 00       	call   390 <open>
 23f:	83 c4 10             	add    $0x10,%esp
 242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 249:	79 07                	jns    252 <stat+0x26>
    return -1;
 24b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 250:	eb 25                	jmp    277 <stat+0x4b>
  r = fstat(fd, st);
 252:	83 ec 08             	sub    $0x8,%esp
 255:	ff 75 0c             	pushl  0xc(%ebp)
 258:	ff 75 f4             	pushl  -0xc(%ebp)
 25b:	e8 48 01 00 00       	call   3a8 <fstat>
 260:	83 c4 10             	add    $0x10,%esp
 263:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 266:	83 ec 0c             	sub    $0xc,%esp
 269:	ff 75 f4             	pushl  -0xc(%ebp)
 26c:	e8 07 01 00 00       	call   378 <close>
 271:	83 c4 10             	add    $0x10,%esp
  return r;
 274:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <atoi>:

int
atoi(const char *s)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 27f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 286:	eb 04                	jmp    28c <atoi+0x13>
 288:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	0f b6 00             	movzbl (%eax),%eax
 292:	3c 20                	cmp    $0x20,%al
 294:	74 f2                	je     288 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	0f b6 00             	movzbl (%eax),%eax
 29c:	3c 2d                	cmp    $0x2d,%al
 29e:	75 07                	jne    2a7 <atoi+0x2e>
 2a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a5:	eb 05                	jmp    2ac <atoi+0x33>
 2a7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	0f b6 00             	movzbl (%eax),%eax
 2b5:	3c 2b                	cmp    $0x2b,%al
 2b7:	74 0a                	je     2c3 <atoi+0x4a>
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	0f b6 00             	movzbl (%eax),%eax
 2bf:	3c 2d                	cmp    $0x2d,%al
 2c1:	75 2b                	jne    2ee <atoi+0x75>
    s++;
 2c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2c7:	eb 25                	jmp    2ee <atoi+0x75>
    n = n*10 + *s++ - '0';
 2c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cc:	89 d0                	mov    %edx,%eax
 2ce:	c1 e0 02             	shl    $0x2,%eax
 2d1:	01 d0                	add    %edx,%eax
 2d3:	01 c0                	add    %eax,%eax
 2d5:	89 c1                	mov    %eax,%ecx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	8d 50 01             	lea    0x1(%eax),%edx
 2dd:	89 55 08             	mov    %edx,0x8(%ebp)
 2e0:	0f b6 00             	movzbl (%eax),%eax
 2e3:	0f be c0             	movsbl %al,%eax
 2e6:	01 c8                	add    %ecx,%eax
 2e8:	83 e8 30             	sub    $0x30,%eax
 2eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	0f b6 00             	movzbl (%eax),%eax
 2f4:	3c 2f                	cmp    $0x2f,%al
 2f6:	7e 0a                	jle    302 <atoi+0x89>
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	3c 39                	cmp    $0x39,%al
 300:	7e c7                	jle    2c9 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 302:	8b 45 f8             	mov    -0x8(%ebp),%eax
 305:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 309:	c9                   	leave  
 30a:	c3                   	ret    

0000030b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30b:	55                   	push   %ebp
 30c:	89 e5                	mov    %esp,%ebp
 30e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 317:	8b 45 0c             	mov    0xc(%ebp),%eax
 31a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31d:	eb 17                	jmp    336 <memmove+0x2b>
    *dst++ = *src++;
 31f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 fc             	mov    %edx,-0x4(%ebp)
 328:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32b:	8d 4a 01             	lea    0x1(%edx),%ecx
 32e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 331:	0f b6 12             	movzbl (%edx),%edx
 334:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 336:	8b 45 10             	mov    0x10(%ebp),%eax
 339:	8d 50 ff             	lea    -0x1(%eax),%edx
 33c:	89 55 10             	mov    %edx,0x10(%ebp)
 33f:	85 c0                	test   %eax,%eax
 341:	7f dc                	jg     31f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 348:	b8 01 00 00 00       	mov    $0x1,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <exit>:
SYSCALL(exit)
 350:	b8 02 00 00 00       	mov    $0x2,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <wait>:
SYSCALL(wait)
 358:	b8 03 00 00 00       	mov    $0x3,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <pipe>:
SYSCALL(pipe)
 360:	b8 04 00 00 00       	mov    $0x4,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <read>:
SYSCALL(read)
 368:	b8 05 00 00 00       	mov    $0x5,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <write>:
SYSCALL(write)
 370:	b8 10 00 00 00       	mov    $0x10,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <close>:
SYSCALL(close)
 378:	b8 15 00 00 00       	mov    $0x15,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <kill>:
SYSCALL(kill)
 380:	b8 06 00 00 00       	mov    $0x6,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <exec>:
SYSCALL(exec)
 388:	b8 07 00 00 00       	mov    $0x7,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <open>:
SYSCALL(open)
 390:	b8 0f 00 00 00       	mov    $0xf,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <mknod>:
SYSCALL(mknod)
 398:	b8 11 00 00 00       	mov    $0x11,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <unlink>:
SYSCALL(unlink)
 3a0:	b8 12 00 00 00       	mov    $0x12,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <fstat>:
SYSCALL(fstat)
 3a8:	b8 08 00 00 00       	mov    $0x8,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <link>:
SYSCALL(link)
 3b0:	b8 13 00 00 00       	mov    $0x13,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <mkdir>:
SYSCALL(mkdir)
 3b8:	b8 14 00 00 00       	mov    $0x14,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <chdir>:
SYSCALL(chdir)
 3c0:	b8 09 00 00 00       	mov    $0x9,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <dup>:
SYSCALL(dup)
 3c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <getpid>:
SYSCALL(getpid)
 3d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <sbrk>:
SYSCALL(sbrk)
 3d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <sleep>:
SYSCALL(sleep)
 3e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <uptime>:
SYSCALL(uptime)
 3e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <halt>:
SYSCALL(halt)
 3f0:	b8 16 00 00 00       	mov    $0x16,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <date>:
SYSCALL(date)
 3f8:	b8 17 00 00 00       	mov    $0x17,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <getuid>:
SYSCALL(getuid)
 400:	b8 18 00 00 00       	mov    $0x18,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <getgid>:
SYSCALL(getgid)
 408:	b8 19 00 00 00       	mov    $0x19,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <getppid>:
SYSCALL(getppid)
 410:	b8 1a 00 00 00       	mov    $0x1a,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <setuid>:
SYSCALL(setuid)
 418:	b8 1b 00 00 00       	mov    $0x1b,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <setgid>:
SYSCALL(setgid)
 420:	b8 1c 00 00 00       	mov    $0x1c,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <getprocs>:
SYSCALL(getprocs)
 428:	b8 1d 00 00 00       	mov    $0x1d,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 18             	sub    $0x18,%esp
 436:	8b 45 0c             	mov    0xc(%ebp),%eax
 439:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 43c:	83 ec 04             	sub    $0x4,%esp
 43f:	6a 01                	push   $0x1
 441:	8d 45 f4             	lea    -0xc(%ebp),%eax
 444:	50                   	push   %eax
 445:	ff 75 08             	pushl  0x8(%ebp)
 448:	e8 23 ff ff ff       	call   370 <write>
 44d:	83 c4 10             	add    $0x10,%esp
}
 450:	90                   	nop
 451:	c9                   	leave  
 452:	c3                   	ret    

00000453 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 453:	55                   	push   %ebp
 454:	89 e5                	mov    %esp,%ebp
 456:	53                   	push   %ebx
 457:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 461:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 465:	74 17                	je     47e <printint+0x2b>
 467:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 46b:	79 11                	jns    47e <printint+0x2b>
    neg = 1;
 46d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	f7 d8                	neg    %eax
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47c:	eb 06                	jmp    484 <printint+0x31>
  } else {
    x = xx;
 47e:	8b 45 0c             	mov    0xc(%ebp),%eax
 481:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 48b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 48e:	8d 41 01             	lea    0x1(%ecx),%eax
 491:	89 45 f4             	mov    %eax,-0xc(%ebp)
 494:	8b 5d 10             	mov    0x10(%ebp),%ebx
 497:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49a:	ba 00 00 00 00       	mov    $0x0,%edx
 49f:	f7 f3                	div    %ebx
 4a1:	89 d0                	mov    %edx,%eax
 4a3:	0f b6 80 48 0b 00 00 	movzbl 0xb48(%eax),%eax
 4aa:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b4:	ba 00 00 00 00       	mov    $0x0,%edx
 4b9:	f7 f3                	div    %ebx
 4bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c2:	75 c7                	jne    48b <printint+0x38>
  if(neg)
 4c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c8:	74 2d                	je     4f7 <printint+0xa4>
    buf[i++] = '-';
 4ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cd:	8d 50 01             	lea    0x1(%eax),%edx
 4d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d8:	eb 1d                	jmp    4f7 <printint+0xa4>
    putc(fd, buf[i]);
 4da:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e0:	01 d0                	add    %edx,%eax
 4e2:	0f b6 00             	movzbl (%eax),%eax
 4e5:	0f be c0             	movsbl %al,%eax
 4e8:	83 ec 08             	sub    $0x8,%esp
 4eb:	50                   	push   %eax
 4ec:	ff 75 08             	pushl  0x8(%ebp)
 4ef:	e8 3c ff ff ff       	call   430 <putc>
 4f4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ff:	79 d9                	jns    4da <printint+0x87>
    putc(fd, buf[i]);
}
 501:	90                   	nop
 502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 505:	c9                   	leave  
 506:	c3                   	ret    

00000507 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 507:	55                   	push   %ebp
 508:	89 e5                	mov    %esp,%ebp
 50a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 514:	8d 45 0c             	lea    0xc(%ebp),%eax
 517:	83 c0 04             	add    $0x4,%eax
 51a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 524:	e9 59 01 00 00       	jmp    682 <printf+0x17b>
    c = fmt[i] & 0xff;
 529:	8b 55 0c             	mov    0xc(%ebp),%edx
 52c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52f:	01 d0                	add    %edx,%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	0f be c0             	movsbl %al,%eax
 537:	25 ff 00 00 00       	and    $0xff,%eax
 53c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 53f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 543:	75 2c                	jne    571 <printf+0x6a>
      if(c == '%'){
 545:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 549:	75 0c                	jne    557 <printf+0x50>
        state = '%';
 54b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 552:	e9 27 01 00 00       	jmp    67e <printf+0x177>
      } else {
        putc(fd, c);
 557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55a:	0f be c0             	movsbl %al,%eax
 55d:	83 ec 08             	sub    $0x8,%esp
 560:	50                   	push   %eax
 561:	ff 75 08             	pushl  0x8(%ebp)
 564:	e8 c7 fe ff ff       	call   430 <putc>
 569:	83 c4 10             	add    $0x10,%esp
 56c:	e9 0d 01 00 00       	jmp    67e <printf+0x177>
      }
    } else if(state == '%'){
 571:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 575:	0f 85 03 01 00 00    	jne    67e <printf+0x177>
      if(c == 'd'){
 57b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 57f:	75 1e                	jne    59f <printf+0x98>
        printint(fd, *ap, 10, 1);
 581:	8b 45 e8             	mov    -0x18(%ebp),%eax
 584:	8b 00                	mov    (%eax),%eax
 586:	6a 01                	push   $0x1
 588:	6a 0a                	push   $0xa
 58a:	50                   	push   %eax
 58b:	ff 75 08             	pushl  0x8(%ebp)
 58e:	e8 c0 fe ff ff       	call   453 <printint>
 593:	83 c4 10             	add    $0x10,%esp
        ap++;
 596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59a:	e9 d8 00 00 00       	jmp    677 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 59f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a3:	74 06                	je     5ab <printf+0xa4>
 5a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a9:	75 1e                	jne    5c9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	6a 00                	push   $0x0
 5b2:	6a 10                	push   $0x10
 5b4:	50                   	push   %eax
 5b5:	ff 75 08             	pushl  0x8(%ebp)
 5b8:	e8 96 fe ff ff       	call   453 <printint>
 5bd:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c4:	e9 ae 00 00 00       	jmp    677 <printf+0x170>
      } else if(c == 's'){
 5c9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5cd:	75 43                	jne    612 <printf+0x10b>
        s = (char*)*ap;
 5cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d2:	8b 00                	mov    (%eax),%eax
 5d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5df:	75 25                	jne    606 <printf+0xff>
          s = "(null)";
 5e1:	c7 45 f4 f5 08 00 00 	movl   $0x8f5,-0xc(%ebp)
        while(*s != 0){
 5e8:	eb 1c                	jmp    606 <printf+0xff>
          putc(fd, *s);
 5ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ed:	0f b6 00             	movzbl (%eax),%eax
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	83 ec 08             	sub    $0x8,%esp
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 31 fe ff ff       	call   430 <putc>
 5ff:	83 c4 10             	add    $0x10,%esp
          s++;
 602:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 606:	8b 45 f4             	mov    -0xc(%ebp),%eax
 609:	0f b6 00             	movzbl (%eax),%eax
 60c:	84 c0                	test   %al,%al
 60e:	75 da                	jne    5ea <printf+0xe3>
 610:	eb 65                	jmp    677 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 612:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 616:	75 1d                	jne    635 <printf+0x12e>
        putc(fd, *ap);
 618:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61b:	8b 00                	mov    (%eax),%eax
 61d:	0f be c0             	movsbl %al,%eax
 620:	83 ec 08             	sub    $0x8,%esp
 623:	50                   	push   %eax
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 04 fe ff ff       	call   430 <putc>
 62c:	83 c4 10             	add    $0x10,%esp
        ap++;
 62f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 633:	eb 42                	jmp    677 <printf+0x170>
      } else if(c == '%'){
 635:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 639:	75 17                	jne    652 <printf+0x14b>
        putc(fd, c);
 63b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	83 ec 08             	sub    $0x8,%esp
 644:	50                   	push   %eax
 645:	ff 75 08             	pushl  0x8(%ebp)
 648:	e8 e3 fd ff ff       	call   430 <putc>
 64d:	83 c4 10             	add    $0x10,%esp
 650:	eb 25                	jmp    677 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 652:	83 ec 08             	sub    $0x8,%esp
 655:	6a 25                	push   $0x25
 657:	ff 75 08             	pushl  0x8(%ebp)
 65a:	e8 d1 fd ff ff       	call   430 <putc>
 65f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 665:	0f be c0             	movsbl %al,%eax
 668:	83 ec 08             	sub    $0x8,%esp
 66b:	50                   	push   %eax
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 bc fd ff ff       	call   430 <putc>
 674:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 677:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 67e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 682:	8b 55 0c             	mov    0xc(%ebp),%edx
 685:	8b 45 f0             	mov    -0x10(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	0f b6 00             	movzbl (%eax),%eax
 68d:	84 c0                	test   %al,%al
 68f:	0f 85 94 fe ff ff    	jne    529 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 695:	90                   	nop
 696:	c9                   	leave  
 697:	c3                   	ret    

00000698 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	83 e8 08             	sub    $0x8,%eax
 6a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a7:	a1 64 0b 00 00       	mov    0xb64,%eax
 6ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6af:	eb 24                	jmp    6d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 00                	mov    (%eax),%eax
 6b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b9:	77 12                	ja     6cd <free+0x35>
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c1:	77 24                	ja     6e7 <free+0x4f>
 6c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cb:	77 1a                	ja     6e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6db:	76 d4                	jbe    6b1 <free+0x19>
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e5:	76 ca                	jbe    6b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	8b 40 04             	mov    0x4(%eax),%eax
 6ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	01 c2                	add    %eax,%edx
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	39 c2                	cmp    %eax,%edx
 700:	75 24                	jne    726 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	8b 40 04             	mov    0x4(%eax),%eax
 710:	01 c2                	add    %eax,%edx
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	8b 10                	mov    (%eax),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	89 10                	mov    %edx,(%eax)
 724:	eb 0a                	jmp    730 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 10                	mov    (%eax),%edx
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 40 04             	mov    0x4(%eax),%eax
 736:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	01 d0                	add    %edx,%eax
 742:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 745:	75 20                	jne    767 <free+0xcf>
    p->s.size += bp->s.size;
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 50 04             	mov    0x4(%eax),%edx
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	8b 40 04             	mov    0x4(%eax),%eax
 753:	01 c2                	add    %eax,%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	8b 10                	mov    (%eax),%edx
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	89 10                	mov    %edx,(%eax)
 765:	eb 08                	jmp    76f <free+0xd7>
  } else
    p->s.ptr = bp;
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 76d:	89 10                	mov    %edx,(%eax)
  freep = p;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	a3 64 0b 00 00       	mov    %eax,0xb64
}
 777:	90                   	nop
 778:	c9                   	leave  
 779:	c3                   	ret    

0000077a <morecore>:

static Header*
morecore(uint nu)
{
 77a:	55                   	push   %ebp
 77b:	89 e5                	mov    %esp,%ebp
 77d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 780:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 787:	77 07                	ja     790 <morecore+0x16>
    nu = 4096;
 789:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 790:	8b 45 08             	mov    0x8(%ebp),%eax
 793:	c1 e0 03             	shl    $0x3,%eax
 796:	83 ec 0c             	sub    $0xc,%esp
 799:	50                   	push   %eax
 79a:	e8 39 fc ff ff       	call   3d8 <sbrk>
 79f:	83 c4 10             	add    $0x10,%esp
 7a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a9:	75 07                	jne    7b2 <morecore+0x38>
    return 0;
 7ab:	b8 00 00 00 00       	mov    $0x0,%eax
 7b0:	eb 26                	jmp    7d8 <morecore+0x5e>
  hp = (Header*)p;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bb:	8b 55 08             	mov    0x8(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	83 c0 08             	add    $0x8,%eax
 7c7:	83 ec 0c             	sub    $0xc,%esp
 7ca:	50                   	push   %eax
 7cb:	e8 c8 fe ff ff       	call   698 <free>
 7d0:	83 c4 10             	add    $0x10,%esp
  return freep;
 7d3:	a1 64 0b 00 00       	mov    0xb64,%eax
}
 7d8:	c9                   	leave  
 7d9:	c3                   	ret    

000007da <malloc>:

void*
malloc(uint nbytes)
{
 7da:	55                   	push   %ebp
 7db:	89 e5                	mov    %esp,%ebp
 7dd:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
 7e3:	83 c0 07             	add    $0x7,%eax
 7e6:	c1 e8 03             	shr    $0x3,%eax
 7e9:	83 c0 01             	add    $0x1,%eax
 7ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ef:	a1 64 0b 00 00       	mov    0xb64,%eax
 7f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7fb:	75 23                	jne    820 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7fd:	c7 45 f0 5c 0b 00 00 	movl   $0xb5c,-0x10(%ebp)
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	a3 64 0b 00 00       	mov    %eax,0xb64
 80c:	a1 64 0b 00 00       	mov    0xb64,%eax
 811:	a3 5c 0b 00 00       	mov    %eax,0xb5c
    base.s.size = 0;
 816:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 81d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	8b 00                	mov    (%eax),%eax
 825:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 831:	72 4d                	jb     880 <malloc+0xa6>
      if(p->s.size == nunits)
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83c:	75 0c                	jne    84a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	8b 10                	mov    (%eax),%edx
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	89 10                	mov    %edx,(%eax)
 848:	eb 26                	jmp    870 <malloc+0x96>
      else {
        p->s.size -= nunits;
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	8b 40 04             	mov    0x4(%eax),%eax
 850:	2b 45 ec             	sub    -0x14(%ebp),%eax
 853:	89 c2                	mov    %eax,%edx
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	c1 e0 03             	shl    $0x3,%eax
 864:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	a3 64 0b 00 00       	mov    %eax,0xb64
      return (void*)(p + 1);
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	83 c0 08             	add    $0x8,%eax
 87e:	eb 3b                	jmp    8bb <malloc+0xe1>
    }
    if(p == freep)
 880:	a1 64 0b 00 00       	mov    0xb64,%eax
 885:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 888:	75 1e                	jne    8a8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 88a:	83 ec 0c             	sub    $0xc,%esp
 88d:	ff 75 ec             	pushl  -0x14(%ebp)
 890:	e8 e5 fe ff ff       	call   77a <morecore>
 895:	83 c4 10             	add    $0x10,%esp
 898:	89 45 f4             	mov    %eax,-0xc(%ebp)
 89b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89f:	75 07                	jne    8a8 <malloc+0xce>
        return 0;
 8a1:	b8 00 00 00 00       	mov    $0x0,%eax
 8a6:	eb 13                	jmp    8bb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	8b 00                	mov    (%eax),%eax
 8b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b6:	e9 6d ff ff ff       	jmp    828 <malloc+0x4e>
}
 8bb:	c9                   	leave  
 8bc:	c3                   	ret    
