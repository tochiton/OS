
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <forkTest>:
#include "types.h"
#include "user.h"

static void 
forkTest(uint nval){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
 uint uid, gid;
 int pid; 
 printf(1, "setting UID to: %d and Setting GID to: %d before fork()", nval, nval);
   6:	ff 75 08             	pushl  0x8(%ebp)
   9:	ff 75 08             	pushl  0x8(%ebp)
   c:	68 d4 09 00 00       	push   $0x9d4
  11:	6a 01                	push   $0x1
  13:	e8 06 06 00 00       	call   61e <printf>
  18:	83 c4 10             	add    $0x10,%esp
 
 if(setuid(nval) < 0)
  1b:	83 ec 0c             	sub    $0xc,%esp
  1e:	ff 75 08             	pushl  0x8(%ebp)
  21:	e8 09 05 00 00       	call   52f <setuid>
  26:	83 c4 10             	add    $0x10,%esp
  29:	85 c0                	test   %eax,%eax
  2b:	79 15                	jns    42 <forkTest+0x42>
   printf(2, "Invalid uid %d", nval);
  2d:	83 ec 04             	sub    $0x4,%esp
  30:	ff 75 08             	pushl  0x8(%ebp)
  33:	68 0c 0a 00 00       	push   $0xa0c
  38:	6a 02                	push   $0x2
  3a:	e8 df 05 00 00       	call   61e <printf>
  3f:	83 c4 10             	add    $0x10,%esp
 // do the same for gid
 // run getuid and getgid and print content before fork

 pid = fork();
  42:	e8 18 04 00 00       	call   45f <fork>
  47:	89 45 f4             	mov    %eax,-0xc(%ebp)
 if(pid == 0){
  4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4e:	75 3a                	jne    8a <forkTest+0x8a>
   uid = getuid();
  50:	e8 c2 04 00 00       	call   517 <getuid>
  55:	89 45 f0             	mov    %eax,-0x10(%ebp)
   gid = getgid();
  58:	e8 c2 04 00 00       	call   51f <getgid>
  5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
   printf(1, "Child UID is: %d, GID is: %d\n", uid, gid);
  60:	ff 75 ec             	pushl  -0x14(%ebp)
  63:	ff 75 f0             	pushl  -0x10(%ebp)
  66:	68 1b 0a 00 00       	push   $0xa1b
  6b:	6a 01                	push   $0x1
  6d:	e8 ac 05 00 00       	call   61e <printf>
  72:	83 c4 10             	add    $0x10,%esp
   sleep(2* TPS);
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	68 d0 07 00 00       	push   $0x7d0
  7d:	e8 75 04 00 00       	call   4f7 <sleep>
  82:	83 c4 10             	add    $0x10,%esp
   exit(); 
  85:	e8 dd 03 00 00       	call   467 <exit>
 }else
   sleep(2* TPS);
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	68 d0 07 00 00       	push   $0x7d0
  92:	e8 60 04 00 00       	call   4f7 <sleep>
  97:	83 c4 10             	add    $0x10,%esp
  

}
  9a:	90                   	nop
  9b:	c9                   	leave  
  9c:	c3                   	ret    

0000009d <testuidgid>:

