
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 60 0e 00 00       	add    $0xe60,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 88 05 00 00       	call   5f2 <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba 60 0e 00 00       	mov    $0xe60,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 60 0e 00 00       	push   $0xe60
  c0:	e8 c8 04 00 00       	call   58d <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 60 0e 00 00       	add    $0xe60,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 ff 04 00 00       	call   5ea <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 10 0b 00 00       	push   $0xb10
 11f:	6a 02                	push   $0x2
 121:	e8 33 06 00 00       	call   759 <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 a4 04 00 00       	call   5d2 <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 81 04 00 00       	call   5d2 <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 9c 04 00 00       	call   612 <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 30 0b 00 00       	push   $0xb30
 19c:	6a 01                	push   $0x1
 19e:	e8 b6 05 00 00       	call   759 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 27 04 00 00       	call   5d2 <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 33 04 00 00       	call   5fa <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d5:	e8 f8 03 00 00       	call   5d2 <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	3b 45 08             	cmp    0x8(%ebp),%eax
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8d 50 01             	lea    0x1(%eax),%edx
 36f:	89 55 08             	mov    %edx,0x8(%ebp)
 372:	8b 55 0c             	mov    0xc(%ebp),%edx
 375:	8d 4a 01             	lea    0x1(%edx),%ecx
 378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3a 45 fc             	cmp    -0x4(%ebp),%al
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 8c 01 00 00       	call   5ea <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	3b 45 0c             	cmp    0xc(%ebp),%eax
 499:	7c b3                	jl     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 49d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 51 01 00 00       	call   612 <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	pushl  0xc(%ebp)
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 48 01 00 00       	call   62a <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	pushl  -0xc(%ebp)
 4ee:	e8 07 01 00 00       	call   5fa <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 508:	eb 04                	jmp    50e <atoi+0x13>
 50a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	0f b6 00             	movzbl (%eax),%eax
 514:	3c 20                	cmp    $0x20,%al
 516:	74 f2                	je     50a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	0f b6 00             	movzbl (%eax),%eax
 51e:	3c 2d                	cmp    $0x2d,%al
 520:	75 07                	jne    529 <atoi+0x2e>
 522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 527:	eb 05                	jmp    52e <atoi+0x33>
 529:	b8 01 00 00 00       	mov    $0x1,%eax
 52e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	0f b6 00             	movzbl (%eax),%eax
 537:	3c 2b                	cmp    $0x2b,%al
 539:	74 0a                	je     545 <atoi+0x4a>
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	3c 2d                	cmp    $0x2d,%al
 543:	75 2b                	jne    570 <atoi+0x75>
    s++;
 545:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 549:	eb 25                	jmp    570 <atoi+0x75>
    n = n*10 + *s++ - '0';
 54b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54e:	89 d0                	mov    %edx,%eax
 550:	c1 e0 02             	shl    $0x2,%eax
 553:	01 d0                	add    %edx,%eax
 555:	01 c0                	add    %eax,%eax
 557:	89 c1                	mov    %eax,%ecx
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	8d 50 01             	lea    0x1(%eax),%edx
 55f:	89 55 08             	mov    %edx,0x8(%ebp)
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	01 c8                	add    %ecx,%eax
 56a:	83 e8 30             	sub    $0x30,%eax
 56d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	3c 2f                	cmp    $0x2f,%al
 578:	7e 0a                	jle    584 <atoi+0x89>
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	3c 39                	cmp    $0x39,%al
 582:	7e c7                	jle    54b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 584:	8b 45 f8             	mov    -0x8(%ebp),%eax
 587:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 58b:	c9                   	leave  
 58c:	c3                   	ret    

0000058d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 599:	8b 45 0c             	mov    0xc(%ebp),%eax
 59c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 59f:	eb 17                	jmp    5b8 <memmove+0x2b>
    *dst++ = *src++;
 5a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a4:	8d 50 01             	lea    0x1(%eax),%edx
 5a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 5b0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5b3:	0f b6 12             	movzbl (%edx),%edx
 5b6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5b8:	8b 45 10             	mov    0x10(%ebp),%eax
 5bb:	8d 50 ff             	lea    -0x1(%eax),%edx
 5be:	89 55 10             	mov    %edx,0x10(%ebp)
 5c1:	85 c0                	test   %eax,%eax
 5c3:	7f dc                	jg     5a1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    

000005ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ca:	b8 01 00 00 00       	mov    $0x1,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <exit>:
SYSCALL(exit)
 5d2:	b8 02 00 00 00       	mov    $0x2,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <wait>:
SYSCALL(wait)
 5da:	b8 03 00 00 00       	mov    $0x3,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <pipe>:
SYSCALL(pipe)
 5e2:	b8 04 00 00 00       	mov    $0x4,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <read>:
SYSCALL(read)
 5ea:	b8 05 00 00 00       	mov    $0x5,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <write>:
SYSCALL(write)
 5f2:	b8 10 00 00 00       	mov    $0x10,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <close>:
SYSCALL(close)
 5fa:	b8 15 00 00 00       	mov    $0x15,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <kill>:
SYSCALL(kill)
 602:	b8 06 00 00 00       	mov    $0x6,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <exec>:
SYSCALL(exec)
 60a:	b8 07 00 00 00       	mov    $0x7,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <open>:
SYSCALL(open)
 612:	b8 0f 00 00 00       	mov    $0xf,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <mknod>:
SYSCALL(mknod)
 61a:	b8 11 00 00 00       	mov    $0x11,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <unlink>:
SYSCALL(unlink)
 622:	b8 12 00 00 00       	mov    $0x12,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <fstat>:
SYSCALL(fstat)
 62a:	b8 08 00 00 00       	mov    $0x8,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <link>:
SYSCALL(link)
 632:	b8 13 00 00 00       	mov    $0x13,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <mkdir>:
SYSCALL(mkdir)
 63a:	b8 14 00 00 00       	mov    $0x14,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <chdir>:
SYSCALL(chdir)
 642:	b8 09 00 00 00       	mov    $0x9,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <dup>:
SYSCALL(dup)
 64a:	b8 0a 00 00 00       	mov    $0xa,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <getpid>:
SYSCALL(getpid)
 652:	b8 0b 00 00 00       	mov    $0xb,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <sbrk>:
SYSCALL(sbrk)
 65a:	b8 0c 00 00 00       	mov    $0xc,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <sleep>:
SYSCALL(sleep)
 662:	b8 0d 00 00 00       	mov    $0xd,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <uptime>:
SYSCALL(uptime)
 66a:	b8 0e 00 00 00       	mov    $0xe,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <halt>:
SYSCALL(halt)
 672:	b8 16 00 00 00       	mov    $0x16,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <date>:
SYSCALL(date)
 67a:	b8 17 00 00 00       	mov    $0x17,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 682:	55                   	push   %ebp
 683:	89 e5                	mov    %esp,%ebp
 685:	83 ec 18             	sub    $0x18,%esp
 688:	8b 45 0c             	mov    0xc(%ebp),%eax
 68b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 68e:	83 ec 04             	sub    $0x4,%esp
 691:	6a 01                	push   $0x1
 693:	8d 45 f4             	lea    -0xc(%ebp),%eax
 696:	50                   	push   %eax
 697:	ff 75 08             	pushl  0x8(%ebp)
 69a:	e8 53 ff ff ff       	call   5f2 <write>
 69f:	83 c4 10             	add    $0x10,%esp
}
 6a2:	90                   	nop
 6a3:	c9                   	leave  
 6a4:	c3                   	ret    

000006a5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a5:	55                   	push   %ebp
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	53                   	push   %ebx
 6a9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6b7:	74 17                	je     6d0 <printint+0x2b>
 6b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6bd:	79 11                	jns    6d0 <printint+0x2b>
    neg = 1;
 6bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c9:	f7 d8                	neg    %eax
 6cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ce:	eb 06                	jmp    6d6 <printint+0x31>
  } else {
    x = xx;
 6d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6dd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6e0:	8d 41 01             	lea    0x1(%ecx),%eax
 6e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ec:	ba 00 00 00 00       	mov    $0x0,%edx
 6f1:	f7 f3                	div    %ebx
 6f3:	89 d0                	mov    %edx,%eax
 6f5:	0f b6 80 1c 0e 00 00 	movzbl 0xe1c(%eax),%eax
 6fc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 700:	8b 5d 10             	mov    0x10(%ebp),%ebx
 703:	8b 45 ec             	mov    -0x14(%ebp),%eax
 706:	ba 00 00 00 00       	mov    $0x0,%edx
 70b:	f7 f3                	div    %ebx
 70d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 710:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 714:	75 c7                	jne    6dd <printint+0x38>
  if(neg)
 716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71a:	74 2d                	je     749 <printint+0xa4>
    buf[i++] = '-';
 71c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71f:	8d 50 01             	lea    0x1(%eax),%edx
 722:	89 55 f4             	mov    %edx,-0xc(%ebp)
 725:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 72a:	eb 1d                	jmp    749 <printint+0xa4>
    putc(fd, buf[i]);
 72c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 732:	01 d0                	add    %edx,%eax
 734:	0f b6 00             	movzbl (%eax),%eax
 737:	0f be c0             	movsbl %al,%eax
 73a:	83 ec 08             	sub    $0x8,%esp
 73d:	50                   	push   %eax
 73e:	ff 75 08             	pushl  0x8(%ebp)
 741:	e8 3c ff ff ff       	call   682 <putc>
 746:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 749:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 74d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 751:	79 d9                	jns    72c <printint+0x87>
    putc(fd, buf[i]);
}
 753:	90                   	nop
 754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 757:	c9                   	leave  
 758:	c3                   	ret    

