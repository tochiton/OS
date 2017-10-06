
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 a0 0c 00 00       	add    $0xca0,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 a0 0c 00 00       	add    $0xca0,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 be 09 00 00       	push   $0x9be
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 a0 0c 00 00       	push   $0xca0
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 d1 03 00 00       	call   471 <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 c4 09 00 00       	push   $0x9c4
  be:	6a 01                	push   $0x1
  c0:	e8 43 05 00 00       	call   608 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 8c 03 00 00       	call   459 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 d4 09 00 00       	push   $0x9d4
  e1:	6a 01                	push   $0x1
  e3:	e8 20 05 00 00       	call   608 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
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
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 e1 09 00 00       	push   $0x9e1
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 3b 03 00 00       	call   459 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 53 03 00 00       	call   499 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 e2 09 00 00       	push   $0x9e2
 16c:	6a 01                	push   $0x1
 16e:	e8 95 04 00 00       	call   608 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 de 02 00 00       	call   459 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 db 02 00 00       	call   481 <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 9c 02 00 00       	call   459 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 8c 01 00 00       	call   471 <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 51 01 00 00       	call   499 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 48 01 00 00       	call   4b1 <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 07 01 00 00       	call   481 <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 38f:	eb 04                	jmp    395 <atoi+0x13>
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	3c 20                	cmp    $0x20,%al
 39d:	74 f2                	je     391 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	3c 2d                	cmp    $0x2d,%al
 3a7:	75 07                	jne    3b0 <atoi+0x2e>
 3a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ae:	eb 05                	jmp    3b5 <atoi+0x33>
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
 3b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	3c 2b                	cmp    $0x2b,%al
 3c0:	74 0a                	je     3cc <atoi+0x4a>
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	3c 2d                	cmp    $0x2d,%al
 3ca:	75 2b                	jne    3f7 <atoi+0x75>
    s++;
 3cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3d0:	eb 25                	jmp    3f7 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d5:	89 d0                	mov    %edx,%eax
 3d7:	c1 e0 02             	shl    $0x2,%eax
 3da:	01 d0                	add    %edx,%eax
 3dc:	01 c0                	add    %eax,%eax
 3de:	89 c1                	mov    %eax,%ecx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	8d 50 01             	lea    0x1(%eax),%edx
 3e6:	89 55 08             	mov    %edx,0x8(%ebp)
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	0f be c0             	movsbl %al,%eax
 3ef:	01 c8                	add    %ecx,%eax
 3f1:	83 e8 30             	sub    $0x30,%eax
 3f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	3c 2f                	cmp    $0x2f,%al
 3ff:	7e 0a                	jle    40b <atoi+0x89>
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	3c 39                	cmp    $0x39,%al
 409:	7e c7                	jle    3d2 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 40b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 426:	eb 17                	jmp    43f <memmove+0x2b>
    *dst++ = *src++;
 428:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42b:	8d 50 01             	lea    0x1(%eax),%edx
 42e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 431:	8b 55 f8             	mov    -0x8(%ebp),%edx
 434:	8d 4a 01             	lea    0x1(%edx),%ecx
 437:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 43a:	0f b6 12             	movzbl (%edx),%edx
 43d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43f:	8b 45 10             	mov    0x10(%ebp),%eax
 442:	8d 50 ff             	lea    -0x1(%eax),%edx
 445:	89 55 10             	mov    %edx,0x10(%ebp)
 448:	85 c0                	test   %eax,%eax
 44a:	7f dc                	jg     428 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 451:	b8 01 00 00 00       	mov    $0x1,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <exit>:
SYSCALL(exit)
 459:	b8 02 00 00 00       	mov    $0x2,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <wait>:
SYSCALL(wait)
 461:	b8 03 00 00 00       	mov    $0x3,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <pipe>:
SYSCALL(pipe)
 469:	b8 04 00 00 00       	mov    $0x4,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <read>:
SYSCALL(read)
 471:	b8 05 00 00 00       	mov    $0x5,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <write>:
SYSCALL(write)
 479:	b8 10 00 00 00       	mov    $0x10,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <close>:
