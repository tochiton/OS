
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 c0 0b 00 00       	push   $0xbc0
  13:	6a 01                	push   $0x1
  15:	e8 b1 03 00 00       	call   3cb <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 c0 0b 00 00       	push   $0xbc0
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 91 03 00 00       	call   3c3 <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 e8 08 00 00       	push   $0x8e8
  4c:	6a 01                	push   $0x1
  4e:	e8 df 04 00 00       	call   532 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 50 03 00 00       	call   3ab <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 22 03 00 00       	call   3ab <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 3d 03 00 00       	call   3eb <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 f9 08 00 00       	push   $0x8f9
  d4:	6a 01                	push   $0x1
  d6:	e8 57 04 00 00       	call   532 <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 c8 02 00 00       	call   3ab <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 d7 02 00 00       	call   3d3 <close>
  fc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 10a:	e8 9c 02 00 00       	call   3ab <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 8c 01 00 00       	call   3c3 <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b3                	jl     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 276:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 51 01 00 00       	call   3eb <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 48 01 00 00       	call   403 <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 07 01 00 00       	call   3d3 <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2e1:	eb 04                	jmp    2e7 <atoi+0x13>
 2e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	3c 20                	cmp    $0x20,%al
 2ef:	74 f2                	je     2e3 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	0f b6 00             	movzbl (%eax),%eax
 2f7:	3c 2d                	cmp    $0x2d,%al
 2f9:	75 07                	jne    302 <atoi+0x2e>
 2fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 300:	eb 05                	jmp    307 <atoi+0x33>
 302:	b8 01 00 00 00       	mov    $0x1,%eax
 307:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	3c 2b                	cmp    $0x2b,%al
 312:	74 0a                	je     31e <atoi+0x4a>
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	3c 2d                	cmp    $0x2d,%al
 31c:	75 2b                	jne    349 <atoi+0x75>
    s++;
 31e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 322:	eb 25                	jmp    349 <atoi+0x75>
    n = n*10 + *s++ - '0';
 324:	8b 55 fc             	mov    -0x4(%ebp),%edx
 327:	89 d0                	mov    %edx,%eax
 329:	c1 e0 02             	shl    $0x2,%eax
 32c:	01 d0                	add    %edx,%eax
 32e:	01 c0                	add    %eax,%eax
 330:	89 c1                	mov    %eax,%ecx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	8d 50 01             	lea    0x1(%eax),%edx
 338:	89 55 08             	mov    %edx,0x8(%ebp)
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	0f be c0             	movsbl %al,%eax
 341:	01 c8                	add    %ecx,%eax
 343:	83 e8 30             	sub    $0x30,%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	0f b6 00             	movzbl (%eax),%eax
 34f:	3c 2f                	cmp    $0x2f,%al
 351:	7e 0a                	jle    35d <atoi+0x89>
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 00             	movzbl (%eax),%eax
 359:	3c 39                	cmp    $0x39,%al
 35b:	7e c7                	jle    324 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 35d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 360:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 364:	c9                   	leave  
 365:	c3                   	ret    

00000366 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 378:	eb 17                	jmp    391 <memmove+0x2b>
    *dst++ = *src++;
 37a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37d:	8d 50 01             	lea    0x1(%eax),%edx
 380:	89 55 fc             	mov    %edx,-0x4(%ebp)
 383:	8b 55 f8             	mov    -0x8(%ebp),%edx
 386:	8d 4a 01             	lea    0x1(%edx),%ecx
 389:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 38c:	0f b6 12             	movzbl (%edx),%edx
 38f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 391:	8b 45 10             	mov    0x10(%ebp),%eax
 394:	8d 50 ff             	lea    -0x1(%eax),%edx
 397:	89 55 10             	mov    %edx,0x10(%ebp)
 39a:	85 c0                	test   %eax,%eax
 39c:	7f dc                	jg     37a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3a1:	c9                   	leave  
 3a2:	c3                   	ret    

