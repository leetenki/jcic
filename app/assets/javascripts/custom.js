$(document).ready(function(){
  // init datepicker
  $( ".datepicker" ).datepicker({
    minDate: new Date(),
    showMonthAfterYear: true,
    yearSuffix: "年",
    dayNamesMin: [ "日", "一", "二", "三", "四", "五", "六" ],
    monthNames: [ "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月" ],
    dateFormat: 'yy/mm/dd'
  });

  // init zeroclipboard
  var clip = new ZeroClipboard($(".d_clip_button"))
});


// function to open panel
function openAlert() {
  $(".alert-panel").fadeIn(700, function(){
    $(".alert-panel").fadeOut(2200, function(){
    });
  });
}

// function to change element's class
function changeClass(id, className) {
  document.getElementById(id).setAttribute("class", className);
}

// function to search and redraw table
function updateCompanyTable() {
  var keyword = simplized(document.getElementById("company_keyword").value.replace(/(^\s+)|(\s+$)/g, ""));
  var tbody = document.getElementById("company_tbody_dynamic");

  for(var i = 0; i < tbody.children.length; i++) {
    var tr = tbody.children[i];
    var searchText = tr.children[4].value;

    if(searchText.indexOf(keyword) == -1) {
      tr.style.display = "none"
    } else {
      tr.style.display = "table-row"
    }
  }
}

// suggestion
function startSuggest() {
  jsonData = document.getElementById("company_data_json");
  if(jsonData) {
    var company_data_list = JSON.parse(jsonData.value);
    new Suggest.Local(
      "company_input",    // from id=company_input
      "suggest",          // to id=suggest
      company_data_list, // data list
      {
        dispMax: 10,
        interval: 10,
        hookBeforeSearch: simplized
      }
    );
  }
}
window.addEventListener? window.addEventListener('load', startSuggest, false) :window.attachEvent('onload', startSuggest);


/************* validates project form *************/
function validateCompanyName() {
  companyInput = document.getElementById("company_input");
  companyNames = JSON.parse(document.getElementById("company_data_json").value);
  var valid = false;
  for(var i = 0; i < companyNames.length; i++) {
    if(companyInput.value == companyNames[i].name) {
      valid = true;
      break;
    }
  }
  return valid;
}

function validateVisaType() {
  var valid = false;
  visaType = document.getElementById("visaType");
  for(var i = 0; i < visaType.children.length; i++) {
    if(visaType.children[i].className.indexOf("active") != -1) {
      valid = true;
      break;
    }
  }
  return valid;
}

function validateChineseName() {
  var valid = true;
  chineseName = document.getElementById("chineseName").value;

  if(chineseName.length <= 0 || chineseName.length > 10) {
    valid = false;
  } else if(CheckLength(chineseName, 0)) {
    valid = false;
  }
  return valid;
}

function validateEnglishName() {
  var valid = true;
  englishName = document.getElementById("englishName").value;

  if(englishName.length <= 0 || englishName.length > 30) {
    valid = false;
  } else if(CheckLength(englishName, 1)) {
    valid = false;
  }
  return valid;
}

function validateTotalPeople() {
  var valid = true;
  var totalPeopleTag = document.getElementById("totalPeople");
  totalPeople = parseInt(totalPeopleTag.value, 10);

  if(totalPeople > 0 && totalPeople <= 999) {
    totalPeopleTag.value = totalPeople;
  } else if(totalPeople <= 0) {
    totalPeopleTag.value = 1;
  } else if(totalPeople > 999) {
    totalPeopleTag.value = 999;
  } else {
    valid = false;
  } 

  return valid;
}

function validateDateArrival() {
  var valid = false;
  var dateArrival = document.getElementById("dateArrival").value;
  var now = new Date();
  var today = new Date(now.getFullYear(), now.getMonth(), now.getDate())

  if(ckDate(dateArrival)) {
    var date = new Date(dateArrival);
    if(date.getTime() >= today.getTime()) {
      var dateLeaving = document.getElementById("dateLeaving").value;
      if(dateLeaving.length == 0) {
        valid = true;
      } else {
        if(ckDate(dateLeaving)) {
          if(new Date(dateLeaving).getTime() >= date.getTime()) {
            document.getElementById("date_leaving_container").setAttribute("class", "field_ok")
            document.getElementById("date_leaving_check").setAttribute("class", "fa fa-check")            
            valid = true;
          }
        }
      }
    }
  }
  return valid;
}