SYSCALL(close)
 481:	b8 15 00 00 00       	mov    $0x15,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <kill>:
SYSCALL(kill)
 489:	b8 06 00 00 00       	mov    $0x6,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <exec>:
SYSCALL(exec)
 491:	b8 07 00 00 00       	mov    $0x7,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <open>:
SYSCALL(open)
 499:	b8 0f 00 00 00       	mov    $0xf,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mknod>:
SYSCALL(mknod)
 4a1:	b8 11 00 00 00       	mov    $0x11,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <unlink>:
SYSCALL(unlink)
 4a9:	b8 12 00 00 00       	mov    $0x12,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <fstat>:
SYSCALL(fstat)
 4b1:	b8 08 00 00 00       	mov    $0x8,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <link>:
SYSCALL(link)
 4b9:	b8 13 00 00 00       	mov    $0x13,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <mkdir>:
SYSCALL(mkdir)
 4c1:	b8 14 00 00 00       	mov    $0x14,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <chdir>:
SYSCALL(chdir)
 4c9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <dup>:
SYSCALL(dup)
 4d1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getpid>:
SYSCALL(getpid)
 4d9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sbrk>:
SYSCALL(sbrk)
 4e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <sleep>:
SYSCALL(sleep)
 4e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <uptime>:
SYSCALL(uptime)
 4f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <halt>:
SYSCALL(halt)
 4f9:	b8 16 00 00 00       	mov    $0x16,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <date>:
SYSCALL(date)
 501:	b8 17 00 00 00       	mov    $0x17,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <getuid>:
SYSCALL(getuid)
 509:	b8 18 00 00 00       	mov    $0x18,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <getgid>:
SYSCALL(getgid)
 511:	b8 19 00 00 00       	mov    $0x19,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <getppid>:
SYSCALL(getppid)
 519:	b8 1a 00 00 00       	mov    $0x1a,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <setuid>:
SYSCALL(setuid)
 521:	b8 1b 00 00 00       	mov    $0x1b,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <setgid>:
SYSCALL(setgid)
 529:	b8 1c 00 00 00       	mov    $0x1c,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	83 ec 18             	sub    $0x18,%esp
 537:	8b 45 0c             	mov    0xc(%ebp),%eax
 53a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 53d:	83 ec 04             	sub    $0x4,%esp
 540:	6a 01                	push   $0x1
 542:	8d 45 f4             	lea    -0xc(%ebp),%eax
 545:	50                   	push   %eax
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 2b ff ff ff       	call   479 <write>
 54e:	83 c4 10             	add    $0x10,%esp
}
 551:	90                   	nop
 552:	c9                   	leave  
 553:	c3                   	ret    

00000554 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	53                   	push   %ebx
 558:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 55b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 562:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 566:	74 17                	je     57f <printint+0x2b>
 568:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56c:	79 11                	jns    57f <printint+0x2b>
    neg = 1;
 56e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 575:	8b 45 0c             	mov    0xc(%ebp),%eax
 578:	f7 d8                	neg    %eax
 57a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57d:	eb 06                	jmp    585 <printint+0x31>
  } else {
    x = xx;
 57f:	8b 45 0c             	mov    0xc(%ebp),%eax
 582:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 585:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 58f:	8d 41 01             	lea    0x1(%ecx),%eax
 592:	89 45 f4             	mov    %eax,-0xc(%ebp)
 595:	8b 5d 10             	mov    0x10(%ebp),%ebx
 598:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59b:	ba 00 00 00 00       	mov    $0x0,%edx
 5a0:	f7 f3                	div    %ebx
 5a2:	89 d0                	mov    %edx,%eax
 5a4:	0f b6 80 6c 0c 00 00 	movzbl 0xc6c(%eax),%eax
 5ab:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5af:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b5:	ba 00 00 00 00       	mov    $0x0,%edx
 5ba:	f7 f3                	div    %ebx
 5bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c3:	75 c7                	jne    58c <printint+0x38>
  if(neg)
 5c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c9:	74 2d                	je     5f8 <printint+0xa4>
    buf[i++] = '-';
 5cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ce:	8d 50 01             	lea    0x1(%eax),%edx
 5d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5d4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d9:	eb 1d                	jmp    5f8 <printint+0xa4>
    putc(fd, buf[i]);
 5db:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e1:	01 d0                	add    %edx,%eax
 5e3:	0f b6 00             	movzbl (%eax),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	83 ec 08             	sub    $0x8,%esp
 5ec:	50                   	push   %eax
 5ed:	ff 75 08             	pushl  0x8(%ebp)
 5f0:	e8 3c ff ff ff       	call   531 <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 600:	79 d9                	jns    5db <printint+0x87>
    putc(fd, buf[i]);
}
 602:	90                   	nop
 603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 606:	c9                   	leave  
 607:	c3                   	ret    

