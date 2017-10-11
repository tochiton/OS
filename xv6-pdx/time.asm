
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
  14:	e8 d5 03 00 00       	call   3ee <uptime>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int pid = fork();
  1c:	e8 2d 03 00 00       	call   34e <fork>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if(pid < 0){
  24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  28:	79 17                	jns    41 <main+0x41>
		printf(2, "time failed: invalid pid\n");
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	68 c3 08 00 00       	push   $0x8c3
  32:	6a 02                	push   $0x2
  34:	e8 d4 04 00 00       	call   50d <printf>
  39:	83 c4 10             	add    $0x10,%esp
		exit();	
  3c:	e8 15 03 00 00       	call   356 <exit>
	}

	if(pid == 0){
  41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  45:	75 3d                	jne    84 <main+0x84>
		if(argc == 1)
  47:	83 3b 01             	cmpl   $0x1,(%ebx)
  4a:	75 05                	jne    51 <main+0x51>
			exit(); 
  4c:	e8 05 03 00 00       	call   356 <exit>
		++argv; 
  51:	83 43 04 04          	addl   $0x4,0x4(%ebx)
		if(exec(argv[0], argv)){
  55:	8b 43 04             	mov    0x4(%ebx),%eax
  58:	8b 00                	mov    (%eax),%eax
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	ff 73 04             	pushl  0x4(%ebx)
  60:	50                   	push   %eax
  61:	e8 28 03 00 00       	call   38e <exec>
  66:	83 c4 10             	add    $0x10,%esp
  69:	85 c0                	test   %eax,%eax
  6b:	74 17                	je     84 <main+0x84>
			printf(2, "time failed: exec failed\n");
  6d:	83 ec 08             	sub    $0x8,%esp
  70:	68 dd 08 00 00       	push   $0x8dd
  75:	6a 02                	push   $0x2
  77:	e8 91 04 00 00       	call   50d <printf>
  7c:	83 c4 10             	add    $0x10,%esp
			exit();	
  7f:	e8 d2 02 00 00       	call   356 <exit>
		}  
	}
	wait();
  84:	e8 d5 02 00 00       	call   35e <wait>
	int time_end = uptime();
  89:	e8 60 03 00 00       	call   3ee <uptime>
  8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int total_time = time_end - time_start;
  91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  94:	2b 45 f4             	sub    -0xc(%ebp),%eax
  97:	89 45 e8             	mov    %eax,-0x18(%ebp)
	printf(1, "%s ran in %d seconds\n",argv[1], total_time);
  9a:	8b 43 04             	mov    0x4(%ebx),%eax
  9d:	83 c0 04             	add    $0x4,%eax
  a0:	8b 00                	mov    (%eax),%eax
  a2:	ff 75 e8             	pushl  -0x18(%ebp)
  a5:	50                   	push   %eax
  a6:	68 f7 08 00 00       	push   $0x8f7
  ab:	6a 01                	push   $0x1
  ad:	e8 5b 04 00 00       	call   50d <printf>
  b2:	83 c4 10             	add    $0x10,%esp
	exit();
  b5:	e8 9c 02 00 00       	call   356 <exit>

