package formatter;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import junit.framework.AssertionFailedError;
import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.optional.junit.JUnitResultFormatter;
import org.apache.tools.ant.taskdefs.optional.junit.JUnitTest;

public class Formatter implements JUnitResultFormatter {
    static int testNo = 1;


	@Override
	public void endTestSuite(JUnitTest arg0) throws BuildException {
		File original = new File("cobertura.ser");
 		File copy = new File("initial-cobertura.ser");
		try {
			original.delete();
        	Files.copy(copy.toPath(), original.toPath());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void setOutput(OutputStream arg0) {
	}

	@Override
	public void setSystemError(String arg0) {
	}

	@Override
	public void setSystemOutput(String arg0) {
	}

	@Override
	public void startTestSuite(JUnitTest junitTest) throws BuildException {
		File original = new File("cobertura.ser");
 		File copy = new File("initial-cobertura.ser");
		try {
        	Files.copy(original.toPath(), copy.toPath());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}


	@Override
	public void addError(Test test, Throwable t) {
	}

	@Override
	public void addFailure(Test test, AssertionFailedError t) {
	}

	@Override
	public void endTest(Test test) {
        File original = new File("cobertura.ser");
        File folder = new File("coverage_original_results/" + testNo);
 		File new_result = new File("coverage_original_results/" + testNo+ "/cobertura.ser");
		try {
			folder.mkdirs();
        	Files.copy(original.toPath(), new_result.toPath());
        	original.delete();

			File copy = new File("initial-cobertura.ser");
			Files.copy(copy.toPath(), original.toPath());
		} catch (IOException e) {
			e.printStackTrace();
		}

        testNo++;
	}

	@Override
	public void startTest(Test test) {
	}
}