000003a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a3:	b8 01 00 00 00       	mov    $0x1,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <exit>:
SYSCALL(exit)
 3ab:	b8 02 00 00 00       	mov    $0x2,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <wait>:
SYSCALL(wait)
 3b3:	b8 03 00 00 00       	mov    $0x3,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <pipe>:
SYSCALL(pipe)
 3bb:	b8 04 00 00 00       	mov    $0x4,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <read>:
SYSCALL(read)
 3c3:	b8 05 00 00 00       	mov    $0x5,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <write>:
SYSCALL(write)
 3cb:	b8 10 00 00 00       	mov    $0x10,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <close>:
SYSCALL(close)
 3d3:	b8 15 00 00 00       	mov    $0x15,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <kill>:
SYSCALL(kill)
 3db:	b8 06 00 00 00       	mov    $0x6,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <exec>:
SYSCALL(exec)
 3e3:	b8 07 00 00 00       	mov    $0x7,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <open>:
SYSCALL(open)
 3eb:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <mknod>:
SYSCALL(mknod)
 3f3:	b8 11 00 00 00       	mov    $0x11,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <unlink>:
SYSCALL(unlink)
 3fb:	b8 12 00 00 00       	mov    $0x12,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <fstat>:
SYSCALL(fstat)
 403:	b8 08 00 00 00       	mov    $0x8,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <link>:
SYSCALL(link)
 40b:	b8 13 00 00 00       	mov    $0x13,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <mkdir>:
SYSCALL(mkdir)
 413:	b8 14 00 00 00       	mov    $0x14,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <chdir>:
SYSCALL(chdir)
 41b:	b8 09 00 00 00       	mov    $0x9,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <dup>:
SYSCALL(dup)
 423:	b8 0a 00 00 00       	mov    $0xa,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <getpid>:
SYSCALL(getpid)
 42b:	b8 0b 00 00 00       	mov    $0xb,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sbrk>:
SYSCALL(sbrk)
 433:	b8 0c 00 00 00       	mov    $0xc,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <sleep>:
SYSCALL(sleep)
 43b:	b8 0d 00 00 00       	mov    $0xd,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <uptime>:
SYSCALL(uptime)
 443:	b8 0e 00 00 00       	mov    $0xe,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <halt>:
SYSCALL(halt)
 44b:	b8 16 00 00 00       	mov    $0x16,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <date>:
SYSCALL(date)
 453:	b8 17 00 00 00       	mov    $0x17,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	83 ec 18             	sub    $0x18,%esp
 461:	8b 45 0c             	mov    0xc(%ebp),%eax
 464:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 467:	83 ec 04             	sub    $0x4,%esp
 46a:	6a 01                	push   $0x1
 46c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46f:	50                   	push   %eax
 470:	ff 75 08             	pushl  0x8(%ebp)
 473:	e8 53 ff ff ff       	call   3cb <write>
 478:	83 c4 10             	add    $0x10,%esp
}
 47b:	90                   	nop
 47c:	c9                   	leave  
 47d:	c3                   	ret    

