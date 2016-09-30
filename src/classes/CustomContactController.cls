public class CustomContactController {

  public List<Contact> contacts {get; set;}
  public String searchString {get; set;}

  public CustomContactController() {
    contacts = [select Name, Title, Email from contact order by Name limit 70];
  }

  public void save() {
    update contacts;
  }

  public void doQuery() {
    String lastNameLike = '';

    if (searchString != null) {
      lastNameLike += '%' + searchString + '%';

      contacts = [select Name, Title, Email
                  from contact
                  where LastName like :lastNameLike order by Name limit 70 ];
    }
  }

}