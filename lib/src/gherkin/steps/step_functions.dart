typedef Future<void> StepDefinitionCode();

typedef Future<void> StepDefinitionCode1<TInput1>(TInput1 input1);

typedef Future<void> StepDefinitionCode2<TInput1, TInput2>(
    TInput1 input1, TInput2 input2);

typedef Future<void> StepDefinitionCode3<TInput1, TInput2, TInput3>(
    TInput1 input1, TInput2 input2, TInput3 input3);

typedef Future<void> StepDefinitionCode4<TInput1, TInput2, TInput3, TInput4>(
    TInput1 input1, TInput2 input2, TInput3 input3, TInput4 input4);

typedef Future<void> StepDefinitionCode5<TInput1, TInput2, TInput3, TInput4, TInput5>(
    TInput1 input1,
    TInput2 input2,
    TInput3 input3,
    TInput4 input4,
    TInput5 input5);

// at this point a table should be considered
