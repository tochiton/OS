
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
  14:	68 cd 08 00 00       	push   $0x8cd
  19:	6a 01                	push   $0x1
  1b:	e8 f7 04 00 00       	call   517 <printf>
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
  46:	68 e4 08 00 00       	push   $0x8e4
  4b:	6a 01                	push   $0x1
  4d:	e8 c5 04 00 00       	call   517 <printf>
  52:	83 c4 10             	add    $0x10,%esp
		sleep(5000);
  55:	83 ec 0c             	sub    $0xc,%esp
  58:	68 88 13 00 00       	push   $0x1388
  5d:	e8 8e 03 00 00       	call   3f0 <sleep>
  62:	83 c4 10             	add    $0x10,%esp
		printf(1, "Killed child\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 f2 08 00 00       	push   $0x8f2
  6d:	6a 01                	push   $0x1
  6f:	e8 a3 04 00 00       	call   517 <printf>
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
		wait();  // this is the parent. kill it and exit put it into zombie 
  95:	e8 ce 02 00 00       	call   368 <wait>
				//waiting for a child to become a zombie
						// wait() takes out of zombie into freelist
	}
	printf(1,"%d\n", pid);
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	ff 75 f4             	pushl  -0xc(%ebp)
  a0:	68 00 09 00 00       	push   $0x900
  a5:	6a 01                	push   $0x1
  a7:	e8 6b 04 00 00       	call   517 <printf>
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

00000440 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	83 ec 18             	sub    $0x18,%esp
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 44c:	83 ec 04             	sub    $0x4,%esp
 44f:	6a 01                	push   $0x1
 451:	8d 45 f4             	lea    -0xc(%ebp),%eax
 454:	50                   	push   %eax
 455:	ff 75 08             	pushl  0x8(%ebp)
 458:	e8 23 ff ff ff       	call   380 <write>
 45d:	83 c4 10             	add    $0x10,%esp
}
 460:	90                   	nop
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	53                   	push   %ebx
 467:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 46a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 471:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 475:	74 17                	je     48e <printint+0x2b>
 477:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 47b:	79 11                	jns    48e <printint+0x2b>
    neg = 1;
 47d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 484:	8b 45 0c             	mov    0xc(%ebp),%eax
 487:	f7 d8                	neg    %eax
 489:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48c:	eb 06                	jmp    494 <printint+0x31>
  } else {
    x = xx;
 48e:	8b 45 0c             	mov    0xc(%ebp),%eax
 491:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 494:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 49b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 49e:	8d 41 01             	lea    0x1(%ecx),%eax
 4a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4aa:	ba 00 00 00 00       	mov    $0x0,%edx
 4af:	f7 f3                	div    %ebx
 4b1:	89 d0                	mov    %edx,%eax
 4b3:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 4ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4be:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c4:	ba 00 00 00 00       	mov    $0x0,%edx
 4c9:	f7 f3                	div    %ebx
 4cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d2:	75 c7                	jne    49b <printint+0x38>
  if(neg)
 4d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d8:	74 2d                	je     507 <printint+0xa4>
    buf[i++] = '-';
 4da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dd:	8d 50 01             	lea    0x1(%eax),%edx
 4e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e8:	eb 1d                	jmp    507 <printint+0xa4>
    putc(fd, buf[i]);
 4ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f0:	01 d0                	add    %edx,%eax
 4f2:	0f b6 00             	movzbl (%eax),%eax
 4f5:	0f be c0             	movsbl %al,%eax
 4f8:	83 ec 08             	sub    $0x8,%esp
 4fb:	50                   	push   %eax
 4fc:	ff 75 08             	pushl  0x8(%ebp)
 4ff:	e8 3c ff ff ff       	call   440 <putc>
 504:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 507:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 50b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50f:	79 d9                	jns    4ea <printint+0x87>
    putc(fd, buf[i]);
}
 511:	90                   	nop
 512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 515:	c9                   	leave  
 516:	c3                   	ret    

