
_testuidgid:     file format elf32-i386


Disassembly of section .text:

00000000 <testuidgid>:
#include "types.h"
#include "user.h"

int
testuidgid(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  uint uid, gid, ppid;
  
  uid = getuid();
   6:	e8 62 04 00 00       	call   46d <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 22 09 00 00       	push   $0x922
  19:	6a 02                	push   $0x2
  1b:	e8 4c 05 00 00       	call   56c <printf>
  20:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting UID to 100\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 36 09 00 00       	push   $0x936
  2b:	6a 02                	push   $0x2
  2d:	e8 3a 05 00 00       	call   56c <printf>
  32:	83 c4 10             	add    $0x10,%esp
  setuid(100);
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	6a 64                	push   $0x64
  3a:	e8 46 04 00 00       	call   485 <setuid>
  3f:	83 c4 10             	add    $0x10,%esp
  uid = getuid();
  42:	e8 26 04 00 00       	call   46d <getuid>
  47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(2, "Current UID is: %d\n", uid);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 f4             	pushl  -0xc(%ebp)
  50:	68 22 09 00 00       	push   $0x922
  55:	6a 02                	push   $0x2
  57:	e8 10 05 00 00       	call   56c <printf>
  5c:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
  5f:	e8 11 04 00 00       	call   475 <getgid>
  64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f0             	pushl  -0x10(%ebp)
  6d:	68 4a 09 00 00       	push   $0x94a
  72:	6a 02                	push   $0x2
  74:	e8 f3 04 00 00       	call   56c <printf>
  79:	83 c4 10             	add    $0x10,%esp
  printf(2, "Setting GID to 100\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 5e 09 00 00       	push   $0x95e
  84:	6a 02                	push   $0x2
  86:	e8 e1 04 00 00       	call   56c <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  setgid(100);
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	6a 64                	push   $0x64
  93:	e8 f5 03 00 00       	call   48d <setgid>
  98:	83 c4 10             	add    $0x10,%esp
  gid = getgid();
  9b:	e8 d5 03 00 00       	call   475 <getgid>
  a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(2, "Current GID is: %d\n", gid);
  a3:	83 ec 04             	sub    $0x4,%esp
  a6:	ff 75 f0             	pushl  -0x10(%ebp)
  a9:	68 4a 09 00 00       	push   $0x94a
  ae:	6a 02                	push   $0x2
  b0:	e8 b7 04 00 00       	call   56c <printf>
  b5:	83 c4 10             	add    $0x10,%esp

  ppid = getppid();
  b8:	e8 c0 03 00 00       	call   47d <getppid>
  bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(2, "My parent process  is: %d\n", ppid);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	ff 75 ec             	pushl  -0x14(%ebp)
  c6:	68 72 09 00 00       	push   $0x972
  cb:	6a 02                	push   $0x2
  cd:	e8 9a 04 00 00       	call   56c <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  printf(2, "Done!\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 8d 09 00 00       	push   $0x98d
  dd:	6a 02                	push   $0x2
  df:	e8 88 04 00 00       	call   56c <printf>
  e4:	83 c4 10             	add    $0x10,%esp
  
  return 0;
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	51                   	push   %ecx
  fc:	83 ec 14             	sub    $0x14,%esp
  int temp = testuidgid(); 
  ff:	e8 fc fe ff ff       	call   0 <testuidgid>
 104:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"temp: %d\n", temp); 
 107:	83 ec 04             	sub    $0x4,%esp
 10a:	ff 75 f4             	pushl  -0xc(%ebp)
 10d:	68 94 09 00 00       	push   $0x994
 112:	6a 01                	push   $0x1
 114:	e8 53 04 00 00       	call   56c <printf>
 119:	83 c4 10             	add    $0x10,%esp
  exit();
 11c:	e8 9c 02 00 00       	call   3bd <exit>

00000121 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	57                   	push   %edi
 125:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 126:	8b 4d 08             	mov    0x8(%ebp),%ecx
 129:	8b 55 10             	mov    0x10(%ebp),%edx
 12c:	8b 45 0c             	mov    0xc(%ebp),%eax
 12f:	89 cb                	mov    %ecx,%ebx
 131:	89 df                	mov    %ebx,%edi
 133:	89 d1                	mov    %edx,%ecx
 135:	fc                   	cld    
 136:	f3 aa                	rep stos %al,%es:(%edi)
 138:	89 ca                	mov    %ecx,%edx
 13a:	89 fb                	mov    %edi,%ebx
 13c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 142:	90                   	nop
 143:	5b                   	pop    %ebx
 144:	5f                   	pop    %edi
 145:	5d                   	pop    %ebp
 146:	c3                   	ret    

00000147 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 14d:	8b 45 08             	mov    0x8(%ebp),%eax
 150:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 153:	90                   	nop
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8d 50 01             	lea    0x1(%eax),%edx
 15a:	89 55 08             	mov    %edx,0x8(%ebp)
 15d:	8b 55 0c             	mov    0xc(%ebp),%edx
 160:	8d 4a 01             	lea    0x1(%edx),%ecx
 163:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 166:	0f b6 12             	movzbl (%edx),%edx
 169:	88 10                	mov    %dl,(%eax)
 16b:	0f b6 00             	movzbl (%eax),%eax
 16e:	84 c0                	test   %al,%al
 170:	75 e2                	jne    154 <strcpy+0xd>
    ;
  return os;
 172:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 175:	c9                   	leave  
 176:	c3                   	ret    

00000177 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17a:	eb 08                	jmp    184 <strcmp+0xd>
    p++, q++;
 17c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 180:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	84 c0                	test   %al,%al
 18c:	74 10                	je     19e <strcmp+0x27>
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 10             	movzbl (%eax),%edx
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	38 c2                	cmp    %al,%dl
 19c:	74 de                	je     17c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	0f b6 d0             	movzbl %al,%edx
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	0f b6 c0             	movzbl %al,%eax
 1b0:	29 c2                	sub    %eax,%edx
 1b2:	89 d0                	mov    %edx,%eax
}
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret    

000001b6 <strlen>:

uint
strlen(char *s)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c3:	eb 04                	jmp    1c9 <strlen+0x13>
 1c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	01 d0                	add    %edx,%eax
 1d1:	0f b6 00             	movzbl (%eax),%eax
 1d4:	84 c0                	test   %al,%al
 1d6:	75 ed                	jne    1c5 <strlen+0xf>
    ;
  return n;
 1d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e0:	8b 45 10             	mov    0x10(%ebp),%eax
 1e3:	50                   	push   %eax
 1e4:	ff 75 0c             	pushl  0xc(%ebp)
 1e7:	ff 75 08             	pushl  0x8(%ebp)
 1ea:	e8 32 ff ff ff       	call   121 <stosb>
 1ef:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <strchr>:

char*
strchr(const char *s, char c)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 04             	sub    $0x4,%esp
 1fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 200:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 203:	eb 14                	jmp    219 <strchr+0x22>
    if(*s == c)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20e:	75 05                	jne    215 <strchr+0x1e>
      return (char*)s;
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	eb 13                	jmp    228 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	75 e2                	jne    205 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 223:	b8 00 00 00 00       	mov    $0x0,%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <gets>:

char*
gets(char *buf, int max)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 237:	eb 42                	jmp    27b <gets+0x51>
    cc = read(0, &c, 1);
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	6a 01                	push   $0x1
 23e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 241:	50                   	push   %eax
 242:	6a 00                	push   $0x0
 244:	e8 8c 01 00 00       	call   3d5 <read>
 249:	83 c4 10             	add    $0x10,%esp
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 253:	7e 33                	jle    288 <gets+0x5e>
      break;
    buf[i++] = c;
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	8d 50 01             	lea    0x1(%eax),%edx
 25b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25e:	89 c2                	mov    %eax,%edx
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	01 c2                	add    %eax,%edx
 265:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 269:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26f:	3c 0a                	cmp    $0xa,%al
 271:	74 16                	je     289 <gets+0x5f>
 273:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 277:	3c 0d                	cmp    $0xd,%al
 279:	74 0e                	je     289 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27e:	83 c0 01             	add    $0x1,%eax
 281:	3b 45 0c             	cmp    0xc(%ebp),%eax
 284:	7c b3                	jl     239 <gets+0xf>
 286:	eb 01                	jmp    289 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 288:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 289:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	01 d0                	add    %edx,%eax
 291:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <stat>:

int
stat(char *n, struct stat *st)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	6a 00                	push   $0x0
 2a4:	ff 75 08             	pushl  0x8(%ebp)
 2a7:	e8 51 01 00 00       	call   3fd <open>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b6:	79 07                	jns    2bf <stat+0x26>
    return -1;
 2b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bd:	eb 25                	jmp    2e4 <stat+0x4b>
  r = fstat(fd, st);
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	ff 75 0c             	pushl  0xc(%ebp)
 2c5:	ff 75 f4             	pushl  -0xc(%ebp)
 2c8:	e8 48 01 00 00       	call   415 <fstat>
 2cd:	83 c4 10             	add    $0x10,%esp
 2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d3:	83 ec 0c             	sub    $0xc,%esp
 2d6:	ff 75 f4             	pushl  -0xc(%ebp)
 2d9:	e8 07 01 00 00       	call   3e5 <close>
 2de:	83 c4 10             	add    $0x10,%esp
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2f3:	eb 04                	jmp    2f9 <atoi+0x13>
 2f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 00             	movzbl (%eax),%eax
 2ff:	3c 20                	cmp    $0x20,%al
 301:	74 f2                	je     2f5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	3c 2d                	cmp    $0x2d,%al
 30b:	75 07                	jne    314 <atoi+0x2e>
 30d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 312:	eb 05                	jmp    319 <atoi+0x33>
 314:	b8 01 00 00 00       	mov    $0x1,%eax
 319:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	3c 2b                	cmp    $0x2b,%al
 324:	74 0a                	je     330 <atoi+0x4a>
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	3c 2d                	cmp    $0x2d,%al
 32e:	75 2b                	jne    35b <atoi+0x75>
    s++;
 330:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 334:	eb 25                	jmp    35b <atoi+0x75>
    n = n*10 + *s++ - '0';
 336:	8b 55 fc             	mov    -0x4(%ebp),%edx
 339:	89 d0                	mov    %edx,%eax
 33b:	c1 e0 02             	shl    $0x2,%eax
 33e:	01 d0                	add    %edx,%eax
 340:	01 c0                	add    %eax,%eax
 342:	89 c1                	mov    %eax,%ecx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8d 50 01             	lea    0x1(%eax),%edx
 34a:	89 55 08             	mov    %edx,0x8(%ebp)
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	0f be c0             	movsbl %al,%eax
 353:	01 c8                	add    %ecx,%eax
 355:	83 e8 30             	sub    $0x30,%eax
 358:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	3c 2f                	cmp    $0x2f,%al
 363:	7e 0a                	jle    36f <atoi+0x89>
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	3c 39                	cmp    $0x39,%al
 36d:	7e c7                	jle    336 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 36f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 372:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 38a:	eb 17                	jmp    3a3 <memmove+0x2b>
    *dst++ = *src++;
 38c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38f:	8d 50 01             	lea    0x1(%eax),%edx
 392:	89 55 fc             	mov    %edx,-0x4(%ebp)
 395:	8b 55 f8             	mov    -0x8(%ebp),%edx
 398:	8d 4a 01             	lea    0x1(%edx),%ecx
 39b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 39e:	0f b6 12             	movzbl (%edx),%edx
 3a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a3:	8b 45 10             	mov    0x10(%ebp),%eax
 3a6:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a9:	89 55 10             	mov    %edx,0x10(%ebp)
 3ac:	85 c0                	test   %eax,%eax
 3ae:	7f dc                	jg     38c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b5:	b8 01 00 00 00       	mov    $0x1,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <exit>:
SYSCALL(exit)
 3bd:	b8 02 00 00 00       	mov    $0x2,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <wait>:
SYSCALL(wait)
 3c5:	b8 03 00 00 00       	mov    $0x3,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <pipe>:
SYSCALL(pipe)
 3cd:	b8 04 00 00 00       	mov    $0x4,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <read>:
SYSCALL(read)
 3d5:	b8 05 00 00 00       	mov    $0x5,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <write>:
SYSCALL(write)
 3dd:	b8 10 00 00 00       	mov    $0x10,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <close>:
SYSCALL(close)
 3e5:	b8 15 00 00 00       	mov    $0x15,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <kill>:
SYSCALL(kill)
 3ed:	b8 06 00 00 00       	mov    $0x6,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <exec>:
SYSCALL(exec)
 3f5:	b8 07 00 00 00       	mov    $0x7,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <open>:
SYSCALL(open)
 3fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <mknod>:
SYSCALL(mknod)
 405:	b8 11 00 00 00       	mov    $0x11,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <unlink>:
SYSCALL(unlink)
 40d:	b8 12 00 00 00       	mov    $0x12,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <fstat>:
SYSCALL(fstat)
 415:	b8 08 00 00 00       	mov    $0x8,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <link>:
SYSCALL(link)
 41d:	b8 13 00 00 00       	mov    $0x13,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <mkdir>:
SYSCALL(mkdir)
 425:	b8 14 00 00 00       	mov    $0x14,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <chdir>:
SYSCALL(chdir)
 42d:	b8 09 00 00 00       	mov    $0x9,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <dup>:
SYSCALL(dup)
 435:	b8 0a 00 00 00       	mov    $0xa,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <getpid>:
SYSCALL(getpid)
 43d:	b8 0b 00 00 00       	mov    $0xb,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <sbrk>:
SYSCALL(sbrk)
 445:	b8 0c 00 00 00       	mov    $0xc,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <sleep>:
SYSCALL(sleep)
 44d:	b8 0d 00 00 00       	mov    $0xd,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <uptime>:
SYSCALL(uptime)
 455:	b8 0e 00 00 00       	mov    $0xe,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <halt>:
SYSCALL(halt)
 45d:	b8 16 00 00 00       	mov    $0x16,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <date>:
SYSCALL(date)
 465:	b8 17 00 00 00       	mov    $0x17,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <getuid>:
SYSCALL(getuid)
 46d:	b8 18 00 00 00       	mov    $0x18,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <getgid>:
SYSCALL(getgid)
 475:	b8 19 00 00 00       	mov    $0x19,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <getppid>:
SYSCALL(getppid)
 47d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <setuid>:
SYSCALL(setuid)
 485:	b8 1b 00 00 00       	mov    $0x1b,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <setgid>:
SYSCALL(setgid)
 48d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 495:	55                   	push   %ebp
 496:	89 e5                	mov    %esp,%ebp
 498:	83 ec 18             	sub    $0x18,%esp
 49b:	8b 45 0c             	mov    0xc(%ebp),%eax
 49e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a1:	83 ec 04             	sub    $0x4,%esp
 4a4:	6a 01                	push   $0x1
 4a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a9:	50                   	push   %eax
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 2b ff ff ff       	call   3dd <write>
 4b2:	83 c4 10             	add    $0x10,%esp
}
 4b5:	90                   	nop
 4b6:	c9                   	leave  
 4b7:	c3                   	ret    

