import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gridform/sizing.dart';

class GridForm extends StatefulWidget {
  @override
  _GridFormState createState() => _GridFormState();
}

class _GridFormState extends State<GridForm> {
  // Prices of each items
  List allItemPrices = ["399","250","600","125"];

  // All Listed Items
  var items = <String>['Wood', 'Hammer', 'Concrete Powder', 'Hollowblocks'];

  // Items Ordered Lists
  List<String> allItemOrders = [];

  // Controller Lists
  var qtyTECs = <TextEditingController>[];
  var priceTECs = <TextEditingController>[];
  var tpriceTECs = <TextEditingController>[];

  // Number of Rows Generated
  int totalRows = 1;

  // Index of Generated Row
  int rowIndex;

  // Form Keys
  var itemFKeys = <GlobalKey<FormState>>[];
  var qtyFKeys = <GlobalKey<FormState>>[];

  @override
  Widget build(BuildContext context) {

    // Define device size
    SizeConfig().init(context); 
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Order'),
        backgroundColor: Colors.blue[400],
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView (
          child: Column(
            children: <Widget> [
              Column (
                children: <Widget>[
                  Row(
                    children: <Widget> [menu]
                  ),
                  Row( 
                    children: <Widget> [grid]
                  ),
                  Row(
                    children: <Widget>[botmenu],
                  )
                ]
              )
            ]
          )
        )
      )
    );
  }

  get botmenu =>
    Container(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Wrap(
        spacing: 5.0,
        runSpacing: 4.0,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.blue[400], borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    bool isItemValidated = true, isQtyValidated = true;
                    for(var keys in itemFKeys) {
                      if(!keys.currentState.validate()) { // Validate field and check if form field is empty.
                        isItemValidated = false;
                      }
                    }
                    for(var keys in qtyFKeys) {
                      if(!keys.currentState.validate()) {
                        isQtyValidated = false;
                      }
                    }
                    if(isItemValidated && isQtyValidated) { // If all fields are validated, sumbit.

                      // To API
                      print("Order Submitted\n");
                      print("ITEMS\t\t\tQuantity");
                      for(int i = 0; i < qtyTECs.length; i++) {
                        print(allItemOrders[i] + "\t\t\t" + qtyTECs[i].text);
                      }
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 25),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(IconData(57378, fontFamily: 'MaterialIcons'), color: Colors.white),
                        Text(
                          'Create Order',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ]
                  )
                )
              ),
            ),
            // Other Menu Buttons Here
        ]
      )
    );

  get menu =>
    Container(
      padding: EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Wrap(
        spacing: 5.0,
        runSpacing: 4.0,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
              height: 40,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.blue[400], borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    allItemOrders.add(" "); // Add new index
                    totalRows += 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 25),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(IconData(57378, fontFamily: 'MaterialIcons'), color: Colors.white),
                        Text(
                          'Add Row',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ]
                  )
                )
              ),
            ),
            // Other Menu Buttons Here
        ]
      )
    );
  get grid =>
    Expanded (
      child: Container(
        width: 725,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26)
        ),
        margin: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Scrollbar (
          child: SingleChildScrollView(
            physics: new AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: const EdgeInsets.all(5),
              width: 750,
              constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight * .55),
              child: Scrollbar (
                child: SingleChildScrollView (
                  child: Column (
                    children: List.generate(totalRows, (int index) {
                      rowIndex = index;
                      if(index == 0) {
                        allItemOrders.add(" ");
                      }
                      return Container(
                        alignment: Alignment.center,
                        child: _addRow,
                        padding: EdgeInsets.only(top: 3, bottom: 3),
                        decoration: new BoxDecoration(
                          color: index % 2 != 0 ? Colors.grey[300] : Colors.white
                        ),
                      );
                    })
                  )
                )
              )
            )
          )
        )
      )
    ); 
  
  get _addRow { 
    // Get the assigned index for this row
    int thsRowIndex = rowIndex;
    
    // Controllers of each textfields
    var qty, price, tprice;
    
    // Current Selected Item of the dropdown
    String currentSelectedValue;

    // Check if there is a stored controller for this row in the list of controllers
    bool isRowNew;
    if(qtyTECs.asMap().containsKey(thsRowIndex)) {
      isRowNew = false;
    } else {
      // If none, create new controllers and add them to the list of controllers
      isRowNew = true;

      qty = TextEditingController();
      price = TextEditingController();
      tprice = TextEditingController();

      // New form field keys for validation
      final GlobalKey<FormState> itemKey = GlobalKey();
      final GlobalKey<FormState> qtyKey = GlobalKey();

      itemFKeys.add(itemKey);
      qtyFKeys.add(qtyKey);

      qtyTECs.add(qty);
      priceTECs.add(price);
      tpriceTECs.add(tprice);

    }
    var thsRowBgColor = thsRowIndex % 2 != 0 ? Colors.grey[300] : Colors.white;

    return Row (
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  int rowToRemove = thsRowIndex;
                  if(totalRows != 1) {
                    allItemOrders.removeAt(rowToRemove);
                    qtyTECs.removeAt(rowToRemove);
                    priceTECs.removeAt(rowToRemove);
                    tpriceTECs.removeAt(rowToRemove);
                    itemFKeys.removeAt(rowToRemove);
                    qtyFKeys.removeAt(rowToRemove);
                    totalRows--;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(5),
                child: Icon(IconData(57579, fontFamily: 'MaterialIcons'), size: 25, color: Colors.black26)
              )
            )
          ),
          Container(
            width: 250,
            color: thsRowBgColor,
            child: Form(
              key:  itemFKeys[thsRowIndex], //Assign Form Keys
              child: new DropdownButtonFormField<String> (
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(      
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Item Name',
                  labelStyle: TextStyle(
                    color: Colors.black54
                  ),
                  hintText: "Please select an Item",
                  errorStyle: TextStyle(backgroundColor: thsRowBgColor)
                ),
                value: allItemOrders[thsRowIndex] != " " ? allItemOrders[thsRowIndex] : currentSelectedValue,
                validator: (value) {
                  // For validation
                  if (value == null || value.isEmpty) {
                    return 'Please select an item';
                  }
                  return null;
                },
                items: items.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Text(value)
                  );
                }).toList(),
                onChanged: (value) {  
                  setState(() {
                    // If there is no item stored on the list of items ordered, save the item on the list
                    if(!allItemOrders.asMap().containsKey(thsRowIndex)) {
                      allItemOrders.add(value);
                    } else { // Else change the saved item
                      allItemOrders[thsRowIndex] = value;
                    }
                    
                    int quantity;
                    
                    // Get the value of the Item Quantity textfield of this row
                    String qtyValue = qtyTECs[thsRowIndex].text;

                    // If the field is empty when an item is selected, set quantity as 1 
                    if(qtyValue == "") {
                      qtyTECs[thsRowIndex].text = "1";
                      quantity = 1;
                    } else { // Else, save the value
                      quantity = int.parse(qtyValue);
                    }

                    // Get the index of the selected item on the list of items
                    int priceIndex = items.indexOf(value);

                    // Get the item price 
                    String itemPrice = allItemPrices[priceIndex];

                    // Assign the price and the total price
                    priceTECs[thsRowIndex].text = double.parse(itemPrice).toStringAsFixed(2);
                    tpriceTECs[thsRowIndex].text = (double.parse(itemPrice) * quantity).toStringAsFixed(2);

                    currentSelectedValue = value;
                  });
                },
            )
            )
          ),
          Container(
            color: thsRowBgColor,
            constraints: BoxConstraints(minWidth: 10, maxWidth: 150),
            child: Form(
              key: qtyFKeys[thsRowIndex],
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]+')),], // Allowing numerics only
                controller: isRowNew ? qty : qtyTECs[thsRowIndex], // If this row is new, assign new controllers. Else, get the assigned controller from the controller list
                validator: (value) {
                  // For validation
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(      
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Product Quantity',
                  labelStyle: TextStyle(
                    color: Colors.black54
                  ),
                  hintText: "No. of Product",
                  errorStyle: TextStyle(backgroundColor: thsRowBgColor)
                ),
                onChanged: (value) { 
                  setState(() { 
                    if(allItemOrders[thsRowIndex] != " ") {
                      int quantity;
                      if(value == "") {
                        quantity = 1;
                      } else {
                        quantity = int.parse(value);
                      }

                      int priceIndex = items.indexOf(allItemOrders[thsRowIndex]);
                      String itemPrice = allItemPrices[priceIndex];

                      priceTECs[thsRowIndex].text = double.parse(itemPrice).toStringAsFixed(2);
                      tpriceTECs[thsRowIndex].text = (double.parse(itemPrice) * quantity).toStringAsFixed(2);
                    }
                  });
                },
            )
            )
          ),
          Container(
            color: Colors.white,
            constraints: BoxConstraints(minWidth: 10, maxWidth: 150),
            child: TextFormField(
                enabled: false,
                controller: isRowNew ? price : priceTECs[thsRowIndex],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(      
                    borderSide: BorderSide(color: Colors.black),
                  ),
                border: OutlineInputBorder(),
                labelText: 'Item Price',
                labelStyle: TextStyle(
                  color: Colors.black54
                ),
              ),
            )
          ),
          Container(
            color: Colors.white,
            constraints: BoxConstraints(minWidth: 10, maxWidth: 150),
            child: TextFormField(
                enabled: false,
                controller: isRowNew ? tprice : tpriceTECs[thsRowIndex],
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(      
                    borderSide: BorderSide(color: Colors.black),
                  ),
                border: OutlineInputBorder(),
                labelText: 'Total Price',
                labelStyle: TextStyle(
                  color: Colors.black54
                ),
              ),
            )
          ),
        ],
    );
  }
}

// For saving features
class Orders {
  final String itemName;
  final String itemQuantity;
  final int itemPrice;
  final int totalPrice;

  Orders(this.itemName, this.itemQuantity, this.itemPrice, this.totalPrice);
}