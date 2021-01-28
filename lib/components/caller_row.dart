import 'package:flutter/material.dart';
import 'package:hello_caen/model/database/commerce_model.dart';

class CallerRow extends StatefulWidget {


  @override
  _CallerRowState createState() => _CallerRowState();
}

class _CallerRowState extends State<CallerRow> {
  @override
  Widget build(BuildContext context) {

      return Container(
          width: 700,
          height: 200,
          color: Colors.amber,

          child:FutureBuilder(
            future: CommerceModel().getAll(),
            builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              List<Widget> widgets = [];
              for(var data in snapshot.data){
                widgets.add(Container(
                    margin:EdgeInsets.all(5.0),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              data.imageLink),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child:Container(
                        child:Opacity(opacity: 0.5,child:Container(padding:EdgeInsets.all(5.0),color:Colors.black,child:Text(data.name))))
                  )
                );


              }

              return ListView.builder(
                    scrollDirection : Axis.horizontal,
                    itemCount: widgets.length,
                    itemBuilder: (context,index){
                      return widgets[index];
                    }

                  );



            }
            else{
              return CircularProgressIndicator();
            }


          })
      );

  }
}