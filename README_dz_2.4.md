1) Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea

Ответ: 
полный хеш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545
комментарий: Update CHANGELOG.md

как искал:
#git show aefea 

commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

diff --git a/CHANGELOG.md b/CHANGELOG.md
index 86d70e3e0..588d807b1 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -27,6 +27,7 @@ BUG FIXES:
 * backend/s3: Prefer AWS shared configuration over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
 * backend/s3: Prefer ECS credentials over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
 * backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://github.com/hashicorp/terraform/issues/25134))
+* command: Fix bug with global `-v`/`-version`/`--version` flags introduced in 0.13.0beta2 [GH-25277]
 * command/0.13upgrade: Fix `0.13upgrade` usage help text to include options ([#25127](https://github.com/hashicorp/terraform/issues/25127))
 * command/0.13upgrade: Do not add source for builtin provider ([#25215](https://github.com/hashicorp/terraform/issues/25215))
 * command/apply: Fix bug which caused Terraform to silently exit on Windows when using absolute plan path ([#25233](https://github.com/hashicorp/terraform/issues/25233))

==========================================================================

2) Какому тегу соответствует коммит 85024d3?
Ответ: v0.12.23

как искал:
1-й способ:
git show 85024d3 --format=oneline

85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23) v0.12.23
diff --git a/CHANGELOG.md b/CHANGELOG.md
index 1a9dcd0f9..faedc8bf4 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -1,4 +1,4 @@
-## 0.12.23 (Unreleased)
+## 0.12.23 (March 05, 2020)
 ## 0.12.22 (March 05, 2020)
 
 ENHANCEMENTS:
diff --git a/version/version.go b/version/version.go
index 33ac86f5d..bcb6394d2 100644
--- a/version/version.go
+++ b/version/version.go
@@ -16,7 +16,7 @@ var Version = "0.12.23"
 // A pre-release marker for the version. If this is "" (empty string)
 // then it means that it is a final release. Otherwise, this is a pre-release
 // such as "dev" (in development), "beta", "rc1", etc.
-var Prerelease = "dev"
+var Prerelease = ""
 
 // SemVer is an instance of version.Version. This has the secondary
 // benefit of verifying during tests and init time that our version is a





2-й способ. Пытался отформатировать и вывести только хеш и тег.
#git show 85024d3 --pretty=format:"The Hash is %H with tag %d"

The Hash is 85024d3100126de36331c6982bfaac02cdab9e76 with tag  (tag: v0.12.23)
diff --git a/CHANGELOG.md b/CHANGELOG.md
index 1a9dcd0f9..faedc8bf4 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -1,4 +1,4 @@
-## 0.12.23 (Unreleased)
+## 0.12.23 (March 05, 2020)
 ## 0.12.22 (March 05, 2020)
  
   ENHANCEMENTS:
   diff --git a/version/version.go b/version/version.go
   index 33ac86f5d..bcb6394d2 100644
   --- a/version/version.go
   +++ b/version/version.go
   @@ -16,7 +16,7 @@ var Version = "0.12.23"
    // A pre-release marker for the version. If this is "" (empty string)
     // then it means that it is a final release. Otherwise, this is a pre-release
      // such as "dev" (in development), "beta", "rc1", etc.
      -var Prerelease = "dev"
      +var Prerelease = ""
    // SemVer is an instance of version.Version. This has the secondary
    // benefit of verifying during tests and init time that our version is a



Итог попытки вывести отформатированную строку:
так и не понял как избавиться от огроиного описания изменений, а вывести только одну свою отформатированную строку и кроме того есть подозрение, что вместо тега в итоге вывелось какое-то описание, совпадающее с тегом.
Не нашёл точного упоминания что тег вообще можно вывести так каr не нашёл такую %-переменную. 
Это вообще возможно?

3) Сколько родителей у коммита b8d720? Напишите их хеши.
Ответ:
2 родителя: 9ea88f22f  и  56cd7859e

как нашёл:
Сначала вывел дерево до этого коммита:

[root@DevOpser terraform]# git log b8d720 --oneline --graph
*   b8d720f83 Merge pull request #23916 from hashicorp/cgriggs01-stable
|\  
| * 9ea88f22f add/update community provider listings
|/  
*   56cd7859e Merge pull request #23857 from hashicorp/cgriggs01-stable
|\  
| * ffbcf5581 [Website]add checkpoint links
|/  
* 58dcac4b7 (tag: v0.12.19) v0.12.19
и т.д.

потом вывел данные по его предкам, хотя их и так на дееве можно было узнать:

1-й родитель:
[root@DevOpser terraform]# git show b8d720^1
commit 56cd7859e05c36c06b56d013b55a252d0bb7e158
Merge: 58dcac4b7 ffbcf5581
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Mon Jan 13 13:19:09 2020 -0800

Merge pull request #23857 from hashicorp/cgriggs01-stable
[cherry-pick]add checkpoint links

2-й родитель:
[root@DevOpser terraform]# git show b8d720^2
commit 9ea88f22fc6269854151c571162c5bcf958bee2b
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Jan 21 17:08:06 2020 -0800
...
и т.д.


4) Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24

Ответ:
# git log v0.12.23..v0.12.24 --oneline

* 33ff1c03b (tag: v0.12.24) v0.12.24
* b14b74c49 [Website] vmc provider links
* 3f235065b Update CHANGELOG.md
* 6ae64e247 registry: Fix panic when server is unreachable
* 5c619ca1b website: Remove links to the getting started guide's old location
* 06275647e Update CHANGELOG.md
* d5f9411f5 command: Fix bug when using terraform login on Windows
* 4b6d06cc5 Update CHANGELOG.md
* dd01a3507 Update CHANGELOG.md
* 225466bc3 Cleanup after v0.12.23 release

5) Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
Ответ: 8c928e835

Как делал:

# git log -S'func providerSource(' --oneline
8c928e835 main: Consult local directories as potential mirrors of providers

проверяем, что всё так:
# git show 8c928e835 | grep "func providerSource("
+func providerSource(services *disco.Disco) getproviders.Source {

Видим, что в коммите в одном из файлов добавилась строка с объявлением функции


6) Найдите все коммиты в которых была изменена функция globalPluginDirs
Ответ: 
78b122055
52dbf9483
41ab0aef7
66ebff90c
8364383c3

Как делал:

Ищем, коммит где функция была определена:
# git log -S'func globalPluginDirs' --oneline               
8364383c3 Push plugin discovery down into command package

Ищем, в каком файле она содержится:
#git show 8364383c3
листаем и ищем файл где она добавилась
находим

plugins.go


теперь ищем коммиты с изменениями этой  функции в этом файле:

#git log -L :globalPluginDirs:plugins.go --oneline


78b122055 Remove config.go and update things using its aliases

diff --git a/plugins.go b/plugins.go
--- a/plugins.go
+++ b/plugins.go
@@ -16,14 +18,14 @@
 func globalPluginDirs() []string {
 	var ret []string
 	// Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
-	dir, err := ConfigDir()
+	dir, err := cliconfig.ConfigDir()
 	if err != nil {
 		log.Printf("[ERROR] Error finding global config directory: %s", err)
 	} else {
 		machineDir := fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH)
 		ret = append(ret, filepath.Join(dir, "plugins"))
 		ret = append(ret, filepath.Join(dir, "plugins", machineDir))
 	}
 
 	return ret
 }
