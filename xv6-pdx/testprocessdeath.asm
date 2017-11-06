
_testprocessdeath:     file format elf32-i386


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
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
	printf(1,"Testing process death\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 d5 08 00 00       	push   $0x8d5
  19:	6a 01                	push   $0x1
  1b:	e8 ff 04 00 00       	call   51f <printf>
  20:	83 c4 10             	add    $0x10,%esp
	int pid = fork();
  23:	e8 30 03 00 00       	call   358 <fork>
  28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(pid == 0){
  2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  2f:	75 12                	jne    43 <main+0x43>
											// add some logic here -- call wait() on the child and remove kill
		sleep(50000);						// do the same logic for wait() and exit()
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	68 50 c3 00 00       	push   $0xc350
  39:	e8 b2 03 00 00       	call   3f0 <sleep>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	eb 57                	jmp    9a <main+0x9a>
	}else{
		printf(1, "Forked child\n");
  43:	83 ec 08             	sub    $0x8,%esp
  46:	68 ec 08 00 00       	push   $0x8ec
  4b:	6a 01                	push   $0x1
  4d:	e8 cd 04 00 00       	call   51f <printf>
  52:	83 c4 10             	add    $0x10,%esp
		sleep(5000);
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	68 88 13 00 00       	push   $0x1388
  5d:	e8 8e 03 00 00       	call   3f0 <sleep>
  62:	83 c4 10             	add    $0x10,%esp
		printf(1, "Killed child\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 fa 08 00 00       	push   $0x8fa
  6d:	6a 01                	push   $0x1
  6f:	e8 ab 04 00 00       	call   51f <printf>
  74:	83 c4 10             	add    $0x10,%esp
		kill(pid);				// run command for zombie list
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	ff 75 f4             	pushl  -0xc(%ebp)
  7d:	e8 0e 03 00 00       	call   390 <kill>
  82:	83 c4 10             	add    $0x10,%esp
		sleep(5000);      
  85:	83 ec 0c             	sub    $0xc,%esp
  88:	68 88 13 00 00       	push   $0x1388
  8d:	e8 5e 03 00 00       	call   3f0 <sleep>
  92:	83 c4 10             	add    $0x10,%esp
		wait();  			// this is the parent. kill it and exit put it into zombie 
  95:	e8 ce 02 00 00       	call   368 <wait>
							//waiting for a child to become a zombie
							// wait() takes out of zombie into freelist
	}
	printf(1,"%d\n", pid);
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	ff 75 f4             	pushl  -0xc(%ebp)
  a0:	68 08 09 00 00       	push   $0x908
  a5:	6a 01                	push   $0x1
  a7:	e8 73 04 00 00       	call   51f <printf>
  ac:	83 c4 10             	add    $0x10,%esp
	sleep(10000);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	68 10 27 00 00       	push   $0x2710
  b7:	e8 34 03 00 00       	call   3f0 <sleep>
  bc:	83 c4 10             	add    $0x10,%esp
  	exit();
  bf:	e8 9c 02 00 00       	call   360 <exit>

000000c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cc:	8b 55 10             	mov    0x10(%ebp),%edx
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	89 cb                	mov    %ecx,%ebx
  d4:	89 df                	mov    %ebx,%edi
  d6:	89 d1                	mov    %edx,%ecx
  d8:	fc                   	cld    
  d9:	f3 aa                	rep stos %al,%es:(%edi)
  db:	89 ca                	mov    %ecx,%edx
  dd:	89 fb                	mov    %edi,%ebx
  df:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e5:	90                   	nop
  e6:	5b                   	pop    %ebx
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ea:	55                   	push   %ebp
  eb:	89 e5                	mov    %esp,%ebp
  ed:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f6:	90                   	nop
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
  fa:	8d 50 01             	lea    0x1(%eax),%edx
  fd:	89 55 08             	mov    %edx,0x8(%ebp)
 100:	8b 55 0c             	mov    0xc(%ebp),%edx
 103:	8d 4a 01             	lea    0x1(%edx),%ecx
 106:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 109:	0f b6 12             	movzbl (%edx),%edx
 10c:	88 10                	mov    %dl,(%eax)
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	84 c0                	test   %al,%al
 113:	75 e2                	jne    f7 <strcpy+0xd>
    ;
  return os;
 115:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 118:	c9                   	leave  
 119:	c3                   	ret    

0000011a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11d:	eb 08                	jmp    127 <strcmp+0xd>
    p++, q++;
 11f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 123:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	84 c0                	test   %al,%al
 12f:	74 10                	je     141 <strcmp+0x27>
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	0f b6 10             	movzbl (%eax),%edx
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	0f b6 00             	movzbl (%eax),%eax
 13d:	38 c2                	cmp    %al,%dl
 13f:	74 de                	je     11f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 00             	movzbl (%eax),%eax
 147:	0f b6 d0             	movzbl %al,%edx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	0f b6 00             	movzbl (%eax),%eax
 150:	0f b6 c0             	movzbl %al,%eax
 153:	29 c2                	sub    %eax,%edx
 155:	89 d0                	mov    %edx,%eax
}
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    

00000159 <strlen>:

uint
strlen(char *s)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 166:	eb 04                	jmp    16c <strlen+0x13>
 168:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16f:	8b 45 08             	mov    0x8(%ebp),%eax
 172:	01 d0                	add    %edx,%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	75 ed                	jne    168 <strlen+0xf>
    ;
  return n;
 17b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 183:	8b 45 10             	mov    0x10(%ebp),%eax
 186:	50                   	push   %eax
 187:	ff 75 0c             	pushl  0xc(%ebp)
 18a:	ff 75 08             	pushl  0x8(%ebp)
 18d:	e8 32 ff ff ff       	call   c4 <stosb>
 192:	83 c4 0c             	add    $0xc,%esp
  return dst;
 195:	8b 45 08             	mov    0x8(%ebp),%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <strchr>:

char*
strchr(const char *s, char c)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	83 ec 04             	sub    $0x4,%esp
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a6:	eb 14                	jmp    1bc <strchr+0x22>
    if(*s == c)
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 00             	movzbl (%eax),%eax
 1ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1b1:	75 05                	jne    1b8 <strchr+0x1e>
      return (char*)s;
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	eb 13                	jmp    1cb <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 e2                	jne    1a8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <gets>:

char*
gets(char *buf, int max)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1da:	eb 42                	jmp    21e <gets+0x51>
    cc = read(0, &c, 1);
 1dc:	83 ec 04             	sub    $0x4,%esp
 1df:	6a 01                	push   $0x1
 1e1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e4:	50                   	push   %eax
 1e5:	6a 00                	push   $0x0
 1e7:	e8 8c 01 00 00       	call   378 <read>
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1f6:	7e 33                	jle    22b <gets+0x5e>
      break;
    buf[i++] = c;
 1f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 201:	89 c2                	mov    %eax,%edx
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	01 c2                	add    %eax,%edx
 208:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 20c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 20e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 212:	3c 0a                	cmp    $0xa,%al
 214:	74 16                	je     22c <gets+0x5f>
 216:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21a:	3c 0d                	cmp    $0xd,%al
 21c:	74 0e                	je     22c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 221:	83 c0 01             	add    $0x1,%eax
 224:	3b 45 0c             	cmp    0xc(%ebp),%eax
 227:	7c b3                	jl     1dc <gets+0xf>
 229:	eb 01                	jmp    22c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 22b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 22c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	01 d0                	add    %edx,%eax
 234:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
}
 23a:	c9                   	leave  
 23b:	c3                   	ret    