00000517 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 51d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 524:	8d 45 0c             	lea    0xc(%ebp),%eax
 527:	83 c0 04             	add    $0x4,%eax
 52a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 52d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 534:	e9 59 01 00 00       	jmp    692 <printf+0x17b>
    c = fmt[i] & 0xff;
 539:	8b 55 0c             	mov    0xc(%ebp),%edx
 53c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 53f:	01 d0                	add    %edx,%eax
 541:	0f b6 00             	movzbl (%eax),%eax
 544:	0f be c0             	movsbl %al,%eax
 547:	25 ff 00 00 00       	and    $0xff,%eax
 54c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 54f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 553:	75 2c                	jne    581 <printf+0x6a>
      if(c == '%'){
 555:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 559:	75 0c                	jne    567 <printf+0x50>
        state = '%';
 55b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 562:	e9 27 01 00 00       	jmp    68e <printf+0x177>
      } else {
        putc(fd, c);
 567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 c7 fe ff ff       	call   440 <putc>
 579:	83 c4 10             	add    $0x10,%esp
 57c:	e9 0d 01 00 00       	jmp    68e <printf+0x177>
      }
    } else if(state == '%'){
 581:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 585:	0f 85 03 01 00 00    	jne    68e <printf+0x177>
      if(c == 'd'){
 58b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 58f:	75 1e                	jne    5af <printf+0x98>
        printint(fd, *ap, 10, 1);
 591:	8b 45 e8             	mov    -0x18(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	6a 01                	push   $0x1
 598:	6a 0a                	push   $0xa
 59a:	50                   	push   %eax
 59b:	ff 75 08             	pushl  0x8(%ebp)
 59e:	e8 c0 fe ff ff       	call   463 <printint>
 5a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 5a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5aa:	e9 d8 00 00 00       	jmp    687 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5af:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5b3:	74 06                	je     5bb <printf+0xa4>
 5b5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b9:	75 1e                	jne    5d9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	6a 00                	push   $0x0
 5c2:	6a 10                	push   $0x10
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 96 fe ff ff       	call   463 <printint>
 5cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d4:	e9 ae 00 00 00       	jmp    687 <printf+0x170>
      } else if(c == 's'){
 5d9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5dd:	75 43                	jne    622 <printf+0x10b>
        s = (char*)*ap;
 5df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ef:	75 25                	jne    616 <printf+0xff>
          s = "(null)";
 5f1:	c7 45 f4 04 09 00 00 	movl   $0x904,-0xc(%ebp)
        while(*s != 0){
 5f8:	eb 1c                	jmp    616 <printf+0xff>
          putc(fd, *s);
 5fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fd:	0f b6 00             	movzbl (%eax),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	83 ec 08             	sub    $0x8,%esp
 606:	50                   	push   %eax
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 31 fe ff ff       	call   440 <putc>
 60f:	83 c4 10             	add    $0x10,%esp
          s++;
 612:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 616:	8b 45 f4             	mov    -0xc(%ebp),%eax
 619:	0f b6 00             	movzbl (%eax),%eax
 61c:	84 c0                	test   %al,%al
 61e:	75 da                	jne    5fa <printf+0xe3>
 620:	eb 65                	jmp    687 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 622:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 626:	75 1d                	jne    645 <printf+0x12e>
        putc(fd, *ap);
 628:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	83 ec 08             	sub    $0x8,%esp
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 04 fe ff ff       	call   440 <putc>
 63c:	83 c4 10             	add    $0x10,%esp
        ap++;
 63f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 643:	eb 42                	jmp    687 <printf+0x170>
      } else if(c == '%'){
 645:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 649:	75 17                	jne    662 <printf+0x14b>
        putc(fd, c);
 64b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64e:	0f be c0             	movsbl %al,%eax
 651:	83 ec 08             	sub    $0x8,%esp
 654:	50                   	push   %eax
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 e3 fd ff ff       	call   440 <putc>
 65d:	83 c4 10             	add    $0x10,%esp
 660:	eb 25                	jmp    687 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 662:	83 ec 08             	sub    $0x8,%esp
 665:	6a 25                	push   $0x25
 667:	ff 75 08             	pushl  0x8(%ebp)
 66a:	e8 d1 fd ff ff       	call   440 <putc>
 66f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 675:	0f be c0             	movsbl %al,%eax
 678:	83 ec 08             	sub    $0x8,%esp
 67b:	50                   	push   %eax
 67c:	ff 75 08             	pushl  0x8(%ebp)
 67f:	e8 bc fd ff ff       	call   440 <putc>
 684:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 687:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 68e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 692:	8b 55 0c             	mov    0xc(%ebp),%edx
 695:	8b 45 f0             	mov    -0x10(%ebp),%eax
 698:	01 d0                	add    %edx,%eax
 69a:	0f b6 00             	movzbl (%eax),%eax
 69d:	84 c0                	test   %al,%al
 69f:	0f 85 94 fe ff ff    	jne    539 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a5:	90                   	nop
 6a6:	c9                   	leave  
 6a7:	c3                   	ret    

000006a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ae:	8b 45 08             	mov    0x8(%ebp),%eax
 6b1:	83 e8 08             	sub    $0x8,%eax
 6b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b7:	a1 70 0b 00 00       	mov    0xb70,%eax
 6bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6bf:	eb 24                	jmp    6e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c9:	77 12                	ja     6dd <free+0x35>
 6cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d1:	77 24                	ja     6f7 <free+0x4f>
 6d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d6:	8b 00                	mov    (%eax),%eax
 6d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6db:	77 1a                	ja     6f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6eb:	76 d4                	jbe    6c1 <free+0x19>
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f5:	76 ca                	jbe    6c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	01 c2                	add    %eax,%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	39 c2                	cmp    %eax,%edx
 710:	75 24                	jne    736 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 50 04             	mov    0x4(%eax),%edx
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	8b 40 04             	mov    0x4(%eax),%eax
 720:	01 c2                	add    %eax,%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	8b 10                	mov    (%eax),%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	89 10                	mov    %edx,(%eax)
 734:	eb 0a                	jmp    740 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 10                	mov    (%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	8b 40 04             	mov    0x4(%eax),%eax
 746:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	01 d0                	add    %edx,%eax
 752:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 755:	75 20                	jne    777 <free+0xcf>
    p->s.size += bp->s.size;
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 50 04             	mov    0x4(%eax),%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	01 c2                	add    %eax,%edx
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	89 10                	mov    %edx,(%eax)
 775:	eb 08                	jmp    77f <free+0xd7>
  } else
    p->s.ptr = bp;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 77d:	89 10                	mov    %edx,(%eax)
  freep = p;
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 787:	90                   	nop
 788:	c9                   	leave  
 789:	c3                   	ret    

0000078a <morecore>:

static Header*
morecore(uint nu)
{
 78a:	55                   	push   %ebp
 78b:	89 e5                	mov    %esp,%ebp
 78d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 790:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 797:	77 07                	ja     7a0 <morecore+0x16>
    nu = 4096;
 799:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	c1 e0 03             	shl    $0x3,%eax
 7a6:	83 ec 0c             	sub    $0xc,%esp
 7a9:	50                   	push   %eax
 7aa:	e8 39 fc ff ff       	call   3e8 <sbrk>
 7af:	83 c4 10             	add    $0x10,%esp
 7b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b9:	75 07                	jne    7c2 <morecore+0x38>
    return 0;
 7bb:	b8 00 00 00 00       	mov    $0x0,%eax
 7c0:	eb 26                	jmp    7e8 <morecore+0x5e>
  hp = (Header*)p;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cb:	8b 55 08             	mov    0x8(%ebp),%edx
 7ce:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	83 c0 08             	add    $0x8,%eax
 7d7:	83 ec 0c             	sub    $0xc,%esp
 7da:	50                   	push   %eax
 7db:	e8 c8 fe ff ff       	call   6a8 <free>
 7e0:	83 c4 10             	add    $0x10,%esp
  return freep;
 7e3:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7e8:	c9                   	leave  
 7e9:	c3                   	ret    

000007ea <malloc>:

void*
malloc(uint nbytes)
{
 7ea:	55                   	push   %ebp
 7eb:	89 e5                	mov    %esp,%ebp
 7ed:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f0:	8b 45 08             	mov    0x8(%ebp),%eax
 7f3:	83 c0 07             	add    $0x7,%eax
 7f6:	c1 e8 03             	shr    $0x3,%eax
 7f9:	83 c0 01             	add    $0x1,%eax
 7fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ff:	a1 70 0b 00 00       	mov    0xb70,%eax
 804:	89 45 f0             	mov    %eax,-0x10(%ebp)
 807:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80b:	75 23                	jne    830 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 80d:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 814:	8b 45 f0             	mov    -0x10(%ebp),%eax
 817:	a3 70 0b 00 00       	mov    %eax,0xb70
 81c:	a1 70 0b 00 00       	mov    0xb70,%eax
 821:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 826:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 82d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	8b 45 f0             	mov    -0x10(%ebp),%eax
 833:	8b 00                	mov    (%eax),%eax
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 841:	72 4d                	jb     890 <malloc+0xa6>
      if(p->s.size == nunits)
 843:	8b 45 f4             	mov    -0xc(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84c:	75 0c                	jne    85a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8b 10                	mov    (%eax),%edx
 853:	8b 45 f0             	mov    -0x10(%ebp),%eax
 856:	89 10                	mov    %edx,(%eax)
 858:	eb 26                	jmp    880 <malloc+0x96>
      else {
        p->s.size -= nunits;
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 40 04             	mov    0x4(%eax),%eax
 860:	2b 45 ec             	sub    -0x14(%ebp),%eax
 863:	89 c2                	mov    %eax,%edx
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	c1 e0 03             	shl    $0x3,%eax
 874:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 87d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	83 c0 08             	add    $0x8,%eax
 88e:	eb 3b                	jmp    8cb <malloc+0xe1>
    }
    if(p == freep)
 890:	a1 70 0b 00 00       	mov    0xb70,%eax
 895:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 898:	75 1e                	jne    8b8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 89a:	83 ec 0c             	sub    $0xc,%esp
 89d:	ff 75 ec             	pushl  -0x14(%ebp)
 8a0:	e8 e5 fe ff ff       	call   78a <morecore>
 8a5:	83 c4 10             	add    $0x10,%esp
 8a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8af:	75 07                	jne    8b8 <malloc+0xce>
        return 0;
 8b1:	b8 00 00 00 00       	mov    $0x0,%eax
 8b6:	eb 13                	jmp    8cb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c6:	e9 6d ff ff ff       	jmp    838 <malloc+0x4e>
}
 8cb:	c9                   	leave  
 8cc:	c3                   	ret    