52dbf9483 keep .terraform.d/plugins for discovery

diff --git a/plugins.go b/plugins.go
--- a/plugins.go
+++ b/plugins.go
@@ -16,13 +16,14 @@
 func globalPluginDirs() []string {
 	var ret []string
 	// Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
 	dir, err := ConfigDir()
 	if err != nil {
 		log.Printf("[ERROR] Error finding global config directory: %s", err)
 	} else {
 		machineDir := fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH)
+		ret = append(ret, filepath.Join(dir, "plugins"))
 		ret = append(ret, filepath.Join(dir, "plugins", machineDir))
 	}
 
 	return ret
 }
41ab0aef7 Add missing OS_ARCH dir to global plugin paths

diff --git a/plugins.go b/plugins.go
--- a/plugins.go
+++ b/plugins.go
@@ -14,12 +16,13 @@
 func globalPluginDirs() []string {
 	var ret []string
 	// Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
 	dir, err := ConfigDir()
 	if err != nil {
 		log.Printf("[ERROR] Error finding global config directory: %s", err)
 	} else {
-		ret = append(ret, filepath.Join(dir, "plugins"))
+		machineDir := fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH)
+		ret = append(ret, filepath.Join(dir, "plugins", machineDir))
 	}
 
 	return ret
 }
66ebff90c move some more plugin search path logic to command

diff --git a/plugins.go b/plugins.go
--- a/plugins.go
+++ b/plugins.go
@@ -16,22 +14,12 @@
 func globalPluginDirs() []string {
 	var ret []string
-
-	// Look in the same directory as the Terraform executable.
-	// If found, this replaces what we found in the config path.
-	exePath, err := osext.Executable()
-	if err != nil {
-		log.Printf("[ERROR] Error discovering exe directory: %s", err)
-	} else {
-		ret = append(ret, filepath.Dir(exePath))
-	}
-
 	// Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
 	dir, err := ConfigDir()
 	if err != nil {
 		log.Printf("[ERROR] Error finding global config directory: %s", err)
 	} else {
 		ret = append(ret, filepath.Join(dir, "plugins"))
 	}
 
 	return ret
 }
8364383c3 Push plugin discovery down into command package

diff --git a/plugins.go b/plugins.go
--- /dev/null
+++ b/plugins.go
@@ -0,0 +16,22 @@
+func globalPluginDirs() []string {
+	var ret []string
+
+	// Look in the same directory as the Terraform executable.
+	// If found, this replaces what we found in the config path.
+	exePath, err := osext.Executable()
+	if err != nil {
+		log.Printf("[ERROR] Error discovering exe directory: %s", err)
+	} else {
+		ret = append(ret, filepath.Dir(exePath))
+	}
+
+	// Look in ~/.terraform.d/plugins/ , or its equivalent on non-UNIX
+	dir, err := ConfigDir()
+	if err != nil {
+		log.Printf("[ERROR] Error finding global config directory: %s", err)
+	} else {
+		ret = append(ret, filepath.Join(dir, "plugins"))
+	}
+
+	return ret
+}