int
testuidgid(void){
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	83 ec 18             	sub    $0x18,%esp
  uint uid, gid, ppid;
  // check for out of range value for negative test  
  forkTest(111);
  a3:	83 ec 0c             	sub    $0xc,%esp
  a6:	6a 6f                	push   $0x6f
  a8:	e8 53 ff ff ff       	call   0 <forkTest>
  ad:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  b0:	e8 62 04 00 00       	call   517 <getuid>
  b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
  b8:	83 ec 04             	sub    $0x4,%esp
  bb:	ff 75 f4             	pushl  -0xc(%ebp)
  be:	68 39 0a 00 00       	push   $0xa39
  c3:	6a 02                	push   $0x2
  c5:	e8 54 05 00 00       	call   61e <printf>
  ca:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting UID to 100\n");
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	68 4d 0a 00 00       	push   $0xa4d
  d5:	6a 02                	push   $0x2
  d7:	e8 42 05 00 00       	call   61e <printf>
  dc:	83 c4 10             	add    $0x10,%esp
  setuid(100);
  df:	83 ec 0c             	sub    $0xc,%esp
  e2:	6a 64                	push   $0x64
  e4:	e8 46 04 00 00       	call   52f <setuid>
  e9:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  ec:	e8 26 04 00 00       	call   517 <getuid>
  f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
  f4:	83 ec 04             	sub    $0x4,%esp
  f7:	ff 75 f4             	pushl  -0xc(%ebp)
  fa:	68 39 0a 00 00       	push   $0xa39
  ff:	6a 02                	push   $0x2
 101:	e8 18 05 00 00       	call   61e <printf>
 106:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 109:	e8 11 04 00 00       	call   51f <getgid>
 10e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
 111:	83 ec 04             	sub    $0x4,%esp
 114:	ff 75 f0             	pushl  -0x10(%ebp)
 117:	68 61 0a 00 00       	push   $0xa61
 11c:	6a 02                	push   $0x2
 11e:	e8 fb 04 00 00       	call   61e <printf>
 123:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting GID to 100\n");
 126:	83 ec 08             	sub    $0x8,%esp
 129:	68 75 0a 00 00       	push   $0xa75
 12e:	6a 02                	push   $0x2
 130:	e8 e9 04 00 00       	call   61e <printf>
 135:	83 c4 10             	add    $0x10,%esp
  setgid(100);
 138:	83 ec 0c             	sub    $0xc,%esp
 13b:	6a 64                	push   $0x64
 13d:	e8 f5 03 00 00       	call   537 <setgid>
 142:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
 145:	e8 d5 03 00 00       	call   51f <getgid>
 14a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	ff 75 f0             	pushl  -0x10(%ebp)
 153:	68 61 0a 00 00       	push   $0xa61
 158:	6a 02                	push   $0x2
 15a:	e8 bf 04 00 00       	call   61e <printf>
 15f:	83 c4 10             	add    $0x10,%esp

  ppid = getppid();
 162:	e8 c0 03 00 00       	call   527 <getppid>
 167:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(2, "My parent process  is: %d\n", ppid);
 16a:	83 ec 04             	sub    $0x4,%esp
 16d:	ff 75 ec             	pushl  -0x14(%ebp)
 170:	68 89 0a 00 00       	push   $0xa89
 175:	6a 02                	push   $0x2
 177:	e8 a2 04 00 00       	call   61e <printf>
 17c:	83 c4 10             	add    $0x10,%esp
  printf(2, "Done!\n");
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	68 a4 0a 00 00       	push   $0xaa4
 187:	6a 02                	push   $0x2
 189:	e8 90 04 00 00       	call   61e <printf>
 18e:	83 c4 10             	add    $0x10,%esp
  
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <main>:

int
main(int argc, char *argv[])
{
 198:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 19c:	83 e4 f0             	and    $0xfffffff0,%esp
 19f:	ff 71 fc             	pushl  -0x4(%ecx)
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	51                   	push   %ecx
 1a6:	83 ec 14             	sub    $0x14,%esp
  int temp = testuidgid(); 
 1a9:	e8 ef fe ff ff       	call   9d <testuidgid>
 1ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"temp: %d\n", temp); 
 1b1:	83 ec 04             	sub    $0x4,%esp
 1b4:	ff 75 f4             	pushl  -0xc(%ebp)
 1b7:	68 ab 0a 00 00       	push   $0xaab
 1bc:	6a 01                	push   $0x1
 1be:	e8 5b 04 00 00       	call   61e <printf>
 1c3:	83 c4 10             	add    $0x10,%esp
  exit();
 1c6:	e8 9c 02 00 00       	call   467 <exit>

000001cb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	57                   	push   %edi
 1cf:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d3:	8b 55 10             	mov    0x10(%ebp),%edx
 1d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d9:	89 cb                	mov    %ecx,%ebx
 1db:	89 df                	mov    %ebx,%edi
 1dd:	89 d1                	mov    %edx,%ecx
 1df:	fc                   	cld    
 1e0:	f3 aa                	rep stos %al,%es:(%edi)
 1e2:	89 ca                	mov    %ecx,%edx
 1e4:	89 fb                	mov    %edi,%ebx
 1e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1ec:	90                   	nop
 1ed:	5b                   	pop    %ebx
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    

000001f1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1fd:	90                   	nop
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	8d 50 01             	lea    0x1(%eax),%edx
 204:	89 55 08             	mov    %edx,0x8(%ebp)
 207:	8b 55 0c             	mov    0xc(%ebp),%edx
 20a:	8d 4a 01             	lea    0x1(%edx),%ecx
 20d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 210:	0f b6 12             	movzbl (%edx),%edx
 213:	88 10                	mov    %dl,(%eax)
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	84 c0                	test   %al,%al
 21a:	75 e2                	jne    1fe <strcpy+0xd>
    ;
  return os;
 21c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 224:	eb 08                	jmp    22e <strcmp+0xd>
    p++, q++;
 226:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 22a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	84 c0                	test   %al,%al
 236:	74 10                	je     248 <strcmp+0x27>
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 10             	movzbl (%eax),%edx
 23e:	8b 45 0c             	mov    0xc(%ebp),%eax
 241:	0f b6 00             	movzbl (%eax),%eax
 244:	38 c2                	cmp    %al,%dl
 246:	74 de                	je     226 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	0f b6 d0             	movzbl %al,%edx
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	0f b6 c0             	movzbl %al,%eax
 25a:	29 c2                	sub    %eax,%edx
 25c:	89 d0                	mov    %edx,%eax
}
 25e:	5d                   	pop    %ebp
 25f:	c3                   	ret    

