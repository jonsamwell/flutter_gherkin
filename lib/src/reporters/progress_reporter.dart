import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:flutter_gherkin/src/reporters/message_level.dart';
import 'package:flutter_gherkin/src/reporters/messages.dart';

class ProgressReporter extends StdoutReporter {
  Future<void> onStepFinished(FinishedMessage message) async {}

  Future<void> message(String message, MessageLevel level) async {
    // ignore messages
  }

  String getStatePrefixIcon() {
    return "√|×|e!";
  }

  String getContext(RunnableDebugInformation context) {
    return "# ${context.filePath}:${context.lineNumber}";
  }
}
// √ And I click on the "change job" link # src\step-definitions\interactions\click-on-element.step.ts:13
//    × And I fill the "finish date" field with "1 December 2020" # src\step-definitions\interactions\fill-the-field-with.step.ts:11
//        WebDriverError: unknown error: cannot focus element
//          (Session info: chrome=70.0.3538.67)
//          (Driver info: chromedriver=2.43.600210 (68dcf5eebde37173d4027fa8635e332711d2874a),platform=Windows NT 10.0.16299 x86_64)
//            at Object.checkLegacyResponse (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\error.js:546:15)
//            at parseHttpResponse (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\http.js:509:13)
//            at doSend.then.response (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\http.js:441:30)
//            at process._tickCallback (internal/process/next_tick.js:68:7)
//        From: Task: WebElement.sendKeys()
//            at thenableWebDriverProxy.schedule (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\webdriver.js:807:17)
//            at WebElement.schedule_ (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\webdriver.js:2010:25)
//            at WebElement.sendKeys (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\webdriver.js:2174:19)
//            at actionFn (C:\easilog\webapp-tests\node_modules\protractor\built\element.js:89:44)
//            at Array.map (<anonymous>)
//            at actionResults.getWebElements.then (C:\easilog\webapp-tests\node_modules\protractor\built\element.js:461:65)
//            at ManagedPromise.invokeCallback_ (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\promise.js:1376:14)
//            at TaskQueue.execute_ (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\promise.js:3084:14)
//            at TaskQueue.executeNext_ (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\promise.js:3067:27)
//            at asyncRun (C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\promise.js:2927:27)
//            at C:\easilog\webapp-tests\node_modules\selenium-webdriver\lib\promise.js:668:7
//            at process._tickCallback (internal/process/next_tick.js:68:7)Error
//            at ElementArrayFinder.applyAction_ (C:\easilog\webapp-tests\node_modules\protractor\built\element.js:459:27)
//            at ElementArrayFinder.(anonymous function).args [as sendKeys] (C:\easilog\webapp-tests\node_modules\protractor\built\element.js:91:29)
//            at ElementFinder.(anonymous function).args [as sendKeys] (C:\easilog\webapp-tests\node_modules\protractor\built\element.js:831:22)
//            at LoginPageObject.<anonymous> (C:\easilog\webapp-tests\src\pages\base.page.ts:101:23)
//            at step (C:\easilog\webapp-tests\src\pages\base.page.js:42:23)
//            at Object.next (C:\easilog\webapp-tests\src\pages\base.page.js:23:53)
//            at fulfilled (C:\easilog\webapp-tests\src\pages\base.page.js:14:58)
//            at process._tickCallback (internal/process/next_tick.js:68:7)
//    - And I fill the "started date" field with "1 October 2021" # src\step-definitions\interactions\fill-the-field-with.step.ts:11
//    - And I fill the "country" field with "United Kingdom" # src\step-definitions\interactions\fill-the-field-with.step.ts:11