0000023c <stat>:

int
stat(char *n, struct stat *st)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 242:	83 ec 08             	sub    $0x8,%esp
 245:	6a 00                	push   $0x0
 247:	ff 75 08             	pushl  0x8(%ebp)
 24a:	e8 51 01 00 00       	call   3a0 <open>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 259:	79 07                	jns    262 <stat+0x26>
    return -1;
 25b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 260:	eb 25                	jmp    287 <stat+0x4b>
  r = fstat(fd, st);
 262:	83 ec 08             	sub    $0x8,%esp
 265:	ff 75 0c             	pushl  0xc(%ebp)
 268:	ff 75 f4             	pushl  -0xc(%ebp)
 26b:	e8 48 01 00 00       	call   3b8 <fstat>
 270:	83 c4 10             	add    $0x10,%esp
 273:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 276:	83 ec 0c             	sub    $0xc,%esp
 279:	ff 75 f4             	pushl  -0xc(%ebp)
 27c:	e8 07 01 00 00       	call   388 <close>
 281:	83 c4 10             	add    $0x10,%esp
  return r;
 284:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <atoi>:

int
atoi(const char *s)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 28f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 296:	eb 04                	jmp    29c <atoi+0x13>
 298:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	3c 20                	cmp    $0x20,%al
 2a4:	74 f2                	je     298 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 00             	movzbl (%eax),%eax
 2ac:	3c 2d                	cmp    $0x2d,%al
 2ae:	75 07                	jne    2b7 <atoi+0x2e>
 2b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b5:	eb 05                	jmp    2bc <atoi+0x33>
 2b7:	b8 01 00 00 00       	mov    $0x1,%eax
 2bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2b                	cmp    $0x2b,%al
 2c7:	74 0a                	je     2d3 <atoi+0x4a>
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 2d                	cmp    $0x2d,%al
 2d1:	75 2b                	jne    2fe <atoi+0x75>
    s++;
 2d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2d7:	eb 25                	jmp    2fe <atoi+0x75>
    n = n*10 + *s++ - '0';
 2d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2dc:	89 d0                	mov    %edx,%eax
 2de:	c1 e0 02             	shl    $0x2,%eax
 2e1:	01 d0                	add    %edx,%eax
 2e3:	01 c0                	add    %eax,%eax
 2e5:	89 c1                	mov    %eax,%ecx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	8d 50 01             	lea    0x1(%eax),%edx
 2ed:	89 55 08             	mov    %edx,0x8(%ebp)
 2f0:	0f b6 00             	movzbl (%eax),%eax
 2f3:	0f be c0             	movsbl %al,%eax
 2f6:	01 c8                	add    %ecx,%eax
 2f8:	83 e8 30             	sub    $0x30,%eax
 2fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	0f b6 00             	movzbl (%eax),%eax
 304:	3c 2f                	cmp    $0x2f,%al
 306:	7e 0a                	jle    312 <atoi+0x89>
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 39                	cmp    $0x39,%al
 310:	7e c7                	jle    2d9 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 312:	8b 45 f8             	mov    -0x8(%ebp),%eax
 315:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 319:	c9                   	leave  
 31a:	c3                   	ret    

