import 'package:flutter/material.dart';
import 'package:hello_caen/model/database/commerce_model.dart';
import 'package:hello_caen/screens/generated_screens/generated_store_screen.dart';

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
          //color: Colors.amber,
          margin: EdgeInsets.only(top:40),
          child:
              FutureBuilder(
                future: CommerceModel().getAll(),
                builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  List<Widget> widgets = [];
                  for(var data in snapshot.data){
                    widgets.add(
                        GestureDetector(onTap: () {Navigator.popAndPushNamed(context,GeneratedStoreScreen.routeName);} ,
                            child:Column(
                                children: [Container(
                                //margin:EdgeInsets.all(5.0),g
                                width: 250,
                                height: 100,
                                decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                  data.imageLink),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15))),
                            ),
                            Row(children: [Container(
                              width: 75,
                              height: 75,
                              margin: EdgeInsets.only(top:10.0,left:10),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        data.imageLink),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15))),
                            ),Container(
                              width: 150,
                              height: 100,
                              //color: Colors.black,
                              child:Column(
                                children: [
                                  Container(width:90,height:20 ,margin: EdgeInsets.only(top:25),padding: EdgeInsets.only(left:10) ,child: Text(data.name),),
                                  Container(width:90,height:20 ,margin: EdgeInsets.only(top:5),child: Opacity(opacity:0.5, child: Text(data.name)),),
                                  Container(width:90,height:20 ,margin: EdgeInsets.only(top:5),child: Opacity(opacity:0.5, child: Text(data.name)),),
                                ],
                              )
                              //borderRadius: BorderRadius.all(Radius.circular(15))),
                            )],)


                            ])
                ));
              widgets.add(SizedBox(width: 20,));
              }

              return ListView.builder(
                    scrollDirection : Axis.horizontal,
                    itemCount: widgets.length,
                    itemBuilder: (context,index){
                      return widgets[index];}
                    );
            }
            else{
              return CircularProgressIndicator();
            }


          }),

      );
  }
}