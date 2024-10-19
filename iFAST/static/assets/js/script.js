const prevBtns = $(".btn-prev");
const nextBtns = $(".btn-next");
const progressSteps = $(".progressbar .step");
const formSteps = $(".form-step");
let currentStep = 0; // Adjusted to start from 0
let formStepsNum = 0;
nextBtns.on("click", function () {

    if (formStepsNum < formSteps.length - 1) {
        formStepsNum++;
        updateFormSteps();
        currentStep++;
        updateProgressbar();
    }
});

prevBtns.on("click", function () {
    if (currentStep > 0) { // Check if it's not the first step
        currentStep--;
        updateFormSteps();
        updateProgressbar();
    }
});

function updateFormSteps() {
    $(".form-step").removeClass("form-step-active");
    $(".form-step").eq(currentStep).addClass("form-step-active");
}

function updateProgressbar() {
    progressSteps.removeClass("progress-step-active");
    progressSteps.slice(0, currentStep + 1).addClass("progress-step-active");

    const progressActive = $(".progress-step-active");
    const progress = $(".progress-bar");
    const totalSteps = progressSteps.length - 1; // Total number of steps (0-indexed)
    const stepWidth = (100 / totalSteps) * currentStep; // Calculate the width based on current step
    progress.width(stepWidth + "%");
}


updateFormSteps();
updateProgressbar();