0000031b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31b:	55                   	push   %ebp
 31c:	89 e5                	mov    %esp,%ebp
 31e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 327:	8b 45 0c             	mov    0xc(%ebp),%eax
 32a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 32d:	eb 17                	jmp    346 <memmove+0x2b>
    *dst++ = *src++;
 32f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 332:	8d 50 01             	lea    0x1(%eax),%edx
 335:	89 55 fc             	mov    %edx,-0x4(%ebp)
 338:	8b 55 f8             	mov    -0x8(%ebp),%edx
 33b:	8d 4a 01             	lea    0x1(%edx),%ecx
 33e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 341:	0f b6 12             	movzbl (%edx),%edx
 344:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 346:	8b 45 10             	mov    0x10(%ebp),%eax
 349:	8d 50 ff             	lea    -0x1(%eax),%edx
 34c:	89 55 10             	mov    %edx,0x10(%ebp)
 34f:	85 c0                	test   %eax,%eax
 351:	7f dc                	jg     32f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 353:	8b 45 08             	mov    0x8(%ebp),%eax
}
 356:	c9                   	leave  
 357:	c3                   	ret    

00000358 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 358:	b8 01 00 00 00       	mov    $0x1,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <exit>:
SYSCALL(exit)
 360:	b8 02 00 00 00       	mov    $0x2,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <wait>:
SYSCALL(wait)
 368:	b8 03 00 00 00       	mov    $0x3,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <pipe>:
SYSCALL(pipe)
 370:	b8 04 00 00 00       	mov    $0x4,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <read>:
SYSCALL(read)
 378:	b8 05 00 00 00       	mov    $0x5,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <write>:
SYSCALL(write)
 380:	b8 10 00 00 00       	mov    $0x10,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <close>:
SYSCALL(close)
 388:	b8 15 00 00 00       	mov    $0x15,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <kill>:
SYSCALL(kill)
 390:	b8 06 00 00 00       	mov    $0x6,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <exec>:
SYSCALL(exec)
 398:	b8 07 00 00 00       	mov    $0x7,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <open>:
SYSCALL(open)
 3a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <mknod>:
SYSCALL(mknod)
 3a8:	b8 11 00 00 00       	mov    $0x11,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <unlink>:
SYSCALL(unlink)
 3b0:	b8 12 00 00 00       	mov    $0x12,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <fstat>:
SYSCALL(fstat)
 3b8:	b8 08 00 00 00       	mov    $0x8,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <link>:
SYSCALL(link)
 3c0:	b8 13 00 00 00       	mov    $0x13,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <mkdir>:
SYSCALL(mkdir)
 3c8:	b8 14 00 00 00       	mov    $0x14,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <chdir>:
SYSCALL(chdir)
 3d0:	b8 09 00 00 00       	mov    $0x9,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <dup>:
SYSCALL(dup)
 3d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <getpid>:
SYSCALL(getpid)
 3e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <sbrk>:
SYSCALL(sbrk)
 3e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <sleep>:
SYSCALL(sleep)
 3f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <uptime>:
SYSCALL(uptime)
 3f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <halt>:
SYSCALL(halt)
 400:	b8 16 00 00 00       	mov    $0x16,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <date>:
SYSCALL(date)
 408:	b8 17 00 00 00       	mov    $0x17,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <getuid>:
SYSCALL(getuid)
 410:	b8 18 00 00 00       	mov    $0x18,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <getgid>:
SYSCALL(getgid)
 418:	b8 19 00 00 00       	mov    $0x19,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getppid>:
SYSCALL(getppid)
 420:	b8 1a 00 00 00       	mov    $0x1a,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <setuid>:
SYSCALL(setuid)
 428:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <setgid>:
SYSCALL(setgid)
 430:	b8 1c 00 00 00       	mov    $0x1c,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <getprocs>:
SYSCALL(getprocs)
 438:	b8 1d 00 00 00       	mov    $0x1d,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <setpriority>:
SYSCALL(setpriority)
 440:	b8 1e 00 00 00       	mov    $0x1e,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 18             	sub    $0x18,%esp
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 454:	83 ec 04             	sub    $0x4,%esp
 457:	6a 01                	push   $0x1
 459:	8d 45 f4             	lea    -0xc(%ebp),%eax
 45c:	50                   	push   %eax
 45d:	ff 75 08             	pushl  0x8(%ebp)
 460:	e8 1b ff ff ff       	call   380 <write>
 465:	83 c4 10             	add    $0x10,%esp
}
 468:	90                   	nop
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
 46e:	53                   	push   %ebx
 46f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 479:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 47d:	74 17                	je     496 <printint+0x2b>
 47f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 483:	79 11                	jns    496 <printint+0x2b>
    neg = 1;
 485:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	f7 d8                	neg    %eax
 491:	89 45 ec             	mov    %eax,-0x14(%ebp)
 494:	eb 06                	jmp    49c <printint+0x31>
  } else {
    x = xx;
 496:	8b 45 0c             	mov    0xc(%ebp),%eax
 499:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 49c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4a6:	8d 41 01             	lea    0x1(%ecx),%eax
 4a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b2:	ba 00 00 00 00       	mov    $0x0,%edx
 4b7:	f7 f3                	div    %ebx
 4b9:	89 d0                	mov    %edx,%eax
 4bb:	0f b6 80 5c 0b 00 00 	movzbl 0xb5c(%eax),%eax
 4c2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
 4d1:	f7 f3                	div    %ebx
 4d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4da:	75 c7                	jne    4a3 <printint+0x38>
  if(neg)
 4dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e0:	74 2d                	je     50f <printint+0xa4>
    buf[i++] = '-';
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	8d 50 01             	lea    0x1(%eax),%edx
 4e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4eb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f0:	eb 1d                	jmp    50f <printint+0xa4>
    putc(fd, buf[i]);
 4f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f8:	01 d0                	add    %edx,%eax
 4fa:	0f b6 00             	movzbl (%eax),%eax
 4fd:	0f be c0             	movsbl %al,%eax
 500:	83 ec 08             	sub    $0x8,%esp
 503:	50                   	push   %eax
 504:	ff 75 08             	pushl  0x8(%ebp)
 507:	e8 3c ff ff ff       	call   448 <putc>
 50c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 50f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 517:	79 d9                	jns    4f2 <printint+0x87>
    putc(fd, buf[i]);
}
 519:	90                   	nop
 51a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 525:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 52c:	8d 45 0c             	lea    0xc(%ebp),%eax
 52f:	83 c0 04             	add    $0x4,%eax
 532:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 53c:	e9 59 01 00 00       	jmp    69a <printf+0x17b>
    c = fmt[i] & 0xff;
 541:	8b 55 0c             	mov    0xc(%ebp),%edx
 544:	8b 45 f0             	mov    -0x10(%ebp),%eax
 547:	01 d0                	add    %edx,%eax
 549:	0f b6 00             	movzbl (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	25 ff 00 00 00       	and    $0xff,%eax
 554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 557:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55b:	75 2c                	jne    589 <printf+0x6a>
      if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 0c                	jne    56f <printf+0x50>
        state = '%';
 563:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 56a:	e9 27 01 00 00       	jmp    696 <printf+0x177>
      } else {
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 c7 fe ff ff       	call   448 <putc>
 581:	83 c4 10             	add    $0x10,%esp
 584:	e9 0d 01 00 00       	jmp    696 <printf+0x177>
      }
    } else if(state == '%'){
 589:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 58d:	0f 85 03 01 00 00    	jne    696 <printf+0x177>
      if(c == 'd'){
 593:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 597:	75 1e                	jne    5b7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59c:	8b 00                	mov    (%eax),%eax
 59e:	6a 01                	push   $0x1
 5a0:	6a 0a                	push   $0xa
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 c0 fe ff ff       	call   46b <printint>
 5ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b2:	e9 d8 00 00 00       	jmp    68f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5b7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bb:	74 06                	je     5c3 <printf+0xa4>
 5bd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c1:	75 1e                	jne    5e1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c6:	8b 00                	mov    (%eax),%eax
 5c8:	6a 00                	push   $0x0
 5ca:	6a 10                	push   $0x10
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	pushl  0x8(%ebp)
 5d0:	e8 96 fe ff ff       	call   46b <printint>
 5d5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5dc:	e9 ae 00 00 00       	jmp    68f <printf+0x170>
      } else if(c == 's'){
 5e1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e5:	75 43                	jne    62a <printf+0x10b>
        s = (char*)*ap;
 5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f7:	75 25                	jne    61e <printf+0xff>
          s = "(null)";
 5f9:	c7 45 f4 0c 09 00 00 	movl   $0x90c,-0xc(%ebp)
        while(*s != 0){
 600:	eb 1c                	jmp    61e <printf+0xff>
          putc(fd, *s);
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	0f b6 00             	movzbl (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	83 ec 08             	sub    $0x8,%esp
 60e:	50                   	push   %eax
 60f:	ff 75 08             	pushl  0x8(%ebp)
 612:	e8 31 fe ff ff       	call   448 <putc>
 617:	83 c4 10             	add    $0x10,%esp
          s++;
 61a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 61e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 621:	0f b6 00             	movzbl (%eax),%eax
 624:	84 c0                	test   %al,%al
 626:	75 da                	jne    602 <printf+0xe3>
 628:	eb 65                	jmp    68f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 62e:	75 1d                	jne    64d <printf+0x12e>
        putc(fd, *ap);
 630:	8b 45 e8             	mov    -0x18(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 04 fe ff ff       	call   448 <putc>
 644:	83 c4 10             	add    $0x10,%esp
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	eb 42                	jmp    68f <printf+0x170>
      } else if(c == '%'){
 64d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 651:	75 17                	jne    66a <printf+0x14b>
        putc(fd, c);
 653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 656:	0f be c0             	movsbl %al,%eax
 659:	83 ec 08             	sub    $0x8,%esp
 65c:	50                   	push   %eax
 65d:	ff 75 08             	pushl  0x8(%ebp)
 660:	e8 e3 fd ff ff       	call   448 <putc>
 665:	83 c4 10             	add    $0x10,%esp
 668:	eb 25                	jmp    68f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66a:	83 ec 08             	sub    $0x8,%esp
 66d:	6a 25                	push   $0x25
 66f:	ff 75 08             	pushl  0x8(%ebp)
 672:	e8 d1 fd ff ff       	call   448 <putc>
 677:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 67a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 bc fd ff ff       	call   448 <putc>
 68c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 68f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 696:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 69a:	8b 55 0c             	mov    0xc(%ebp),%edx
 69d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a0:	01 d0                	add    %edx,%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	84 c0                	test   %al,%al
 6a7:	0f 85 94 fe ff ff    	jne    541 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ad:	90                   	nop
 6ae:	c9                   	leave  
 6af:	c3                   	ret    

000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	83 e8 08             	sub    $0x8,%eax
 6bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bf:	a1 78 0b 00 00       	mov    0xb78,%eax
 6c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c7:	eb 24                	jmp    6ed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d1:	77 12                	ja     6e5 <free+0x35>
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	77 24                	ja     6ff <free+0x4f>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e3:	77 1a                	ja     6ff <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	76 d4                	jbe    6c9 <free+0x19>
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fd:	76 ca                	jbe    6c9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	8b 40 04             	mov    0x4(%eax),%eax
 705:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	39 c2                	cmp    %eax,%edx
 718:	75 24                	jne    73e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	8b 50 04             	mov    0x4(%eax),%edx
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	8b 40 04             	mov    0x4(%eax),%eax
 728:	01 c2                	add    %eax,%edx
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	8b 10                	mov    (%eax),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	89 10                	mov    %edx,(%eax)
 73c:	eb 0a                	jmp    748 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 10                	mov    (%eax),%edx
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	01 d0                	add    %edx,%eax
 75a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75d:	75 20                	jne    77f <free+0xcf>
    p->s.size += bp->s.size;
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 50 04             	mov    0x4(%eax),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	01 c2                	add    %eax,%edx
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 08                	jmp    787 <free+0xd7>
  } else
    p->s.ptr = bp;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 55 f8             	mov    -0x8(%ebp),%edx
 785:	89 10                	mov    %edx,(%eax)
  freep = p;
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	a3 78 0b 00 00       	mov    %eax,0xb78
}
 78f:	90                   	nop
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <morecore>:

static Header*
morecore(uint nu)
{
 792:	55                   	push   %ebp
 793:	89 e5                	mov    %esp,%ebp
 795:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 798:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 79f:	77 07                	ja     7a8 <morecore+0x16>
    nu = 4096;
 7a1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
 7ab:	c1 e0 03             	shl    $0x3,%eax
 7ae:	83 ec 0c             	sub    $0xc,%esp
 7b1:	50                   	push   %eax
 7b2:	e8 31 fc ff ff       	call   3e8 <sbrk>
 7b7:	83 c4 10             	add    $0x10,%esp
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c1:	75 07                	jne    7ca <morecore+0x38>
    return 0;
 7c3:	b8 00 00 00 00       	mov    $0x0,%eax
 7c8:	eb 26                	jmp    7f0 <morecore+0x5e>
  hp = (Header*)p;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	8b 55 08             	mov    0x8(%ebp),%edx
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	83 ec 0c             	sub    $0xc,%esp
 7e2:	50                   	push   %eax
 7e3:	e8 c8 fe ff ff       	call   6b0 <free>
 7e8:	83 c4 10             	add    $0x10,%esp
  return freep;
 7eb:	a1 78 0b 00 00       	mov    0xb78,%eax
}
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    

000007f2 <malloc>:

void*
malloc(uint nbytes)
{
 7f2:	55                   	push   %ebp
 7f3:	89 e5                	mov    %esp,%ebp
 7f5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	83 c0 07             	add    $0x7,%eax
 7fe:	c1 e8 03             	shr    $0x3,%eax
 801:	83 c0 01             	add    $0x1,%eax
 804:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 807:	a1 78 0b 00 00       	mov    0xb78,%eax
 80c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 813:	75 23                	jne    838 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 815:	c7 45 f0 70 0b 00 00 	movl   $0xb70,-0x10(%ebp)
 81c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81f:	a3 78 0b 00 00       	mov    %eax,0xb78
 824:	a1 78 0b 00 00       	mov    0xb78,%eax
 829:	a3 70 0b 00 00       	mov    %eax,0xb70
    base.s.size = 0;
 82e:	c7 05 74 0b 00 00 00 	movl   $0x0,0xb74
 835:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 849:	72 4d                	jb     898 <malloc+0xa6>
      if(p->s.size == nunits)
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 854:	75 0c                	jne    862 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 10                	mov    (%eax),%edx
 85b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85e:	89 10                	mov    %edx,(%eax)
 860:	eb 26                	jmp    888 <malloc+0x96>
      else {
        p->s.size -= nunits;
 862:	8b 45 f4             	mov    -0xc(%ebp),%eax
 865:	8b 40 04             	mov    0x4(%eax),%eax
 868:	2b 45 ec             	sub    -0x14(%ebp),%eax
 86b:	89 c2                	mov    %eax,%edx
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	c1 e0 03             	shl    $0x3,%eax
 87c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 55 ec             	mov    -0x14(%ebp),%edx
 885:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 888:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88b:	a3 78 0b 00 00       	mov    %eax,0xb78
      return (void*)(p + 1);
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	83 c0 08             	add    $0x8,%eax
 896:	eb 3b                	jmp    8d3 <malloc+0xe1>
    }
    if(p == freep)
 898:	a1 78 0b 00 00       	mov    0xb78,%eax
 89d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a0:	75 1e                	jne    8c0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a2:	83 ec 0c             	sub    $0xc,%esp
 8a5:	ff 75 ec             	pushl  -0x14(%ebp)
 8a8:	e8 e5 fe ff ff       	call   792 <morecore>
 8ad:	83 c4 10             	add    $0x10,%esp
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b7:	75 07                	jne    8c0 <malloc+0xce>
        return 0;
 8b9:	b8 00 00 00 00       	mov    $0x0,%eax
 8be:	eb 13                	jmp    8d3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 00                	mov    (%eax),%eax
 8cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ce:	e9 6d ff ff ff       	jmp    840 <malloc+0x4e>
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    
