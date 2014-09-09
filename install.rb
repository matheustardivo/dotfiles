#!/usr/bin/ruby

require 'pathname'
require 'fileutils'

def dotfile_path(dotfile)
  File.expand_path('~') + "/.#{dotfile.basename}"
end

def dotfile_backup(dotfile)
  FileUtils.mv dotfile_path(dotfile), "#{dotfile_path(dotfile)}_backup_#{Time.now.to_f.to_s.gsub('.', '')}"
end

dotfiles = Pathname.new File.expand_path 'files'
dotfiles.children.each do |dotfile|
  # Verify if the dotfile already exist and if it's already a symlink before continue
  next if File.exist?(dotfile_path(dotfile)) && File.symlink?(dotfile_path(dotfile))

  # Try to move to *dotfile*_backup if dotfile exist but isn't a symlink
  dotfile_backup(dotfile) if File.exist?(dotfile_path(dotfile))

  # Symlink the dotfile to ~/.dotfile
  File.symlink dotfile.to_s, dotfile_path(dotfile)
end