function validateDateLeaving() {
  var valid = false;
  var dateLeaving = document.getElementById("dateLeaving").value;
  var now = new Date();
  var today = new Date(now.getFullYear(), now.getMonth(), now.getDate())

  if(ckDate(dateLeaving)) {
    var date = new Date(dateLeaving);
    if(date.getTime() >= today.getTime()) {
      var dateArrival = document.getElementById("dateArrival").value;
      if(dateArrival.length == 0) {
        valid = true;
      } else {
        if(ckDate(dateArrival)) {
          if(new Date(dateArrival).getTime() <= date.getTime()) {
            document.getElementById("date_arrival_container").setAttribute("class", "field_ok")
            document.getElementById("date_arrival_check").setAttribute("class", "fa fa-check")
            valid = true;
          }
        }
      }
    }
  }
  return valid;
}


/* update icons */
function updateIcon(id, callbackValidation, containerID) {
  var icon = document.getElementById(id);
  var valid = callbackValidation();
  if(valid) {
    icon.setAttribute("class", "fa fa-check")
    if(containerID) {
      document.getElementById(containerID).setAttribute("class", "field_ok")
    }
  } else {
    icon.setAttribute("class", "fa fa-close")
    if(containerID) {
      document.getElementById(containerID).setAttribute("class", "field_with_errors")
    }
  }

  return valid;
}

function updateIconOnlyCheck(id, callbackValidation, containerID) {
  var icon = document.getElementById(id);
  var valid = callbackValidation();
  if(valid) {
    icon.setAttribute("class", "")
    if(containerID) {
      document.getElementById(containerID).setAttribute("class", "field_ok")
    }
  } else {
    icon.setAttribute("class", "")
    if(containerID) {
      document.getElementById(containerID).setAttribute("class", "")
    }
  }  

  return valid;
}

/* utility */
function CheckLength(str,flg) {
  for (var i = 0; i < str.length; i++) {
    var c = str.charCodeAt(i);
    // Shift_JIS: 0x0 ～ 0x80, 0xa0 , 0xa1 ～ 0xdf , 0xfd ～ 0xff
    // Unicode : 0x0 ～ 0x80, 0xf8f0, 0xff61 ～ 0xff9f, 0xf8f1 ～ 0xf8f3
    if ( (c >= 0x0 && c < 0x81) || (c == 0xf8f0) || (c >= 0xff61 && c < 0xffa0) || (c >= 0xf8f1 && c < 0xf8f4)) {
      if(!flg) return true;
    } else {
      if(flg) return true;
    }
  }
  return false;
}

function ckDate(datestr) {
  if(!datestr.match(/^\d{4}\/\d{1,2}\/\d{1,2}$/)){
    return false;
  }
  var vYear = datestr.substr(0, 4) - 0;
  var vMonth = datestr.substr(5, 2) - 1;
  var vDay = datestr.substr(8, 2) - 0;

  if(vMonth >= 0 && vMonth <= 11 && vDay >= 1 && vDay <= 31){
    var vDt = new Date(vYear, vMonth, vDay);
    if(isNaN(vDt)){
        return false;
    }else if(vDt.getFullYear() == vYear && vDt.getMonth() == vMonth && vDt.getDate() == vDay){
        return true;
    }else{
        return false;
    }
  }else{
    return false;
  }
}

// validate before sending
/*
$(function() {
    $('#new_project').submit(function() {
        var failedMessage = "";

        if(!updateIcon('china_company_check', validateCompanyName, 'china_company_container')) {
          failedMessage += "<li>中国旅行社名不正确.</li>";
        }
        if(!updateIcon('visa_type_check', validateVisaType)) {
          failedMessage += "<li>签证种类未选.</li>";
        }
        if(!updateIcon('chinese_name_check', validateChineseName, 'chinese_name_container')) {
          failedMessage += "<li>代表人全名(简体字)不正确.</li>";          
        }
        if(!updateIcon('english_name_check', validateEnglishName, 'english_name_container')) {
          failedMessage += "<li>代表人全名(拼音)不正确.</li>";                    
        }
        if(!updateIcon('total_people_check', validateTotalPeople, 'total_people_container')) {
          failedMessage += "<li>总人数不正确.</li>";                              
        }
        if(!updateIcon('date_arrival_check', validateDateArrival, 'date_arrival_container')) {
          failedMessage += "<li>日本入境日期不正确.</li>";                                        
        }
        if(!updateIcon('date_leaving_check', validateDateLeaving, 'date_leaving_container')) {
          failedMessage += "<li>日本出境日期不正确.</li>";                                                  
        }

        if(failedMessage.length > 0) {
          $("#failed-alert content").html(failedMessage)
          openAlert();
          return false;
        } else {
          return true;
        }
    });
});
*/
