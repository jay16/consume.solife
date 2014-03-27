function MultiSelector(list_target, max) {
    this.list_target = list_target;
    this.file_array = [];
    this.file_name = "";
    this.file_id  = "";
    this.count = 0;
    this.id = 0;
    this.table_row = this.list_target.insertRow(this.list_target.rows.length);
    if (max) {
        this.max = max;
    } else {
        this.max = -1;
    };
    this.addElement = function(element) {
        if (element.tagName == 'INPUT' && element.type == 'file') {
            if(this.file_array.length) {
              element.name = this.file_name;
              element.id = this.file_id;
            } else {
              this.file_name = element.name;
              this.file_id = element.id;
            }
            this.file_array.push(element);
            element.multi_selector = this;
            element.onchange = function() {   
                var new_element = document.createElement('input');
                new_element.type = 'file';
                this.parentNode.insertBefore(new_element, this);
                this.multi_selector.addElement(new_element);
                this.multi_selector.addThumbnail(this);
                this.multi_selector.addListRow(this);
                this.name = 'file_' + this.multi_selector.id;
                this.id   = 'file_' + this.multi_selector.id;
                this.style.position = 'absolute';
                this.style.left = '-1000px';
            };
            if (this.max != -1 && this.count >= this.max) {
               // element.disabled = true;
            };
            this.id++;
            this.count++;
            this.current_element = element;
            if(this.count > 1) {
               $("#photo_submit_btn").removeAttr("disabled"); 
            }
        } else {
            alert('Error: not a file input element');
        };
    };
    
    this.addThumbnail = function(element) {
        var new_row = document.createElement('img');
        var props = "", errors = ""; 

        for(var p in element){
          try{ 
                  if(typeof(element[p])=="function"){  
                  } else {
                      props+= p + "=" + element[p] + "\t";
                  }
          } catch(e) { errors = errors + String(e) + "\t"; }
        }
       // alert(props);

        //new_row.src = element.files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
             new_row.width = 100;
             new_row.src   = e.target.result;
            }  
        reader.readAsDataURL(element.files[0]);    

        //this.list_target.appendChild(new_row);
        this.table_row.insertCell(this.table_row.cells.length).appendChild(new_row);
    };
    this.addListRow = function(element) {
        var new_row = document.createElement('div');
        var new_row_button = document.createElement('input');
        new_row_button.className = 'btn btn-danger btn-xs';
        new_row_button.type = 'button';
        new_row_button.value = 'Delete';
        new_row_button.id = "row_index_"+String(this.id);
        new_row.element = element;
        var root = this;
        new_row_button.onclick = function() {
            //delete table row
            var td = this.parentNode
            var tr = td.parentNode
            var row_index = tr.rowIndex
            root.list_target.deleteRow(row_index); 
            //delete file
            var id = this.id.split("_")[2];
            var file_id = "file_"+id;
            var input_file = document.getElementById(file_id);
            input_file.remove();

            root.count--;
            //alert(root.count);
            //root.current_element.disabled = false;

            if(root.count <= 1) {
             $("#photo_submit_btn").attr("disabled","disabled"); 
            }
            return false;
        };
        new_row.innerHTML = element.value;
        //new_row.appendChild(new_row_button);
        this.table_row.insertCell(this.table_row.cells.length).appendChild(new_row);
        this.table_row.insertCell(this.table_row.cells.length).appendChild(new_row_button);
        this.table_row = this.list_target.insertRow(this.list_target.rows.length);
    };
};