00000260 <strlen>:

uint
strlen(char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26d:	eb 04                	jmp    273 <strlen+0x13>
 26f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 273:	8b 55 fc             	mov    -0x4(%ebp),%edx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	01 d0                	add    %edx,%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	84 c0                	test   %al,%al
 280:	75 ed                	jne    26f <strlen+0xf>
    ;
  return n;
 282:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <memset>:

void*
memset(void *dst, int c, uint n)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 28a:	8b 45 10             	mov    0x10(%ebp),%eax
 28d:	50                   	push   %eax
 28e:	ff 75 0c             	pushl  0xc(%ebp)
 291:	ff 75 08             	pushl  0x8(%ebp)
 294:	e8 32 ff ff ff       	call   1cb <stosb>
 299:	83 c4 0c             	add    $0xc,%esp
  return dst;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29f:	c9                   	leave  
 2a0:	c3                   	ret    

000002a1 <strchr>:

char*
strchr(const char *s, char c)
{
 2a1:	55                   	push   %ebp
 2a2:	89 e5                	mov    %esp,%ebp
 2a4:	83 ec 04             	sub    $0x4,%esp
 2a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2aa:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ad:	eb 14                	jmp    2c3 <strchr+0x22>
    if(*s == c)
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	0f b6 00             	movzbl (%eax),%eax
 2b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b8:	75 05                	jne    2bf <strchr+0x1e>
      return (char*)s;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	eb 13                	jmp    2d2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	84 c0                	test   %al,%al
 2cb:	75 e2                	jne    2af <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <gets>:

char*
gets(char *buf, int max)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e1:	eb 42                	jmp    325 <gets+0x51>
    cc = read(0, &c, 1);
 2e3:	83 ec 04             	sub    $0x4,%esp
 2e6:	6a 01                	push   $0x1
 2e8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2eb:	50                   	push   %eax
 2ec:	6a 00                	push   $0x0
 2ee:	e8 8c 01 00 00       	call   47f <read>
 2f3:	83 c4 10             	add    $0x10,%esp
 2f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2fd:	7e 33                	jle    332 <gets+0x5e>
      break;
    buf[i++] = c;
 2ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 302:	8d 50 01             	lea    0x1(%eax),%edx
 305:	89 55 f4             	mov    %edx,-0xc(%ebp)
 308:	89 c2                	mov    %eax,%edx
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	01 c2                	add    %eax,%edx
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 315:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 319:	3c 0a                	cmp    $0xa,%al
 31b:	74 16                	je     333 <gets+0x5f>
 31d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 321:	3c 0d                	cmp    $0xd,%al
 323:	74 0e                	je     333 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 325:	8b 45 f4             	mov    -0xc(%ebp),%eax
 328:	83 c0 01             	add    $0x1,%eax
 32b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 32e:	7c b3                	jl     2e3 <gets+0xf>
 330:	eb 01                	jmp    333 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 332:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 333:	8b 55 f4             	mov    -0xc(%ebp),%edx
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	01 d0                	add    %edx,%eax
 33b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <stat>:

int
stat(char *n, struct stat *st)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	6a 00                	push   $0x0
 34e:	ff 75 08             	pushl  0x8(%ebp)
 351:	e8 51 01 00 00       	call   4a7 <open>
 356:	83 c4 10             	add    $0x10,%esp
 359:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 35c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 360:	79 07                	jns    369 <stat+0x26>
    return -1;
 362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 367:	eb 25                	jmp    38e <stat+0x4b>
  r = fstat(fd, st);
 369:	83 ec 08             	sub    $0x8,%esp
 36c:	ff 75 0c             	pushl  0xc(%ebp)
 36f:	ff 75 f4             	pushl  -0xc(%ebp)
 372:	e8 48 01 00 00       	call   4bf <fstat>
 377:	83 c4 10             	add    $0x10,%esp
 37a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 37d:	83 ec 0c             	sub    $0xc,%esp
 380:	ff 75 f4             	pushl  -0xc(%ebp)
 383:	e8 07 01 00 00       	call   48f <close>
 388:	83 c4 10             	add    $0x10,%esp
  return r;
 38b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <atoi>:

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 39d:	eb 04                	jmp    3a3 <atoi+0x13>
 39f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 00             	movzbl (%eax),%eax
 3a9:	3c 20                	cmp    $0x20,%al
 3ab:	74 f2                	je     39f <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	3c 2d                	cmp    $0x2d,%al
 3b5:	75 07                	jne    3be <atoi+0x2e>
 3b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3bc:	eb 05                	jmp    3c3 <atoi+0x33>
 3be:	b8 01 00 00 00       	mov    $0x1,%eax
 3c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	0f b6 00             	movzbl (%eax),%eax
 3cc:	3c 2b                	cmp    $0x2b,%al
 3ce:	74 0a                	je     3da <atoi+0x4a>
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	0f b6 00             	movzbl (%eax),%eax
 3d6:	3c 2d                	cmp    $0x2d,%al
 3d8:	75 2b                	jne    405 <atoi+0x75>
    s++;
 3da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3de:	eb 25                	jmp    405 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e3:	89 d0                	mov    %edx,%eax
 3e5:	c1 e0 02             	shl    $0x2,%eax
 3e8:	01 d0                	add    %edx,%eax
 3ea:	01 c0                	add    %eax,%eax
 3ec:	89 c1                	mov    %eax,%ecx
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	8d 50 01             	lea    0x1(%eax),%edx
 3f4:	89 55 08             	mov    %edx,0x8(%ebp)
 3f7:	0f b6 00             	movzbl (%eax),%eax
 3fa:	0f be c0             	movsbl %al,%eax
 3fd:	01 c8                	add    %ecx,%eax
 3ff:	83 e8 30             	sub    $0x30,%eax
 402:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	0f b6 00             	movzbl (%eax),%eax
 40b:	3c 2f                	cmp    $0x2f,%al
 40d:	7e 0a                	jle    419 <atoi+0x89>
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	3c 39                	cmp    $0x39,%al
 417:	7e c7                	jle    3e0 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 419:	8b 45 f8             	mov    -0x8(%ebp),%eax
 41c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 434:	eb 17                	jmp    44d <memmove+0x2b>
    *dst++ = *src++;
 436:	8b 45 fc             	mov    -0x4(%ebp),%eax
 439:	8d 50 01             	lea    0x1(%eax),%edx
 43c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 43f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 442:	8d 4a 01             	lea    0x1(%edx),%ecx
 445:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 448:	0f b6 12             	movzbl (%edx),%edx
 44b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 44d:	8b 45 10             	mov    0x10(%ebp),%eax
 450:	8d 50 ff             	lea    -0x1(%eax),%edx
 453:	89 55 10             	mov    %edx,0x10(%ebp)
 456:	85 c0                	test   %eax,%eax
 458:	7f dc                	jg     436 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 45d:	c9                   	leave  
 45e:	c3                   	ret    

0000045f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45f:	b8 01 00 00 00       	mov    $0x1,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <exit>:
SYSCALL(exit)
 467:	b8 02 00 00 00       	mov    $0x2,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <wait>:
SYSCALL(wait)
 46f:	b8 03 00 00 00       	mov    $0x3,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <pipe>:
SYSCALL(pipe)
 477:	b8 04 00 00 00       	mov    $0x4,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <read>:
SYSCALL(read)
 47f:	b8 05 00 00 00       	mov    $0x5,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <write>:
SYSCALL(write)
 487:	b8 10 00 00 00       	mov    $0x10,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <close>:
SYSCALL(close)
 48f:	b8 15 00 00 00       	mov    $0x15,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <kill>:
SYSCALL(kill)
 497:	b8 06 00 00 00       	mov    $0x6,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <exec>:
SYSCALL(exec)
 49f:	b8 07 00 00 00       	mov    $0x7,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <open>:
SYSCALL(open)
 4a7:	b8 0f 00 00 00       	mov    $0xf,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <mknod>:
SYSCALL(mknod)
 4af:	b8 11 00 00 00       	mov    $0x11,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <unlink>:
SYSCALL(unlink)
 4b7:	b8 12 00 00 00       	mov    $0x12,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <fstat>:
SYSCALL(fstat)
 4bf:	b8 08 00 00 00       	mov    $0x8,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <link>:
SYSCALL(link)
 4c7:	b8 13 00 00 00       	mov    $0x13,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <mkdir>:
SYSCALL(mkdir)
 4cf:	b8 14 00 00 00       	mov    $0x14,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <chdir>:
SYSCALL(chdir)
 4d7:	b8 09 00 00 00       	mov    $0x9,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <dup>:
SYSCALL(dup)
 4df:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <getpid>:
SYSCALL(getpid)
 4e7:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <sbrk>:
SYSCALL(sbrk)
 4ef:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <sleep>:
SYSCALL(sleep)
 4f7:	b8 0d 00 00 00       	mov    $0xd,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <uptime>:
SYSCALL(uptime)
 4ff:	b8 0e 00 00 00       	mov    $0xe,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <halt>:
SYSCALL(halt)
 507:	b8 16 00 00 00       	mov    $0x16,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <date>:
SYSCALL(date)
 50f:	b8 17 00 00 00       	mov    $0x17,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <getuid>:
SYSCALL(getuid)
 517:	b8 18 00 00 00       	mov    $0x18,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <getgid>:
SYSCALL(getgid)
 51f:	b8 19 00 00 00       	mov    $0x19,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <getppid>:
SYSCALL(getppid)
 527:	b8 1a 00 00 00       	mov    $0x1a,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <setuid>:
SYSCALL(setuid)
 52f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <setgid>:
SYSCALL(setgid)
 537:	b8 1c 00 00 00       	mov    $0x1c,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <getprocs>:
SYSCALL(getprocs)
 53f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	83 ec 18             	sub    $0x18,%esp
 54d:	8b 45 0c             	mov    0xc(%ebp),%eax
 550:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 553:	83 ec 04             	sub    $0x4,%esp
 556:	6a 01                	push   $0x1
 558:	8d 45 f4             	lea    -0xc(%ebp),%eax
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 23 ff ff ff       	call   487 <write>
 564:	83 c4 10             	add    $0x10,%esp
}
 567:	90                   	nop
 568:	c9                   	leave  
 569:	c3                   	ret    

0000056a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 56a:	55                   	push   %ebp
 56b:	89 e5                	mov    %esp,%ebp
 56d:	53                   	push   %ebx
 56e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 578:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 57c:	74 17                	je     595 <printint+0x2b>
 57e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 582:	79 11                	jns    595 <printint+0x2b>
    neg = 1;
 584:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 58b:	8b 45 0c             	mov    0xc(%ebp),%eax
 58e:	f7 d8                	neg    %eax
 590:	89 45 ec             	mov    %eax,-0x14(%ebp)
 593:	eb 06                	jmp    59b <printint+0x31>
  } else {
    x = xx;
 595:	8b 45 0c             	mov    0xc(%ebp),%eax
 598:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 59b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5a5:	8d 41 01             	lea    0x1(%ecx),%eax
 5a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b1:	ba 00 00 00 00       	mov    $0x0,%edx
 5b6:	f7 f3                	div    %ebx
 5b8:	89 d0                	mov    %edx,%eax
 5ba:	0f b6 80 44 0d 00 00 	movzbl 0xd44(%eax),%eax
 5c1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5cb:	ba 00 00 00 00       	mov    $0x0,%edx
 5d0:	f7 f3                	div    %ebx
 5d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d9:	75 c7                	jne    5a2 <printint+0x38>
  if(neg)
 5db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5df:	74 2d                	je     60e <printint+0xa4>
    buf[i++] = '-';
 5e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e4:	8d 50 01             	lea    0x1(%eax),%edx
 5e7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ea:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5ef:	eb 1d                	jmp    60e <printint+0xa4>
    putc(fd, buf[i]);
 5f1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f7:	01 d0                	add    %edx,%eax
 5f9:	0f b6 00             	movzbl (%eax),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	83 ec 08             	sub    $0x8,%esp
 602:	50                   	push   %eax
 603:	ff 75 08             	pushl  0x8(%ebp)
 606:	e8 3c ff ff ff       	call   547 <putc>
 60b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 60e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 616:	79 d9                	jns    5f1 <printint+0x87>
    putc(fd, buf[i]);
}
 618:	90                   	nop
 619:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 61c:	c9                   	leave  
 61d:	c3                   	ret    

