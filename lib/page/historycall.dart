import 'package:flutter/material.dart';


class HistoryCallWidget extends StatefulWidget {
  
  final String? destination; // Add this parameter
  const HistoryCallWidget({Key? key, this.destination}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HistoryCallWidgetState createState() => _HistoryCallWidgetState();
}

class _HistoryCallWidgetState extends State<HistoryCallWidget> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // debugPrint('movieTitle: $size');

    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height:100),
          if (widget.destination != null)
            showhistoryDest(widget.destination!, '2', true),
            
          showhistoryDest('102','2',true),
          showhistoryDest('101','20',false),
          showhistoryDest('101','20',false),

        ],
      ),
    );
  }
  
  Widget showhistoryDest(String dest,String timeHappen,bool? isAccepted){
    isAccepted ??= true;
    timeHappen = '$timeHappen seconds ago';
    final iconChoise = isAccepted ? const Icon(Icons.call_end_rounded) : const Icon(Icons.call_missed_outgoing);

    return Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: Container(
              height: 80,
              width: 300,
              decoration:
                  BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                    color: isAccepted ? Colors.green[100] :Colors.red[100] ,
                    ),
              child: Padding(
                padding:const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [ Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dest,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      Text(
                        timeHappen,
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal))
                    ],
                  ),
                    const SizedBox(width: 100),
                    iconChoise,
                    // Icon(Icons.call_end_rounded),
                  ]
                ),
              ),
            )
          );
  }
}
