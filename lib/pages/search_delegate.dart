import 'package:flutter/material.dart';
import 'package:prolimpia_mobile/models/person_model.dart';
import 'package:prolimpia_mobile/pages/collect_page.dart';
import 'package:prolimpia_mobile/providers/person_provider.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  final personsProvider = new PersonProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty || query.length <= 4) {
      print(query.length);
      return Container(
        child: Center(
          child: Text('Vacío o mayor a 4 letras...'),
        ),
      );
    } else {
      return FutureBuilder(
        future: personsProvider.search(query),
        builder: (BuildContext ctx, AsyncSnapshot<List<Person>> snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            final List<Person> persons = snapshot.data;
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              itemCount: persons.length,
              itemBuilder: (context, index) {
                final Person person = persons[index];
                return ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(
                    '${person.usrNombre}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        person.usrDomici.length > 15
                            ? '${person.usrDomici.substring(0, 15)}...'
                            : '${person.usrDomici}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Adeudo: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '\$ ${person.usrTotal}',
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    '${person.usrNumcon}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollectPage(person: person),
                        ));
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    return Center(
      child: Container(),
    );
  }
}
