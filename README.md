# Triangle
Triangle is an example program for a software testing exercise that focuses on
unit testing and test effectiveness, using code coverage criteria.

#### How to build Triangle and run its tests from the terminal:

1. Change into the Triangle root directory, which contains the *build.xml* build
   file.

2. Run `ant compile` to compile Triangle. The compiled class files will be in
   the *bin* directory.

4. Run `ant test` to run all Triangle unit tests.

5. Run `ant clean` whenever you want to clean up the project (i.e., delete all
   generated files).

#### Mutation analysis

1. Run `./mutation.sh` to compute the mutation score and list all mutants that
are covered (i.e., the mutated code is executed) but live (i.e., the mutant is
not detected by any test).

2. After completion, the following files in the *mutation_results* directory
provide additional information:

    - *killed.csv*:  a summary of whether a covered mutant is still live or was
                     killed with an exception/assertion/timeout.

    - *summary.csv*: a one-line summary that indicates how many mutants were
                     generated and killed, and how long the analysis took.

    - *mutants.log*: a summary of the generated mutants (i.e., what part of the
                     code was changed and how).

    - *covMap.csv*:  a matrix that indicates which tests cover which mutants.

    - *killMap.csv*: a matrix that indicates which tests detect (kill) which
                     mutants. (Only computed and exported if `exportKillMap` is
                     set to true in the `build.xml` build file.)

    - *testMap.csv*: a mapping from test id (TestNo) to test name.

##### Inspecting a mutant - research version
`ant setup` must be run before the first time `make_report.sh` is run. It does **not** need to be run before each subsequent run of `make_report.sh`.

To run the mutant visualization tool run `make_report.sh`. This will generate a web-based report at `mutant_report/index.html`. This can be opened in any web browser.

You can select any live mutant. When a live mutant is selected, you will see:
- the original and mutated expression (with additional parentheses to clarify order of operations)
- the original and mutated expression ASTs with the mutated node(s) highlighted 
- truth tables for reasoning about local conditions that must be true at the expression to observe the mutant. Blue and orange cells in a row highlight truth values that must hold for **state infection** and **propogation**. Yellow cells indicate other conditions that must also hold. So you are trying to find a colored row that can be satisfied (note: you should consider the two tables as one - you must satisfy the whole row across both the original and mutated tables) that additionally will result in a different return value for the function.
- the tests that cover (but do not detect) the mutant. You can select any such test. When a test is selected for a given mutant, you will see:
    - the Cobertura code coverage reports for both the original and mutant programs when that test is executed. This allows you to reason about the execution trace of a test. (note: you can see detailed information about the coverage of conditions by hovering over the condition).

##### Inspecting a mutant - old version

Run `./show_mutant.sh <mutant ID>` to visualize the source code
differences between a mutant and the original program by running.

For example, the following command shows how mutant 1 differs from the original
(i.e., unmutated) program:
`./show_mutant.sh 1`

The output is a unified diff that indicates what line the mutation changed:
```
diff --git a/src/triangle/Triangle.java b/.mutated/mutants/1/triangle/Triangle.java
index f31c52d..3b3899e 100644
--- a/src/triangle/Triangle.java
+++ b/.mutated/mutants/1/triangle/Triangle.java
@@ -3,50 +3,50 @@ package triangle;
 /**
  * An implementation that classifies triangles.
  */
 public class Triangle {

     /**
      * This enum gives the type of the triangle.
      */
     public static enum Type {
         INVALID, SCALENE, EQUILATERAL, ISOSCELES
     };

     /**
      * This static method does the actual classification of a triangle, given the lengths
      * of its three sides.
      */
     public static Type classify(int a, int b, int c) {
-        if (a <= 0 || b <= 0 || c <= 0) {
+        if (a <= 1 || b <= 0 || c <= 0) {
             return Type.INVALID;
         }
         int trian = 0;
         if (a == b) {
             trian = trian + 1;
         }
         if (a == c) {
             trian = trian + 2;
         }
         if (b == c) {
             trian = trian + 3;
         }
         if (trian == 0) {
             if (a + b <= c || a + c <= b || b + c <= a) {
                 return Type.INVALID;
             } else {
                 return Type.SCALENE;
             }
         }
         if (trian > 3) {
             return Type.EQUILATERAL;
         }
         if (trian == 1 && a + b > c) {
             return Type.ISOSCELES;
         } else if (trian == 2 && a + c > b) {
             return Type.ISOSCELES;
         } else if (trian == 3 && b + c > a) {
             return Type.ISOSCELES;
         }
         return Type.INVALID;
     }
 }
```
The line starting with `- ` shows the removed line (original program),
and the line starting with `+ ` shows the line that replaced it (Mutant).

## Troubleshooting

#### Unit tests not running
The test target in the *build.xml* file is configured to (recursively) include
and run all *.java* files in the *test* folder as JUnit test suites.

+ Test suites placed elsewhere will not be run.

#### Outdated version of JUnit
If your system uses an outdated version of JUnit, you may encounter the
following error:
```
[junit] junit/framework/JUnit4TestAdapterCache
[junit] java.lang.NoClassDefFoundError: junit/framework/JUnit4TestAdapterCache
```
Run `ant -lib lib/ <target>` to explicitly use JUnit4, which is provided in the
*lib* directory. For example, run `ant -lib lib/ test` to run all unit tests.

#### Java JDK not installed or misconfigured
If a Java JDK is not installed or properly configured on your system, you may
encounter the following error: 
```
BUILD FAILED
build.xml:17 Unable to find a javac compiler;
```
Make sure that you have a JDK installed and that the JAVA_HOME environment
variable is properly set.
