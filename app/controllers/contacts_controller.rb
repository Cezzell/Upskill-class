class ContactsController < ApplicationController
    
    #Get request /contact-us
    #Show new contact form
    def new
        @contact = Contact.new
    end
    
    #Post request /contacts
    #Flash and reroute to /contact us
    def create
        #Mass assignment of form fields
        @contact = Contact.new(contact_params)
        if @contact.save
            #Succeeded. Save, Deliver, Flash, Redirect
            name = params[:contact][:name]
            email = params[:contact][:email]
            comments = params[:contact][:comments]
            #Send email with Mailgun
            ContactMailer.contact_email(name, email, comments).deliver
            flash[:success] = "Message Sent"
            redirect_to contact_us_path
        else
            #Failed. Flash, Redirect
            flash[:danger] = @contact.errors.full_messages.join(", ")
            redirect_to contact_us_path
        end
    end

    private
        # To collect Data From Form Fields, whitelist the form fields
        def contact_params
            params.require(:contact).permit(:name, :email, :comments)
        end
end