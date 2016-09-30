public class IncidentController {

  // ------------------------------------------------------------------------------------------
  // Attributes
  // ------------------------------------------------------------------------------------------

  // Incidents list
  public List<Incident__c> incidents {get; set;}

  // Holds a single incident, so we can show / create it
  public Incident__c incident {get; set;}

  // Comments
  public List<Comment__c> comments {get; set;}

  // New comment
  public Comment__c newComment {get; set;}

  // String that will be set by the page using ajax. This will be used at doQuery method to filter the incidents
  public String searchString {get; set;}

  // ------------------------------------------------------------------------------------------
  // Controllers
  // ------------------------------------------------------------------------------------------

  public IncidentController() {
    incidents = loadAllIncidents();

    incident = new Incident__c();
  }

  // ------------------------------------------------------------------------------------------
  // CRUD
  // ------------------------------------------------------------------------------------------

  // Opens the new incident page
  public PageReference newIncident() {
    PageReference pageReference = new PageReference('/apex/new_incident');
    //pageReference.setRedirect(true);
    return pageReference;
  }

  // Show the selected incident
  public PageReference showIncident() {
    // Get the incident number param
    String incidentNumber = System.currentPageReference().getParameters().get('incidentNumber');

    // Load the incident
    incident = loadIncident(incidentNumber);

    // Load the comments
    comments = loadAllComments();

    // Creates a new comment object
    newComment = new Comment__c();

    // Got to the other page
    PageReference pageReference = new PageReference('/apex/show_incident');
    //pageReference.setRedirect(false);

    return pageReference;
  }

  // Update all incidents
  public void saveAll() {
    update incidents;
  }

  // Update a single incident and redirects to the index page (/apex/incidends)
  public PageReference save() {
    update incident;
    PageReference pageReference = new PageReference('/apex/incidents');
    pageReference.setRedirect(true);
    return pageReference;
  }

  // Create a new incident and redirects to the index page (/apex/incidents)
  public PageReference create() {
    insert incident;
    PageReference pageReference = new PageReference('/apex/incidents');
    pageReference.setRedirect(true);
    return pageReference;
  }

  // Cancel the operation and go back to the index page (/apex/incidents)
  public PageReference cancel() {
    PageReference pageReference = new PageReference('/apex/incidents');
    pageReference.setRedirect(true);
    return pageReference;
  }

  // ------------------------------------------------------------------------------------------
  // Ajax calls
  // ------------------------------------------------------------------------------------------
  public void findIncidentLike() {
    String incidentLike = '';

    if (searchString != null) {
      incidentLike += '%' + searchString + '%';

      incidents = loadAllIncidents(incidentLike);
    }
  }

  public void addCommentary() {
    newComment.Incident__c = incident.id;
    insert newComment;

    comments = loadAllComments();

    // Creates a new comment object
    newComment = new Comment__c();
  }

  // ------------------------------------------------------------------------------------------
  // Private methods
  // ------------------------------------------------------------------------------------------

  private List<Incident__c> loadAllIncidents() {
    return [  select Name, Title__c, Status__c, Description__c, Client__c, Assigned_To__c, CreatedById, CreatedDate
              from Incident__c
              order by CreatedDate desc
            ];
  }

  private List<Incident__c> loadAllIncidents(String incidentLike) {
    return [  select Name, Title__c, Status__c, Description__c, Client__c, Assigned_To__c, CreatedById, CreatedDate
              from Incident__c
              where Name like :incidentLike or
                    Status__c like :incidentLike or
                    Title__c like :incidentLike or
                    Client__r.Name like :incidentLike or
                    Assigned_To__r.Name like :incidentLike
              order by CreatedDate desc
            ];
  }

  private Incident__c loadIncident(String incidentNumber) {
    return [  select Name, Title__c, Status__c, Description__c, Client__c, Assigned_To__c
              from Incident__c
              where Name = :incidentNumber
            ];
  }

  private List<Comment__c> loadAllComments() {
    return [  select Name, Title__c, Description__c, CreatedDate
              from Comment__c
              where Incident__r.Name = :incident.Name
              order by CreatedDate desc
            ];
  }
}
