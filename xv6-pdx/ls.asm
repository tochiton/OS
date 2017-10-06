
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 c9 03 00 00       	call   3db <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 95 03 00 00       	call   3db <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 7d 03 00 00       	call   3db <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 24 0e 00 00       	push   $0xe24
  6d:	e8 2b 05 00 00       	call   59d <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 5b 03 00 00       	call   3db <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 44 03 00 00       	call   3db <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 24 0e 00 00       	add    $0xe24,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 24 0e 00 00       	mov    $0xe24,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 51 05 00 00       	call   622 <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 1f 0b 00 00       	push   $0xb1f
  e8:	6a 02                	push   $0x2
  ea:	e8 7a 06 00 00       	call   769 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 31 05 00 00       	call   63a <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 33 0b 00 00       	push   $0xb33
 11b:	6a 02                	push   $0x2
 11d:	e8 47 06 00 00       	call   769 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 da 04 00 00       	call   60a <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 47 0b 00 00       	push   $0xb47
 17e:	6a 01                	push   $0x1
 180:	e8 e4 05 00 00       	call   769 <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 43 02 00 00       	call   3db <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 54 0b 00 00       	push   $0xb54
 1ad:	6a 01                	push   $0x1
 1af:	e8 b5 05 00 00       	call   769 <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9e 01 00 00       	call   36c <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fb 01 00 00       	call   3db <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	pushl  -0x20(%ebp)
 224:	e8 74 03 00 00       	call   59d <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 73 02 00 00       	call   4be <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 33 0b 00 00       	push   $0xb33
 261:	6a 01                	push   $0x1
 263:	e8 01 05 00 00       	call   769 <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 47 0b 00 00       	push   $0xb47
 2a1:	6a 01                	push   $0x1
 2a3:	e8 c1 04 00 00       	call   769 <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ba:	e8 3b 03 00 00       	call   5fa <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	e8 33 03 00 00       	call   60a <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	pushl  -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 67 0b 00 00       	push   $0xb67
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 d2 02 00 00       	call   5e2 <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
    ls(argv[i]);
  exit();
 341:	e8 9c 02 00 00       	call   5e2 <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	90                   	nop
 368:	5b                   	pop    %ebx
 369:	5f                   	pop    %edi
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    

0000036c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 378:	90                   	nop
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	8d 50 01             	lea    0x1(%eax),%edx
 37f:	89 55 08             	mov    %edx,0x8(%ebp)
 382:	8b 55 0c             	mov    0xc(%ebp),%edx
 385:	8d 4a 01             	lea    0x1(%edx),%ecx
 388:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38b:	0f b6 12             	movzbl (%edx),%edx
 38e:	88 10                	mov    %dl,(%eax)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	75 e2                	jne    379 <strcpy+0xd>
    ;
  return os;
 397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39f:	eb 08                	jmp    3a9 <strcmp+0xd>
    p++, q++;
 3a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	84 c0                	test   %al,%al
 3b1:	74 10                	je     3c3 <strcmp+0x27>
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 10             	movzbl (%eax),%edx
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	38 c2                	cmp    %al,%dl
 3c1:	74 de                	je     3a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	0f b6 d0             	movzbl %al,%edx
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	0f b6 00             	movzbl (%eax),%eax
 3d2:	0f b6 c0             	movzbl %al,%eax
 3d5:	29 c2                	sub    %eax,%edx
 3d7:	89 d0                	mov    %edx,%eax
}
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    

000003db <strlen>:

uint
strlen(char *s)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e8:	eb 04                	jmp    3ee <strlen+0x13>
 3ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	84 c0                	test   %al,%al
 3fb:	75 ed                	jne    3ea <strlen+0xf>
    ;
  return n;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	50                   	push   %eax
 409:	ff 75 0c             	pushl  0xc(%ebp)
 40c:	ff 75 08             	pushl  0x8(%ebp)
 40f:	e8 32 ff ff ff       	call   346 <stosb>
 414:	83 c4 0c             	add    $0xc,%esp
  return dst;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <strchr>:

char*
strchr(const char *s, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 428:	eb 14                	jmp    43e <strchr+0x22>
    if(*s == c)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3a 45 fc             	cmp    -0x4(%ebp),%al
 433:	75 05                	jne    43a <strchr+0x1e>
      return (char*)s;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	eb 13                	jmp    44d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 43a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	84 c0                	test   %al,%al
 446:	75 e2                	jne    42a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 448:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <gets>:

char*
gets(char *buf, int max)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45c:	eb 42                	jmp    4a0 <gets+0x51>
    cc = read(0, &c, 1);
 45e:	83 ec 04             	sub    $0x4,%esp
 461:	6a 01                	push   $0x1
 463:	8d 45 ef             	lea    -0x11(%ebp),%eax
 466:	50                   	push   %eax
 467:	6a 00                	push   $0x0
 469:	e8 8c 01 00 00       	call   5fa <read>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 478:	7e 33                	jle    4ad <gets+0x5e>
      break;
    buf[i++] = c;
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 55 f4             	mov    %edx,-0xc(%ebp)
 483:	89 c2                	mov    %eax,%edx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	01 c2                	add    %eax,%edx
 48a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 490:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 494:	3c 0a                	cmp    $0xa,%al
 496:	74 16                	je     4ae <gets+0x5f>
 498:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49c:	3c 0d                	cmp    $0xd,%al
 49e:	74 0e                	je     4ae <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a3:	83 c0 01             	add    $0x1,%eax
 4a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a9:	7c b3                	jl     45e <gets+0xf>
 4ab:	eb 01                	jmp    4ae <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4ad:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bc:	c9                   	leave  
 4bd:	c3                   	ret    

000004be <stat>:

int
stat(char *n, struct stat *st)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 51 01 00 00       	call   622 <open>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x26>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 25                	jmp    509 <stat+0x4b>
  r = fstat(fd, st);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	ff 75 0c             	pushl  0xc(%ebp)
 4ea:	ff 75 f4             	pushl  -0xc(%ebp)
 4ed:	e8 48 01 00 00       	call   63a <fstat>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	ff 75 f4             	pushl  -0xc(%ebp)
 4fe:	e8 07 01 00 00       	call   60a <close>
 503:	83 c4 10             	add    $0x10,%esp
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 518:	eb 04                	jmp    51e <atoi+0x13>
 51a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	3c 20                	cmp    $0x20,%al
 526:	74 f2                	je     51a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	3c 2d                	cmp    $0x2d,%al
 530:	75 07                	jne    539 <atoi+0x2e>
 532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 537:	eb 05                	jmp    53e <atoi+0x33>
 539:	b8 01 00 00 00       	mov    $0x1,%eax
 53e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	3c 2b                	cmp    $0x2b,%al
 549:	74 0a                	je     555 <atoi+0x4a>
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	3c 2d                	cmp    $0x2d,%al
 553:	75 2b                	jne    580 <atoi+0x75>
    s++;
 555:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 559:	eb 25                	jmp    580 <atoi+0x75>
    n = n*10 + *s++ - '0';
 55b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 55e:	89 d0                	mov    %edx,%eax
 560:	c1 e0 02             	shl    $0x2,%eax
 563:	01 d0                	add    %edx,%eax
 565:	01 c0                	add    %eax,%eax
 567:	89 c1                	mov    %eax,%ecx
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	8d 50 01             	lea    0x1(%eax),%edx
 56f:	89 55 08             	mov    %edx,0x8(%ebp)
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	01 c8                	add    %ecx,%eax
 57a:	83 e8 30             	sub    $0x30,%eax
 57d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	3c 2f                	cmp    $0x2f,%al
 588:	7e 0a                	jle    594 <atoi+0x89>
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	3c 39                	cmp    $0x39,%al
 592:	7e c7                	jle    55b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 594:	8b 45 f8             	mov    -0x8(%ebp),%eax
 597:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 59b:	c9                   	leave  
 59c:	c3                   	ret    

0000059d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 59d:	55                   	push   %ebp
 59e:	89 e5                	mov    %esp,%ebp
 5a0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5a3:	8b 45 08             	mov    0x8(%ebp),%eax
 5a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5af:	eb 17                	jmp    5c8 <memmove+0x2b>
    *dst++ = *src++;
 5b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b4:	8d 50 01             	lea    0x1(%eax),%edx
 5b7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5bd:	8d 4a 01             	lea    0x1(%edx),%ecx
 5c0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5c3:	0f b6 12             	movzbl (%edx),%edx
 5c6:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5c8:	8b 45 10             	mov    0x10(%ebp),%eax
 5cb:	8d 50 ff             	lea    -0x1(%eax),%edx
 5ce:	89 55 10             	mov    %edx,0x10(%ebp)
 5d1:	85 c0                	test   %eax,%eax
 5d3:	7f dc                	jg     5b1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    

000005da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5da:	b8 01 00 00 00       	mov    $0x1,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <exit>:
SYSCALL(exit)
 5e2:	b8 02 00 00 00       	mov    $0x2,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <wait>:
SYSCALL(wait)
 5ea:	b8 03 00 00 00       	mov    $0x3,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <pipe>:
SYSCALL(pipe)
 5f2:	b8 04 00 00 00       	mov    $0x4,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <read>:
SYSCALL(read)
 5fa:	b8 05 00 00 00       	mov    $0x5,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <write>:
SYSCALL(write)
 602:	b8 10 00 00 00       	mov    $0x10,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <close>:
SYSCALL(close)
 60a:	b8 15 00 00 00       	mov    $0x15,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <kill>:
SYSCALL(kill)
 612:	b8 06 00 00 00       	mov    $0x6,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <exec>:
SYSCALL(exec)
 61a:	b8 07 00 00 00       	mov    $0x7,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <open>:
SYSCALL(open)
 622:	b8 0f 00 00 00       	mov    $0xf,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mknod>:
SYSCALL(mknod)
 62a:	b8 11 00 00 00       	mov    $0x11,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <unlink>:
SYSCALL(unlink)
 632:	b8 12 00 00 00       	mov    $0x12,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <fstat>:
SYSCALL(fstat)
 63a:	b8 08 00 00 00       	mov    $0x8,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <link>:
SYSCALL(link)
 642:	b8 13 00 00 00       	mov    $0x13,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mkdir>:
SYSCALL(mkdir)
 64a:	b8 14 00 00 00       	mov    $0x14,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <chdir>:
SYSCALL(chdir)
 652:	b8 09 00 00 00       	mov    $0x9,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <dup>:
SYSCALL(dup)
 65a:	b8 0a 00 00 00       	mov    $0xa,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getpid>:
SYSCALL(getpid)
 662:	b8 0b 00 00 00       	mov    $0xb,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <sbrk>:
SYSCALL(sbrk)
 66a:	b8 0c 00 00 00       	mov    $0xc,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <sleep>:
SYSCALL(sleep)
 672:	b8 0d 00 00 00       	mov    $0xd,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <uptime>:
SYSCALL(uptime)
 67a:	b8 0e 00 00 00       	mov    $0xe,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <halt>:
SYSCALL(halt)
 682:	b8 16 00 00 00       	mov    $0x16,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <date>:
SYSCALL(date)
 68a:	b8 17 00 00 00       	mov    $0x17,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 18             	sub    $0x18,%esp
 698:	8b 45 0c             	mov    0xc(%ebp),%eax
 69b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 69e:	83 ec 04             	sub    $0x4,%esp
 6a1:	6a 01                	push   $0x1
 6a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6a6:	50                   	push   %eax
 6a7:	ff 75 08             	pushl  0x8(%ebp)
 6aa:	e8 53 ff ff ff       	call   602 <write>
 6af:	83 c4 10             	add    $0x10,%esp
}
 6b2:	90                   	nop
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    

