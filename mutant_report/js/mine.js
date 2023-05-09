const mutants = Array.from(mut_tests.keys());
const iframeStyle = 'style="height:720px;width:550px;"';
var mutNo = null;
var testNo = null;

function setPanes() {
    originalPath = 'coverage/original/' + testNo + '-triangle.html';
    original = '<iframe type="text/html" src="' + originalPath + '"' + iframeStyle + '></iframe>';

    mutantPath = 'coverage/mutants/' + mutNo + '-' + testNo + '-triangle.html';
    mutant = '<iframe type="text/html" src="' + mutantPath + '"' + iframeStyle + '></iframe>'
    document.getElementById("panes").innerHTML= original + mutant;
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
};

function makeTestButton(test) {
    let button = document.createElement("button");
    button.innerHTML = test.testName;
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