7) Кто автор функции synchronizedWriters ?
Ответ:  Martin Atkins

Как искал:
Ищем коммиты в которых упоминается определение функции:

# git log -S'func synchronizedWriters' --oneline                
bdfea50cc remove unused
5ac311e2a main: synchronize writes to VT100-faker on Windows


Нашли 2 коммита. Выводим подробности по ним:

#git show 5ac311e2a bdfea50cc 

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Wed May 3 16:25:41 2017 -0700

    main: synchronize writes to VT100-faker on Windows
    
    We use a third-party library "colorable" to translate VT100 color
    sequences into Windows console attribute-setting calls when Terraform is
    running on Windows.
    
    colorable is not concurrency-safe for multiple writes to the same console,
    because it writes to the console one character at a time and so two
    concurrent writers get their characters interleaved, creating unreadable
    garble.
    
    Here we wrap around it a synchronization mechanism to ensure that there
    can be only one Write call outstanding across both stderr and stdout,
    mimicking the usual behavior we expect (when stderr/stdout are a normal
    file handle) of each Write being completed atomically.

diff --git a/main.go b/main.go
index b94de2ebc..237581200 100644
--- a/main.go
+++ b/main.go
@@ -258,6 +258,15 @@ func copyOutput(r io.Reader, doneCh chan<- struct{}) {
 	if runtime.GOOS == "windows" {
 		stdout = colorable.NewColorableStdout()
 		stderr = colorable.NewColorableStderr()
+
+		// colorable is not concurrency-safe when stdout and stderr are the
+		// same console, so we need to add some synchronization to ensure that
+		// we can't be concurrently writing to both stderr and stdout at
+		// once, or else we get intermingled writes that create gibberish
+		// in the console.
+		wrapped := synchronizedWriters(stdout, stderr)
+		stdout = wrapped[0]
+		stderr = wrapped[1]
 	}
 
 	var wg sync.WaitGroup
diff --git a/synchronized_writers.go b/synchronized_writers.go
new file mode 100644
index 000000000..2533d1316
--- /dev/null
+++ b/synchronized_writers.go
@@ -0,0 +1,31 @@
+package main
+
+import (
+	"io"
+	"sync"
+)
+
+type synchronizedWriter struct {
+	io.Writer
+	mutex *sync.Mutex
+}
+
+// synchronizedWriters takes a set of writers and returns wrappers that ensure
+// that only one write can be outstanding at a time across the whole set.
+func synchronizedWriters(targets ...io.Writer) []io.Writer {
+	mutex := &sync.Mutex{}
+	ret := make([]io.Writer, len(targets))
+	for i, target := range targets {
+		ret[i] = &synchronizedWriter{
+			Writer: target,
+			mutex:  mutex,
+		}
+	}
+	return ret
+}
+
+func (w *synchronizedWriter) Write(p []byte) (int, error) {
+	w.mutex.Lock()
+	defer w.mutex.Unlock()
+	return w.Writer.Write(p)
+}

commit bdfea50cc85161dea41be0fe3381fd98731ff786
Author: James Bardin <j.bardin@gmail.com>
Date:   Mon Nov 30 18:02:04 2020 -0500

    remove unused

diff --git a/commands.go b/commands.go
index c889d37f1..d726e8ae0 100644
--- a/commands.go
+++ b/commands.go
@@ -46,11 +46,6 @@ var HiddenCommands map[string]struct{}
 // Ui is the cli.Ui used for communicating to the outside world.
 var Ui cli.Ui
 
-const (
-	ErrorPrefix  = "e:"
-	OutputPrefix = "o:"
-)
-
 func initCommands(
 	originalWorkingDir string,
 	config *cliconfig.Config,
diff --git a/synchronized_writers.go b/synchronized_writers.go
deleted file mode 100644
index 2533d1316..000000000
--- a/synchronized_writers.go
+++ /dev/null
@@ -1,31 +0,0 @@
-package main
-
-import (
-	"io"
-	"sync"
-)
-
-type synchronizedWriter struct {
-	io.Writer
-	mutex *sync.Mutex
-}
-
-// synchronizedWriters takes a set of writers and returns wrappers that ensure
-// that only one write can be outstanding at a time across the whole set.
-func synchronizedWriters(targets ...io.Writer) []io.Writer {
-	mutex := &sync.Mutex{}
-	ret := make([]io.Writer, len(targets))
-	for i, target := range targets {
-		ret[i] = &synchronizedWriter{
-			Writer: target,
-			mutex:  mutex,
-		}
-	}
-	return ret
-}
-
-func (w *synchronizedWriter) Write(p []byte) (int, error) {
-	w.mutex.Lock()
-	defer w.mutex.Unlock()
-	return w.Writer.Write(p)
-}

Видим, что в одном коммите фукнкия была добавлена автором, а в другом удалена, значит мы теперь знаем автора.