000004b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	53                   	push   %ebx
 4bc:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ca:	74 17                	je     4e3 <printint+0x2b>
 4cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d0:	79 11                	jns    4e3 <printint+0x2b>
    neg = 1;
 4d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dc:	f7 d8                	neg    %eax
 4de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e1:	eb 06                	jmp    4e9 <printint+0x31>
  } else {
    x = xx;
 4e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4f3:	8d 41 01             	lea    0x1(%ecx),%eax
 4f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ff:	ba 00 00 00 00       	mov    $0x0,%edx
 504:	f7 f3                	div    %ebx
 506:	89 d0                	mov    %edx,%eax
 508:	0f b6 80 10 0c 00 00 	movzbl 0xc10(%eax),%eax
 50f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 513:	8b 5d 10             	mov    0x10(%ebp),%ebx
 516:	8b 45 ec             	mov    -0x14(%ebp),%eax
 519:	ba 00 00 00 00       	mov    $0x0,%edx
 51e:	f7 f3                	div    %ebx
 520:	89 45 ec             	mov    %eax,-0x14(%ebp)
 523:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 527:	75 c7                	jne    4f0 <printint+0x38>
  if(neg)
 529:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52d:	74 2d                	je     55c <printint+0xa4>
    buf[i++] = '-';
 52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 532:	8d 50 01             	lea    0x1(%eax),%edx
 535:	89 55 f4             	mov    %edx,-0xc(%ebp)
 538:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 53d:	eb 1d                	jmp    55c <printint+0xa4>
    putc(fd, buf[i]);
 53f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	01 d0                	add    %edx,%eax
 547:	0f b6 00             	movzbl (%eax),%eax
 54a:	0f be c0             	movsbl %al,%eax
 54d:	83 ec 08             	sub    $0x8,%esp
 550:	50                   	push   %eax
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 3c ff ff ff       	call   495 <putc>
 559:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 564:	79 d9                	jns    53f <printint+0x87>
    putc(fd, buf[i]);
}
 566:	90                   	nop
 567:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 56a:	c9                   	leave  
 56b:	c3                   	ret    

