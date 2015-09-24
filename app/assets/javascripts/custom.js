function initBirthdayPicker(picker) {
  picker.datepicker({
    defaultDate: new Date(1970, 0, 1),
    maxDate: new Date(),
    changeYear: true,
    changeMonth: true,
    yearRange: "-100:+100",
    showMonthAfterYear: true,
    yearSuffix: "年",
    dayNamesMin: [ "日", "一", "二", "三", "四", "五", "六" ],
    monthNames: [ "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月" ],
    monthNamesShort: [ "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月" ],
    dateFormat: 'yy/mm/dd'
  });
}

$(document).ready(function(){  
  // init datepicker
  $( ".datepicker:not(.birthdaypicker)" ).datepicker({
    minDate: new Date(),
    showMonthAfterYear: true,
    yearSuffix: "年",
    dayNamesMin: [ "日", "一", "二", "三", "四", "五", "六" ],
    monthNames: [ "1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月" ],
    dateFormat: 'yy/mm/dd'
  });

  initBirthdayPicker($(".birthdaypicker"));

  // init zeroclipboard
  var clip = new ZeroClipboard($(".d_clip_button"));

  // initialValidation of projects table
  var clientsContainer = document.getElementById("clients_container");
  var identityContainer = document.getElementById("identity_container");
  var schedulesContainer = document.getElementById("schedules_container");
  if(clientsContainer && identityContainer && schedulesContainer) {
    initialValidation();
  }

  // init now_loading
  $(".require-loading").click(function() {
    $("#now_loading")[0].style.display = "block";
  })

  $("#now_loading")[0].style.display = "none";
});


