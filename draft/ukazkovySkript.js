(new MojObj());        //vytvorenie
MojObj = function() { 
  var prem1 = [];
  var bool = 0; 
  var construct = function() {
    var prem1 = $('#id').find('div');            
    prem1.each(function() {
      prem1.push(new obj(this));
    });
    $(document).click(nejakaFunkcia);   
  } 
  var funkcia = function() {        
    for (var i in prem1) {   
      if ( bool ) { //tak nieco sprav        
      }
    }   
    bool = !bool;    
  }
  $(document).ready(construct);    
};