00000759 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 759:	55                   	push   %ebp
 75a:	89 e5                	mov    %esp,%ebp
 75c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 75f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 766:	8d 45 0c             	lea    0xc(%ebp),%eax
 769:	83 c0 04             	add    $0x4,%eax
 76c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 76f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 776:	e9 59 01 00 00       	jmp    8d4 <printf+0x17b>
    c = fmt[i] & 0xff;
 77b:	8b 55 0c             	mov    0xc(%ebp),%edx
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	01 d0                	add    %edx,%eax
 783:	0f b6 00             	movzbl (%eax),%eax
 786:	0f be c0             	movsbl %al,%eax
 789:	25 ff 00 00 00       	and    $0xff,%eax
 78e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 791:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 795:	75 2c                	jne    7c3 <printf+0x6a>
      if(c == '%'){
 797:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 79b:	75 0c                	jne    7a9 <printf+0x50>
        state = '%';
 79d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7a4:	e9 27 01 00 00       	jmp    8d0 <printf+0x177>
      } else {
        putc(fd, c);
 7a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ac:	0f be c0             	movsbl %al,%eax
 7af:	83 ec 08             	sub    $0x8,%esp
 7b2:	50                   	push   %eax
 7b3:	ff 75 08             	pushl  0x8(%ebp)
 7b6:	e8 c7 fe ff ff       	call   682 <putc>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	e9 0d 01 00 00       	jmp    8d0 <printf+0x177>
      }
    } else if(state == '%'){
 7c3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7c7:	0f 85 03 01 00 00    	jne    8d0 <printf+0x177>
      if(c == 'd'){
 7cd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7d1:	75 1e                	jne    7f1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	6a 01                	push   $0x1
 7da:	6a 0a                	push   $0xa
 7dc:	50                   	push   %eax
 7dd:	ff 75 08             	pushl  0x8(%ebp)
 7e0:	e8 c0 fe ff ff       	call   6a5 <printint>
 7e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ec:	e9 d8 00 00 00       	jmp    8c9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7f1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7f5:	74 06                	je     7fd <printf+0xa4>
 7f7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7fb:	75 1e                	jne    81b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	6a 00                	push   $0x0
 804:	6a 10                	push   $0x10
 806:	50                   	push   %eax
 807:	ff 75 08             	pushl  0x8(%ebp)
 80a:	e8 96 fe ff ff       	call   6a5 <printint>
 80f:	83 c4 10             	add    $0x10,%esp
        ap++;
 812:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 816:	e9 ae 00 00 00       	jmp    8c9 <printf+0x170>
      } else if(c == 's'){
 81b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 81f:	75 43                	jne    864 <printf+0x10b>
        s = (char*)*ap;
 821:	8b 45 e8             	mov    -0x18(%ebp),%eax
 824:	8b 00                	mov    (%eax),%eax
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 829:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 831:	75 25                	jne    858 <printf+0xff>
          s = "(null)";
 833:	c7 45 f4 46 0b 00 00 	movl   $0xb46,-0xc(%ebp)
        while(*s != 0){
 83a:	eb 1c                	jmp    858 <printf+0xff>
          putc(fd, *s);
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	0f b6 00             	movzbl (%eax),%eax
 842:	0f be c0             	movsbl %al,%eax
 845:	83 ec 08             	sub    $0x8,%esp
 848:	50                   	push   %eax
 849:	ff 75 08             	pushl  0x8(%ebp)
 84c:	e8 31 fe ff ff       	call   682 <putc>
 851:	83 c4 10             	add    $0x10,%esp
          s++;
 854:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	0f b6 00             	movzbl (%eax),%eax
 85e:	84 c0                	test   %al,%al
 860:	75 da                	jne    83c <printf+0xe3>
 862:	eb 65                	jmp    8c9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 864:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 868:	75 1d                	jne    887 <printf+0x12e>
        putc(fd, *ap);
 86a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86d:	8b 00                	mov    (%eax),%eax
 86f:	0f be c0             	movsbl %al,%eax
 872:	83 ec 08             	sub    $0x8,%esp
 875:	50                   	push   %eax
 876:	ff 75 08             	pushl  0x8(%ebp)
 879:	e8 04 fe ff ff       	call   682 <putc>
 87e:	83 c4 10             	add    $0x10,%esp
        ap++;
 881:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 885:	eb 42                	jmp    8c9 <printf+0x170>
      } else if(c == '%'){
 887:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 88b:	75 17                	jne    8a4 <printf+0x14b>
        putc(fd, c);
 88d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 890:	0f be c0             	movsbl %al,%eax
 893:	83 ec 08             	sub    $0x8,%esp
 896:	50                   	push   %eax
 897:	ff 75 08             	pushl  0x8(%ebp)
 89a:	e8 e3 fd ff ff       	call   682 <putc>
 89f:	83 c4 10             	add    $0x10,%esp
 8a2:	eb 25                	jmp    8c9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8a4:	83 ec 08             	sub    $0x8,%esp
 8a7:	6a 25                	push   $0x25
 8a9:	ff 75 08             	pushl  0x8(%ebp)
 8ac:	e8 d1 fd ff ff       	call   682 <putc>
 8b1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b7:	0f be c0             	movsbl %al,%eax
 8ba:	83 ec 08             	sub    $0x8,%esp
 8bd:	50                   	push   %eax
 8be:	ff 75 08             	pushl  0x8(%ebp)
 8c1:	e8 bc fd ff ff       	call   682 <putc>
 8c6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8da:	01 d0                	add    %edx,%eax
 8dc:	0f b6 00             	movzbl (%eax),%eax
 8df:	84 c0                	test   %al,%al
 8e1:	0f 85 94 fe ff ff    	jne    77b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8e7:	90                   	nop
 8e8:	c9                   	leave  
 8e9:	c3                   	ret    

000008ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8ea:	55                   	push   %ebp
 8eb:	89 e5                	mov    %esp,%ebp
 8ed:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f0:	8b 45 08             	mov    0x8(%ebp),%eax
 8f3:	83 e8 08             	sub    $0x8,%eax
 8f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f9:	a1 48 0e 00 00       	mov    0xe48,%eax
 8fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 901:	eb 24                	jmp    927 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 903:	8b 45 fc             	mov    -0x4(%ebp),%eax
 906:	8b 00                	mov    (%eax),%eax
 908:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 90b:	77 12                	ja     91f <free+0x35>
 90d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 913:	77 24                	ja     939 <free+0x4f>
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	8b 00                	mov    (%eax),%eax
 91a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91d:	77 1a                	ja     939 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	89 45 fc             	mov    %eax,-0x4(%ebp)
 927:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92d:	76 d4                	jbe    903 <free+0x19>
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 00                	mov    (%eax),%eax
 934:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 937:	76 ca                	jbe    903 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 939:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93c:	8b 40 04             	mov    0x4(%eax),%eax
 93f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 946:	8b 45 f8             	mov    -0x8(%ebp),%eax
 949:	01 c2                	add    %eax,%edx
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	39 c2                	cmp    %eax,%edx
 952:	75 24                	jne    978 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	8b 50 04             	mov    0x4(%eax),%edx
 95a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	01 c2                	add    %eax,%edx
 964:	8b 45 f8             	mov    -0x8(%ebp),%eax
 967:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 96a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96d:	8b 00                	mov    (%eax),%eax
 96f:	8b 10                	mov    (%eax),%edx
 971:	8b 45 f8             	mov    -0x8(%ebp),%eax
 974:	89 10                	mov    %edx,(%eax)
 976:	eb 0a                	jmp    982 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	8b 10                	mov    (%eax),%edx
 97d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 980:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 982:	8b 45 fc             	mov    -0x4(%ebp),%eax
 985:	8b 40 04             	mov    0x4(%eax),%eax
 988:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	01 d0                	add    %edx,%eax
 994:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 997:	75 20                	jne    9b9 <free+0xcf>
    p->s.size += bp->s.size;
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	8b 50 04             	mov    0x4(%eax),%edx
 99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a2:	8b 40 04             	mov    0x4(%eax),%eax
 9a5:	01 c2                	add    %eax,%edx
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b0:	8b 10                	mov    (%eax),%edx
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	89 10                	mov    %edx,(%eax)
 9b7:	eb 08                	jmp    9c1 <free+0xd7>
  } else
    p->s.ptr = bp;
 9b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9bf:	89 10                	mov    %edx,(%eax)
  freep = p;
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9c9:	90                   	nop
 9ca:	c9                   	leave  
 9cb:	c3                   	ret    

000009cc <morecore>:

static Header*
morecore(uint nu)
{
 9cc:	55                   	push   %ebp
 9cd:	89 e5                	mov    %esp,%ebp
 9cf:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9d2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9d9:	77 07                	ja     9e2 <morecore+0x16>
    nu = 4096;
 9db:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9e2:	8b 45 08             	mov    0x8(%ebp),%eax
 9e5:	c1 e0 03             	shl    $0x3,%eax
 9e8:	83 ec 0c             	sub    $0xc,%esp
 9eb:	50                   	push   %eax
 9ec:	e8 69 fc ff ff       	call   65a <sbrk>
 9f1:	83 c4 10             	add    $0x10,%esp
 9f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9f7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9fb:	75 07                	jne    a04 <morecore+0x38>
    return 0;
 9fd:	b8 00 00 00 00       	mov    $0x0,%eax
 a02:	eb 26                	jmp    a2a <morecore+0x5e>
  hp = (Header*)p;
 a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0d:	8b 55 08             	mov    0x8(%ebp),%edx
 a10:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	83 c0 08             	add    $0x8,%eax
 a19:	83 ec 0c             	sub    $0xc,%esp
 a1c:	50                   	push   %eax
 a1d:	e8 c8 fe ff ff       	call   8ea <free>
 a22:	83 c4 10             	add    $0x10,%esp
  return freep;
 a25:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a2a:	c9                   	leave  
 a2b:	c3                   	ret    

00000a2c <malloc>:

void*
malloc(uint nbytes)
{
 a2c:	55                   	push   %ebp
 a2d:	89 e5                	mov    %esp,%ebp
 a2f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a32:	8b 45 08             	mov    0x8(%ebp),%eax
 a35:	83 c0 07             	add    $0x7,%eax
 a38:	c1 e8 03             	shr    $0x3,%eax
 a3b:	83 c0 01             	add    $0x1,%eax
 a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a41:	a1 48 0e 00 00       	mov    0xe48,%eax
 a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4d:	75 23                	jne    a72 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a4f:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a59:	a3 48 0e 00 00       	mov    %eax,0xe48
 a5e:	a1 48 0e 00 00       	mov    0xe48,%eax
 a63:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a68:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a6f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a75:	8b 00                	mov    (%eax),%eax
 a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	8b 40 04             	mov    0x4(%eax),%eax
 a80:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a83:	72 4d                	jb     ad2 <malloc+0xa6>
      if(p->s.size == nunits)
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8b 40 04             	mov    0x4(%eax),%eax
 a8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a8e:	75 0c                	jne    a9c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a93:	8b 10                	mov    (%eax),%edx
 a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a98:	89 10                	mov    %edx,(%eax)
 a9a:	eb 26                	jmp    ac2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9f:	8b 40 04             	mov    0x4(%eax),%eax
 aa2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aa5:	89 c2                	mov    %eax,%edx
 aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab0:	8b 40 04             	mov    0x4(%eax),%eax
 ab3:	c1 e0 03             	shl    $0x3,%eax
 ab6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 abf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac5:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acd:	83 c0 08             	add    $0x8,%eax
 ad0:	eb 3b                	jmp    b0d <malloc+0xe1>
    }
    if(p == freep)
 ad2:	a1 48 0e 00 00       	mov    0xe48,%eax
 ad7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ada:	75 1e                	jne    afa <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 adc:	83 ec 0c             	sub    $0xc,%esp
 adf:	ff 75 ec             	pushl  -0x14(%ebp)
 ae2:	e8 e5 fe ff ff       	call   9cc <morecore>
 ae7:	83 c4 10             	add    $0x10,%esp
 aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 af1:	75 07                	jne    afa <malloc+0xce>
        return 0;
 af3:	b8 00 00 00 00       	mov    $0x0,%eax
 af8:	eb 13                	jmp    b0d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b03:	8b 00                	mov    (%eax),%eax
 b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b08:	e9 6d ff ff ff       	jmp    a7a <malloc+0x4e>
}
 b0d:	c9                   	leave  
 b0e:	c3                   	ret    