000006b5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6b5:	55                   	push   %ebp
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	53                   	push   %ebx
 6b9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c7:	74 17                	je     6e0 <printint+0x2b>
 6c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6cd:	79 11                	jns    6e0 <printint+0x2b>
    neg = 1;
 6cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d9:	f7 d8                	neg    %eax
 6db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6de:	eb 06                	jmp    6e6 <printint+0x31>
  } else {
    x = xx;
 6e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6f0:	8d 41 01             	lea    0x1(%ecx),%eax
 6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6fc:	ba 00 00 00 00       	mov    $0x0,%edx
 701:	f7 f3                	div    %ebx
 703:	89 d0                	mov    %edx,%eax
 705:	0f b6 80 10 0e 00 00 	movzbl 0xe10(%eax),%eax
 70c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 710:	8b 5d 10             	mov    0x10(%ebp),%ebx
 713:	8b 45 ec             	mov    -0x14(%ebp),%eax
 716:	ba 00 00 00 00       	mov    $0x0,%edx
 71b:	f7 f3                	div    %ebx
 71d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 720:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 724:	75 c7                	jne    6ed <printint+0x38>
  if(neg)
 726:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72a:	74 2d                	je     759 <printint+0xa4>
    buf[i++] = '-';
 72c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72f:	8d 50 01             	lea    0x1(%eax),%edx
 732:	89 55 f4             	mov    %edx,-0xc(%ebp)
 735:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 73a:	eb 1d                	jmp    759 <printint+0xa4>
    putc(fd, buf[i]);
 73c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 73f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 742:	01 d0                	add    %edx,%eax
 744:	0f b6 00             	movzbl (%eax),%eax
 747:	0f be c0             	movsbl %al,%eax
 74a:	83 ec 08             	sub    $0x8,%esp
 74d:	50                   	push   %eax
 74e:	ff 75 08             	pushl  0x8(%ebp)
 751:	e8 3c ff ff ff       	call   692 <putc>
 756:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 759:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 75d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 761:	79 d9                	jns    73c <printint+0x87>
    putc(fd, buf[i]);
}
 763:	90                   	nop
 764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 767:	c9                   	leave  
 768:	c3                   	ret    