0000047e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	53                   	push   %ebx
 482:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 490:	74 17                	je     4a9 <printint+0x2b>
 492:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 496:	79 11                	jns    4a9 <printint+0x2b>
    neg = 1;
 498:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49f:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a2:	f7 d8                	neg    %eax
 4a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a7:	eb 06                	jmp    4af <printint+0x31>
  } else {
    x = xx;
 4a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b9:	8d 41 01             	lea    0x1(%ecx),%eax
 4bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c5:	ba 00 00 00 00       	mov    $0x0,%edx
 4ca:	f7 f3                	div    %ebx
 4cc:	89 d0                	mov    %edx,%eax
 4ce:	0f b6 80 84 0b 00 00 	movzbl 0xb84(%eax),%eax
 4d5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4df:	ba 00 00 00 00       	mov    $0x0,%edx
 4e4:	f7 f3                	div    %ebx
 4e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ed:	75 c7                	jne    4b6 <printint+0x38>
  if(neg)
 4ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f3:	74 2d                	je     522 <printint+0xa4>
    buf[i++] = '-';
 4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f8:	8d 50 01             	lea    0x1(%eax),%edx
 4fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4fe:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 503:	eb 1d                	jmp    522 <printint+0xa4>
    putc(fd, buf[i]);
 505:	8d 55 dc             	lea    -0x24(%ebp),%edx
 508:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50b:	01 d0                	add    %edx,%eax
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	83 ec 08             	sub    $0x8,%esp
 516:	50                   	push   %eax
 517:	ff 75 08             	pushl  0x8(%ebp)
 51a:	e8 3c ff ff ff       	call   45b <putc>
 51f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 522:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52a:	79 d9                	jns    505 <printint+0x87>
    putc(fd, buf[i]);
}
 52c:	90                   	nop
 52d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 530:	c9                   	leave  
 531:	c3                   	ret    