0000061e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 61e:	55                   	push   %ebp
 61f:	89 e5                	mov    %esp,%ebp
 621:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 624:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 62b:	8d 45 0c             	lea    0xc(%ebp),%eax
 62e:	83 c0 04             	add    $0x4,%eax
 631:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 634:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 63b:	e9 59 01 00 00       	jmp    799 <printf+0x17b>
    c = fmt[i] & 0xff;
 640:	8b 55 0c             	mov    0xc(%ebp),%edx
 643:	8b 45 f0             	mov    -0x10(%ebp),%eax
 646:	01 d0                	add    %edx,%eax
 648:	0f b6 00             	movzbl (%eax),%eax
 64b:	0f be c0             	movsbl %al,%eax
 64e:	25 ff 00 00 00       	and    $0xff,%eax
 653:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 656:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 65a:	75 2c                	jne    688 <printf+0x6a>
      if(c == '%'){
 65c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 660:	75 0c                	jne    66e <printf+0x50>
        state = '%';
 662:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 669:	e9 27 01 00 00       	jmp    795 <printf+0x177>
      } else {
        putc(fd, c);
 66e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 671:	0f be c0             	movsbl %al,%eax
 674:	83 ec 08             	sub    $0x8,%esp
 677:	50                   	push   %eax
 678:	ff 75 08             	pushl  0x8(%ebp)
 67b:	e8 c7 fe ff ff       	call   547 <putc>
 680:	83 c4 10             	add    $0x10,%esp
 683:	e9 0d 01 00 00       	jmp    795 <printf+0x177>
      }
    } else if(state == '%'){
 688:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 68c:	0f 85 03 01 00 00    	jne    795 <printf+0x177>
      if(c == 'd'){
 692:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 696:	75 1e                	jne    6b6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 698:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69b:	8b 00                	mov    (%eax),%eax
 69d:	6a 01                	push   $0x1
 69f:	6a 0a                	push   $0xa
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	e8 c0 fe ff ff       	call   56a <printint>
 6aa:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b1:	e9 d8 00 00 00       	jmp    78e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6b6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ba:	74 06                	je     6c2 <printf+0xa4>
 6bc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6c0:	75 1e                	jne    6e0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	6a 00                	push   $0x0
 6c9:	6a 10                	push   $0x10
 6cb:	50                   	push   %eax
 6cc:	ff 75 08             	pushl  0x8(%ebp)
 6cf:	e8 96 fe ff ff       	call   56a <printint>
 6d4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6db:	e9 ae 00 00 00       	jmp    78e <printf+0x170>
      } else if(c == 's'){
 6e0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6e4:	75 43                	jne    729 <printf+0x10b>
        s = (char*)*ap;
 6e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6f6:	75 25                	jne    71d <printf+0xff>
          s = "(null)";
 6f8:	c7 45 f4 b5 0a 00 00 	movl   $0xab5,-0xc(%ebp)
        while(*s != 0){
 6ff:	eb 1c                	jmp    71d <printf+0xff>
          putc(fd, *s);
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	0f be c0             	movsbl %al,%eax
 70a:	83 ec 08             	sub    $0x8,%esp
 70d:	50                   	push   %eax
 70e:	ff 75 08             	pushl  0x8(%ebp)
 711:	e8 31 fe ff ff       	call   547 <putc>
 716:	83 c4 10             	add    $0x10,%esp
          s++;
 719:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 71d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 720:	0f b6 00             	movzbl (%eax),%eax
 723:	84 c0                	test   %al,%al
 725:	75 da                	jne    701 <printf+0xe3>
 727:	eb 65                	jmp    78e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 729:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 72d:	75 1d                	jne    74c <printf+0x12e>
        putc(fd, *ap);
 72f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	0f be c0             	movsbl %al,%eax
 737:	83 ec 08             	sub    $0x8,%esp
 73a:	50                   	push   %eax
 73b:	ff 75 08             	pushl  0x8(%ebp)
 73e:	e8 04 fe ff ff       	call   547 <putc>
 743:	83 c4 10             	add    $0x10,%esp
        ap++;
 746:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74a:	eb 42                	jmp    78e <printf+0x170>
      } else if(c == '%'){
 74c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 750:	75 17                	jne    769 <printf+0x14b>
        putc(fd, c);
 752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 755:	0f be c0             	movsbl %al,%eax
 758:	83 ec 08             	sub    $0x8,%esp
 75b:	50                   	push   %eax
 75c:	ff 75 08             	pushl  0x8(%ebp)
 75f:	e8 e3 fd ff ff       	call   547 <putc>
 764:	83 c4 10             	add    $0x10,%esp
 767:	eb 25                	jmp    78e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 769:	83 ec 08             	sub    $0x8,%esp
 76c:	6a 25                	push   $0x25
 76e:	ff 75 08             	pushl  0x8(%ebp)
 771:	e8 d1 fd ff ff       	call   547 <putc>
 776:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 779:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77c:	0f be c0             	movsbl %al,%eax
 77f:	83 ec 08             	sub    $0x8,%esp
 782:	50                   	push   %eax
 783:	ff 75 08             	pushl  0x8(%ebp)
 786:	e8 bc fd ff ff       	call   547 <putc>
 78b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 78e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 795:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 799:	8b 55 0c             	mov    0xc(%ebp),%edx
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	01 d0                	add    %edx,%eax
 7a1:	0f b6 00             	movzbl (%eax),%eax
 7a4:	84 c0                	test   %al,%al
 7a6:	0f 85 94 fe ff ff    	jne    640 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7ac:	90                   	nop
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	83 e8 08             	sub    $0x8,%eax
 7bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	a1 60 0d 00 00       	mov    0xd60,%eax
 7c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c6:	eb 24                	jmp    7ec <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d0:	77 12                	ja     7e4 <free+0x35>
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d8:	77 24                	ja     7fe <free+0x4f>
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e2:	77 1a                	ja     7fe <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ef:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f2:	76 d4                	jbe    7c8 <free+0x19>
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fc:	76 ca                	jbe    7c8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 801:	8b 40 04             	mov    0x4(%eax),%eax
 804:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	01 c2                	add    %eax,%edx
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	39 c2                	cmp    %eax,%edx
 817:	75 24                	jne    83d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 819:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81c:	8b 50 04             	mov    0x4(%eax),%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	01 c2                	add    %eax,%edx
 829:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	8b 10                	mov    (%eax),%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	89 10                	mov    %edx,(%eax)
 83b:	eb 0a                	jmp    847 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 83d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 840:	8b 10                	mov    (%eax),%edx
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	01 d0                	add    %edx,%eax
 859:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85c:	75 20                	jne    87e <free+0xcf>
    p->s.size += bp->s.size;
 85e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 861:	8b 50 04             	mov    0x4(%eax),%edx
 864:	8b 45 f8             	mov    -0x8(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	01 c2                	add    %eax,%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 872:	8b 45 f8             	mov    -0x8(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 08                	jmp    886 <free+0xd7>
  } else
    p->s.ptr = bp;
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 55 f8             	mov    -0x8(%ebp),%edx
 884:	89 10                	mov    %edx,(%eax)
  freep = p;
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	a3 60 0d 00 00       	mov    %eax,0xd60
}
 88e:	90                   	nop
 88f:	c9                   	leave  
 890:	c3                   	ret    

00000891 <morecore>:

static Header*
morecore(uint nu)
{
 891:	55                   	push   %ebp
 892:	89 e5                	mov    %esp,%ebp
 894:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 897:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 89e:	77 07                	ja     8a7 <morecore+0x16>
    nu = 4096;
 8a0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	c1 e0 03             	shl    $0x3,%eax
 8ad:	83 ec 0c             	sub    $0xc,%esp
 8b0:	50                   	push   %eax
 8b1:	e8 39 fc ff ff       	call   4ef <sbrk>
 8b6:	83 c4 10             	add    $0x10,%esp
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8bc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c0:	75 07                	jne    8c9 <morecore+0x38>
    return 0;
 8c2:	b8 00 00 00 00       	mov    $0x0,%eax
 8c7:	eb 26                	jmp    8ef <morecore+0x5e>
  hp = (Header*)p;
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d2:	8b 55 08             	mov    0x8(%ebp),%edx
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8db:	83 c0 08             	add    $0x8,%eax
 8de:	83 ec 0c             	sub    $0xc,%esp
 8e1:	50                   	push   %eax
 8e2:	e8 c8 fe ff ff       	call   7af <free>
 8e7:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ea:	a1 60 0d 00 00       	mov    0xd60,%eax
}
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    

000008f1 <malloc>:

void*
malloc(uint nbytes)
{
 8f1:	55                   	push   %ebp
 8f2:	89 e5                	mov    %esp,%ebp
 8f4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	83 c0 07             	add    $0x7,%eax
 8fd:	c1 e8 03             	shr    $0x3,%eax
 900:	83 c0 01             	add    $0x1,%eax
 903:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 906:	a1 60 0d 00 00       	mov    0xd60,%eax
 90b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 912:	75 23                	jne    937 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 914:	c7 45 f0 58 0d 00 00 	movl   $0xd58,-0x10(%ebp)
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	a3 60 0d 00 00       	mov    %eax,0xd60
 923:	a1 60 0d 00 00       	mov    0xd60,%eax
 928:	a3 58 0d 00 00       	mov    %eax,0xd58
    base.s.size = 0;
 92d:	c7 05 5c 0d 00 00 00 	movl   $0x0,0xd5c
 934:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 937:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93a:	8b 00                	mov    (%eax),%eax
 93c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 40 04             	mov    0x4(%eax),%eax
 945:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 948:	72 4d                	jb     997 <malloc+0xa6>
      if(p->s.size == nunits)
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	8b 40 04             	mov    0x4(%eax),%eax
 950:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 953:	75 0c                	jne    961 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	8b 10                	mov    (%eax),%edx
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	89 10                	mov    %edx,(%eax)
 95f:	eb 26                	jmp    987 <malloc+0x96>
      else {
        p->s.size -= nunits;
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	8b 40 04             	mov    0x4(%eax),%eax
 967:	2b 45 ec             	sub    -0x14(%ebp),%eax
 96a:	89 c2                	mov    %eax,%edx
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	8b 40 04             	mov    0x4(%eax),%eax
 978:	c1 e0 03             	shl    $0x3,%eax
 97b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	8b 55 ec             	mov    -0x14(%ebp),%edx
 984:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 987:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98a:	a3 60 0d 00 00       	mov    %eax,0xd60
      return (void*)(p + 1);
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	83 c0 08             	add    $0x8,%eax
 995:	eb 3b                	jmp    9d2 <malloc+0xe1>
    }
    if(p == freep)
 997:	a1 60 0d 00 00       	mov    0xd60,%eax
 99c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 99f:	75 1e                	jne    9bf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9a1:	83 ec 0c             	sub    $0xc,%esp
 9a4:	ff 75 ec             	pushl  -0x14(%ebp)
 9a7:	e8 e5 fe ff ff       	call   891 <morecore>
 9ac:	83 c4 10             	add    $0x10,%esp
 9af:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b6:	75 07                	jne    9bf <malloc+0xce>
        return 0;
 9b8:	b8 00 00 00 00       	mov    $0x0,%eax
 9bd:	eb 13                	jmp    9d2 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8b 00                	mov    (%eax),%eax
 9ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9cd:	e9 6d ff ff ff       	jmp    93f <malloc+0x4e>
}
 9d2:	c9                   	leave  
 9d3:	c3                   	ret    