000000ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ba:	55                   	push   %ebp
  bb:	89 e5                	mov    %esp,%ebp
  bd:	57                   	push   %edi
  be:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  c2:	8b 55 10             	mov    0x10(%ebp),%edx
  c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  c8:	89 cb                	mov    %ecx,%ebx
  ca:	89 df                	mov    %ebx,%edi
  cc:	89 d1                	mov    %edx,%ecx
  ce:	fc                   	cld    
  cf:	f3 aa                	rep stos %al,%es:(%edi)
  d1:	89 ca                	mov    %ecx,%edx
  d3:	89 fb                	mov    %edi,%ebx
  d5:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  db:	90                   	nop
  dc:	5b                   	pop    %ebx
  dd:	5f                   	pop    %edi
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ec:	90                   	nop
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8d 50 01             	lea    0x1(%eax),%edx
  f3:	89 55 08             	mov    %edx,0x8(%ebp)
  f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  f9:	8d 4a 01             	lea    0x1(%edx),%ecx
  fc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ff:	0f b6 12             	movzbl (%edx),%edx
 102:	88 10                	mov    %dl,(%eax)
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	84 c0                	test   %al,%al
 109:	75 e2                	jne    ed <strcpy+0xd>
    ;
  return os;
 10b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10e:	c9                   	leave  
 10f:	c3                   	ret    

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 113:	eb 08                	jmp    11d <strcmp+0xd>
    p++, q++;
 115:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 119:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	0f b6 00             	movzbl (%eax),%eax
 123:	84 c0                	test   %al,%al
 125:	74 10                	je     137 <strcmp+0x27>
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	0f b6 00             	movzbl (%eax),%eax
 133:	38 c2                	cmp    %al,%dl
 135:	74 de                	je     115 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 137:	8b 45 08             	mov    0x8(%ebp),%eax
 13a:	0f b6 00             	movzbl (%eax),%eax
 13d:	0f b6 d0             	movzbl %al,%edx
 140:	8b 45 0c             	mov    0xc(%ebp),%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	0f b6 c0             	movzbl %al,%eax
 149:	29 c2                	sub    %eax,%edx
 14b:	89 d0                	mov    %edx,%eax
}
 14d:	5d                   	pop    %ebp
 14e:	c3                   	ret    

0000014f <strlen>:

uint
strlen(char *s)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 155:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 15c:	eb 04                	jmp    162 <strlen+0x13>
 15e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 162:	8b 55 fc             	mov    -0x4(%ebp),%edx
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	01 d0                	add    %edx,%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 ed                	jne    15e <strlen+0xf>
    ;
  return n;
 171:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <memset>:

void*
memset(void *dst, int c, uint n)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 179:	8b 45 10             	mov    0x10(%ebp),%eax
 17c:	50                   	push   %eax
 17d:	ff 75 0c             	pushl  0xc(%ebp)
 180:	ff 75 08             	pushl  0x8(%ebp)
 183:	e8 32 ff ff ff       	call   ba <stosb>
 188:	83 c4 0c             	add    $0xc,%esp
  return dst;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	83 ec 04             	sub    $0x4,%esp
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19c:	eb 14                	jmp    1b2 <strchr+0x22>
    if(*s == c)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a7:	75 05                	jne    1ae <strchr+0x1e>
      return (char*)s;
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	eb 13                	jmp    1c1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 00             	movzbl (%eax),%eax
 1b8:	84 c0                	test   %al,%al
 1ba:	75 e2                	jne    19e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c1:	c9                   	leave  
 1c2:	c3                   	ret    

000001c3 <gets>:

char*
gets(char *buf, int max)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1d0:	eb 42                	jmp    214 <gets+0x51>
    cc = read(0, &c, 1);
 1d2:	83 ec 04             	sub    $0x4,%esp
 1d5:	6a 01                	push   $0x1
 1d7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	6a 00                	push   $0x0
 1dd:	e8 8c 01 00 00       	call   36e <read>
 1e2:	83 c4 10             	add    $0x10,%esp
 1e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ec:	7e 33                	jle    221 <gets+0x5e>
      break;
    buf[i++] = c;
 1ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f1:	8d 50 01             	lea    0x1(%eax),%edx
 1f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1f7:	89 c2                	mov    %eax,%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 c2                	add    %eax,%edx
 1fe:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 202:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 204:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 208:	3c 0a                	cmp    $0xa,%al
 20a:	74 16                	je     222 <gets+0x5f>
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	3c 0d                	cmp    $0xd,%al
 212:	74 0e                	je     222 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 214:	8b 45 f4             	mov    -0xc(%ebp),%eax
 217:	83 c0 01             	add    $0x1,%eax
 21a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21d:	7c b3                	jl     1d2 <gets+0xf>
 21f:	eb 01                	jmp    222 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 221:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 222:	8b 55 f4             	mov    -0xc(%ebp),%edx
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	01 d0                	add    %edx,%eax
 22a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <stat>:

int
stat(char *n, struct stat *st)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 238:	83 ec 08             	sub    $0x8,%esp
 23b:	6a 00                	push   $0x0
 23d:	ff 75 08             	pushl  0x8(%ebp)
 240:	e8 51 01 00 00       	call   396 <open>
 245:	83 c4 10             	add    $0x10,%esp
 248:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 24b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 24f:	79 07                	jns    258 <stat+0x26>
    return -1;
 251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 256:	eb 25                	jmp    27d <stat+0x4b>
  r = fstat(fd, st);
 258:	83 ec 08             	sub    $0x8,%esp
 25b:	ff 75 0c             	pushl  0xc(%ebp)
 25e:	ff 75 f4             	pushl  -0xc(%ebp)
 261:	e8 48 01 00 00       	call   3ae <fstat>
 266:	83 c4 10             	add    $0x10,%esp
 269:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 26c:	83 ec 0c             	sub    $0xc,%esp
 26f:	ff 75 f4             	pushl  -0xc(%ebp)
 272:	e8 07 01 00 00       	call   37e <close>
 277:	83 c4 10             	add    $0x10,%esp
  return r;
 27a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <atoi>:

int
atoi(const char *s)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 285:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 28c:	eb 04                	jmp    292 <atoi+0x13>
 28e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	3c 20                	cmp    $0x20,%al
 29a:	74 f2                	je     28e <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	3c 2d                	cmp    $0x2d,%al
 2a4:	75 07                	jne    2ad <atoi+0x2e>
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 05                	jmp    2b2 <atoi+0x33>
 2ad:	b8 01 00 00 00       	mov    $0x1,%eax
 2b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	3c 2b                	cmp    $0x2b,%al
 2bd:	74 0a                	je     2c9 <atoi+0x4a>
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2d                	cmp    $0x2d,%al
 2c7:	75 2b                	jne    2f4 <atoi+0x75>
    s++;
 2c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2cd:	eb 25                	jmp    2f4 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d2:	89 d0                	mov    %edx,%eax
 2d4:	c1 e0 02             	shl    $0x2,%eax
 2d7:	01 d0                	add    %edx,%eax
 2d9:	01 c0                	add    %eax,%eax
 2db:	89 c1                	mov    %eax,%ecx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 08             	mov    %edx,0x8(%ebp)
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	0f be c0             	movsbl %al,%eax
 2ec:	01 c8                	add    %ecx,%eax
 2ee:	83 e8 30             	sub    $0x30,%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	0f b6 00             	movzbl (%eax),%eax
 2fa:	3c 2f                	cmp    $0x2f,%al
 2fc:	7e 0a                	jle    308 <atoi+0x89>
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	0f b6 00             	movzbl (%eax),%eax
 304:	3c 39                	cmp    $0x39,%al
 306:	7e c7                	jle    2cf <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 308:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30b:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 323:	eb 17                	jmp    33c <memmove+0x2b>
    *dst++ = *src++;
 325:	8b 45 fc             	mov    -0x4(%ebp),%eax
 328:	8d 50 01             	lea    0x1(%eax),%edx
 32b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 331:	8d 4a 01             	lea    0x1(%edx),%ecx
 334:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 337:	0f b6 12             	movzbl (%edx),%edx
 33a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33c:	8b 45 10             	mov    0x10(%ebp),%eax
 33f:	8d 50 ff             	lea    -0x1(%eax),%edx
 342:	89 55 10             	mov    %edx,0x10(%ebp)
 345:	85 c0                	test   %eax,%eax
 347:	7f dc                	jg     325 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34e:	b8 01 00 00 00       	mov    $0x1,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <exit>:
SYSCALL(exit)
 356:	b8 02 00 00 00       	mov    $0x2,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <wait>:
SYSCALL(wait)
 35e:	b8 03 00 00 00       	mov    $0x3,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <pipe>:
SYSCALL(pipe)
 366:	b8 04 00 00 00       	mov    $0x4,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <read>:
SYSCALL(read)
 36e:	b8 05 00 00 00       	mov    $0x5,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <write>:
SYSCALL(write)
 376:	b8 10 00 00 00       	mov    $0x10,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <close>:
