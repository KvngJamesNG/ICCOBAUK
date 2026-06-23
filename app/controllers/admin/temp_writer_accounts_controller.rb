class Admin::TempWriterAccountsController < Admin::BaseController
  def index
    TempWriterAccount.purge_expired!
    @temp_writer_account = TempWriterAccount.new
    @active_accounts = TempWriterAccount.active.order(expires_at: :asc)
  end

  def create
    @temp_writer_account = TempWriterAccount.new(temp_writer_account_params)
    generated_password = TempWriterAccount.generate_phrase_password
    @temp_writer_account.password = generated_password
    @temp_writer_account.expires_at = 24.hours.from_now
    @temp_writer_account.created_by = session[:admin_display_name].presence || "admin"

    if @temp_writer_account.save
      flash[:generated_writer_credentials] = {
        username: @temp_writer_account.username,
        email: @temp_writer_account.email,
        password: generated_password,
        expires_at: @temp_writer_account.expires_at
      }
      redirect_to admin_temp_writer_accounts_path, notice: "Temporary writer account created. It expires in 24 hours."
    else
      @active_accounts = TempWriterAccount.active.order(expires_at: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    temp_writer_account = TempWriterAccount.find(params[:id])
    temp_writer_account.destroy

    redirect_to admin_temp_writer_accounts_path, notice: "Temporary writer account removed."
  end

  private

  def temp_writer_account_params
    params.require(:temp_writer_account).permit(:username, :email)
  end
end