00000608 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 615:	8d 45 0c             	lea    0xc(%ebp),%eax
 618:	83 c0 04             	add    $0x4,%eax
 61b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 625:	e9 59 01 00 00       	jmp    783 <printf+0x17b>
    c = fmt[i] & 0xff;
 62a:	8b 55 0c             	mov    0xc(%ebp),%edx
 62d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 630:	01 d0                	add    %edx,%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	25 ff 00 00 00       	and    $0xff,%eax
 63d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 640:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 644:	75 2c                	jne    672 <printf+0x6a>
      if(c == '%'){
 646:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64a:	75 0c                	jne    658 <printf+0x50>
        state = '%';
 64c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 653:	e9 27 01 00 00       	jmp    77f <printf+0x177>
      } else {
        putc(fd, c);
 658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	83 ec 08             	sub    $0x8,%esp
 661:	50                   	push   %eax
 662:	ff 75 08             	pushl  0x8(%ebp)
 665:	e8 c7 fe ff ff       	call   531 <putc>
 66a:	83 c4 10             	add    $0x10,%esp
 66d:	e9 0d 01 00 00       	jmp    77f <printf+0x177>
      }
    } else if(state == '%'){
 672:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 676:	0f 85 03 01 00 00    	jne    77f <printf+0x177>
      if(c == 'd'){
 67c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 680:	75 1e                	jne    6a0 <printf+0x98>
        printint(fd, *ap, 10, 1);
 682:	8b 45 e8             	mov    -0x18(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	6a 01                	push   $0x1
 689:	6a 0a                	push   $0xa
 68b:	50                   	push   %eax
 68c:	ff 75 08             	pushl  0x8(%ebp)
 68f:	e8 c0 fe ff ff       	call   554 <printint>
 694:	83 c4 10             	add    $0x10,%esp
        ap++;
 697:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69b:	e9 d8 00 00 00       	jmp    778 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a4:	74 06                	je     6ac <printf+0xa4>
 6a6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6aa:	75 1e                	jne    6ca <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	6a 00                	push   $0x0
 6b3:	6a 10                	push   $0x10
 6b5:	50                   	push   %eax
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 96 fe ff ff       	call   554 <printint>
 6be:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c5:	e9 ae 00 00 00       	jmp    778 <printf+0x170>
      } else if(c == 's'){
 6ca:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ce:	75 43                	jne    713 <printf+0x10b>
        s = (char*)*ap;
 6d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e0:	75 25                	jne    707 <printf+0xff>
          s = "(null)";
 6e2:	c7 45 f4 f6 09 00 00 	movl   $0x9f6,-0xc(%ebp)
        while(*s != 0){
 6e9:	eb 1c                	jmp    707 <printf+0xff>
          putc(fd, *s);
 6eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ee:	0f b6 00             	movzbl (%eax),%eax
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	83 ec 08             	sub    $0x8,%esp
 6f7:	50                   	push   %eax
 6f8:	ff 75 08             	pushl  0x8(%ebp)
 6fb:	e8 31 fe ff ff       	call   531 <putc>
 700:	83 c4 10             	add    $0x10,%esp
          s++;
 703:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 707:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70a:	0f b6 00             	movzbl (%eax),%eax
 70d:	84 c0                	test   %al,%al
 70f:	75 da                	jne    6eb <printf+0xe3>
 711:	eb 65                	jmp    778 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 713:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 717:	75 1d                	jne    736 <printf+0x12e>
        putc(fd, *ap);
 719:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	0f be c0             	movsbl %al,%eax
 721:	83 ec 08             	sub    $0x8,%esp
 724:	50                   	push   %eax
 725:	ff 75 08             	pushl  0x8(%ebp)
 728:	e8 04 fe ff ff       	call   531 <putc>
 72d:	83 c4 10             	add    $0x10,%esp
        ap++;
 730:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 734:	eb 42                	jmp    778 <printf+0x170>
      } else if(c == '%'){
 736:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73a:	75 17                	jne    753 <printf+0x14b>
        putc(fd, c);
 73c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73f:	0f be c0             	movsbl %al,%eax
 742:	83 ec 08             	sub    $0x8,%esp
 745:	50                   	push   %eax
 746:	ff 75 08             	pushl  0x8(%ebp)
 749:	e8 e3 fd ff ff       	call   531 <putc>
 74e:	83 c4 10             	add    $0x10,%esp
 751:	eb 25                	jmp    778 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 753:	83 ec 08             	sub    $0x8,%esp
 756:	6a 25                	push   $0x25
 758:	ff 75 08             	pushl  0x8(%ebp)
 75b:	e8 d1 fd ff ff       	call   531 <putc>
 760:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 766:	0f be c0             	movsbl %al,%eax
 769:	83 ec 08             	sub    $0x8,%esp
 76c:	50                   	push   %eax
 76d:	ff 75 08             	pushl  0x8(%ebp)
 770:	e8 bc fd ff ff       	call   531 <putc>
 775:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 778:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 77f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 783:	8b 55 0c             	mov    0xc(%ebp),%edx
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	01 d0                	add    %edx,%eax
 78b:	0f b6 00             	movzbl (%eax),%eax
 78e:	84 c0                	test   %al,%al
 790:	0f 85 94 fe ff ff    	jne    62a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 796:	90                   	nop
 797:	c9                   	leave  
 798:	c3                   	ret    

00000799 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	83 e8 08             	sub    $0x8,%eax
 7a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	a1 88 0c 00 00       	mov    0xc88,%eax
 7ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b0:	eb 24                	jmp    7d6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ba:	77 12                	ja     7ce <free+0x35>
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c2:	77 24                	ja     7e8 <free+0x4f>
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cc:	77 1a                	ja     7e8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7dc:	76 d4                	jbe    7b2 <free+0x19>
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e6:	76 ca                	jbe    7b2 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	01 c2                	add    %eax,%edx
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	39 c2                	cmp    %eax,%edx
 801:	75 24                	jne    827 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 50 04             	mov    0x4(%eax),%edx
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	01 c2                	add    %eax,%edx
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	8b 10                	mov    (%eax),%edx
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	89 10                	mov    %edx,(%eax)
 825:	eb 0a                	jmp    831 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	01 d0                	add    %edx,%eax
 843:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 846:	75 20                	jne    868 <free+0xcf>
    p->s.size += bp->s.size;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 50 04             	mov    0x4(%eax),%edx
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	01 c2                	add    %eax,%edx
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
 859:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	8b 10                	mov    (%eax),%edx
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	89 10                	mov    %edx,(%eax)
 866:	eb 08                	jmp    870 <free+0xd7>
  } else
    p->s.ptr = bp;
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86e:	89 10                	mov    %edx,(%eax)
  freep = p;
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	a3 88 0c 00 00       	mov    %eax,0xc88
}
 878:	90                   	nop
 879:	c9                   	leave  
 87a:	c3                   	ret    

0000087b <morecore>:

static Header*
morecore(uint nu)
{
 87b:	55                   	push   %ebp
 87c:	89 e5                	mov    %esp,%ebp
 87e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 881:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 888:	77 07                	ja     891 <morecore+0x16>
    nu = 4096;
 88a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 891:	8b 45 08             	mov    0x8(%ebp),%eax
 894:	c1 e0 03             	shl    $0x3,%eax
 897:	83 ec 0c             	sub    $0xc,%esp
 89a:	50                   	push   %eax
 89b:	e8 41 fc ff ff       	call   4e1 <sbrk>
 8a0:	83 c4 10             	add    $0x10,%esp
 8a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8aa:	75 07                	jne    8b3 <morecore+0x38>
    return 0;
 8ac:	b8 00 00 00 00       	mov    $0x0,%eax
 8b1:	eb 26                	jmp    8d9 <morecore+0x5e>
  hp = (Header*)p;
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bc:	8b 55 08             	mov    0x8(%ebp),%edx
 8bf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c5:	83 c0 08             	add    $0x8,%eax
 8c8:	83 ec 0c             	sub    $0xc,%esp
 8cb:	50                   	push   %eax
 8cc:	e8 c8 fe ff ff       	call   799 <free>
 8d1:	83 c4 10             	add    $0x10,%esp
  return freep;
 8d4:	a1 88 0c 00 00       	mov    0xc88,%eax
}
 8d9:	c9                   	leave  
 8da:	c3                   	ret    

000008db <malloc>:

void*
malloc(uint nbytes)
{
 8db:	55                   	push   %ebp
 8dc:	89 e5                	mov    %esp,%ebp
 8de:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e1:	8b 45 08             	mov    0x8(%ebp),%eax
 8e4:	83 c0 07             	add    $0x7,%eax
 8e7:	c1 e8 03             	shr    $0x3,%eax
 8ea:	83 c0 01             	add    $0x1,%eax
 8ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f0:	a1 88 0c 00 00       	mov    0xc88,%eax
 8f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8fc:	75 23                	jne    921 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8fe:	c7 45 f0 80 0c 00 00 	movl   $0xc80,-0x10(%ebp)
 905:	8b 45 f0             	mov    -0x10(%ebp),%eax
 908:	a3 88 0c 00 00       	mov    %eax,0xc88
 90d:	a1 88 0c 00 00       	mov    0xc88,%eax
 912:	a3 80 0c 00 00       	mov    %eax,0xc80
    base.s.size = 0;
 917:	c7 05 84 0c 00 00 00 	movl   $0x0,0xc84
 91e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 921:	8b 45 f0             	mov    -0x10(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 932:	72 4d                	jb     981 <malloc+0xa6>
      if(p->s.size == nunits)
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	8b 40 04             	mov    0x4(%eax),%eax
 93a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93d:	75 0c                	jne    94b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 93f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 942:	8b 10                	mov    (%eax),%edx
 944:	8b 45 f0             	mov    -0x10(%ebp),%eax
 947:	89 10                	mov    %edx,(%eax)
 949:	eb 26                	jmp    971 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	2b 45 ec             	sub    -0x14(%ebp),%eax
 954:	89 c2                	mov    %eax,%edx
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	c1 e0 03             	shl    $0x3,%eax
 965:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 968:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 96e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 971:	8b 45 f0             	mov    -0x10(%ebp),%eax
 974:	a3 88 0c 00 00       	mov    %eax,0xc88
      return (void*)(p + 1);
 979:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97c:	83 c0 08             	add    $0x8,%eax
 97f:	eb 3b                	jmp    9bc <malloc+0xe1>
    }
    if(p == freep)
 981:	a1 88 0c 00 00       	mov    0xc88,%eax
 986:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 989:	75 1e                	jne    9a9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 98b:	83 ec 0c             	sub    $0xc,%esp
 98e:	ff 75 ec             	pushl  -0x14(%ebp)
 991:	e8 e5 fe ff ff       	call   87b <morecore>
 996:	83 c4 10             	add    $0x10,%esp
 999:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a0:	75 07                	jne    9a9 <malloc+0xce>
        return 0;
 9a2:	b8 00 00 00 00       	mov    $0x0,%eax
 9a7:	eb 13                	jmp    9bc <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	8b 00                	mov    (%eax),%eax
 9b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b7:	e9 6d ff ff ff       	jmp    929 <malloc+0x4e>
}
 9bc:	c9                   	leave  
 9bd:	c3                   	ret    