SYSCALL(close)
 37e:	b8 15 00 00 00       	mov    $0x15,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <kill>:
SYSCALL(kill)
 386:	b8 06 00 00 00       	mov    $0x6,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <exec>:
SYSCALL(exec)
 38e:	b8 07 00 00 00       	mov    $0x7,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <open>:
SYSCALL(open)
 396:	b8 0f 00 00 00       	mov    $0xf,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <mknod>:
SYSCALL(mknod)
 39e:	b8 11 00 00 00       	mov    $0x11,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <unlink>:
SYSCALL(unlink)
 3a6:	b8 12 00 00 00       	mov    $0x12,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <fstat>:
SYSCALL(fstat)
 3ae:	b8 08 00 00 00       	mov    $0x8,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <link>:
SYSCALL(link)
 3b6:	b8 13 00 00 00       	mov    $0x13,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <mkdir>:
SYSCALL(mkdir)
 3be:	b8 14 00 00 00       	mov    $0x14,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <chdir>:
SYSCALL(chdir)
 3c6:	b8 09 00 00 00       	mov    $0x9,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <dup>:
SYSCALL(dup)
 3ce:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <getpid>:
SYSCALL(getpid)
 3d6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <sbrk>:
SYSCALL(sbrk)
 3de:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <sleep>:
SYSCALL(sleep)
 3e6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <uptime>:
SYSCALL(uptime)
 3ee:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <halt>:
SYSCALL(halt)
 3f6:	b8 16 00 00 00       	mov    $0x16,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <date>:
SYSCALL(date)
 3fe:	b8 17 00 00 00       	mov    $0x17,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <getuid>:
SYSCALL(getuid)
 406:	b8 18 00 00 00       	mov    $0x18,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <getgid>:
SYSCALL(getgid)
 40e:	b8 19 00 00 00       	mov    $0x19,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getppid>:
SYSCALL(getppid)
 416:	b8 1a 00 00 00       	mov    $0x1a,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <setuid>:
SYSCALL(setuid)
 41e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <setgid>:
SYSCALL(setgid)
 426:	b8 1c 00 00 00       	mov    $0x1c,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <getprocs>:
SYSCALL(getprocs)
 42e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	83 ec 18             	sub    $0x18,%esp
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 442:	83 ec 04             	sub    $0x4,%esp
 445:	6a 01                	push   $0x1
 447:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44a:	50                   	push   %eax
 44b:	ff 75 08             	pushl  0x8(%ebp)
 44e:	e8 23 ff ff ff       	call   376 <write>
 453:	83 c4 10             	add    $0x10,%esp
}
 456:	90                   	nop
 457:	c9                   	leave  
 458:	c3                   	ret    

00000459 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 459:	55                   	push   %ebp
 45a:	89 e5                	mov    %esp,%ebp
 45c:	53                   	push   %ebx
 45d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 467:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46b:	74 17                	je     484 <printint+0x2b>
 46d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 471:	79 11                	jns    484 <printint+0x2b>
    neg = 1;
 473:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47a:	8b 45 0c             	mov    0xc(%ebp),%eax
 47d:	f7 d8                	neg    %eax
 47f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 482:	eb 06                	jmp    48a <printint+0x31>
  } else {
    x = xx;
 484:	8b 45 0c             	mov    0xc(%ebp),%eax
 487:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 48a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 491:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 494:	8d 41 01             	lea    0x1(%ecx),%eax
 497:	89 45 f4             	mov    %eax,-0xc(%ebp)
 49a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a0:	ba 00 00 00 00       	mov    $0x0,%edx
 4a5:	f7 f3                	div    %ebx
 4a7:	89 d0                	mov    %edx,%eax
 4a9:	0f b6 80 60 0b 00 00 	movzbl 0xb60(%eax),%eax
 4b0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ba:	ba 00 00 00 00       	mov    $0x0,%edx
 4bf:	f7 f3                	div    %ebx
 4c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c8:	75 c7                	jne    491 <printint+0x38>
  if(neg)
 4ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ce:	74 2d                	je     4fd <printint+0xa4>
    buf[i++] = '-';
 4d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d3:	8d 50 01             	lea    0x1(%eax),%edx
 4d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d9:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4de:	eb 1d                	jmp    4fd <printint+0xa4>
    putc(fd, buf[i]);
 4e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e6:	01 d0                	add    %edx,%eax
 4e8:	0f b6 00             	movzbl (%eax),%eax
 4eb:	0f be c0             	movsbl %al,%eax
 4ee:	83 ec 08             	sub    $0x8,%esp
 4f1:	50                   	push   %eax
 4f2:	ff 75 08             	pushl  0x8(%ebp)
 4f5:	e8 3c ff ff ff       	call   436 <putc>
 4fa:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4fd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 501:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 505:	79 d9                	jns    4e0 <printint+0x87>
    putc(fd, buf[i]);
}
 507:	90                   	nop
 508:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 50b:	c9                   	leave  
 50c:	c3                   	ret    

