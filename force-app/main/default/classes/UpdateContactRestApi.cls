@RestResource(urlMapping='/contacts/*')
global with sharing class UpdateContactRestApi {
    @HttpPut
    global static void doPut() {
        Response response = new Response();

        try {
            Request reqBody = new Request();
            update reqBody.listContact;

            response.setStatus(200);
            response.setSuccess(true);
            response.setMessage('Updated Success.');
        } catch (DmlException error) {

            response.setStatus(422);
            response.setSuccess(false);
            response.setMessage(error.getDmlMessage(0));
        } catch (Exception error) {
            response.setStatus(422);
            response.setSuccess(false);
            response.setMessage('Bad request.');
            System.debug(error.getMessage());
        } finally {
            response.sendAsJson();
        }
    }

    class Request {
        List<Contact> listContact;

        public Request() {
            listContact = new List<Contact>();

            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());
            List<Object> data = (List<Object>) params.get('contacts');

            for (Object item : data) {
                listContact.add((Contact) JSON.deserializeStrict(JSON.serialize(item), Contact.class));
            }
        }
    }

    class Response {
        public Boolean success;
        public String message;

        public Response() {
            RestContext.response.statuscode = 500;
            success = false;
            message = 'Internal server error.';
        }

        public void setSuccess(Boolean value) {
            success = value;
        }

        public void setMessage(String value) {
            message = value;
        }

        public void setStatus(Integer value) {
            RestContext.response.statuscode = value;
        }

        public void sendAsJson() {
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(this));
        }
    }
}