0000056c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 579:	8d 45 0c             	lea    0xc(%ebp),%eax
 57c:	83 c0 04             	add    $0x4,%eax
 57f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 582:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 589:	e9 59 01 00 00       	jmp    6e7 <printf+0x17b>
    c = fmt[i] & 0xff;
 58e:	8b 55 0c             	mov    0xc(%ebp),%edx
 591:	8b 45 f0             	mov    -0x10(%ebp),%eax
 594:	01 d0                	add    %edx,%eax
 596:	0f b6 00             	movzbl (%eax),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	25 ff 00 00 00       	and    $0xff,%eax
 5a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a8:	75 2c                	jne    5d6 <printf+0x6a>
      if(c == '%'){
 5aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ae:	75 0c                	jne    5bc <printf+0x50>
        state = '%';
 5b0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b7:	e9 27 01 00 00       	jmp    6e3 <printf+0x177>
      } else {
        putc(fd, c);
 5bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bf:	0f be c0             	movsbl %al,%eax
 5c2:	83 ec 08             	sub    $0x8,%esp
 5c5:	50                   	push   %eax
 5c6:	ff 75 08             	pushl  0x8(%ebp)
 5c9:	e8 c7 fe ff ff       	call   495 <putc>
 5ce:	83 c4 10             	add    $0x10,%esp
 5d1:	e9 0d 01 00 00       	jmp    6e3 <printf+0x177>
      }
    } else if(state == '%'){
 5d6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5da:	0f 85 03 01 00 00    	jne    6e3 <printf+0x177>
      if(c == 'd'){
 5e0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e4:	75 1e                	jne    604 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	6a 01                	push   $0x1
 5ed:	6a 0a                	push   $0xa
 5ef:	50                   	push   %eax
 5f0:	ff 75 08             	pushl  0x8(%ebp)
 5f3:	e8 c0 fe ff ff       	call   4b8 <printint>
 5f8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ff:	e9 d8 00 00 00       	jmp    6dc <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 604:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 608:	74 06                	je     610 <printf+0xa4>
 60a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 60e:	75 1e                	jne    62e <printf+0xc2>
        printint(fd, *ap, 16, 0);
 610:	8b 45 e8             	mov    -0x18(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	6a 00                	push   $0x0
 617:	6a 10                	push   $0x10
 619:	50                   	push   %eax
 61a:	ff 75 08             	pushl  0x8(%ebp)
 61d:	e8 96 fe ff ff       	call   4b8 <printint>
 622:	83 c4 10             	add    $0x10,%esp
        ap++;
 625:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 629:	e9 ae 00 00 00       	jmp    6dc <printf+0x170>
      } else if(c == 's'){
 62e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 632:	75 43                	jne    677 <printf+0x10b>
        s = (char*)*ap;
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 63c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 644:	75 25                	jne    66b <printf+0xff>
          s = "(null)";
 646:	c7 45 f4 9e 09 00 00 	movl   $0x99e,-0xc(%ebp)
        while(*s != 0){
 64d:	eb 1c                	jmp    66b <printf+0xff>
          putc(fd, *s);
 64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 652:	0f b6 00             	movzbl (%eax),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 31 fe ff ff       	call   495 <putc>
 664:	83 c4 10             	add    $0x10,%esp
          s++;
 667:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 66b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66e:	0f b6 00             	movzbl (%eax),%eax
 671:	84 c0                	test   %al,%al
 673:	75 da                	jne    64f <printf+0xe3>
 675:	eb 65                	jmp    6dc <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 677:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 67b:	75 1d                	jne    69a <printf+0x12e>
        putc(fd, *ap);
 67d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	0f be c0             	movsbl %al,%eax
 685:	83 ec 08             	sub    $0x8,%esp
 688:	50                   	push   %eax
 689:	ff 75 08             	pushl  0x8(%ebp)
 68c:	e8 04 fe ff ff       	call   495 <putc>
 691:	83 c4 10             	add    $0x10,%esp
        ap++;
 694:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 698:	eb 42                	jmp    6dc <printf+0x170>
      } else if(c == '%'){
 69a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 69e:	75 17                	jne    6b7 <printf+0x14b>
        putc(fd, c);
 6a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	83 ec 08             	sub    $0x8,%esp
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 e3 fd ff ff       	call   495 <putc>
 6b2:	83 c4 10             	add    $0x10,%esp
 6b5:	eb 25                	jmp    6dc <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b7:	83 ec 08             	sub    $0x8,%esp
 6ba:	6a 25                	push   $0x25
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 d1 fd ff ff       	call   495 <putc>
 6c4:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ca:	0f be c0             	movsbl %al,%eax
 6cd:	83 ec 08             	sub    $0x8,%esp
 6d0:	50                   	push   %eax
 6d1:	ff 75 08             	pushl  0x8(%ebp)
 6d4:	e8 bc fd ff ff       	call   495 <putc>
 6d9:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6e7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ed:	01 d0                	add    %edx,%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	84 c0                	test   %al,%al
 6f4:	0f 85 94 fe ff ff    	jne    58e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6fa:	90                   	nop
 6fb:	c9                   	leave  
 6fc:	c3                   	ret    

000006fd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fd:	55                   	push   %ebp
 6fe:	89 e5                	mov    %esp,%ebp
 700:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	83 e8 08             	sub    $0x8,%eax
 709:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 711:	89 45 fc             	mov    %eax,-0x4(%ebp)
 714:	eb 24                	jmp    73a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 00                	mov    (%eax),%eax
 71b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71e:	77 12                	ja     732 <free+0x35>
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 726:	77 24                	ja     74c <free+0x4f>
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 730:	77 1a                	ja     74c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 732:	8b 45 fc             	mov    -0x4(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	89 45 fc             	mov    %eax,-0x4(%ebp)
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 740:	76 d4                	jbe    716 <free+0x19>
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74a:	76 ca                	jbe    716 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	01 c2                	add    %eax,%edx
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	39 c2                	cmp    %eax,%edx
 765:	75 24                	jne    78b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	8b 50 04             	mov    0x4(%eax),%edx
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 00                	mov    (%eax),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	01 c2                	add    %eax,%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 00                	mov    (%eax),%eax
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 45 f8             	mov    -0x8(%ebp),%eax
 787:	89 10                	mov    %edx,(%eax)
 789:	eb 0a                	jmp    795 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 10                	mov    (%eax),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	01 d0                	add    %edx,%eax
 7a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7aa:	75 20                	jne    7cc <free+0xcf>
    p->s.size += bp->s.size;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 50 04             	mov    0x4(%eax),%edx
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	01 c2                	add    %eax,%edx
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c3:	8b 10                	mov    (%eax),%edx
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	89 10                	mov    %edx,(%eax)
 7ca:	eb 08                	jmp    7d4 <free+0xd7>
  } else
    p->s.ptr = bp;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d2:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 7dc:	90                   	nop
 7dd:	c9                   	leave  
 7de:	c3                   	ret    

000007df <morecore>:

static Header*
morecore(uint nu)
{
 7df:	55                   	push   %ebp
 7e0:	89 e5                	mov    %esp,%ebp
 7e2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ec:	77 07                	ja     7f5 <morecore+0x16>
    nu = 4096;
 7ee:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f5:	8b 45 08             	mov    0x8(%ebp),%eax
 7f8:	c1 e0 03             	shl    $0x3,%eax
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	50                   	push   %eax
 7ff:	e8 41 fc ff ff       	call   445 <sbrk>
 804:	83 c4 10             	add    $0x10,%esp
 807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 80a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 80e:	75 07                	jne    817 <morecore+0x38>
    return 0;
 810:	b8 00 00 00 00       	mov    $0x0,%eax
 815:	eb 26                	jmp    83d <morecore+0x5e>
  hp = (Header*)p;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	8b 55 08             	mov    0x8(%ebp),%edx
 823:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	83 c0 08             	add    $0x8,%eax
 82c:	83 ec 0c             	sub    $0xc,%esp
 82f:	50                   	push   %eax
 830:	e8 c8 fe ff ff       	call   6fd <free>
 835:	83 c4 10             	add    $0x10,%esp
  return freep;
 838:	a1 2c 0c 00 00       	mov    0xc2c,%eax
}
 83d:	c9                   	leave  
 83e:	c3                   	ret    

0000083f <malloc>:

void*
malloc(uint nbytes)
{
 83f:	55                   	push   %ebp
 840:	89 e5                	mov    %esp,%ebp
 842:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	83 c0 07             	add    $0x7,%eax
 84b:	c1 e8 03             	shr    $0x3,%eax
 84e:	83 c0 01             	add    $0x1,%eax
 851:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 854:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 859:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 860:	75 23                	jne    885 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 862:	c7 45 f0 24 0c 00 00 	movl   $0xc24,-0x10(%ebp)
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	a3 2c 0c 00 00       	mov    %eax,0xc2c
 871:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 876:	a3 24 0c 00 00       	mov    %eax,0xc24
    base.s.size = 0;
 87b:	c7 05 28 0c 00 00 00 	movl   $0x0,0xc28
 882:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 885:	8b 45 f0             	mov    -0x10(%ebp),%eax
 888:	8b 00                	mov    (%eax),%eax
 88a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	8b 40 04             	mov    0x4(%eax),%eax
 893:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 896:	72 4d                	jb     8e5 <malloc+0xa6>
      if(p->s.size == nunits)
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a1:	75 0c                	jne    8af <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 10                	mov    (%eax),%edx
 8a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ab:	89 10                	mov    %edx,(%eax)
 8ad:	eb 26                	jmp    8d5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 40 04             	mov    0x4(%eax),%eax
 8b5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b8:	89 c2                	mov    %eax,%edx
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	8b 40 04             	mov    0x4(%eax),%eax
 8c6:	c1 e0 03             	shl    $0x3,%eax
 8c9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d8:	a3 2c 0c 00 00       	mov    %eax,0xc2c
      return (void*)(p + 1);
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	83 c0 08             	add    $0x8,%eax
 8e3:	eb 3b                	jmp    920 <malloc+0xe1>
    }
    if(p == freep)
 8e5:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 8ea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ed:	75 1e                	jne    90d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8ef:	83 ec 0c             	sub    $0xc,%esp
 8f2:	ff 75 ec             	pushl  -0x14(%ebp)
 8f5:	e8 e5 fe ff ff       	call   7df <morecore>
 8fa:	83 c4 10             	add    $0x10,%esp
 8fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 904:	75 07                	jne    90d <malloc+0xce>
        return 0;
 906:	b8 00 00 00 00       	mov    $0x0,%eax
 90b:	eb 13                	jmp    920 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 910:	89 45 f0             	mov    %eax,-0x10(%ebp)
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 91b:	e9 6d ff ff ff       	jmp    88d <malloc+0x4e>
}
 920:	c9                   	leave  
 921:	c3                   	ret    
