class ProjectsController < ActionController::Base
	def new
		if session[:auth_token]
			@project = Project.new
			@project_attachment = ProjectAttachment.new
		else
			redirect_to root_url
		end
	end

	def create
		@project = Project.new(
			:caption => params[:project][:caption],
			:description => params[:project][:description],
			:title => params[:project][:title])
		if @project.save
			project_attachment = ProjectAttachment.create(params[:project][:project_attachments])
			@project.project_attachments << project_attachment
			Tag.create_tags(@project, params)
			redirect_to project_path(@project)
		else
			render :new
		end
	end

	def index
		@projects = Project.all
	end

	def show
		if Project.exists?(params[:id])
			@project = Project.find(params[:id])
		else
			redirect_to root_url 
		end
	end

	def edit
		@project = Project.find(params[:id]) if Project.exists?(params[:id])
		if session[:auth_token]
			render :edit
		else
			redirect_to projects_path
		end
	end

	def update
		@project = Project.find(params[:id]) if Project.exists?(params[:id])
		if @project.update_attributes(params[:project])
			redirect_to project_path(@project)
		else
			render :edit
		end
	end

	def destroy
		Project.destroy(params[:id])
		redirect_to projects_path
	end
end