let flag = true;
function touchCallback(event) {
  switch (event.type) {
    case 'touchstart':
      flag = true;
      break;
    case 'touchmove':
      flag = false;
      break;
    case 'touchend':
      if (flag) {
        // 点击事件
        console.log('你好')
      } else {
        // 滑动事件
      }
    default:
      break;
  }
}
var pages = document.querySelector('.inner');
pages.addEventListener("touchstart", touchCallback);
pages.addEventListener("touchmove", touchCallback);
pages.addEventListener("touchend", touchCallback);