// function to open panel
function openAlert() {
  $(".alert-panel").fadeIn(700, function(){
    $(".alert-panel").fadeOut(5200, function(){
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

  if(chineseName.length <= 1 || chineseName.length > 10) {
    valid = false;
  } else if(/*CheckLength(chineseName, 0)*/ !CheckLength(chineseName, 1)) {
    valid = false;
  }
  return valid;
}

function validateEnglishName() {
  var valid = true;
  englishName = document.getElementById("englishName").value;

  if(englishName.length <= 3 || englishName.length > 30) {
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

  if(totalPeople > 0 && totalPeople <= 200) {
    totalPeopleTag.value = totalPeople;
  } else if(totalPeople <= 0) {
    totalPeopleTag.value = 1;
  } else if(totalPeople > 200) {
    totalPeopleTag.value = 200;
  } else {
    valid = false;
  } 

  return valid;
}


function validateDateArrival() {
  var valid = false;
  var dateArrival = replaceDateStr(document.getElementById("dateArrival").value);
  $("#dateArrival")[0].value = dateArrival;

  var today = getAbsoluteToday();

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
  var dateLeaving = replaceDateStr(document.getElementById("dateLeaving").value);
  $("#dateLeaving")[0].value = dateLeaving;

  var today = getAbsoluteToday()

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





function validateDateArrivalAndRegenerateSchedules() {
  var valid = false;
  var scheduleActive = false;
  var dateArrival = document.getElementById("dateArrival").value;
  var today = getAbsoluteToday();
  if(ckDate(dateArrival)) {
    var date = new Date(dateArrival);
    if(date.getTime() >= today.getTime()) {
      var dateLeaving = document.getElementById("dateLeaving").value;
      if(dateLeaving.length == 0) {
        valid = true;
      } else {
        if(ckDate(dateLeaving)) {
          if(new Date(dateLeaving).getTime() >= date.getTime()) {
            document.getElementById("date_leaving_container").setAttribute("class", "field_ok");
            document.getElementById("date_leaving_check").setAttribute("class", "fa fa-check"); 
            regenerateScheduleTable();   
            valid = true;
            scheduleActive = true;
          }
        }
      }
    }
  }

  if(scheduleActive) {
    $("#schedules_container table textarea").removeAttr("disabled");
  } else {
    $("#schedules_container table textarea").attr("disabled", "disabled");    
  }
  return valid;
}

function validateDateLeavingAndRegenerateSchedules() {
  var valid = false;
  var scheduleActive = false;
  var dateLeaving = document.getElementById("dateLeaving").value;
  var today = getAbsoluteToday()

  if(ckDate(dateLeaving)) {
    var date = new Date(dateLeaving);
    if(date.getTime() >= today.getTime()) {
      var dateArrival = document.getElementById("dateArrival").value;
      if(dateArrival.length == 0) {
        valid = true;
      } else {
        if(ckDate(dateArrival)) {
          if(new Date(dateArrival).getTime() <= date.getTime()) {
            document.getElementById("date_arrival_container").setAttribute("class", "field_ok");
            document.getElementById("date_arrival_check").setAttribute("class", "fa fa-check");
            regenerateScheduleTable();
            valid = true;
            scheduleActive = true;
          }
        }
      }
    }
  }

  if(scheduleActive) {
    $("#schedules_container table textarea").removeAttr("disabled");
  } else {
    $("#schedules_container table textarea").attr("disabled", "disabled");    
  }
  return valid;

  return valid;
}





function validateDates() {
  var valid = false;
  if(validateDateLeaving() && validateDateArrival()) {
    var lastDay = new Date(document.getElementById("dateLeaving").value);
    var firstDay = new Date(document.getElementById("dateArrival").value);
    var stay_term = subDate(lastDay, firstDay) + 1;

    if(stay_term == $("#schedules_container table .date_container").length) {
      valid = true;

      var term = 0;
      $("#schedules_container table .date_container").each(function() {
        var dateStr = $(this).children("textarea")[0].value.match(/^\d{4}\/\d{1,2}\/\d{1,2}/);
        if(!dateStr || dateStr.length <= 0 || !ckDate(dateStr[0]) || ((new Date(dateStr[0])).getTime() != addDate(firstDay, term).getTime())) {
          valid = false;
        }
        term += 1;
      });
    }
  }

  return valid;
}

function validateDatesAndUpdateIcon() {
  var valid = false;
  if(validateDateLeaving() && validateDateArrival()) {
    var lastDay = new Date(document.getElementById("dateLeaving").value);
    var firstDay = new Date(document.getElementById("dateArrival").value);
    var stay_term = subDate(lastDay, firstDay) + 1;

    if(stay_term == $("#schedules_container table .date_container").length) {
      valid = true;

      var term = 0;
      $("#schedules_container table .date_container").each(function() {
        var dateStr = $(this).children("textarea")[0].value.match(/^\d{4}\/\d{1,2}\/\d{1,2}/);
        if(!dateStr || dateStr.length <= 0 || !ckDate(dateStr[0]) || ((new Date(dateStr[0])).getTime() != addDate(firstDay, term).getTime())) {
          this.className = "date_container field_with_errors"
          $(this).children("i")[0].className = "fa fa-close"
          valid = false;
        } else {
          this.className = "date_container field_ok";      
          $(this).children("i")[0].className = "fa fa-check"
        }
        term += 1;
      });
    } else {
      $("#schedules_container table .date_container").each(function() {
        this.className = "date_container field_with_errors"
        $(this).children("i")[0].className = "fa fa-close"
      });
    }
  } else {
    $("#schedules_container table .date_container").each(function() {
      this.className = "date_container field_with_errors"
      $(this).children("i")[0].className = "fa fa-close"
    })    
  }

  return valid
}

function validatePlan(id) {
  var inputText = $("#" + id + " textarea")[0].value;

  if(inputText.length > 0 && inputText.length <= 200) {
    return true
  } else {
    return false;
  }
}

function validateHotel(id) {
  var inputText = $("#" + id + " textarea")[0].value;
  if(inputText.length > 0 && inputText.length <= 100) {
    return true
  } else {
    return false;
  }
}


function validateGender(id) {
  var valid = false;

  var genderGroup = $('#' + id + ' .form-group label')
  genderGroup.each(function() {
    if(this.className.indexOf("active") != -1) {
      valid = true;
    }
  })
  return valid;
}



function validateChineseNameById(id) {
  var inputText = $("#" + id + " input")[0].value;

  if(inputText.length > 1 && inputText.length <= 10 /*&& !CheckLength(inputText, 0)*/ && CheckLength(inputText, 1)) {
    return true
  } else {
    return false;
  }
}

function validateEnglishNameById(id) {
  var inputText = $("#" + id + " input")[0].value;

  if(inputText.length > 3 && inputText.length <= 30 && !CheckLength(inputText, 1)) {
    return true
  } else {
    return false;
  }
}

function validatePassportNo(id) {
  var passportValid = true;

  var inputText = $("#" + id + " input")[0].value;
  if(inputText.length >= 8 && inputText.length <= 11 && !CheckLength(inputText, 1)) {

    $(".passport_no_container:not(#" + id + ") input").each(function() { 
      if(this.value == inputText) {
        passportValid = false;
      }
    });
  } else {
    passportValid = false;
  }

  return passportValid;
}

function validateHometown(id) {
  var inputText = $("#" + id + " input")[0].value;

  if(inputText.length >= 2 && inputText.length <= 10) {
    return true
  } else {
    return false;
  }
}


function validateBirthday(id) {
  var inputText = replaceDateStr($("#" + id + " input")[0].value);
  $("#" + id + " input")[0].value = inputText;

  if(ckDate(inputText) && (new Date(inputText).getTime()) < getAbsoluteToday().getTime()) {
    return true;
  } else {
    return false;
  }
}

function validateAndUpdateField(id, className, callbackValidation) {
  var valid = callbackValidation(id);
  if(valid) {
    $("#" + id)[0].className = className + " field_ok";    
    $("#" + id + " i")[0].className = "fa fa-check";    
  } else {
    $("#" + id)[0].className = className + " field_with_errors";    
    $("#" + id + " i")[0].className = "fa fa-close";    
  }

  return valid;
}

function validateAndUpdateFieldIgnoreError(id, className, callbackValidation) {
  var valid = callbackValidation(id);
  if(valid) {
    $("#" + id)[0].className = className + " field_ok";    
    $("#" + id + " i")[0].className = "fa fa-check";    
  } else {
    $("#" + id)[0].className = className;    
    $("#" + id + " i")[0].className = "";    
  }

  return valid;
}

function validateAndUpdateFieldOnlyCheck(id, className, callbackValidation) {
  var valid = callbackValidation(id);
  if(valid) {
    $("#" + id)[0].className = className + " field_ok";    
    $("#" + id + " i")[0].className = "";    
  } else {
    $("#" + id)[0].className = className;    
    $("#" + id + " i")[0].className = "";    
  }

  return valid;
}

// function to regenerate schedules table
function regenerateScheduleTable() {
  var lastDay = new Date(document.getElementById("dateLeaving").value);
  var firstDay = new Date(document.getElementById("dateArrival").value);
  var stay_term = subDate(lastDay, firstDay) + 1;


  var trs = $("#schedules_container table tr");
  if(stay_term >= trs.length) {
    // reset date
    var i = 0;
    trs.each(function() {
      $(this).find(".date_container textarea")[0].value = formatDate(addDate(firstDay, i))
      i += 1;
    })

    // add line
    for(; i < stay_term; i++) {
      $("#schedules_container table tbody").append(createScheduleTag(i, formatDate(addDate(firstDay, i))));
    }
  } else {
    // delete line
    do {
      trs[trs.length-1].remove();
      trs = $("#schedules_container table tbody tr");
    } while(trs.length > stay_term);

    // reset date
    trs = $("#schedules_container table tr");
    var i = 0;
    trs.each(function() {
      $(this).find(".date_container textarea")[0].value = formatDate(addDate(firstDay, i))
      i += 1;
    })
  }

  // revalidate
  $("#schedules-total").text($("#schedules_container tr").length);
  validateDatesAndUpdateIcon();
}


function autoCompleteFirstChineseName() {
  if(updateIcon('chinese_name_check', validateChineseName, 'chinese_name_container') && $("#clients_container table tr").length > 0) {
    var firstChineseName = $("#clients_container table .chinese_name_container input")[0];
    if(!firstChineseName.value) {
      firstChineseName.value = $("#chineseName")[0].value;
      validateAndUpdateField($("#clients_container table .chinese_name_container")[0].id, 'chinese_name_container', validateChineseNameById);

      $("#totalPeople")[0].value = $("#clients_container table tr").length;
      updateIcon('total_people_check', validateTotalPeople, 'total_people_container')
    }
  }
}

function autoCompleteFirstEnglishName() {
  if(updateIcon('english_name_check', validateEnglishName, 'english_name_container') && $("#clients_container table tr").length > 0) {
    var firstEnglishName = $("#clients_container table .english_name_container input")[0];
    if(!firstEnglishName.value) {
      firstEnglishName.value = $("#englishName")[0].value;
      validateAndUpdateField($("#clients_container table .english_name_container")[0].id, 'english_name_container', validateEnglishNameById);

      $("#totalPeople")[0].value = $("#clients_container table tr").length;
      updateIcon('total_people_check', validateTotalPeople, 'total_people_container')
    }
  }
}

function initClientTableFromTotalPeople() {
  if(updateIcon('total_people_check', validateTotalPeople, 'total_people_container')) {
    var totalPeople = parseInt($("#totalPeople")[0].value);
    if(totalPeople >= $("#clients_container table tr").length) {
      var newRowLength = totalPeople - $("#clients_container table tr").length;
      for(var i = 0; i < newRowLength; i++) {
        addClientRow();
      }
    } else {
      var oldRowLength = $("#clients_container table tr").length - totalPeople;
      for(var i = 0; i < oldRowLength; i++) {
        removeClientRow($("#clients_container table tr:last")[0].id);
      }
    }
  }
}

function overwriteHiddenValueInClients() {
  hiddenTags = $("#clients_container table input:hidden");
  trs = $("#clients_container table tr");

  var overwriteCount = Math.min(hiddenTags.length, trs.length);
  var i = 0;
  var index = 0;
  for(; i < overwriteCount; i++) {
    var index = trs[i].id.split("_")[1];
    hiddenTags[i].name = "project[clients_attributes][" + index + "][id]";
    hiddenTags[i].id = "project_clients_attributes_" + index + "_id";
  }

  if(hiddenTags.length != 0 && hiddenTags.length > trs.length) {
    for(; i < hiddenTags.length; i++) {
      index = parseInt(index) + 1;
      hiddenTags[i].name = "project[clients_attributes][" + index + "][id]";
      hiddenTags[i].id = "project_clients_attributes_" + index + "_id";
    }
  }
}

// function to recompute index of rows
function reComputeClientsIndex() {
  $("#clients-total").text($("#clients_container table tr").length);  

  var i = 1;
  $("#clients_container table .index").each(function() {
    $(this).text(i++);
  });
}

// function to add new client row to table
function addClientRow() {
  index = 0;
  if($("#clients_container table tr").length > 0) {
    index = parseInt($("#clients_container table tr:last")[0].id.split("_")[1]) + 1;
  }

  var newRow = createClientTag(index);
  $("#clients_container table tbody").append(newRow);
  overwriteHiddenValueInClients();

  $("#totalPeople")[0].value = $("#clients_container table tr").length;
  updateIcon('total_people_check', validateTotalPeople, 'total_people_container');

  // update clients number
  reComputeClientsIndex();

  return "client_" + index;
}

function removeClientRow(id) {
  if($("#clients_container table tr").length >= 1) {
    if($("#clients_container table tr").length == 1) {
      addClientRow();
    }

    $("#" + id).remove();
    overwriteHiddenValueInClients();

    $("#totalPeople")[0].value = $("#clients_container table tr").length;
    updateIcon('total_people_check', validateTotalPeople, 'total_people_container');

    // update clients number
    reComputeClientsIndex();
  }
}

// function to build tr tag for client
function createClientTag(index) {
  var trNode = document.createElement("tr");
  trNode.setAttribute("id", "client_" + index);
  var tdNode;
  var containerNode;
  var labelNode;
  var iconNode;
  var inputTag;

  // chinese name tag
  tdNode = document.createElement("td");
  tdNode.setAttribute("class", "col col-md-2 col-sm-2 col-xs-2")
  trNode.appendChild(tdNode);

  var indexNode = document.createElement("span");
  indexNode.setAttribute("class", "index");
  tdNode.appendChild(indexNode);

  containerNode = document.createElement("div");
  containerNode.setAttribute("id", "clients_chinese_name_container_" + index);
  containerNode.setAttribute("class", "chinese_name_container");
  tdNode.appendChild(containerNode);

  labelNode = document.createElement("label");
  labelNode.setAttribute("for", "project_clients_attributes_" + index + "_name_chinese");
  labelNode.appendChild(document.createTextNode("中文名"))
  containerNode.appendChild(labelNode)

  containerNode.appendChild(document.createTextNode(" "));

  iconNode = document.createElement("i");
  iconNode.setAttribute("id", "clients_chinese_name_" + index);
  containerNode.appendChild(iconNode)

  inputTag = document.createElement("input");
  inputTag.setAttribute("autocomplete", "off");
  inputTag.setAttribute("class", "form-control");
  inputTag.setAttribute("placeholder", "");
  inputTag.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('clients_chinese_name_container_" + index + "', 'chinese_name_container', validateChineseNameById)");
  inputTag.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('clients_chinese_name_container_" + index + "', 'chinese_name_container', validateChineseNameById)");
  inputTag.setAttribute("onchange", "validateAndUpdateField('clients_chinese_name_container_" + index + "', 'chinese_name_container', validateChineseNameById)");
  inputTag.setAttribute("onblur", "validateAndUpdateField('clients_chinese_name_container_" + index + "', 'chinese_name_container', validateChineseNameById)");
  inputTag.setAttribute("type", "text");
  inputTag.setAttribute("maxlength", "10");
  inputTag.setAttribute("name", "project[clients_attributes][" + index + "][name_chinese]");
  inputTag.setAttribute("id", "project_clients_attributes_" + index + "_name_chinese")
  containerNode.appendChild(inputTag);


  // english name tag
  tdNode = document.createElement("td");
  tdNode.setAttribute("class", "col col-md-2 col-sm-2 col-xs-2")
  trNode.appendChild(tdNode);

  containerNode = document.createElement("div");
  containerNode.setAttribute("id", "clients_english_name_container_" + index);
  containerNode.setAttribute("class", "english_name_container");
  tdNode.appendChild(containerNode);

  labelNode = document.createElement("label");
  labelNode.setAttribute("for", "project_clients_attributes_" + index + "_name_english");
  labelNode.appendChild(document.createTextNode("英文名"))
  containerNode.appendChild(labelNode)

  containerNode.appendChild(document.createTextNode(" "));

  iconNode = document.createElement("i");
  iconNode.setAttribute("id", "clients_english_name_" + index);
  containerNode.appendChild(iconNode)

  inputTag = document.createElement("input");
  inputTag.setAttribute("autocomplete", "off");
  inputTag.setAttribute("class", "form-control");
  inputTag.setAttribute("placeholder", "");
  inputTag.setAttribute("maxlength", "30");  
  inputTag.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('clients_english_name_container_" + index + "', 'english_name_container', validateEnglishNameById)");
  inputTag.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('clients_english_name_container_" + index + "', 'english_name_container', validateEnglishNameById)");
  inputTag.setAttribute("onchange", "validateAndUpdateField('clients_english_name_container_" + index + "', 'english_name_container', validateEnglishNameById)");
  inputTag.setAttribute("onblur", "validateAndUpdateField('clients_english_name_container_" + index + "', 'english_name_container', validateEnglishNameById)");
  inputTag.setAttribute("type", "text");
  inputTag.setAttribute("name", "project[clients_attributes][" + index + "][name_english]");
  inputTag.setAttribute("id", "project_clients_attributes_" + index + "_name_english")
  containerNode.appendChild(inputTag);



  // gender tag
  tdNode = document.createElement("td");
  tdNode.setAttribute("class", "col col-md-2 col-sm-2 col-xs-2")
  trNode.appendChild(tdNode);

  containerNode = document.createElement("div");
  containerNode.setAttribute("id", "clients_gender_container_" + index);
  containerNode.setAttribute("class", "gender_container");
  tdNode.appendChild(containerNode);

  labelNode = document.createElement("label");
  labelNode.setAttribute("for", "project_clients_attributes_" + index + "_gender");
  labelNode.appendChild(document.createTextNode("性别"))
  containerNode.appendChild(labelNode)

  containerNode.appendChild(document.createTextNode(" "));

  iconNode = document.createElement("i");
  iconNode.setAttribute("id", "clients_gender_" + index);
  containerNode.appendChild(iconNode)

  var formGroup = document.createElement("div");
  formGroup.setAttribute("class", "form-group");
  containerNode.appendChild(formGroup);

  var btnGroup = document.createElement("div");
  btnGroup.setAttribute("id", "gender_type_" + index);
  btnGroup.setAttribute("class", "gender_type btn-group")
  btnGroup.setAttribute("data-toggle", "buttons");
  btnGroup.setAttribute("onchange", "validateAndUpdateField('clients_gender_container_" + index + "', 'gender_container', validateGender)")
  formGroup.appendChild(btnGroup);

  var btnLabel = document.createElement("label");
  btnLabel.setAttribute("class", "btn btn-default");
  var radioBtn = document.createElement("input");
  radioBtn.setAttribute("type", "radio");
  radioBtn.setAttribute("autocomplete", "off");
  radioBtn.setAttribute("value", "male");
  radioBtn.setAttribute("name", "project[clients_attributes][" + index + "][gender]");
  btnLabel.appendChild(document.createTextNode("男"));
  btnLabel.appendChild(radioBtn);
  btnGroup.appendChild(btnLabel);

  btnLabel = document.createElement("label");
  btnLabel.setAttribute("class", "btn btn-default");
  radioBtn = document.createElement("input");
  radioBtn.setAttribute("type", "radio");
  radioBtn.setAttribute("autocomplete", "off");
  radioBtn.setAttribute("value", "female");
  radioBtn.setAttribute("name", "project[clients_attributes][" + index + "][gender]");
  btnLabel.appendChild(document.createTextNode("女"));
  btnLabel.appendChild(radioBtn);
  btnGroup.appendChild(btnLabel);


  // hometown tag
  tdNode = document.createElement("td");
  tdNode.setAttribute("class", "col col-md-2 col-sm-2 col-xs-2")
  trNode.appendChild(tdNode);

  containerNode = document.createElement("div");
  containerNode.setAttribute("id", "clients_hometown_container_" + index);
  containerNode.setAttribute("class", "hometown_container");
  tdNode.appendChild(containerNode);

  labelNode = document.createElement("label");
  labelNode.setAttribute("for", "project_clients_attributes_" + index + "_hometown");
  labelNode.appendChild(document.createTextNode("签发地点"))
  containerNode.appendChild(labelNode)

  containerNode.appendChild(document.createTextNode(" "));

  iconNode = document.createElement("i");
  iconNode.setAttribute("id", "clients_hometown_" + index);
  containerNode.appendChild(iconNode)

  inputTag = document.createElement("input");
  inputTag.setAttribute("autocomplete", "off");
  inputTag.setAttribute("class", "form-control");
  inputTag.setAttribute("placeholder", "");
  inputTag.setAttribute("maxlength", "10");  
  inputTag.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('clients_hometown_container_" + index + "', 'hometown_container', validateHometown)");
  inputTag.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('clients_hometown_container_" + index + "', 'hometown_container', validateHometown)");
  inputTag.setAttribute("onchange", "validateAndUpdateField('clients_hometown_container_" + index + "', 'hometown_container', validateHometown)");
  inputTag.setAttribute("onblur", "validateAndUpdateField('clients_hometown_container_" + index + "', 'hometown_container', validateHometown)");
  inputTag.setAttribute("type", "text");
  inputTag.setAttribute("name", "project[clients_attributes][" + index + "][hometown]");
  inputTag.setAttribute("id", "project_clients_attributes_" + index + "_hometown")
  containerNode.appendChild(inputTag);


  // birthday tag
  tdNode = document.createElement("td");
  tdNode.setAttribute("class", "col col-md-2 col-sm-2 col-xs-2")
  trNode.appendChild(tdNode);

  containerNode = document.createElement("div");
  containerNode.setAttribute("id", "clients_birthday_container_" + index);
  containerNode.setAttribute("class", "birthday_container");
  tdNode.appendChild(containerNode);

  labelNode = document.createElement("label");
  labelNode.setAttribute("for", "project_clients_attributes_" + index + "_birthday");
  labelNode.appendChild(document.createTextNode("出身日期"))
  containerNode.appendChild(labelNode)

  containerNode.appendChild(document.createTextNode(" "));

  iconNode = document.createElement("i");
  iconNode.setAttribute("id", "clients_birthday_" + index);
  containerNode.appendChild(iconNode)

  inputTag = document.createElement("input");
  inputTag.setAttribute("autocomplete", "off");
  inputTag.setAttribute("class", "form-control datepicker birthdaypicker");
  inputTag.setAttribute("placeholder", "");
  inputTag.setAttribute("maxlength", "10");
  inputTag.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('clients_birthday_container_" + index + "', 'birthday_container', validateBirthday)");
  inputTag.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('clients_birthday_container_" + index + "', 'birthday_container', validateBirthday)");
  inputTag.setAttribute("onchange", "validateAndUpdateField('clients_birthday_container_" + index + "', 'birthday_container', validateBirthday)");
  inputTag.setAttribute("onblur", "validateAndUpdateField('clients_birthday_container_" + index + "', 'birthday_container', validateBirthday)");
  inputTag.setAttribute("size", "10");
  inputTag.setAttribute("type", "text");
  inputTag.setAttribute("name", "project[clients_attributes][" + index + "][birthday]");
  inputTag.setAttribute("id", "project_clients_attributes_" + index + "_birthday")
  containerNode.appendChild(inputTag);
  initBirthdayPicker($(inputTag));


  // passport_no tag
  tdNode = document.createElement("td");
  tdNode.setAttribute("class", "col col-md-2 col-sm-2 col-xs-2")
  trNode.appendChild(tdNode);

  containerNode = document.createElement("div");
  containerNode.setAttribute("id", "clients_passport_no_container_" + index);
  containerNode.setAttribute("class", "passport_no_container");
  tdNode.appendChild(containerNode);

  labelNode = document.createElement("label");
  labelNode.setAttribute("for", "project_clients_attributes_" + index + "_passport_no");
  labelNode.appendChild(document.createTextNode("护照号"))
  containerNode.appendChild(labelNode);

  containerNode.appendChild(document.createTextNode(" "));

  iconNode = document.createElement("i");
  iconNode.setAttribute("id", "clients_passport_no_" + index);
  containerNode.appendChild(iconNode);

  var closeNode = document.createElement("div");
  closeNode.setAttribute("class", "remove_client");
  closeNode.setAttribute("onclick", "removeClientRow('client_" + index + "')")
  closeNode.appendChild(document.createTextNode("×"));
  containerNode.appendChild(closeNode);

  inputTag = document.createElement("input");
  inputTag.setAttribute("autocomplete", "off");
  inputTag.setAttribute("class", "form-control");
  inputTag.setAttribute("placeholder", "");
  inputTag.setAttribute("maxlength", "11");  
  inputTag.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('clients_passport_no_container_" + index + "', 'passport_no_container', validatePassportNo)");
  inputTag.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('clients_passport_no_container_" + index + "', 'passport_no_container', validatePassportNo)");
  inputTag.setAttribute("onchange", "validateAndUpdateField('clients_passport_no_container_" + index + "', 'passport_no_container', validatePassportNo)");
  inputTag.setAttribute("onblur", "validateAndUpdateField('clients_passport_no_container_" + index + "', 'passport_no_container', validatePassportNo)");
  inputTag.setAttribute("type", "text");
  inputTag.setAttribute("name", "project[clients_attributes][" + index + "][passport_no]");
  inputTag.setAttribute("id", "project_clients_attributes_" + index + "_passport_no")
  containerNode.appendChild(inputTag);

  return trNode;  
}


// function to build tr tag for schedule
function createScheduleTag(index, dateText) {
  var trNode = document.createElement("tr");

  // date tag
  var dateTdNode = document.createElement("td");
  dateTdNode.setAttribute("class", "col col-md-2 col-sm-2 col-lg-2 col-xs-3 date");
  trNode.appendChild(dateTdNode);

  var dateIndexNode = document.createElement("span");
  dateIndexNode.setAttribute("class", "date-index");
  dateIndexNode.appendChild(document.createTextNode($("#schedules_container tr").length));
  dateTdNode.appendChild(dateIndexNode);

  var dateContainerNode = document.createElement("div");
  dateContainerNode.setAttribute("id", "schedules_date_container_" + index);
  dateContainerNode.setAttribute("class", "date_container");
  dateTdNode.appendChild(dateContainerNode);

  var dateLabelNode = document.createElement("label");
  dateLabelNode.setAttribute("for", "project_schedules_attributes_" + index + "_date");
  dateLabelNode.appendChild(document.createTextNode("日期"));
  dateContainerNode.appendChild(dateLabelNode);

  dateContainerNode.appendChild(document.createTextNode(" "));

  var dateIconNode = document.createElement("i");
  dateIconNode.setAttribute("id", "schedules_date_" + index);
  dateContainerNode.appendChild(dateIconNode);

  var dateTextareaNode = document.createElement("textarea");
  dateTextareaNode.setAttribute("autocomplete", "off");
  dateTextareaNode.setAttribute("readonly", "readonly");
  dateTextareaNode.setAttribute("class", "form-control datepicker");
  dateTextareaNode.setAttribute("onchange", "validateDatesAndUpdateIcon()");
  dateTextareaNode.setAttribute("placeholder", dateText);
  dateTextareaNode.setAttribute("name", "project[schedules_attributes][" + index + "][date]");
  dateTextareaNode.setAttribute("id", "project_schedules_attributes_" + index + "_date");
  dateTextareaNode.setAttribute("value", dateText);
  dateTextareaNode.setAttribute("maxlength", "25");
  dateTextareaNode.appendChild(document.createTextNode(dateText));
  dateTextareaNode.setAttribute("maxlength", "25");
  dateContainerNode.appendChild(dateTextareaNode);

  //plan tag
  var planTdNode = document.createElement("td");
  planTdNode.setAttribute("class", "col col-md-6 col-sm-6 col-lg-6 col-xs-5");
  trNode.appendChild(planTdNode);

  var planContainerNode = document.createElement("div");
  planContainerNode.setAttribute("id", "schedules_plan_container_" + index);
  planContainerNode.setAttribute("class", "plan_container");
  planTdNode.appendChild(planContainerNode);

  var planLabelNode = document.createElement("label");
  planLabelNode.setAttribute("for", "project_schedules_attributes_" + index + "_plan");
  planLabelNode.appendChild(document.createTextNode("行动计划"));  
  planContainerNode.appendChild(planLabelNode);

  planContainerNode.appendChild(document.createTextNode(" "));

  var planIconNode = document.createElement("i");
  planIconNode.setAttribute("id", "schedules_plan_" + index);
  planContainerNode.appendChild(planIconNode);

  var planTextareaNode = document.createElement("textarea");
  planTextareaNode.setAttribute("autocomplete", "off");
  planTextareaNode.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('schedules_plan_container_" + index + "', 'plan_container', validatePlan)");
  planTextareaNode.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('schedules_plan_container_" + index + "', 'plan_container', validatePlan)");
  planTextareaNode.setAttribute("onblur", "validateAndUpdateField('schedules_plan_container_" + index + "', 'plan_container', validatePlan)");
  planTextareaNode.setAttribute("onchange", "validateAndUpdateField('schedules_plan_container_" + index + "', 'plan_container', validatePlan)");
  planTextareaNode.setAttribute("class", "form-control");
  planTextareaNode.setAttribute("placeholder", "");
  planTextareaNode.setAttribute("name", "project[schedules_attributes][" + index + "][plan]");
  planTextareaNode.setAttribute("id", "project_schedules_attributes_" + index + "_plan");
  planTextareaNode.setAttribute("maxlength", "200");
  planContainerNode.appendChild(planTextareaNode);

  // hotel tag
  var hotelTdNode = document.createElement("td");
  hotelTdNode.setAttribute("class", "col col-md-4 col-sm-4 col-lg-4 col-xs-4");
  trNode.appendChild(hotelTdNode);

  var hotelContainerNode = document.createElement("div");
  hotelContainerNode.setAttribute("id", "schedules_hotel_container_" + index);
  hotelContainerNode.setAttribute("class", "hotel_container");
  hotelTdNode.appendChild(hotelContainerNode);

  var hotelLabelNode = document.createElement("label");
  hotelLabelNode.setAttribute("for", "project_schedules_attributes_" + index + "_hotel");
  hotelLabelNode.appendChild(document.createTextNode("住宿"));
  hotelContainerNode.appendChild(hotelLabelNode);

  hotelContainerNode.appendChild(document.createTextNode(" "));

  var hotelIconNode = document.createElement("i");
  hotelIconNode.setAttribute("id", "schedules_hotel_" + index);
  hotelContainerNode.appendChild(hotelIconNode);

  var hotelTextareaNode = document.createElement("textarea");
  hotelTextareaNode.setAttribute("autocomplete", "off");
  hotelTextareaNode.setAttribute("oninput", "validateAndUpdateFieldOnlyCheck('schedules_hotel_container_" + index + "', 'hotel_container', validateHotel)");
  hotelTextareaNode.setAttribute("onfocus", "validateAndUpdateFieldOnlyCheck('schedules_hotel_container_" + index + "', 'hotel_container', validateHotel)");
  hotelTextareaNode.setAttribute("onblur", "validateAndUpdateField('schedules_hotel_container_" + index + "', 'hotel_container', validateHotel)");
  hotelTextareaNode.setAttribute("onchange", "validateAndUpdateField('schedules_hotel_container_" + index + "', 'hotel_container', validateHotel)");
  hotelTextareaNode.setAttribute("class", "form-control");
  hotelTextareaNode.setAttribute("placeholder", "");
  hotelTextareaNode.setAttribute("name", "project[schedules_attributes][" + index + "][hotel]");
  hotelTextareaNode.setAttribute("id", "project_schedules_attributes_" + index + "_hotel");
  hotelTextareaNode.setAttribute("maxlength", "100");
  hotelContainerNode.appendChild(hotelTextareaNode);

  return trNode;
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

function updateIconIgnoreError(id, callbackValidation, containerID) {
  var icon = document.getElementById(id);
  var valid = callbackValidation();
  if(valid) {
    icon.setAttribute("class", "fa fa-check")
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

function replaceDateStr(originalDateStr) {
  if(originalDateStr) {
    var newDateStr = originalDateStr.replace(/[-+:;,_~.=\s年月]{1,}/g, "/");
    newDateStr = newDateStr.replace(/[日号]{1,}/g, "");
    return newDateStr;
  } else {
    return originalDateStr;
  }
}

function ckDate(datestr) {
  if(!datestr.match(/^\d{4}\/\d{1,2}\/\d{1,2}$/)){
    return false;
  }

  var splitted = datestr.split("/");
  if(splitted.length != 3) {
    return false;
  }
  var vYear = parseInt(splitted[0]);
  var vMonth = parseInt(splitted[1]) - 1;
  var vDay = parseInt(splitted[2]);

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

function addDate(originalDate, addDays) {
    var dt = new Date(originalDate.getFullYear(), originalDate.getMonth(), originalDate.getDate());
    var baseSec = dt.getTime();
    var addSec = addDays * 86400000;//日数 * 1日のミリ秒数
    var targetSec = baseSec + addSec;
    dt.setTime(targetSec);
    return dt;
}

function subDate(lastDay, firstDay) {
  return Math.ceil((lastDay.getTime() - firstDay.getTime()) / 86400000);
}

function getAbsoluteToday() {
  var now = new Date();
  return new Date(now.getFullYear(), now.getMonth(), now.getDate());  
}


function formatDate(date) {
  var chinese_week_days = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
  var year = date.getFullYear();  
  var month = date.getMonth() + 1;  
  var day = date.getDate();  
    
  if ( month < 10 ) {  
  　　month = '0' + month;  
  }  
  if ( day < 10 ) {  
  　　day = '0' + day;  
  }      
  var str = year + '/' + month + '/' + day + "\n ( " + chinese_week_days[date.getDay()] + " ) ";  

  return str;
}


// validate when init
function initialValidation() {
  // check calendar
  if(validateDateArrival() && validateDateLeaving()) {
    $("#schedules_container table textarea").removeAttr("disabled");
    regenerateScheduleTable();   
  } else {
    if($("#schedules_container table tr").length == 0) {
      $("#schedules_container table tbody").append(createScheduleTag(0, formatDate(new Date())));    
    }
    $("#schedules_container table textarea").attr("disabled", "disabled");    
  }

  // check identity params
  updateIconIgnoreError('china_company_check', validateCompanyName, 'china_company_container');
  updateIconIgnoreError('visa_type_check', validateVisaType);
  updateIconIgnoreError('chinese_name_check', validateChineseName, 'chinese_name_container');
  updateIconIgnoreError('english_name_check', validateEnglishName, 'english_name_container');
  updateIconIgnoreError('total_people_check', validateTotalPeople, 'total_people_container');


  // check plan
  $("#schedules_container table .plan_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'plan_container', validatePlan);
  });

  // check hotel
  $("#schedules_container table .hotel_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'hotel_container', validateHotel);
  });

  // check all chinese name
  $(".chinese_name_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'chinese_name_container', validateChineseNameById);
  })

  // check all english name
  $(".english_name_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'english_name_container', validateEnglishNameById);
  })

  // check all gender
  $(".gender_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'gender_container', validateGender);
  })

  // check all hometown
  $(".hometown_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'hometown_container', validateHometown);
  })

  // check all birthday
  $(".birthday_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'birthday_container', validateBirthday);
  })

  // check all passport_no
  $(".passport_no_container").each(function() {
    validateAndUpdateFieldIgnoreError(this.attributes.id.value, 'passport_no_container', validatePassportNo);
  })
}

// validate before sending
$(function() {
  $('#new_project, .edit_project').submit(function() {
    reduceClientsTable();
    var failedMessage = "";

    // validate identity information
    if(!updateIcon('china_company_check', validateCompanyName, 'china_company_container')) {
      failedMessage += "<li>中国旅行社名不正确.</li>";
    }
    if(!updateIcon('visa_type_check', validateVisaType)) {
      failedMessage += "<li>签证种类未选.</li>";
    }
    if(!updateIcon('chinese_name_check', validateChineseName, 'chinese_name_container')) {
      failedMessage += "<li>代表人全名(简体字)不正确.</li>";          
    } else {
      var chineseNameValid = false;
      $(".chinese_name_container input").each(function() {
        if(this.value == $("#chineseName")[0].value) {
          chineseNameValid = true;
        }
      })
      if(!chineseNameValid) {
        failedMessage += "<li>代表人名不存在名单里.</li>";          
      }            
    }
    if(!updateIcon('english_name_check', validateEnglishName, 'english_name_container')) {
      failedMessage += "<li>代表人全名(拼音)不正确.</li>";                    
    }
    if($("#clients_container table tr").length == 0) {
      failedMessage += "<li>人数不可为零.</li>";                              
    } else {
      $("#totalPeople")[0].value = $("#clients_container table tr").length;
      if(!updateIcon('total_people_check', validateTotalPeople, 'total_people_container')) {
        failedMessage += "<li>总人数不正确.</li>";                              
      }
    }
    if(!updateIcon('date_arrival_check', validateDateArrival, 'date_arrival_container')) {
      failedMessage += "<li>日本入境日期不正确.</li>";                                        
    }
    if(!updateIcon('date_leaving_check', validateDateLeaving, 'date_leaving_container')) {
      failedMessage += "<li>日本出境日期不正确.</li>";                                                  
    }

    // validate schedules
    if(!validateDatesAndUpdateIcon()) {
      failedMessage += "<li>旅程表日期不正确.</li>";                                     
    }

    var planValid = true;
    $("#schedules_container table .plan_container").each(function() {
      var inputText = $("#" + this.attributes.id.value + " textarea")[0].value;
      if(inputText.match(/[\s]{1,}/g)) {
        inputText = inputText.replace(/[\s]{1,}/g, " ");
        if(inputText.match(/^[\s　]{1,}/)) {
          inputText = inputText.replace(/^[\s　]{1,}/, "");
        }
      }
      $("#" + this.attributes.id.value + " textarea")[0].value = inputText;

      if(!validateAndUpdateField(this.attributes.id.value, 'plan_container', validatePlan)) {
        planValid = false;
      }
    });
    if(!planValid) {
      failedMessage += "<li>行动计划不可空虚，必须200字以内.</li>";          
    }


    var hotelValid = true;
    $("#schedules_container table .hotel_container").each(function() {
      var inputText = $("#" + this.attributes.id.value + " textarea")[0].value;
      if(inputText.match(/[\s]{1,}/g)) {
        inputText = inputText.replace(/[\s]{1,}/g, " ");
        if(inputText.match(/^[\s　]{1,}/)) {
          inputText = inputText.replace(/^[\s　]{1,}/, "");
        }
      }
      $("#" + this.attributes.id.value + " textarea")[0].value = inputText;

      if(!validateAndUpdateField(this.attributes.id.value, 'hotel_container', validateHotel)) {
        hotelValid = false;
      }
    });
    if(!hotelValid) {
      failedMessage += "<li>住宿不可空虚，必须100字以内.</li>";          
    }

    // validate clients table
    var chineseNameValid = true;
    $(".chinese_name_container").each(function() {
      if(!validateAndUpdateField(this.attributes.id.value, 'chinese_name_container', validateChineseNameById)) {
        chineseNameValid = false;
      }
    })
    if(!chineseNameValid) {
      failedMessage += "<li>中文名必须填写简体字，10字以内.</li>";          
    }

    var englishNameValid = true;
    $(".english_name_container").each(function() {
      if(!validateAndUpdateField(this.attributes.id.value, 'english_name_container', validateEnglishNameById)) {
        englishNameValid = false;
      }
    })
    if(!englishNameValid) {
      failedMessage += "<li>英文名必须填写半角拼英，30字以内.</li>";          
    }

    var genderValid = true;
    $(".gender_container").each(function() {
      if(!validateAndUpdateField(this.attributes.id.value, 'gender_container', validateGender)) {
        genderValid = false;
      }
    })
    if(!genderValid) {
      failedMessage += "<li>性别未选择，不可空虚.</li>";          
    }

    var hometownValid = true;
    $(".hometown_container").each(function() {
      if(!validateAndUpdateField(this.attributes.id.value, 'hometown_container', validateHometown)) {
        hometownValid = false;
      }
    })
    if(!hometownValid) {
      failedMessage += "<li>签发地点不可空虚，必须10字以内.</li>";          
    }

    var birthdayValid = true;
    $(".birthday_container").each(function() {
      if(!validateAndUpdateField(this.attributes.id.value, 'birthday_container', validateBirthday)) {
        birthdayValid = false;
      }
    })
    if(!birthdayValid) {
      failedMessage += "<li>出生日期形式不正确.</li>";          
    }

    var passportNoValid = true;
    $(".passport_no_container").each(function() {
      if(!validateAndUpdateField(this.attributes.id.value, 'passport_no_container', validatePassportNo)) {
        passportNoValid = false;
      }
    })
    if(!passportNoValid) {
      failedMessage += "<li>护照号必须半角英文字母或数字，不可重复.</li>";          
    }

    if(failedMessage.length > 0) {
      $("#failed-alert content").html(failedMessage)
      openAlert();
      return false;
    } else {
      $("#now_loading")[0].style.display = "block";
      return true;
    }
  });

  // modal process
  $('#modal-panel').on('shown.bs.modal', function () {
    $('#excel_area').focus()
  })
  $("button#parse-button").click(function(e){
      var excelText = $('#excel_area')[0].value;
      var rowItems = parseExcelText(excelText);
      if(rowItems.length > 0) {
        reduceClientsTable();
        var i = 0;
        if($("#clients_container table tr").length == 1 && isEmptyRow($("#clients_container table tr")[0].id)) {
          fillRow($("#clients_container table tr")[0].id, rowItems[i]);
          i++;
        }
        for(; i < rowItems.length; i++) {
          var id = addClientRow();
          fillRow(id, rowItems[i]);
        }

        // validate clients table
        $(".chinese_name_container").each(function() {
          validateAndUpdateField(this.attributes.id.value, 'chinese_name_container', validateChineseNameById);
        });
        $(".english_name_container").each(function() {
          validateAndUpdateField(this.attributes.id.value, 'english_name_container', validateEnglishNameById);
        });
        $(".gender_container").each(function() {
          validateAndUpdateField(this.attributes.id.value, 'gender_container', validateGender);
        });
        $(".hometown_container").each(function() {
          validateAndUpdateField(this.attributes.id.value, 'hometown_container', validateHometown);
        });
        $(".birthday_container").each(function() {
          validateAndUpdateField(this.attributes.id.value, 'birthday_container', validateBirthday);
        });
        $(".passport_no_container").each(function() {
          validateAndUpdateField(this.attributes.id.value, 'passport_no_container', validatePassportNo);
        });

        $('#modal-panel').modal('hide');
        alert("成功读取" + rowItems.length + "份个人资料,请确认.");
      } else {
        alert("您填入的表格不符合Excel文件格式!")
      }
  });
});

// function to fill row from excel items
function fillRow(id, rowItem) {
  $("#"+id+" .chinese_name_container input")[0].value = rowItem.chineseName;
  $("#"+id+" .english_name_container input")[0].value = rowItem.englishName;
  if(rowItem.gender.match(/[男1]|male|man|men|boy/i)) {
    $("#"+id+" .gender_container .gender_type label")[0].className += " active";
    $("#"+id+" .gender_container .gender_type input")[0].checked = true;
  } else if(rowItem.gender.match(/[女2]|female|woman|women|girl/i)) {
    $("#"+id+" .gender_container .gender_type label")[1].className += " active";
    $("#"+id+" .gender_container .gender_type input")[1].checked = true;
  }
  $("#"+id+" .hometown_container input")[0].value = rowItem.hometown;
  $("#"+id+" .birthday_container input")[0].value = rowItem.birthday;
  $("#"+id+" .passport_no_container input")[0].value = rowItem.passportNo;  
}

// function to parse excel text file
function parseExcelText(excelText) {
  var rowItems = [];

  var lines = excelText.split(/\r\n|\r|\n/);
  for (var i = 0; i < lines.length; i++) {
    items = lines[i].split(/[ ]{3,}|[,\t]/);
    for(passportIndex = 5; passportIndex < items.length; passportIndex++) {
      // match passport
      if(items[passportIndex].match(/[A-Z]{1,3}[0-9]{6,}/)) {
        rowItems.push({
          passportNo: items[passportIndex],
          birthday: items[passportIndex-1],
          hometown: items[passportIndex-2],
          gender: items[passportIndex-3],
          englishName: items[passportIndex-4],
          chineseName: items[passportIndex-5]
        });
      }
    }
  }

  return rowItems;
}

// function to check if tr row empty
function isEmptyRow(id) {
  if(!$("#"+id+" .chinese_name_container input")[0].value 
      && !$("#"+id+" .english_name_container input")[0].value
      && ($("#"+id+" .gender_container .gender_type label")[0].className.indexOf("active")==-1 && $("#"+id+" .gender_container .gender_type label")[1].className.indexOf("active")==-1)
      && !$("#"+id+" .hometown_container input")[0].value
      && !$("#"+id+" .birthday_container input")[0].value
      && !$("#"+id+" .passport_no_container input")[0].value) {
    return true;
  } else {
    return false;
  }
}

// auto remove unused rowItems
function reduceClientsTable() {
  var deleteFinished = false;

  $($("#clients_container table tr").get().reverse()).each(function() {
    if(!deleteFinished) {
      if(isEmptyRow(this.id) && $("#clients_container table tr").length > 1) {
        removeClientRow(this.id);
      } else {
        deleteFinished = true;
      }
    }
  });
}