00000769 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 769:	55                   	push   %ebp
 76a:	89 e5                	mov    %esp,%ebp
 76c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 76f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 776:	8d 45 0c             	lea    0xc(%ebp),%eax
 779:	83 c0 04             	add    $0x4,%eax
 77c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 77f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 786:	e9 59 01 00 00       	jmp    8e4 <printf+0x17b>
    c = fmt[i] & 0xff;
 78b:	8b 55 0c             	mov    0xc(%ebp),%edx
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	01 d0                	add    %edx,%eax
 793:	0f b6 00             	movzbl (%eax),%eax
 796:	0f be c0             	movsbl %al,%eax
 799:	25 ff 00 00 00       	and    $0xff,%eax
 79e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a5:	75 2c                	jne    7d3 <printf+0x6a>
      if(c == '%'){
 7a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ab:	75 0c                	jne    7b9 <printf+0x50>
        state = '%';
 7ad:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7b4:	e9 27 01 00 00       	jmp    8e0 <printf+0x177>
      } else {
        putc(fd, c);
 7b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bc:	0f be c0             	movsbl %al,%eax
 7bf:	83 ec 08             	sub    $0x8,%esp
 7c2:	50                   	push   %eax
 7c3:	ff 75 08             	pushl  0x8(%ebp)
 7c6:	e8 c7 fe ff ff       	call   692 <putc>
 7cb:	83 c4 10             	add    $0x10,%esp
 7ce:	e9 0d 01 00 00       	jmp    8e0 <printf+0x177>
      }
    } else if(state == '%'){
 7d3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7d7:	0f 85 03 01 00 00    	jne    8e0 <printf+0x177>
      if(c == 'd'){
 7dd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7e1:	75 1e                	jne    801 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	6a 01                	push   $0x1
 7ea:	6a 0a                	push   $0xa
 7ec:	50                   	push   %eax
 7ed:	ff 75 08             	pushl  0x8(%ebp)
 7f0:	e8 c0 fe ff ff       	call   6b5 <printint>
 7f5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fc:	e9 d8 00 00 00       	jmp    8d9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 801:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 805:	74 06                	je     80d <printf+0xa4>
 807:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 80b:	75 1e                	jne    82b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 80d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	6a 00                	push   $0x0
 814:	6a 10                	push   $0x10
 816:	50                   	push   %eax
 817:	ff 75 08             	pushl  0x8(%ebp)
 81a:	e8 96 fe ff ff       	call   6b5 <printint>
 81f:	83 c4 10             	add    $0x10,%esp
        ap++;
 822:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 826:	e9 ae 00 00 00       	jmp    8d9 <printf+0x170>
      } else if(c == 's'){
 82b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 82f:	75 43                	jne    874 <printf+0x10b>
        s = (char*)*ap;
 831:	8b 45 e8             	mov    -0x18(%ebp),%eax
 834:	8b 00                	mov    (%eax),%eax
 836:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 839:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 83d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 841:	75 25                	jne    868 <printf+0xff>
          s = "(null)";
 843:	c7 45 f4 69 0b 00 00 	movl   $0xb69,-0xc(%ebp)
        while(*s != 0){
 84a:	eb 1c                	jmp    868 <printf+0xff>
          putc(fd, *s);
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	0f b6 00             	movzbl (%eax),%eax
 852:	0f be c0             	movsbl %al,%eax
 855:	83 ec 08             	sub    $0x8,%esp
 858:	50                   	push   %eax
 859:	ff 75 08             	pushl  0x8(%ebp)
 85c:	e8 31 fe ff ff       	call   692 <putc>
 861:	83 c4 10             	add    $0x10,%esp
          s++;
 864:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	0f b6 00             	movzbl (%eax),%eax
 86e:	84 c0                	test   %al,%al
 870:	75 da                	jne    84c <printf+0xe3>
 872:	eb 65                	jmp    8d9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 874:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 878:	75 1d                	jne    897 <printf+0x12e>
        putc(fd, *ap);
 87a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	0f be c0             	movsbl %al,%eax
 882:	83 ec 08             	sub    $0x8,%esp
 885:	50                   	push   %eax
 886:	ff 75 08             	pushl  0x8(%ebp)
 889:	e8 04 fe ff ff       	call   692 <putc>
 88e:	83 c4 10             	add    $0x10,%esp
        ap++;
 891:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 895:	eb 42                	jmp    8d9 <printf+0x170>
      } else if(c == '%'){
 897:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 89b:	75 17                	jne    8b4 <printf+0x14b>
        putc(fd, c);
 89d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a0:	0f be c0             	movsbl %al,%eax
 8a3:	83 ec 08             	sub    $0x8,%esp
 8a6:	50                   	push   %eax
 8a7:	ff 75 08             	pushl  0x8(%ebp)
 8aa:	e8 e3 fd ff ff       	call   692 <putc>
 8af:	83 c4 10             	add    $0x10,%esp
 8b2:	eb 25                	jmp    8d9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8b4:	83 ec 08             	sub    $0x8,%esp
 8b7:	6a 25                	push   $0x25
 8b9:	ff 75 08             	pushl  0x8(%ebp)
 8bc:	e8 d1 fd ff ff       	call   692 <putc>
 8c1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c7:	0f be c0             	movsbl %al,%eax
 8ca:	83 ec 08             	sub    $0x8,%esp
 8cd:	50                   	push   %eax
 8ce:	ff 75 08             	pushl  0x8(%ebp)
 8d1:	e8 bc fd ff ff       	call   692 <putc>
 8d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ea:	01 d0                	add    %edx,%eax
 8ec:	0f b6 00             	movzbl (%eax),%eax
 8ef:	84 c0                	test   %al,%al
 8f1:	0f 85 94 fe ff ff    	jne    78b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8f7:	90                   	nop
 8f8:	c9                   	leave  
 8f9:	c3                   	ret    

000008fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8fa:	55                   	push   %ebp
 8fb:	89 e5                	mov    %esp,%ebp
 8fd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 900:	8b 45 08             	mov    0x8(%ebp),%eax
 903:	83 e8 08             	sub    $0x8,%eax
 906:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 909:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 90e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 911:	eb 24                	jmp    937 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 00                	mov    (%eax),%eax
 918:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 91b:	77 12                	ja     92f <free+0x35>
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 923:	77 24                	ja     949 <free+0x4f>
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92d:	77 1a                	ja     949 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 00                	mov    (%eax),%eax
 934:	89 45 fc             	mov    %eax,-0x4(%ebp)
 937:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93d:	76 d4                	jbe    913 <free+0x19>
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 00                	mov    (%eax),%eax
 944:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 947:	76 ca                	jbe    913 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 949:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94c:	8b 40 04             	mov    0x4(%eax),%eax
 94f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	01 c2                	add    %eax,%edx
 95b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	39 c2                	cmp    %eax,%edx
 962:	75 24                	jne    988 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 964:	8b 45 f8             	mov    -0x8(%ebp),%eax
 967:	8b 50 04             	mov    0x4(%eax),%edx
 96a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96d:	8b 00                	mov    (%eax),%eax
 96f:	8b 40 04             	mov    0x4(%eax),%eax
 972:	01 c2                	add    %eax,%edx
 974:	8b 45 f8             	mov    -0x8(%ebp),%eax
 977:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 00                	mov    (%eax),%eax
 97f:	8b 10                	mov    (%eax),%edx
 981:	8b 45 f8             	mov    -0x8(%ebp),%eax
 984:	89 10                	mov    %edx,(%eax)
 986:	eb 0a                	jmp    992 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	8b 10                	mov    (%eax),%edx
 98d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 990:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 992:	8b 45 fc             	mov    -0x4(%ebp),%eax
 995:	8b 40 04             	mov    0x4(%eax),%eax
 998:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a2:	01 d0                	add    %edx,%eax
 9a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9a7:	75 20                	jne    9c9 <free+0xcf>
    p->s.size += bp->s.size;
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	8b 50 04             	mov    0x4(%eax),%edx
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	8b 40 04             	mov    0x4(%eax),%eax
 9b5:	01 c2                	add    %eax,%edx
 9b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ba:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c0:	8b 10                	mov    (%eax),%edx
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	89 10                	mov    %edx,(%eax)
 9c7:	eb 08                	jmp    9d1 <free+0xd7>
  } else
    p->s.ptr = bp;
 9c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9cf:	89 10                	mov    %edx,(%eax)
  freep = p;
 9d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d4:	a3 3c 0e 00 00       	mov    %eax,0xe3c
}
 9d9:	90                   	nop
 9da:	c9                   	leave  
 9db:	c3                   	ret    

000009dc <morecore>:

static Header*
morecore(uint nu)
{
 9dc:	55                   	push   %ebp
 9dd:	89 e5                	mov    %esp,%ebp
 9df:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9e2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9e9:	77 07                	ja     9f2 <morecore+0x16>
    nu = 4096;
 9eb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9f2:	8b 45 08             	mov    0x8(%ebp),%eax
 9f5:	c1 e0 03             	shl    $0x3,%eax
 9f8:	83 ec 0c             	sub    $0xc,%esp
 9fb:	50                   	push   %eax
 9fc:	e8 69 fc ff ff       	call   66a <sbrk>
 a01:	83 c4 10             	add    $0x10,%esp
 a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a07:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a0b:	75 07                	jne    a14 <morecore+0x38>
    return 0;
 a0d:	b8 00 00 00 00       	mov    $0x0,%eax
 a12:	eb 26                	jmp    a3a <morecore+0x5e>
  hp = (Header*)p;
 a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1d:	8b 55 08             	mov    0x8(%ebp),%edx
 a20:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a26:	83 c0 08             	add    $0x8,%eax
 a29:	83 ec 0c             	sub    $0xc,%esp
 a2c:	50                   	push   %eax
 a2d:	e8 c8 fe ff ff       	call   8fa <free>
 a32:	83 c4 10             	add    $0x10,%esp
  return freep;
 a35:	a1 3c 0e 00 00       	mov    0xe3c,%eax
}
 a3a:	c9                   	leave  
 a3b:	c3                   	ret    

00000a3c <malloc>:

void*
malloc(uint nbytes)
{
 a3c:	55                   	push   %ebp
 a3d:	89 e5                	mov    %esp,%ebp
 a3f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a42:	8b 45 08             	mov    0x8(%ebp),%eax
 a45:	83 c0 07             	add    $0x7,%eax
 a48:	c1 e8 03             	shr    $0x3,%eax
 a4b:	83 c0 01             	add    $0x1,%eax
 a4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a51:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a5d:	75 23                	jne    a82 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a5f:	c7 45 f0 34 0e 00 00 	movl   $0xe34,-0x10(%ebp)
 a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a69:	a3 3c 0e 00 00       	mov    %eax,0xe3c
 a6e:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 a73:	a3 34 0e 00 00       	mov    %eax,0xe34
    base.s.size = 0;
 a78:	c7 05 38 0e 00 00 00 	movl   $0x0,0xe38
 a7f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a85:	8b 00                	mov    (%eax),%eax
 a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8d:	8b 40 04             	mov    0x4(%eax),%eax
 a90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a93:	72 4d                	jb     ae2 <malloc+0xa6>
      if(p->s.size == nunits)
 a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a98:	8b 40 04             	mov    0x4(%eax),%eax
 a9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9e:	75 0c                	jne    aac <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 10                	mov    (%eax),%edx
 aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa8:	89 10                	mov    %edx,(%eax)
 aaa:	eb 26                	jmp    ad2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaf:	8b 40 04             	mov    0x4(%eax),%eax
 ab2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ab5:	89 c2                	mov    %eax,%edx
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 40 04             	mov    0x4(%eax),%eax
 ac3:	c1 e0 03             	shl    $0x3,%eax
 ac6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 acf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad5:	a3 3c 0e 00 00       	mov    %eax,0xe3c
      return (void*)(p + 1);
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	83 c0 08             	add    $0x8,%eax
 ae0:	eb 3b                	jmp    b1d <malloc+0xe1>
    }
    if(p == freep)
 ae2:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 ae7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aea:	75 1e                	jne    b0a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 aec:	83 ec 0c             	sub    $0xc,%esp
 aef:	ff 75 ec             	pushl  -0x14(%ebp)
 af2:	e8 e5 fe ff ff       	call   9dc <morecore>
 af7:	83 c4 10             	add    $0x10,%esp
 afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b01:	75 07                	jne    b0a <malloc+0xce>
        return 0;
 b03:	b8 00 00 00 00       	mov    $0x0,%eax
 b08:	eb 13                	jmp    b1d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b13:	8b 00                	mov    (%eax),%eax
 b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b18:	e9 6d ff ff ff       	jmp    a8a <malloc+0x4e>
}
 b1d:	c9                   	leave  
 b1e:	c3                   	ret    
