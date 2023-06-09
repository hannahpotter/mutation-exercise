const mutants = Array.from(mut_tests.keys());
const iframeStyle = 'style="height:740px;width:550px;"';
var mutNo = null;
var testNo = null;

function setPanes() {
    originalPath = 'coverage/original/' + testNo + '-triangle.html';
    original = '<iframe type="text/html" src="' + originalPath + '"' + iframeStyle + '></iframe>';

    mutantPath = 'coverage/mutants/' + mutNo + '-' + testNo + '-triangle.html';
    mutant = '<iframe type="text/html" src="' + mutantPath + '"' + iframeStyle + '></iframe>'
    document.getElementById("panes").innerHTML= original + mutant;
}

function setExpressions() {
    originalPath = 'static_info/' + mutNo + '/expressionOriginal.svg';
    mutantPath = 'static_info/' + mutNo + '/expressionMutant.svg';
    original = document.createElement('img');
    original.src = originalPath;
    mutant = document.createElement('img');
    mutant.src = mutantPath;
    const element = document.getElementById("expressions");
    element.replaceChildren('');
    element.appendChild(original);
    element.appendChild(mutant);
}

function setASTs() {
    originalPath = 'static_info/' + mutNo + '/visualOriginal.svg';
    mutantPath = 'static_info/' + mutNo + '/visualMutant.svg';
    original = document.createElement('img');
    original.src = originalPath;
    mutant = document.createElement('img');
    mutant.src = mutantPath;
    const element = document.getElementById("asts");
    element.replaceChildren('');
    element.appendChild(original);
    element.appendChild(mutant);
}

function setTables() {
    originalPath = 'static_info/' + mutNo + '/tableOriginal.svg';
    mutantPath = 'static_info/' + mutNo + '/tableMutant.svg';
    original = document.createElement('img');
    original.src = originalPath;
    mutant = document.createElement('img');
    mutant.src = mutantPath;
    const element = document.getElementById("tables");
    element.replaceChildren('');
    element.appendChild(original);
    element.appendChild(mutant);
}

function setNames() {
    document.getElementById("mutant-name").innerHTML= "Mutant " + mutNo;
}

window.onload = function() {
    mutants.map(addMutants);
    setMutant(mutants[0]);
    mutNo = mutants[0];
};

function addMutants(newMutNo) {
    let button = document.createElement("button");
    button.innerHTML = newMutNo;
    button.value = newMutNo;
    if (newMutNo == mutants[0]) {
        button.classList = ["selected"];
    }
    button.onclick = function () {setMutant(newMutNo)};
    document.getElementById("mutNo").appendChild(button);
};

function setMutant(newMutNo) {
    if (newMutNo == mutNo) {
        return;
    }
    mutElements = document.getElementById("mutNo");
    mutButton = mutElements.querySelector(".selected");
    mutButton.classList = [];
    mutNo = newMutNo;
    mutButton = mutElements.querySelector("[value=\"" + mutNo+ "\"]");
    mutButton.classList = ["selected"];

    tests = mut_tests.get(mutNo);
    
    var tests = mut_tests.get(mutNo);
    testNo = tests[0].testNo;

    document.getElementById("testNo").replaceChildren('');
    tests.map(makeTestButton);

    setPanes();
    setNames();
    setASTs();
    setExpressions();
    setTables();
};

function makeTestButton(test) {
    let button = document.createElement("button");
    button.innerHTML = getDisplayName(test.testName);
    button.value = test.testNo;
    if (test.testNo == testNo) {
        button.classList = ["selected"];
    }
    button.onclick = function () {selectTest(test.testNo)};
    document.getElementById("testNo").appendChild(button);
};

function selectTest(newTestNo) {
    if (newTestNo == testNo) {
        return;
    }
    testElements = document.getElementById("testNo");
    testButton = testElements.querySelector(".selected");
    testButton.classList = [];
    testNo = newTestNo;
    testButton = testElements.querySelector("[value=\"" + testNo+ "\"]");
    testButton.classList = ["selected"];

    setPanes();
};

function getDisplayName(testName) {
    var input = testName.match(/\([^\]-]*/)[0];
    input = input.replaceAll(' ', ',');
    var output = testName.match(/INVALID|EQUILATERAL|SCALENE|ISOSCELES/)[0];
    console.log(output);
    if (output == 'INVALID') {
        output = 'INV';
    } else if (output == 'SCALENE') {
        output = 'SCL';
    } else if (output == 'ISOSCELES') {
        output = 'ISO';
    } else if (output == 'EQUILATERAL') {
        output = 'EQI';
    }
    return input + '->' + output
}