00000532 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 532:	55                   	push   %ebp
 533:	89 e5                	mov    %esp,%ebp
 535:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 538:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53f:	8d 45 0c             	lea    0xc(%ebp),%eax
 542:	83 c0 04             	add    $0x4,%eax
 545:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 548:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54f:	e9 59 01 00 00       	jmp    6ad <printf+0x17b>
    c = fmt[i] & 0xff;
 554:	8b 55 0c             	mov    0xc(%ebp),%edx
 557:	8b 45 f0             	mov    -0x10(%ebp),%eax
 55a:	01 d0                	add    %edx,%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	25 ff 00 00 00       	and    $0xff,%eax
 567:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 56a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56e:	75 2c                	jne    59c <printf+0x6a>
      if(c == '%'){
 570:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 574:	75 0c                	jne    582 <printf+0x50>
        state = '%';
 576:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57d:	e9 27 01 00 00       	jmp    6a9 <printf+0x177>
      } else {
        putc(fd, c);
 582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 585:	0f be c0             	movsbl %al,%eax
 588:	83 ec 08             	sub    $0x8,%esp
 58b:	50                   	push   %eax
 58c:	ff 75 08             	pushl  0x8(%ebp)
 58f:	e8 c7 fe ff ff       	call   45b <putc>
 594:	83 c4 10             	add    $0x10,%esp
 597:	e9 0d 01 00 00       	jmp    6a9 <printf+0x177>
      }
    } else if(state == '%'){
 59c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a0:	0f 85 03 01 00 00    	jne    6a9 <printf+0x177>
      if(c == 'd'){
 5a6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5aa:	75 1e                	jne    5ca <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5af:	8b 00                	mov    (%eax),%eax
 5b1:	6a 01                	push   $0x1
 5b3:	6a 0a                	push   $0xa
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 c0 fe ff ff       	call   47e <printint>
 5be:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c5:	e9 d8 00 00 00       	jmp    6a2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5ca:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ce:	74 06                	je     5d6 <printf+0xa4>
 5d0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d4:	75 1e                	jne    5f4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d9:	8b 00                	mov    (%eax),%eax
 5db:	6a 00                	push   $0x0
 5dd:	6a 10                	push   $0x10
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 96 fe ff ff       	call   47e <printint>
 5e8:	83 c4 10             	add    $0x10,%esp
        ap++;
 5eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ef:	e9 ae 00 00 00       	jmp    6a2 <printf+0x170>
      } else if(c == 's'){
 5f4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f8:	75 43                	jne    63d <printf+0x10b>
        s = (char*)*ap;
 5fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fd:	8b 00                	mov    (%eax),%eax
 5ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 602:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60a:	75 25                	jne    631 <printf+0xff>
          s = "(null)";
 60c:	c7 45 f4 0e 09 00 00 	movl   $0x90e,-0xc(%ebp)
        while(*s != 0){
 613:	eb 1c                	jmp    631 <printf+0xff>
          putc(fd, *s);
 615:	8b 45 f4             	mov    -0xc(%ebp),%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	83 ec 08             	sub    $0x8,%esp
 621:	50                   	push   %eax
 622:	ff 75 08             	pushl  0x8(%ebp)
 625:	e8 31 fe ff ff       	call   45b <putc>
 62a:	83 c4 10             	add    $0x10,%esp
          s++;
 62d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 631:	8b 45 f4             	mov    -0xc(%ebp),%eax
 634:	0f b6 00             	movzbl (%eax),%eax
 637:	84 c0                	test   %al,%al
 639:	75 da                	jne    615 <printf+0xe3>
 63b:	eb 65                	jmp    6a2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 641:	75 1d                	jne    660 <printf+0x12e>
        putc(fd, *ap);
 643:	8b 45 e8             	mov    -0x18(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	0f be c0             	movsbl %al,%eax
 64b:	83 ec 08             	sub    $0x8,%esp
 64e:	50                   	push   %eax
 64f:	ff 75 08             	pushl  0x8(%ebp)
 652:	e8 04 fe ff ff       	call   45b <putc>
 657:	83 c4 10             	add    $0x10,%esp
        ap++;
 65a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65e:	eb 42                	jmp    6a2 <printf+0x170>
      } else if(c == '%'){
 660:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 664:	75 17                	jne    67d <printf+0x14b>
        putc(fd, c);
 666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	50                   	push   %eax
 670:	ff 75 08             	pushl  0x8(%ebp)
 673:	e8 e3 fd ff ff       	call   45b <putc>
 678:	83 c4 10             	add    $0x10,%esp
 67b:	eb 25                	jmp    6a2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67d:	83 ec 08             	sub    $0x8,%esp
 680:	6a 25                	push   $0x25
 682:	ff 75 08             	pushl  0x8(%ebp)
 685:	e8 d1 fd ff ff       	call   45b <putc>
 68a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 68d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 690:	0f be c0             	movsbl %al,%eax
 693:	83 ec 08             	sub    $0x8,%esp
 696:	50                   	push   %eax
 697:	ff 75 08             	pushl  0x8(%ebp)
 69a:	e8 bc fd ff ff       	call   45b <putc>
 69f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6a9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b3:	01 d0                	add    %edx,%eax
 6b5:	0f b6 00             	movzbl (%eax),%eax
 6b8:	84 c0                	test   %al,%al
 6ba:	0f 85 94 fe ff ff    	jne    554 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c0:	90                   	nop
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    

000006c3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	83 e8 08             	sub    $0x8,%eax
 6cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d2:	a1 a8 0b 00 00       	mov    0xba8,%eax
 6d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6da:	eb 24                	jmp    700 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 00                	mov    (%eax),%eax
 6e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e4:	77 12                	ja     6f8 <free+0x35>
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ec:	77 24                	ja     712 <free+0x4f>
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f6:	77 1a                	ja     712 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 706:	76 d4                	jbe    6dc <free+0x19>
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 710:	76 ca                	jbe    6dc <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	8b 40 04             	mov    0x4(%eax),%eax
 718:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	01 c2                	add    %eax,%edx
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	39 c2                	cmp    %eax,%edx
 72b:	75 24                	jne    751 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 72d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 730:	8b 50 04             	mov    0x4(%eax),%edx
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	8b 40 04             	mov    0x4(%eax),%eax
 73b:	01 c2                	add    %eax,%edx
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 00                	mov    (%eax),%eax
 748:	8b 10                	mov    (%eax),%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	89 10                	mov    %edx,(%eax)
 74f:	eb 0a                	jmp    75b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 10                	mov    (%eax),%edx
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	01 d0                	add    %edx,%eax
 76d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 770:	75 20                	jne    792 <free+0xcf>
    p->s.size += bp->s.size;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 50 04             	mov    0x4(%eax),%edx
 778:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	01 c2                	add    %eax,%edx
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 786:	8b 45 f8             	mov    -0x8(%ebp),%eax
 789:	8b 10                	mov    (%eax),%edx
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	89 10                	mov    %edx,(%eax)
 790:	eb 08                	jmp    79a <free+0xd7>
  } else
    p->s.ptr = bp;
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 55 f8             	mov    -0x8(%ebp),%edx
 798:	89 10                	mov    %edx,(%eax)
  freep = p;
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 7a2:	90                   	nop
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <morecore>:

static Header*
morecore(uint nu)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b2:	77 07                	ja     7bb <morecore+0x16>
    nu = 4096;
 7b4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7bb:	8b 45 08             	mov    0x8(%ebp),%eax
 7be:	c1 e0 03             	shl    $0x3,%eax
 7c1:	83 ec 0c             	sub    $0xc,%esp
 7c4:	50                   	push   %eax
 7c5:	e8 69 fc ff ff       	call   433 <sbrk>
 7ca:	83 c4 10             	add    $0x10,%esp
 7cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d4:	75 07                	jne    7dd <morecore+0x38>
    return 0;
 7d6:	b8 00 00 00 00       	mov    $0x0,%eax
 7db:	eb 26                	jmp    803 <morecore+0x5e>
  hp = (Header*)p;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	8b 55 08             	mov    0x8(%ebp),%edx
 7e9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	83 c0 08             	add    $0x8,%eax
 7f2:	83 ec 0c             	sub    $0xc,%esp
 7f5:	50                   	push   %eax
 7f6:	e8 c8 fe ff ff       	call   6c3 <free>
 7fb:	83 c4 10             	add    $0x10,%esp
  return freep;
 7fe:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 803:	c9                   	leave  
 804:	c3                   	ret    

00000805 <malloc>:

void*
malloc(uint nbytes)
{
 805:	55                   	push   %ebp
 806:	89 e5                	mov    %esp,%ebp
 808:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	83 c0 07             	add    $0x7,%eax
 811:	c1 e8 03             	shr    $0x3,%eax
 814:	83 c0 01             	add    $0x1,%eax
 817:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81a:	a1 a8 0b 00 00       	mov    0xba8,%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 826:	75 23                	jne    84b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 828:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	a3 a8 0b 00 00       	mov    %eax,0xba8
 837:	a1 a8 0b 00 00       	mov    0xba8,%eax
 83c:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 841:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 848:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85c:	72 4d                	jb     8ab <malloc+0xa6>
      if(p->s.size == nunits)
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 867:	75 0c                	jne    875 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 26                	jmp    89b <malloc+0x96>
      else {
        p->s.size -= nunits;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 87e:	89 c2                	mov    %eax,%edx
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	c1 e0 03             	shl    $0x3,%eax
 88f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 55 ec             	mov    -0x14(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	83 c0 08             	add    $0x8,%eax
 8a9:	eb 3b                	jmp    8e6 <malloc+0xe1>
    }
    if(p == freep)
 8ab:	a1 a8 0b 00 00       	mov    0xba8,%eax
 8b0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b3:	75 1e                	jne    8d3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8b5:	83 ec 0c             	sub    $0xc,%esp
 8b8:	ff 75 ec             	pushl  -0x14(%ebp)
 8bb:	e8 e5 fe ff ff       	call   7a5 <morecore>
 8c0:	83 c4 10             	add    $0x10,%esp
 8c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ca:	75 07                	jne    8d3 <malloc+0xce>
        return 0;
 8cc:	b8 00 00 00 00       	mov    $0x0,%eax
 8d1:	eb 13                	jmp    8e6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e1:	e9 6d ff ff ff       	jmp    853 <malloc+0x4e>
}
 8e6:	c9                   	leave  
 8e7:	c3                   	ret    
