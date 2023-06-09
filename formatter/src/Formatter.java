import java.io.File;
import java.io.FileWriter;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.ArrayList;

import junit.framework.AssertionFailedError;
import junit.framework.Test;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.optional.junit.JUnitResultFormatter;
import org.apache.tools.ant.taskdefs.optional.junit.JUnitTest;

import net.sourceforge.cobertura.coveragedata.CoverageDataFileHandler;
import net.sourceforge.cobertura.coveragedata.ProjectData;
import net.sourceforge.cobertura.coveragedata.TouchCollector;
import net.sourceforge.cobertura.reporting.Main;

public class Formatter implements JUnitResultFormatter {
    private static final String OUT_DIR = System.getProperty("OUT_DIR", "coverage_original_results");
    private static final String SRC_DIR = System.getProperty("SRC_DIR", "src");
    private int testNo = 1;
    private List<String> tests = new ArrayList<String>(32);

    @Override
    public void startTestSuite(JUnitTest junitTest) throws BuildException { }

    @Override
    public void endTestSuite(JUnitTest arg0) throws BuildException {
        // No need to export the coverage data again when the JVM exits.
        // TODO: The thread still runs when the JVM shuts down.
        ProjectData.turnOffAutoSave();

        StringBuffer buf = new StringBuffer();
        int index = 1;
        for (String testName : tests) {
          buf.append(index++ + "," + testName + "\n");
        }

        try {
            FileWriter fw = new FileWriter(Paths.get(OUT_DIR, "testMap.csv").toFile());
            fw.write(buf.toString());
            fw.flush();
            fw.close();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void startTest(Test test) { }

    @Override
    public void endTest(Test test) {
        tests.add(test.toString());
        // No need to create the directories; Cobertura does this during export
        exportAndResetCoverageData(testNo);

        testNo++;
    }

    /**
     * Export and reset the current coverage counters.
     *
     * ProjectData.saveGlobalProjectData would be a more convenient way to do
     * this but it uses a very conservative 1-second sleep to avoid data
     * corruption. This is unnecessary in our use case.
     */
    private void exportAndResetCoverageData(int testNo) {
        String testNoStr = "" + testNo;
        // Get current coverage data and write to disk.
        ProjectData projectData = ProjectData.getGlobalProjectData();
        TouchCollector.applyTouchesOnProjectData(projectData);
        Path serPath = Paths.get(OUT_DIR, testNoStr, "cobertura.ser");
        CoverageDataFileHandler.saveCoverageData(projectData, serPath.toFile());

        // Reset the global coverage data.
        try {
            Field f = ProjectData.class.getDeclaredField("globalProjectData");
            f.setAccessible(true);
            f.set(null, new ProjectData());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        // Export the incremental coverage report.
        try {
            Main.main(new String[]{
                "--format", "html",
                "--datafile", serPath.toString(),
                "--destination", Paths.get(OUT_DIR, testNoStr).toString(),
                SRC_DIR}
            );
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    @Override
    public void addError(Test test, Throwable t) { }

    @Override
    public void addFailure(Test test, AssertionFailedError t) { }

    @Override
    public void setOutput(OutputStream arg0) { }

    @Override
    public void setSystemError(String arg0) { }

    @Override
    public void setSystemOutput(String arg0) { }
}