0000050d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50d:	55                   	push   %ebp
 50e:	89 e5                	mov    %esp,%ebp
 510:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 513:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51a:	8d 45 0c             	lea    0xc(%ebp),%eax
 51d:	83 c0 04             	add    $0x4,%eax
 520:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 523:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 52a:	e9 59 01 00 00       	jmp    688 <printf+0x17b>
    c = fmt[i] & 0xff;
 52f:	8b 55 0c             	mov    0xc(%ebp),%edx
 532:	8b 45 f0             	mov    -0x10(%ebp),%eax
 535:	01 d0                	add    %edx,%eax
 537:	0f b6 00             	movzbl (%eax),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	25 ff 00 00 00       	and    $0xff,%eax
 542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 545:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 549:	75 2c                	jne    577 <printf+0x6a>
      if(c == '%'){
 54b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54f:	75 0c                	jne    55d <printf+0x50>
        state = '%';
 551:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 558:	e9 27 01 00 00       	jmp    684 <printf+0x177>
      } else {
        putc(fd, c);
 55d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	83 ec 08             	sub    $0x8,%esp
 566:	50                   	push   %eax
 567:	ff 75 08             	pushl  0x8(%ebp)
 56a:	e8 c7 fe ff ff       	call   436 <putc>
 56f:	83 c4 10             	add    $0x10,%esp
 572:	e9 0d 01 00 00       	jmp    684 <printf+0x177>
      }
    } else if(state == '%'){
 577:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 57b:	0f 85 03 01 00 00    	jne    684 <printf+0x177>
      if(c == 'd'){
 581:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 585:	75 1e                	jne    5a5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 587:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58a:	8b 00                	mov    (%eax),%eax
 58c:	6a 01                	push   $0x1
 58e:	6a 0a                	push   $0xa
 590:	50                   	push   %eax
 591:	ff 75 08             	pushl  0x8(%ebp)
 594:	e8 c0 fe ff ff       	call   459 <printint>
 599:	83 c4 10             	add    $0x10,%esp
        ap++;
 59c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a0:	e9 d8 00 00 00       	jmp    67d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5a5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a9:	74 06                	je     5b1 <printf+0xa4>
 5ab:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5af:	75 1e                	jne    5cf <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b4:	8b 00                	mov    (%eax),%eax
 5b6:	6a 00                	push   $0x0
 5b8:	6a 10                	push   $0x10
 5ba:	50                   	push   %eax
 5bb:	ff 75 08             	pushl  0x8(%ebp)
 5be:	e8 96 fe ff ff       	call   459 <printint>
 5c3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ca:	e9 ae 00 00 00       	jmp    67d <printf+0x170>
      } else if(c == 's'){
 5cf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d3:	75 43                	jne    618 <printf+0x10b>
        s = (char*)*ap;
 5d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d8:	8b 00                	mov    (%eax),%eax
 5da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e5:	75 25                	jne    60c <printf+0xff>
          s = "(null)";
 5e7:	c7 45 f4 0d 09 00 00 	movl   $0x90d,-0xc(%ebp)
        while(*s != 0){
 5ee:	eb 1c                	jmp    60c <printf+0xff>
          putc(fd, *s);
 5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f3:	0f b6 00             	movzbl (%eax),%eax
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	83 ec 08             	sub    $0x8,%esp
 5fc:	50                   	push   %eax
 5fd:	ff 75 08             	pushl  0x8(%ebp)
 600:	e8 31 fe ff ff       	call   436 <putc>
 605:	83 c4 10             	add    $0x10,%esp
          s++;
 608:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60f:	0f b6 00             	movzbl (%eax),%eax
 612:	84 c0                	test   %al,%al
 614:	75 da                	jne    5f0 <printf+0xe3>
 616:	eb 65                	jmp    67d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 618:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61c:	75 1d                	jne    63b <printf+0x12e>
        putc(fd, *ap);
 61e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	83 ec 08             	sub    $0x8,%esp
 629:	50                   	push   %eax
 62a:	ff 75 08             	pushl  0x8(%ebp)
 62d:	e8 04 fe ff ff       	call   436 <putc>
 632:	83 c4 10             	add    $0x10,%esp
        ap++;
 635:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 639:	eb 42                	jmp    67d <printf+0x170>
      } else if(c == '%'){
 63b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63f:	75 17                	jne    658 <printf+0x14b>
        putc(fd, c);
 641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 644:	0f be c0             	movsbl %al,%eax
 647:	83 ec 08             	sub    $0x8,%esp
 64a:	50                   	push   %eax
 64b:	ff 75 08             	pushl  0x8(%ebp)
 64e:	e8 e3 fd ff ff       	call   436 <putc>
 653:	83 c4 10             	add    $0x10,%esp
 656:	eb 25                	jmp    67d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	6a 25                	push   $0x25
 65d:	ff 75 08             	pushl  0x8(%ebp)
 660:	e8 d1 fd ff ff       	call   436 <putc>
 665:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 bc fd ff ff       	call   436 <putc>
 67a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 67d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 684:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 688:	8b 55 0c             	mov    0xc(%ebp),%edx
 68b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68e:	01 d0                	add    %edx,%eax
 690:	0f b6 00             	movzbl (%eax),%eax
 693:	84 c0                	test   %al,%al
 695:	0f 85 94 fe ff ff    	jne    52f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 69b:	90                   	nop
 69c:	c9                   	leave  
 69d:	c3                   	ret    

0000069e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69e:	55                   	push   %ebp
 69f:	89 e5                	mov    %esp,%ebp
 6a1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	83 e8 08             	sub    $0x8,%eax
 6aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ad:	a1 7c 0b 00 00       	mov    0xb7c,%eax
 6b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b5:	eb 24                	jmp    6db <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bf:	77 12                	ja     6d3 <free+0x35>
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c7:	77 24                	ja     6ed <free+0x4f>
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d1:	77 1a                	ja     6ed <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e1:	76 d4                	jbe    6b7 <free+0x19>
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6eb:	76 ca                	jbe    6b7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 40 04             	mov    0x4(%eax),%eax
 6f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	39 c2                	cmp    %eax,%edx
 706:	75 24                	jne    72c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 708:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	8b 40 04             	mov    0x4(%eax),%eax
 716:	01 c2                	add    %eax,%edx
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	8b 10                	mov    (%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 10                	mov    %edx,(%eax)
 72a:	eb 0a                	jmp    736 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	8b 10                	mov    (%eax),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 40 04             	mov    0x4(%eax),%eax
 73c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	01 d0                	add    %edx,%eax
 748:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74b:	75 20                	jne    76d <free+0xcf>
    p->s.size += bp->s.size;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 40 04             	mov    0x4(%eax),%eax
 759:	01 c2                	add    %eax,%edx
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 761:	8b 45 f8             	mov    -0x8(%ebp),%eax
 764:	8b 10                	mov    (%eax),%edx
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	89 10                	mov    %edx,(%eax)
 76b:	eb 08                	jmp    775 <free+0xd7>
  } else
    p->s.ptr = bp;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 55 f8             	mov    -0x8(%ebp),%edx
 773:	89 10                	mov    %edx,(%eax)
  freep = p;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	a3 7c 0b 00 00       	mov    %eax,0xb7c
}
 77d:	90                   	nop
 77e:	c9                   	leave  
 77f:	c3                   	ret    

00000780 <morecore>:

static Header*
morecore(uint nu)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 786:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 78d:	77 07                	ja     796 <morecore+0x16>
    nu = 4096;
 78f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 796:	8b 45 08             	mov    0x8(%ebp),%eax
 799:	c1 e0 03             	shl    $0x3,%eax
 79c:	83 ec 0c             	sub    $0xc,%esp
 79f:	50                   	push   %eax
 7a0:	e8 39 fc ff ff       	call   3de <sbrk>
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7af:	75 07                	jne    7b8 <morecore+0x38>
    return 0;
 7b1:	b8 00 00 00 00       	mov    $0x0,%eax
 7b6:	eb 26                	jmp    7de <morecore+0x5e>
  hp = (Header*)p;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c1:	8b 55 08             	mov    0x8(%ebp),%edx
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	83 c0 08             	add    $0x8,%eax
 7cd:	83 ec 0c             	sub    $0xc,%esp
 7d0:	50                   	push   %eax
 7d1:	e8 c8 fe ff ff       	call   69e <free>
 7d6:	83 c4 10             	add    $0x10,%esp
  return freep;
 7d9:	a1 7c 0b 00 00       	mov    0xb7c,%eax
}
 7de:	c9                   	leave  
 7df:	c3                   	ret    

000007e0 <malloc>:

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e6:	8b 45 08             	mov    0x8(%ebp),%eax
 7e9:	83 c0 07             	add    $0x7,%eax
 7ec:	c1 e8 03             	shr    $0x3,%eax
 7ef:	83 c0 01             	add    $0x1,%eax
 7f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f5:	a1 7c 0b 00 00       	mov    0xb7c,%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 801:	75 23                	jne    826 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 803:	c7 45 f0 74 0b 00 00 	movl   $0xb74,-0x10(%ebp)
 80a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80d:	a3 7c 0b 00 00       	mov    %eax,0xb7c
 812:	a1 7c 0b 00 00       	mov    0xb7c,%eax
 817:	a3 74 0b 00 00       	mov    %eax,0xb74
    base.s.size = 0;
 81c:	c7 05 78 0b 00 00 00 	movl   $0x0,0xb78
 823:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 837:	72 4d                	jb     886 <malloc+0xa6>
      if(p->s.size == nunits)
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 842:	75 0c                	jne    850 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	8b 10                	mov    (%eax),%edx
 849:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84c:	89 10                	mov    %edx,(%eax)
 84e:	eb 26                	jmp    876 <malloc+0x96>
      else {
        p->s.size -= nunits;
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	2b 45 ec             	sub    -0x14(%ebp),%eax
 859:	89 c2                	mov    %eax,%edx
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	c1 e0 03             	shl    $0x3,%eax
 86a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 55 ec             	mov    -0x14(%ebp),%edx
 873:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	a3 7c 0b 00 00       	mov    %eax,0xb7c
      return (void*)(p + 1);
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	83 c0 08             	add    $0x8,%eax
 884:	eb 3b                	jmp    8c1 <malloc+0xe1>
    }
    if(p == freep)
 886:	a1 7c 0b 00 00       	mov    0xb7c,%eax
 88b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 88e:	75 1e                	jne    8ae <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 890:	83 ec 0c             	sub    $0xc,%esp
 893:	ff 75 ec             	pushl  -0x14(%ebp)
 896:	e8 e5 fe ff ff       	call   780 <morecore>
 89b:	83 c4 10             	add    $0x10,%esp
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a5:	75 07                	jne    8ae <malloc+0xce>
        return 0;
 8a7:	b8 00 00 00 00       	mov    $0x0,%eax
 8ac:	eb 13                	jmp    8c1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8bc:	e9 6d ff ff ff       	jmp    82e <malloc+0x4e>
}
 8c1:	c9                   	leave  
 8c2:	c3                   	ret    
